# Persistence — Day 2 / lecture S06

`PersistentVolume` (PV), `PersistentVolumeClaim` (PVC) and `StorageClass` decouple *storage* from
*Pods*: a Pod claims storage (PVC); the cluster satisfies it from a PV.

## Provisioning (hands-on)

| File | Provisioning |
|---|---|
| `pv-static.yml` + `pvc-static.yml` | **static** — admin pre-creates a PV; the PVC binds to it |
| `pvc-dynamic.yml` + `pod-pvc-writer.yml` | **dynamic** — the default StorageClass creates a PV on demand |

```bash
kubectl apply -f pv-static.yml -f pvc-static.yml
kubectl get pv,pvc                       # skyhop-pvc-static -> Bound to skyhop-pv-static

kubectl apply -f pvc-dynamic.yml -f pod-pvc-writer.yml
kubectl get pvc skyhop-pvc-dynamic        # Bound once pvc-writer schedules
kubectl exec pvc-writer -- cat /data/note.txt
```

## Storage plugins & CSI  *(reference — not applied)*

A **StorageClass** points at a *provisioner* — the plugin that actually creates the volumes:

- **In-tree plugins** — legacy, compiled into Kubernetes (`hostPath`, NFS, the old cloud volumes).
  Being removed in favour of CSI.
- **CSI (Container Storage Interface)** — the modern, out-of-tree standard. Each vendor ships a
  driver: `ebs.csi.aws.com`, `pd.csi.storage.gke.io`, `disk.csi.azure.com`,
  `rbd.csi.ceph.com` / `cephfs.csi.ceph.com` (Ceph), `nfs.csi.k8s.io`, …

Two CSI StorageClass examples are included (reference only — each needs the backing storage +
driver installed):
- `csi-ceph-storageclass.yml` — **Ceph RBD** block storage (`rbd.csi.ceph.com`) → RWO.
- `csi-nfs-storageclass.yml` — **NFS** shared filesystem (`nfs.csi.k8s.io`) → supports RWX.

## Access modes  *(reference — not applied)*

| Mode | Meaning | Typical backing |
|---|---|---|
| **RWO** ReadWriteOnce | read-write by a single **node** | block storage — EBS, Ceph RBD, GCE PD |
| **RWX** ReadWriteMany | read-write by **many nodes** | shared filesystem — NFS, CephFS |
| ROX ReadOnlyMany | read-only by many nodes | shared, read-only |
| RWOP ReadWriteOncePod | read-write by a single **Pod** | block storage (stricter than RWO) |

`access-mode-rwo.yml` and `access-mode-rwx.yml` showcase the two most common modes.

> The Postgres StatefulSet (../statefulset) uses **RWO** dynamic provisioning via
> `volumeClaimTemplates` — one volume per replica.
