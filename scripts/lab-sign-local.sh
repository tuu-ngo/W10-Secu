#!/usr/bin/env bash
# Lab 2.2: build, push to local registry, cosign sign (minikube)
set -euo pipefail

REGISTRY="${REGISTRY:-localhost:5000}"
IMAGE="${IMAGE:-w10-secu-api:0.0.2}"
TAG="${REGISTRY}/${IMAGE}"

eval "$(minikube -p w10 docker-env)"

docker build -t "${TAG}" ./src/api
docker push "${TAG}"

docker run --rm -v "$(pwd)/signing:/work" -w /work \
  -e COSIGN_PASSWORD= \
  cgr.dev/chainguard/cosign:latest \
  sign --yes --allow-insecure-registry --key cosign.key "${TAG}"

echo "Signed ${TAG}"
echo "Update rollout to: registry.demo.svc.cluster.local:5000/${IMAGE}"
