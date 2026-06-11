# TLS termination (stretch) — Day 3 / edge

**TLS termination** = the edge decrypts inbound HTTPS and forwards plain HTTP to the app inside the
cluster, so the app never deals with certificates. This stretch lab shows the mechanics the simple
way, using **Caddy** — its `tls internal` directive auto-issues a certificate from Caddy's own CA
(no cert-manager, no external CA).

## Where should TLS terminate, in a real environment?

**At the shared edge, once** — the **Ingress controller**, the **Gateway**, or the **cloud load
balancer** — with a **managed certificate** (cert-manager + ACME/Let's Encrypt, or the cloud's cert
store). Everything behind it stays plain-HTTP.

You would **not** put a bespoke TLS proxy in front of each individual Service — that's an extra hop
and an extra cert to manage for no benefit. So in this lab **Caddy *is* the edge** (it replaces the
Ingress for this host), not an extra layer stacked in front of one app. If you also need encryption
*inside* the cluster (pod-to-pod, zero-trust mTLS), that's a **service-mesh** job (Istio, Linkerd) —
again, not a per-app proxy.

## Files

| File | |
|---|---|
| `caddy-config.yml` | the Caddyfile: `tls internal` + `reverse_proxy skyhop-fe:3000` |
| `caddy-deployment.yml` | Caddy (`caddy:2-alpine`) serving HTTPS on :443 |
| `caddy-service.yml` | ClusterIP exposing 443/80 |

## Set it up

```bash
# 1) the backend Caddy will proxy to (the FE Deployment + its ClusterIP Service)
kubectl apply -f ../../d01/deployment/skyhop-fe-deployment.yml \
               -f ../../d01/service/skyhop-fe-service-clusterip.yml

# 2) Caddy: config, deployment, service
kubectl apply -f caddy-config.yml -f caddy-deployment.yml -f caddy-service.yml
kubectl rollout status deployment/caddy
kubectl logs deploy/caddy | grep "certificate obtained"     # Caddy issued a cert for skyhop.local
```

## Test the HTTPS endpoint

TLS picks the certificate by **SNI** (the hostname in the TLS handshake), so the client must present
`skyhop.local` — not `localhost`. Use `curl --resolve` (and `-k`, since Caddy's internal CA isn't in
your trust store):

```bash
# easiest: an in-cluster client straight at the Service IP
CADDY_IP=$(kubectl get svc caddy -o jsonpath='{.spec.clusterIP}')
kubectl run tlscurl --image=curlimages/curl:8.11.1 --restart=Never --rm -i --command -- \
  curl -sk --resolve skyhop.local:443:$CADDY_IP https://skyhop.local/api/health
# -> {"status":"ok"}     (HTTP 200, served over TLS that Caddy terminated)

# or from your laptop via port-forward (note --resolve, so SNI = skyhop.local):
kubectl port-forward svc/caddy 8443:443 &
curl -sk --resolve skyhop.local:8443:127.0.0.1 https://skyhop.local:8443/api/health
kill %1
```

> Common gotcha: `curl -k -H 'Host: skyhop.local' https://localhost:8443` **fails** the handshake —
> the `Host:` header is HTTP-layer and arrives *after* TLS; the cert is chosen by SNI, which here
> would be `localhost`. Always drive SNI with `--resolve`.

## Cleanup

```bash
kubectl delete -f caddy-config.yml -f caddy-deployment.yml -f caddy-service.yml
kubectl delete -f ../../d01/deployment/skyhop-fe-deployment.yml \
               -f ../../d01/service/skyhop-fe-service-clusterip.yml
```

## The production way: terminate at the platform edge with a real cert

Same termination, but at the Ingress/Gateway with an explicit cert (a `kubernetes.io/tls` Secret,
typically issued by cert-manager) instead of an app pod:

```yaml
# Ingress (../../d01/ingress) — add a tls block:
spec:
  tls:
    - hosts: [skyhop.local]
      secretName: skyhop-tls            # kubectl create secret tls skyhop-tls --cert=… --key=…
  ingressClassName: nginx
  # …rules as before

# Gateway API (../gateway-api) — an HTTPS listener referencing the same Secret:
listeners:
  - name: https
    protocol: HTTPS
    port: 443
    hostname: skyhop.local
    tls:
      mode: Terminate
      certificateRefs:
        - { kind: Secret, name: skyhop-tls }
```
