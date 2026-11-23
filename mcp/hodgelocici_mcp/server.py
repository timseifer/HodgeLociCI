"""MCP server exposing four tools of the HodgeLociCI Macaulay2 package.

Uses the official MCP Python SDK (package `mcp`, version 2.x, class `mcp.server.mcpserver.MCPServer`).
Run with `python -m hodgelocici_mcp` (stdio transport). Written by an AI agent; not reviewed by a human.
"""
from __future__ import annotations

from typing import Any, Literal

from mcp.server.mcpserver import MCPServer
from mcp.server.mcpserver.exceptions import ToolError

from . import __version__, core

INSTRUCTIONS = (
    "Tools of the HodgeLociCI Macaulay2 package (Hodge loci of r[Y1] + s[Y2] for two linear or complete-intersection "
    "cycles in a smooth even-dimensional hypersurface). Every output carries a status label (EXACT / MOD p / PROVED "
    "in an AI-written unreviewed note / COMPUTED ONLY): quote it with any number you report. Everything here is "
    "AI-generated and not reviewed by a human mathematician; never present an output as a proved theorem or as "
    "evidence about the Hodge conjecture. Search the registry (registry_search) before starting new work."
)

server = MCPServer(name="hodgelocici", version=__version__, instructions=INSTRUCTIONS)


def _call(fn, *args, **kwargs) -> dict[str, Any]:
    try:
        return fn(*args, **kwargs)
    except (core.InputError, core.ComputationError, ZeroDivisionError) as exc:
        raise ToolError(f"{type(exc).__name__}: {exc}. {core.DISCLAIMER}") from exc


@server.tool(
    description=(
        "First-order excess calculator BY DEGREES (HodgeLociCI excessFromDegrees). Setting: a smooth hypersurface X of "
        "degree d in P^(2k+1); two cycles Y1 = V(f, p), Y2 = V(h, p) of dimension k with c own equations each (f, h) "
        "and k+1-c shared equations p; all degrees >= 1 and < d. Returns the level tau = d - deg det M, the special "
        "coefficient lambda_0 = (-1)^(c-1), e_tau, the range flag, the excess at lambda_0 and for generic lambda "
        "(or NotDetermined outside the range, with bounds), the codimensions of V1, V2, V_Z and of the Hodge locus at "
        "lambda_0, and the level-dichotomy verdict. Example: cubic sixfold with two 3-planes meeting in a point: "
        "degree=3, own_degrees_y1=[1,1,1], own_degrees_y2=[1,1,1], shared_degrees=[1] gives codim V_Z = 8, codim NL "
        "at lambda_0 = 7, lambda_0 = 1. Status: EXACT integer arithmetic; its interpretation is a theorem of an "
        "AI-written, unreviewed note."
    ),
)
def excess_formula(degree: int, own_degrees_y1: list[int], own_degrees_y2: list[int],
                   shared_degrees: list[int], timeout_seconds: int | None = None) -> dict[str, Any]:
    """degree: d of the hypersurface; own_degrees_y1 / own_degrees_y2: degrees of the c own equations of each cycle;
    shared_degrees: degrees of the k+1-c shared equations (may be empty); timeout_seconds: optional override."""
    return _call(core.excess_formula, degree, own_degrees_y1, own_degrees_y2, shared_degrees, timeout_seconds)


@server.tool(
    description=(
        "Second-order obstruction check on the excess directions (HodgeLociCI secondOrderObstruction, version 0.1.1 "
        "semantics) at one coefficient lambda. Verdicts: NO EXCESS, ALL SURVIVE, ALL DIE, SOME DIE, NOT DETERMINED "
        "(outside the range when condition (S) fails and the computed part vanishes; NOT 'no obstruction'). "
        "mode='explicit': give nvars = 2k+2 and polynomial strings in x_0..x_(nvars-1) for f, h (c each), p, s (same "
        "length) and the c x c matrix M (list of rows), with F = f^T M h + sum p_l s_l; only integers, x_i, + - * / ^ "
        "( ) are accepted (write products with *). mode='random': give degree, own_degrees_y1, own_degrees_y2, "
        "shared_degrees and seed; a random instance is built (randomCyclePair). field: 'QQ' (EXACT, can be slow) or a "
        "prime 2 < p < 32768 (MOD p: evidence at one instance, not a proof). lam (the coefficient lambda): nonzero integer or 'a/b'. "
        "Example: mode='random', degree=3, [1,1,1], [1,1,1], [1], seed=7, field=32003: lam=2 gives ALL DIE, "
        "lam=1 gives ALL SURVIVE."
    ),
)
def second_order_check(lam: int | str, field: int | str = 32003,
                       mode: Literal["explicit", "random"] = "explicit", nvars: int | None = None,
                       f: list[str] | None = None, h: list[str] | None = None, p: list[str] | None = None,
                       M: list[list[str]] | None = None, s: list[str] | None = None, degree: int | None = None,
                       own_degrees_y1: list[int] | None = None, own_degrees_y2: list[int] | None = None,
                       shared_degrees: list[int] | None = None, seed: int = 7,
                       strategy: Literal["Formula", "Pointwise", "Both"] = "Formula",
                       timeout_seconds: int | None = None) -> dict[str, Any]:
    """lam: the coefficient lambda in [Y1] + lambda [Y2] (nonzero integer or 'a/b')."""
    return _call(core.second_order_check, lam, field, mode, nvars, f, h, p, M, s, degree, own_degrees_y1,
                 own_degrees_y2, shared_degrees, seed, strategy, timeout_seconds)


@server.tool(
    description=(
        "Higher-order expansion of the Hodge locus at the Fermat hypersurface x_0^d + ... + x_(n+1)^d (HodgeLociCI "
        "fermatExtendArc, fermatWriteCertificate, fermatVerifyCertificate). Linear spaces are given as lists of "
        "triples [a, b, e] meaning x_a = z^e x_b, z a primitive 2d-th root of unity, e odd, the pairs (a, b) a perfect "
        "matching of 0..n+1. The class is sum coefficients[i] * [space i]. Starting from T_1 (a polynomial string in "
        "x_i and z, or 'auto'), the arc F0 - (eps T_1 + eps^2 T_2 + ...) is extended order by order up to `order` or "
        "to the first obstruction; the arc is written as a certificate file (under $HODGELOCICI_OUTPUT_DIR or a "
        "temporary directory) and re-verified from the file. prime=0: EXACT over QQ(zeta_2d); otherwise a prime "
        "p = 1 mod 2d below 32768 (MOD p). Status: COMPUTED ONLY. Example: degree=3, dimension=6, spaces "
        "[[[0,1,1],[2,3,1],[4,5,1],[6,7,1]], [[0,1,3],[2,3,3],[4,5,3],[6,7,1]]], coefficients [1, 2], order 6, "
        "t1='x_0*x_1*x_7 + (1/3+(1/3)*z)*x_0*x_2*x_4 + x_0*x_2*x_5 + x_2*x_3*x_7 + x_4*x_5*x_7' reaches order 4 "
        "and is obstructed at order 5."
    ),
)
def fermat_expansion(degree: int, dimension: int, spaces: list[list[list[int]]], coefficients: list[int | str],
                     order: int, prime: int = 0, t1: str = "auto",
                     timeout_seconds: int | None = None) -> dict[str, Any]:
    """degree: d (3..6); dimension: even n (2..8); order: target order N (1..12)."""
    return _call(core.fermat_expansion, degree, dimension, spaces, coefficients, order, prime, t1, timeout_seconds)


@server.tool(
    description=(
        "Search the HodgeLociCI discoveries registry (discoveries/registry.yaml: results, negative results, dead ends, "
        "corrections, open problems) before starting new work. All words of `query` must occur (case-insensitive) in "
        "the id, title, statement or data of an entry. Optional filters: kind (result, negative, dead_end, "
        "correction, open), status (EXACT, MOD_P, PROVED_AI_UNREVIEWED, COMPUTED_ONLY, PAPER_ARGUMENT_AI, CONJECTURE, "
        "RULED_OUT, OPEN, STUCK), area. Returns id, title, kind, status and status label of each match, with an "
        "excerpt of the statement. Pure Python, no Macaulay2."
    ),
)
def registry_search(query: str = "", kind: str | None = None, status: str | None = None, area: str | None = None,
                    limit: int = 20) -> dict[str, Any]:
    return _call(core.registry_search, query, kind, status, area, limit)


def main() -> None:
    server.run("stdio")


if __name__ == "__main__":
    main()
