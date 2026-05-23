# Security Hardening Plan and Implementation Tracker

Last updated: 2026-05-23
Branch: misc-updates

## Scope
This plan tracks follow-up implementation work from the latest repository security review.

### Findings Addressed
1. Unbounded SMS reads can cause memory/performance pressure when `count` is omitted or very large.
2. Example app shows full SMS body and logs metadata that can be copied into production patterns.
3. Dependency vulnerability scanning is not automated/available in tooling.
4. Dev toolchain has outdated and discontinued packages (supply-chain maintenance risk).

## Success Criteria
- Query APIs enforce safe upper bounds for message fetch volume.
- Example app demonstrates privacy-safe defaults.
- CI (or local scripted workflow) includes reproducible vulnerability checks.
- Dependency hygiene process is documented and periodically executed.

## Tracker Legend
- Status: `todo` | `in-progress` | `blocked` | `done`
- Priority: `P0` (highest) to `P3` (lowest)

## Implementation Tracker

| ID | Task | Priority | Status | Owner | Target | Verification | Notes |
|---|---|---|---|---|---|---|---|
| SH-01 | Add a safe max cap for total messages fetched in Dart query path | P0 | todo | unassigned | 2026-05-30 | Unit tests for clamping and no-overfetch behavior | Cap should apply to global `count` semantics across ordered `kinds` |
| SH-02 | Validate and clamp `count + start` before passing to native query | P0 | todo | unassigned | 2026-05-30 | Unit tests + analyzer clean | Prevent oversized native requests and potential memory spikes |
| SH-03 | Add native-side defensive cap fallback in `SmsQueryHandler` for unbounded requests | P1 | todo | unassigned | 2026-06-03 | Android tests/manual validation | Provides safety if Dart-side checks are bypassed |
| SH-04 | Add regression tests for large start/count edge cases | P1 | todo | unassigned | 2026-06-03 | `flutter test` in security test suite | Cover integer boundaries and large inbox simulation |
| SH-05 | Privacy-harden example app: mask/truncate message bodies by default | P1 | todo | unassigned | 2026-06-03 | Manual run of example + snapshot review | Keep sample useful while reducing accidental sensitive-data exposure |
| SH-06 | Remove or gate debug logs in example app for release-safe guidance | P2 | todo | unassigned | 2026-06-03 | Code review + grep check for debug logs | Prefer comments describing secure logging practices |
| SH-07 | Add README section for fetch limits and privacy-safe usage patterns | P1 | todo | unassigned | 2026-06-03 | Docs review | Include examples with constrained `count` and minimization guidance |
| SH-08 | Add vulnerability scan command and CI workflow (OSV or equivalent) | P1 | todo | unassigned | 2026-06-07 | CI run artifact + failing on critical/high | If scanner unavailable locally, document dev setup fallback |
| SH-09 | Perform dependency refresh plan for outdated/discontinued dev tooling | P2 | todo | unassigned | 2026-06-10 | `flutter pub outdated` delta + successful tests/analyze | Track compatibility constraints and migration notes |
| SH-10 | Add periodic security review checklist and release gate | P2 | todo | unassigned | 2026-06-10 | Checklist committed and referenced in release flow | Include permissions, logging, dependency scan, docs checks |

## Work Breakdown by Phase

### Phase 1: Immediate Runtime Safety (P0/P1)
- Implement SH-01, SH-02, SH-03, SH-04.
- Exit criteria:
  - All new tests pass.
  - `flutter analyze` has no issues.
  - Query behavior documented and deterministic under large inputs.

### Phase 2: Privacy and Developer Guidance (P1/P2)
- Implement SH-05, SH-06, SH-07.
- Exit criteria:
  - Example app demonstrates least-exposure defaults.
  - README clearly states safe usage and limits.

### Phase 3: Supply-Chain and Process Hardening (P1/P2)
- Implement SH-08, SH-09, SH-10.
- Exit criteria:
  - Automated vulnerability scanning is reproducible.
  - Dependency maintenance process documented and operational.

## Suggested Verification Commands
```bash
flutter test
flutter analyze
flutter pub outdated --no-transitive
```

## Risks and Mitigations
- Risk: Strict caps could surprise existing consumers expecting unbounded reads.
  - Mitigation: Document defaults clearly and allow explicit override within safe bounds.
- Risk: CI vulnerability tooling may vary by environment.
  - Mitigation: Pin scanner version and include a setup script/documentation.
- Risk: Example app privacy changes reduce demo clarity.
  - Mitigation: Add a clear note explaining how to opt in to full-body rendering for debugging only.

## Change Log
- 2026-05-23: Initial plan created with prioritized tracker items from security review.
