# Cloud session report: branch cloud-job-1 (INTERIM, updated 2026-11-24 ~13:50Z)

AI-run computations (cloud lead + worker agents), not reviewed by a human. All arithmetic MOD p. A finite order never
proves that a component exists. This file is updated while the session runs; the final version replaces it.

Machine: 30 vCPU (Intel Xeon Platinum 8358, KVM), 222 GB RAM, Ubuntu 22.04, Python 3.10.12, numpy 1.21.5, g++ 11.4.
Macaulay2 1.22 via the repository's Docker image `hodgelocici` (installation authorised directly by the operator, Tim;
Ubuntu 22.04's apt only has 1.19.1, the requests pin 1.22).

## Headline

* **lambda = -1, generic seed 1 (a x l) EXTENDS to order 12 at BOTH primes** (R001 MOD 67108837, R020 MOD 67108819;
  identical HISTORY: orders 5-12 corrected x2..x9, the last one affine; K.c_n nnz 54 at every order). W3 had order 8.
* Every lambda = -1 run that completed EXTENDS: no OBSTRUCTED_GENUINE / CHOICE / UNRESOLVED anywhere.
  New generic directions: 4 (R004) + 4 W3 (R017) to order 10; 48 H1 directions to order 9 (R010 + R021).
  EX-T6 sparse arcs: to order 13-14 (R003) and 15 (R016), both types, both primes.
* Controls: lambda = 2 is OBSTRUCTED_GENUINE at order 6 in all 24 + 96 runs (R002, R007). Of 26 other lambda values
  only -1 and 1 extend to order 7 (R006).
* Macaulay2 scans (R013, R014): every smooth point ALL DIE or SINGULAR, no ALERT (expected dead end). The exact
  Z_431 check (R015) timed out without a verdict; R025 reruns it with no limit.
* Two lambda = -1 rows are ERROR, both caused by the lead killing a run on purpose, NOT obstructions (alert set per rule):
  R001 attempt 1 (killed after order 11 at the original time limit; then rerun to order 12 with the operator's
  approval) and R005 (killed after order 9 by operator decision to free cores for R001).

## Requests

| id | what | state | verdict | start - end (UTC) | wall | peak RSS/run |
|---|---|---|---|---|---|---|
| R000 | validate.sh | DONE | VALIDATION PASS (steps 0-6) | 02:48 - 02:50 | 2.1 min | < 2 GB |
| R001 | generic s1 al p37 to N12 | DONE | attempt 1 ERROR (killed after order 11); rerun **EXTENDS 12** | 02:51 - 03:34; 03:47 - 05:59 | 42 + 132 min | 117.8 GB |
| R002 | lambda=2 controls s1-12 | DONE | 24/24 OBSTRUCTED_GENUINE at 6 | 02:51 - 02:53 | 1.4 min | 0.27 GB |
| R003 | EX-T6 sparse to 13-14 | DONE | 6/6 EXTENDS | 02:54 - 03:29 | 35 min | 13.1 GB |
| R004 | generic new seeds 7,8,10,11 to N10 | DONE | 4/4 EXTENDS | 03:29 - 05:27 | 118 min | 12.2 GB |
| R005 | generic s4 la p19 to N11 | DONE | ERROR (killed after order 9; operator decision) | 03:34 - 03:47 | 12 min | n/a |
| R006 | other lambdas, order 7 | DONE | only -1, 1 extend; 26 values OBSTRUCTED_GENUINE | 03:34 - 03:40 | 5 min | 0.35 GB |
| R007 | lambda=2 controls s13-60 | DONE | 96/96 OBSTRUCTED_GENUINE | 03:34 - 03:45 | 11 min | 0.27 GB |
| R008, R009, R012 | M2 jobs | SKIPPED | macaulay2 not authorised at the time (re-queued as R013-R015) | - | - | - |
| R010 | H1 48 seeds to N9 | DONE | 8 EXTENDS, 40 NOT_RUN (old --deadline-min 50, lead error) | 05:28 - 06:19 | 51 min | 3.5 GB |
| R013 | M2 sextic scan | DONE | 468 OK + 4 TIMEOUT; ALL DIE 561, SINGULAR 111; no ALERT | 06:00 - 07:02 | 62 min | < 8 GB cap |
| R014 | M2 retry scan | DONE | 106 OK; ALL DIE 129, SINGULAR 18; no ALERT | 03:41 - 03:46 | 5 min | < 8 GB cap |
| R015 | exact Z_431 (QQ) | DONE | TIMEOUT, no verdict (old timeout arg, lead error) | 06:00 - 12:26 | 386 min | < 16 GB cap |
| R016 | EX-T6 sparse to 15 | DONE | 4/4 EXTENDS | 09:11 - 10:38 | 87 min | 29.4 GB |
| R017 | W3 seeds 2,3,5,6 to N10 | DONE | 4/4 EXTENDS (CHECK FAIL = checker artifact, see its summary.md) | 09:11 - 11:05 | 114 min | 12.5 GB |
| R020 | generic s1 al p19 to N12 | DONE | **EXTENDS 12**, same HISTORY as R001 | 06:53 - 09:11 | 138 min | 116.6 GB |
| R021 | H1 remaining 40 seeds to N9 | DONE | 40/40 EXTENDS | 07:28 - 13:31 | 362 min | 3.5 GB |
| R011 | H2 replication 48 seeds to N9 | RUNNING | so far all EXTENDS | 09:30 - | | |
| R018 | 28 new seeds to N10 | RUNNING | so far all EXTENDS | 10:39 - | | |
| R024 | 12 new seeds to N10 | RUNNING | so far all EXTENDS | 11:12 - | | |
| R025 | exact Z_431 rerun, no limit | RUNNING | | 12:38 - | | |
| R026 | seeds 73-75 to N10 | RUNNING | | 13:43 - | | |
| R019, R022, R023 | N11 / N12 seed 4 | QUEUED | need 16 / 20 cores; wait for running jobs | - | - | - |

## Deviations and lead errors (all also in the per-request status files)

* Budget: the original 100-minute limit was replaced by the coordinator (per Tim) with no time limit; Tim also approved
  directly the longer time for the R001 order-12 rerun.
* The lead started R010, R013 and R015 with commands that had been superseded in the request files (deadline /
  timeout removed at 03:46Z). Effects: R010 left 40 seeds NOT_RUN (re-queued and completed as R021); R013 no effect;
  R015 timed out (re-queued as R025). R020 was started with --cores 22 instead of 20 (no effect). Since then the lead
  re-reads each request file immediately before starting it.
* M2 runs use the documented `--m2` / third-argument Docker invocation, with a per-container `--memory` cap. With
  Docker, m2scan's per-type timeout kills only the client; the lead stopped the 4 orphaned containers of R013's
  timed-out types right after each TIMEOUT.
* check_results.py is not applicable to R006 (fractional lambda; the request says so) or to the M2 group (no manifest).
