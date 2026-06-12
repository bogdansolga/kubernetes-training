# DaemonSet — Day 2 / lecture 5.2

A **DaemonSet** ensures one Pod runs on **every node** (or every node matching a selector) — the
pattern for **node-level agents**. SkyHop's tiers are replica-scaled (Deployments / StatefulSet), so a
DaemonSet is *never* a SkyHop tier; it is cluster infrastructure.

Here it runs the Prometheus **node-exporter** — each node's CPU/memory/disk/network metrics on `:9100`.

```bash
kubectl apply -f node-exporter-daemonset.yml
kubectl rollout status daemonset/node-exporter
kubectl get pods -o wide -l app=node-exporter      # one per node (incl. control-plane, via the toleration)

# scrape a node's metrics (hostNetwork -> the Pod IP is the node IP):
IP=$(kubectl get pod -l app=node-exporter -o jsonpath='{.items[0].status.podIP}')
kubectl run m --rm -i --image=curlimages/curl:8.11.1 --restart=Never -- curl -s $IP:9100/metrics | grep -m3 '^node_'
```

> Other real DaemonSet use-cases: **log shippers** (Fluent Bit / Vector), **CSI node plugins** (the
> per-node half of a storage driver), **CNI / kube-proxy**, and **security/audit agents** (Falco).
> As nodes are added or removed, the DaemonSet adds/removes its Pod automatically.
