# Security Release Checklist

Last updated: 2026-05-23
Scope: SH-10 in `docs/security-hardening-plan.md`

Use this checklist before merging release-bound changes.

## Runtime Safety
- [ ] Query bounds remain enforced in Dart (`count` default/max).
- [ ] Native fallback cap remains enforced in Android handler.
- [ ] Error contracts are stable (`permission_denied`, `invalid_arguments`, `invalid_response`, `query_failed`).

## Data Minimization
- [ ] Example app defaults to privacy-safe rendering.
- [ ] No sensitive debug logging patterns in example/app code.
- [ ] README guidance for privacy-safe usage is current.

## Supply Chain
- [ ] `bash scripts/security_scan.sh` completes successfully.
- [ ] `bash scripts/dependency_report.sh` reviewed and triaged.
- [ ] Any discontinued package warnings have a tracked migration issue.

## Quality Gates
- [ ] `flutter analyze` passes.
- [ ] `flutter test` passes.
- [ ] CI security-scan workflow passes.

## Sign-off
- [ ] Reviewer confirms checklist completion.
- [ ] Release notes mention security-relevant behavior changes.
