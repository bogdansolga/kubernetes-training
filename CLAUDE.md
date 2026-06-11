# CLAUDE.md — Kubernetes training (hands-on labs)

Context for Claude Code working in this repo. Read this first. For the visual map of every lab,
open **`timeline.html`** in a browser.

## What this is

Participant-facing **hands-on Kubernetes labs** for a 3-day course, built around **one cohesive
running example — SkyHop**, a tiny flight-booking app. Every lab teaches *one* Kubernetes resource on
a SkyHop component, so by Day 3 the cluster runs the app participants then assemble — as teams — in
the **capstone**.

- The **instructor solution / capstone** lives in a **separate** repo:
  `~/Development/Projects/kubernetes-capstone-project` (private). The cohesion design + plan is there:
  `docs/proposals/training-cohesion-plan.md`.
- GitHub: `bogdansolga/kubernetes-training`. Default branch **`master`**.

## The running example — SkyHop

- **skyhop-fe** — Next.js frontend, port **3000**, health `/api/health`. Image `bogdansolga/skyhop-fe:0.1`.
- **skyhop-be** — Spring Boot backend, port **8080**, health `/actuator/health/{readiness,liveness}`.
  Image `bogdansolga/skyhop-be:0.1`. v0 = default profile (**H2 in-memory**, no DB → runs standalone).
- **postgres** — `postgres:18-alpine`, DB + user **`flights`**.
- Cross-team contract: FE reads `BACKEND_URL=http://skyhop-be:8080`; BE reads
  `SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/flights`.
- Namespace **`skyhop`** is used where a lab needs one; most labs run in `default` for isolation.

## Day / folder layout

- **`d01` — Edge & objects:** namespace · pod · deployment (+ `deployment-strategies.md`) · service ·
  ingress · imperative-declarative
- **`d02` — State, config, jobs & network:** statefulset · daemonset · volumes · config-map ·
  secrets · job · cronjob · networkpolicy · replication-controller *(legacy exhibit)*
- **`d03` — Scale, admin & package:** scheduling · autoscaling (+ `load-test.sh`) · resource-quota ·
  roles (RBAC) · cluster-upgrade · helm · gateway-api · tls-termination *(stretch)*

Every lab folder has its own `README.md` (what it teaches + how to run it).

## Conventions — HARD constraints (keep consistent)

- **One Kubernetes resource per file.** Split multi-resource manifests (e.g. Service + StatefulSet →
  two files; PVC + CronJob → two files).
- **Building blocks only.** Each lab teaches ONE resource in *isolation*; **never ship a fully-wired,
  end-to-end working SkyHop here** — assembling it is the capstone's job. Facts the participant brief
  discloses (the `skyhop-*` names, `BACKEND_URL`, the pg18 `PGDATA` requirement, resource values) are
  fair game; the assembled solution manifest set is **not**.
- **Namespace-less by default** — most labs apply into `default` so each runs standalone; the
  `namespace`, `resource-quota` and `roles` labs use `skyhop`.
- Header comment on each manifest: `# Day N · lecture X.Y — <concept>`.
- **Pin every image tag.** Use `bogdansolga/skyhop-{be,fe}:0.1` and `postgres:18-alpine` — no bare
  `nginx`/`busybox`. Modern apiVersions only (no `extensions/v1beta1`, `batch/v1beta1`,
  `autoscaling/v1`).
- When you add or finish a lab, **update `timeline.html`** — flip the card's status dot to done and
  bump the day count + the top-nav counter. Palette matches the capstone diagrams (FE=blue `#1d4ed8`,
  BE=green `#15803d`, DB=amber `#a16207`, shared=slate `#475569`).

## Cluster & verification

- **kind** cluster `kind-cluster`, context **`kind-kind-cluster`**. Create it with the host 80/443
  mappings from the capstone's `k8s-reference/optional-ingress/kind-cluster.yaml`; install
  ingress-nginx (`controller-v1.12.1`) and metrics-server.
- App reachable at **http://skyhop.local** (needs `127.0.0.1 skyhop.local` in `/etc/hosts`, or
  `curl -H 'Host: skyhop.local'`).
- **Verify every deployable on the real cluster, then clean up** to keep it pristine (recreate with
  `kind delete/create` when a fresh slate is wanted). `skyhop` images pull from Docker Hub, or
  `kind load docker-image`.

### Gotchas (learned the hard way — keep these in mind)

- `postgres:18-alpine` needs **`PGDATA=/var/lib/postgresql/data/pgdata`** (mount at
  `/var/lib/postgresql/data`, `subPath: pgdata`) — pg18 aborts otherwise.
- **metrics-server on kind** needs the `--kubelet-insecure-tls` arg (else the `/readyz` probe can't
  scrape the kubelets over self-signed TLS and the pod stays NotReady). Then `kubectl top` works.
- **HPA** needs container `requests` **and** metrics-server. Drive load with
  `d03/autoscaling/load-test.sh <concurrent-users> [duration]`.
- **NetworkPolicy IS enforced** by kindnet on this cluster (the lab's deny test really denies).
- **Gateway API:** standard-channel CRDs **v1.5.0** + **NGINX Gateway Fabric v2.6.3**; min K8s
  **1.26**. NGF provisions a data-plane `svc/skyhop-gateway-nginx`; test via `kubectl port-forward`.
- **TLS / Caddy:** the cert is chosen by **SNI**, not the `Host:` header — test with
  `curl --resolve skyhop.local:PORT:IP ...` (a `-H 'Host:'` against `localhost` fails the handshake).

## Commits

Bracket prefixes `[feat]`/`[fix]`/`[doc]`/`[refactor]`/`[chore]`. End the body with
`Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`.

## Memory

`~/.claude/projects/-Users-bsolga-Development-Projects-kubernetes-capstone-project/memory/training-repo-cohesion.md`
records the cross-repo cohesion effort and that the training repo is now actively maintained.
