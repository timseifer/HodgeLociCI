# Cloud session report: branch cloud-job-1 (FINAL, 2026-11-24, 02:48Z - 16:21Z)

AI-run computations (cloud lead + worker agents), not reviewed by a human. All arithmetic MOD p
(p = 67108837 or 67108819) unless stated. A finite order never proves that a component of the Hodge locus exists.

Machine: 30 vCPU (Intel Xeon Platinum 8358, KVM), 222 GB RAM, Ubuntu 22.04, Python 3.10.12, numpy 1.21.5, g++ 11.4.
Macaulay2 1.22 via the repository's Docker image `hodgelocici` (installation authorised directly by the operator, Tim;
Ubuntu 22.04's apt only has 1.19.1 and the requests pin 1.22). Highest machine memory in use observed: ~163 GB
(05:18Z, R001 order 12 + R004).

Session ended by the operator's wind-down (requests/NOTE_wind_down.md, ~14:10Z) and wrap-up decision (~16:00Z):
no new starts, R025 stopped, nearly finished runs allowed to finish, the rest left unstarted (each can be resumed by
rerunning its command unchanged: finished tasks are skipped).

## Headline

* **lambda = -1, generic seed 1 (a x l) EXTENDS to order 12 at BOTH primes** (R001 MOD 67108837, R020 MOD 67108819).
  Identical HISTORY: orders 5-12 corrected x2..x9 (12 affine); K.c_n nnz 54 at every order; E'_11 = 9.87e9 terms.
  W3 had order 8. (This is order 12, not the preregistered order 13: generic order 13 needs ~244 GB.)
* **No lambda = -1 run obstructed anywhere** (no OBSTRUCTED_GENUINE / CHOICE / UNRESOLVED). Generic directions that
  EXTEND: 4 W3 directions (seeds 2, 3, 5, 6) and 29 new ones to order 10 (R004 4, R017 4, R018 12, R024 10,
  R026 3); 48 new H1 directions to order 9 (R010 + R021) and 40 of them replicated at the other prime (R011).
  EX-T6 sparse arcs (both types, both primes): orders 13-14 (R003) and 15 (R016).
* **Controls:** lambda = 2 OBSTRUCTED_GENUINE at order 6 in 24 + 96 runs (R002, R007). Among 28 lambda values at
  order 7 (R006) only lambda = -1 and 1 extend.
* **Macaulay2 scans (T6c):** sextic (R013, 472 types) and retry (R014, 106 types): every smooth point ALL DIE or
  SINGULAR; no ALERT (the expected dead end). 4 sextic types timed out (1800 s cap).
* **Exact Z_431 check over QQ:** no verdict. R015 (386 min, old 90-min timeout) and R025 (215 min, stopped at
  wrap-up) produced no output; the QQ computation is essentially single-threaded.
* **lambda = -1 ERROR rows (alert set per rule) are all deliberate kills by the lead, NOT obstructions:** R001
  attempt 1 (after order 11; then rerun to order 12 with the operator's approval), R005 (after order 9, operator
  decision), R024 seeds 71, 72 (after order 9, operator wrap-up).

## Requests

| id | what | state | verdict | UTC | wall | peak RSS/run |
|---|---|---|---|---|---|---|
| R000 | validate.sh | DONE | VALIDATION PASS (steps 0-6) | 02:48-02:50 | 2.1 min | < 2 GB |
| R001 | generic s1 al p37 to N12 | DONE | attempt 1 ERROR (killed after 11); rerun **EXTENDS 12** | 02:51-03:34; 03:47-05:59 | 42 + 132 min | 117.8 GB |
| R002 | lambda=2 controls s1-12 | DONE | 24/24 OBSTRUCTED_GENUINE at 6 | 02:51-02:53 | 1.4 min | 0.27 GB |
| R003 | EX-T6 sparse to 13-14 | DONE | 6/6 EXTENDS | 02:54-03:29 | 35 min | 13.1 GB |
| R004 | generic seeds 7, 8, 10, 11 to N10 | DONE | 4/4 EXTENDS | 03:29-05:27 | 118 min | 12.2 GB |
| R005 | generic s4 la p19 to N11 | DONE | ERROR (killed after order 9; operator decision) | 03:34-03:47 | 12 min | n/a |
| R006 | other lambdas, order 7 | DONE | only -1, 1 extend; 26 values OBSTRUCTED_GENUINE | 03:34-03:40 | 5 min | 0.35 GB |
| R007 | lambda=2 controls s13-60 | DONE | 96/96 OBSTRUCTED_GENUINE | 03:34-03:45 | 11 min | 0.27 GB |
| R008, R009, R012 | M2 jobs | SKIPPED | macaulay2 not authorised then (re-queued as R013-R015) | - | - | - |
| R010 | H1 48 seeds to N9 | DONE | 8 EXTENDS, 40 NOT_RUN (old --deadline-min, lead error) | 05:28-06:19 | 51 min | 3.5 GB |
| R011 | H2 replication 48 seeds to N9 | DONE (wrap-up) | 40 EXTENDS, 8 never started | 09:30-16:21 | 6.8 h | 3.5 GB |
| R013 | M2 sextic scan | DONE | 468 OK + 4 TIMEOUT; ALL DIE 561, SINGULAR 111; no ALERT | 06:00-07:02 | 62 min | < 8 GB cap |
| R014 | M2 retry scan | DONE | 106 OK; ALL DIE 129, SINGULAR 18; no ALERT | 03:41-03:46 | 5 min | < 8 GB cap |
| R015 | exact Z_431 (QQ) | DONE | TIMEOUT, no verdict (old timeout arg, lead error) | 06:00-12:26 | 386 min | < 16 GB cap |
| R016 | EX-T6 sparse to 15 | DONE | 4/4 EXTENDS | 09:11-10:38 | 87 min | 29.4 GB |
| R017 | W3 seeds 2, 3, 5, 6 to N10 | DONE | 4/4 EXTENDS (CHECK FAIL = checker artifact, see its summary.md) | 09:11-11:05 | 114 min | 12.5 GB |
| R018 | 28 new seeds to N10 | DONE (wrap-up) | 12 EXTENDS, 16 never started | 10:39-16:21 | 5.7 h | 12.3 GB |
| R019, R022, R023 | N11 / N12 seed 4 | SKIPPED | cancelled by the operator's wind-down | - | - | - |
| R020 | generic s1 al p19 to N12 | DONE | **EXTENDS 12**, same HISTORY as R001 | 06:53-09:11 | 138 min | 116.6 GB |
| R021 | H1 remaining 40 seeds to N9 | DONE | 40/40 EXTENDS | 07:28-13:31 | 362 min | 3.5 GB |
| R024 | 12 new seeds to N10 | DONE (wrap-up) | 10 EXTENDS; 71, 72 ERROR (killed after order 9) | 11:12-16:13 | 5 h | 12.2 GB |
| R025 | exact Z_431 rerun, no limit | DONE (stopped) | no verdict; stopped at wrap-up after 215 min | 12:38-16:13 | 215 min | ~5.4 GB |
| R026 | seeds 73-75 to N10 | DONE | 3/3 EXTENDS | 13:43-15:40 | 117 min | 12.2 GB |

## Deviations and lead errors (details in the per-request status files and summary.md notes)

* Budget: the original 100-minute limit was replaced by the coordinator (per Tim) with no time limit; Tim approved
  directly the longer time for the R001 order-12 rerun, the Macaulay2 installation, stopping R005, and the wrap-up.
* The lead started R010, R013 and R015 with commands that had been superseded in the request files (deadline /
  timeout removed at 03:46Z). Effects: R010 left 40 seeds NOT_RUN (completed as R021); R013 none; R015 timed out
  (rerun as R025). R020 was started with --cores 22 instead of 20 (no effect). The lead then re-read each request
  immediately before starting it.
* The lead noticed the wind-down note (~14:05Z) only at ~15:15Z (it arrived inside the lead's own pull and the poller
  missed it); nothing had been started in between.
* M2 runs use the documented `--m2` / third-argument Docker invocation with a per-container `--memory` cap. With
  Docker, a per-type timeout kills only the client; the lead stopped the 4 orphaned containers of R013's timed-out
  types.
* At wrap-up the R011/R018 drivers were stopped (SIGTERM to the driver only); their 7 running tasks finished
  normally and are recorded by sidecar JSON (not in manifest.csv), listed in the summary.md notes.
* check_results.py does not apply to R006 (fractional lambda) or to the M2 group (no manifest). R017 prints
  CHECK FAIL only because its order-10 runs cannot print the "final order" line of W3's order-8 reference logs;
  lines through order 8 reproduce exactly.

## Not done / suggested next steps (for the coordinator)

* The cloud side writes only under jobs/queue/ and jobs/cloud-job-1/results/, so nothing was added to
  discoveries/registry.yaml (AGENTS.md asks for entries for new findings): that is for the coordinator.
* Generic order 13 (the preregistered SURPRISE / DEAD END order) does not fit in 222 GB (~244 GB estimate); it needs
  a bigger machine or the validated 4-byte layout described in jobs/cloud-job-1/README.md section 5.
* Unfinished: R011 (8 seeds), R018 (16 seeds), R024 (seeds 71, 72 to order 10), R019/R022/R023, exact Z_431
  (likely needs a different method, e.g. multimodular, as new validated code).
