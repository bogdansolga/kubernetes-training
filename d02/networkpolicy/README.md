# NetworkPolicy — Day 2 / lecture S09

By default every Pod can talk to every other Pod. A **NetworkPolicy** restricts that. This one
makes Postgres reachable on `:5432` **only** from the SkyHop backend (and the backup CronJob).

```bash
# prereq: Postgres running (../statefulset); a CNI that enforces policy (kind's kindnet does)
kubectl apply -f postgres-networkpolicy.yml

# a backend-labelled Pod CAN reach Postgres:
kubectl run probe-be --rm -i --image=busybox:1.36 --labels app=skyhop-be \
  --restart=Never -- nc -z -w3 postgres 5432      # succeeds

# a Pod without the label CANNOT:
kubectl run probe-x --rm -i --image=busybox:1.36 \
  --restart=Never -- nc -z -w3 postgres 5432      # times out
```

> Selectors match by **label**, so teams must agree on Pod labels: the policy also admits the
> backup CronJob's Pods (`app: skyhop-db-backup`), otherwise the nightly backup would be blocked.
