# Deployments — Day 1 / lecture 3.4

A Deployment manages a replicated, self-healing set of Pods and handles rolling updates.
Here, the two SkyHop app tiers — each with **2 replicas**, **resource requests/limits**, and
**readiness/liveness probes** (the health-check lesson, folded in).

| File | |
|---|---|
| `skyhop-be-deployment.yml` | backend — probes on the Spring Boot actuator endpoints |
| `skyhop-fe-deployment.yml` | frontend — probes on `/api/health` |

```bash
kubectl apply -f skyhop-be-deployment.yml -f skyhop-fe-deployment.yml
kubectl get deploy,pods
kubectl rollout status deployment/skyhop-be
```

> Probes decide when a Pod is *ready* for traffic (readiness) and when to restart it (liveness).
> The backend reports both on its actuator health endpoints.

## Rollout strategies

How a new version replaces the old is a choice. See **[`deployment-strategies.md`](deployment-strategies.md)**
for all six (rolling, recreate, blue/green, canary, A/B, shadow). The two that are pure
`Deployment.spec.strategy` are runnable here:

| File | Strategy |
|---|---|
| `strategy-rolling.yml` | RollingUpdate (gradual, zero-downtime) — the default |
| `strategy-recreate.yml` | Recreate (stop all, then start new — brief downtime) |
