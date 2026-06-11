# Cluster upgrades — Day 3 / lecture S11 (administration · node maintenance & HA)

Kubernetes ships a **minor release every ~3–4 months** and patch releases more often. A cluster
must be upgraded to get security fixes and stay inside the **supported window** (~1 year / the last
3 minor releases). This session covers *how* an upgrade works and *how often* to do it.

## How an upgrade works (the mechanics)

- **Control plane first, then the worker nodes** — and **one minor version at a time** (you cannot
  skip minors: 1.31 → 1.32 → 1.33, not 1.31 → 1.33). Patch bumps within a minor are free.
- **Version skew:** a kubelet may lag the API server by up to 3 minors, but **never run a node
  newer than the control plane**.
- **Per node, rolling:** `cordon` (stop new Pods) → `drain` (evict Pods — they reschedule
  elsewhere) → upgrade kubelet/kubeadm → `uncordon`.
- Workloads with **≥ 2 replicas + a PodDisruptionBudget** stay available through the rolling drain.

## Two cadence strategies

### A — Frequent, small upgrades  *(upgrade soon after each release)*
Small version steps, taken often.
- **+** Less disruption per upgrade · small changesets · deprecations handled incrementally ·
  easy rollback · always comfortably in support.
- **−** More maintenance windows · more recurring operational overhead.

### B — Infrequent, large jumps  *(upgrade rarely, then catch up)*
Bigger minor+patch jumps (still stepping through each minor).
- **+** Fewer maintenance windows · less frequent disruption to the team's calendar.
- **−** Large changesets · accumulated deprecations & removed APIs to fix *all at once* · higher
  risk per upgrade · harder rollback · risk of **falling out of the support window**.

## Tradeoffs — summary

| Dimension | A · Frequent / small | B · Infrequent / large jumps |
|---|---|---|
| Disruption **per** upgrade | low | higher |
| Operational overhead | higher (more windows) | lower (fewer windows) |
| Changeset size / risk | small, contained | large, compounding |
| Deprecations / API removals | handled incrementally | pile up, fixed all at once |
| Rollback | easier | harder |
| Support window | comfortably inside | risk of falling out |
| Best fit | most teams, production | limited ops capacity, very stable workloads |

> **Rule of thumb:** prefer **A (frequent/small)** for production — it keeps each step boring.
> Reserve large jumps for tightly-scoped, well-rehearsed maintenance with a tested rollback.

## Hands-on — keep SkyHop available during an upgrade

A rolling upgrade drains one node at a time. With `skyhop-be` at **2 replicas**, a
**PodDisruptionBudget** (`minAvailable: 1`) lets a drain evict *one* Pod but never both.

```bash
# (deploy skyhop-be at 2 replicas first — see ../../d01/deployment/)
kubectl apply -f skyhop-be-pdb.yml
kubectl get pdb skyhop-be                 # MIN AVAILABLE 1 · ALLOWED DISRUPTIONS 1

# simulate a node going down for upgrade — Pods reschedule, the PDB protects availability
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data
kubectl uncordon <node>                   # bring it back after the (simulated) upgrade
```

### Upgrading the cluster itself
- **kubeadm:** `kubeadm upgrade plan` → `kubeadm upgrade apply vX.Y.Z` (control plane), then per
  node `kubeadm upgrade node` + restart kubelet.
- **Managed (EKS / GKE / AKS):** upgrade the control plane in the console/CLI, then roll the node pools.
- **kind (this training cluster):** kind has no in-place upgrade — **recreate** with a newer node
  image: `kind create cluster --image kindest/node:vX.Y.Z`. So practice the *drain + PDB* mechanics
  here; the version bump itself is a recreate.

> **Tie-in:** the primitives you already met — Deployments with `replicas`, pod **anti-affinity**
> (spread across nodes), and now **PodDisruptionBudgets** — are exactly what make a rolling cluster
> upgrade non-disruptive for SkyHop.
