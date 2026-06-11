# Namespaces — Day 1 / lecture 3.2

A Namespace partitions cluster objects into isolated groups. All of SkyHop runs in one
namespace, `skyhop` — so the whole app can be listed, or torn down, as a single unit.

```bash
kubectl apply -f namespace.yml
kubectl get namespaces
kubectl get all -n skyhop          # everything SkyHop, in one place
```

Imperatively, the same result: `kubectl create namespace skyhop`.

> Create the namespace first; the other labs can then target it with `-n skyhop`.
