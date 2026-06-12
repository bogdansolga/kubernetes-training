# CronJob — Day 2 / lecture 8.2

A **CronJob** creates a Job on a cron schedule. Here: a nightly `pg_dump` backup of the SkyHop
database into a PVC.

| File | |
|---|---|
| `backup-pvc.yml` | the volume the dumps are written to |
| `backup-cronjob.yml` | the CronJob (`0 18 * * *`) that runs `pg_dump` |

```bash
# prereq: Postgres is running (see ../statefulset)
kubectl apply -f backup-pvc.yml -f backup-cronjob.yml

# don't wait until 18:00 — trigger an on-demand run now:
kubectl create job --from=cronjob/skyhop-db-backup backup-now
kubectl wait --for=condition=complete job/backup-now --timeout=120s
kubectl logs job/backup-now
```

> `concurrencyPolicy: Forbid` skips a run if the previous one is still going. The PVC stays
> `Pending` until the first backup Pod schedules — that's `WaitForFirstConsumer`, not a bug.
> The same backup **once, on demand** is the Job in ../job (or `kubectl create job --from=cronjob/...`).
