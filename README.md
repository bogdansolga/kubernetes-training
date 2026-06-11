# Kubernetes training

Hands-on Kubernetes labs built around **one cohesive running example — SkyHop**, a small
flight-booking app (Next.js frontend `skyhop-fe`, Spring Boot backend `skyhop-be`, Postgres
database). Every lab builds one piece of SkyHop, so by Day 3 the cluster runs the app you then
assemble — as teams — in the capstone.

Open **[`timeline.html`](timeline.html)** for a visual map of every lab across the three days.

## Layout

- **`d01` — Edge & objects:** namespace · pod · deployment (+ `deployment-strategies.md`) · service ·
  ingress · imperative/declarative
- **`d02` — State, config, jobs & network:** statefulset · daemonset · volumes (PV/PVC/StorageClass +
  CSI) · config-map · secrets · job · cronjob · networkpolicy · (legacy) replication-controller
- **`d03` — Scale, admin & package:** scheduling · autoscaling · resource-quota · roles (RBAC) ·
  cluster-upgrade · helm · gateway-api · tls-termination *(stretch)*

Each lab folder has its own `README.md` (what it teaches + how to run it). Manifests are **one
resource per file**, on the `bogdansolga/skyhop-*` images.

## Cluster

A **kind** cluster with ingress-nginx (host `80/443`) and metrics-server. The app is reachable at
`http://skyhop.local` once `127.0.0.1 skyhop.local` is in `/etc/hosts` (or send a
`Host: skyhop.local` header). Some labs add their own prerequisites — see each folder's README
(e.g. node labels for scheduling, the Gateway API CRDs + NGINX Gateway Fabric for `gateway-api`).

## Capstone

The labs are the **vocabulary**; the **capstone** is the **sentence** — there you assemble the full,
wired-up SkyHop yourself, split into two teams, staged `v0 → v1`, plus stretch goals.
