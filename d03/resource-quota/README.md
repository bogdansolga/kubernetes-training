# Resource quotas & limits — Day 3 / lecture 11.1

Cluster admins cap what a namespace may consume. Scoped here to the `skyhop` namespace.

| File | |
|---|---|
| `resource-quota.yml` | total CPU/memory the namespace may request & limit |
| `object-counts.yml` | max number of ConfigMaps, Secrets, PVCs, Services, Pods |
| `limit-range.yml` | default requests/limits for containers that omit them |

```bash
kubectl create namespace skyhop --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f resource-quota.yml -f object-counts.yml -f limit-range.yml
kubectl -n skyhop describe quota          # USED vs HARD
kubectl -n skyhop describe limitrange skyhop-defaults
```

> With a ResourceQuota in place, every Pod must declare requests/limits — the LimitRange fills in
> defaults so Pods aren't rejected for omitting them.
