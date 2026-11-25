#!/usr/bin/env python3
"""Build the static progress page (GitHub Pages) from discoveries/registry.yaml and site/status.json.

Usage (from the repository root):  python3 site/build_site.py [OUTPUT_DIR]   (default: _site)
Python 3, standard library only. The page is one self-contained index.html with the data embedded.
"""
import json, os, re, subprocess, sys, html, datetime

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(ROOT, "_site")

reg = json.loads(subprocess.run([sys.executable, os.path.join(ROOT, "discoveries", "check_registry.py"), "--json"],
                                capture_output=True, text=True, check=True, cwd=ROOT).stdout)
status = json.load(open(os.path.join(ROOT, "site", "status.json")))
keep = ["id", "kind", "area", "title", "statement", "status", "conditions", "evidence", "independent_check",
        "not_established", "known_before", "reproduce", "do_not_repeat", "next_step", "data"]
entries = [{k: e.get(k, "") for k in keep} for e in reg]

# Links between entries: entry A mentions the id of entry B in one of its fields. Drawn as B -> A ("A builds on
# B"). A mention in statement/conditions/data/evidence/independent_check is a "strong" link (A rests on B); a
# mention elsewhere (reproduce, not_established, known_before, do_not_repeat, next_step) is a cross-reference.
# When two entries mention each other, the one that cites the other in a strong field follows it; if both or
# neither do, the earlier one in the registry is drawn first.
STRONG = ["statement", "conditions", "data", "evidence", "independent_check"]
WEAK = ["reproduce", "not_established", "known_before", "do_not_repeat", "next_step"]
ids = [e["id"] for e in entries]
order = {i: n for n, i in enumerate(ids)}
idre = re.compile(r"\b[A-Z]-[A-Z0-9][A-Z0-9-]*[A-Z0-9]\b")
mentions = {}  # (citing, cited) -> "strong" | "weak"
for e in entries:
    for f in STRONG + WEAK:
        for m in idre.findall(str(e.get(f, ""))):
            if m in order and m != e["id"]:
                key = (e["id"], m)
                if mentions.get(key) != "strong":
                    mentions[key] = "strong" if f in STRONG else "weak"
links = {}
for (a, b), kind in mentions.items():
    src, dst = (b, a)
    if (b, a) in mentions:
        rank = {"strong": 1, "weak": 0}
        ka, kb = rank[kind], rank[mentions[(b, a)]]  # how strongly a cites b, and b cites a
        if kb > ka or (kb == ka and order[a] < order[b]):
            src, dst = (a, b)
        kind = "strong" if "strong" in (kind, mentions[(b, a)]) else "weak"
    if (src, dst) not in links or kind == "strong":
        links[(src, dst)] = kind
edges = [{"from": s_, "to": t, "kind": k} for (s_, t), k in sorted(links.items(), key=lambda x: (order[x[0][0]], order[x[0][1]]))]
payload = json.dumps({"entries": entries, "status": status, "edges": edges,
                      "built": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%d %H:%M UTC")})
payload = payload.replace("</", "<\\/")

template = open(os.path.join(ROOT, "site", "template.html")).read()
os.makedirs(OUT, exist_ok=True)
with open(os.path.join(OUT, "index.html"), "w") as f:
    f.write(template.replace("/*__DATA__*/null", payload))
open(os.path.join(OUT, ".nojekyll"), "w").close()
print("wrote", os.path.join(OUT, "index.html"), "with", len(entries), "entries and", len(edges), "links")
