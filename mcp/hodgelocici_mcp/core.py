"""Core logic of the HodgeLociCI MCP server: input validation, the Macaulay2 subprocess, result parsing.

Written by an AI agent (November 2026); not reviewed by a human. Everything the tools return is a computation to be
checked; see the README of the repository for what is exact, what is computed modulo a prime, what is proved only in
AI-written notes and what is only computed.

Security model
--------------
* Macaulay2 is started with ``subprocess.Popen`` and an argument list (never ``shell=True``), in a fresh temporary
  working directory, in its own process group, with a wall-clock timeout (the whole group is killed when it expires),
  an address-space cap (``RLIMIT_AS``) and a CPU-time cap (``RLIMIT_CPU``).
* No string from the caller reaches Macaulay2 unless it has passed a strict validator: integers are range-checked and
  re-formatted by Python; rational numbers must match ``-?[0-9]+(/[0-9]+)?``; polynomials must be a sequence of the
  tokens ``<digits>``, ``x_<digits>`` (index range-checked), ``z`` (Fermat tool only), ``+ - * / ^ ( )`` and spaces,
  with balanced parentheses and a length cap. Such a string cannot name any Macaulay2 function, so evaluating it
  with ``value`` can only do ring arithmetic.
"""
from __future__ import annotations

import json
import os
import re
import resource
import shutil
import signal
import subprocess
import sys
import tempfile
import uuid
from fractions import Fraction
from pathlib import Path
from typing import Any

DISCLAIMER = "AI-generated, not reviewed by a human mathematician."

DEFAULT_TIMEOUT_S = 300
DEFAULT_MEM_MB = 4096
MAX_TIMEOUT_S = 3600
F4_PRIME_LIMIT = 32768        # Macaulay2's fast Groebner engine (F4) is used only for primes below this
MAX_POLY_LEN = 20000
MAX_TOTAL_POLY_LEN = 200000


class InputError(ValueError):
    """The caller's input is invalid; the message says why."""


class ComputationError(RuntimeError):
    """Macaulay2 failed, timed out, or hit the memory cap; the message says which."""


# ------------------------------------------------------------------------------------------------ configuration
def repo_root() -> Path:
    """The HodgeLociCI repository root: $HODGELOCICI_ROOT, else the first ancestor of this file or of the working
    directory that contains M2/HodgeLociCI.m2."""
    env = os.environ.get("HODGELOCICI_ROOT")
    if env:
        p = Path(env).expanduser().resolve()
        if not (p / "M2" / "HodgeLociCI.m2").is_file():
            raise ComputationError(f"HODGELOCICI_ROOT={env} does not contain M2/HodgeLociCI.m2")
        return p
    for start in (Path(__file__).resolve().parent, Path.cwd().resolve()):
        for p in (start, *start.parents):
            if (p / "M2" / "HodgeLociCI.m2").is_file():
                return p
    raise ComputationError("cannot find the HodgeLociCI repository: set HODGELOCICI_ROOT to the directory that "
                           "contains M2/HodgeLociCI.m2")


def m2_binary() -> str:
    m2 = os.environ.get("HODGELOCICI_M2", "M2")
    found = shutil.which(m2)
    if not found:
        raise ComputationError(f"Macaulay2 executable '{m2}' not found; install Macaulay2 (tested with 1.22) or set "
                               "HODGELOCICI_M2 to its path")
    return found


def _env_int(name: str, default: int, lo: int, hi: int) -> int:
    raw = os.environ.get(name)
    if raw is None or raw == "":
        return default
    try:
        v = int(raw)
    except ValueError:
        raise ComputationError(f"{name} must be an integer, got {raw!r}") from None
    if not lo <= v <= hi:
        raise ComputationError(f"{name} must be between {lo} and {hi}, got {v}")
    return v


def default_timeout() -> int:
    return _env_int("HODGELOCICI_TIMEOUT", DEFAULT_TIMEOUT_S, 1, MAX_TIMEOUT_S)


def mem_limit_mb() -> int:
    return _env_int("HODGELOCICI_MEM_MB", DEFAULT_MEM_MB, 256, 1 << 20)


def output_dir() -> Path:
    env = os.environ.get("HODGELOCICI_OUTPUT_DIR")
    p = Path(env).expanduser() if env else Path(tempfile.gettempdir()) / "hodgelocici-mcp"
    p.mkdir(parents=True, exist_ok=True)
    return p.resolve()


# ------------------------------------------------------------------------------------------------ validators
_RAT_RE = re.compile(r"^-?[0-9]{1,30}(/[0-9]{1,30})?$")
_TOKEN_RE = re.compile(r"\s*(x_([0-9]{1,3})|z|[0-9]{1,40}|[-+*/^()])")


def check_int(name: str, v: Any, lo: int, hi: int) -> int:
    if isinstance(v, bool) or not isinstance(v, int):
        raise InputError(f"{name} must be an integer, got {v!r}")
    if not lo <= v <= hi:
        raise InputError(f"{name} must be between {lo} and {hi}, got {v}")
    return v


def check_int_list(name: str, v: Any, lo: int, hi: int, min_len: int, max_len: int) -> list[int]:
    if not isinstance(v, (list, tuple)):
        raise InputError(f"{name} must be a list of integers, got {v!r}")
    if not min_len <= len(v) <= max_len:
        raise InputError(f"{name} must have between {min_len} and {max_len} entries, got {len(v)}")
    return [check_int(f"{name}[{i}]", a, lo, hi) for i, a in enumerate(v)]


def check_rational(name: str, v: Any, nonzero: bool = False) -> str:
    """An integer or a string 'a' / 'a/b'; returned as a Macaulay2 literal."""
    if isinstance(v, bool):
        raise InputError(f"{name} must be an integer or a string like '5/3', got {v!r}")
    if isinstance(v, int):
        s = str(v)
    elif isinstance(v, str) and _RAT_RE.match(v.strip()):
        s = v.strip()
    else:
        raise InputError(f"{name} must be an integer or a string like '5/3' (digits only), got {v!r}")
    q = Fraction(s)  # raises ZeroDivisionError for a/0
    if nonzero and q == 0:
        raise InputError(f"{name} must be nonzero")
    return str(q.numerator) if q.denominator == 1 else f"{q.numerator}/{q.denominator}"


def is_prime(p: int) -> bool:
    if p < 2:
        return False
    i = 2
    while i * i <= p:
        if p % i == 0:
            return False
        i += 1
    return True


def check_field(field: Any) -> int:
    """'QQ' -> 0; a prime 2 < p < 32768 (int or digit string) -> p."""
    if isinstance(field, str) and field.strip().upper() == "QQ":
        return 0
    if isinstance(field, str) and field.strip().isdigit():
        field = int(field.strip())
    if isinstance(field, bool) or not isinstance(field, int):
        raise InputError(f"field must be 'QQ' or a prime number, got {field!r}")
    if not (2 < field < F4_PRIME_LIMIT and is_prime(field)):
        raise InputError(f"field must be 'QQ' or a prime p with 2 < p < {F4_PRIME_LIMIT} (Macaulay2's F4 engine is "
                         f"used only below {F4_PRIME_LIMIT}); got {field}")
    return field


def check_poly(name: str, s: Any, nvars: int, allow_z: bool = False) -> str:
    """Validate a polynomial string over the variables x_0..x_(nvars-1) (and z if allow_z)."""
    if not isinstance(s, str):
        raise InputError(f"{name} must be a polynomial given as a string, got {s!r}")
    if not s.strip():
        raise InputError(f"{name} is empty")
    if len(s) > MAX_POLY_LEN:
        raise InputError(f"{name} is longer than {MAX_POLY_LEN} characters")
    pos, depth, out = 0, 0, []
    while pos < len(s):
        if s[pos:].strip() == "":
            break
        m = _TOKEN_RE.match(s, pos)
        if not m:
            raise InputError(f"{name}: unexpected character {s[pos:].lstrip()[:1]!r} at position {pos}; allowed: "
                             f"integers, x_0..x_{nvars - 1}{', z' if allow_z else ''}, + - * / ^ ( ) and spaces")
        tok = m.group(1)
        if tok.startswith("x_"):
            idx = int(m.group(2))
            if idx >= nvars:
                raise InputError(f"{name}: variable {tok} out of range (the ring has x_0..x_{nvars - 1})")
        elif tok == "z" and not allow_z:
            raise InputError(f"{name}: the symbol z is only allowed in the Fermat tool")
        elif tok == "(":
            depth += 1
        elif tok == ")":
            depth -= 1
            if depth < 0:
                raise InputError(f"{name}: unbalanced parentheses")
        out.append(tok)
        pos = m.end()
    if depth != 0:
        raise InputError(f"{name}: unbalanced parentheses")
    # a number or variable directly followed by another number/variable/parenthesis would be implicit
    # multiplication, which Macaulay2 parses differently (function application); refuse it
    for a, b in zip(out, out[1:]):
        if (a[0].isdigit() or a.startswith("x_") or a in ("z", ")")) and (b[0].isdigit() or b.startswith("x_")
                                                                          or b in ("z", "(")):
            raise InputError(f"{name}: write products with '*' (found {a!r} followed by {b!r})")
    return " ".join(out)


def check_poly_list(name: str, v: Any, nvars: int, min_len: int, max_len: int) -> list[str]:
    if not isinstance(v, (list, tuple)):
        raise InputError(f"{name} must be a list of polynomial strings, got {v!r}")
    if not min_len <= len(v) <= max_len:
        raise InputError(f"{name} must have between {min_len} and {max_len} entries, got {len(v)}")
    return [check_poly(f"{name}[{i}]", a, nvars) for i, a in enumerate(v)]


def m2_list(items: list[str]) -> str:
    return "{" + ", ".join(items) + "}"


def m2_str(s: str) -> str:
    # only called on validated strings (no quotes, no backslashes) and on paths checked below
    if '"' in s or "\\" in s or "\n" in s:
        raise InputError("internal: refusing to quote a string with quotes, backslashes or newlines")
    return '"' + s + '"'


def _safe_path(p: Path) -> str:
    s = str(p)
    if not re.match(r"^[A-Za-z0-9_./ +-]+$", s):
        raise ComputationError(f"path {s!r} contains characters that are not passed to Macaulay2; set "
                               "HODGELOCICI_ROOT / HODGELOCICI_OUTPUT_DIR to a plain path")
    return m2_str(s)


# ------------------------------------------------------------------------------------------------ running M2
PREAMBLE = """-- generated by hodgelocici_mcp; every value below was validated by the Python side
needsPackage("HodgeLociCI", FileName => {pkg});
hlciOut = (k, v) -> print("HLCI|" | k | "|" | replace("\\n", " ", toString v));
"""


def _limits(mem_mb: int, cpu_s: int):
    def apply() -> None:
        b = mem_mb * 1024 * 1024
        resource.setrlimit(resource.RLIMIT_AS, (b, b))
        resource.setrlimit(resource.RLIMIT_CPU, (cpu_s, cpu_s + 5))
        resource.setrlimit(resource.RLIMIT_CORE, (0, 0))
    return apply


def run_m2(body: str, timeout: int | None = None) -> dict[str, str]:
    """Run the generated script `body` (after the preamble) and return the HLCI key/value lines."""
    t = default_timeout() if timeout is None else check_int("timeout_seconds", timeout, 1, MAX_TIMEOUT_S)
    mem = mem_limit_mb()
    root = repo_root()
    m2 = m2_binary()
    script = PREAMBLE.format(pkg=_safe_path(root / "M2" / "HodgeLociCI.m2")) + body + "\n"
    with tempfile.TemporaryDirectory(prefix="hlci-m2-") as wd:
        path = os.path.join(wd, "job.m2")
        with open(path, "w") as fh:
            fh.write(script)
        proc = subprocess.Popen([m2, "--script", path], cwd=wd, stdin=subprocess.DEVNULL, stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE, text=True, start_new_session=True,
                                preexec_fn=_limits(mem, t + 10),
                                env={**os.environ, "HOME": wd})
        try:
            out, err = proc.communicate(timeout=t)
        except subprocess.TimeoutExpired:
            try:
                os.killpg(proc.pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
            proc.communicate()
            raise ComputationError(f"Macaulay2 did not finish within {t} s (timeout; raise timeout_seconds or "
                                   "HODGELOCICI_TIMEOUT, or try a smaller case or a prime field)") from None
    res: dict[str, str] = {}
    for line in out.splitlines():
        if line.startswith("HLCI|"):
            _, k, v = line.split("|", 2)
            res[k] = v
    if proc.returncode != 0 or "done" not in res:
        msgs = [ln.split("error:", 1)[1].strip() for ln in err.splitlines() if "error:" in ln]
        if not msgs and ("out of memory" in err.lower() or "GC Warning" in err or proc.returncode in (-9, 137)):
            msgs = [f"Macaulay2 was stopped (probably the memory cap of {mem} MB; set HODGELOCICI_MEM_MB)"]
        if not msgs:
            tail = err.strip().splitlines()[-3:]
            msgs = [f"Macaulay2 exited with status {proc.returncode}: " + " / ".join(tail)]
        raise ComputationError("Macaulay2 reported: " + msgs[0].replace(wd, "<tmp>"))
    return res


def _parse_value(v: str) -> Any:
    if v == "true":
        return True
    if v == "false":
        return False
    if v == "null":
        return None
    if re.fullmatch(r"-?[0-9]+", v):
        return int(v)
    m = re.fullmatch(r"\((-?[0-9]+(?:, ?-?[0-9]+)*)\)", v)
    if m:
        return [int(a) for a in m.group(1).split(",")]
    return v


# ------------------------------------------------------------------------------------------------ tool 1
def excess_formula(degree: int, own_degrees_y1: list[int], own_degrees_y2: list[int], shared_degrees: list[int],
                   timeout_seconds: int | None = None) -> dict[str, Any]:
    d = check_int("degree", degree, 2, 60)
    df = check_int_list("own_degrees_y1", own_degrees_y1, 1, d - 1, 1, 8)
    dh = check_int_list("own_degrees_y2", own_degrees_y2, 1, d - 1, 1, 8)
    dp = check_int_list("shared_degrees", shared_degrees, 1, d - 1, 0, 8)
    if len(df) != len(dh):
        raise InputError(f"the two cycles must have the same number c of own equations; got {len(df)} and {len(dh)}")
    k = len(df) + len(dp) - 1
    if k < 1:
        raise InputError("need k = c + (number of shared equations) - 1 >= 1 (a hypersurface of dimension 2k >= 2)")
    if 2 * k + 2 > 20:
        raise InputError("at most 20 variables (k <= 9)")
    keys = ["k", "c", "tau", "lambda0", "inRange", "eTau", "dimAd", "codimV1", "codimV2", "codimVZ",
            "excessAtLambda0", "codimNLAtLambda0", "excessElsewhere", "excessElsewhereBounds", "levelDichotomy",
            "label"]
    body = (f"r = excessFromDegrees({d}, {m2_list([str(a) for a in df])}, {m2_list([str(a) for a in dh])}, "
            f"{m2_list([str(a) for a in dp])});\n"
            f"scan({m2_list([m2_str(k_) for k_ in keys])}, k -> hlciOut(k, r#k));\n"
            "scan(#(r#\"notes\"), i -> hlciOut(\"note\" | toString i, (r#\"notes\")#i));\n"
            "hlciOut(\"done\", 1);\n")
    r = run_m2(body, timeout_seconds)
    vals = {k_: _parse_value(r[k_]) for k_ in keys}
    tau = vals["tau"]
    elsewhere = vals["excessElsewhere"]
    verdict = ("tau < 0: no excess for any lambda != 0" if tau < 0 else
               "tau >= 0: excess e_tau = %s at lambda_0 = %s; elsewhere %s" % (
                   vals["eTau"], vals["lambda0"],
                   f"{elsewhere} (in the range)" if elsewhere != "NotDetermined"
                   else "not determined by the degrees (outside the range); bounds " + str(vals["excessElsewhereBounds"])
                   + ", use second_order_check / explicit data"))
    return {
        "tool": "excess_formula",
        "status_label": "EXACT (integer arithmetic on the degrees); its reading as the excess of a Hodge locus is "
                        "PROVED in an AI-written, unreviewed note (paper 3, Theorem 2)",
        "package_label": vals["label"],
        "input": {"degree": d, "own_degrees_y1": df, "own_degrees_y2": dh, "shared_degrees": dp,
                  "ambient": f"P^{2 * k + 1}", "hypersurface_dimension": 2 * k},
        "computed_with": "excessFromDegrees (by degrees alone; no explicit instance is built)",
        "tau": tau,
        "lambda0": vals["lambda0"],
        "in_range": vals["inRange"],
        "e_tau": vals["eTau"],
        "excess_at_lambda0": vals["excessAtLambda0"],
        "excess_generic_lambda": elsewhere,
        "excess_generic_lambda_bounds": vals["excessElsewhereBounds"],
        "excess_by_coefficient": {
            "lambda = lambda0": vals["excessAtLambda0"],
            "lambda not in {0, lambda0}": elsewhere,
        },
        "codim_V1": vals["codimV1"], "codim_V2": vals["codimV2"], "codim_VZ": vals["codimVZ"],
        "codim_NL_at_lambda0": vals["codimNLAtLambda0"],
        "dichotomy": vals["levelDichotomy"],
        "verdict": verdict,
        "notes": [r[k_] for k_ in sorted(r) if k_.startswith("note")],
        "disclaimer": DISCLAIMER,
    }


# ------------------------------------------------------------------------------------------------ tool 2
VERDICTS = ["NO EXCESS", "ALL SURVIVE", "ALL DIE", "SOME DIE", "NOT DETERMINED"]


def second_order_check(lam: Any, field: Any = 32003, mode: str = "explicit", nvars: int | None = None,
                       f: list[str] | None = None, h: list[str] | None = None, p: list[str] | None = None,
                       M: list[list[str]] | None = None, s: list[str] | None = None,
                       degree: int | None = None, own_degrees_y1: list[int] | None = None,
                       own_degrees_y2: list[int] | None = None, shared_degrees: list[int] | None = None,
                       seed: int = 7, strategy: str = "Formula",
                       timeout_seconds: int | None = None) -> dict[str, Any]:
    lam_s = check_rational("lambda", lam, nonzero=True)
    pr = check_field(field)
    if strategy not in ("Formula", "Pointwise", "Both"):
        raise InputError("strategy must be 'Formula', 'Pointwise' or 'Both'")
    kk = "QQ" if pr == 0 else f"ZZ/{pr}"
    if mode == "explicit":
        if None in (nvars, f, h, p, M, s):
            raise InputError("mode 'explicit' needs nvars, f, h, p, M and s")
        nv = check_int("nvars", nvars, 4, 14)
        if nv % 2:
            raise InputError("nvars must be even (the ambient space is P^(2k+1))")
        fl = check_poly_list("f", f, nv, 1, 6)
        hl = check_poly_list("h", h, nv, 1, 6)
        pl = check_poly_list("p", p, nv, 0, 6)
        sl = check_poly_list("s", s, nv, 0, 6)
        c = len(fl)
        if len(hl) != c:
            raise InputError(f"f and h must have the same length c; got {c} and {len(hl)}")
        if len(sl) != len(pl):
            raise InputError(f"p and s must have the same length; got {len(pl)} and {len(sl)}")
        if c + len(pl) != nv // 2:
            raise InputError(f"#f + #p must equal k+1 = nvars/2 = {nv // 2}; got {c + len(pl)}")
        if not isinstance(M, (list, tuple)) or len(M) != c or not all(isinstance(row, (list, tuple)) and len(row) == c
                                                                       for row in M):
            raise InputError(f"M must be a {c} x {c} matrix given as a list of rows of polynomial strings")
        Ml = [[check_poly(f"M[{i}][{j}]", e, nv) for j, e in enumerate(row)] for i, row in enumerate(M)]
        total = sum(len(x) for x in fl + hl + pl + sl + [e for row in Ml for e in row])
        if total > MAX_TOTAL_POLY_LEN:
            raise InputError(f"the polynomial data are longer than {MAX_TOTAL_POLY_LEN} characters in total")
        q = lambda xs: m2_list([m2_str(x) for x in xs])  # noqa: E731
        build = (f"S = {kk}[x_0..x_{nv - 1}];\n"
                 "hlciP = t -> (v := value t; if instance(v, ZZ) or instance(v, QQ) then promote(v, S) else v);\n"
                 f"D = cyclePair(apply({q(fl)}, hlciP), apply({q(hl)}, hlciP), apply({q(pl)}, hlciP), "
                 f"matrix(S, apply({m2_list([q(row) for row in Ml])}, r -> apply(r, hlciP))), "
                 f"apply({q(sl)}, hlciP));\n")
        inp = {"mode": "explicit", "nvars": nv, "f": fl, "h": hl, "p": pl, "M": Ml, "s": sl}
    elif mode == "random":
        if None in (degree, own_degrees_y1, own_degrees_y2, shared_degrees):
            raise InputError("mode 'random' needs degree, own_degrees_y1, own_degrees_y2 and shared_degrees")
        d = check_int("degree", degree, 2, 12)
        df = check_int_list("own_degrees_y1", own_degrees_y1, 1, d - 1, 1, 6)
        dh = check_int_list("own_degrees_y2", own_degrees_y2, 1, d - 1, 1, 6)
        dp = check_int_list("shared_degrees", shared_degrees, 1, d - 1, 0, 6)
        if len(df) != len(dh):
            raise InputError("the two cycles must have the same number c of own equations")
        if not 4 <= 2 * (len(df) + len(dp)) <= 14:
            raise InputError("need 2 <= #own + #shared <= 7 (between 4 and 14 variables)")
        sd = check_int("seed", seed, 0, 2**31 - 1)
        build = (f"D = randomCyclePair({d}, {m2_list([str(a) for a in df])}, {m2_list([str(a) for a in dh])}, "
                 f"{m2_list([str(a) for a in dp])}, Seed => {sd}, CoefficientRing => {kk});\n")
        inp = {"mode": "random", "degree": d, "own_degrees_y1": df, "own_degrees_y2": dh, "shared_degrees": dp,
               "seed": sd}
    else:
        raise InputError("mode must be 'explicit' or 'random'")
    keys = ["verdict", "statement", "label", "lambda", "lambda0", "tau", "inRange", "conditionS", "eTau", "excess",
            "dimK", "rankOfQuadrics", "commonZeroLocusDim", "strategiesAgree", "arithmetic"]
    body = (build +
            f"r = secondOrderObstruction(D, {lam_s}, Strategy => {m2_str(strategy)});\n"
            f"scan({m2_list([m2_str(k_) for k_ in keys])}, k -> if r#?k then hlciOut(k, r#k));\n"
            "hlciOut(\"degree\", D#\"degree\"); hlciOut(\"F\", D#\"F\");\n"
            "hlciOut(\"done\", 1);\n")
    r = run_m2(body, timeout_seconds)
    vals = {k_: _parse_value(r[k_]) for k_ in keys if k_ in r}
    arith = "EXACT" if pr == 0 else "MOD p"
    status = (f"{arith} (" + ("over QQ" if pr == 0 else f"over ZZ/{pr} at this one instance: evidence, not a proof")
              + "); the second-order formulas are PROVED in an AI-written, unreviewed note (paper 3)")
    if inp["mode"] == "random":
        inp["field"] = kk
    return {
        "tool": "second_order_check",
        "status_label": status,
        "package_label": vals.get("label"),
        "input": {**inp, "lambda": lam_s, "field": kk, "strategy": strategy},
        "hypersurface_F": r.get("F"),
        "degree": _parse_value(r.get("degree", "")),
        "verdict": vals.get("verdict"),
        "statement": vals.get("statement"),
        "lambda0": vals.get("lambda0"),
        "tau": vals.get("tau"),
        "in_range": vals.get("inRange"),
        "condition_S": vals.get("conditionS"),
        "e_tau": vals.get("eTau"),
        "excess": vals.get("excess"),
        "dim_K": vals.get("dimK"),
        "rank_of_quadrics": vals.get("rankOfQuadrics"),
        "common_zero_locus_dim": vals.get("commonZeroLocusDim"),
        "strategies_agree": vals.get("strategiesAgree"),
        "verdict_vocabulary": VERDICTS,
        "disclaimer": DISCLAIMER,
    }


# ------------------------------------------------------------------------------------------------ tool 3
def fermat_expansion(degree: int, dimension: int, spaces: list[list[list[int]]], coefficients: list[Any],
                     order: int, prime: int = 0, t1: str = "auto",
                     timeout_seconds: int | None = None) -> dict[str, Any]:
    d = check_int("degree", degree, 3, 6)
    n = check_int("dimension", dimension, 2, 8)
    if n % 2:
        raise InputError("dimension must be even")
    nv = n + 2
    N = check_int("order", order, 1, 12)
    pr = check_int("prime", prime, 0, F4_PRIME_LIMIT - 1)
    if pr != 0 and not (is_prime(pr) and pr % (2 * d) == 1):
        raise InputError(f"prime must be 0 (exact over QQ(zeta_{2 * d})) or a prime p < {F4_PRIME_LIMIT} with "
                         f"p = 1 mod {2 * d}; got {pr}")
    if not isinstance(spaces, (list, tuple)) or not 1 <= len(spaces) <= 4:
        raise InputError("spaces must be a list of 1 to 4 linear spaces")
    sp_m2 = []
    for i, L in enumerate(spaces):
        if not isinstance(L, (list, tuple)) or len(L) != nv // 2:
            raise InputError(f"spaces[{i}] must be a list of {nv // 2} triples [a, b, e] (x_a = z^e x_b)")
        trip = []
        used: set[int] = set()
        for j, t in enumerate(L):
            a, b, e = check_int_list(f"spaces[{i}][{j}]", t, -4 * d, 4 * d, 3, 3)
            check_int(f"spaces[{i}][{j}][0]", a, 0, nv - 1)
            check_int(f"spaces[{i}][{j}][1]", b, 0, nv - 1)
            if e % 2 == 0:
                raise InputError(f"spaces[{i}][{j}]: the exponent e must be odd")
            if a in used or b in used or a == b:
                raise InputError(f"spaces[{i}]: the pairs (a, b) must form a perfect matching of 0..{nv - 1}")
            used |= {a, b}
            trip.append(f"{{{a},{b},{e}}}")
        sp_m2.append(m2_list(trip))
    if not isinstance(coefficients, (list, tuple)) or len(coefficients) != len(spaces):
        raise InputError("coefficients must be a list with one entry per linear space")
    cs = [check_rational(f"coefficients[{i}]", c) for i, c in enumerate(coefficients)]
    if all(Fraction(c) == 0 for c in cs):
        raise InputError("at least one coefficient must be nonzero")
    if t1 == "auto":
        if len(spaces) < 2:
            raise InputError("t1='auto' needs at least two linear spaces; give t1 explicitly")
        t1_m2 = ("B = fermatHodgeTangent P; LP1 = fermatFirstOrderMatrix fermatPeriodPolynomial(S, spaces#0);\n"
                 "sqf = fermatDeformationMonomials S;\n"
                 "cand = select(flatten entries B, t -> LP1 * transpose matrix {apply(sqf, a -> coefficient(a, t))} != 0);\n"
                 "if #cand == 0 then error \"no tangent direction of the Hodge locus leaves the locus of the first space "
                 "(no excess direction at Fermat): give t1 explicitly\";\n"
                 "T1 = first cand;\n")
        t1_desc = ("auto: the first basis element of the tangent space of the Hodge locus (fermatHodgeTangent) that is "
                   "not tangent to the locus where the first space persists")
    else:
        t1v = check_poly("t1", t1, nv, allow_z=True)
        t1_m2 = f"T1 = hlciP {m2_str(t1v)};\n"
        t1_desc = t1v
    out_dir = output_dir()
    cert = out_dir / f"fermat_d{d}_n{n}_{'exact' if pr == 0 else 'p' + str(pr)}_{uuid.uuid4().hex[:12]}.txt"
    ring = f"fermatRing({d}, {n})" if pr == 0 else f"fermatRing({d}, {n}, {pr})"
    body = (f"S = {ring}; z = fermatRoot S; K = coefficientRing S;\n"
            "hlciP = t -> (v := value t; if instance(v, ZZ) or instance(v, QQ) then promote(v, S) "
            "else if ring v =!= S then promote(v, S) else v);\n"
            f"spaces = {m2_list(sp_m2)};\n"
            f"cs = {m2_list(cs)};\n"
            "P = sum(#spaces, i -> promote(cs#i, K) * fermatPeriodPolynomial(S, spaces#i));\n"
            + t1_m2 +
            f"H = fermatExtendArc(P, {{T1}}, {N});\n"
            "hlciOut(\"label\", H#\"label\"); hlciOut(\"order\", H#\"order\");\n"
            "hlciOut(\"obstructedAtOrder\", H#\"obstructedAtOrder\");\n"
            "hlciOut(\"obstruction\", if H#\"obstruction\" === null then null else toString H#\"obstruction\");\n"
            "hlciOut(\"T1\", T1);\n"
            f"file = {_safe_path(cert)};\n"
            "fermatWriteCertificate(file, hashTable {\"ring\" => S, \"spaces\" => spaces, \"coefficients\" => cs, "
            "\"arc\" => H#\"arc\"});\n"
            "V = fermatVerifyCertificate file;\n"
            "hlciOut(\"verifyPass\", V#\"pass\"); hlciOut(\"verifyVanishingOrder\", V#\"vanishingOrder\");\n"
            "hlciOut(\"verifyLabel\", V#\"label\");\n"
            "scan(#(V#\"checks\"), i -> hlciOut(\"check\" | toString(1000 + i), toString((V#\"checks\")#i#0) | \" => \" | toString((V#\"checks\")#i#1)));\n"
            "hlciOut(\"done\", 1);\n")
    r = run_m2(body, timeout_seconds)
    obs_at = _parse_value(r["obstructedAtOrder"])
    order_reached = _parse_value(r["order"])
    obs = r.get("obstruction")
    summary = (f"the arc was extended to order {order_reached}; it is obstructed at order {obs_at} "
               f"(obstruction K.c_{obs_at} = {obs})" if obs_at is not None else
               f"the arc was extended to order {order_reached} = the requested order; no obstruction found up to there")
    return {
        "tool": "fermat_expansion",
        "status_label": r["label"],
        "package_label": r["label"],
        "input": {"degree": d, "dimension": n, "prime": pr, "spaces": [list(map(list, L)) for L in spaces],
                  "coefficients": cs, "order": N, "t1": t1_desc},
        "field": f"QQ(zeta_{2 * d}) (EXACT)" if pr == 0 else f"ZZ/{pr} (MOD p)",
        "T1": r.get("T1"),
        "order_reached": order_reached,
        "obstructed_at_order": obs_at,
        "obstruction": None if obs in (None, "null") else obs,
        "summary": summary,
        "certificate_file": str(cert),
        "certificate_contents": "the arc T_1..T_%s and the claim that the expansion vanishes to that order (claim 1); "
                                "an obstruction, if any, is reported here but not written to the file" % order_reached,
        "certificate_verified": _parse_value(r["verifyPass"]),
        "certificate_vanishing_order": _parse_value(r["verifyVanishingOrder"]),
        "certificate_checks": [r[k_] for k_ in sorted(r) if k_.startswith("check")],
        "caveat": "an obstruction found here is an obstruction for the particular arc constructed (deterministic "
                  "particular solutions at each order), not for every arc with the same first term; 'an arc exists to "
                  "order N' says nothing about the Hodge locus beyond order N",
        "disclaimer": DISCLAIMER,
    }


# ------------------------------------------------------------------------------------------------ tool 4
STATUS_LABELS = {
    "EXACT": "EXACT",
    "MOD_P": "MOD p",
    "PROVED_AI_UNREVIEWED": "PROVED (AI-written, unreviewed)",
    "COMPUTED_ONLY": "COMPUTED ONLY",
    "PAPER_ARGUMENT_AI": "PAPER ARGUMENT (AI, read at most once by another AI agent)",
    "CONJECTURE": "CONJECTURE",
    "RULED_OUT": "RULED OUT",
    "OPEN": "OPEN",
    "STUCK": "STUCK",
}
KINDS = ["result", "negative", "dead_end", "correction", "open"]

_REGISTRY_CACHE: dict[str, Any] = {}


def load_registry() -> list[dict[str, Any]]:
    root = repo_root()
    reg = root / "discoveries" / "registry.yaml"
    checker = root / "discoveries" / "check_registry.py"
    mtime = reg.stat().st_mtime
    if _REGISTRY_CACHE.get("mtime") == mtime:
        return _REGISTRY_CACHE["entries"]
    r = subprocess.run([sys.executable, "-I", str(checker), "--json"], capture_output=True, text=True, timeout=60,
                       cwd=str(root), stdin=subprocess.DEVNULL)
    if r.returncode != 0:
        raise ComputationError("discoveries/check_registry.py --json failed: " + r.stderr.strip()[-300:])
    entries = json.loads(r.stdout)
    _REGISTRY_CACHE.update(mtime=mtime, entries=entries)
    return entries


def registry_search(query: str = "", kind: str | None = None, status: str | None = None, area: str | None = None,
                    limit: int = 20) -> dict[str, Any]:
    if not isinstance(query, str) or len(query) > 500:
        raise InputError("query must be a string of at most 500 characters")
    lim = check_int("limit", limit, 1, 200)
    if kind is not None and kind not in KINDS:
        raise InputError(f"kind must be one of {KINDS}")
    st = None
    if status is not None:
        st = status.strip().upper().replace(" ", "_")
        if st == "MOD_P" or st == "MODP":
            st = "MOD_P"
        if st not in STATUS_LABELS:
            raise InputError(f"status must be one of {list(STATUS_LABELS)}")
    entries = load_registry()
    words = [w.lower() for w in query.split()]
    hits = []
    for e in entries:
        if kind and e.get("kind") != kind:
            continue
        if st and e.get("status") != st:
            continue
        if area and e.get("area") != area:
            continue
        hay = " ".join(str(e.get(k, "")) for k in ("id", "title", "statement", "data", "area", "kind")).lower()
        if all(w in hay for w in words):
            stmt = " ".join(str(e.get("statement", "")).split())
            hits.append({
                "id": e["id"], "kind": e.get("kind"), "area": e.get("area"), "title": e.get("title"),
                "status": e.get("status"), "status_label": STATUS_LABELS.get(e.get("status"), e.get("status")),
                "statement_excerpt": stmt[:400] + ("..." if len(stmt) > 400 else ""),
            })
    return {
        "tool": "registry_search",
        "status_label": "per entry (field status_label); the registry is AI-produced and checked only by AI agents",
        "query": query, "filters": {"kind": kind, "status": st, "area": area},
        "total_entries": len(entries), "matches": len(hits), "returned": min(len(hits), lim),
        "entries": hits[:lim],
        "source": "discoveries/registry.yaml (full text: python3 discoveries/check_registry.py --json)",
        "disclaimer": DISCLAIMER,
    }
