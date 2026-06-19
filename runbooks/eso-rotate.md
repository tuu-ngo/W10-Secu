# Runbook: Rotate DB password via ESO (fake provider)

Lab dùng fake provider thay AWS Secrets Manager. Production thay bằng AWS + IRSA.

## Rotate

1. Sửa `eso/secret-store.yaml` — đổi `value` (ví dụ `password-v1` → `password-v2`)
2. Commit + push, hoặc `kubectl apply -f eso/secret-store.yaml`
3. Đợi ≤ `refreshInterval` (30s)
4. Verify:
   ```bash
   kubectl get secret db-secret -n demo -o jsonpath='{.data.password}' | base64 -d; echo
   kubectl get pod -n demo
   ```

## Expected

- K8s Secret `db-secret` cập nhật trong < 60s
- Pod AGE không đổi (no restart)
