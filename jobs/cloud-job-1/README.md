# cloud-job-1: high-order formal arcs at the Fermat cubic tenfold (Hodge loci, Movasati's pair)

**Status: AI-generated research code and AI-run computations, not reviewed by a human.** All arithmetic is exact
modular arithmetic (MOD p, p = 67108837 or 67108819). The results do not depend on the machine. A finite order
never proves that a component of the Hodge locus exists (see the project's `checks/w4` REPORT). A survival to order
N only makes the lead stronger. An obstruction can refute a direction.

This folder is self-contained. It uses the CI-tested compiled kernel in `../../tooling/fermat_series/`, imported by
relative path. Do not move this folder out of the repository. Macaulay2 and Singular are **NOT needed**.

---

## 1. What is computed, and why

**Plain language.** Take the Fermat cubic tenfold X (a hypersurface in P^11) and two linear 5-planes P1, P2 in it
that meet in a P^2 (Movasati's pair). The project asks along which deformation directions of X the class
[P1] + lambda [P2] stays a Hodge class. At first order there are more such directions than expected (the "lead").
The question is whether they lift to actual curves (arcs) in the Hodge locus. The program tries to extend an arc
order by order. At each order it computes a huge polynomial (up to billions of terms) and reduces it to a few
hundred numbers mod p. Then it checks whether a correction keeps the arc going.

**Precise.** The arc is t -> F + sum_j t^j T_j. Here F is the Fermat cubic, T_1 = v is the tangent direction, and
T_m = SL c_m + kerL x_m. The obstruction at order n is K.c_n, the cokernel part of the order-n period coefficient
vector. Order 4 is G4(v), with K.c_4 = 0 on Sigma1. The order-5 linearisation is DG4(v), of rank 16. At each order
n >= 5 the top-term correction x_(n-3) is chosen so that K.c_n = 0, if K.c_n lies in Im DG4(v). All lower orders are
then recomputed exactly. The tangent directions are of two kinds:

* **generic rank-1 directions** (jobs a, b): v = c0 + bOf(a x l) or bOf(l x a), the two Segre types, with c0
  uniform in T Cone_T mod p and a, l uniform mod p. These are exactly the directions of agent W3's `gen_dirs.py`
  for the same seed. They are generated here from `inputs/mc_<p>_lam<lambda>.json`, and `validate.sh` checks that
  the 12 stored W3 directions come out identical.
* **EX-T6 explicit arcs** (job c): the exact lambda = -1 arcs of EX-T6 (`inputs/exarc_{al,la}.json`, exact to
  order 8 over Q(z)), reduced mod p. These are sparse, so higher orders fit in memory.

The values of lambda:

* **lambda = -1, the lead.** Known so far: the EX-T6 arcs reach order 12 (a x l) and 11 (l x a) at both primes. The
  12 W3 generic directions reach order 8. No obstruction has been found.
* **lambda = 2, the control.** All 12 W3 generic directions are obstructed at order 6, for every integral arc with
  that tangent (the quadratic-freedom criterion of step (e) / RC-T6 / W3).

The user registered the following before the run (coordinator ledger, 02:00Z, 24 Nov):

* **SURPRISE**: lambda = -1 generic directions survive to order 13 at both primes, while lambda = 2 stays obstructed.
* **DEAD END**: any lambda = -1 generic direction is obstructed at order <= 13.

**Important: generic order 13 does NOT fit on this machine.** It needs an estimated 244 GB of RAM and about 36
CPU-hours (section 5). So this job cannot reach the SURPRISE criterion for generic directions. It can reach generic
order 12 for one direction, order 10 to 11 for several more, and sparse EX-T6 arcs to order 13 to 14. A DEAD END
(an obstruction at order <= 12) can still be found.

### Jobs

| job | what | script | why |
|---|---|---|---|
| validate | reproduces stored runs exactly (section 3) | `validate.sh` | must pass first; otherwise STOP |
| a | lambda = -1 generic directions (W3 seeds 1-6, new seeds 7+, both Segre types, both primes), orders 10-12 | `hodge_job.py` | does the lead survive at higher order for generic tangents? |
| b | lambda = 2 generic directions, order-6 obstruction test (control) | `hodge_job.py` | the control must stay obstructed at 6 for new seeds too |
| c | lambda = -1 EX-T6 sparse arcs, orders 13-14 | `run_arc.py` | the highest orders reachable |

### What happens when a lambda = -1 run finds an obstruction

The run does not stop silently. Say K.c_n is not in Im DG4(v) after the top-term correction. Then `hodge_job.py`
runs `analyse()`:

1. **Linear stage.** The freedom is x_2 .. x_(n-3). The first-order effects of these on K.c_3 .. K.c_(n-1) must
   vanish; call the space of such x the kernel Z. Let S = Im DG4 + J_n(Z), where J_n is the order-n effect. Suppose
   K.c_n lies in S. The program then applies the linear solution and rebuilds the arc exactly from T_2.
   * If every K.c_m = 0, the verdict is **OBSTRUCTED_CHOICE**. The failure came from earlier choices, and the arc
     continues with other corrections.
   * Otherwise the verdict is **OBSTRUCTED_UNRESOLVED**.
2. **Nonlinear stage.** Suppose K.c_n is not in S. The program takes a random k in Z, rebuilds exactly with x + k,
   and checks two things: K.c_3 .. K.c_(n-1) stay 0, and the nonlinear part q = K.c_n(x+k) - K.c_n(x) - J_n k lies
   in Im DG4(v).
   * If both hold, the verdict is **OBSTRUCTED_GENUINE**. There is no integral arc with this tangent. This is MOD p,
     with one random k, the same standard as W3 / RC-T6.
   * Otherwise the verdict is **OBSTRUCTED_UNRESOLVED**.

At n = 6 this is exactly W3's criterion. The lambda = 2 runs print both W3's test and `analyse()`, and the two must
agree (`agree: True`). The order-7 code path is tested in `validate.sh` step 6.

There is one limitation. For the EX-T6 sparse arcs (`run_arc.py`, unchanged SP-T6/W3 logic), a failure of the top
term prints the full linearised freedom, saves `obstr_*.pkl` and is recorded as **OBSTRUCTED_UNRESOLVED**. The
quadratic-freedom analysis for that case is left to the coordinator.

> **Instance agent: any lambda = -1 row in the manifest that is not EXTENDS (OBSTRUCTED_GENUINE, OBSTRUCTED_CHOICE,
> OBSTRUCTED_UNRESOLVED, or ERROR) must be reported PROMINENTLY.** Put it in the first lines of `summary.md`
> (automatic), of the commit message and of your final report. Do not try to "fix" it, and do not rerun it with
> other settings to make it go away. A lambda = 2 row that is NOT OBSTRUCTED_GENUINE must also be reported, because
> the control would then have failed.

---

## 2. Install on a fresh Ubuntu 22.04 / 24.04

    sudo apt-get update && sudo apt-get install -y python3 python3-numpy g++ git
    # (or: pip install numpy)   OpenMP comes with g++ (libgomp).  No Macaulay2, no Singular, no GPU, no network.
    git clone <repo> && cd <repo> && git checkout -b cloud-job-1      # or check out the existing branch
    cd jobs/cloud-job-1

Python must be 3.8 or newer, with numpy 1.20 or newer. The kernel compiles itself into `build/` on first use, which
takes about 10 s (`g++ -O3 -march=native -fopenmp`). Use `tmux` or `nohup` so that jobs survive a disconnect.

## 3. Validation (always first; about 3-5 min on 30 cores)

    ./validate.sh            # writes results/validation/ (validate.log, machine.txt, calibration.txt, logs)

The script checks the following. Every comparison is line by line, apart from timings.

0. Environment, and the build of the compiled kernel.
1. The kernel unit test (`tooling/fermat_series/test_fermat_series.py`): the compiled kernel against the numpy
   references, bit for bit.
2. The direction generator: the 12 W3 lambda = -1 generic directions are regenerated from (p, seed, kind), and they
   must be identical to `inputs/dir_*.json`.
3. **(i)** lambda = -1, EX-T6 arc a x l, MOD 67108837, z index 0, **order 11**. The log must match
   `reference/exarc_67108837_0_al_11.log` (W3/SP-T6), and the final arc must be identical to
   `reference/w3_arc_67108837_0_al_11.npy`.
4. **(ii)** lambda = 2, generic seed 1 a x l (MOD 67108837) and seed 4 l x a (MOD 67108819), **order-6 obstruction**.
   The ranks and the verdict must be the same as W3's `gen_*_2_*` logs, and the verdict must be OBSTRUCTED_GENUINE,
   with the general analysis agreeing.
5. **(iii)** lambda = -1, generic seed 1 a x l, MOD 67108837, **order 8**. The log must match W3's
   `gen_67108837_-1_1_al` (SP-T6 expected), with the same HISTORY. This step also prints a CALIBRATION speed factor.
6. The obstruction-analysis code path, forced at order 7. The expected verdict is TEST_OBSTRUCTED_CHOICE.

The script ends with `VALIDATION PASS` (exit 0), or `VALIDATION FAIL` (exit 1).
**If validation fails: STOP.** Do not run the main jobs. Commit `results/validation/` to the branch (section 7) and
report the first FAIL line. `run_tasks.py` refuses to start without `results/validation/VALIDATION_PASS`.

## 4. Main jobs

The driver runs any task list in parallel within a CPU budget and a memory budget, so it never oversubscribes RAM:

    python3 run_tasks.py tasks/recommended.csv --cores 30 --mem-gb 185 --mem-safety 1.1 --deadline-min 60 2>&1 | tee results/driver.log
    python3 make_summary.py && python3 check_results.py

* A task file is CSV with the columns `job,lam,p,seed,kind,N,threads`. `kind` is `al`/`la` for a generic direction
  or `exarc_al`/`exarc_la` for an EX-T6 arc.
* A task starts only when (threads in use + its threads) <= `--cores` and (estimated memory in use + its estimate)
  <= `--mem-gb`. The estimates come from `estimate.py`, multiplied by `--mem-safety`.
* A task whose estimate alone exceeds the budget is recorded as NOT_RUN.
* A watchdog kills the most recently started task if MemAvailable drops below 4 GB. That task is recorded as ERROR.
* `--deadline-min M`: no new task starts after M minutes. Tasks that were never started are recorded as NOT_RUN.
* Restarting the same command skips finished tasks.
* Single runs are also possible, for example:

      python3 hodge_job.py --lam -1 --p 67108837 --seed 7 --kind al --N 10 --threads 8 --out results/runs
      python3 run_arc.py 67108837 0 al 14 --threads 8 --out results/runs

**One command per job group (for the job queue, from the repository root).** The driver takes a task file and
an output directory (`--out`). `--validation-dir` defaults to `jobs/cloud-job-1/results/validation`, and the
validation evidence is copied into `<out>/validation`.

| group | command (repository root) | cores | memory GB | est. minutes |
|---|---|---|---|---|
| G0 validate | `jobs/cloud-job-1/validate.sh` | 30 | 4 | 5 |
| G1 generic order 12 | `python3 jobs/cloud-job-1/run_tasks.py jobs/cloud-job-1/tasks/g1_order12.csv --out jobs/queue/results/<id> --cores 22 --mem-gb 120 --mem-safety 1.1` | 22 | 120 | 60 (+-50%) |
| G2 lambda=2 controls | `python3 jobs/cloud-job-1/run_tasks.py jobs/cloud-job-1/tasks/g2_controls_lam2.csv --out jobs/queue/results/<id> --cores 8 --mem-gb 10 --mem-safety 1.1` | 8 | 10 | 5 |
| G3 EX-T6 sparse 13-14 | `python3 jobs/cloud-job-1/run_tasks.py jobs/cloud-job-1/tasks/g3_sparse_exarc.csv --out jobs/queue/results/<id> --cores 8 --mem-gb 60 --mem-safety 1.1` | 8 | 60 | 20 |
| G4 generic order 10 (new seeds) | `python3 jobs/cloud-job-1/run_tasks.py jobs/cloud-job-1/tasks/g4_generic_N10.csv --out jobs/queue/results/<id> --cores 8 --mem-gb 60 --mem-safety 1.1` | 8 | 60 | 45 |
| G5 optional generic order 11 | `python3 jobs/cloud-job-1/run_tasks.py jobs/cloud-job-1/tasks/g5_generic_N11_optional.csv --out jobs/queue/results/<id> --cores 8 --mem-gb 45 --mem-safety 1.1` | 8 | 45 | 50 |

After each group, run `python3 jobs/cloud-job-1/make_summary.py <out>` and then
`python3 jobs/cloud-job-1/check_results.py <out>`.

Suggested concurrency on 30 cores / 200 GB:

* G0 first.
* Then G1 together with G2 (30 cores).
* When G2 ends, start G3, then G4 (G1 + G4 = 30 cores, about 168 GB).
* G5 only if more than 50 min remain.

Task files in `tasks/`:

* `recommended.csv`: the 90-minute plan below.
* `a_generic_lam-1_N11.csv`, `a_generic_lam-1_N12.csv`: seeds 1-12, both primes.
* `a_generic_lam-1_N13_bigmachine.csv`: does NOT fit here.
* `b_control_lam2.csv`: seeds 1-24, both primes.
* `c_sparse_N14.csv`.
* `test_small.csv`: the local test.

Seeds and Segre types: seeds 1-3, 7-9, 13-15 and 19-21 are a x l (`al`); seeds 4-6, 10-12, 16-18 and 22-24 are
l x a (`la`). Seeds 1-6 are W3's directions, and runs of them must reproduce W3's lower-order logs (checked by
`check_results.py`).

### Recommended job list (about 90 min in total on 30 cores / 200 GB)

| order of start | tasks | threads | est. memory | est. wall |
|---|---|---|---|---|
| 0 | `./validate.sh` | 30 | < 2 GB | 3-5 min |
| 1 | **a**: lambda = -1 generic seed 1 (a x l), MOD 67108837, **order 12** (W3 had order 8) | 22 | 98 GB (108 with the safety factor) | about 60 min (+-50%) |
| 2 | **b**: lambda = 2 controls, seeds 1-12, both primes (24 runs) | 1 each | 0.9 GB each | about 1 min each, about 5 min in total on the free cores |
| 3 | **c**: EX-T6 a x l MOD 67108837 to **14**; l x a MOD 67108837, a x l and l x a MOD 67108819 to **13** | 2 each | 6-13 GB | 5-12 min each |
| 4 | **a**: lambda = -1 generic new seeds 7 (al), 10 (la) MOD 67108837 and 8 (al), 11 (la) MOD 67108819, **order 10** | 2 each | 14 GB each | about 45 min each |
| 5 (if time) | **a**: seed 4 (la) MOD 67108819 order 11; EX-T6 a x l MOD 67108819 and l x a MOD 67108837 to 14 | 8 / 2 | 40 / 13 GB | about 50 / 12 min |

The driver starts tasks in this order as soon as cores and memory allow. Memory at peak is about 108 + 4 x 14 + 13
GB, which is under 185 GB.

If the order-12 job has not finished at about 85 minutes, leave it running if the rental allows. Otherwise kill it
(`pkill -f hodge_job.py`). It will then appear as ERROR with exit code -9; write "killed at the time limit" in the
summary. Every completed order is already in its log (lines `ORDER n` / `corrected x_..`).

## 5. Estimates (from `estimate.py`; measured growth, SP-T6 model, +-50%)

The model was calibrated by SP-T6 on a 2-core shared machine with 1 thread. It assumes 12 bytes per stored term
(levels 0..N-2), one extra copy of the largest stored level, and that the top level is streamed. The parallel
efficiency on 30 cores is **not measured** (0.6 is assumed). `validate.sh` prints a CALIBRATION factor f. Then
`python3 estimate.py --speed f` gives the times for this machine.

| job | N | memory | CPU-hours | wall, all 30 cores (eff 0.6) | fits in 200 GB? |
|---|---|---|---|---|---|
| lambda = -1 generic | 10 | 12.6 GB | 1.3 | 4 min | yes |
| lambda = -1 generic | 11 | 36.5 GB | 4.2 | 14 min | yes (4 at a time) |
| lambda = -1 generic | 12 | 97.8 GB | 12.8 | 43 min | yes (ONE at a time) |
| lambda = -1 generic | 13 | **244 GB** | 35.5 | 2.0 h | **NO** |
| lambda = -1 generic | 14 | 570 GB | 92 | 5.1 h | no |
| EX-T6 sparse | 13 | 5.1 GB | 0.13 | < 1 min | yes |
| EX-T6 sparse | 14 | 11.4 GB | 0.34 | 1-2 min | yes |
| EX-T6 sparse | 15 | 24.9 GB | 0.83 | 3 min | yes |
| lambda = 2 control | 6 | 0.8 GB | < 0.01 | about 20-60 s (1 thread) | yes |

Measured on the development machine (2 shared cores, 1-2 threads, nice 10):

* EX-T6 a x l order 11: 83 s.
* Generic order 7: 53 s. Generic order 8: about 200-330 s at 0.3 GB.
* lambda = 2 order 6: 22 s.

**Generic order 13 does not fit in 200 GB.** A 4-byte value-only layout would bring it to about 80 GB. It was NOT
implemented, for two reasons:

* It would not help within this rental anyway: 35 CPU-hours is about 2 h even at perfect use of 30 cores.
* It could not be validated here to produce identical outputs.

The feasible plan for this rental is generic order 12 for one direction, generic order 10-11 for several, and the
sparse EX-T6 arcs to 13-14 (section 4). Generic order 13 needs a bigger machine (>= 256 GB) and about 2-3 h. One way
to get it would be an exact incremental update: for n >= 7 the correction changes E'_(n-3..n-1) only affinely, by
products of 220-term polynomials with E'_(<=2), so the rebuild of three levels per order could be dropped. That
would give about 1.6x, plus the 4-byte layout. Both would need SP-T6-style validation first.

## 6. Output

    results/validation/        validate.log, machine.txt, calibration.txt, VALIDATION_PASS, per-step logs
    results/runs/<tag>.log     one log per run (one block per order; RESULT / ANALYSIS / HISTORY / DIGEST / VERDICT lines)
    results/runs/<tag>.json    sidecar: verdict, order reached, runtime, peak RSS, engine version, digests
    results/runs/arc_<tag>.npy, exarc_*_N*.npy   final arc mod p (a few kB)
    results/runs/obstr_*.pkl   only if an EX-T6 arc obstructs (small)
    results/manifest.csv       job, lambda, prime, seed, kind, order_requested, order_reached, verdict, runtime_s,
                               peak_rss_gb, code_commit (git rev-parse HEAD), engine_version, threads, log, arc_digest, note
    results/summary.md         headline + table (make_summary.py)
    results/driver.log         driver output (if you tee it as above)

The verdicts are:

* EXTENDS: the arc was extended to the requested order.
* OBSTRUCTED_GENUINE, OBSTRUCTED_CHOICE, OBSTRUCTED_UNRESOLVED: see section 1.
* NOT_RUN: over the memory budget, or past the deadline.
* ERROR: a crash, out of memory, or killed.

`check_results.py` validates the manifest and logs, including the reproduction of the W3 lower-order logs for
seeds 1-6. It must print `CHECK PASS`.

## 7. Committing the results (branch `cloud-job-1`)

    cd <repo>
    git checkout -B cloud-job-1
    python3 jobs/cloud-job-1/make_summary.py; python3 jobs/cloud-job-1/check_results.py | tail -5
    find jobs/cloud-job-1/results -size +50M          # must print nothing; delete or leave out anything listed
    git add jobs/cloud-job-1/results
    git commit -m "cloud-job-1 results: <headline from summary.md, incl. any lambda = -1 obstruction FIRST>"
    git push -u origin cloud-job-1

* Commit only under `jobs/cloud-job-1/results/`, and only small files: logs, the manifest, the summary, the JSON
  sidecars, and the `.npy`/`.pkl` arcs (kB each; never above 50 MB).
* Do not commit `build/`.
* Never commit secrets: tokens, SSH keys, `.env`, cloud credentials, `~/.gitconfig`. `results/` contains none
  unless you put them there. `machine.txt` has only `uname`, the CPU count and memory.
* Do not change code or reference files on this branch. If something had to be changed to run at all, say so in the
  commit message and in `summary.md`.

## 8. Files

| file | role |
|---|---|
| `validate.sh` | validation (section 3) |
| `hodge_job.py` | generic directions, lambda = -1 and 2 (W3 gen_dirs / SP-T6 run_job logic + obstruction analysis) |
| `run_arc.py` | EX-T6 sparse arcs (SP-T6 remote_job/run_arc.py; only the engine path changed) |
| `run_tasks.py` | parallel driver with CPU and memory budget, manifest |
| `estimate.py` | resource model |
| `check_expected.py` | line-by-line log comparison, ignoring timings (SP-T6) |
| `check_results.py`, `make_summary.py` | result checking and summary |
| `hodge_build.py` | builds `build/libfsc.so` once |
| `inputs/` | `mc_<p>_lam<lambda>.json` (T Cone_T conditions mod p), `dir_*.json` (W3 directions, for validation), `exarc_*.json`, `primes.json` |
| `reference/` | stored logs and arcs: SP-T6 expected logs, W3 logs (`w3_*`) |
| `tasks/` | task lists |
| `dev/export_mc.py` | how `inputs/mc_*.json` were made (needs the discovery checkout; not for the cloud machine) |
