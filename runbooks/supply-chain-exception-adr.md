# ADR: CVE exception (template)

Dùng khi Trivy fail vì CVE HIGH/CRITICAL mà upstream chưa fix.

| Field | Value |
|-------|-------|
| CVE | CVE-XXXX-YYYY |
| Severity | HIGH |
| Component | (package name) |
| Reason | No upstream fix available |
| Expiry | YYYY-MM-DD |
| Mitigation | NetworkPolicy, non-root, read-only rootfs |
| Owner | (your name) |

## Decision

Tạm thời cho phép deploy với exception có thời hạn. Review lại trước Expiry.
