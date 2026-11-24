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

lambda = -1: 4 run(s) EXTEND to their requested order (highest order reached: 10).
A finite order is evidence only; it cannot prove that a component exists (checks/w4 REPORT.md).

## All runs

| job | lambda | prime | seed | kind | N req | N reached | verdict | runtime s | peak RSS GB | note |
|---|---|---|---|---|---|---|---|---|---|---|
| a | -1 | 67108837 | 2 | al | 10 | 10 | EXTENDS | 3317.1 | 12.281 | arc to order 10 |
| a | -1 | 67108837 | 3 | al | 10 | 10 | EXTENDS | 3323.3 | 12.43 | arc to order 10 |
| a | -1 | 67108837 | 5 | la | 10 | 10 | EXTENDS | 3479.9 | 12.487 | arc to order 10 |
| a | -1 | 67108837 | 6 | la | 10 | 10 | EXTENDS | 3481.5 | 12.28 | arc to order 10 |

code_commit: ['d470043fd3be38c7f9e6fb7fcb7aa2982cd5359d']; engine_version: ['8e8d1b39e4f3']

## Operator note (cloud lead): check_results.py prints CHECK FAIL (4 problems) - checker artifact, not a data mismatch

All 4 runs EXTEND to order 10. The 4 "problems" are the comparison with W3's stored ORDER-8 logs
(reference/w3_sp8_67108837_s{2,3,5,6}_*.log): for every seed, expected lines 1-28 (all of orders 4-8, including
"ORDER 8 ... K.c_n nnz 54" and "x_5 effect rank 16, equals DG4(v): True; K.c_n in Im DG4(v): True") are reproduced
exactly; the first mismatch is expected line 29, "final order: corrected x_5, K.c_m = 0 (m = 2..8) by the exact affine
formula", which W3's run printed only because order 8 was its FINAL order. An order-10 run continues to order 9 at
that point, so this line (and the HISTORY/DIGEST/peak RSS lines that follow it) cannot appear there. Full checker
output: check_results.txt. No code was changed.
