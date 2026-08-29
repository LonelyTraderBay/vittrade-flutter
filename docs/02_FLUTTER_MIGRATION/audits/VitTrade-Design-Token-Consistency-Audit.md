# VitTrade Design Token Consistency Audit

Generated: 2026-06-12

Generated from `flutter_app/tool/design_token_consistency_audit.dart`.

## Inputs

- Root pages: `lib/features/*/presentation/pages/*_page.dart` plus audited route-screen exceptions (+ part files).
- Feature widgets: `lib/features/*/presentation/widgets/*.dart`.
- Shared files: `lib/shared/widgets` and `lib/shared/layout`.

## Summary
```text
generated=2026-06-12
status_fail=1
status_warn=20
status_exception=110
rows=1273
```

## CI Baseline Gates

Global debt is report-only while the migration baseline is still being reduced. P0 financial modules are enforced against the post-tokenization baseline below.

| module | current debt | max baseline | status |
| --- | ---: | ---: | --- |
| markets | 1 | 2042 | pass |
| p2p | 0 | 1911 | pass |
| profile | 0 | 1037 | pass |
| trade_bots | 0 | 0 | pass |
| trade_compliance | 0 | 0 | pass |
| trade_copy | 0 | 0 | pass |
| trade_core | 3 | 3 | pass |
| trade_terminal | 0 | 6 | pass |
| wallet | 2 | 759 | pass |

## Typography Debt By Module

This section counts only local typography drift: `fontSize`, `fontFamily`, and `FontWeight.w800/w900`. Bundle summary rows are excluded to avoid double-counting root page part files.

| module | total typography debt | fontSize | fontFamily | w800/w900 |
| --- | ---: | ---: | ---: | ---: |
| admin | 0 | 0 | 0 | 0 |
| arena | 0 | 0 | 0 | 0 |
| cross_module | 0 | 0 | 0 | 0 |
| dca | 0 | 0 | 0 | 0 |
| dev | 0 | 0 | 0 | 0 |
| discovery | 0 | 0 | 0 | 0 |
| earn_core | 0 | 0 | 0 | 0 |
| earn_savings | 0 | 0 | 0 | 0 |
| earn_staking | 0 | 0 | 0 | 0 |
| enterprise_states | 0 | 0 | 0 | 0 |
| home | 0 | 0 | 0 | 0 |
| launchpad | 0 | 0 | 0 | 0 |
| markets | 0 | 0 | 0 | 0 |
| news | 0 | 0 | 0 | 0 |
| notifications | 0 | 0 | 0 | 0 |
| onboarding | 0 | 0 | 0 | 0 |
| p2p_account | 0 | 0 | 0 | 0 |
| p2p_core | 0 | 0 | 0 | 0 |
| p2p_dispute | 0 | 0 | 0 | 0 |
| p2p_marketplace | 0 | 0 | 0 | 0 |
| p2p_orders | 0 | 0 | 0 | 0 |
| p2p_security | 0 | 0 | 0 | 0 |
| predictions | 0 | 0 | 0 | 0 |
| profile | 0 | 0 | 0 | 0 |
| referral | 0 | 0 | 0 | 0 |
| rewards | 0 | 0 | 0 | 0 |
| shared/layout | 0 | 0 | 0 | 0 |
| shared/widgets | 0 | 0 | 0 | 0 |
| support | 0 | 0 | 0 | 0 |
| trade | 0 | 0 | 0 | 0 |
| trade_bots | 0 | 0 | 0 | 0 |
| trade_compliance | 0 | 0 | 0 | 0 |
| trade_copy | 0 | 0 | 0 | 0 |
| trade_core | 0 | 0 | 0 | 0 |
| trade_terminal | 0 | 0 | 0 | 0 |
| wallet | 0 | 0 | 0 | 0 |

## Top Debt Files (non-exception)
| scope | bundle | path | status | total | fontSize | fontFamily | w800/w900 | near1Height | edgeInsets | sizedBox | borderRadius | radius | container | decoration | gridCount | fixedWH | exception |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_two_column_tablet_dashboard.dart` | fail | 7 | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/points/arena_points_entry_detail_page_sections.dart` | warn | 4 | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/order_receipt_page_sections.dart` | warn | 3 | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_stats_grid.dart` | warn | 1 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_mode_detail_hero.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/points/arena_points_ledger_page_sections.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_home_hero.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_dashboard_summary.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_earn_hero_tabs.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_status_content.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_home_highlights.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/predictions_global_activity_feed_widgets.dart` | warn | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/predictions_global_activity_widgets.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/rewards/presentation/widgets/rewards_hub_hero_section.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart` | warn | 1 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_detail_hero.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_hub_hero.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/phone/wallet_page_balance_sections.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tablet/wallet_page_balance_sections.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_web_utility_page.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_segmented_choice.dart` | warn | 1 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_field_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_helpers.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_models.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_privacy_clarity.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_resolution_timing.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_setup_fields.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_status_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_stepper_title.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_suggestions_eligibility.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_summary_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_report_case_related_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_report_case_summary_timeline.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_report_case_system_appeal.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_safety_center_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_safety_center_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/my_arena_reports_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/my_arena_reports_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_date_format.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_flow_map_nodes.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_flow_map_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_flow_map_qa.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_state_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_viewport_padding.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/points/arena_points_entry_detail_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/admin_dashboard_state_content.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/points/arena_points_ledger_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/admin_home_dashboards_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_creator_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_creator_hero_trust.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_creator_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_smart_rule_builder_page_basics_fields.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_smart_rule_builder_page_condition_timing_fields.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_studio_fee_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_studio_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_studio_stepper.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_studio_steps.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_analytics_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_analytics_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_analytics_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_icon_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_history_settings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_analysis.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/dca_delete_button.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/dca_missing_config_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/phone/dca_currency_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/phone/dca_overview_demo_metrics.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/phone/dca_overview_demo_shell.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_performance_compare_analysis.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_performance_compare_charts.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_performance_compare_primitives.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_performance_compare_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_allocation_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_common_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_comparison_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_floating_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_frontier.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_header_drift.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_stat_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_tab_panels.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_analysis.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_results.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_setup.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_schedule_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_schedule_limits_enable.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_schedule_strategy_time.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_smart_rules_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_smart_rules_info_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_smart_rules_tabs_stats.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/discovery_shared_tiles.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/topic_hub_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/topic_hub_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/topic_hub_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/topic_hub_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_entity_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_prediction_arena_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_results.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_shell.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_core/presentation/widgets/earn_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_calculator.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_info_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_settings_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_shared.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/earn_comparison_chart.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/earn_comparison_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |

## Report File Matrix
| scope | bundle | path | status | fontSize | fontFamily | w800/w900 | height~1 | edgeInsets | sizedBox | borderRadius | radius | container | decoration | crossAxisCount | childAspectRatio | mainAxisExtent | fixedWidth | fixedHeight | exception |
| --- | --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/ab_test_dashboard_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/ab_test_dashboard_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/admin_dashboard_state_content.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/admin_home_dashboards_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/admin_home_metrics_realtime.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/admin_metric_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/analytics_dashboard_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/analytics_dashboard_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/funnel_dashboard_common_painter.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/funnel_dashboard_selector_metrics.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/admin/presentation/widgets/funnel_dashboard_waterfall_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_join_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_join_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_leaderboard_body.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_leaderboard_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_leaderboard_rows_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_mode_detail_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_mode_detail_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_mode_detail_hero.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_mode_detail_prediction.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_mode_detail_quality.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_mode_detail_related.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_mode_detail_rules.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/challenge/arena_navigation_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_field_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_helpers.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_models.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_privacy_clarity.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_resolution_timing.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_setup_fields.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_status_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_stepper_title.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_suggestions_eligibility.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_governance_gate_summary_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_report_case_related_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_report_case_summary_timeline.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_report_case_system_appeal.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_safety_center_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/arena_safety_center_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/my_arena_reports_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/governance/my_arena_reports_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_date_format.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_flow_map_nodes.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_flow_map_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_flow_map_qa.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_state_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/phone/arena_viewport_padding.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/points/arena_points_entry_detail_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/points/arena_points_entry_detail_page_sections.dart` | warn | 0 | 0 | 0 | 4 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/points/arena_points_ledger_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/points/arena_points_ledger_page_sections.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_creator_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_creator_hero_trust.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_creator_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_smart_rule_builder_page_basics_fields.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_smart_rule_builder_page_condition_timing_fields.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_studio_fee_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_studio_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_studio_stepper.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/arena/presentation/widgets/studio/arena_studio_steps.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_analytics_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_analytics_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_analytics_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_analytics_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_icon_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/cross_module_tabbed_shell.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_history_settings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/smart_alert_center_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_analysis.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/cross_module/presentation/widgets/unified_portfolio_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/dca_delete_button.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/dca_missing_config_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/phone/dca_currency_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/phone/dca_overview_demo_actions.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/phone/dca_overview_demo_metrics.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/phone/dca_overview_demo_shell.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_performance_compare_analysis.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_performance_compare_charts.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_performance_compare_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_performance_compare_primitives.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_performance_compare_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_allocation_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_common_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_comparison_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_floating_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_frontier.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_frontier_painter.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_header_drift.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_stat_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_tab_panels.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/portfolio/dca_portfolio_optimizer_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_analysis.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_charts.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_results.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_setup.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/research/dca_backtester_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_schedule_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_schedule_limits_enable.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_schedule_strategy_time.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_smart_rules_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_smart_rules_info_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dca/presentation/widgets/schedule/dca_smart_rules_tabs_stats.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/design_system_color_section.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/design_system_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/design_system_cta_section.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/design_system_footer.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/design_system_hero.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/design_system_input_section.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/design_system_playground.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/design_system_section_header_section.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/design_system_tokens_section.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/dev_state_bar.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/missing_screens_showcase_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/missing_screens_showcase_page_sections.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/performance_monitor_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/performance_monitor_sections.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/route_checker_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/dev/presentation/widgets/route_checker_page_sections.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_path_exception: /dev/ |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/discovery_shared_tiles.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/topic_hub_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/topic_hub_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/topic_hub_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/topic_hub_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_entity_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_prediction_arena_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_results.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/discovery/presentation/widgets/unified_search_shell.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_core/presentation/widgets/earn_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_calculator.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_info_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_settings_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/auto_compound_settings_shared.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/earn_comparison_chart.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/earn_comparison_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/phone/earn_comparison_table.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_analytics_charts_metrics.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_analytics_secondary_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_analytics_summary_range.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_auto_rebalance_allocation.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_auto_rebalance_drift_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_auto_rebalance_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_auto_rebalance_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_auto_rebalance_preview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_auto_rebalance_settings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_auto_rebalance_shared.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_auto_rebalance_strategy.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_autopilot_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_autopilot_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_autopilot_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_autopilot_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_autopilot_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_autopilot_settings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_backtest_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_backtest_compare.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_backtest_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_backtest_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_backtest_results.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_backtest_setup.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_dca_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_dca_history_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_dca_plans.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_dca_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_export_config_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_export_option_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_export_summary_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_faq_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_faq_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_goal_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_goal_create_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_goal_detail_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_goal_sheet_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_goal_summary_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_goal_visuals.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_guide_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_guide_glossary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_guide_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_guide_tutorials.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_history_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_history_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_home_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_home_hero.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_home_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_home_products.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_ladder_analysis.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_ladder_builder_config.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_ladder_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_ladder_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_ladder_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_ladder_liquidity.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_ladder_rung_manager.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_ladder_timeline.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_notification_preferences_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_notification_preferences_delivery.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_notification_preferences_events.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_notification_preferences_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_notifications_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_notifications_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_notifications_settings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_portfolio_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_portfolio_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_portfolio_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_portfolio_maturity.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_portfolio_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_portfolio_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_recommendations_amount_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_recommendations_compare_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_recommendations_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_recommendations_insights.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_recommendations_shared.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_recommendations_strategy_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_recommendations_strategy_detail_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_risk_assessment_products_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_risk_assessment_questions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_risk_assessment_result.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_smart_suggestions_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_smart_suggestions_suggestions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_smart_suggestions_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_smart_suggestions_trends.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_what_if_asset_impact.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_what_if_common_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_what_if_models.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_what_if_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_what_if_results.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_what_if_stress.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_savings/presentation/widgets/savings/savings_what_if_stress_components.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_advanced_orders_guidance.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_advanced_orders_overview_orders.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_advanced_orders_sheet_fields.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_analytics_apy_tab.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_analytics_chart_shared.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_analytics_earnings_tab.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_analytics_products_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_analytics_roi_tab.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_analytics_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_api_documentation_auth.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_api_documentation_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_api_documentation_endpoints.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_api_documentation_examples.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_api_documentation_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_audit_reports_bounty_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_audit_reports_hero_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_audit_reports_reports_findings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_auto_compound_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_auto_compound_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_auto_compound_settings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_auto_compound_shared.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_auto_compound_simulation.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_community_governance_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_community_governance_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_contingency_plan_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_contingency_plan_support_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_custody_actions_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_custody_assets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_custody_audit.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_custody_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_custody_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_custody_pie_chart.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_dashboard_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_dashboard_charts.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_dashboard_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_dashboard_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_dashboard_summary.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_earn_hero_tabs.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_earn_positions_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_earn_products.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_earn_tools.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_earnings_calendar_grid.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_earnings_events_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_earnings_summary_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_guide_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_guide_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_history_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_history_detail_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_history_summary_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_institutional_overview_batches.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_institutional_sheet_painter.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_institutional_signers_features.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_claims.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_asset_breakdown.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_claims.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_contribution_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_fund_status_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_plans.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_insurance_sheets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_liquid_staking_benefits.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_liquid_staking_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_liquid_staking_detail_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_liquid_staking_holdings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_liquid_staking_stake.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_liquid_staking_swap.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_liquid_staking_swap_fields.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_multi_chain_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_multi_chain_page_sections.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_notifications_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_notifications_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_proof_of_reserves_assets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_proof_of_reserves_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_proof_of_reserves_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_proof_of_reserves_overview_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_proof_of_reserves_verify.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_proof_of_reserves_verify_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_recommendations_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_recommendations_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_recommendations_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_recommendations_strategy.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_regulatory_framework_hero_licenses.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_regulatory_framework_protection_complaints.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_regulatory_framework_sheet_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_assessment_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_assessment_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_dashboard_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_dashboard_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_disclosure_assessment_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_disclosure_categories.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_disclosure_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_score_inputs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_score_radar.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_risk_score_results.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_slashing_history_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_slashing_history_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_slashing_history_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_slashing_history_prevention.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_slashing_history_statistics.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_social_feed_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_social_feed_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_suitability_assessment_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_suitability_assessment_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_tax_guide_calculator.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_tax_guide_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_tax_guide_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_tax_guide_jurisdictions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_tax_guide_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_transaction_reporting_sheet_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_transaction_reporting_summary_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_transaction_reporting_transaction_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_validator_health_monitor_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_validator_health_monitor_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_validator_selection_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_validator_selection_detail.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_validator_selection_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_validator_selection_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_validator_selection_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_withdrawal_policy_calculator.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_withdrawal_policy_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_withdrawal_policy_emergency.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_withdrawal_policy_penalties.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/earn_staking/presentation/widgets/staking/staking_withdrawal_policy_timeline.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/enterprise_states/presentation/widgets/enterprise_states_hero_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/enterprise_states/presentation/widgets/enterprise_states_preview_kit.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/enterprise_states/presentation/widgets/enterprise_states_references.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/home_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/home_more_products_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/home_tablet_reference_home.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/phone/home_announcement_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/phone/home_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/phone/home_market_ticker_section.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/phone/home_next_action_section.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/phone/home_portfolio_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/phone/home_products_section.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/phone/home_recent_products_section.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/phone/home_scroll_shell.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/phone/home_status_content.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_discovery_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_market_ticker_section.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_market_watchlist_panel.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: candlestick |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_more_products_dialog.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_next_action_section.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_notice_line.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_portfolio_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_products_section.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_recent_products_section.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_status_content.dart` | warn | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_tablet_keys.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_tablet_kpi_strip.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/home/presentation/widgets/tablet/home_tablet_reference_home.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_compare_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_compare_confirm.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_compare_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_compare_quick_compare.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_compare_route_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_compare_route_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_compare_route_metrics.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_order_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_order_events.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_order_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_bridge_order_timeline.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_swap_aggregator_history_settings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_swap_aggregator_input.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/bridge/launchpad_swap_aggregator_quotes.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/claim/launchpad_batch_claim_review_success.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/claim/launchpad_batch_claim_selection.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/claim/launchpad_batch_claim_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/claim/launchpad_claim_receipt_claim_sheet_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/claim/launchpad_claim_receipt_hero_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/claim/launchpad_claim_receipt_misc_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/claim/launchpad_claim_receipt_overview_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/claim/launchpad_claim_receipt_timeline_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_home_header_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_home_helpers.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_home_project_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_home_shared_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_home_tool_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_performance_chart_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_performance_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_performance_projects.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_portfolio_empty_disclaimer_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_portfolio_hero_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_portfolio_subscription.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_receipt_details_next_steps.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/phone/launchpad_receipt_states_success.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_abi_diff_entries.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_abi_diff_extensions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_abi_diff_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_address_book_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_address_book_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_address_book_sheet_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_create_form.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_strategies.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_event_log_export_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_event_log_filter_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_event_log_list_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_event_log_misc_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_gas_tracker_alert_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_gas_tracker_alerts.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_gas_tracker_chains.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_gas_tracker_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_gas_tracker_estimator.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_gas_tracker_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_gas_tracker_prices.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_limit_orders_active_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_limit_orders_create_fields.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_limit_orders_create_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_limit_orders_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_limit_orders_header_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_limit_orders_history_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_limit_orders_preview_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_multisig_create_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_multisig_owners.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_multisig_page_chrome.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_multisig_queue_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_multisig_tx_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_multisig_tx_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_notif_sound_categories.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_notif_sound_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_notif_sound_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_rebalance_allocation.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_rebalance_calculations.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_rebalance_deviation.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_rebalance_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_rebalance_strategy.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_rebalance_suggestions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_rebalance_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_risk_due_diligence.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_risk_painter.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_risk_report_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_risk_tabs_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_staking_calculator.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_staking_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_staking_pool_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_staking_pool_status.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_staking_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_staking_shared.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_webhooks_common_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_webhooks_create_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_webhooks_deliveries.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_webhooks_form_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_webhooks_stats_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_webhooks_status_utils.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_webhooks_subscription_detail.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/launchpad/presentation/widgets/tools/launchpad_webhooks_subscription_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/market_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/market_depth_chart.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/market_depth_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/market_depth_order_book.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/market_depth_tabs.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/market_depth_whale_alerts.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/market_heatmap_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/market_heatmap_panels.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/market_heatmap_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/market_heatmap_treemap.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/pair_detail_chart_widgets.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/pair_detail_header_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/pair_detail_order_widgets.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/pair/pair_detail_painter_widgets.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/market_list_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/market_list_discover.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/market_list_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/market_list_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/market_list_movers.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/market_list_pairs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/market_list_pairs_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/market_list_tools.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/watchlist_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/watchlist_common_painter.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/phone/watchlist_toolbar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/portfolio/price_alerts_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/portfolio/price_alerts_page_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/portfolio/price_alerts_page_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/research/market_news_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/research/market_news_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/research/social_sentiment_overview_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/research/social_sentiment_tabs_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/research/social_sentiment_token_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/research/social_sentiment_trends_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/research/token_info_detail_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/research/token_info_market_widgets.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/research/token_info_tabs_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/market_list_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/market_list_discover.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/market_list_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/market_list_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/market_list_movers.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/market_list_tools.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_master_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pair_chart_math.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pair_depth_pane.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pair_detail_pane.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pair_detail_pane_chart.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pair_detail_pane_depth.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pair_detail_pane_sections.dart` | exception | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pair_detail_pane_tables.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pane_navigation.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_pulse_strip.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_status_content.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_token_info_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_token_info_pane_details.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tablet/markets_token_info_pane_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/comparison_tool_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/comparison_tool_content.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/comparison_tool_tokens.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_calendar_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_calendar_events.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_calendar_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_calendar_month.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_correlations_diversification_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_correlations_matrix_widgets.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_correlations_pairs_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_correlations_tabs_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_derivatives_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_derivatives_liquidation.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_derivatives_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_derivatives_perpetual.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_derivatives_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_movers_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_movers_results.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_movers_row_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_movers_sparkline.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_screener_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_screener_results.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_screener_row_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_sector_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_sector_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_sector_comparison_table.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_sector_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_sector_detail_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/markets/presentation/widgets/tools/market_sector_distribution.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/news/presentation/widgets/news_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/news/presentation/widgets/news_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/notifications/presentation/widgets/notifications_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/notifications/presentation/widgets/notifications_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/onboarding/presentation/widgets/onboarding_shared_components.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/onboarding/presentation/widgets/onboarding_step_screens.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_address_proof_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_address_proof_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_identity_verification_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_identity_verification_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_kyc_requirements_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_kyc_requirements_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_kyc_status_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_kyc_status_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_merchant_profile_ads_reviews.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_merchant_profile_header_stats.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_selfie_verification_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/merchant/p2p_selfie_verification_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/payment/p2p_payment_method_add_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/payment/p2p_payment_method_add_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/payment/p2p_payment_method_verification_flow.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/payment/p2p_payment_method_verification_methods.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/payment/p2p_payment_methods_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_account/presentation/widgets/payment/p2p_payment_methods_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_core/presentation/widgets/p2p_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_core/presentation/widgets/p2p_notice_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_dispute_actions_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_dispute_detail_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_dispute_escalation_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_dispute_evidence_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_dispute_status_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_dispute_support_chat.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_dispute_timeline_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_dispute_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_insurance_certificate_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_insurance_certificate_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_insurance_score_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_dispute/presentation/widgets/dispute/p2p_insurance_score_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_ad_analytics_breakdown_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_ad_analytics_charts_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_ad_analytics_overview_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_ad_detail_amount_terms.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_ad_detail_merchant_info.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_create_ad_choice_chips.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_create_ad_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_create_ad_preview_badge.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_create_ad_preview_confirm.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_create_ad_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_my_ads_empty_links.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_my_ads_stats_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_order_book_cards_lists.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_order_book_painter.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/ads/p2p_order_book_selector_ticker.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_dashboard_activity_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_dashboard_overview_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_dashboard_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_dashboard_row_widgets.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_express_form_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_express_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_express_page_state.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_guide_steps_safety.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_guide_tabs_faq.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_guide_video_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_home_offer_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_home_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_home_page_state.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_home_tools.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_settings_hours_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_settings_trade_security.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_trading_level_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_marketplace/presentation/widgets/phone/p2p_trading_level_hero_progress.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_chat_composer_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_chat_header_banners.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_chat_messages.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_balance_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_balance_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_detail_multisig_order.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_detail_status_address.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_escrow_detail_timeline_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_my_orders_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_my_orders_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_order_content_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_order_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_order_page_state.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_order_proof_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/orders/p2p_order_rate_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/wallet/p2p_wallet_actions_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/wallet/p2p_wallet_balances.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/wallet/p2p_wallet_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/wallet/p2p_wallet_transfer_amount.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/wallet/p2p_wallet_transfer_confirm.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_orders/presentation/widgets/wallet/p2p_wallet_transfer_form.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_2fa_settings_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_2fa_settings_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_achievements_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_achievements_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_anti_phishing_code_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_anti_phishing_code_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_blacklist_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_blacklist_entries.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_blacklist_summary_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_device_management_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_device_management_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_device_management_tips.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_fraud_checklist_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_fraud_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_fraud_score_patterns.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_login_history_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_login_history_events.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_login_history_summary_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_report_merchant_reasons_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_report_merchant_summary_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_security_center_actions_events.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_security_center_score_features.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_tax_reporting_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_tax_reporting_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_transaction_limits_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/p2p_security/presentation/widgets/security/p2p_transaction_limits_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_advanced_chart_analysis.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_advanced_chart_indicators.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_advanced_chart_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_advanced_chart_overview_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_advanced_chart_painter_utils.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_activity_holders.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_chart.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_comments.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_detail_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_order_book.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_quick_links.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_related_arena.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_stats_position.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_trade_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_event_detail_trade_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_order_preview_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_order_receipt_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/event/prediction_order_receipt_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/prediction_enum_tab_bar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_breaking_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_breaking_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_home_events.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_home_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_home_highlights.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_rewards_arena_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_rewards_hero_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_rewards_table.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_search_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/phone/predictions_search_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_market_maker_earnings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_market_maker_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_market_maker_provide.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_market_maker_returns.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_portfolio_analyzer_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_portfolio_analyzer_performance.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_portfolio_analyzer_risk.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_portfolio_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_portfolio_history.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_portfolio_orders.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_portfolio_positions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_portfolio_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_risk_calculator_analysis.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_risk_calculator_form.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/prediction_risk_calculator_scenarios_guide.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/portfolio/predictions_portfolio_bridge_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/predictions_outcome_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/predictions_time_remaining.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_data_integration_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_data_integration_keys_webhooks.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_data_integration_sources.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_event_calendar_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_event_calendar_events.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_event_calendar_notifications.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_social_analysis_share.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_social_comment_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_social_header_comments.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_social_support_widgets.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_tournaments_detail.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_tournaments_empty_leaderboard.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_tournaments_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/prediction_tournaments_stats.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/predictions_global_activity_feed_widgets.dart` | warn | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/predictions_global_activity_widgets.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/predictions_leaderboard_filters_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/predictions_leaderboard_podium_rankings.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/predictions/presentation/widgets/social/predictions_leaderboard_rows_wins.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/activity_log_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/activity_log_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/api_management_docs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/api_management_key_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/api_management_keys.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/common/profile_icon_registry.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/device_management_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/device_management_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/kyc_details_privacy.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/kyc_status_levels.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_account_footer_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_api_key_create_form.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_api_key_create_result.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_discovery_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_legal_accordion_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_menu_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_product_hub_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_card_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_create.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_primitives.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_sub_account_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_vip_benefits.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_vip_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/profile_vip_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/security_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/security_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/settings_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/settings_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_account_footer_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_account_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_activity_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_api_create_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_api_create_pane_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_api_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_api_pane_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_devices_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_devices_pane_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_discovery_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_edit_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_icon_registry.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_kyc_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_legal_accordion_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_master_menu.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_menu_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_pane_navigation.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_product_hub_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_security_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_security_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_settings_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_status_content.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_sub_accounts_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_sub_accounts_pane_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/tablet/profile_vip_pane.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/profile/presentation/widgets/vip_history_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/referral/presentation/widgets/referral_history_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/referral/presentation/widgets/referral_history_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/referral/presentation/widgets/referral_rules_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/referral/presentation/widgets/referral_rules_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/rewards/presentation/widgets/rewards_hub_components.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/rewards/presentation/widgets/rewards_hub_hero_section.dart` | warn | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/rewards/presentation/widgets/rewards_hub_task_section.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/support/presentation/widgets/announcements_filters_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/support/presentation/widgets/announcements_list_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/support/presentation/widgets/help_center_hero_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/support/presentation/widgets/help_center_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/support/presentation/widgets/support_context_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/support/presentation/widgets/support_faq_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/support/presentation/widgets/support_quick_contacts_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/support/presentation/widgets/support_tickets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/convert/convert_page_amount_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/convert/convert_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/convert/convert_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/convert/convert_page_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/futures/futures_page_form_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/futures/futures_page_state.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/futures/leverage_controls_presets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/futures/leverage_header_hero_risk.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/futures/leverage_impact_confirm.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/margin/margin_trading_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/margin/margin_trading_hub_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/margin/margin_trading_hub_hero_nav.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/margin/margin_trading_hub_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/margin/margin_trading_order_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/margin/margin_trading_positions_orders.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/margin/margin_trading_reserved.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/margin/margin_trading_shared_helpers.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/margin/margin_trading_simple_form.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/order_receipt_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/order_receipt_page_sections.dart` | warn | 0 | 0 | 0 | 3 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/orders_history_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/orders_history_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/position_dashboard_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/position_dashboard_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/trade_history_export_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/trade_history_export_selectors_includes.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/trade_history_export_summary_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/trade_settings_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/trade_settings_page_sections.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: orderbook |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/vit_trade_confirm_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/vit_trade_side_switch.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/vit_trade_simple_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/vit_trade_simple_order_form.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/phone/vit_trade_simple_shell.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/order_receipt_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/order_receipt_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/trade_positions_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/trade_status_content.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/trade_ticker_strip.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/vit_trade_confirm_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/vit_trade_side_switch.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/vit_trade_simple_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade/presentation/widgets/tablet/vit_trade_simple_order_form.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/backtest/bot_backtesting_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/backtest/bot_optimization_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/backtest/bot_optimization_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/backtest/bot_strategy_compare_metrics.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/backtest/bot_strategy_compare_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/backtest/bot_strategy_compare_recommendations_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/backtest/bot_strategy_compare_selection.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_drawdown_analyzer_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_drawdown_analyzer_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_equity_curve_analysis_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_equity_curve_charts_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_equity_curve_summary_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_history_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_history_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_performance_charts_strategy.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_performance_metrics_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_performance_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_performance_timeframe_view.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_portfolio_dashboard_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_portfolio_dashboard_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_risk_dashboard_charts.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_risk_dashboard_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_risk_dashboard_metrics.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/dashboard/bot_risk_dashboard_score.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/phone/trading_bots_page_bot_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/phone/trading_bots_page_create_bot_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/phone/trading_bots_page_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/phone/trading_bots_page_my_bots_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/phone/trading_bots_page_tools.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_api_documentation_endpoints.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_api_documentation_intro_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_api_documentation_support_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_api_documentation_websocket_examples.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_emergency_stop_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_emergency_stop_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_faq_cards_help.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_faq_search_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_guide_blocks.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_guide_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_guide_intro_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_guide_practices_videos.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_guide_strategies.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_risk_disclosure_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_risk_disclosure_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_security_settings_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_security_settings_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_security_settings_sheets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_suitability_breakdown_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_suitability_questions_info.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_suitability_result_score.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_tax_reporting_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_tax_reporting_notice_year.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_tax_reporting_reports.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_tax_reporting_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_terms_of_service_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/bot_terms_of_service_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_bots/presentation/widgets/settings/trade_bot_radio_icon.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/client_money/arm_integration_common_painter.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/client_money/arm_integration_providers.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/client_money/arm_integration_sla_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/client_money/cass_reconciliation_records_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/client_money/cass_reconciliation_summary_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/client_money/client_money_protection_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/client_money/client_money_protection_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/client_money/investor_compensation_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/client_money/investor_compensation_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/complaints/complaint_submission_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/complaints/complaint_submission_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/complaints/complaints_handling_overview_complaints.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/complaints/complaints_handling_overview_header_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/complaints/complaints_handling_process_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/ex_ante_costs_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/ex_ante_costs_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/ex_ante_costs_scenarios_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/ex_ante_costs_summary_breakdown.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/ex_post_costs_report_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/ex_post_costs_report_variance_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/performance_scenarios_intro_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/performance_scenarios_outcome_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/regulatory_disclosures_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/regulatory_disclosures_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/regulatory_disclosures_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/regulatory_disclosures_hero_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/regulatory_disclosures_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/risk_indicator_details_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/risk_indicator_scale_intro.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/riy_calculator_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/disclosures/riy_calculator_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/best_execution_archive_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/best_execution_current.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/best_execution_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/execution_venue_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/execution_venue_comparison.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/execution_venue_speed_trends.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/execution_venue_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_chart_painter.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_common_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_data_analytics_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_interest_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_interest_funding.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_interest_open_interest.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_interest_ratio.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_interest_top_traders.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_liquidations.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_pair_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_sentiment.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/live_market_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/market_data_analytics_funding_traders.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/market_data_analytics_liquidations.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/market_data_analytics_open_interest.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/market_data_analytics_sentiment.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/market_data_analytics_shared.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/slippage_monitoring_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/slippage_monitoring_events.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/slippage_monitoring_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/execution/slippage_monitoring_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/audit_trail_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/audit_trail_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/client_categorization_history_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/client_categorization_overview_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/client_categorization_page_chrome.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/client_categorization_protections_requirements_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/product_governance_overview_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/product_governance_products.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/product_governance_reviews_distribution.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/regulatory_inspection_ready_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/regulatory_inspection_ready_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/transaction_reporting_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/transaction_reporting_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/transaction_reporting_filters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/transaction_reporting_reports.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/governance/transaction_reporting_stats.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/phone/regulatory_reports_dashboard_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/phone/regulatory_reports_dashboard_exports.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/phone/regulatory_reports_dashboard_kpis.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/phone/regulatory_reports_dashboard_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/phone/regulatory_reports_dashboard_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_compliance/presentation/widgets/phone/regulatory_reports_dashboard_queue_compliance.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/analytics/copy_performance_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/analytics/copy_performance_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/analytics/copy_performance_summary_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/analytics/performance_attribution_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/analytics/performance_attribution_summary_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/analytics/performance_attribution_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/analytics/portfolio_risk_analysis_page_common.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/analytics/portfolio_risk_analysis_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/flow/copy_configuration_provider_capital_mode.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/flow/copy_configuration_risk_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/flow/copy_configuration_validation_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/flow/copy_confirmation_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/flow/copy_confirmation_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/active_copies_alerts_modal.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/active_copies_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/active_copies_expanded_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/active_copies_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/active_copies_shared.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_notifications_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_notifications_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_settings_contacts_privacy.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_settings_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_settings_modes.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_trading_card_demo_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_trading_card_demo_primitives.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_trading_card_demo_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_trading_card_demo_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_trading_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_trading_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/phone/copy_trading_metrics_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/provider_application_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/provider_application_progress_intro.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/provider_application_steps.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/provider_governance_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/provider_governance_page_details.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/provider_governance_page_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/provider_leaderboard_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/provider_leaderboard_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/provider_leaderboard_disclaimer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/trader_profile_chart_painters.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/trader_profile_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/trader_profile_stats_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/provider/trader_profile_trades.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/copy_audit_log_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/copy_audit_log_events.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/copy_audit_log_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/copy_education_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/copy_education_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/copy_safety_enforcement_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/copy_safety_metrics_tools.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/copy_safety_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/dispute_resolution_cases.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/dispute_resolution_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/dispute_resolution_form.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/safety_education_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/safety/safety_education_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/trade_copy_consent_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_copy/presentation/widgets/trade_copy_header_body_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/trade_body_review_widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/trade_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/trade_high_risk_status_ui.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/trade_module_layout.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/trade_product_navigation.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_analytics_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart` | warn | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_detail_hero.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_hub_hero.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_product_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_core/presentation/widgets/vit_trade_terminal_header.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: trade chart |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_analytics_page_ai_signals.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_analytics_page_risk_journal.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_analytics_page_shared.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_analytics_page_signal_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_analytics_page_sizing_footer.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_chart_area_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_chart_header_toolbar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_chart_painter.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_tools_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_tools_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_tools_tabs_sheets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_trading_demo_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/advanced_trading_demo_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/execution_quality_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/execution_quality_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/execution_quality_sheets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/execution_quality_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/risk_management_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/risk_management_overview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/trade_terminal/presentation/widgets/tools/risk_management_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/address/wallet_address_add_agreement.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/address/wallet_address_add_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/address/wallet_address_add_form.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/address/wallet_address_add_preview.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/address/wallet_address_add_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/address/wallet_address_add_selectors.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/address/wallet_address_book_controls.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/address/wallet_address_book_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/address/wallet_address_book_security.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/asset_detail_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/asset_detail_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/wallet_buy_crypto_input_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/wallet_buy_crypto_payment_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/wallet_buy_crypto_result_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/wallet_buy_crypto_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/wallet_dust_converter_assets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/wallet_dust_converter_confirm.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/wallet_dust_converter_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/assets/wallet_dust_converter_targets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/history/transaction_detail_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/history/transaction_detail_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/history/transaction_history_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/history/transaction_history_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/phone/wallet_formatters.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/phone/wallet_page_allocation_sections.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/phone/wallet_page_asset_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/phone/wallet_page_balance_sections.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/phone/wallet_page_dca_tool_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/phone/wallet_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/phone/wallet_unavailable_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tablet/wallet_page_allocation_sections.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tablet/wallet_page_asset_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tablet/wallet_page_balance_sections.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tablet/wallet_page_dca_tool_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tablet/wallet_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tablet/wallet_tablet_keys.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tablet/wallet_unavailable_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/network_status_cards_stats.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/network_status_legend_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/network_status_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/portfolio_analytics_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/portfolio_analytics_metrics_assets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/portfolio_analytics_overview_chart.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/portfolio_analytics_summary_switcher.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_gas_optimizer_current.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_gas_optimizer_tips.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_gas_optimizer_trends.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_health_score_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_health_score_charts.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_health_score_page_shell.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_manager_activity_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_manager_all_wallets_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_manager_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_manager_distribution_chart.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_manager_groups_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_manager_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_multi_manager_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_token_active_approvals_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_token_approval_badges.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_token_approval_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_token_approval_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_token_approval_history_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_token_approval_settings_tab.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_token_approval_tabs.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/tools/wallet_token_revoke_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/deposit_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/deposit_page_sections.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/pending_deposits_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/wallet_transfer_asset_amount.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/wallet_transfer_confirm_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/wallet_transfer_history_picker.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/wallet_transfer_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/wallet_transfer_wallet_cards.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/withdraw_amount_actions.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/withdraw_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/withdraw_form_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/withdraw_limits_page_common.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/withdraw_limits_page_sections.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/withdraw_network_picker.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| feature_widget | `` | `flutter_app/lib/features/wallet/presentation/widgets/transfer/withdraw_preview_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/shell_render_mode.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_auto_hide_header_scaffold.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_auto_hide_page_scaffold.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_bottom_nav.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_header_action_button.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_navigation_rail.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_page_content.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_page_layout.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_phone_frame.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_status_bar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_tablet_utility_page.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_top_chrome.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_two_column_tablet_dashboard.dart` | fail | 0 | 0 | 0 | 0 | 7 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_layout | `` | `flutter_app/lib/shared/layout/vit_web_utility_page.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_accent_icon_box.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_accent_pill.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_action_tile_grid.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_announcement_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_asset_avatar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_balance_breakdown_row.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_bottom_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_bullet_row.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_carousel_dots.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_choice_pill.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_community_rules_link.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_compact_product_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_confirm_dialog.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_counted_section_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_cta_button.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_discovery_action_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_empty_state.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_error_state.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_faq_accordion.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_filter_chip.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_financial_safety_summary.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_hero_glow.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_high_risk_state_panel.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_icon_button.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_icon_label_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_icon_list_row.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_info_callout.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_info_row.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_inline_icon_action.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_input.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_inset_scroll_view.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_key_value_row.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_legend_item.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_market_rows.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_market_ticker.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_metric_box.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_metric_column.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_metric_delta_pill.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_module_components.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_next_action_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_notice_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_offline_banner.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_preset_chip_row.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_preview_confirm_sheet.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_progress_bar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_risk_disclaimer_note.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_scrollable_tab_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_search_bar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_section_header.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_segmented_choice.dart` | warn | 0 | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_segmented_progress_bar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_segmented_tab_bar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_sheet_handle.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_skeleton.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_sort_rail.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_sparkline.dart` | exception | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | allowed_source_keyword: custompainter |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_stats_grid.dart` | warn | 0 | 0 | 0 | 0 | 1 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_status_pill.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_step_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_tab_bar.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_task_card.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_toggle_pill.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_trade_instrument_hero.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_trade_order_list.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/vit_trade_product_hub.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |
| shared_widget | `` | `flutter_app/lib/shared/widgets/widgets.dart` | pass | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | - |

## Verification Commands
```bash
cd flutter_app
dart run tool/design_token_consistency_audit.dart
dart run tool/design_token_consistency_audit.dart --check
```
