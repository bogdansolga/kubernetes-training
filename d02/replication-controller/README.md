# ReplicationController (legacy) — Day 2

The **ReplicationController** (RC) is the original way to keep N Pod replicas running. It has been
superseded by **Deployments**, which add rolling updates, rollbacks and revision history (via
ReplicaSets). Kept here for historical context — **prefer a Deployment** (../../d01/deployment).

```bash
kubectl apply -f skyhop-fe-rc.yml
kubectl get rc skyhop-fe-rc
kubectl delete rc skyhop-fe-rc
```
