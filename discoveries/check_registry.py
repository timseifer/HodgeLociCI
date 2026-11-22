#!/usr/bin/env python3
"""Validate discoveries/registry.yaml and (re)generate the human-readable pages 01 to 08.

Written by an AI agent (22 November 2026); not reviewed by a human. Python 3 standard library only.

    python3 discoveries/check_registry.py                 validate; also check that the pages are up to date
    python3 discoveries/check_registry.py --write-pages   validate, then rewrite discoveries/01_*.md .. 08_*.md
    python3 discoveries/check_registry.py --json          print the registry as JSON on standard output
    python3 discoveries/check_registry.py --list          one line per entry: id, kind, status, title

SINGLE SOURCE OF TRUTH: registry.yaml. The pages are generated from it by this script and must not be edited by
hand. The registry is stored in a small subset of YAML and read by the reader below (no external YAML library):
  * a top-level list; an entry starts with "- id: VALUE"; its other fields are indented by two spaces;
  * a value is either a plain scalar on the same line, a double-quoted string on the same line (JSON escapes),
    or a literal block scalar introduced by "|-" whose lines are indented by four spaces;
  * comment lines start with "#" in column 0; blank lines are allowed anywhere.
Exit status: 0 if there is no violation, 1 otherwise.
"""
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
REGISTRY = os.path.join(HERE, "registry.yaml")

KINDS = ["result", "negative", "dead_end", "correction", "open"]
AREAS = ["first_order", "second_order", "fermat_expansion", "movasati_conjecture", "explicit_cycles",
         "fake_linear_cycles", "methods"]
STATUSES = ["EXACT", "MOD_P", "PROVED_AI_UNREVIEWED", "COMPUTED_ONLY", "PAPER_ARGUMENT_AI", "CONJECTURE",
            "RULED_OUT", "OPEN", "STUCK"]
REQUIRED = ["id", "kind", "area", "title", "statement", "status", "conditions", "evidence", "independent_check",
            "not_established", "known_before", "reproduce", "session_refs"]
OPTIONAL = ["data", "do_not_repeat", "next_step"]
FIELD_ORDER = ["id", "kind", "area", "title", "statement", "data", "status", "conditions", "evidence",
               "independent_check", "not_established", "known_before", "reproduce", "do_not_repeat", "next_step",
               "session_refs"]
PREFIX_KINDS = {"D": ["result"], "M": ["result"], "N": ["negative", "dead_end"], "O": ["open"], "C": ["correction"]}
NOT_REPRODUCIBLE = "not reproducible from this repository"
ID_RE = re.compile(r"^[DMNOC]-[A-Z0-9]+(?:-[A-Z0-9]+)*$")
ID_REF_RE = re.compile(r"(?<![A-Za-z0-9-])([DMNOC]-[A-Z0-9]+(?:-[A-Z0-9]+)+)(?![A-Za-z0-9]|-[A-Z0-9])")
PATH_RE = re.compile(r"(?<![A-Za-z0-9_./$-])((?:M2|tests|docs|examples|lean|discoveries)/[A-Za-z0-9_./-]*[A-Za-z0-9_]"
                     r"|(?:README|AGENTS|CHANGELOG)\.md)")

# ------------------------------------------------------------------------------------------------------ pages
# (file name, title, three summary lines, selector). An entry appears in full on exactly one page.
PAGES = [
    ("01_first_order.md", "First order: the rule for tau, lambda_0 and the excess",
     ["From the degrees alone: the level tau, the special coefficient lambda_0 = (-1)^(c-1), the number e_tau, the "
      "codimensions, and the complete list of pairs of linear subspaces with excess directions.",
      "Published first-order numbers (Movasati, Kloosterman, Villaflor Loyola, Maclean) are reproduced; the general "
      "rule is a theorem of an AI-written, unreviewed note.",
      "First-order statements say nothing about the dimension of a Hodge locus away from lambda_0: see page 02."],
     lambda e: e["kind"] == "result" and e["area"] == "first_order"),
    ("02_second_order.md", "Second order: excess directions die away from lambda_0",
     ["Second-order law: the obstruction on the excess directions is ((lambda - lambda_0)/lambda) times a quantity "
      "independent of lambda; where it is nonzero the Hodge locus is V_Z with a non-reduced structure.",
      "Exceptions are listed: rows with no dependent equation (K = 0), one row where only some directions die, and "
      "special points (Fermat) where the second-order term vanishes.",
      "All of it rests on formulas of AI-written, unreviewed notes; instances are computed modulo primes or exactly."],
     lambda e: e["kind"] == "result" and e["area"] == "second_order"),
    ("03_movasati_conjecture_and_fermat.md", "Movasati's Conjecture 1 and higher-order expansions at Fermat points",
     ["Exact certificates at both Movasati points (lambda = -1, 2, 5/3) show, conditionally, that the full germ of "
      "the Hodge locus has no component of dimension dim V + 1 there; this is AI-computed and conditional, and must "
      "not be presented as a refutation of a published conjecture.",
      "Structure of the germ: V doubled plus one component W_lambda on sixfolds; bounds on eightfolds; at the pair X1 "
      "the coefficient -1 is special, with an explicit obstruction formula and a rank invariant separating -1, 1 and "
      "the other coefficients.",
      "Identifications of components with explicit families are paper arguments by AI agents, each read once."],
     lambda e: e["kind"] == "result" and e["area"] in ("movasati_conjecture", "fermat_expansion")),
    ("04_explicit_cycles_on_cubics.md", "Explicit cycles on cubic sixfolds and eightfolds",
     ["Coefficient -1: the second component is (an open piece of) the closure of the cubics det A + det B, which "
      "carry an explicit threefold of degree 9 (8 conditions); coefficient 1: l*Q + Pfaffian with a quintic threefold "
      "(7 conditions); eightfolds: l*Q + det A + det B with a fourfold of degree 9 (26 conditions), and the Segre "
      "fourfold (27 / 26).",
      "The general cubic containing both planes is a limit of sums of two determinants, not a sum; along one path "
      "into it both determinants blow up towards a triple hyperplane.",
      "For other coefficients nothing was found; the matrices along the path and the limit of the threefold were not "
      "recovered. Numbers are modulo primes unless marked exact; identifications are paper chains."],
     lambda e: e["kind"] == "result" and e["area"] == "explicit_cycles"),
    ("05_fake_linear_cycles.md", "Fake linear cycles on quartic sixfolds",
     ["The class 3[P1] + [P2] - 3[P4] on the Fermat quartic sixfold; its Hodge locus contains Sigma_4 (codimension 38, "
      "a reduced component) and explained cone loci E1, E2.",
      "No unexplained piece of the Hodge locus was found: every candidate direction at the Fermat point was killed "
      "by an explicit certificate, and at general points of the corank-6 strata the reduced locus is Sigma_4.",
      "It is not a theorem: the balanced regime at pencil-type points is undecided (one explicit polynomial w), and "
      "three loopholes remain at the Fermat point."],
     lambda e: e["kind"] == "result" and e["area"] == "fake_linear_cycles"),
    ("06_ruled_out_and_dead_ends.md", "Ruled out, and dead ends",
     ["What was tried and failed, with the reason, so that nobody tries the same thing again.",
      "Kind 'negative': a statement that was tested and is false. Kind 'dead_end': a method that does not work or a "
      "computation that did not finish.",
      "Read the 'Do not repeat' paragraph of an entry before starting anything similar."],
     lambda e: e["kind"] in ("negative", "dead_end")),
    ("07_open_problems.md", "Open problems",
     ["Questions the project left open, each with the single most useful next computation or argument.",
      "Includes work that was queued and never started (three or more cycles; sextic fourfolds and cubic tenfolds) "
      "and the literature and human checks that were not done.",
      "Status OPEN, STUCK (attempted, blocked) or CONJECTURE (a statement the evidence supports, with gaps)."],
     lambda e: e["kind"] == "open"),
    ("08_corrections_and_lessons.md", "Corrections, and methods worth reusing",
     ["Every error caught by a check: what was wrong and what replaced it. For a correction, 'status' is the status "
      "of the statement that replaced the wrong one.",
      "Then the methods that worked: universal certificates, catalecticants along arcs, dual-number and p-adic "
      "second-order data, the endomorphism-algebra splitting test, exact certificate files, blind checks.",
      "Lessons: keep parameters symbolic, check that symmetries fix the class, never infer a dimension from a "
      "tangent codimension alone."],
     lambda e: e["kind"] == "correction" or (e["kind"] == "result" and e["area"] == "methods")),
]
PAGE_AREAS = {"01_first_order.md": ["first_order"], "02_second_order.md": ["second_order"],
              "03_movasati_conjecture_and_fermat.md": ["movasati_conjecture", "fermat_expansion"],
              "04_explicit_cycles_on_cubics.md": ["explicit_cycles"], "05_fake_linear_cycles.md": ["fake_linear_cycles"]}
BANNER = ("> **Status of everything on this page:** produced by AI agents, checked only by other AI agents, reviewed "
          "by no human. Sources of published results were read by machine (see `tests/SOURCES.md`). The notes cited "
          "as \"unreviewed note 1, 2, 3\" are AI-written and not public. Nothing here is, or bears on, a proof or "
          "disproof of the Hodge conjecture. This is a registry of what was found, ruled out or left open, not a "
          "list of established theorems.")
LABELS = [("statement", "Statement"), ("data", "Data"), ("conditions", "Conditions"), ("evidence", "Evidence"),
          ("independent_check", "Independent check"), ("not_established", "Not established"),
          ("known_before", "Known before"), ("reproduce", "Reproduce"), ("do_not_repeat", "Do not repeat"),
          ("next_step", "Next step"), ("session_refs", "Session references (files not public)")]


# ------------------------------------------------------------------------------------------------- the reader
def parse_registry(text):
    """Read the YAML subset described in the module docstring. Returns (entries, errors)."""
    entries, errors = [], []
    cur, key, buf = None, None, None

    def close_block():
        nonlocal buf
        if buf is not None:
            while buf and buf[-1] == "":
                buf.pop()
            cur[key] = "\n".join(buf)
            buf = None

    for lineno, raw in enumerate(text.split("\n"), 1):
        line = raw.rstrip("\r")
        if "\t" in line:
            errors.append("line %d: tab character" % lineno)
        if buf is not None:
            if line.startswith("    "):
                buf.append(line[4:].rstrip())
                continue
            if line.strip() == "":
                buf.append("")
                continue
            close_block()
        if line.strip() == "" or line.startswith("#"):
            continue
        m = re.match(r"^(- |  )([a-z_]+):(?: (.*))?$", line)
        if not m:
            errors.append("line %d: cannot parse: %r" % (lineno, line[:60]))
            continue
        lead, key, val = m.group(1), m.group(2), m.group(3)
        if lead == "- ":
            if key != "id":
                errors.append("line %d: an entry must start with '- id:'" % lineno)
            cur = {}
            entries.append(cur)
        if cur is None:
            errors.append("line %d: field before the first entry" % lineno)
            continue
        if key in cur:
            errors.append("line %d: duplicate field %r in entry %r" % (lineno, key, cur.get("id")))
        if val is None or val.strip() == "":
            cur[key] = ""
        elif val.strip() in ("|-", "|"):
            buf = []
        elif val.startswith('"'):
            try:
                cur[key] = json.loads(val)
            except ValueError:
                errors.append("line %d: bad quoted string" % lineno)
                cur[key] = val
        else:
            cur[key] = val.strip()
    close_block()
    return entries, errors


# ------------------------------------------------------------------------------------------------- validation
def repo_paths(text):
    """Repository-relative paths mentioned in a text (top-level folders of the repository, or root .md files)."""
    found = []
    for m in PATH_RE.finditer(text):
        p = m.group(1).rstrip(".")
        if p not in found:
            found.append(p)
    return found


def validate(entries):
    errors, warnings = [], []
    ids = {}
    for n, e in enumerate(entries, 1):
        eid = e.get("id", "")
        where = "entry %d (%s)" % (n, eid or "no id")
        for f in REQUIRED:
            if not str(e.get(f, "")).strip():
                errors.append("%s: required field %r missing or empty" % (where, f))
        for f in e:
            if f not in REQUIRED and f not in OPTIONAL:
                errors.append("%s: unknown field %r" % (where, f))
            elif f in OPTIONAL and not str(e[f]).strip():
                errors.append("%s: optional field %r present but empty" % (where, f))
        if eid:
            if eid in ids:
                errors.append("%s: id is not unique (also entry %d)" % (where, ids[eid]))
            ids.setdefault(eid, n)
            if not ID_RE.match(eid):
                errors.append("%s: id must look like D-..., M-..., N-..., O-... or C-... in capitals" % where)
            elif e.get("kind") not in PREFIX_KINDS[eid[0]]:
                errors.append("%s: id prefix %s- is for kind %s, not %r"
                              % (where, eid[0], " / ".join(PREFIX_KINDS[eid[0]]), e.get("kind")))
        if e.get("kind") not in KINDS:
            errors.append("%s: kind %r not in %s" % (where, e.get("kind"), KINDS))
        if e.get("area") not in AREAS:
            errors.append("%s: area %r not in %s" % (where, e.get("area"), AREAS))
        if e.get("status") not in STATUSES:
            errors.append("%s: status %r not in %s" % (where, e.get("status"), STATUSES))
        if "\n" in e.get("title", ""):
            errors.append("%s: title must be one line" % where)
        if e.get("kind") in ("negative", "dead_end") and e.get("status") not in ("RULED_OUT", "STUCK"):
            errors.append("%s: a negative or dead end must have status RULED_OUT or STUCK" % where)
        if e.get("kind") == "open" and e.get("status") not in ("OPEN", "STUCK", "CONJECTURE"):
            errors.append("%s: an open item must have status OPEN, STUCK or CONJECTURE" % where)
        if e.get("kind") in ("result", "correction") and e.get("status") in ("RULED_OUT", "OPEN", "STUCK"):
            errors.append("%s: a result or correction cannot have status %s" % (where, e.get("status")))
        if e.get("kind") in ("negative", "dead_end") and "do_not_repeat" not in e:
            warnings.append("%s: negative / dead end without do_not_repeat" % where)
        if e.get("kind") == "open" and "next_step" not in e:
            warnings.append("%s: open item without next_step" % where)
        rep = e.get("reproduce", "")
        paths = repo_paths(rep)
        for p in paths:
            if not os.path.exists(os.path.join(REPO, p)):
                errors.append("%s: reproduce mentions %r, which does not exist in the repository" % (where, p))
        snippet = any(l.startswith("    ") and l.strip() for l in rep.split("\n"))
        if rep.strip() and NOT_REPRODUCIBLE not in rep and not paths and not snippet and not ID_REF_RE.search(rep):
            errors.append("%s: reproduce must name a repository path, contain a code snippet (lines indented by "
                          "four spaces), point to another entry, or contain the literal string %r"
                          % (where, NOT_REPRODUCIBLE))
        if NOT_REPRODUCIBLE in rep and len(rep.split(NOT_REPRODUCIBLE, 1)[1].strip(" :.")) < 10:
            errors.append("%s: %r must be followed by one line on what would be needed" % (where, NOT_REPRODUCIBLE))
    for n, e in enumerate(entries, 1):
        for f, v in e.items():
            if f == "id":
                continue
            for m in ID_REF_RE.finditer(str(v)):
                if m.group(1) not in ids:
                    errors.append("entry %d (%s): field %r refers to unknown entry %s"
                                  % (n, e.get("id"), f, m.group(1)))
    for fname in ("README.md", "NOTATION.md"):
        if not os.path.exists(os.path.join(HERE, fname)):
            errors.append("discoveries/%s is missing" % fname)
    return errors, warnings


# ------------------------------------------------------------------------------------------------- rendering
def render_text(text):
    """Blocks separated by blank lines: tables stay tables; blocks indented by four spaces become code; blocks with
    internal layout (indented lines, numbered items) are kept verbatim in a text fence; the rest are paragraphs."""
    out = []
    blocks, cur = [], []
    for line in text.split("\n"):
        if line.strip() == "":
            if cur:
                blocks.append(cur)
                cur = []
        else:
            cur.append(line)
    if cur:
        blocks.append(cur)
    item = re.compile(r"^(\(\w{1,3}\)|\(\w\'\)|- |E[0-3] |n = \d)")
    for b in blocks:
        if all(l.startswith("|") for l in b):
            out.append("\n".join(b))
        elif all(l.startswith("    ") for l in b):
            out.append("```\n" + "\n".join(l[4:] for l in b) + "\n```")
        elif any(l.startswith(" ") for l in b) or any(item.match(l) for l in b[1:]) or (len(b) > 1 and item.match(b[0])):
            out.append("```text\n" + "\n".join(b) + "\n```")
        else:
            out.append("\n".join(b))
    return "\n\n".join(out)


def render_entry(e):
    lines = ["## %s" % e["id"], "", "**%s**" % e["title"], "",
             "kind: `%s` | area: `%s` | status: **`%s`**" % (e["kind"], e["area"], e["status"]), ""]
    for f, label in LABELS:
        if f in e:
            body = render_text(e[f])
            if "\n" not in body and not body.startswith("|"):
                lines += ["**%s.** %s" % (label, body), ""]
            else:
                lines += ["**%s.**" % label, "", body, ""]
    return "\n".join(lines)


def render_pages(entries):
    pages = {}
    assigned = {}
    for fname, title, summary, sel in PAGES:
        chosen = [e for e in entries if sel(e)]
        for e in chosen:
            assigned.setdefault(e["id"], []).append(fname)
        L = ["# %s" % title, ""]
        L += ["- " + s for s in summary]
        L += ["", BANNER, "",
              "Generated from `discoveries/registry.yaml` by `discoveries/check_registry.py --write-pages`. Do not "
              "edit this page by hand: edit the registry. Notation: [`NOTATION.md`](NOTATION.md). "
              "Status vocabulary: [`README.md`](README.md).", ""]
        L += ["## Entries on this page (%d)" % len(chosen), "", "| id | status | title |", "|---|---|---|"]
        L += ["| [%s](#%s) | `%s` | %s |" % (e["id"], e["id"].lower(), e["status"], e["title"].replace("|", "\\|"))
              for e in chosen]
        L.append("")
        if fname in PAGE_AREAS:
            rel = [e for e in entries if e["area"] in PAGE_AREAS[fname] and e["kind"] != "result"]
            if rel:
                L += ["## Related entries on other pages", "", "| id | kind | status | page | title |",
                      "|---|---|---|---|---|"]
                for e in rel:
                    other = [p[0] for p in PAGES if p[3](e)][0]
                    L.append("| [%s](%s#%s) | %s | `%s` | %s | %s |" % (e["id"], other, e["id"].lower(), e["kind"],
                                                                        e["status"], other[:2],
                                                                        e["title"].replace("|", "\\|")))
                L.append("")
        for e in chosen:
            L += ["---", "", render_entry(e)]
        pages[fname] = "\n".join(L).rstrip("\n") + "\n"
    return pages, assigned


def summary_table(entries):
    used = [s for s in STATUSES if any(e.get("status") == s for e in entries)]
    w = max(len(k) for k in KINDS + ["TOTAL"])
    head = "kind".ljust(w) + "".join("  " + s for s in used) + "  TOTAL"
    lines = [head, "-" * len(head)]
    for k in KINDS + ["TOTAL"]:
        row = k.ljust(w)
        sel = [e for e in entries if k == "TOTAL" or e.get("kind") == k]
        for s in used:
            row += "  " + str(sum(1 for e in sel if e.get("status") == s)).rjust(len(s))
        row += "  " + str(len(sel)).rjust(5)
        lines.append(row)
    lines.append("")
    lines.append("by area: " + ", ".join("%s %d" % (a, sum(1 for e in entries if e.get("area") == a)) for a in AREAS))
    return "\n".join(lines)


def main(argv):
    with open(REGISTRY, encoding="utf-8") as fh:
        text = fh.read()
    entries, errors = parse_registry(text)
    if "--json" in argv:
        json.dump(entries, sys.stdout, indent=1)
        sys.stdout.write("\n")
        return 1 if errors else 0
    if "--list" in argv:
        for e in entries:
            print("%-44s %-10s %-22s %s" % (e.get("id"), e.get("kind"), e.get("status"), e.get("title")))
        return 1 if errors else 0
    verr, warnings = validate(entries)
    errors += verr
    pages, assigned = ({}, {}) if errors else render_pages(entries)
    if not errors:
        for e in entries:
            n = len(assigned.get(e["id"], []))
            if n != 1:
                errors.append("entry %s appears on %d pages (must be exactly 1)" % (e["id"], n))
    if not errors:
        for fname, content in pages.items():
            path = os.path.join(HERE, fname)
            if "--write-pages" in argv:
                with open(path, "w", encoding="utf-8") as fh:
                    fh.write(content)
            elif not os.path.exists(path):
                errors.append("page discoveries/%s is missing (run with --write-pages)" % fname)
            else:
                with open(path, encoding="utf-8") as fh:
                    if fh.read() != content:
                        errors.append("page discoveries/%s is not up to date with registry.yaml "
                                      "(run with --write-pages)" % fname)
    print("discoveries/registry.yaml: %d entries" % len(entries))
    print()
    print(summary_table(entries))
    print()
    npaths = sum(len(repo_paths(e.get("reproduce", ""))) for e in entries)
    nnot = sum(1 for e in entries if NOT_REPRODUCIBLE in e.get("reproduce", ""))
    print("reproduce fields: %d repository paths mentioned, all checked for existence; %d entries marked %r"
          % (npaths, nnot, NOT_REPRODUCIBLE))
    if "--write-pages" in argv and not errors:
        print("pages written: " + ", ".join(sorted(pages)))
    for w in warnings:
        print("WARNING: " + w)
    for err in errors:
        print("VIOLATION: " + err)
    print()
    print("RESULT: %s (%d violation(s), %d warning(s))" % ("FAIL" if errors else "OK", len(errors), len(warnings)))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
