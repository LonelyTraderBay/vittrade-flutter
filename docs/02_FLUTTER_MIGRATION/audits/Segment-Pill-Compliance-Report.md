# Segment-Pill Compliance Report

**Tool:** `flutter_app/tool/segment_pill_audit.dart`

## Executive summary

| Metric | Count |
| --- | ---: |
| Audit rows | 430 |
| Files with shared widgets | 376 |
| Compliance pass | 272 |
| Compliance warn | 0 |
| Compliance review | 158 |
| Interactive local classes | 0 |
| P0 local classes | 0 |

## Shared widget call sites

| Family | Call sites |
| --- | ---: |
| VitTabBar | 141 |
| VitChoicePill | 134 |
| VitSegmentedChoice | 108 |
| VitSegmentedTabBar | 41 |
| VitPresetChipRow | 36 |
| VitFilterChip | 132 |

## Module heat map

| Module | Audit rows |
| --- | ---: |
| admin | 1 |
| arena | 17 |
| auth | 2 |
| cross_module | 7 |
| dca | 13 |
| dev | 4 |
| discovery | 2 |
| earn_savings | 27 |
| earn_staking | 26 |
| enterprise_states | 2 |
| home | 2 |
| launchpad | 25 |
| markets | 51 |
| news | 2 |
| notifications | 1 |
| p2p_account | 6 |
| p2p_core | 16 |
| p2p_dispute | 4 |
| p2p_marketplace | 19 |
| p2p_orders | 9 |
| p2p_security | 8 |
| predictions | 46 |
| profile | 10 |
| referral | 2 |
| rewards | 2 |
| support | 2 |
| trade | 35 |
| trade_bots | 11 |
| trade_compliance | 21 |
| trade_copy | 20 |
| trade_terminal | 7 |
| wallet | 30 |

## Migration status

**Complete** — CI gate: `dart run tool/segment_pill_audit.dart --check --strict-full`.

## P0 migration targets

No P0 local classes remain.

## Regenerate

```bash
cd flutter_app
dart run tool/segment_pill_audit.dart
dart run tool/segment_pill_manifest.dart
dart run tool/segment_pill_audit.dart --check --strict-full
```
