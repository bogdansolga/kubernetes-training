# Autoscaling — Day 3 / lecture S10

A **HorizontalPodAutoscaler** (HPA) adds/removes Pod replicas to keep resource utilisation near a
target. Here it scales the SkyHop backend between 2 and 6 replicas.

| File | |
|---|---|
| `skyhop-be-deployment.yml` | the target Deployment (must declare CPU/memory **requests**) |
| `skyhop-be-service.yml` | a ClusterIP Service so load (and clients) can reach skyhop-be |
| `skyhop-be-hpa.yml` | the HPA — `autoscaling/v2`, CPU 70% + memory 80% |
| `load-test.sh` | generates load (simulated users) to make the HPA scale up |

```bash
# prereq: metrics-server installed (kubectl top must work)
kubectl apply -f skyhop-be-deployment.yml -f skyhop-be-service.yml -f skyhop-be-hpa.yml
kubectl get hpa skyhop-be          # TARGETS show cpu/mem % once metrics flow in
```

### Triggering a scale-up (load test)

The HPA only scales when there's load — generate it with the script (number of simulated users is
the first argument):

```bash
./load-test.sh 150            # 150 concurrent users, default 120s
./load-test.sh 150 180        # 150 users for 180s
# in another terminal:
kubectl get hpa skyhop-be -w  # watch TARGETS climb and REPLICAS grow toward maxReplicas
```

> Utilisation is measured against the container's **requests** — no requests, no HPA. On kind,
> metrics-server needs `--kubelet-insecure-tls`. A VerticalPodAutoscaler (VPA) instead resizes a
> Pod's requests/limits rather than the replica count.
