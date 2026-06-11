# Services — Day 1 / lecture 3.5

A Service gives a set of Pods a stable address and load-balances across them, matched by
**labels** (not Pod names). Two ways to expose the SkyHop frontend:

| File | Type | Reach |
|---|---|---|
| `skyhop-fe-service-clusterip.yml` | ClusterIP | in-cluster only (how the Ingress reaches the FE) |
| `skyhop-fe-service-nodeport.yml` | NodePort | a fixed port on every node, from outside |

```bash
kubectl apply -f skyhop-fe-service-clusterip.yml
kubectl get svc skyhop-fe -o wide
kubectl get endpoints skyhop-fe        # the FE Pods this Service is load-balancing
```

> ClusterIP is the default and what the course uses everywhere; the Ingress (next) routes to it.
