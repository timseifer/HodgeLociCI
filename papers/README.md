# The three AI-written notes ("paper 1", "paper 2", "paper 3")

These are the notes that the package's help nodes, `tests/SOURCES.md` (part E) and the discoveries registry cite as
"paper 1", "paper 2" and "paper 3" (also "note 3"), with their theorem numbers. They are added here unchanged, as
frozen on 21-22 November 2026, so that those numbers can be looked up.

**Status, read first.** All three were written by an AI system (Anthropic's Claude) at the direction of Timothy
Seifert. Their proofs were checked only by AI referee agents. No human mathematician has reviewed them. They are not
peer-reviewed and not submitted anywhere. Each opens with a notice saying so. Nothing in them is a proof or a
disproof of the Hodge conjecture, and each says that it does not bear on it. The author line "[author names to be
added]" is left as frozen.

| File | Title | Version | Cited as |
| --- | --- | --- | --- |
| `paper1.tex`, `paper1_cubic_sixfolds_eightfolds.pdf` | Hodge loci of sums of two linear cycles: Movasati's conjecture for cubic sixfolds and eightfolds | version 6, 21 Nov 2026 | paper 1 |
| `paper2.tex`, `paper2_curves_on_surfaces.pdf` | Noether-Lefschetz loci of sums of two disjoint complete-intersection curves, with an application to Movasati's proposed counterexample to Harris's conjecture for octic surfaces | version 4, 21 Nov 2026 | paper 2 |
| `paper3.tex`, `paper3_general_rule.pdf` | The special coefficient for Hodge loci of sums of two complete intersections sharing equations: a liaison identity and a second-order law | version 21, 22 Nov 2026 | paper 3, note 3 |

The `.tex` files are self-contained (no `\input`, no figures). SHA-256:

    c8ed8bf588ebc79164fa3f4eb412c1846ff74879ec29d7426b5bb3e028410186  paper1.tex
    a9af9d235f10f011bce95a20ce8bce03135aa6e3dff5624d5213fce5da2c5465  paper1_cubic_sixfolds_eightfolds.pdf
    d6e0af4ccc8d14a8c33910ce976f32524043912bcd90f99c1c8b926e8b19525f  paper2.tex
    b2715387cf90989701ebcf791c1197a82530dce3ac827b2c45c65e95ef6f5ef4  paper2_curves_on_surfaces.pdf
    676ce37fee871db11357e5bed99ccf2d0269c330987a59217b7188a39a2e5e7b  paper3.tex
    fdf28397a7f41fcff37aff96efc0883970d736d32eaf7fc4f6904ebba8ca68fa  paper3_general_rule.pdf

## Frozen: what has changed since

The notes are not edited. Everything learned after they were frozen is in the registry (`discoveries/`), which takes
precedence where the two differ:

- Corrections and gaps: `discoveries/08_corrections_and_lessons.md` (entries `C-...`; several concern drafts and
  proofs of these notes, e.g. C-NIGHT-WS-STATEMENT, C-NIGHT-PROP-94PRIME-GAP, C-NIGHT-VACUOUS-CHECKS for note 3,
  C-PLANE-LEMMA-GAP, C-EIGHTFOLD-CHAIN-STEP4, C-AVERAGING-ARGUMENT for the sixfold and eightfold work), and the open
  entries O-SIGN-AND-PLANE-LEMMA-GAPS, O-COMMON-ZEROS-AND-SECOND-ORDER-GAPS and O-CITED-INPUTS-AND-HUMAN-REVIEW
  (cited analytic inputs that no agent opened).
- Later results that go beyond the notes (for example the cubic tenfold lead, `leads/`) are recorded only in the
  registry.

## Prior work not cited in the notes

- **Paper 1.** Its main result, that Movasati's Conjecture 1 fails for cubic sixfolds and eightfolds, was obtained
  earlier in rStation paper #5 (u/lelong_ridge, agent-written, v5 dated 18 Oct 2026,
  https://rstation.ai/problems/hodge_conjecture/papers/5; Theorem A, for all lambda outside a finite set, including
  all 125 of Movasati's ratios). Credit for that disproof belongs there; paper 1 was written without knowledge of it.
  The registry entries D-MOVASATI-CERTIFICATES and following give the overlap and what paper 1 adds (for example
  exact certificates over Q(zeta_6) at lambda = -1, 2, 5/3).
- **Paper 3.** rStation #5 contains no general rule for lambda_0, no excess formula and no second-order law (registry
  D-FIRST-ORDER-RULE, D-SECOND-ORDER-LAW, D-LINEAR-LIST-FIRST-ORDER).
- **Paper 2.** No systematic search for prior agent-written work on this topic was made.

The rStation pages were machine-read on 24 Nov 2026; the rest of the rStation Hodge list was not scanned.

## Using them

Quote a statement from these notes with its status: "proved in an AI-written, unreviewed note", never as an
established theorem. The package labels this as `PROVED (AI-written, unreviewed)`.
