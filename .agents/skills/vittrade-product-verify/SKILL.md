---
name: vittrade-product-verify
description: Verify high-risk VitTrade financial flows for preview/confirm, fees, limits, risk copy, masking, and acknowledgement safety.
---

# Product verification for high-risk flows

Use after changing withdrawals, deposits, transfers, address book, P2P
payment methods, escrow, or security settings. This is a read-only checklist
and does not replace human sign-off on real-money paths.

## Required behavior

- Preview and confirm withdrawals, escrow release, security changes, address
  additions, and P2P payment-method changes.
- Show fees, risk, limits, and next steps before high-risk confirmation.
- Mask account, wallet, email, phone, and address data in UI lists and logs.
- Use `showVitNoticeSheet` for required success/error acknowledgement, not a
  SnackBar toast.

## Flow probes

| Flow | Verify |
| --- | --- |
| Withdraw / transfer | Amount and fee summary are separate from the confirm CTA |
| Deposit | Network and asset are explicit; no false arrival success |
| Address book | Address and label are previewed before persistence |
| P2P payment method | Changes are previewed; existing data is not silently overwritten |
| Trade / bots | Coming-soon actions use the notice sheet |

Run the relevant guardrails from `flutter_app/`:

```powershell
flutter test test/quality/high_risk_state_primitives_guardrail_test.dart --reporter=compact
flutter test test/quality/product_copy_guardrails_test.dart --reporter=compact
flutter test test/quality/notice_acknowledgement_guardrail_test.dart --reporter=compact
```

Arena uses points-only language. Prediction Markets may use positions,
probability, receipts, rewards, and P/L, but must remain separate from Arena.
