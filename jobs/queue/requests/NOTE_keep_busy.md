# Note from the coordinator (07:20Z 24 Nov) - please act on your next poll

About 9 cores have been idle since R013 finished (07:02Z): only R020 (20 threads) and R015 (1 core) are running.
Per the keep-busy rule (jobs/queue/README.md, Tim: the instance bills hourly regardless of load) please start NOW:

1. R021 with its CURRENT command (re-read jobs/queue/requests/R021.yaml): `--cores 6 --mem-gb 30` (each order-9 task
   peaks at about 3.5 GB). It does not need to wait for R015.
2. If cores remain (3 left), nothing else fits exactly; that is fine. When R020 finishes, start R017, R016, R018, R019,
   R011 by priority, packing cores and memory.

Memory check: R020 about 130 GB + R015 (requested 16 GB, likely much less) + R021 30 GB = 176 GB < 180 GB.
If the measured free memory says otherwise, report it in status/R021.json and start R021 with --cores 4 --mem-gb 20.
