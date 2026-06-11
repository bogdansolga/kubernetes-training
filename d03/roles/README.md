# RBAC — Day 3 / lecture 11.2

Role-Based Access Control grants **subjects** (users, groups, ServiceAccounts) permission to perform
**verbs** on **resources**. Roles are namespaced; ClusterRoles are cluster-wide. A binding ties a
role to subjects.

| File | Scope |
|---|---|
| `role.yml` + `rolebinding.yml` | namespaced — `skyhop-deployer` manages workloads in `skyhop` |
| `clusterrole.yml` + `clusterrolebinding.yml` | cluster-wide — `skyhop-viewer`, read-only |

```bash
kubectl create namespace skyhop --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f role.yml -f rolebinding.yml -f clusterrole.yml -f clusterrolebinding.yml

# test what a subject is allowed to do:
kubectl -n skyhop auth can-i create deployments --as deployer@skyhop      # yes
kubectl -n skyhop auth can-i delete nodes        --as deployer@skyhop      # no
```

> **Least privilege:** grant only the verbs/resources actually needed — avoid wildcard
> (`resources: ["*"]`, `verbs: ["*"]`) rules.
