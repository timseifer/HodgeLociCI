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

**ATTENTION: 2 lambda = -1 run(s) did NOT extend to the requested order** (see the table; verdicts OBSTRUCTED_GENUINE / OBSTRUCTED_CHOICE / OBSTRUCTED_UNRESOLVED / ERROR are explained in README.md).
lambda = -1: 10 run(s) EXTEND to their requested order (highest order reached: 10).
A finite order is evidence only; it cannot prove that a component exists (checks/w4 REPORT.md).

## All runs

| job | lambda | prime | seed | kind | N req | N reached | verdict | runtime s | peak RSS GB | note |
|---|---|---|---|---|---|---|---|---|---|---|
| a | -1 | 67108819 | 61 | al | 10 | 10 | EXTENDS | 3473.1 | 12.28 | arc to order 10 |
| a | -1 | 67108837 | 62 | al | 10 | 10 | EXTENDS | 3473.9 | 12.281 | arc to order 10 |
| a | -1 | 67108819 | 63 | al | 10 | 10 | EXTENDS | 3416.4 | 12.418 | arc to order 10 |
| a | -1 | 67108837 | 64 | la | 10 | 10 | EXTENDS | 3425.2 | 12.301 | arc to order 10 |
| a | -1 | 67108819 | 65 | la | 10 | 10 | EXTENDS | 3359.8 | 12.281 | arc to order 10 |
| a | -1 | 67108837 | 66 | la | 10 | 10 | EXTENDS | 3360.9 | 12.281 | arc to order 10 |
| a | -1 | 67108819 | 67 | al | 10 | 10 | EXTENDS | 3471.0 | 12.28 | arc to order 10 |
| a | -1 | 67108837 | 68 | al | 10 | 10 | EXTENDS | 3470.0 | 12.3 | arc to order 10 |
| a | -1 | 67108819 | 69 | al | 10 | 10 | EXTENDS | 3367.4 | 12.32 | arc to order 10 |
| a | -1 | 67108837 | 70 | la | 10 | 10 | EXTENDS | 3367.9 | 12.304 | arc to order 10 |
| a | -1 | 67108819 | 71 | la | 10 | 0 | ERROR | 995.1 | 0 | exit code -9:    x_6 effect rank 16, equals DG4(v): True; K.c_n in Im DG4(v): True (731s) |    E'_6: 32119851 terms (18s |
| a | -1 | 67108837 | 72 | la | 10 | 0 | ERROR | 983.1 | 0 | exit code -9:    x_6 effect rank 16, equals DG4(v): True; K.c_n in Im DG4(v): True (736s) |    E'_6: 32119852 terms (17s |

code_commit: ['f01e395f73640e5ba83c0266512774caacdac162']; engine_version: ['1f4eeb9d39c7', '8e8d1b39e4f3']

## Operator note (cloud lead)

The two ERROR rows (seeds 71, 72; exit -9) are NOT obstructions: the cloud lead killed these two runs at 16:13Z on the
operator's (Tim's) decision to shut the machine down (wrap-up). Both had completed order 9 (ORDER 9: K.c_m = 0 for
m < 9, K.c_n nnz 54; x_6 effect rank 16 = DG4(v); K.c_9 in Im DG4(v): True) and were in the order-10 rebuild.
