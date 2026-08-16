# VitTrade Home Reference Consistency Audit

Generated: 2026-07-07

Generated from `flutter_app/tool/home_reference_consistency_audit.dart`. Measures structural divergence from the patterns established by `lib/features/home/presentation/**` — the canonical UI reference ("SC-007 HomePage", see Flutter-Module-Identity-Standard.md): raw `Container`/`BoxDecoration` instead of `VitCard`, `BorderRadius.circular(`/`Radius.circular(` instead of `AppRadii.*`, raw `EdgeInsets.*(` literals, and oversized fixed width/height literals. Every module — not just a P0 subset — is hard-gated against its own frozen baseline below; regressions fail CI.

## Module Gate (all modules, frozen baseline)

| module | current divergence | baseline | status |
| --- | ---: | ---: | --- |
| admin | 0 | 0 | pass |
| arena | 0 | 6 | pass |
| auth | 0 | 0 | pass |
| cross_module | 0 | 0 | pass |
| dca | 0 | 1 | pass |
| dev | 0 | 0 | pass |
| discovery | 0 | 0 | pass |
| earn_core | 0 | 0 | pass |
| earn_savings | 0 | 0 | pass |
| earn_staking | 0 | 0 | pass |
| enterprise_states | 0 | 0 | pass |
| home | 0 | 0 | pass |
| launchpad | 0 | 0 | pass |
| markets | 0 | 0 | pass |
| news | 0 | 1 | pass |
| notifications | 0 | 1 | pass |
| onboarding | 0 | 0 | pass |
| p2p_account | 0 | 0 | pass |
| p2p_core | 0 | 0 | pass |
| p2p_dispute | 0 | 0 | pass |
| p2p_marketplace | 0 | 0 | pass |
| p2p_orders | 0 | 0 | pass |
| p2p_security | 0 | 0 | pass |
| predictions | 0 | 0 | pass |
| profile | 0 | 0 | pass |
| referral | 0 | 0 | pass |
| rewards | 1 | 2 | pass |
| support | 0 | 3 | pass |
| trade | 0 | 0 | pass |
| trade_bots | 0 | 0 | pass |
| trade_compliance | 0 | 0 | pass |
| trade_copy | 0 | 0 | pass |
| trade_core | 0 | 0 | pass |
| trade_terminal | 0 | 0 | pass |
| wallet | 0 | 0 | pass |

## Top Divergence Files (non-exception)
| module | path | total | container | boxDecoration | borderRadius.circular | radius.circular | edgeInsets | fixedWidth | fixedHeight |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| rewards | `flutter_app/lib/features/rewards/presentation/widgets/rewards_hub_hero_section.dart` | 1 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |

## Verification Commands
```bash
cd flutter_app
dart run tool/home_reference_consistency_audit.dart
dart run tool/home_reference_consistency_audit.dart --check
```
