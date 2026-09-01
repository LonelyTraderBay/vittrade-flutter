import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_hub_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_product_tabs.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/theme/trade_core_spacing_tokens.dart';

/// Home-aligned bottom scroll clearance for L2 trade detail/hub pages.
double tradeScrollBottomInset(
  BuildContext context, {
  ShellRenderMode? shellRenderMode,
}) {
  final mode = shellRenderMode ?? defaultShellRenderMode();
  final base = mode.usesVisualQaFrame
      ? AppSurfaceSpacing.buttonStandard + AppSurfaceSpacing.x7
      : AppSurfaceSpacing.buttonStandard + AppSurfaceSpacing.x5;
  return base + MediaQuery.paddingOf(context).bottom;
}

/// Copy-trading hub uses dedicated inset tokens (taller hero/footer).
double copyTradingScrollBottomInset(
  BuildContext context, {
  ShellRenderMode? shellRenderMode,
}) {
  final mode = shellRenderMode ?? defaultShellRenderMode();
  final base = mode.usesVisualQaFrame
      ? TradeCoreSpacingTokens.copyTradingBottomInsetVisual
      : TradeCoreSpacingTokens.copyTradingBottomInsetNative;
  return base + MediaQuery.paddingOf(context).bottom;
}

/// L1 instrument terminals (Trade/Futures/Margin) with portfolio dock.
double tradeTerminalScrollBottomInset(
  BuildContext context, {
  ShellRenderMode? shellRenderMode,
}) {
  final mode = shellRenderMode ?? defaultShellRenderMode();
  final chromeInset = mode.usesVisualQaFrame
      ? DeviceMetrics.bottomChrome
      : DeviceMetrics.nativeBottomChrome;
  final extra = mode.usesVisualQaFrame
      ? TradeCoreSpacingTokens.tradeBottomInsetVisual
      : TradeCoreSpacingTokens.tradeBottomInsetNative;
  return chromeInset + MediaQuery.paddingOf(context).bottom + extra;
}

/// Prepends [VitTradeProductTabs] when [showProductTabs] is true.
///
/// The Spot/Futures/Margin/Convert/Bot product-tab nav bar is a
/// `trade`-domain concept — `trade_core` has no knowledge of which routes
/// those tabs point to, so it never supplies a default [navigationBuilder].
/// `trade` pages and `trade_bots`'s hub (as of ARCH-A2, 2026-07-19 — see
/// `trade_product_navigation.dart`) pass `showProductTabs: true` together
/// with `buildTradeProductNavigation`. `trade_copy` and `trade_compliance`
/// should still leave [showProductTabs] at its default `false` rather than
/// borrowing this wrong-domain nav source.
List<Widget> tradeShellWithProductTabs({
  required BuildContext context,
  required List<Widget> children,
  bool showProductTabs = false,
  String? activeProductId,
  TradePair? productPair,
  Key Function(String id)? quickNavKey,
  TradeProductNavigationBuilder? navigationBuilder,
}) {
  if (!showProductTabs) {
    return children;
  }
  assert(
    navigationBuilder != null,
    'tradeShellWithProductTabs: showProductTabs is true but no '
    'navigationBuilder was supplied. This nav-bar source is '
    "trade_terminal-specific — pass trade_terminal's "
    'buildTradeProductNavigation explicitly, or leave showProductTabs at '
    'its default false.',
  );
  if (navigationBuilder == null) {
    return children;
  }
  final nav = navigationBuilder(
    context: context,
    pair: productPair,
    activeId: activeProductId ?? '',
    quickNavKey: quickNavKey,
  );
  return [
    VitTradeProductTabs(
      activeId: activeProductId ?? '',
      tabs: nav.tabs,
      overflowItems: nav.overflow,
    ),
    ...children,
  ];
}

/// Section rhythm wrapper: VitSectionHeader + x3 gap + child.
class VitTradeSection extends StatelessWidget {
  const VitTradeSection({
    super.key,
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
    this.headerTrailing,
    this.innerGap,
  });

  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? headerTrailing;

  /// Luật 12dp (2026-08-31): caller TABLET truyền 12 để tách nhịp khỏi
  /// tier mặc định dùng chung với phone (8) — null giữ nguyên cho phone.
  final double? innerGap;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: title,
      headerVariant: VitSectionHeaderVariant.plain,
      headerDensity: VitDensity.standard,
      actionLabel: actionLabel,
      onAction: onAction,
      headerTrailing: headerTrailing,
      gap: VitContentGap.tight,
      innerGap: innerGap,
      children: [child],
    );
  }
}

/// L2 detail scaffold for trade sub-flows (margin, bots, copy, regulatory).
class VitTradeDetailScaffold extends StatelessWidget {
  const VitTradeDetailScaffold({
    super.key,
    required this.title,
    required this.children,
    this.semanticLabel,
    this.semanticIdentifier,
    this.subtitle,
    this.contentKey,
    this.showBack = true,
    this.onBack,
    this.backKey,
    this.bottomInset,
    this.shellRenderMode,
    this.headerActions = const [],
    this.useCopyTradingInset = false,
    this.showProductTabs = false,
    this.activeProductId,
    this.productPair,
    this.quickNavKey,
    this.navigationBuilder,
    this.footer,
  });

  final String title;
  final List<Widget> children;
  final String? semanticLabel;

  /// Internal screen code (e.g. `SC-007`) for tooling/debugging — see A11Y-1,
  /// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
  final String? semanticIdentifier;
  final String? subtitle;
  final Key? contentKey;
  final bool showBack;
  final VoidCallback? onBack;
  final Key? backKey;
  final double? bottomInset;
  final ShellRenderMode? shellRenderMode;
  final List<VitHeaderActionItem> headerActions;
  final bool useCopyTradingInset;

  /// Terminal-specific — see the doc comment on [tradeShellWithProductTabs].
  final bool showProductTabs;
  final String? activeProductId;
  final TradePair? productPair;
  final Key Function(String id)? quickNavKey;

  /// Required whenever [showProductTabs] is true (see
  /// [tradeShellWithProductTabs]). `trade` pages and `trade_bots`'s hub
  /// should pass `buildTradeProductNavigation`; `trade_copy` and
  /// `trade_compliance` should not set this.
  final TradeProductNavigationBuilder? navigationBuilder;

  /// Optional sticky footer rendered below the scrollable content (e.g. a
  /// fixed confirm/cancel action bar). Omitted by default.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final resolvedInset =
        bottomInset ??
        (useCopyTradingInset
            ? copyTradingScrollBottomInset(
                context,
                shellRenderMode: shellRenderMode,
              )
            : tradeScrollBottomInset(
                context,
                shellRenderMode: shellRenderMode,
              ));

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      semanticIdentifier: semanticIdentifier,
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitHeader(
              title: title,
              subtitle: subtitle,
              showBack: showBack,
              onBack: onBack,
              backKey: backKey,
              actions: headerActions,
            ),
            Expanded(
              child: VitInsetScrollView(
                key: contentKey,
                bottomInset: resolvedInset,
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  padding: VitContentPadding.compact,
                  density: VitDensity.tool,
                  children: tradeShellWithProductTabs(
                    context: context,
                    children: children,
                    showProductTabs: showProductTabs,
                    activeProductId: activeProductId,
                    productPair: productPair,
                    quickNavKey: quickNavKey,
                    navigationBuilder: navigationBuilder,
                  ),
                ),
              ),
            ),
            ?footer,
          ],
        ),
      ),
    );
  }
}

/// L2 hub with auto-hide header — matches Home scroll shell grammar.
class VitTradeHubScaffold extends StatelessWidget {
  const VitTradeHubScaffold({
    super.key,
    required this.title,
    required this.children,
    this.semanticLabel,
    this.semanticIdentifier,
    this.subtitle,
    this.contentKey,
    this.showBack = true,
    this.onBack,
    this.backKey,
    this.shellRenderMode,
    this.useCopyTradingInset = false,
    this.headerActions = const [],
    this.showProductTabs = false,
    this.activeProductId,
    this.productPair,
    this.quickNavKey,
    this.navigationBuilder,
  });

  final String title;
  final List<Widget> children;
  final String? semanticLabel;

  /// Internal screen code (e.g. `SC-007`) for tooling/debugging — see A11Y-1,
  /// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/A-Plus-Task-Manifest.csv.
  final String? semanticIdentifier;
  final String? subtitle;
  final Key? contentKey;
  final bool showBack;
  final VoidCallback? onBack;
  final Key? backKey;
  final ShellRenderMode? shellRenderMode;
  final bool useCopyTradingInset;
  final List<VitHeaderActionItem> headerActions;

  /// Terminal-specific — see the doc comment on [tradeShellWithProductTabs].
  final bool showProductTabs;
  final String? activeProductId;
  final TradePair? productPair;
  final Key Function(String id)? quickNavKey;

  /// Required whenever [showProductTabs] is true (see
  /// [tradeShellWithProductTabs]). `trade` pages and `trade_bots`'s hub
  /// should pass `buildTradeProductNavigation`; `trade_copy` and
  /// `trade_compliance` should not set this.
  final TradeProductNavigationBuilder? navigationBuilder;

  @override
  Widget build(BuildContext context) {
    final scrollEndClearance = useCopyTradingInset
        ? copyTradingScrollBottomInset(
            context,
            shellRenderMode: shellRenderMode,
          )
        : tradeScrollBottomInset(context, shellRenderMode: shellRenderMode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      semanticIdentifier: semanticIdentifier,
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: showBack,
            onBack: onBack,
            backKey: backKey,
            actions: headerActions,
          ),
          child: VitInsetScrollView(
            key: contentKey,
            bottomInset: scrollEndClearance,
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.compact,
              density: VitDensity.tool,
              children: tradeShellWithProductTabs(
                context: context,
                children: children,
                showProductTabs: showProductTabs,
                activeProductId: activeProductId,
                productPair: productPair,
                quickNavKey: quickNavKey,
                navigationBuilder: navigationBuilder,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// L1 instrument workspace scroll shell (spot-like surfaces).
class VitTradeWorkspaceScaffold extends StatelessWidget {
  const VitTradeWorkspaceScaffold({
    super.key,
    required this.semanticLabel,
    required this.children,
    this.contentKey,
    this.shellRenderMode,
    this.bottomInset,
  });

  final String semanticLabel;
  final List<Widget> children;
  final Key? contentKey;
  final ShellRenderMode? shellRenderMode;
  final double? bottomInset;

  @override
  Widget build(BuildContext context) {
    final resolvedInset =
        bottomInset ??
        tradeTerminalScrollBottomInset(
          context,
          shellRenderMode: shellRenderMode,
        );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      child: Material(
        type: MaterialType.transparency,
        child: VitInsetScrollView(
          key: contentKey,
          bottomInset: resolvedInset,
          child: VitPageContent(
            rhythm: VitPageRhythm.compact,
            padding: VitContentPadding.compact,
            density: VitDensity.tool,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// Home-aligned 2-KPI hero strip for bot sub-pages (mirrors SC-059 hub).
///
/// Thin alias over [VitTradeHubHero] kept for the existing bot sub-page call
/// sites — new hub/list archetype pages should use [VitTradeHubHero]
/// directly (see `Trade-Hero-Section-Archetype-Standard.md`).
class VitBotSubpageHero extends StatelessWidget {
  const VitBotSubpageHero({
    super.key,
    required this.primaryLabel,
    required this.primaryValue,
    required this.secondaryLabel,
    required this.secondaryValue,
    this.primaryColor,
    this.secondaryColor,
  });

  final String primaryLabel;
  final String primaryValue;
  final String secondaryLabel;
  final String secondaryValue;
  final Color? primaryColor;
  final Color? secondaryColor;

  @override
  Widget build(BuildContext context) {
    return VitTradeHubHero(
      primaryLabel: primaryLabel,
      primaryValue: primaryValue,
      secondaryLabel: secondaryLabel,
      secondaryValue: secondaryValue,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
    );
  }
}

/// Flat risk review footer — no card-in-card nesting.
class VitBotRiskReviewFooter extends StatelessWidget {
  const VitBotRiskReviewFooter({
    super.key,
    required this.title,
    required this.message,
    this.contractId,
    this.statusLabel,
    this.status = VitStatusPillStatus.info,
  });

  final String title;
  final String message;
  final String? contractId;
  final String? statusLabel;
  final VitStatusPillStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: title,
          message: message,
          contractId: contractId,
          density: VitDensity.tool,
        ),
        if (statusLabel != null) ...[
          SizedBox(height: AppSurfaceSpacing.pageRhythmCompactInnerGap),
          VitStatusPill(
            label: statusLabel!,
            status: status,
            size: VitStatusPillSize.sm,
          ),
        ],
        SizedBox(height: AppSurfaceSpacing.pageRhythmStandardInnerGap),
        const VitBotRiskDisclaimer(),
      ],
    );
  }
}

/// Hub-aligned risk micro-disclaimer.
class VitBotRiskDisclaimer extends StatelessWidget {
  const VitBotRiskDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bot không đảm bảo lợi nhuận. Hiệu suất quá khứ không đại diện kết quả tương lai.',
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      textAlign: TextAlign.center,
    );
  }
}
