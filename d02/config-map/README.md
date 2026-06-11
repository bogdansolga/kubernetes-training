# ConfigMaps & the Downward API — Day 2 / lecture 7.1

ConfigMaps hold **non-secret** configuration, decoupled from the container image. The SkyHop
cross-team contract lives here.

| File | |
|---|---|
| `skyhop-fe-config.yml` | the FE→BE contract: `BACKEND_URL=http://skyhop-be:8080` |
| `skyhop-be-config.yml` | the backend's Spring profile + JDBC URL |
| `pod-configmap-env.yml` | consuming a ConfigMap as env (`envFrom` + `configMapKeyRef`) |
| `pod-downward-api.yml` | the Downward API — expose Pod metadata to the container |

```bash
kubectl apply -f skyhop-fe-config.yml -f skyhop-be-config.yml -f pod-configmap-env.yml
kubectl logs skyhop-config-consumer           # BACKEND_URL=http://skyhop-be:8080 PROFILE=k8s
kubectl apply -f pod-downward-api.yml
kubectl logs skyhop-downward-api              # POD=... NS=... NODE=...
```

> `BACKEND_URL` is the single integration point between the FE and BE teams in the capstone.
