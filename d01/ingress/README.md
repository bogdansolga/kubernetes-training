# Ingress — Day 1 / lecture 3.6

An Ingress is L7 (HTTP) routing into the cluster. Only the SkyHop **frontend** is exposed —
the backend stays internal, because the FE calls it server-side over the cluster network.

`skyhop-fe-ingress.yml`: `ingressClassName: nginx`, host `skyhop.local`, routes `/` (Prefix)
to the `skyhop-fe` Service on port `3000`.

```bash
# needs the ClusterIP Service from ../service/ and an ingress-nginx controller
kubectl apply -f ../service/skyhop-fe-service-clusterip.yml -f skyhop-fe-ingress.yml
curl -H 'Host: skyhop.local' http://localhost/        # reach the FE through the Ingress
```

> Prerequisite: an ingress controller. The training kind cluster is created with host 80/443
> mappings and ingress-nginx installed, so `http://skyhop.local` works with no port-forward.
> Forward-looking: the Ingress successor is the **Gateway API** (`Gateway` + `HTTPRoute`).
