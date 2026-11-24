# cloud-job-1 results (AI-generated computation, MOD p, not reviewed by a human)

Validation: PASS (Tue Nov 24 02:50:42 UTC 2026)

Machine:

```
Linux 129-153-231-100 6.8.0-1064-nvidia #67~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Sep 17 21:53:31 UTC 2 x86_64 x86_64 x86_64 GNU/Linux
30
               total        used        free      shared  buff/cache   available
Mem:             222           1         219           0           2         219
Swap:              0           0           0
Python 3.10.12
numpy 1.21.5
g++ (Ubuntu 11.4.0-1ubuntu1~22.04.3) 11.4.0
```

## Headline

**ATTENTION: 1 lambda = -1 run(s) did NOT extend to the requested order** (see the table; verdicts OBSTRUCTED_GENUINE / OBSTRUCTED_CHOICE / OBSTRUCTED_UNRESOLVED / ERROR are explained in README.md).
A finite order is evidence only; it cannot prove that a component exists (checks/w4 REPORT.md).

## All runs

| job | lambda | prime | seed | kind | N req | N reached | verdict | runtime s | peak RSS GB | note |
|---|---|---|---|---|---|---|---|---|---|---|
| a | -1 | 67108837 | 1 | al | 12 | 0 | ERROR | 2536.8 | 0 | exit code -9: ORDER 11 : K.c_m nonzero for m < n: []  K.c_n nnz 54 (2275s) |    x_8 effect rank 16, equals DG4(v): True; |

code_commit: ['1361aef15a889545373b126f8de0d453f7cba664']; engine_version: ['1f4eeb9d39c7']

## Operator note (cloud lead)

The ERROR row (exit code -9) is NOT an obstruction and NOT an out-of-memory kill: the cloud lead killed the run
(SIGKILL to the hodge_job.py PID only) at 03:33:49Z, killed at the time limit in effect: order 11 had completed
(ORDER 11: K.c_m = 0 for m < 11; x_8 effect rank 16 = DG4(v); K.c_11 in Im DG4(v): True, corrected), and order 12
(E'_11 about 3x E'_10, which alone took 1161 s) could not finish before the 100-minute budget ends (04:28:33Z).
So the lambda = -1 generic direction seed 1 (a x l, MOD 67108837) survives to order 11 (W3 had order 8); order 12 untested.
Peak RSS observed by the lead before the kill: about 71 GB (the sidecar records 0 because the process was killed).
