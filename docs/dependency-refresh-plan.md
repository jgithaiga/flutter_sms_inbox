# Dependency Refresh Plan

Last updated: 2026-05-23
Scope: SH-09 in `docs/security-hardening-plan.md`

## Goals
- Keep dependency risk low by regularly reviewing outdated packages.
- Prioritize security and ecosystem support over raw version churn.
- Avoid accidental breakages from major upgrades by using staged updates.

## Cadence
- Weekly: run dependency report and capture diff from previous run.
- Before release: run dependency report and evaluate all high-priority updates.
- Monthly: review discontinued/deprecated package warnings and migration options.

## Commands
```bash
bash scripts/dependency_report.sh
flutter test
flutter analyze
```

## Triage Rules
1. Security fix available: prioritize immediately.
2. Discontinued/deprecated package in active path: open migration task in the next sprint.
3. Major version with API breaks: stage behind a branch and test matrix before merge.
4. Dev-only package updates: batch together when possible to reduce CI churn.

## Upgrade Workflow
1. Create a branch for dependency updates.
2. Run dependency report and record baseline output.
3. Upgrade smallest safe set first.
4. Run:
```bash
flutter pub get
flutter analyze
flutter test
```
5. If successful, expand to the next update set.
6. Update changelog/notes with notable dependency impacts.

## Tracking Template
Use this table when planning upgrade batches:

| Package | Current | Candidate | Type (runtime/dev) | Reason | Risk | Status |
|---|---|---|---|---|---|---|
| example-package | x.y.z | a.b.c | dev | security/compatibility | low/med/high | todo/in-progress/done |

## Acceptance Criteria
- Dependency report is reproducible via script.
- Upgrade decisions are documented with rationale.
- `flutter analyze` and `flutter test` pass after each dependency batch.
