#!/usr/bin/env python3
"""docs/build_docs.py (agent PC; AI-written, not reviewed by a human).

Rebuilds the worked examples docs/NN_*.md from the prose in docs/prose/NN_*.md and the captured Macaulay2 sessions
docs/sessions/NN_*.out.  With --run it first re-runs every session:
    M2 --silent --no-readline --print-width 118 < sessions/NN.m2 > sessions/NN.out
The Markdown files contain the session output verbatim (only the final empty prompt is removed).
"""
import glob, os, subprocess, sys
here = os.path.dirname(os.path.abspath(__file__))
names = sorted(os.path.basename(f)[:-3] for f in glob.glob(os.path.join(here, "sessions", "[0-9]*.m2")))
if "--run" in sys.argv:
    for n in names:
        with open(os.path.join(here, "sessions", n + ".m2")) as fin, open(os.path.join(here, "sessions", n + ".out"), "w") as fout:
            subprocess.run(["M2", "--silent", "--no-readline", "--print-width", "118"], stdin=fin, stdout=fout,
                           stderr=subprocess.STDOUT, cwd=os.path.join(here, "sessions"), check=True)
for n in names:
    prose = open(os.path.join(here, "prose", n + ".md")).read()
    out = open(os.path.join(here, "sessions", n + ".out")).read().rstrip("\n").split("\n")
    while out and (out[-1].strip() == "" or (out[-1].startswith("i") and out[-1].rstrip().endswith(":"))):
        out.pop()
    session = "```\n" + "\n".join(l.rstrip() for l in out) + "\n```"
    if "{{SESSION}}" not in prose:
        raise SystemExit("no {{SESSION}} marker in prose/" + n + ".md")
    open(os.path.join(here, n + ".md"), "w").write(prose.replace("{{SESSION}}", session))
    print("wrote", n + ".md", len(out), "session lines")
