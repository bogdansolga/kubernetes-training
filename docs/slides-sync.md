# Slides sync — align the Google Slides with the SkyHop labs

**Purpose.** The hands-on labs were rebuilt around one cohesive running example, **SkyHop** (see the
repo `CLAUDE.md` and `timeline.html`). The lecture **Google Slides** now need to match. The user
edits the slides; this doc is the **full context + change-list** for a future Claude Code session to
draft that content. Claude can't edit Google Slides directly — produce the **slide text/bullets per
deck**, and the user pastes them in.

## Source of truth

- **The labs are canonical.** For each deck, open its matching `dNN/<lab>/` folder — the `README.md`
  (what it teaches) and the manifests (the exact example) — and mirror them on the slide using the
  **same names and values** (`skyhop-fe`, `skyhop-be`, `postgres`, `BACKEND_URL=http://skyhop-be:8080`,
  ports 3000/8080/5432).
- Deck list + links live in **`Kubernetes training.md`** (the Google Slides URLs).
- Reusable diagrams: the capstone repo's `diagrams/skyhop-{architecture,topology,team-split}.svg`.
- Conventions/gotchas to keep consistent: repo `CLAUDE.md`.

## Global changes (every deck)

1. **Introduce SkyHop once, early** — add a slide in **S02** ("the app we'll deploy together"),
   reuse `skyhop-topology.svg`. Then every topic deck shows *its* concept on the matching SkyHop
   component, so slide and lab share one vocabulary.
2. **Reuse the capstone diagrams** in the architecture/services/ingress decks.
3. **Modernize any API shown on a slide** — no `extensions/v1beta1`, `batch/v1beta1`,
   `autoscaling/v1`; use current GA versions.
4. Add a footer/callout on each resource deck: **"Hands-on: `dNN/<lab>/`"**.

## Per-deck change-list (deck → lab → what to show)

| Deck | Lab | Put on the slide |
|---|---|---|
| S01 orchestration overview | — | closing slide: "the app we'll build — SkyHop (FE + BE + Postgres)" |
| S02 K8s intro/architecture | — | NEW slide introducing SkyHop; reuse `skyhop-topology.svg` |
| 3.1 Cluster/Nodes/Control Plane | — | SkyHop pods scheduled on a node |
| 3.2 Objects/API/Namespaces | `d01/namespace` | the `skyhop` namespace as the worked example |
| 3.3 Pods | `d01/pod` | `skyhop-be`/`skyhop-fe` as Pods; QoS classes (Guaranteed/Burstable/BestEffort) |
| **3.3.1 Pods scheduling** | `d03/scheduling` | nodeSelector · node affinity (hard/soft, operators) · pod affinity/anti-affinity · taints/tolerations · PriorityClass. **Note: this topic's lab now lives in Day 3** (advanced) |
| 3.4 Deployments | `d01/deployment` | 2 replicas, requests/limits, probes. **+ new "Deployment strategies" deck** from `deployment-strategies.md` (rolling, recreate, blue/green, canary, A/B, shadow — which are native vs need a controller/mesh) |
| 3.5 Services & Labels | `d01/service` | `skyhop-fe` ClusterIP + NodePort; label selectors |
| 3.6 Ingress & NetworkPolicy | `d01/ingress`, `d02/networkpolicy` | `skyhop-fe` Ingress (host `skyhop.local`); Postgres-lockdown NetworkPolicy; reuse `skyhop-architecture.svg`. Forward-pointer to **Gateway API** + **TLS termination** (below) |
| S04 imperative/declarative | `d01/imperative-declarative` | the same `skyhop-fe` applied both ways |
| 5.1 Stateful | `d02/statefulset` | Postgres StatefulSet + `volumeClaimTemplates` + the **pg18 `PGDATA`** gotcha |
| 5.2 DaemonSet | `d02/daemonset` | a node-level agent; note it's cluster infra, not a SkyHop tier |
| S06 Persistence | `d02/volumes` | PV/PVC/StorageClass, static vs dynamic. **Add: CSI (Ceph RBD, NFS) + access modes RWO/RWX** |
| 7.1 ConfigMap + Downward API | `d02/config-map` | the `BACKEND_URL` contract + BE datasource + Downward API |
| 7.2 Secrets | `d02/secrets` | `skyhop-db-secret` (DB user/password), env vs mounted |
| 8.1 Job | `d02/job` | one-off DB seed/migration Job |
| 8.2 CronJob | `d02/cronjob` | nightly `pg_dump` backup |
| S09 Networking | `d02/networkpolicy` | lock Postgres `:5432` to `skyhop-be`; kindnet enforces it |
| S10 Autoscaling | `d03/autoscaling` | HPA on `skyhop-be`, **`autoscaling/v2`** (CPU+memory); mention `load-test.sh`; VPA contrast |
| 11.1 Quotas | `d03/resource-quota` | ResourceQuota (compute + object counts) + LimitRange on `skyhop` ns |
| 11.2 RBAC | `d03/roles` | scoped `skyhop-deployer` Role + least-privilege `skyhop-viewer` ClusterRole (drop wildcards) |
| **11.3 Node maintenance / 11.4 HA** | `d03/cluster-upgrade` | NEW content: **cluster upgrade cadence** (frequent/small vs infrequent/large jumps) + tradeoffs table; cordon/drain/uncordon; **PodDisruptionBudget** keeps SkyHop available during a drain |
| S12 Helm | `d03/helm` | a chart packaging the `skyhop-fe` component (Chart/values/templates) |
| **(NEW) Gateway API** | `d03/gateway-api` | Ingress successor; role-oriented (GatewayClass/Gateway/HTTPRoute). **Versions: Gateway API v1.5.0, NGINX Gateway Fabric v2.6.3, min K8s 1.26.** Place after 3.6 / S09 |
| **(NEW, stretch) TLS termination** | `d03/tls-termination` | where TLS terminates (shared edge, once, managed cert — not per-app); Caddy `tls internal` demo; Ingress `spec.tls` + Gateway HTTPS listener equivalents |
| **(removed)** Logging/ELK | — | drop the obsolete ELK slides; at most one conceptual observability slide (`kubectl logs`/stdout/sidecars) |

## Facts/versions to put on slides (verified in the labs)

- Images: `bogdansolga/skyhop-{be,fe}:0.1`, `postgres:18-alpine`.
- pg18 needs `PGDATA=/var/lib/postgresql/data/pgdata` (subPath `pgdata`).
- HPA: `autoscaling/v2`, scales on utilisation vs **requests**; needs metrics-server
  (`--kubelet-insecure-tls` on kind).
- Gateway API CRDs **v1.5.0** + **NGINX Gateway Fabric v2.6.3**, min K8s **1.26**.
- NetworkPolicy is enforced by **kindnet** on the training cluster.
- Deployment strategies: **rolling + recreate** are native (`Deployment.spec.strategy`); blue/green &
  canary are patterns; A/B & shadow need ingress canary annotations / a service mesh.
- TLS cert is selected by **SNI** (test with `curl --resolve`, not a `Host:` header).

## How a future session should work

1. Read this doc + repo `CLAUDE.md` + `Kubernetes training.md` (deck links).
2. For each deck, open the matching `dNN/<lab>/README.md` + manifests.
3. Draft the slide bullets/code-snippets mirroring that lab (same names/values), plus the
   global changes above.
4. Hand the per-deck drafts to the user to paste into Google Slides. (If a Google Slides MCP/tool is
   available in that session, apply directly; otherwise output text.)
