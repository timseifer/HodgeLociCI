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

lambda = -1: 10 run(s) EXTEND to their requested order (highest order reached: 10).
A finite order is evidence only; it cannot prove that a component exists (checks/w4 REPORT.md).

## All runs

| job | lambda | prime | seed | kind | N req | N reached | verdict | runtime s | peak RSS GB | note |
|---|---|---|---|---|---|---|---|---|---|---|
| a | -1 | 67108837 | 13 | al | 10 | 10 | EXTENDS | 3429.7 | 12.281 | arc to order 10 |
| a | -1 | 67108819 | 14 | al | 10 | 10 | EXTENDS | 3429.3 | 12.283 | arc to order 10 |
| a | -1 | 67108819 | 16 | la | 10 | 10 | EXTENDS | 3456.4 | 12.28 | arc to order 10 |
| a | -1 | 67108837 | 15 | al | 10 | 10 | EXTENDS | 3458.6 | 12.281 | arc to order 10 |
| a | -1 | 67108837 | 17 | la | 10 | 10 | EXTENDS | 3384.2 | 12.28 | arc to order 10 |
| a | -1 | 67108819 | 18 | la | 10 | 10 | EXTENDS | 3383.7 | 12.281 | arc to order 10 |
| a | -1 | 67108837 | 19 | al | 10 | 10 | EXTENDS | 3384.7 | 12.284 | arc to order 10 |
| a | -1 | 67108819 | 20 | al | 10 | 10 | EXTENDS | 3390.1 | 12.281 | arc to order 10 |
| a | -1 | 67108837 | 21 | al | 10 | 10 | EXTENDS | 3469.3 | 12.452 | arc to order 10 |
| a | -1 | 67108819 | 22 | la | 10 | 10 | EXTENDS | 3472.0 | 12.281 | arc to order 10 |

code_commit: ['2fddbb1717c7fc5f6140b24f18db79f74096b656']; engine_version: ['8e8d1b39e4f3']

## Operator note (cloud lead): wrap-up

The driver was stopped at 16:00:10Z (operator decision to wrap up and shut the machine down; SIGTERM to the driver
only). The 2 tasks already running were left to finish; they completed normally and wrote their own logs and sidecar
JSON, but have NO manifest row: seeds 23 la (MOD 67108837) and 24 la (MOD 67108819): both EXTENDS to order 10
(~3220 s, 12.3 GB each). Total: 12 of 28 directions EXTEND to order 10 (10 in the manifest + these 2). The other 16
tasks were never started; rerunning the same command would run exactly those 16.
