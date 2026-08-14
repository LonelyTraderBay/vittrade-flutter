# Button Wiring Baseline Ledger

Generated: 2026-07-21 · Expanded: STEP-P0.10 · **Closed: STEP-P6.1 / P6.2 (2026-07-22)**

Purpose: baseline matrix for non-navigation `onPressed` / `onTap` dead-handler discovery (complements `route_coverage_audit` + `navigation_edge_audit`).  
**Status: P6 sweeps complete — product `broken=0`.**

## Command hint

This ledger is verified directly with the documented Flutter audit commands;
it does not depend on a runtime-specific agent.

Scope one module at a time under `flutter_app/lib/features/<module>/` (or `presentation/` subtree). Exhaustive grep patterns:

```text
onPressed:\s*\(\)\s*\{\s*\}
onTap:\s*\(\)\s*\{\s*\}
onPressed:\s*\(\)\s*async\s*\{\s*\}
onTap:\s*\(\)\s*async\s*\{\s*\}
onPressed:\s*null
onTap:\s*null
```

Classify each hit: `broken` | `needs_review` | `legitimate` (dev demos, conditional disabled, `VitHeaderActionButton` null-disabled).

Persist findings to:

```text
flutter_app/run-artifacts/button-wiring-audit-<scope>-<date>.md
```

Codex sessions: load `.codex/skills/vittrade-button-wiring-audit/SKILL.md` and use the same read-only audit runbook; do not invent parallel tooling.

## Scope matrix by module

| Module | Feature path (scope) | Priority sweep STEP | Empty stubs | Verdict | Status |
|--------|----------------------|---------------------|------------:|---------|--------|
| home | `flutter_app/lib/features/home/` | P6.2 | 0 | PASS | **done 2026-07-22** |
| profile | `flutter_app/lib/features/profile/` | P6.2 | 0 | PASS | **done 2026-07-22** |
| markets | `flutter_app/lib/features/markets/` | **P6.1** | 0 broken (1 legitimate) | PASS | **done 2026-07-22** |
| trade | `flutter_app/lib/features/trade/` (+ bots/copy) | **P6.1** | 0 broken (1 demo legitimate) | PASS | **done 2026-07-22** |
| wallet | `flutter_app/lib/features/wallet/` | **P6.1** | 0 | PASS | **done 2026-07-22** |
| earn | `flutter_app/lib/features/earn_*/` (family) | **P6.2** | 0 | PASS | **done 2026-07-22** |
| p2p (family) | `flutter_app/lib/features/p2p_core/` + `p2p_marketplace/` + `p2p_orders/` + `p2p_account/` + `p2p_security/` + `p2p_dispute/` | **P6.2** | 0 | PASS | **done 2026-07-22** (paths updated post ADR-012 PR8 · 2026-07-24) |
| arena | `flutter_app/lib/features/arena/` | **P6.2** | 0 | PASS | **done 2026-07-22** |
| predictions | `flutter_app/lib/features/predictions/` | **P6.2** | 0 | PASS | **done 2026-07-22** |
| launchpad / rewards / referral / dca / support / news / discovery | related Discovery family | P6.2 | 0 broken (1 launchpad ended-pool legitimate) | PASS | **done 2026-07-22** |

## Dated artifacts

| Scope | Artifact | broken | needs_review | legitimate |
|-------|----------|-------:|-------------:|-----------:|
| trade+markets+wallet | `flutter_app/run-artifacts/button-wiring-audit-trade-markets-wallet-2026-07-22.md` | 0 | 0 | 2 |
| earn+p2p+discovery | `flutter_app/run-artifacts/button-wiring-audit-earn-p2p-discovery-2026-07-22.md` | 0 | 0 | 1 |

## Legitimate catalog (kept)

- Markets pair header share: `VitHeaderActionButton(onPressed: null)` — documented disabled until share sheet.
- Copy-trading SC-401 card demo empty `onTap` — internal design demo.
- Launchpad ended pool CTA `onPressed: null` — conditional terminal state.

## Exit criteria (P6)

- [x] Each module row has dated ledger artifact + counts.
- [x] `broken` count = 0 on production scopes.
- [x] Program gate: playbook **STEP-P6.5**.
