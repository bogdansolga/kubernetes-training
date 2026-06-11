# Helm — Day 3 / lecture S12

**Helm** packages Kubernetes manifests into a versioned, parameterised **chart**. `skyhop-fe/` is a
chart that deploys the SkyHop frontend (Deployment + Service + Ingress), configurable via
`values.yaml` (image tag, replicas, ingress host).

```
skyhop-fe/
  Chart.yaml            # chart metadata
  values.yaml           # default values
  templates/            # templated manifests
    deployment.yaml
    service.yaml
    ingress.yaml
```

```bash
helm lint ./skyhop-fe
helm template skyhop-fe ./skyhop-fe                       # render to plain YAML (no cluster needed)
helm install  skyhop-fe ./skyhop-fe                       # deploy
helm upgrade  skyhop-fe ./skyhop-fe --set replicaCount=3 --set ingress.host=demo.local
helm uninstall skyhop-fe
```

> Per the course's building-blocks rule, this chart packages just the FE — assembling the whole
> wired-up SkyHop is the capstone's job.
