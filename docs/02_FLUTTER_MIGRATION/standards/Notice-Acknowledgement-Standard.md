# Notice Acknowledgement Standard (Mandatory)

**Authority:** Derived from the shipped `showVitNoticeSheet` API in
**Scope:** every screen on both surfaces (phone + tablet) — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
`flutter_app/lib/shared/widgets/vit_offline_banner.dart`, the Trade receipt /
submit reference (`order_receipt_page.dart`, `trade_page_state.dart`), and
rollout plan
[Notice-Acknowledgement-Rollout-Plan.md](../../_archive/2026-migrations-closed/Notice-Acknowledgement-Rollout-Plan.md).  
**Enforcement:** `test/quality/notice_acknowledgement_guardrail_test.dart` (+
baseline ratchet `notice_acknowledgement_baseline.txt`).  
**Related (do not conflate):** [Bottom-Sheet-Standard.md](./Bottom-Sheet-Standard.md)
covers `showVitBottomSheet` vs raw `showModalBottomSheet` only.

## Problem this standard prevents

Post-action acknowledgements (success, error, “coming soon”, must-read) were
implemented inconsistently: sticky dual CTAs, semi-transparent `Positioned`
toasts over list content, and `SnackBar` stubs. That caused overlapping
unreadable UI and two visual languages for the same job.

## Classification

| Job | Required pattern | Not this standard |
| --- | --- | --- |
| Success / error / “sẽ sớm ra mắt” / must-ack | `showVitNoticeSheet` | — |
| Form CTA while editing (Submit / Next / Emergency Stop) | `VitStickyFooter` / `VitTradeDetailScaffold.footer` | Keep sticky |
| Financial preview/confirm | `VitPreviewConfirmSheet` / dedicated form sheets | Keep |
| Persistent inline status (offline, form field errors, disclaimers) | Inline `VitBanner` / `VitOfflineBanner` in page flow | Keep |
| Sheet chrome / navigators | `showVitBottomSheet` | [Bottom-Sheet-Standard.md](./Bottom-Sheet-Standard.md) |

## Rules

1. New or changed **acknowledgement** UX **must** call `showVitNoticeSheet`
   (title + message + primary CTA; optional secondary + `ctaVariant`).
2. Trade / financial **success** acknowledgements use
   `variant: VitBannerVariant.success` and
   `ctaVariant: VitCtaButtonVariant.success` (not brand-orange primary) unless
   product copy requires a neutral dismiss only.
3. Do **not** use `ScaffoldMessenger.showSnackBar` / `SnackBar` for
   user-facing acknowledgements under `lib/features/**/presentation/`.
4. Do **not** overlay success with `Stack` + `Positioned` + `VitBanner` (or
   local `_SuccessToast` / `TransferSuccessBanner` / similar).
5. Do **not** put Share + Continue (or equivalent post-action dual CTAs) in a
   sticky page footer — use stacked CTAs inside `showVitNoticeSheet` (see
   Trade receipt).
6. Sticky footers remain valid **only** for in-progress form / wizard actions
   that must stay visible while the user edits fields above.
7. Prefer a module-local `_showComingSoon` helper that forwards to
   `showVitNoticeSheet` instead of copying sheet args at every stub.

## Wire pattern

```dart
await showVitNoticeSheet(
  context: context,
  title: 'Lệnh đã gửi',
  message: 'Đã gửi ORD-123',
  variant: VitBannerVariant.success,
  ctaVariant: VitCtaButtonVariant.success,
  ctaLabel: 'Tiếp tục giao dịch',
  secondaryLabel: 'Chia sẻ',
  secondaryPressedLabel: 'Đã chia sẻ',
  onPrimary: () => context.go(AppRoutePaths.tradePair('btcusdt')),
);
```

Minimal ack (default primary CTA “Đã hiểu”):

```dart
await showVitNoticeSheet(
  context: context,
  title: 'Sắp ra mắt',
  message: 'Tính năng này sẽ sớm khả dụng.',
);
```

`onPrimary` runs **after** the sheet pops (wrapper always pops first).

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| `SnackBar` for success / coming-soon | Wrong chrome; inconsistent with notice sheet |
| `Positioned` success `VitBanner` over scroll content | Translucent tint + list bleed (overlap bug) |
| Sticky footer Share + Continue after submit | Duplicates sheet; fights scroll/auto-hide |
| Custom “Đã hiểu” `VitSheetSurface` without `showVitNoticeSheet` | Drifts title/banner/CTA contract |
| Using `VitStickyFooter` for one-shot ack after navigation | Sticky is for live form actions only |

## Exceptions

- Line marker: `// notice-ack: allow-<reason>` (e.g. `allow-dev-stub`,
  `allow-marketing-dismiss`) — must be documented; baseline ratchet may list
  path:line until migrated.
- Hard allowlist in the guardrail: `vit_offline_banner.dart`, tests, data
  fixtures, and explicitly listed marketing dismiss paths (e.g. home
  announcement).
- Persistent inline `VitBanner` for form/validation/offline is **not** an
  acknowledgement toast and is allowed without a marker.

## Verify

```bash
cd flutter_app
flutter test test/quality/notice_acknowledgement_guardrail_test.dart --reporter=compact
flutter test test/shared/widgets/vit_offline_banner_test.dart --reporter=compact
```

## Related

- [Notice-Acknowledgement-Rollout-Plan.md](../../_archive/2026-migrations-closed/Notice-Acknowledgement-Rollout-Plan.md) — batch order (archived)
- [Bottom-Sheet-Standard.md](./Bottom-Sheet-Standard.md) — `showVitBottomSheet` wrapper
- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — domain map
- [High-Risk-State-Standard.md](./High-Risk-State-Standard.md) — high-risk panels (separate from notice ack)
