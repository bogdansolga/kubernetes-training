# Stateful applications — Day 2 / lecture 5.1

A **StatefulSet** runs Pods that need a stable network identity and their own persistent storage —
exactly what a database needs. Here it's the SkyHop **Postgres**.

| File | |
|---|---|
| `postgres-service.yml` | the **headless Service** (`clusterIP: None`) for stable per-Pod DNS |
| `postgres-statefulset.yml` | the StatefulSet — `volumeClaimTemplates` + the **pg18 `PGDATA`** fix |

```bash
kubectl apply -f postgres-service.yml -f postgres-statefulset.yml
kubectl rollout status statefulset/postgres
kubectl get pods,pvc -l app=postgres        # postgres-0 + its own PVC

# data survives a Pod restart (it lives on the PVC):
kubectl exec statefulset/postgres -- psql -U flights -d flights -c 'select 1;'
kubectl delete pod postgres-0               # the StatefulSet recreates it, same PVC
```

> **pg18 gotcha:** `postgres:18-alpine` defaults `PGDATA` to a version dir that collides with the
> mounted volume and aborts the entrypoint — so we point `PGDATA` *inside* the mount
> (`/var/lib/postgresql/data/pgdata`, via `subPath: pgdata`).
