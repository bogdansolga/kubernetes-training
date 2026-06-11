#!/usr/bin/env bash
#
# Generate HTTP load against skyhop-be to drive the HorizontalPodAutoscaler (lecture S10).
#
# Usage:  ./load-test.sh <concurrent-users> [duration-seconds]
#   <concurrent-users>  REQUIRED — number of simulated concurrent users (parallel request loops)
#   [duration-seconds]  optional — how long to run (default 120)
#
# Env:    KUBECONTEXT  override the kube-context (default: kind-kind-cluster)
#
# Prereq: skyhop-be-deployment.yml, skyhop-be-service.yml, skyhop-be-hpa.yml applied,
#         and metrics-server installed (kubectl top must work).
#
set -euo pipefail

USERS="${1:?usage: ./load-test.sh <concurrent-users> [duration-seconds]}"
DURATION="${2:-120}"
CTX="${KUBECONTEXT:-kind-kind-cluster}"
TARGET="http://skyhop-be:8080/api/routes"
GEN_POD="skyhop-load-generator"

kc() { kubectl --context "$CTX" "$@"; }

if ! kc get deploy skyhop-be >/dev/null 2>&1; then
  echo "ERROR: deployment/skyhop-be not found." >&2
  echo "Apply skyhop-be-deployment.yml, skyhop-be-service.yml and skyhop-be-hpa.yml first." >&2
  exit 1
fi

echo ">> Load test: ${USERS} simulated users for ${DURATION}s against ${TARGET}"
kc delete pod "$GEN_POD" --ignore-not-found >/dev/null 2>&1 || true

# One pod that forks <USERS> parallel wget loops, each bounded by <DURATION> via `timeout`.
kc run "$GEN_POD" --image=busybox:1.36 --restart=Never --command -- \
  sh -c "for i in \$(seq 1 ${USERS}); do timeout ${DURATION} sh -c 'while true; do wget -q -O /dev/null ${TARGET} 2>/dev/null; done' & done; wait"

echo ">> Generator running. Watching the HPA (also: kubectl get hpa skyhop-be -w)"
echo "   TIME      NAME / REFERENCE / TARGETS / MIN / MAX / REPLICAS"
END=$(( $(date +%s) + DURATION ))
while [ "$(date +%s)" -lt "$END" ]; do
  echo "   $(date +%H:%M:%S)  $(kc get hpa skyhop-be --no-headers 2>/dev/null || echo '(no hpa)')"
  sleep 10
done

echo ">> Done — cleaning up the generator pod."
kc delete pod "$GEN_POD" --ignore-not-found >/dev/null 2>&1 || true
echo ">> The HPA scales back down after load stops (default ~5 min stabilization window)."
