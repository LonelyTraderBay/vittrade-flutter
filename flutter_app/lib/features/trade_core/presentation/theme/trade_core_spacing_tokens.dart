import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';

/// Spacing tokens for `trade_core` shared widgets (hero cards, section
/// rhythm wrapper, scroll-inset helpers).
///
/// Extracted from `TradeSpacingTokens`
/// (`app/theme/spacing/trade_spacing_tokens.dart`) during the Phase 0
/// trade-module split — see
/// `docs/02_FLUTTER_MIGRATION/standards/Trade-Header-Navigation-Conventions.md`
/// context. Only tokens referenced by files under `features/trade_core/`
/// live here; the full trade spacing token set remains in
/// `TradeSpacingTokens` until each domain (terminal/copy/bots/compliance)
/// moves into its own sibling module in a later phase.
final class TradeCoreSpacingTokens {
  const TradeCoreSpacingTokens._();

  /// Left padding for the secondary stat column in a 2-KPI hero strip.
  static EdgeInsets get tradeBotHeroSecondaryPadding =>
      EdgeInsets.only(left: AppSurfaceSpacing.x4);

  /// L1 instrument terminal scroll-end clearance (visual QA frame).
  static const double tradeBottomInsetVisual = 54;

  /// L1 instrument terminal scroll-end clearance (native).
  static const double tradeBottomInsetNative = 20;

  /// Home-aligned section rhythm for L2 trade pages (8px).
  static double get tradePageContentGap => AppSurfaceSpacing.x3;

  /// Copy-trading hub scroll-end clearance (visual QA frame).
  static const double copyTradingBottomInsetVisual = 126;

  /// Copy-trading hub scroll-end clearance (native).
  static const double copyTradingBottomInsetNative = 28;

  /// Progress bar height for entity-detail hero progress rows.
  static double get traderProfileProgressHeight => AppSurfaceSpacing.x3;

  /// Icon size for the compliance/regulatory hero banner.
  static double get regulatoryDisclosuresHeroIcon =>
      AppSurfaceSpacing.iconMd + AppSurfaceSpacing.x1;
}
