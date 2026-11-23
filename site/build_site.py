#!/usr/bin/env python3
"""Build the static progress page (GitHub Pages) from discoveries/registry.yaml and site/status.json.

Usage (from the repository root):  python3 site/build_site.py [OUTPUT_DIR]   (default: _site)
Python 3, standard library only. The page is one self-contained index.html with the data embedded.
"""
import json, os, subprocess, sys, html, datetime

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "_site")

reg = json.loads(subprocess.run([sys.executable, os.path.join(ROOT, "discoveries", "check_registry.py"), "--json"],
                                capture_output=True, text=True, check=True, cwd=ROOT).stdout)
status = json.load(open(os.path.join(ROOT, "site", "status.json")))
keep = ["id", "kind", "area", "title", "statement", "status", "conditions", "evidence", "independent_check",
        "not_established", "known_before", "reproduce", "do_not_repeat", "next_step", "data"]
entries = [{k: e.get(k, "") for k in keep} for e in reg]
payload = json.dumps({"entries": entries, "status": status,
                      "built": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%d %H:%M UTC")})
payload = payload.replace("</", "<\\/")

template = open(os.path.join(ROOT, "site", "template.html")).read()
os.makedirs(OUT, exist_ok=True)
with open(os.path.join(OUT, "index.html"), "w") as f:
    f.write(template.replace("/*__DATA__*/null", payload))
open(os.path.join(OUT, ".nojekyll"), "w").close()
print("wrote", os.path.join(OUT, "index.html"), "with", len(entries), "entries")
