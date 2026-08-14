# Segment-Pill Compliance Report

**Tool:** `flutter_app/tool/segment_pill_audit.dart`

## Executive summary

| Metric | Count |
| --- | ---: |
| Audit rows | 323 |
| Files with shared widgets | 290 |
| Compliance pass | 224 |
| Compliance warn | 0 |
| Compliance review | 99 |
| Interactive local classes | 0 |
| P0 local classes | 0 |

## Shared widget call sites

| Family | Call sites |
| --- | ---: |
| VitTabBar | 118 |
| VitChoicePill | 122 |
| VitSegmentedChoice | 89 |
| VitSegmentedTabBar | 26 |
| VitPresetChipRow | 30 |
| VitFilterChip | 58 |

## Module heat map

| Module | Audit rows |
| --- | ---: |
| admin | 1 |
| arena | 13 |
| auth | 2 |
| cross_module | 5 |
| dca | 12 |
| dev | 4 |
| discovery | 2 |
| earn_savings | 26 |
| earn_staking | 25 |
| enterprise_states | 2 |
| home | 2 |
| launchpad | 24 |
| markets | 36 |
| news | 1 |
| notifications | 1 |
| p2p_account | 6 |
| p2p_dispute | 4 |
| p2p_marketplace | 19 |
| p2p_orders | 9 |
| p2p_security | 8 |
| predictions | 22 |
| profile | 5 |
| referral | 2 |
| rewards | 1 |
| support | 2 |
| trade | 16 |
| trade_bots | 10 |
| trade_compliance | 20 |
| trade_copy | 17 |
| trade_terminal | 7 |
| wallet | 19 |

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
