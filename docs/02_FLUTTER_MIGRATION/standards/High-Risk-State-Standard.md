# High-Risk State Standard (Mandatory)

**Authority:** [AGENTS.md](../../../AGENTS.md) "Financial Safety" section (preview/confirm
withdrawals, escrow release, security changes, address additions, P2P
payment-method changes) · derived from the existing
`high_risk_state_primitives_guardrail_test.dart` check, not new policy.
**Enforcement:** `test/quality/high_risk_state_primitives_guardrail_test.dart`
(no `tool/*_audit.dart` exists for this domain — the guardrail test is the
only enforcement mechanism).

Money-movement and account-risk pages must surface their risk-review /
confirmation state through the shared `VitHighRiskStatePanel` primitive with
a `highRiskContractId`, never a page-local ad-hoc warning `Container`/banner.
This keeps risk copy, iconography, and contract-id disclosure consistent
across every high-risk flow instead of each module inventing its own warning
chrome.

## The 17 pages the guardrail checks

`high_risk_state_primitives_guardrail_test.dart` hard-codes a fixed set of
representative target files and fails if any of them is missing either the
`VitHighRiskStatePanel` symbol or the `highRiskContractId` symbol. Table
regenerated 2026-07-27 (QA audit) from the guardrail's live `targets` set —
8 of the 13 previously-documented paths had drifted from the actual files on
disk (module rename / subfolder move); this table now matches the source:

| File | Module | Panel state used | What it tracks |
| --- | --- | --- | --- |
| `lib/features/trade/presentation/widgets/hub/trade_page_state.dart` | Trade | `riskReview` | Spot order risk (fees, slippage, balance) |
| `lib/features/wallet/presentation/pages/transfer/withdraw_page.dart` | Wallet | `riskReview` | Withdrawal preview (address, network, amount, fee) |
| `lib/features/p2p_marketplace/presentation/widgets/hub/p2p_home_page_state.dart` | P2P | `riskReview` | Offer → order → payment proof → dispute escrow contract |
| `lib/features/p2p_dispute/presentation/pages/dispute/p2p_dispute_resolution_page.dart` | P2P | `riskReview` | Dispute resolution result, refund amount, appeal status, and escrow contract |
| `lib/features/earn_staking/presentation/pages/staking/staking_earn_page.dart` | Earn | `riskReview` | Terms, validator setup, risk preview, confirmation, receipt |
| `lib/features/launchpad/presentation/pages/bridge/launchpad_bridge_order_page.dart` | Launchpad | `success` | Bridge order status tracking |
| `lib/features/predictions/presentation/pages/hub/predictions_home_page.dart` | Predictions | `riskReview` | Event setup, risk preview, confirmation, receipt |
| `lib/features/predictions/presentation/pages/event/prediction_event_detail_page.dart` | Predictions | `riskReview` | Rules, amount setup, probability preview, confirmation |
| `lib/features/predictions/presentation/widgets/event/prediction_order_receipt_page_sections.dart` | Predictions | `success` | Submitted receipt / recovery state |
| `lib/features/wallet/presentation/widgets/address/wallet_address_add_agreement.dart` | Wallet | `riskReview` | Withdrawal-address addition preview |
| `lib/features/profile/presentation/pages/security_page.dart` | Profile | `riskReview` | Account security review |
| `lib/features/p2p_account/presentation/pages/payment/p2p_payment_method_add_page.dart` | P2P | `riskReview` | Payment-method addition preview |
| `lib/features/p2p_account/presentation/pages/payment/p2p_payment_method_ownership_page.dart` | P2P | `riskReview` | Payment-method ownership verification |
| `lib/features/p2p_account/presentation/pages/payment/p2p_payment_method_cooling_period_page.dart` | P2P | `riskReview` | Payment-method cooling-period restriction |
| `lib/features/trade/presentation/widgets/futures/futures_page_state.dart` | Trade | dynamic (`submitting`/`success`/`error`/`offline`) | Futures order submit/receipt risk state |
| `lib/features/trade_bots/presentation/pages/hub/trading_bots_page.dart` | Trade Bots | `riskReview` | No-profit-guarantee disclosure before activating a bot |
| `lib/features/trade_copy/presentation/pages/hub/copy_trading_page.dart` | Trade Copy | `riskReview` | Drawdown/concentration/fee/stop-loss review before copying a strategy |

## Rules

1. **Both symbols, same file** — every file in the table above must contain
   the literal text `VitHighRiskStatePanel` **and** the literal text
   `highRiskContractId`. Either missing fails the test.
2. **Contract id comes from the domain snapshot** — the established pattern
   is `contractId: snapshot.highRiskContractId`, where `highRiskContractId`
   is a nullable `String?` field on that page's fixture/domain snapshot
   entity (e.g. `WithdrawSnapshot`, `P2PHomeSnapshot`). Panels are gated with
   `if (snapshot.highRiskContractId != null)` so the panel only renders once
   a real contract exists.
3. **No local warning banner** — do not hand-roll a `DecoratedBox`/`Container`
   warning row for risk-review or submitted/receipt states on these flows;
   route through `VitHighRiskStatePanel` instead.
4. **New high-risk pages follow the same pattern** — any new page that
   previews/confirms a withdrawal, escrow release, security change, address
   addition, or P2P payment-method change should adopt
   `VitHighRiskStatePanel` + `highRiskContractId` even before it is added to
   the guardrail's target set.

## Craft checklist (Trust polish)

Mandatory for Wave A polish (Tasks A2–A5) and any new high-risk
preview/confirm surface. Reviewers treat each item as a PASS/FAIL gate —
not guidance.

1. **Amount typography scale** — Preview and Confirm must use the same
   `AppTextStyles` amount scale (`amount*` / `heroNumber` family). Do not
   shrink the confirmed amount with an ad-hoc smaller style on the confirm
   step.
2. **Risk facts before final CTA** — Immediately above the final confirm
   CTA, show fee + network + masked address (or the flow’s equivalent risk
   facts) **and** irreversible / next-step copy in Vietnamese with full
   diacritics (e.g. “Không hoàn tác sau khi xác nhận”, “Bước tiếp theo:
   …”).
3. **Final CTA enablement** — Keep the final CTA disabled until all
   prerequisites are met (amount, destination, acknowledgements, etc.).
   The enabled state must be visually obvious (primary filled / active
   contrast — not a subtle opacity-only change).
4. **vi-VN copy only** — All user-facing strings use full Vietnamese with
   diacritics. Do not add new English UI strings; if a touched string is
   still English baseline debt, translate it in the same change.
5. **Shared risk panel (Rules)** — Keep `VitHighRiskStatePanel` +
   `highRiskContractId` per Rules above; craft polish does not replace the
   panel with a local banner.
6. **Confirm density** — Prefer calmer density on confirm / risk-review
   steps (`VitDensity.relaxed` or equivalent extra breathing room) versus
   dense trade / list surfaces (`.compact` / `.tool`).

## What `VitHighRiskStatePanel` renders

Defined in `lib/shared/widgets/vit_high_risk_state_panel.dart`. It is a
`StatelessWidget` keyed off a `VitHighRiskUiState` enum — `loading`, `empty`,
`error`, `offline`, `submitting`, `success`, `riskReview` — and delegates to
the matching shared primitive per state:

- `empty` → `VitEmptyState`, `error` → `VitErrorState`, `offline` →
  `VitOfflineBanner` (existing shared states, reused as-is).
- `loading`, `submitting`, `success`, `riskReview` → an internal
  `_CompactPanel`: an icon + title + message row in a bordered, tinted
  `ShapeDecoration` card (`AppRadii.cardRadius`), with the `contractId`
  string rendered as a trailing micro-text line when non-null.
  `riskReview` uses `AppColors.riskWarning` / `riskWarning08` /
  `warningBorder`; `success` uses the `buy` tone; `submitting` uses
  `primary` with a spinner.
- The whole panel wraps in a `Semantics` node whose label includes the
  contract id (`'High risk flow state: $state. Contract: $contractId'`) when
  one is present, so assistive tech can announce which contract a risk
  state belongs to.

## Wire pattern (reference: `withdraw_page.dart`)

```dart
if (snapshot.highRiskContractId != null)
  VitHighRiskStatePanel(
    state: VitHighRiskUiState.riskReview,
    title: 'Cần xem trước lệnh rút',
    message:
        'Địa chỉ, mạng, số tiền, phí và bước xác nhận được theo dõi '
        'trong cùng một hợp đồng chuyển tiền ví.',
    contractId: snapshot.highRiskContractId,
  ),
```

## Known limitations (state plainly, do not paper over)

- The guardrail is a **plain substring check** (`source.contains(...)`) over
  the whole file, not an AST/lint check that `contractId:` actually receives
  `highRiskContractId`. A file could in theory contain both tokens
  unconnected and still pass; in practice every target file today wires
  `contractId: snapshot.highRiskContractId` directly (see table above).
- The test checks a **fixed 16-file allowlist**, still not a directory scan.
  A whole-app audit on 2026-07-11
  (`flutter_app/run-artifacts/enterprise-grade-whole-app-review-2026-07-11.md`)
  found and fixed the 5 gaps AGENTS.md's Financial Safety section implied but
  the original 8-file list didn't cover (security changes, address additions,
  P2P payment-method changes) — all 5 now follow Rule 2 correctly and are in
  the table above. Two of the five turned out to be the same wiring-mismatch
  shape (panel present, `contractId` hardcoded to a literal instead of
  `snapshot.highRiskContractId`, no null-gate), not "panel missing entirely"
  as first assumed from a stale audit description — verified by reading the
  source directly before fixing. Any *new* high-risk page still won't be
  covered until someone manually adds it here — extending this to a directory
  scan remains unimplemented.

## Verify

```bash
cd flutter_app
flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact
```

## Related

- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — §2 domain-map row and §3 "Domains with a dedicated standard doc" both link here now; this file is that doc.
- [Flutter-Module-Identity-Standard.md](./Flutter-Module-Identity-Standard.md) — Home reference consistency
- [Flutter-Page-Archetype-Standard.md](./Flutter-Page-Archetype-Standard.md) — tab/wizard archetypes that many of these high-risk pages (withdraw, staking, prediction order) are built on
