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
| a | -1 | 67108819 | 4 | la | 11 | 0 | ERROR | 736.8 | 0 | exit code -9:    E'_6: 32119852 terms (9s) (399s) |    E'_7: 129026199 terms (61s) (460s) |    E'_8: 447156064 terms (26 |

code_commit: ['15b96b51565524faa9206d4a72afcdbef15dd047']; engine_version: ['1f4eeb9d39c7']

## Operator note (cloud lead)

The ERROR row (exit code -9) is NOT an obstruction and NOT an out-of-memory kill: the cloud lead killed the run
(SIGKILL to its hodge_job.py PID only) at 03:46:49Z, on the operator's (Tim's) decision, to free 8 cores so that
R001 (order 12, priority 2) could start. At that point orders up to 9 had completed: ORDER 9: K.c_m = 0 for m < 9,
x_6 effect rank 16 = DG4(v), K.c_9 in Im DG4(v): True. So lambda = -1 generic seed 4 (l x a, MOD 67108819)
survives to order 9 in this run; orders 10-11 untested here.
