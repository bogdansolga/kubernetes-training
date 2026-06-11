# DaemonSet — Day 2 / lecture 5.2

A **DaemonSet** ensures one Pod runs on **every node** (or every node matching a selector) —
the pattern for node-level agents: log collectors, metrics exporters, CNI, storage drivers.
It is cluster infrastructure, so it stays app-agnostic (not a SkyHop tier).

```bash
kubectl apply -f node-agent-daemonset.yml
kubectl get pods -o wide -l app=node-agent     # one per node (incl. control-plane, via the toleration)
kubectl get daemonset node-agent
```

> As you add or remove nodes, the DaemonSet automatically adds/removes its Pod there.
