# Jobs — Day 2 / lecture 8.1

A **Job** runs a Pod (or several) until it **completes successfully**, then stops — for batch work:
backups, migrations, seeds, one-off imports. Here: a one-off **DB backup** (`pg_dump`).

```bash
# prereq: Postgres is running (see ../statefulset)
kubectl apply -f db-backup-job.yml
kubectl wait --for=condition=complete job/skyhop-db-backup --timeout=120s
kubectl logs job/skyhop-db-backup               # "backup OK: N lines, M bytes" + the dump head
```

> `backoffLimit` caps retries; `ttlSecondsAfterFinished` auto-deletes the finished Job. The same
> backup on a **schedule** is a CronJob (../cronjob) — that one writes to a persistent volume.
> (Jobs also suit one-off migrations and seeds.)
