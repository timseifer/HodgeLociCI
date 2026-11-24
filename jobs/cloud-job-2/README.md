# cloud-job-2: more work for the cloud instance (breadth at lambda = -1, other lambda values, Macaulay2 scans)

**Status: AI-generated research code (agent PK2, 24 Nov 2026), not reviewed by a human.** Same rules as
`../cloud-job-1/README.md` and `../queue/README.md`: every group starts with a validation step that reproduces
stored results EXACTLY and refuses to continue on a mismatch. A finite order never proves a component exists.

This folder reuses `../cloud-job-1` (engine build, `run_tasks.py`, `estimate.py`, `check_results.py`,
`make_summary.py`) and `../../tooling/fermat_series` by relative path. It writes nothing outside
`jobs/queue/results/<id>/` apart from the kernel build `../cloud-job-1/build/` (made by R000 anyway).
All commands below are run from the repository root. `<id>` is the request id chosen by the coordinator.

Groups, in priority order:

| group | what | validation | cores | memory GB | est. min | after |
|---|---|---|---|---|---|---|
| H1 | lambda = -1 generic NEW seeds 13-60 at order 9, one prime per seed (48 runs) | R000 (cloud-job-1 `validate.sh`) | 8 | 42 | 50 (deadline) | R000, R004 |
| H3 | lambda = 2 controls, seeds 13-60, both primes, order 6 (96 runs) | R000 | 4 | 6 | 15 | R000 |
| L  | other lambda values at the Fermat point, order 7 (60 runs) | `validate_lam.sh` (2 NF-T6 logs) | 8 | 12 | 15 | R000 |
| M1 | Macaulay2: the 472 sextic-fourfold types never run for points of J | `m2scan.py validate` (5 T6c types) | 16 | 40 | 30 | none (no R000 needed) |
| M2 | Macaulay2: retry of the 106 types with no F_p-rational root on T6c's line | `m2scan.py validate` | 8 | 20 | 25 | none |
| H2 | the 48 H1 directions at the OTHER prime (replication) | R000 | 8 | 42 | 50 (deadline) | R000, H1 |
| M4 | exact (QQ) Z_431 check, single long M2 process | `m2scan.py validate` | 1 | 16 | 90 (timeout) | none |

---

## H: more generic lambda = -1 directions at order 9 (breadth), plus lambda = 2 controls

**What.** W3 checked 12 generic directions (seeds 1-6, two primes) to order 7-8; cloud-job-1 adds seeds 7-11 at
order 10-12. H adds 48 NEW fully generic rank-1 directions (seeds 13-60) at order 9, both Segre types (cloud-job-1
convention: seeds 13-15, 19-21, ... a x l; 16-18, 22-24, ... l x a), the prime alternating by seed (H1), then the
same 48 at the other prime (H2). H3 runs the lambda = 2 control (order-6 obstruction) for the same seeds.
Engine and script: `../cloud-job-1/hodge_job.py` through `../cloud-job-1/run_tasks.py`, unchanged.

**Why.** Breadth: does the lambda = -1 lead hold for many independent random tangent directions, not only a handful
pushed to high order? A single obstruction at order <= 9 would refute that direction.

**Pre-registration.** H1/H2: dead end = any lambda = -1 direction OBSTRUCTED_GENUINE at order <= 9; surprise = none
expected (all EXTENDS to 9 only strengthens the lead). H3: expected OBSTRUCTED_GENUINE at order 6 in all 96 runs;
surprise = any lambda = 2 run that is not OBSTRUCTED_GENUINE (the control would have failed).

**Validation.** cloud-job-1's `validate.sh` (R000) covers the engine, the direction generator and the obstruction
analysis; `run_tasks.py` refuses to start without its VALIDATION_PASS. `check_results.py` then checks the manifest.

**Resources** (`estimate.py`, SP-T6 model, +-50%): order 9 = 4.4 GB and about 0.34 CPU-h per run at 1 thread on
the development machine (measured order 8 there: 200-330 s, model 277 s). 48 runs = about 16 CPU-h, so with 8
cores H1 does NOT finish all 48 in 50 min; the task file is in priority order (seed 13 first) and `--deadline-min`
stops new starts (records NOT_RUN). Give it more cores when they are free (e.g. `--cores 24 --mem-gb 120` after R001
ends: all 48 in about 45 min). lambda = 2 order 6: 0.8 GB, 20-60 s each.

**Commands.**

    H1: python3 jobs/cloud-job-1/run_tasks.py jobs/cloud-job-2/tasks/h1_generic_lam-1_N9_pass1.csv --out jobs/queue/results/<id> --cores 8 --mem-gb 42 --mem-safety 1.1 --deadline-min 50
    H3: python3 jobs/cloud-job-1/run_tasks.py jobs/cloud-job-2/tasks/h3_controls_lam2_N6.csv --out jobs/queue/results/<id> --cores 4 --mem-gb 6 --mem-safety 1.1
    H2: python3 jobs/cloud-job-1/run_tasks.py jobs/cloud-job-2/tasks/h2_generic_lam-1_N9_pass2.csv --out jobs/queue/results/<id> --cores 8 --mem-gb 42 --mem-safety 1.1 --deadline-min 50
    then: python3 jobs/cloud-job-1/make_summary.py jobs/queue/results/<id> && python3 jobs/cloud-job-1/check_results.py jobs/queue/results/<id>

Expected outputs: `jobs/queue/results/<id>/manifest.csv`, `summary.md`, `runs/*.log|*.json|arc_*.npy`, `validation/`.
Tested here: `tasks/test_small_h.csv` (lambda = -1 seed 13 a x l MOD 67108819 order 6: EXTENDS; lambda = 2 seed 16
l x a MOD 67108837: OBSTRUCTED_GENUINE), `check_results.py` passes apart from the (expected) missing VALIDATION_PASS.

---

## L: other lambda values at the Fermat point (symmetry question)

**What.** Fully generic rank-1 directions for [P1] + lambda [P2] with lambda = r/s:
lambda in {-4, -1/4, 5, 1/5, -5, 3/2, -3/2, 2/3, -2/3} at both primes, seeds 1 (a x l) and 4 (l x a), plus NF-T6's
values {-1, -2, -1/2, 3, 1/3, 1/2, 2, -3, -1/3, 4, 1/4, 1} at the second prime 67108819 (NF-T6 ran 67108837 only).
Order 7 requested (a run obstructed at 6 stops there; the W3 quadratic-freedom criterion and the general analysis
are both printed and must agree). `hodge_job_lam.py` is `../cloud-job-1/hodge_job.py` with lambda = r/s
(mod p: r s^-1) exactly as NF-T6's `checks/nf_t6/gen_lam.py`. The T Cone_T input depends on lambda
(`mc_exact(ExactEngine(lambda), lambda)`), so `inputs/mc_<p>_lam<r>[o<s>].json` were exported here for 19 lambda
values x 2 primes by `dev/export_mc_lam.py` (needs the discovery checkout and flint; NOT run on the cloud). The
exported lambda = -1 and 2 files are identical to cloud-job-1's (checked by `validate_lam.sh`).

**Why.** NF-T6 found (MOD 67108837) that only lambda = -1 survives order 6 among 12 values, lambda and 1/lambda
always agree, and lambda = 1 = lambda_0 is degenerate. More values, and the second prime, test whether lambda = -1 is
the unique survivor and whether the lambda <-> 1/lambda symmetry holds.

**Pre-registration.** Expected: every lambda other than -1 and 1 OBSTRUCTED_GENUINE at order 6, lambda and 1/lambda
with the same verdict; lambda = -1 EXTENDS to 7; lambda = 1: K.c = 0 (EXTENDS). Surprise = any lambda not in
{-1, 1} that extends past 6, or a pair lambda, 1/lambda with different verdicts, or a verdict that differs between the
two primes. Dead end (for the symmetry route) = all as expected (symmetry-compatible but not separating).

**Validation** (`validate_lam.sh <out>/validation_lam`, called by `run_lam.py` before anything else; refuses to
continue on failure): requires R000's VALIDATION_PASS; the lambda = -1, 2 inputs equal cloud-job-1's; and the stored
NF-T6 logs `A_-2_1_al` (lambda = -2, seed 1, a x l) and `A_1o2_4_la` (lambda = 1/2, seed 4, l x a), MOD 67108837,
order 6, are reproduced line for line (all 24 lines; timings, gen_lam's 'peak RSS' line and the extra ANALYSIS
block are ignored, `check_nf_log.py`), with verdict OBSTRUCTED_GENUINE and `agree: True`.
**Result here: PASS (24/24 lines for both).**

**Command** (cores 8, memory 12 GB, about 15 min; each run < 1.5 GB, order 7 about 1 min, order 6 + analysis
30-70 s on the development machine):

    python3 jobs/cloud-job-2/run_lam.py jobs/cloud-job-2/tasks/l_lambdas_N7.csv --out jobs/queue/results/<id> --procs 8

Outputs: `<out>/manifest.csv` (cloud-job-1 columns; `lambda` is the string r/s), `<out>/summary.md`,
`<out>/runs/gen_lam<r>o<s>_<p>_s<seed>_<kind>_N7.{log,json}`, `<out>/validation_lam/`. Check: every row has a
verdict in {EXTENDS, OBSTRUCTED_GENUINE}; rows in 'runs needing attention' of `summary.md` must be reported.
(`../cloud-job-1/check_results.py` expects integer lambda and is NOT used for this group.)
Tested here: `tasks/test_small_l.csv` (lambda = -1/4, seed 1, a x l, MOD 67108819, order 6): OBSTRUCTED_GENUINE.
Note: negative fractions must be passed as `--lam=-1/4` to `hodge_job_lam.py` (the driver does this).

---

## M: Macaulay2 scans left unfinished by T6 step (c) (embarrassingly parallel)

**What.** T6c (discovery `t6_unsolved/c/`, ledger [T6c]) looked for general points of the jump divisor J of V_Z
(det of the square map .det M : A_tau -> A_d vanishes) on a random line M0 + t M1, MOD 32003, and ran the package's
`excessFromData` and `secondOrderObstruction(D, 2)` at each point. Every smooth point found gave E' = 1, (S) false,
ALL DIE. Two parts were left:

* M1 `sextic`: the sextic-fourfold (6,2) scan stopped after 49 of 630 types; the 472 remaining types with tau != 6
  (tau = 6: det M constant, J inside singular hypersurfaces) were never run. Seed 5 (T6c's), then new lines.
* M2 `retry`: 63 quartic (4,3), 22 tenfold (3,5) and 21 sextic (6,2) types where T6c's line had no F_p-rational root
  of det: new random lines (seeds 6, 7, 8).

`m2scan.py` runs one M2 process per type (`run_one.m2`, the per-type body of T6c's `run_jump.m2`, with T6c's
`jump.m2` verbatim apart from the package path), tries up to `--tries` lines until one has an F_p-root, and writes
`scan_<mode>.csv` (d, k, idx, type, seed, status, info, n_points, points, verdicts, runtime_s), `raw/*.out`,
`summary_<mode>.md`. Per-process caps: `--timeout-s` (default 1800) and `--mem-gb` (address space, default 8).

**Why.** Closes the "general points of J" dead end of step (c) for all three families instead of a sample.

**Pre-registration.** Expected (dead end confirmed): every smooth point ALL DIE (or SINGULAR). Surprise = any smooth
point with verdict NOT DETERMINED, SOME DIE or ALL SURVIVE (flagged as ALERT in `summary_<mode>.md`), i.e. a type
where a second component could pass through general points of J.

**Validation** (automatic: each scan first runs `validate` into its `--out` unless VALIDATION_PASS is there, and
stops on failure): 5 types with results stored in `m2scan/reference/jump_*.out` (T6c, seed 5, MaxRoots 2) are rerun
and every output line compared exactly apart from the cpu time: (6,2) P={1,4} (point, ALL DIE), (6,2) P={1,1} (no
root), (4,3) P={2,2,3} (point, ALL DIE), (4,3) H={3} P={1,1,1} (SINGULAR), (3,5) P={1,1,1,1,2} (point, ALL DIE).
**Result here (M2 1.22): PASS 5/5.**

**Macaulay2 on the cloud** (either):

    # (a) apt, Ubuntu 24.04 (noble, universe): the exact build the package is tested with
    sudo apt-get update && sudo apt-get install -y macaulay2=1.22+ds-6build2 macaulay2-common=1.22+ds-6build2
    # (b) Docker, from the repository root
    docker build -t hodgelocici .
    # then pass  --m2 "docker run --rm -i -v $PWD:/w -w /w/jobs/cloud-job-2/m2scan hodgelocici M2"  to m2scan.py
    # (the script runs M2 with the working directory jobs/cloud-job-2/m2scan; the mount must be the repository root)

**Commands.**

    M1: python3 jobs/cloud-job-2/m2scan/m2scan.py sextic --out jobs/queue/results/<id> --procs 16 --mem-gb 8 --tries 3 --deadline-min 35
    M2: python3 jobs/cloud-job-2/m2scan/m2scan.py retry  --out jobs/queue/results/<id> --procs 8  --mem-gb 8 --tries 3 --deadline-min 30

Resources: one core per process; M2 processes stayed below 1.5 GB here (cap 8 GB, memory_gb = 40 / 20 is the
safe bound, actual use is far lower). Time per type here 4-90 s (package load included; the first new sextic types 49, 50 took 74 and 90 s on
the shared development machine, later types may be larger), so M1 about 472 x 60 s / 16 = 30-45 min (the
deadline stops new starts; rerun the same command to continue), M2 about 106 x (1-3 lines) x 40 s / 8 = 10-25 min. `--deadline-min` stops new types; restarting
the same command continues (types already in the CSV are skipped). Tested here: `--limit 2` of each mode.

**M4 (only if cores are idle): exact (QQ) Z_431 run.** T6c's explicit point of Z_431 ((4;1;1;1,1,1), integer data)
with the full checker over QQ (`zq431_exact.m2`, verbatim apart from the package path and cpu-time prints) did not
finish in 25 min here. Pre-registration: expected = the MOD p result (smooth, E' = 3, (S) false, SOME DIE, quadrics
of rank 5, common zero locus of dimension 0); surprise = a different exact verdict (then the MOD p result was a bad
reduction). Validation = the same 5-type M2 check (the exact run itself has no stored reference).

    M4: bash jobs/cloud-job-2/m2scan/run_zq431_exact.sh jobs/queue/results/<id> 90

Outputs: `<out>/zq431_exact.out`, `<out>/zq431_exact.status`, `<out>/validate_m2.log`. Cores 1, memory 16 GB
(unknown; QQ coefficient growth), 90 min timeout (a TIMEOUT line is written; that is a valid outcome to report).

---

## Files

| file | role |
|---|---|
| `tasks/h1_*.csv`, `h2_*.csv`, `h3_*.csv`, `test_small_h.csv` | H task lists for `../cloud-job-1/run_tasks.py` |
| `hodge_job_lam.py` | `../cloud-job-1/hodge_job.py` with lambda = r/s (NF-T6 gen_lam.py first log line) |
| `run_lam.py`, `validate_lam.sh`, `check_nf_log.py` | L driver, validation, log comparison |
| `tasks/l_lambdas_N7.csv`, `test_small_l.csv` | L task lists |
| `inputs/mc_<p>_lam<r>[o<s>].json` | T Cone_T conditions mod p for 19 lambda values (dev/export_mc_lam.py) |
| `reference/nf_t6_A_*.log` | stored NF-T6 logs for the L validation |
| `m2scan/m2scan.py`, `run_one.m2`, `jump.m2`, `enum_types.out` | M driver, per-type M2 script, T6c's jumpPoints, the 980 degree types |
| `m2scan/reference/jump_{43,35,62}.out` | T6c's stored scan outputs (validation and retry list) |
| `m2scan/zq431_exact.m2`, `run_zq431_exact.sh` | M4 |
| `dev/export_mc_lam.py` | how the L inputs were made (development machine only) |
