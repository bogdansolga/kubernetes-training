# Monitoring — Day 3 (stretch) / observability

The node-exporter DaemonSet (`../../d02/daemonset`) emits per-node metrics; **kube-state-metrics**
turns the state of Kubernetes *objects* (pods, deployments, **HPAs**, …) into metrics. This lab adds
the **scrape + visualize** layer with plain manifests (no operator):

```
node-exporter      :9100  (per node)   ─┐
kube-state-metrics :8080  (objects/HPA) ─┼─▶  Prometheus :9090  (scrape + store)  ─▶  Grafana :3000
```

| File(s) | |
|---|---|
| `node-exporter-service.yml` | headless Service so Prometheus discovers every node-exporter via DNS |
| `ksm-serviceaccount.yml` · `ksm-clusterrole.yml` · `ksm-clusterrolebinding.yml` | RBAC: read-only access for kube-state-metrics |
| `ksm-deployment.yml` · `ksm-service.yml` | kube-state-metrics (object/HPA metrics on :8080) |
| `prometheus-config.yml` · `prometheus-deployment.yml` · `prometheus-service.yml` | Prometheus (scrapes node-exporter + kube-state-metrics) |
| `grafana-config.yml` · `grafana-deployment.yml` · `grafana-service.yml` | Grafana with the Prometheus datasource pre-provisioned |
| `grafana-ingress.yml` | exposes Grafana at `http://skyhop.local/grafana` (separate Ingress, same host as the FE) |

## Run

```bash
# 1) node-exporter (per-node metrics)
kubectl apply -f ../../d02/daemonset/node-exporter-daemonset.yml
kubectl apply -f node-exporter-service.yml

# 2) kube-state-metrics (object + HPA metrics)
kubectl apply -f ksm-serviceaccount.yml -f ksm-clusterrole.yml -f ksm-clusterrolebinding.yml \
               -f ksm-deployment.yml -f ksm-service.yml

# 3) Prometheus + Grafana
kubectl apply -f prometheus-config.yml -f prometheus-deployment.yml -f prometheus-service.yml
kubectl apply -f grafana-config.yml -f grafana-deployment.yml -f grafana-service.yml -f grafana-ingress.yml
kubectl rollout status deploy/kube-state-metrics
kubectl rollout status deploy/prometheus
kubectl rollout status deploy/grafana
```

> If you edit `prometheus-config.yml` after Prometheus is running, reload it with
> `kubectl rollout restart deploy/prometheus` (Prometheus reads its config at startup).

## Using Grafana

```bash
open http://skyhop.local/grafana        # via the shared ingress (needs 127.0.0.1 skyhop.local in /etc/hosts)
# …or: kubectl port-forward svc/grafana 3000:3000  → http://localhost:3000
```

1. **Login: `admin` / `admin`** (click *Skip* when asked to change it — demo only).
2. The **Prometheus datasource is already wired**.
3. **Dashboards → Import** by ID:
   - **`1860`** — *Node Exporter Full* (CPU / memory / disk / network per node).
   - **`13332`** — *Kube State Metrics v2* (pods, deployments, jobs, HPAs, …).
4. Or **Explore** and type a metric (`node_`, `kube_`) to autocomplete.

## Watching the HorizontalPodAutoscaler

kube-state-metrics exposes the HPA's own numbers, so you can chart a scale event. With the
autoscaling lab running (`../autoscaling`) and load applied (`../autoscaling/load-test.sh 150`),
query these in **Explore** (or build a panel):

```promql
kube_horizontalpodautoscaler_status_current_replicas{horizontalpodautoscaler="skyhop-be"}   # what it's at
kube_horizontalpodautoscaler_status_desired_replicas{horizontalpodautoscaler="skyhop-be"}   # what it wants
kube_horizontalpodautoscaler_spec_min_replicas{horizontalpodautoscaler="skyhop-be"}         # floor (2)
kube_horizontalpodautoscaler_spec_max_replicas{horizontalpodautoscaler="skyhop-be"}         # ceiling (6)
kube_deployment_status_replicas{deployment="skyhop-be"}                                      # actual Pods
```

Put *current* vs *desired* vs *max* on one graph, run the load test, and watch the line climb from 2
to 6 and back down — the HPA in motion.

## Potential improvement — pod CPU/memory via cAdvisor (not included)

node-exporter gives *node* CPU and KSM gives the HPA's *replica counts*, which already tell the
scaling story. To also chart **per-pod CPU/memory** (the raw signal the HPA reacts to), scrape
**cAdvisor**, which is built into every kubelet at `/metrics/cadvisor`. It's a heavier add because
Prometheus must authenticate to the kubelet, so it's left as an optional extension:

1. **Give Prometheus a ServiceAccount + RBAC** — a `ServiceAccount`, a `ClusterRole` with
   `get` on `nodes`, `nodes/metrics`, `nodes/proxy` (and the `/metrics` nonResourceURL), and a
   `ClusterRoleBinding`; then set `serviceAccountName: prometheus` on the Deployment.
2. **Add a scrape job** that discovers nodes and scrapes cAdvisor through the API-server proxy
   (uses the SA's bearer token + CA — no kubelet TLS headaches):

   ```yaml
   - job_name: kubernetes-cadvisor
     scheme: https
     tls_config:
       ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
     bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
     kubernetes_sd_configs:
       - role: node
     relabel_configs:
       - target_label: __address__
         replacement: kubernetes.default.svc:443
       - source_labels: [__meta_kubernetes_node_name]
         target_label: __metrics_path__
         replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
   ```

3. Then query per-pod usage, e.g.:
   ```promql
   sum by (pod) (rate(container_cpu_usage_seconds_total{pod=~"skyhop-be.*"}[1m]))
   sum by (pod) (container_memory_working_set_bytes{pod=~"skyhop-be.*"})
   ```

> All of this (cAdvisor + node-exporter + KSM + dashboards + alerting) is what the
> **kube-prometheus-stack** Helm chart wires up automatically — see the production note below.

## Production note

On real clusters the easy path is the **kube-prometheus-stack** Helm chart (Prometheus Operator +
Grafana + node-exporter + kube-state-metrics + cAdvisor + alerting + ready-made dashboards):
`helm install kps prometheus-community/kube-prometheus-stack`. This lab is the hand-built minimal
version so each piece is visible. *(Demo creds `admin/admin` — never do that in production.)*
