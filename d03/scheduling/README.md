# Pod scheduling — Day 3 / lecture 3.3.1

How the scheduler decides *which node* runs a Pod, and how to influence it — all on `skyhop-be`.

| File | Teaches |
|---|---|
| `priority-class.yml` + `skyhop-be-priority.yml` | a `PriorityClass` and a Pod that uses it (preemption) |
| `node-selector.yml` | `nodeSelector` — simplest node constraint (exact label match) |
| `node-affinity.yml` | node affinity — expressions + `required` (hard) / `preferred` (soft) |
| `pod-affinity.yml` | pod affinity (co-locate near postgres) + anti-affinity (spread for HA) |
| `taints-tolerations.yml` | a toleration for a node taint that reserves a node |

## Prerequisites (label / taint a node)

```bash
# pick a schedulable node (on kind, the worker)
NODE=$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o name | head -1)

kubectl label $NODE disktype=ssd                       # for node-selector / node-affinity
kubectl taint  $NODE dedicated=skyhop:NoSchedule       # for taints-tolerations
```

## Run

```bash
kubectl apply -f priority-class.yml -f skyhop-be-priority.yml
kubectl apply -f node-selector.yml -f node-affinity.yml -f pod-affinity.yml -f taints-tolerations.yml

kubectl get pods -o wide                                # see which node each landed on
kubectl get pod skyhop-be-priority -o jsonpath='{.spec.priority}{"\n"}'
```

## Cleanup (restore the node)

```bash
kubectl label $NODE disktype-                          # remove the label
kubectl taint $NODE dedicated=skyhop:NoSchedule-       # remove the taint (trailing '-')
```

> **nodeSelector** is the simplest rule (exact match, no OR). **Node affinity** adds expressions
> (`In`/`NotIn`/`Exists`/`Gt`/`Lt`) and soft vs hard rules. **Pod affinity/anti-affinity** schedule
> relative to other Pods (co-location vs spreading). **Taints/tolerations** are the inverse —
> the *node* repels Pods unless they explicitly tolerate it.
