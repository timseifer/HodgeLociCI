# Where the time goes: the slowest recurring jobs (plan item B14; report, no rewrite)

27 Nov 2026, Claude Opus 5.5. Timings from the logs of this week (2 cores, shared; cpu seconds as printed).

| job | typical cost | where the time goes (from the logs and code) |
| --- | --- | --- |
| `fermatExpansion` / `fermatNextOrderSystem`, eightfold, MOD p | order 4: 3 s, 5: 10 s, 6: 40 s, 7: 150 s, 8: 7 min, 9: 30 min | building E_n = [eps^n] exp(sum eps^j T_j) as a polynomial (3.3 million terms at n = 8) in interpreted Macaulay2 loops; then one pass per form. Grows about 3.5x per order. |
| the same over QQ(zeta_6) (exact) | 3-4x the MOD p time (order 7: 20 min, order 8: 1 h) | coefficient arithmetic in a toField extension; same structure |
| python-flint expansion of blind checks 13-15 (`lib13.py`, `own.py`) | order 8 eightfold: about 1 min (5x faster than the package); order 9: about 1 min, but memory | `nmod_mpoly` products in C; numpy for the period functional. Two order-9 jobs in parallel ran out of memory (7 GB) |
| full-space search (`run7b.py`, `run8.py`, `run9.py`) | order 8: 20 min, order 9: 40 min per prime | dominated by repeated expansions (one per sampled point: 20-40 points); the linear algebra is negligible |
| slice solver `ma2`/`ma4` | dominated by the D measurement (18 + 8 re-extensions at order 5) | each re-extension recomputes the series from scratch |
| `mx4_pipeline.py` (mpmath, 60-170 digits) | 1-10 min | pure-Python complex SVDs of 144 x 120 and eigenproblems of 64 x 64 at high precision; cached after the first run |
| `mx0_export_periods.m2` (exact periods of 330 quartics) | order 13: 1 min, order 19: 6 min | the exact series of the sixfold arc |
| exact plane count, Coble member (`ex2_count.m2`) | tens of minutes; the degree-18 membership run was stopped by hand | Groebner bases and primary decomposition over QQ and residue fields |

Suggestions, only where the profile supports them:
1. Series engine: the package's E_n recursion is the bottleneck of everything Fermat-related. The checkers'
   python-flint code is 5x faster and could become an optional backend for `fermatExpansion` (FLINT mpoly also
   exists over number fields: `fmpq_mpoly` with an extra variable for zeta, or `nf` coefficients). Worth it.
2. Incremental series: the slice and full-space searches recompute E_n from scratch for every sampled point; storing
   the partial products and updating only the changed terms would cut the searches by about the number of orders.
3. Memory: order 9 expansions need about 3 GB each; run one at a time or stream the terms per form.
4. mpmath: replace pure-Python SVDs by python-flint `acb_mat` (has no SVD) or by mpmath only where needed; the
   pipeline already caches; low priority.
5. Groebner-heavy exact runs (Coble counts): msolve could replace Macaulay2 for the zero-dimensional parts; only the
   membership runs were slow enough to matter.
No Rust or C kernel is suggested beyond FLINT: the expensive parts are polynomial products that FLINT already does.
