# Jobs — Day 2 / lecture 8.1

A **Job** runs a Pod (or several) until it **completes successfully**, then stops — for batch work:
migrations, seeds, one-off imports. Here: seed the SkyHop database.

```bash
# prereq: Postgres is running (see ../statefulset)
kubectl apply -f db-seed-job.yml
kubectl wait --for=condition=complete job/skyhop-db-seed --timeout=120s
kubectl logs job/skyhop-db-seed                # ... rows | 1
```

> `backoffLimit` caps retries; `ttlSecondsAfterFinished` auto-deletes the finished Job. A Job that
> runs on a *schedule* is a CronJob (../cronjob).
