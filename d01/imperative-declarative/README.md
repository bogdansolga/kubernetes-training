# Imperative vs declarative — Day 1 / lecture S04

Two ways to manage the **same** `skyhop-fe` Deployment.

## Imperative — you tell kubectl the action to take
```bash
kubectl create deployment skyhop-fe --image=bogdansolga/skyhop-fe:0.1 --replicas=1
kubectl scale deployment skyhop-fe --replicas=3
kubectl set image deployment/skyhop-fe skyhop-fe=bogdansolga/skyhop-fe:0.1
kubectl delete deployment skyhop-fe
```

## Declarative — you describe the desired state, kubectl reconciles to it
```bash
kubectl apply -f skyhop-fe.yml
kubectl diff  -f skyhop-fe.yml      # preview the change before applying
# edit skyhop-fe.yml (e.g. replicas: 3), then re-apply — only the diff is sent:
kubectl apply -f skyhop-fe.yml
kubectl delete -f skyhop-fe.yml
```

> Declarative `apply` is what the course uses for everything else: the manifest is the source
> of truth, versioned in git. Imperative commands are best for quick, throwaway experiments.
