# Pods — Day 1 / lecture 3.3

The Pod is the smallest deployable unit in Kubernetes. These examples introduce it on the
**SkyHop** running example — the flight-booking app you deploy throughout the course.

| File | Teaches |
|---|---|
| `first-pod.yml` | the bare-minimum Pod — `skyhop-be` with just an image |
| `skyhop-fe-pod.yml` | adding labels and a named port — `skyhop-fe` |
| `pod-with-qos.yml` | Quality-of-Service classes (Guaranteed, here) |

```bash
kubectl apply -f first-pod.yml
kubectl get pods
kubectl get pod skyhop-be-qos -o jsonpath='{.status.qosClass}{"\n"}'
```

> In v0 the backend runs an in-memory H2 database, so it stands alone — no Postgres needed.
> We meet each SkyHop piece one at a time here; wiring them together is the capstone's job.
