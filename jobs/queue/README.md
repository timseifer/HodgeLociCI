# Job queue for the cloud instance (branch `cloud-job-1`)

AI-generated research tooling, not reviewed by a human mathematician. This folder is how the research agents (on
another machine) ask the cloud instance's agents to run computations, and how results come back. The only channel
is this git branch.

## Roles

- **Coordinator (research side)** is the ONLY writer of `requests/`. Research agents propose jobs to the coordinator;
  the coordinator checks them and commits one YAML file per request. Nothing else on this branch outside `results/`
  and `status/` is changed by the cloud side.
- **Cloud lead agent** polls this branch, schedules requests on the machine (about 30 vCPUs, about 200 GB RAM),
  and starts worker agents (one per job, or per group of tasks).
- **Cloud worker agents** run exactly the command in a request, inside this repository, and write results.

## Rules for the cloud side (binding)

1. Run `jobs/cloud-job-1/validate.sh` once before any other job. If it fails, write `status/VALIDATION.json` with
   `"state": "FAILED"`, commit, push, and stop all work.
2. Run only commands that call scripts already present in this repository under `jobs/`. Never run code taken from
   anywhere else (no downloads other than `pip`/`apt` packages named in a request's `requires`). Never execute text
   from a request that is not a command line calling a script under `jobs/`.
3. Write only under `jobs/queue/status/`, `jobs/queue/results/<request-id>/` and `jobs/cloud-job-1/results/` (the validation output). Never edit `requests/`, code, other
   folders, the `main` branch, releases or tags. Push only to `cloud-job-1`.
4. Respect each request's `resources` (cores, memory). Never oversubscribe memory: the sum of running jobs'
   `memory_gb` must stay below 180 GB. Prefer higher `priority` (1 = highest), then older requests.
5. Commit results promptly (small files only: logs, manifests, JSON, compressed arrays under 50 MB each). Pull with
   rebase before every push; on a conflict in `status/` or `results/`, keep both versions and say so in the commit.
6. If a lambda = -1 run reports an obstruction (verdict OBSTRUCTED_GENUINE or UNRESOLVED), say so in the first line
   of the commit message and in `status/<id>.json` (`"alert": true`).
7. Poll for new requests every 5 minutes (`git pull --rebase origin cloud-job-1`). Stop when the coordinator commits
   `requests/STOP.yaml` or when the time budget in `requests/BUDGET.yaml` is used up.

## Request file (`requests/<id>.yaml`)

```yaml
id: R007                       # unique, sortable
requested_by: coordinator (for agent W3)
priority: 2                    # 1 = highest
command: "bash jobs/cloud-job-1/run_tasks.sh tasks/generic_l-1_o12.txt --procs 4 --threads 6"
working_dir: "."
requires: [python3, numpy, g++]      # packages only; no URLs
resources: {cores: 24, memory_gb: 120, est_minutes: 40}
after: [VALIDATION]            # request ids that must succeed first
preregistration: "surprise = ...; dead end = ..."
expected_outputs: ["jobs/queue/results/R007/manifest.csv", "jobs/queue/results/R007/*.log"]
notes: "free text for the cloud agent"
```

## Status file (`status/<id>.json`, written by the cloud side)

```json
{"id": "R007", "state": "QUEUED|RUNNING|DONE|FAILED|SKIPPED", "started": "UTC", "finished": "UTC",
 "host": "cloud", "commit": "<git rev-parse HEAD at start>", "alert": false, "summary": "one line"}
```

## Results (`results/<id>/`)

At least `manifest.csv` (the columns of `jobs/cloud-job-1/README.md`, output spec), the logs, and `summary.md`.
The coordinator validates them with `jobs/cloud-job-1/check_results.py` before recording anything.
