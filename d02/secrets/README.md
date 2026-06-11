# Secrets — Day 2 / lecture 7.2

A **Secret** holds sensitive data, kept separate from ConfigMaps and base64-encoded at rest.
Here: the SkyHop database credentials.

| File | |
|---|---|
| `skyhop-db-secret.yml` | the DB `POSTGRES_USER` + `POSTGRES_PASSWORD` (via `stringData`) |
| `pod-secret-env.yml` | consume a Secret as environment variables (`secretKeyRef`) |
| `pod-secret-volume.yml` | mount a Secret as files (one per key) |

```bash
kubectl apply -f skyhop-db-secret.yml -f pod-secret-env.yml -f pod-secret-volume.yml
kubectl logs skyhop-secret-env                 # user=flights
kubectl exec skyhop-secret-volume -- cat /etc/db/POSTGRES_USER
```

> base64 is **encoding, not encryption** — anyone with `get secret` access can decode it. Protect
> Secrets with RBAC (../../d03/roles) and enable encryption-at-rest on real clusters. The Postgres
> StatefulSet and backup CronJob consume this same Secret in the capstone.
