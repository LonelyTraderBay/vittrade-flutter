# Trade Hero Section Archetype Standard

**Scope:** Trade-module screens on both surfaces — See [UI-Rule-Layer-Map.md](./UI-Rule-Layer-Map.md).  
**Status:** Foundation batch landed (2026-07-13): four shared hero widgets
now exist in `lib/features/trade_core/presentation/widgets/` — `trade_core`
is the shared module the other 4 trade feature modules (`trade_terminal`,
`trade_copy`, `trade_bots`, `trade_compliance`) all depend on after the
Phase 5 module split (route paths unchanged; pure code-organization move).
Migration onto the four widgets is in progress — see §3's migration-status
paragraph for the current per-page list; the page-local hero files not yet
migrated are still live and still render today. This doc is the contract
for *new* trade pages starting now (in any of the 5 modules), and the
target shape for the migration tiers that follow.

No dedicated automated guardrail exists yet for hero-archetype *adoption*
specifically (nothing checks which of the four widgets, if any, a given
page's hero uses) — see §4 for the manual check until a migration tier
lands and a guardrail can be added. Separately, as of Phase 5 Batch B, the
general-purpose `tool/design_token_consistency_audit.dart` and
`tool/home_reference_consistency_audit.dart` guardrails were extended with
frozen per-module baselines for all 5 trade_* modules (`trade_core: 3`,
`trade_terminal: 6`, `trade_copy: 0`, `trade_bots: 0`, `trade_compliance: 0`
token-debt baseline in the former; all 5 at `0` divergence baseline in the
latter) — so raw-`Container`/`BorderRadius.circular(`-style token debt
introduced anywhere in these modules, including in a non-compliant
page-local hero added in violation of §2, is now ratcheted and CI-gated.
Neither tool is hero-specific, though: they catch general token/pattern
debt, not "did this page use `VitTradeHubHero` vs a new page-local widget."
§4's manual check remains the only way to verify hero-archetype compliance
itself.

## 1. The four archetypes

Every trade screen's hero belongs to one of four shapes. Match the page's
actual content shape, not just which shell it happens to use — see the note
under the table.

| Archetype | Typical shell | Hero widget | Existing page-local hero it replaces |
| --- | --- | --- | --- |
| Hub / list — a product hub or list root the user scrolls and returns to | `VitTradeHubScaffold` (or `VitTradeSimpleShell` for the beginner-mode variant, which itself wraps `VitTradeHubScaffold`) | `VitTradeHubHero` | `VitBotSubpageHero` (bot sub-pages; now a thin alias — see §2) |
| Entity-detail / flow-step — a primary stat for one bounded entity (a leveraged position, a copy-trading portfolio snapshot, a wizard step), optionally with a secondary KPI or a risk/status badge | `VitTradeDetailScaffold` (also valid on a `VitTradeHubScaffold`-rooted page when the page itself *is* the entity view, e.g. the copy-trading hub's own portfolio snapshot) | `VitTradeDetailHero` | `copy_trading_hero.dart` (`_CopyHeroCard`), `leverage_header_hero_risk.dart` (`_LeverageHero`) |
| Analytics — an icon/title/subtitle banner plus an inline metric-grid row of labeled numeric stats | `VitTradeDetailScaffold` or `VitTradeHubScaffold` | `VitTradeAnalyticsHero` | `advanced_analytics_page_hero.dart` (`_HeroCard`/`_HeroStat`) |
| Compliance / regulatory — a status-banner (icon + title + description) tinted by an accent color, pairing with a compliance list below it | `VitTradeHubScaffold` typically (regulatory landing pages today), `VitTradeDetailScaffold` for a single-document detail | `VitTradeComplianceHero` + `VitTradeComplianceSection` | `regulatory_disclosures_hero_tabs.dart` (`_LegalHero`) |

The shell (`VitTradeHubScaffold` vs `VitTradeDetailScaffold` vs
`VitTradeSimpleShell`) is chosen per
[Trade-Header-Navigation-Conventions.md](./Trade-Header-Navigation-Conventions.md)
§1 (root/hub vs entity-detail/flow-step). The hero archetype is chosen
independently, by content shape — a hub-shelled page can still use
`VitTradeDetailHero` if what it shows is one bounded entity's stat, and a
detail-shelled page can use `VitTradeAnalyticsHero` if its content is a
metric grid. Do not force a hero choice just to match the shell name.

## 2. Rule: no new page-local hero/section widgets

New trade pages must not define a page-local `_HeroCard`, `_ProfileHero`,
`_LegalHero`, or similar private hero widget. Use one of the four widgets
above. If none of the four fits a genuinely new content shape, extend the
closest one with an additional optional parameter rather than adding a
fifth hero widget or a page-local one-off.

`VitBotSubpageHero` (`trade_module_layout.dart`) is kept working as a thin
alias over `VitTradeHubHero` for its existing bot sub-page call sites; do
not add new call sites to `VitBotSubpageHero` — use `VitTradeHubHero`
directly for anything that is not one of those existing bot sub-pages.

`VitTradeComplianceSection` (`vit_trade_compliance_section.dart`) is
unchanged by this doc — it already covers the compliance list-row shape
and is meant to sit directly below `VitTradeComplianceHero`.

## 3. Widgets and signatures

All four live in `lib/features/trade_core/presentation/widgets/` as sibling
`vit_trade_*.dart` files (matching `vit_trade_compliance_section.dart`, also
in `trade_core`), not inside `trade_module_layout.dart` (same directory).
`vit_trade_simple_hero.dart` — the `VitTradeSimpleShell`-variant helper
referenced in §1's table — lives in `lib/features/trade_terminal/presentation/widgets/`
instead, since it is specific to that module's beginner-mode pages rather
than a `trade_core`-shared primitive:

- `vit_trade_hub_hero.dart` → `VitTradeHubHero({ primaryLabel, primaryValue, secondaryLabel, secondaryValue, primaryColor?, secondaryColor? })` — 2-column KPI strip with a hairline divider.
- `vit_trade_detail_hero.dart` → `VitTradeDetailHero({ primaryLabel?, primaryValue?, primaryColor?, leadingIcon?, secondaryLabel?, secondaryValue?, secondaryColor?, badgeLabel?, badgeColor?, footnote?, borderColor?, avatar?, identityTitle?, identityTrailing?, tags?, stats?, progressValue?, progressColor?, progressLeadingLabel?, progressTrailingLabel?, ctaKey?, ctaLabel?, ctaLeading?, ctaVariant = primary, onCtaPressed? })` — renders the 2-column KPI strip when `secondaryLabel`/`secondaryValue` are both set (requires `primaryLabel`/`primaryValue` too), otherwise a single centered stat with an optional leading icon eyebrow and an optional risk/status badge below it; an optional `footnote` line renders under either mode. `primaryLabel`/`primaryValue` are optional so the stat block can be skipped entirely for the richer "entity profile" shape below.
  - Entity-profile extension (added for `trader_profile_page.dart`): an optional `avatar`/`identityTitle`/`identityTrailing`/`tags` identity row (avatar widget + name + trailing indicator + a `Wrap` of pre-built tag/pill widgets, e.g. `VitAccentPill`), a `stats` metric grid reusing `VitTradeAnalyticsStat` from `vit_trade_analytics_hero.dart`, a `progressValue`/`progressColor`/`progressLeadingLabel`/`progressTrailingLabel` progress bar, and a `ctaLabel`/`ctaLeading`/`ctaVariant`/`onCtaPressed` CTA button. Every one of these is independently optional and renders nothing when unset, so the pre-existing `leverage_page.dart`/`copy_trading_page.dart` call sites keep compiling and rendering unchanged. Section order (each conditionally rendered, gaps only inserted between two rendered sections): identity row → primary/secondary stat block → stats grid → badge → progress bar → footnote → CTA button.
- `vit_trade_analytics_hero.dart` → `VitTradeAnalyticsHero({ icon, title, subtitle, stats })` with `VitTradeAnalyticsStat({ label, value, color })` — icon/title/subtitle banner plus an inline row of inner-card stats.
- `vit_trade_compliance_hero.dart` → `VitTradeComplianceHero({ title, description, icon = Icons.balance_rounded, accentColor = AppColors.primary })` — icon + title + description banner tinted by `accentColor`.

Migration status (Tier 1, in progress) using `VitTradeHubHero`: `margin_trading_hub_page.dart`,
`leverage_page.dart`, `order_receipt_page.dart` (all `trade_terminal`), `trading_bots_page.dart` (`trade_bots`). Using `VitTradeDetailHero`/`VitTradeComplianceHero`: `copy_trading_page.dart`, `trader_profile_page.dart`, `copy_education_page.dart`, `copy_safety_center_page.dart`, `copy_audit_log_page.dart`, `copy_confirmation_page.dart` (all `trade_copy`). Using `VitTradeAnalyticsHero`: `provider_governance_page.dart` (`trade_copy`). All of the above have been migrated. `trader_profile_page.dart`'s `_ProfileHero` (avatar + identity + tags + 4-stat grid + copier-progress bar + CTA) previously did not fit `VitTradeDetailHero`'s primary/secondary-stat shape; rather than leaving it as a permanent exception, `VitTradeDetailHero` was extended with the optional identity/tags/stats/progress/CTA params described above and the page-local `_ProfileHero`/`_TagChip`/`_HeroMetric` classes (`trader_profile_hero.dart`) were deleted (confirmed gone — no longer present anywhere in the codebase). Remaining pages listed in the table above are migrated in later tiers, which also retire the page-local private hero classes at that point — do not delete those page-local files before their page's migration lands. One exception: `copy_trading_hero.dart` (`lib/features/trade_copy/presentation/widgets/copy_trading_hero.dart`) is kept on disk (emptied to just its `part of` directive) rather than deleted, because `test/quality/trade_product_copy_guardrails_test.dart` reads that exact file path as part of its copy-safety corpus scan.

Note: a broader grep for the four hero widgets' constructor calls (`VitTradeHubHero(`, `VitTradeDetailHero(`, `VitTradeAnalyticsHero(`, `VitTradeComplianceHero(`) across `lib/features/trade_*` during this update turned up noticeably more consumer pages than the list above — including several `trade_compliance` pages (`regulatory_reports_dashboard_page.dart`, `ex_post_costs_report_page.dart`, `complaint_submission_page.dart`, `client_money_protection_page.dart`, `regulatory_disclosures_page.dart`, `product_governance_page.dart`, `kid_generator_page.dart`, `ex_ante_costs_page.dart`, `complaints_handling_page.dart`, `audit_trail_page.dart`, `transaction_reporting_page.dart`, `target_market_definition_page.dart`, `ombudsman_referral_page.dart`, `slippage_monitoring_page.dart`) and `trade_terminal`'s `advanced_analytics_page.dart`/`execution_quality_overview.dart`. This batch did not attempt to reconcile whether those pages were already built directly on the shared widgets (never had a page-local hero to "migrate" from) versus this list simply being stale — that requires per-page judgment outside this docs-only batch's scope, so it is flagged here rather than guessed at.

## 4. Verify

No dedicated automated guardrail exists yet for this domain. Until a
later tier adds one, verify a touched file by hand:

```bash
cd flutter_app
dart format --output=none --set-exit-if-changed lib/features/trade_core/presentation/widgets/vit_trade_hub_hero.dart lib/features/trade_core/presentation/widgets/vit_trade_detail_hero.dart lib/features/trade_core/presentation/widgets/vit_trade_analytics_hero.dart lib/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart lib/features/trade_core/presentation/widgets/trade_module_layout.dart
flutter analyze
```

When a later tier migrates a page onto one of these widgets, apply the
usual page-change checklist from
[Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md)
§5 (page rhythm, card tile, content width, etc.) to that page.

## Related

- [Trade-Header-Navigation-Conventions.md](./Trade-Header-Navigation-Conventions.md) — shell choice and back-navigation rules this doc's shell column defers to
- [Flutter-Design-System-Reference.md](../Flutter-Design-System-Reference.md) — §2 audit-domain map
