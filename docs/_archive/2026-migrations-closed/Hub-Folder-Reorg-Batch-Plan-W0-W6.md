# Hub Folder Reorg — Batch Plan Wave 0 → Wave 6

**Generated:** 2026-07-14  
**Scope:** Move-only / rename-folder organization. **No UI redesign** in these batches.  
**Rule:** 5–10 files per batch · 1 chat per batch · fix imports + router if paths change.

## Global rules (every batch)

| Rule | Detail |
|------|--------|
| Action type | `git mv` (or explorer move) + update `package:vit_trade_flutter/...` imports |
| Do NOT | Change widget trees, tokens, copy, pub deps, business logic |
| Router | Update imports in `lib/app/router/**` and test imports under `test/` |
| Part files | Moving `*_part_*.dart` keeps `part of` / `part` directives in sync |
| Gate (every batch) | From `flutter_app/`: `flutter analyze` on touched paths; if router paths change: `dart run tool/route_coverage_audit.dart --check` |
| Optional gate | `flutter test test/quality/router_contract_test.dart` when route imports change |
| Stop if | Import graph breaks across Prediction Markets ↔ Arena (never mix in one batch) |

**Path prefix (all relative):** `flutter_app/lib/features/`

---

## Wave 0 — Trade polish + trade_bots hub parts

**Goal:** Align `trade` widgets with `pages/hub`; extract `*_part_*` into semantic widgets; finish `trade_bots` hub widget gap.

### W0-B1 — `trade` rename `widgets/spot` → `widgets/hub` (orders/positions/settings)

**Status:** ✅ DONE 2026-07-14  
**Depends on:** —  
**Files (9 moves):**

| # | From | To |
|--:|------|----|
| 1 | `trade/presentation/widgets/spot/order_receipt_page_common.dart` | `trade/presentation/widgets/hub/order_receipt_page_common.dart` |
| 2 | `trade/presentation/widgets/spot/order_receipt_page_sections.dart` | `trade/presentation/widgets/hub/order_receipt_page_sections.dart` |
| 3 | `trade/presentation/widgets/spot/orders_history_page_common.dart` | `trade/presentation/widgets/hub/orders_history_page_common.dart` |
| 4 | `trade/presentation/widgets/spot/orders_history_page_sections.dart` | `trade/presentation/widgets/hub/orders_history_page_sections.dart` |
| 5 | `trade/presentation/widgets/spot/position_dashboard_page_common.dart` | `trade/presentation/widgets/hub/position_dashboard_page_common.dart` |
| 6 | `trade/presentation/widgets/spot/position_dashboard_page_sections.dart` | `trade/presentation/widgets/hub/position_dashboard_page_sections.dart` |
| 7 | `trade/presentation/widgets/spot/trade_settings_page_common.dart` | `trade/presentation/widgets/hub/trade_settings_page_common.dart` |
| 8 | `trade/presentation/widgets/spot/trade_settings_page_sections.dart` | `trade/presentation/widgets/hub/trade_settings_page_sections.dart` |
| 9 | `trade/presentation/widgets/spot/trade_product_navigation.dart` | `trade/presentation/widgets/hub/trade_product_navigation.dart` |

**Also:** update all imports referencing `.../widgets/spot/...` for these 9 files.  
**Verify:** `flutter analyze lib/features/trade`

---

### W0-B2 — `trade` move export + terminal chrome into `widgets/hub`

**Status:** ✅ DONE 2026-07-14 — `widgets/spot/` deleted  
**Depends on:** W0-B1  
**Files (9 moves):**

| # | From | To |
|--:|------|----|
| 1 | `trade/presentation/widgets/spot/trade_history_export_footer.dart` | `trade/presentation/widgets/hub/trade_history_export_footer.dart` |
| 2 | `trade/presentation/widgets/spot/trade_history_export_selectors_includes.dart` | `trade/presentation/widgets/hub/trade_history_export_selectors_includes.dart` |
| 3 | `trade/presentation/widgets/spot/trade_history_export_summary_sections.dart` | `trade/presentation/widgets/hub/trade_history_export_summary_sections.dart` |
| 4 | `trade/presentation/widgets/spot/vit_trade_confirm_sheet.dart` | `trade/presentation/widgets/hub/vit_trade_confirm_sheet.dart` |
| 5 | `trade/presentation/widgets/spot/vit_trade_side_switch.dart` | `trade/presentation/widgets/hub/vit_trade_side_switch.dart` |
| 6 | `trade/presentation/widgets/spot/vit_trade_simple_hero.dart` | `trade/presentation/widgets/hub/vit_trade_simple_hero.dart` |
| 7 | `trade/presentation/widgets/spot/vit_trade_simple_order_form.dart` | `trade/presentation/widgets/hub/vit_trade_simple_order_form.dart` |
| 8 | `trade/presentation/widgets/spot/vit_trade_simple_shell.dart` | `trade/presentation/widgets/hub/vit_trade_simple_shell.dart` |
| 9 | `trade/presentation/widgets/spot/vit_trade_terminal_header.dart` | `trade/presentation/widgets/hub/vit_trade_terminal_header.dart` |

**Exit criteria:** `widgets/spot/` empty → delete folder.  
**Verify:** `flutter analyze lib/features/trade`

---

### W0-B3 — `trade` convert: parts → widgets

**Status:** ✅ DONE 2026-07-14 — safer variant (`part` kept under `widgets/convert/`, filenames unchanged)  
**Depends on:** W0-B2  
**Files (≤6 touched — move + thin page):**

| # | Action | Path |
|--:|--------|------|
| 1 | Move | `pages/convert/convert_page_part_01.dart` → `widgets/convert/convert_page_sections_a.dart` *(or keep filename if `part of` — prefer keep as `part` under widgets only if package supports; else inline export as library widgets)* |
| 2 | Move | `pages/convert/convert_page_part_02.dart` → `widgets/convert/convert_page_sections_b.dart` |
| 3 | Edit | `pages/convert/convert_page.dart` — replace `part` with imports of new widgets |
| 4–5 | Edit | existing `widgets/convert/convert_page_*.dart` imports if needed |
| 6 | Analyze gate | — |

> If `part of` couples tightly, **safer variant:** keep `part` files but move them next to widgets under `widgets/convert/` and update `part` URIs in `convert_page.dart` only (still counts as batch).

**Verify:** `flutter analyze lib/features/trade/presentation`

---

### W0-B4 — `trade` futures: parts → widgets

**Status:** ✅ DONE 2026-07-14 — safer variant under `widgets/futures/`  
**Depends on:** W0-B3  
**Files:**

| # | From / Edit | To |
|--:|-------------|----|
| 1 | `pages/futures/futures_page_part_01.dart` | `widgets/futures/futures_page_sections_a.dart` (or keep `part` under widgets) |
| 2 | `pages/futures/futures_page_part_02.dart` | `widgets/futures/futures_page_sections_b.dart` |
| 3 | Edit `pages/futures/futures_page.dart` | update part/import |
| 4–6 | Touch if imported: `widgets/futures/leverage_*.dart` | import-only |

**Verify:** `flutter analyze lib/features/trade`

---

### W0-B5 — `trade` hub + margin: parts → widgets

**Status:** ✅ DONE 2026-07-14 — safer variant under `widgets/hub/` + `widgets/margin/`  
**Depends on:** W0-B4  
**Files (10):**

| # | From | To |
|--:|------|----|
| 1 | `pages/hub/trade_page_part_01.dart` | `widgets/hub/trade_page_sections.dart` |
| 2 | Edit `pages/hub/trade_page.dart` | wire new sections |
| 3 | `pages/margin/margin_trading_page_part_01.dart` | `widgets/margin/margin_trading_sections_01.dart` |
| 4 | `pages/margin/margin_trading_page_part_02.dart` | `widgets/margin/margin_trading_sections_02.dart` |
| 5 | `pages/margin/margin_trading_page_part_03.dart` | `widgets/margin/margin_trading_sections_03.dart` |
| 6 | `pages/margin/margin_trading_page_part_04.dart` | `widgets/margin/margin_trading_sections_04.dart` |
| 7 | Edit `pages/margin/margin_trading_page.dart` | wire sections |
| 8–10 | Import sweep in `widgets/margin/*` | as needed |

**Verify:** `flutter analyze lib/features/trade` + `dart run tool/route_coverage_audit.dart --check`

---

### W0-B6 — `trade_bots` hub parts → `widgets/hub`

**Status:** ✅ DONE 2026-07-14 — safer variant (`trading_bots_page_part_0N` under `widgets/hub/`)  
**Depends on:** — (parallel with W0-B1 OK)  
**Files (9):**

| # | From | To |
|--:|------|----|
| 1 | `trade_bots/presentation/pages/hub/trading_bots_page_part_01.dart` | `trade_bots/presentation/widgets/hub/trading_bots_sections_01.dart` |
| 2 | `.../trading_bots_page_part_02.dart` | `widgets/hub/trading_bots_sections_02.dart` |
| 3 | `.../trading_bots_page_part_03.dart` | `widgets/hub/trading_bots_sections_03.dart` |
| 4 | `.../trading_bots_page_part_04.dart` | `widgets/hub/trading_bots_sections_04.dart` |
| 5 | Edit `pages/hub/trading_bots_page.dart` | wire |
| 6–9 | Fix imports / part directives | — |

**Note:** `widgets/hub/` currently empty — create folder.  
**Verify:** `flutter analyze lib/features/trade_bots`

---

### Wave 0 exit checklist

- [x] `trade/presentation/widgets/spot/` deleted  
- [x] No `*_part_*.dart` under `trade/presentation/pages/`  
- [x] No `*_part_*.dart` under `trade_bots/presentation/pages/hub/`  
- [x] Route audit green  
- [x] W0-B1…W0-B6 complete (2026-07-14)

**Wave 0 complete.** Next: Wave 1 (Earn hub).  

---

## Wave 1 — Earn hub completion (P0)

**Goal:** Finish migrate all staking/savings into hub folders (pages then widgets).  
**Already nested:** 6 staking pages + 21 staking widgets — leave them; only move remaining flat files.

### W1-B1 — Earn pages: staking entry + dashboard cluster

**Files (8 moves → `earn/presentation/pages/staking/`):**

1. `pages/staking_earn_page.dart`
2. `pages/staking_dashboard_page.dart`
3. `pages/staking_analytics_page.dart`
4. `pages/staking_history_page.dart`
5. `pages/staking_earnings_calendar_page.dart`
6. `pages/staking_notifications_page.dart`
7. `pages/earn_portfolio_page.dart` → `pages/hub/earn_portfolio_page.dart` *(create `pages/hub/`)*
8. Update: `lib/app/router/route_groups/earn_routes.dart` (+ any `app_router.dart` imports)

**Verify:** route audit + `flutter analyze lib/features/earn lib/app/router`

---

### W1-B2 — Earn pages: staking products / validators

**Files (8 → `pages/staking/`):**

1. `staking_liquid_staking_page.dart`
2. `staking_multi_chain_page.dart`
3. `staking_validator_selection_page.dart`
4. `staking_validator_health_monitor_page.dart`
5. `staking_recommendations_page.dart`
6. `staking_institutional_page.dart`
7. `staking_auto` — already nested: skip `staking_auto_compound_page`  
8. `auto_compound_settings_page.dart` → `pages/staking/auto_compound_settings_page.dart`

**Verify:** analyze + route audit

---

### W1-B3 — Earn pages: staking risk / insurance / reserves

**Files (9 → `pages/staking/`):**

1. `staking_risk_assessment_page.dart`
2. `staking_risk_dashboard_page.dart`
3. `staking_risk_disclosure_page.dart`
4. `staking_risk_score_calculator_page.dart`
5. `staking_insurance_page.dart`
6. `staking_insurance_fund_transparency_page.dart`
7. `staking_proof_of_reserves_page.dart`
8. `staking_slashing_history_page.dart`
9. `staking_withdrawal_policy_page.dart`

**Verify:** analyze + route audit

---

### W1-B4 — Earn pages: staking governance / social / compliance docs

**Files (10 → `pages/staking/`):**

1. `staking_community_governance_page.dart`
2. `staking_proposals_page.dart`
3. `staking_voting_page.dart`
4. `staking_social_feed_page.dart`
5. `staking_forum_page.dart`
6. `staking_suitability_assessment_page.dart`
7. `staking_regulatory_framework_page.dart`
8. `staking_terms_page.dart`
9. `staking_faq_page.dart`
10. `staking_tax_guide_page.dart`

**Verify:** analyze + route audit

---

### W1-B5 — Earn pages: staking remaining tools

**Files (9 → `pages/staking/`):**

1. `staking_api_documentation_page.dart`
2. `staking_developer_console_page.dart`
3. `staking_webhooks_page.dart`
4. `staking_third_party_integrations_page.dart`
5. `staking_data_export_page.dart`
6. `staking_transaction_reporting_page.dart`
7. `staking_emergency_actions_page.dart`
8. Router import sweep if any path still flat
9. Confirm **0** flat `staking_*.dart` under `pages/`

**Verify:** analyze + route audit

---

### W1-B6 — Earn pages: savings hub + portfolio flow

**Files (9 → `pages/savings/`):** create folder

1. `savings_page.dart`
2. `savings_portfolio_page.dart`
3. `savings_product_detail_page.dart`
4. `savings_history_page.dart`
5. `savings_receipt_page.dart`
6. `savings_redeem_page.dart`
7. `savings_goal_page.dart`
8. `savings_guide_page.dart`
9. Update `earn_routes.dart`

**Verify:** analyze + route audit

---

### W1-B7 — Earn pages: savings tools + remaining

**Files (10 → `pages/savings/`):**

1. `savings_analytics_page.dart`
2. `savings_auto_rebalance_page.dart`
3. `savings_autopilot_page.dart`
4. `savings_backtest_page.dart`
5. `savings_comparison_page.dart`
6. `savings_dca_page.dart`
7. `savings_export_page.dart`
8. `savings_faq_page.dart`
9. `savings_ladder_page.dart`
10. `savings_notification_preferences_page.dart`

---

### W1-B8 — Earn pages: savings last + what-if parts

**Files (8 → `pages/savings/`):**

1. `savings_notifications_page.dart`
2. `savings_recommendations_page.dart`
3. `savings_risk_assessment_page.dart`
4. `savings_smart_suggestions_page.dart`
5. `savings_what_if_page.dart`
6. `savings_what_if_page_part_01.dart`
7. `savings_what_if_page_part_04.dart`
8. Confirm **0** flat `savings_*.dart` under `pages/`

**Verify:** analyze + route audit

---

### W1-B9 … W1-B20 — Earn widgets move (prefix → hub)

Move flat widgets in chunks of **8–10** files:

| Batch | Destination | Files |
|-------|-------------|-------|
| W1-B9 | `widgets/staking/` | `staking_earn_*` (3) + `staking_dashboard_*` (5) = 8 |
| W1-B10 | `widgets/staking/` | `staking_analytics_*` (6) + `staking_earnings_*` (3) = 9 |
| W1-B11 | `widgets/staking/` | `staking_history_*` (3) + `staking_liquid_staking_*` (7) = 10 |
| W1-B12 | `widgets/staking/` | `staking_multi_chain_*` (2) + `staking_notifications_*` (2) + `staking_validator_*` (6) = 10 |
| W1-B13 | `widgets/staking/` | `staking_recommendations_*` (4) + `staking_institutional_*` (3) + `staking_api_documentation_*` (5) = 12 → **split to B13a (8) / B13b (4)** |
| W1-B13a | `widgets/staking/` | recommendations (4) + institutional (3) + api auth/common = 9 |
| W1-B13b | `widgets/staking/` | remaining `staking_api_documentation_*` |
| W1-B14 | `widgets/staking/` | all `staking_insurance_*` (12) → **B14a (6) + B14b (6)** |
| W1-B15 | `widgets/staking/` | `staking_proof_of_reserves_*` (6) + `staking_slashing_*` (5) = 11 → split 6+5 |
| W1-B16 | `widgets/staking/` | `staking_risk_*` (10) |
| W1-B17 | `widgets/staking/` | `staking_withdrawal_*` (5) + `staking_tax_*` (5) = 10 |
| W1-B18 | `widgets/staking/` | suitability/social/governance/regulatory/transaction (remaining ~14) → two batches of 7 |
| W1-B19 | `widgets/savings/` | `savings_home_*` (4) + `savings_portfolio_*` (6) = 10 |
| W1-B20 | `widgets/savings/` | `savings_goal_*` (6) + `savings_history_*` (2) + `savings_guide_*` (4) = 12 → 6+6 |
| W1-B21 | `widgets/savings/` | `savings_ladder_*` (8) + `savings_dca_*` (4) = 12 → 8+4 |
| W1-B22 | `widgets/savings/` | `savings_auto_rebalance_*` (8) + `savings_autopilot_*` (6) → two batches |
| W1-B23 | `widgets/savings/` | `savings_backtest_*` (6) + `savings_analytics_*` (3) + export/faq (5) |
| W1-B24 | `widgets/savings/` | notifications/preferences/recommendations/risk/smart/what_if (remaining) |
| W1-B25 | `widgets/hub/` or `widgets/shared/` | `earn_comparison_*` (3) + `earn_custody_risk_banner.dart` + `earn_formatters.dart` + `auto_compound_settings_*` (5) |

**Explicit W1-B9 file list:**

1. `widgets/staking_earn_hero_tabs.dart` → `widgets/staking/`
2. `widgets/staking_earn_positions_common.dart` → `widgets/staking/`
3. `widgets/staking_earn_products.dart` → `widgets/staking/`
4. `widgets/staking_dashboard_actions.dart` → `widgets/staking/`
5. `widgets/staking_dashboard_charts.dart` → `widgets/staking/`
6. `widgets/staking_dashboard_common.dart` → `widgets/staking/`
7. `widgets/staking_dashboard_positions.dart` → `widgets/staking/`
8. `widgets/staking_dashboard_summary.dart` → `widgets/staking/`

*(Subsequent W1 widget batches: take next 8–10 names from the sorted `staking_*.dart` / `savings_*.dart` flat lists in § inventory above — same move pattern.)*

### Wave 1 exit checklist

- [x] `pages/` root has **0** `staking_*.dart` / `savings_*.dart`  
- [x] `widgets/` root has **0** `staking_*.dart` / `savings_*.dart`  
- [x] Folders: `pages/{staking,savings}` + `widgets/{hub,staking,savings}`  
- [x] **DONE 2026-07-14** — Note: `earn_portfolio_page.dart` is a `part` of `savings_portfolio_page` (lives under `pages/savings/`), not a hub page.

**Wave 1 complete.**  

---

## Wave 2 — `trade_copy` hub fold (P0)

**Hubs:** `hub` · `provider` · `flow` · `analytics` · `safety`

### W2-B1 — pages → hub

**Files (7 → `trade_copy/presentation/pages/hub/`):**

1. `copy_trading_page.dart`
2. `active_copies_page.dart`
3. `copy_settings_page.dart`
4. `copy_notifications_page.dart`
5. `copy_trading_card_demo.dart`
6. Update `route_groups/trade_copy_routes.dart`
7. Update `app_router.dart` imports if present

---

### W2-B2 — pages → provider

**Files (7 → `pages/provider/`):**

1. `provider_leaderboard_page.dart`
2. `provider_comparison_page.dart`
3. `copy_provider_detail_page.dart`
4. `trader_profile_page.dart`
5. `provider_application_page.dart`
6. `provider_governance_page.dart`
7. Router import sweep

---

### W2-B3 — pages → flow + analytics + safety

**Files (10):**

| File | To |
|------|----|
| `pre_copy_assessment_page.dart` | `pages/flow/` |
| `copy_configuration_page.dart` | `pages/flow/` |
| `copy_confirmation_page.dart` | `pages/flow/` |
| `copy_performance_page.dart` | `pages/analytics/` |
| `performance_attribution_page.dart` | `pages/analytics/` |
| `portfolio_risk_analysis_page.dart` | `pages/analytics/` |
| `copy_safety_center_page.dart` | `pages/safety/` |
| `safety_education_page.dart` | `pages/safety/` |
| `copy_education_page.dart` | `pages/safety/` |
| `dispute_resolution_page.dart` + `copy_audit_log_page.dart` | `pages/safety/` — **split:** put dispute+audit in W2-B3b if >10 |

**W2-B3b (2 files):** `dispute_resolution_page.dart`, `copy_audit_log_page.dart` → `pages/safety/`

**Verify:** route audit

---

### W2-B4 — widgets → hub (10)

1–5. `active_copies_*.dart` (5 files)  
6–9. `copy_trading_*.dart` hero/list/metrics/card_demo set — take:  
   `copy_trading_hero.dart`, `copy_trading_list.dart`, `copy_trading_metrics_common.dart`, `copy_settings_controls.dart`  
10. `copy_settings_modes.dart` → finish settings in B5 if needed  

**Exact W2-B4 (10):**

1. `active_copies_alerts_modal.dart` → `widgets/hub/`  
2. `active_copies_card.dart` → `widgets/hub/`  
3. `active_copies_expanded_details.dart` → `widgets/hub/`  
4. `active_copies_overview.dart` → `widgets/hub/`  
5. `active_copies_shared.dart` → `widgets/hub/`  
6. `copy_trading_hero.dart` → `widgets/hub/`  
7. `copy_trading_list.dart` → `widgets/hub/`  
8. `copy_trading_metrics_common.dart` → `widgets/hub/`  
9. `copy_notifications_page_common.dart` → `widgets/hub/`  
10. `copy_notifications_page_sections.dart` → `widgets/hub/`  

---

### W2-B5 — widgets → hub (settings + card demo)

1. `copy_settings_contacts_privacy.dart`  
2. `copy_settings_controls.dart`  
3. `copy_settings_modes.dart`  
4. `copy_trading_card_demo_common.dart`  
5. `copy_trading_card_demo_primitives.dart`  
6. `copy_trading_card_demo_sections.dart`  
7. `copy_trading_card_demo_widgets.dart`  
→ all `widgets/hub/`

---

### W2-B6 — widgets → provider (10)

1. `provider_leaderboard_cards.dart`  
2. `provider_leaderboard_controls.dart`  
3. `provider_leaderboard_disclaimer.dart`  
4. `provider_application_common.dart`  
5. `provider_application_progress_intro.dart`  
6. `provider_application_steps.dart`  
7. `provider_governance_page_common.dart`  
8. `provider_governance_page_details.dart`  
9. `provider_governance_page_overview.dart`  
10. `trader_profile_overview.dart`  

---

### W2-B7 — widgets → provider (trader rest) + flow

1. `trader_profile_chart_painters.dart` → `widgets/provider/`  
2. `trader_profile_stats_common.dart` → `widgets/provider/`  
3. `trader_profile_trades.dart` → `widgets/provider/`  
4. `copy_configuration_provider_capital_mode.dart` → `widgets/flow/`  
5. `copy_configuration_risk_summary.dart` → `widgets/flow/`  
6. `copy_configuration_validation_common.dart` → `widgets/flow/`  
7. `copy_confirmation_page_common.dart` → `widgets/flow/`  
8. `copy_confirmation_page_sections.dart` → `widgets/flow/`  

---

### W2-B8 — widgets → analytics

1. `copy_performance_common.dart`  
2. `copy_performance_details.dart`  
3. `copy_performance_summary_tabs.dart`  
4. `performance_attribution_common.dart`  
5. `performance_attribution_painters.dart`  
6. `performance_attribution_summary_tabs.dart`  
7. `performance_attribution_tabs.dart`  
8. `portfolio_risk_analysis_page_common.dart`  
9. `portfolio_risk_analysis_page_sections.dart`  

---

### W2-B9 — widgets → safety (remaining)

1. `copy_audit_log_controls.dart`  
2. `copy_audit_log_events.dart`  
3. `copy_audit_log_summary.dart`  
4. `copy_safety_enforcement_common.dart`  
5. `copy_safety_metrics_tools.dart`  
6. `copy_safety_overview.dart`  
7. `copy_education_page_common.dart`  
8. `copy_education_page_sections.dart`  
9. `safety_education_page_common.dart`  
10. `safety_education_page_sections.dart`  

**W2-B10:** `dispute_resolution_cases.dart`, `dispute_resolution_common.dart`, `dispute_resolution_form.dart` → `widgets/safety/`

### Wave 2 exit

- [ ] `pages/` and `widgets/` roots empty of `.dart`  
- [ ] Hubs exist on both sides  

---

## Wave 3 — P2P hub fold (P1)

**Hubs:** `hub` · `ads` · `orders` · `payment` · `dispute` · `merchant` · `security` · `wallet`

### W3-B1 — pages → hub (9)

1. `p2p_home_page.dart` → `pages/hub/`  
2. `p2p_dashboard_page.dart` → `pages/hub/`  
3. `p2p_express_page.dart` → `pages/hub/`  
4. `p2p_express_confirm_page.dart` → `pages/hub/`  
5. `p2p_guide_page.dart` → `pages/hub/`  
6. `p2p_settings_page.dart` → `pages/hub/`  
7. `p2p_notifications_settings_page.dart` → `pages/hub/`  
8. `p2p_trading_level_page.dart` → `pages/hub/`  
9. Update `route_groups/p2p_routes.dart`  

---

### W3-B2 — pages → ads (6)

1. `p2p_ad_detail_page.dart`  
2. `p2p_ad_analytics_page.dart`  
3. `p2p_create_ad_page.dart`  
4. `p2p_my_ads_page.dart`  
5. `p2p_order_book_page.dart` *(ads/book surface)*  
6. Router sweep  

---

### W3-B3 — pages → orders (10)

1. `p2p_order_page.dart`  
2. `p2p_my_orders_page.dart`  
3. `p2p_order_cancel_page.dart`  
4. `p2p_order_proof_page.dart`  
5. `p2p_order_rate_page.dart`  
6. `p2p_order_timeline_page.dart`  
7. `p2p_chat_page.dart`  
8. `p2p_escrow_balance_page.dart`  
9. `p2p_escrow_detail_page.dart`  
10. `p2p_fund_lock_history_page.dart`  

---

### W3-B4 — pages → payment (6)

1. `p2p_payment_methods_page.dart`  
2. `p2p_payment_method_add_page.dart`  
3. `p2p_payment_method_cooling_period_page.dart`  
4. `p2p_payment_method_history_page.dart`  
5. `p2p_payment_method_ownership_page.dart`  
6. `p2p_payment_method_verification_page.dart`  

---

### W3-B5 — pages → dispute / insurance (10)

1. `p2p_dispute_page.dart`  
2. `p2p_disputes_page.dart`  
3. `p2p_dispute_detail_page.dart`  
4. `p2p_dispute_evidence_page.dart`  
5. `p2p_dispute_resolution_page.dart`  
6. `p2p_claim_detail_page.dart`  
7. `p2p_claim_detail_page_part_01.dart`  
8. `p2p_claim_detail_page_part_02.dart`  
9. `p2p_claim_detail_page_part_03.dart`  
10. `p2p_insurance_fund_page.dart`  

**W3-B5b:** insurance siblings → `pages/dispute/`:  
`p2p_insurance_fund_page_part_01..03.dart`, `p2p_insurance_certificate_page.dart`, `p2p_insurance_policy_page.dart`, `p2p_insurance_score_page.dart`

---

### W3-B6 — pages → merchant + KYC (10)

1. `p2p_merchant_apply_page.dart`  
2. `p2p_merchant_apply_page_part_01.dart`  
3. `p2p_merchant_apply_page_part_02.dart`  
4. `p2p_merchant_apply_page_part_03.dart`  
5. `p2p_merchant_profile_page.dart`  
6. `p2p_kyc_requirements_page.dart`  
7. `p2p_kyc_status_page.dart`  
8. `p2p_identity_verification_page.dart`  
9. `p2p_selfie_verification_page.dart`  
10. `p2p_video_verification_page.dart`  

---

### W3-B7 — pages → security (10)

1. `p2p_security_center_page.dart`  
2. `p2p_blacklist_page.dart`  
3. `p2p_blacklist_add_page.dart`  
4. `p2p_fraud_prevention_page.dart`  
5. `p2p_suspicious_activity_page.dart`  
6. `p2p_2fa_settings_page.dart`  
7. `p2p_anti_phishing_code_page.dart`  
8. `p2p_device_management_page.dart`  
9. `p2p_login_history_page.dart`  
10. `p2p_e2e_info_page.dart`  

**W3-B7b:** `p2p_aml_screening_page.dart`, `p2p_address_proof_page.dart`, `p2p_source_of_funds_page.dart`, `p2p_large_transaction_justification_page.dart`, `p2p_compliance_overview_page.dart`, `p2p_risk_assessment_page.dart`, `p2p_report_merchant_page.dart`, `p2p_reviews_page.dart`, `p2p_achievements_page.dart`, `p2p_contribution_history_page.dart`, `p2p_tax_reporting_page.dart`, `p2p_limit_tracker_page.dart`, `p2p_transaction_limits_page.dart`  
→ split security vs `pages/hub/` extras in two batches of ≤10 (`W3-B7b`, `W3-B7c`).

---

### W3-B8 — pages → wallet (2) + leftover verify

1. `p2p_wallet_page.dart` → `pages/wallet/`  
2. `p2p_wallet_transfer_page.dart` → `pages/wallet/`  
3–10. Confirm zero flat pages; fix remaining imports  

---

### W3-B9+ — P2P widgets (112 files)

Move by prefix into matching hub; **11 batches × ~10 files**:

| Batch | Hub | Prefix / group |
|-------|-----|----------------|
| W3-B9 | `widgets/hub/` | `p2p_home_*`, `p2p_dashboard_*`, `p2p_express_*`, `p2p_guide_*`, `p2p_settings_*` |
| W3-B10 | `widgets/ads/` | `p2p_ad_*`, `p2p_create_*`, `p2p_my_ads*` |
| W3-B11 | `widgets/orders/` | `p2p_order_*`, `p2p_chat_*`, `p2p_escrow_*` |
| W3-B12 | `widgets/payment/` | `p2p_payment_*` |
| W3-B13–14 | `widgets/dispute/` | `p2p_dispute_*`, `p2p_insurance_*`, claim widgets |
| W3-B15 | `widgets/merchant/` | `p2p_merchant_*`, `p2p_kyc_*`, identity/selfie |
| W3-B16–17 | `widgets/security/` | blacklist/fraud/2fa/device/login/anti… |
| W3-B18 | `widgets/wallet/` | `p2p_wallet_*` + leftover |

**Per-batch gate:** `flutter analyze lib/features/p2p`  
**After all page moves:** `dart run tool/route_coverage_audit.dart --check`  
**Also:** `dart run tool/navigation_edge_audit.dart --check`

---

## Wave 4 — `trade_compliance` + `trade_terminal` (P1/P4)

### Hubs (compliance)

`hub` · `disclosures` · `execution` · `client_money` · `complaints` · `governance`

### W4-B1 — compliance pages → hub + disclosures

1. `regulatory_reports_dashboard_page.dart` → `pages/hub/`  
2. `regulatory_disclosures_page.dart` → `pages/disclosures/`  
3. `kid_generator_page.dart` → `pages/disclosures/`  
4. `riy_calculator_page.dart` → `pages/disclosures/`  
5. `risk_indicator_explainer_page.dart` → `pages/disclosures/`  
6. `performance_scenarios_page.dart` → `pages/disclosures/`  
7. `ex_ante_costs_page.dart` → `pages/disclosures/`  
8. `ex_post_costs_report_page.dart` → `pages/disclosures/`  
9. Update `trade_compliance_routes.dart`  

---

### W4-B2 — compliance pages → execution

1. `best_execution_reports_page.dart` → `pages/execution/`  
2. `execution_venue_analysis_page.dart` → `pages/execution/`  
3. `slippage_monitoring_page.dart` → `pages/execution/`  
4. `market_data_analytics_page.dart` → `pages/execution/`  
5. `live_market_data_analytics_page.dart` → `pages/execution/`  
6. Router sweep  

---

### W4-B3 — compliance pages → client_money + complaints

1. `client_money_protection_page.dart` → `pages/client_money/`  
2. `cass_reconciliation_page.dart` → `pages/client_money/`  
3. `investor_compensation_page.dart` → `pages/client_money/`  
4. `arm_integration_status_page.dart` → `pages/client_money/`  
5. `complaints_handling_page.dart` → `pages/complaints/`  
6. `complaint_submission_page.dart` → `pages/complaints/`  
7. `complaint_tracking_page.dart` → `pages/complaints/`  
8. `ombudsman_referral_page.dart` → `pages/complaints/`  

---

### W4-B4 — compliance pages → governance

1. `product_governance_page.dart`  
2. `target_market_definition_page.dart`  
3. `client_categorization_page.dart`  
4. `client_categorization_opt_up_page.dart`  
5. `audit_trail_page.dart`  
6. `transaction_reporting_page.dart`  
7. `regulatory_inspection_ready_page.dart`  
→ all `pages/governance/`  
8. Confirm 0 flat pages  

---

### W4-B5 … W4-B12 — compliance widgets (82 → by hub)

Group by filename prefix into matching hub; batches of 8–10 (`arm_*`, `audit_*`, `best_execution_*`, `cass_*`, `client_*`, `complaint*`, `ex_*`, `execution_*`, `investor_*`, `live_market_*`, `kid_*` / `riy_*` / `risk_*` / `performance_*` / `product_*` / `regulatory_*` / `slippage_*` / `target_*` / `transaction_*`).

---

### W4-B13 — `trade_terminal` → `pages/tools` + `widgets/tools`

**Pages (6):**

1. `advanced_analytics_page.dart` → `pages/tools/`  
2. `advanced_chart_page.dart` → `pages/tools/`  
3. `advanced_tools_demo_page.dart` → `pages/tools/`  
4. `advanced_trading_demo_page.dart` → `pages/tools/`  
5. `execution_quality_demo_page.dart` → `pages/tools/`  
6. `risk_management_demo_page.dart` → `pages/tools/`  

**W4-B14 — terminal widgets (10):** analytics + chart files → `widgets/tools/`  
**W4-B15 — terminal widgets (10):** tools/trading/execution/risk → `widgets/tools/`  
Update `trade_terminal_routes.dart`.

---

## Wave 5 — Wallet · Markets · Arena (P2)

### 5A Wallet

**Hubs:** `hub` · `transfer` · `assets` · `address` · `history` · `tools`

#### W5-A1 — pages

| To | Files |
|----|-------|
| `pages/hub/` | `wallet_page.dart` |
| `pages/transfer/` | `deposit_page.dart`, `withdraw_page.dart`, `transfer_page.dart`, `pending_deposits_page.dart`, `withdraw_limits_page.dart` |
| `pages/assets/` | `asset_detail_page.dart`, `dust_converter_page.dart`, `buy_crypto_page.dart` |

*(Split into 2 batches if including router = >10 touches.)*

#### W5-A2 — pages rest

| To | Files |
|----|-------|
| `pages/address/` | `address_book_page.dart`, `address_add_page.dart` |
| `pages/history/` | `transaction_history_page.dart`, `transaction_detail_page.dart` |
| `pages/tools/` | `wallet_multi_manager_page.dart`, `wallet_gas_optimizer_page.dart`, `wallet_health_score_page.dart`, `wallet_token_approval_page.dart`, `portfolio_analytics_page.dart`, `network_status_page.dart` |

#### W5-A3…W5-A10 — widgets (75)

Move by name affinity into same 6 hubs; ~8 batches × ~10 files.  
Update `wallet_routes.dart` after page moves.

---

### 5B Markets

**Hubs:** `hub` · `pair` · `tools` · `research` · `portfolio`

#### W5-B1 — pages → hub + pair

1. `market_list_page.dart` → `hub/`  
2. `market_overview_page.dart` + `*_part_01..03.dart` → `hub/` (**5 files — keep parts with page for now**)  
3. `watchlist_page.dart` → `hub/`  
4. `pair_detail_page.dart` → `pair/`  
5. `market_depth_page.dart` → `pair/`  
6. `market_heatmap_page.dart` → `pair/`  

→ split overview parts to W5-B1b if needed.

#### W5-B2 — pages → tools

1. `market_screener_page.dart`  
2. `comparison_tool_page.dart`  
3. `market_calendar_page.dart`  
4. `market_correlations_page.dart`  
5. `market_sectors_page.dart`  
6. `market_movers_page.dart`  
7. `derivatives_overview_page.dart`  

#### W5-B3 — pages → research + portfolio

1. `market_news_page.dart` → `research/`  
2. `social_sentiment_page.dart` → `research/`  
3. `social_signals_page.dart` + parts 01–03 → `research/`  
4. `token_info_page.dart` → `research/`  
5. `token_unlocks_page.dart` + parts 01–04 → **W5-B3b**  
6. `portfolio_tracker_page.dart` + parts → `portfolio/`  
7. `price_alerts_page.dart` → `portfolio/`  
8. `advanced_charts_page.dart` + parts → `portfolio/`  

#### W5-B4… — markets widgets (66) by hub (~7 batches)

---

### 5C Arena

**Hubs:** `hub` · `challenge` · `studio` · `governance` · `points` · `bridge`

#### W5-C1 — pages → hub

1. `arena_home_page.dart` + `part_01..03`  
2. `my_arena_page.dart` + `part_01..04`  
→ two batches (home / my_arena)

#### W5-C2 — pages → challenge

1. `arena_challenge_detail_page.dart` + parts  
2. `arena_join_page.dart`  
3. `arena_mode_detail_page.dart`  
4. `verified_challenges_page.dart`  
5. `arena_leaderboard_page.dart`  

#### W5-C3 — pages → studio

1. `arena_studio_page.dart`  
2. `arena_smart_rule_builder_page.dart` + part  
3. `arena_universal_preset_library_page.dart` + parts  
4. `arena_creator_page.dart`  

#### W5-C4 — pages → governance + safety

1. `arena_governance_gate_page.dart` + part  
2. `arena_trust_breakdown_page.dart`  
3. `arena_blocked_users_page.dart`  
4. `arena_safety_center_page.dart`  
5. `arena_resolution_center_page.dart`  
6. `arena_report_case_page.dart`  
7. `my_arena_reports_page.dart`  
8. `arena_guide_page.dart` + parts → may spill W5-C4b  

#### W5-C5 — pages → points + bridge + production

1. `arena_points_entry_detail_page.dart` → `points/`  
2. `arena_points_ledger_page.dart` → `points/`  
3. `arena_prediction_bridge_foundation_page.dart` + parts → `bridge/`  
4. `arena_production_ready_page.dart` + parts → `hub/` or `bridge/`  
5. `connected_ecosystem_production_page.dart` + parts → `bridge/`  
6. `arena_flow_map_page.dart` → `hub/`  

> **Boundary:** do not mix predictions module files into these batches.

#### W5-C6… — arena widgets (49) mirror hubs (~5 batches)

---

## Wave 6 — DCA · Launchpad · Predictions (P3)

### 6A DCA

**Hubs:** `hub` · `schedule` · `portfolio` · `research`

#### W6-A1 — pages → hub

1. `dca_page.dart` + `part_01..04` → `pages/hub/` (keep parts together; 5 files)  
2. `dca_overview_demo.dart` → `pages/hub/`  
3. Update `dca_routes.dart`  

#### W6-A2 — pages → schedule + portfolio

1. `dca_schedule_config_page.dart` → `schedule/`  
2. `dca_schedule_analytics_page.dart` → `schedule/`  
3. `dca_smart_rules_page.dart` → `schedule/`  
4. `dca_multi_asset_page.dart` + parts → `portfolio/` (batch A2b)  
5. `dca_portfolio_optimizer_page.dart` + part → `portfolio/`  
6. `dca_rebalance_config_page.dart` + parts → `portfolio/`  
7. `dca_rebalance_dashboard_page.dart` → `portfolio/`  
8. `dca_performance_compare_page.dart` → `portfolio/`  

#### W6-A3 — pages → research

1. `dca_backtester_page.dart`  
2. `dca_dynamic_amount_page.dart` + `part_01..04`  

#### W6-A4…W6-A6 — dca widgets (31) by hub (~3 batches)

---

### 6B Launchpad

**Hubs:** `hub` · `claim` · `bridge` · `tools`

#### W6-B1 — pages → hub (6)

1. `launchpad_page.dart`  
2. `launchpad_detail_page.dart`  
3. `launchpad_portfolio_page.dart`  
4. `launchpad_performance_page.dart`  
5. `launchpad_contract_page.dart`  
6. `launchpad_receipt_page.dart`  

#### W6-B2 — pages → claim + bridge (8)

1. `launchpad_batch_claim_page.dart` → `claim/`  
2. `launchpad_claim_receipt_page.dart` → `claim/`  
3. `launchpad_ido_bridge_page.dart` → `bridge/`  
4. `launchpad_bridge_compare_page.dart` → `bridge/`  
5. `launchpad_bridge_order_page.dart` → `bridge/`  
6. `launchpad_swap_aggregator_page.dart` → `bridge/`  
7–8. Router  

#### W6-B3 — pages → tools (remaining 12 → two batches of 6)

`abi_diff`, `address_book`, `dca_builder`, `event_log`, `gas_tracker`, `limit_orders`, `multisig`, `notif_sound`, `rebalance`, `risk_analytics`, `staking`, `webhooks`

#### W6-B4…W6-B13 — launchpad widgets (99) — **10 batches × ~10** by hub affiliation (filename prefix / consuming page)

---

### 6C Predictions *(separate from Arena)*

**Hubs:** `hub` · `event` · `portfolio` · `social`

#### W6-C1 — pages (9)

| To | Files |
|----|-------|
| `hub/` | `predictions_home_page.dart`, `predictions_search_page.dart`, `predictions_breaking_page.dart`, `predictions_rewards_page.dart` |
| `event/` | `prediction_event_detail_page.dart`, `prediction_order_receipt_page.dart`, `prediction_advanced_chart_page.dart` |
| Router | `predictions_routes.dart` |

#### W6-C2 — pages (8)

| To | Files |
|----|-------|
| `portfolio/` | `predictions_portfolio_page.dart`, `prediction_portfolio_analyzer_page.dart`, `prediction_risk_calculator_page.dart`, `prediction_market_maker_page.dart` |
| `social/` | `prediction_social_page.dart`, `prediction_event_calendar_page.dart`, `predictions_global_activity_page.dart`, `predictions_leaderboard_page.dart`, `prediction_tournaments_page.dart`, `prediction_data_integration_page.dart` → spill W6-C2b |

#### W6-C3…W6-C9 — predictions widgets (66) — ~7 batches by hub

---

## Summary count (approx)

| Wave | Batches (plan) | Focus |
|------|----------------:|-------|
| W0 | 6 | trade polish + trade_bots parts |
| W1 | ~25 | earn pages+widgets |
| W2 | 10 | trade_copy |
| W3 | ~18 | p2p |
| W4 | ~15 | compliance + terminal |
| W5 | ~30 | wallet + markets + arena |
| W6 | ~25 | dca + launchpad + predictions |
| **Total** | **~129** | move-only org |

---

## Execution tips

1. Start **W0-B1** in a fresh chat; paste only that batch + verify commands.  
2. After each wave exit checklist, run full:  
   `dart run tool/route_coverage_audit.dart --check`  
   `dart run tool/navigation_edge_audit.dart --check`  
   `flutter analyze`  
3. Do **not** combine a fold batch with UI redesign / token cleanup.  
4. For `part` files: prefer move-with-`part` first; convert to imported widgets in a later polish batch if risk is high.  

---

## Inventory snapshot (2026-07-14)

Used as source of truth for this plan:

- `trade` pages hubbed; widgets still under `spot/` (18) + convert/futures/margin  
- `trade_bots` pages hubbed; `widgets/hub/` empty; hub page still has 4 parts  
- `earn` 38 flat staking pages, 25 flat savings pages, 106+90 flat widgets  
- `trade_copy` 22/57 flat · `trade_compliance` 28/82 flat · `p2p` 80/112 flat  
- `wallet` 19/75 · `markets` 37/66 · `arena` 52/49 · `dca` 27/31 · `launchpad` 24/99 · `predictions` 17/66 · `trade_terminal` 6/20

---

## Completion stamp — Wave 0–6 DONE (2026-07-14)

| Wave | Status | Notes |
|------|--------|-------|
| W0 | ✅ | `widgets/spot` removed; parts under `widgets/<hub>/` |
| W1 | ✅ | earn → `staking`/`savings` (+ `widgets/hub` shared) |
| W2 | ✅ | trade_copy → 5 hubs |
| W3 | ✅ | p2p → 8 hubs |
| W4 | ✅ | compliance 6 hubs + terminal `tools/` |
| W5 | ✅ | wallet / markets / arena hubbed |
| W6 | ✅ | dca / launchpad / predictions hubbed |

**Verify (2026-07-14):**  
`flutter analyze` on all hubbed modules + `lib/app/router` → No issues.  
`route_coverage_audit --check` + `navigation_edge_audit --check` → current.  
All listed modules: **0 flat** pages/widgets at presentation root.  
No commit created in this session (await user).
