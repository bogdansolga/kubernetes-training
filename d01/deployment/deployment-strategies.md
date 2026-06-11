# Deployment strategies — Day 1 (reference)

*How* you roll out a new version trades off **downtime**, **risk**, **rollback speed**, **traffic
control** and **resource cost**. Six common strategies, framed on SkyHop (`skyhop-be` / `skyhop-fe`).

| Strategy | Native to a Deployment? | Downtime | Rollback | Traffic control | Extra cost | Needs |
|---|---|---|---|---|---|---|
| **Recreate** | ✅ `strategy: Recreate` | yes (brief) | redeploy | none | none | — |
| **Rolling** | ✅ `strategy: RollingUpdate` (default) | none* | roll back | none (all-or-nothing per Pod) | +maxSurge | good probes |
| **Blue/Green** | ⚠️ pattern (2 Deployments + Service) | none | instant (flip Service) | all-or-nothing, instant | 2× during switch | a label switch |
| **Canary** | ⚠️ pattern (stable + canary Deployment) | none | delete canary | by **replica ratio** (coarse) | +canary Pods | (precise %: Argo Rollouts / Flagger / mesh) |
| **A/B testing** | ❌ needs L7 routing | none | drop the rule | by **request** (header / cookie / geo) | +variant Pods | Ingress rules or a service mesh |
| **Shadow / mirror** | ❌ needs a service mesh | none | stop mirroring | **copy** of prod traffic, responses discarded | +shadow Pods | Istio (or similar) traffic mirroring |

\* zero-downtime only if readiness probes are correct and `maxUnavailable` allows it.

---

## 1. Recreate
Terminate **all** old Pods, then start the new ones. Simple, but there is a gap with **no running
Pods**. Use when old and new **cannot coexist** (e.g. an incompatible DB schema migration).
→ `strategy-recreate.yml`

## 2. Rolling (default)
Replace Pods **gradually** — a few at a time — so the app stays available throughout. `maxSurge`
caps the extra Pods created above `replicas`; `maxUnavailable` caps how many may be down. This is the
default and the right choice for most SkyHop rollouts. → `strategy-rolling.yml`
```bash
kubectl set image deployment/skyhop-be skyhop-be=bogdansolga/skyhop-be:1.0   # triggers the rollout
kubectl rollout status deployment/skyhop-be
kubectl rollout undo    deployment/skyhop-be                                 # roll back
```

## 3. Blue/Green
Run **two full environments**: *blue* (current) and *green* (new). The Service selector points at
blue; once green is verified, **flip the selector** to green — an instant cutover, with instant
rollback (flip back). Costs ~2× resources while both are up.
```yaml
# two Deployments: app=skyhop-be,version=blue  and  app=skyhop-be,version=green
# one Service selects ONE version; cut over by patching its selector:
kubectl patch service skyhop-be -p '{"spec":{"selector":{"app":"skyhop-be","version":"green"}}}'
```

## 4. Canary
Send a **small slice** of traffic to the new version, watch it, then ramp up. The poor-man's version
uses one Service over a *stable* Deployment (e.g. 9 replicas) + a *canary* Deployment (1 replica) with
the **same** Service label — traffic splits ~roughly by replica count. For precise percentages and
metric-based auto-promotion, use **Argo Rollouts**, **Flagger**, or a service mesh.

## 5. A/B testing
Like canary, but routing is **deliberate, by request attribute** (header, cookie, region) to compare
variants for a *product* decision — not just a safe rollout. Needs L7 routing: ingress-nginx canary
annotations, or a service mesh.
```yaml
# ingress-nginx example: route 10% (or header-matched) traffic to a second Ingress/Service
metadata:
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"           # or canary-by-header: x-variant
```

## 6. Shadow (mirror / dark launch)
Send a **copy** of real production traffic to the new version, but **discard its responses** — users
never see them. Lets you observe correctness and load under real traffic with zero user risk. Requires
a **service mesh** (e.g. Istio `mirror`); plain Kubernetes can't duplicate traffic.
```yaml
# Istio VirtualService (reference): 100% to v1, mirror a copy to v2
http:
  - route:
      - destination: { host: skyhop-be, subset: v1 }
    mirror:        { host: skyhop-be, subset: v2 }
    mirrorPercentage: { value: 100 }
```

---

## Should there be a file per strategy?  (advice)

**Yes — but only where a manifest actually teaches something:**

- **Recreate** and **Rolling** are pure `Deployment.spec.strategy` — one self-contained file each is
  clearly worth it. ✅ Added: `strategy-recreate.yml`, `strategy-rolling.yml`.
- **Blue/Green**, **Canary**, **A/B testing** and **Shadow** are kept **doc-only** (the reference
  snippets above): blue/green & canary are *patterns* over core objects rather than a single
  resource, and A/B & shadow need an ingress controller's canary annotations or a service mesh — none
  of them is a self-contained manifest, so a standalone file would teach less than the explanation
  here. The runnable files are intentionally just the two native strategies.
