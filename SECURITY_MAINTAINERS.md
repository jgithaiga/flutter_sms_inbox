# Maintainer Security Notes

This document is for repository maintainers.

## Vulnerability scanning

Run dependency vulnerability scans locally with:

```bash
bash scripts/security_scan.sh
```

The script auto-detects supported OSV flags across versions. If severity filtering flags are unavailable in the scanner version, it falls back to scanning all severities.

Docker fallback uses a pinned OSV scanner image digest by default for reproducible results. You can override it explicitly:

```bash
OSV_SCANNER_IMAGE=ghcr.io/google/osv-scanner@sha256:<digest> bash scripts/security_scan.sh
```

## CI enforcement

CI runs lockfile scans on pull requests and pushes using `.github/workflows/security-scan.yml`.
