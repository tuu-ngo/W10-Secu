# Lab 2.2: Supply Chain Verification

## Prerequisites

- `policy-controller` Running in `cosign-system`
- `ClusterImagePolicy require-signed-ghcr-images` applied
- Namespace `demo` labeled **only after** image signed:
  ```bash
  kubectl label namespace demo policy.sigstore.dev/include=true
  ```

## Local registry (minikube, no GHCR push)

```bash
# Registry runs in kube-system (lab-registry)
kubectl get svc lab-registry -n kube-system

# Push image (from minikube docker-env)
docker push <clusterIP>:5000/w10-secu-api:0.0.2

# Sign in-cluster
kubectl apply -f lab-test/cosign-sign-pod.yaml
kubectl logs cosign-sign -n kube-system
```

## Nghiệm thu 3 tình huống

### 1. Unsigned ghcr image → reject
```bash
kubectl apply -f lab-test/unsigned-ghcr-pod.yaml
# expect: signature key validation failed / no signatures found
```

### 2. Random unsigned image → reject
```bash
kubectl apply -f lab-test/unsigned-pod.yaml
# expect: no matching policies OR signature failed
```

### 3. Signed local image → pass admission
```bash
kubectl apply -f lab-test/signed-pod.yaml
# expect: pod CREATED (not denied by policy.sigstore.dev)
```

## CI (GitHub Actions)

1. Add secrets: `COSIGN_PRIVATE_KEY`, `COSIGN_PASSWORD`
2. Push change to `src/api/**` → workflow runs Trivy + Cosign sign
3. Sign **semver tag** (not only `:latest`)

## GHCR production path

```bash
cosign sign --yes --key signing/cosign.key ghcr.io/tuu-ngo/w10-secu-api:0.0.2
```
