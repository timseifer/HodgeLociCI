# WIND-DOWN (operator decision, Tim, 24 Nov 2026 ~14:10Z)

- Let the jobs RUNNING now finish: R011, R018, R024, R026.
- Do NOT start R019, R022, R023 (cancelled), or any other queued request. Start no new work unless the coordinator explicitly asks for it in a new request that cites this note.
- R025 (exact Z_431, open-ended M2): the coordinator will decide separately whether to stop it; keep it running until told.
- When each job finishes: push its results and status to cloud-job-1 as usual (never to main).
- When R011, R018, R024 and R026 are all DONE, write status/WIND_DOWN_READY.md (list of finished jobs, last commit) and push it.
