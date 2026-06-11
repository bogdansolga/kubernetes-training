# Gateway API — Day 3 (advanced)

The **Gateway API** is the modern, role-oriented successor to **Ingress**. Instead of one annotated
Ingress object, it splits responsibilities:

| Object | Owned by | Role |
|---|---|---|
| `GatewayClass` | platform | which controller implements Gateways (here `nginx`) |
| `Gateway` (`gateway.yml`) | platform / cluster team | the listener — protocol, port, hostname |
| `HTTPRoute` (`httproute.yml`) | app / FE team | host + path → Service routing |

It is **not built into Kubernetes** — you install CRDs + a controller separately.

## Versions (the slide must state these)

| Component | Version |
|---|---|
| Gateway API CRDs (standard channel) | **v1.5.0** |
| NGINX Gateway Fabric (controller) | **v2.6.3** |
| **Minimum Kubernetes** (for Gateway API v1.5.0) | **1.26+** |

## Install

```bash
# 1) Gateway API standard-channel CRDs (GatewayClass / Gateway / HTTPRoute / ReferenceGrant)
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.5.0/standard-install.yaml

# 2) NGINX Gateway Fabric — CRDs (server-side apply) + controller + the `nginx` GatewayClass
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.6.3/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.6.3/deploy/default/deploy.yaml
kubectl -n nginx-gateway wait --for=condition=available deployment/nginx-gateway --timeout=180s
```

## Run

```bash
# the route needs a backend — deploy the FE first (Deployment + Service)
kubectl apply -f ../../d01/deployment/skyhop-fe-deployment.yml -f ../../d01/service/skyhop-fe-service-clusterip.yml
kubectl apply -f gateway.yml -f httproute.yml

# the Gateway should become Programmed; the HTTPRoute Accepted
kubectl wait --for=condition=Programmed gateway/skyhop-gateway --timeout=120s
kubectl get gateway skyhop-gateway
kubectl get httproute skyhop-fe
```

## Test (port-forward the data-plane the controller provisioned)

When the Gateway is created, NGF provisions a data-plane Service `skyhop-gateway-nginx`.

```bash
kubectl wait --for=condition=ready pod -l gateway.networking.k8s.io/gateway-name=skyhop-gateway --timeout=120s
kubectl port-forward svc/skyhop-gateway-nginx 8080:80 &
curl -s -H 'Host: skyhop.local' http://localhost:8080/api/health      # {"status":"ok"}
kill %1
```

> The training cluster already runs ingress-nginx on host 80/443, so we test the Gateway via
> port-forward rather than fighting for port 80 — the two tracks coexist. Cleanup:
> `kubectl delete -f gateway.yml -f httproute.yml`.
