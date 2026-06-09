# SkyHop Capstone — Design

**Date:** 2026-06-09
**Status:** Approved (brainstorming) — pending implementation plan
**Scope:** Phase 1 only. Phase 2 (refactoring all existing course examples to map onto these apps) is explicitly deferred.

## Purpose

Provide the Kubernetes training with a genuinely end-to-end, two-service app that participants
deploy as their last-day capstone. Two teams (FE and BE) own their services independently and
collaborate on the Kubernetes resources. The apps must be a *better integrated* e2e project than
the existing `d03/our-project` demo (which crams nodejs+java+postgres into a single Deployment);
here the services are separately deployable, talk over a real REST contract, seed data, persist
purchases, and expose health endpoints.

## Decisions (locked during brainstorming)

- **Deliverables:** both apps + Docker images pushed to Docker Hub + participant requirements brief
  + 1–2 architecture diagrams + a complete **instructor reference k8s solution** (separate folder).
- **Auth:** none. Every buyer is "Guest". Keeps focus on Kubernetes.
- **Registry:** `bogdansolga/skyhop-fe:1.0` and `bogdansolga/skyhop-be:1.0`
  (requires `docker login` when pushing).
- **Resource allocations & stretch acceptance criteria:** authored here (see below).
- **Location:** new `capstone/` folder inside the `kubernetes-training` repo.
- **BE persistence:** `dev` profile uses H2 (zero local setup); `k8s` profile uses Postgres from env.

## Architecture (Approach A — FE as a pure API client)

The REST contract is the team boundary. FE holds **zero business logic and zero database** — it only
renders and forwards. BE owns the contract, seeds routes, and persists purchases to Postgres.

**Kubernetes networking reality:** in-cluster the browser cannot reach the BE ClusterIP — only the FE
is exposed (via Ingress). So the FE's *server side* performs all BE calls:

- Server components fetch `GET /api/routes` at request time.
- The Buy button invokes **one thin FE server action** that forwards to `POST .../purchases`.

The FE reads the BE URL from a **ConfigMap** (`BACKEND_URL=http://skyhop-be:8080`) — the single
cross-team handshake. Keeping the BE internal is also exactly what the stretch NetworkPolicy enforces.

```
Browser → Ingress → FE Service → FE pods ──(ConfigMap BACKEND_URL)──▶ BE Service → BE pods → Postgres Service → StatefulSet+PVC
                                                                         ▲                         ▲
                                                              ConfigMap (db name) ───────── Secret (user/password)
CronJob (18:00) ── pg_dump ──▶ backup volume                  NetworkPolicy: Postgres ingress only from BE pods
```

## The e2e loop (app behavior)

User opens FE → sees ~6–8 seeded routes (flight number, origin → destination, departure, price,
**seats left**). Clicks **Buy** on a route → one seat is booked → confirmation with a **booking
reference** appears and seats-left decrements. When a route reaches 0 seats, Buy is disabled.

### Data model (BE / Postgres)

- `flight_route` — `id, flight_number, origin, destination, departure_time, price, seats_total, seats_available`
- `purchase` — `id, route_id (FK), booking_reference, passenger_name ('Guest'), purchased_at`

On Buy: BE creates a `purchase`, generates a booking reference (e.g. `BK-XXXXXX`), and decrements
`seats_available` if `> 0` (reject with a clear error otherwise).

### REST contract (BE)

- `GET /api/routes` → list of routes with live `seatsAvailable`
- `POST /api/routes/{id}/purchases` → books 1 seat; returns `{ bookingReference, route }`
- `GET /api/purchases` → list (demo/verification)
- `GET /actuator/health/liveness`, `GET /actuator/health/readiness` → for k8s probes

## Tech stacks (mirror the reference projects under ~/Development/Projects/refs)

### Backend — `skyhop-be`
- Spring Boot 4.0, Java 21. Starters: Web, Data JPA, Actuator + PostgreSQL driver (+ H2 for dev).
- Layered like `reference-spring-boot-project`: `controller / service / domain.model /
  domain.repository / dto / config`. No Spring Security (no auth).
- Profiles: `dev` (H2 in-memory) and `k8s` (Postgres from env:
  `SPRING_DATASOURCE_URL/USERNAME/PASSWORD` or discrete DB host/port/name vars).
- A `CommandLineRunner` seeds `flight_route` rows if the table is empty.
- `application.yml` exposes actuator health with liveness/readiness probe groups.
- Multi-stage Dockerfile: `maven:3.9-eclipse-temurin-21` (build) → `eclipse-temurin:21-jre` (run),
  JVM `-Xmx512m`, EXPOSE 8080.
- Image: `bogdansolga/skyhop-be:1.0`.

### Frontend — `skyhop-fe`
- Next.js 16 / React 19 / Tailwind 4 / TypeScript. Layered like `reference-next-js-project` minus
  the DB layer (no Drizzle/SQLite). A `services`/`lib` layer wraps BE calls; types mirror the BE DTOs.
- Server component renders the routes list (fetches `${BACKEND_URL}/api/routes`).
- One server action handles Buy (forwards to BE), then revalidates the list.
- A lightweight health route (e.g. `GET /api/health` or `HEAD /`) for k8s probes.
- Multi-stage Dockerfile using Next standalone output, EXPOSE 3000.
- Image: `bogdansolga/skyhop-fe:1.0`.

## Instructor reference k8s solution + participant responsibilities

All resources live in a `skyhop` namespace. The reference solution is complete and known-good;
participants author their own manifests against the brief.

**Core — BE team:**
- Postgres `StatefulSet` (postgres:16) + headless `Service` + PVC via `volumeClaimTemplates` (1Gi)
- Postgres `ConfigMap` (db name) + `Secret` (user/password)
- BE `Deployment` (2 replicas) — DB env from ConfigMap+Secret, resource requests/limits,
  liveness/readiness probes → actuator
- BE `Service` (ClusterIP, internal only)

**Core — FE team:**
- FE `Deployment` (2 replicas) — `BACKEND_URL` from ConfigMap, resource requests/limits, probes
- FE `Service` + `Ingress` (the only externally exposed surface)
- The `BACKEND_URL` ConfigMap — the cross-team collaboration point

**Stretch (invited):**
- `CronJob` `0 18 * * *` → `pg_dump` to a backup PVC, credentials from the Secret
- `NetworkPolicy` → Postgres accepts ingress **only** from BE pods (`app=skyhop-be`); deny all else

### Resource allocations (sized for minikube / kind / Docker Desktop)

| Component | requests (cpu / mem) | limits (cpu / mem) |
|---|---|---|
| FE (Node) | 100m / 128Mi | 500m / 256Mi |
| BE (JVM, `-Xmx512m`) | 250m / 512Mi | 1000m / 768Mi |
| Postgres | 100m / 256Mi | 500m / 512Mi |

### Stretch acceptance criteria

- **CronJob backup:** a Job triggered on schedule `0 18 * * *` runs `pg_dump` against the Postgres
  Service using credentials from the Secret and writes a timestamped dump to a backup volume;
  a manually-triggered run (`kubectl create job --from=cronjob/...`) produces a non-empty dump file.
- **NetworkPolicy:** a test pod *not* labeled `app=skyhop-be` cannot open a TCP connection to the
  Postgres Service; a BE pod can. Default-deny ingress to Postgres otherwise.

## Diagrams (2 SVGs, in the master-claude-code-course style)

1. **Runtime architecture** — full request path, ConfigMap/Secret wiring, CronJob backup, and the
   NetworkPolicy ring around Postgres. Color-coded by team (FE / BE / shared).
2. **Team split + Buy sequence** — resource ownership per team, the ConfigMap handshake, the stretch
   goals, and the Buy request flow (browser → FE → BE → Postgres → booking reference).

## Folder layout

```
capstone/
  README.md                  # overview + build/push instructions
  skyhop-fe/         # Next.js app + Dockerfile
  skyhop-be/         # Spring Boot app + Dockerfile
  k8s-reference/             # instructor solution
    00-namespace.yaml
    postgres-*.yaml  be-*.yaml  fe-*.yaml  ingress.yaml
    stretch/ cronjob-backup.yaml  networkpolicy.yaml
  brief/participant-brief.md # requirements, resource table, acceptance criteria, stretch goals
  diagrams/ skyhop-architecture.svg  skyhop-team-split.svg
```

## Out of scope (Phase 2, deferred)

Refactoring the existing `d01`–`d03` course examples to map onto these two apps. Tracked separately;
will require adaptations across every session.

## Build & push notes

- Both images build via multi-stage Dockerfiles, so only Docker is needed locally (no host JDK/Node).
- Pushing requires the user to be logged in to Docker Hub (`docker login`) as `bogdansolga`.
  Pushing is an outward-facing action and will be confirmed with the user before it runs.
