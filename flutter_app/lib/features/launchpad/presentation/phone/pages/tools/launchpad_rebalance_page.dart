import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/tools/launchpad_rebalance_allocation.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/tools/launchpad_rebalance_deviation.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/tools/launchpad_rebalance_strategy.dart';

part '../../../widgets/tools/launchpad_rebalance_calculations.dart';
part '../../../widgets/tools/launchpad_rebalance_hero.dart';
part '../../../widgets/tools/launchpad_rebalance_suggestions.dart';
part '../../../widgets/tools/launchpad_rebalance_summary.dart';

class LaunchpadRebalancePage extends ConsumerStatefulWidget {
  const LaunchpadRebalancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc312_launchpad_rebalance_content');
  static const heroKey = Key('sc312_launchpad_rebalance_hero');
  static const strategyKey = Key('sc312_launchpad_rebalance_strategies');
  static const allocationKey = Key('sc312_launchpad_rebalance_allocation');
  static const deviationKey = Key('sc312_launchpad_rebalance_deviation');
  static const suggestionsKey = Key('sc312_launchpad_rebalance_suggestions');
  static const summaryKey = Key('sc312_launchpad_rebalance_summary');
  static const warningKey = Key('sc312_launchpad_rebalance_warning');
  static const previewKey = Key('sc312_launchpad_rebalance_preview');
  static const confirmSheetKey = Key('sc312_launchpad_rebalance_confirm_sheet');
  static const confirmKey = Key('sc312_launchpad_rebalance_confirm');
  static const cancelKey = Key('sc312_launchpad_rebalance_cancel');

  static Key strategyButtonKey(String id) =>
      Key('sc312_launchpad_rebalance_strategy_$id');
  static Key suggestionKey(String id) =>
      Key('sc312_launchpad_rebalance_suggestion_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadRebalancePage> createState() =>
      _LaunchpadRebalancePageState();
}

class _LaunchpadRebalancePageState
    extends ConsumerState<LaunchpadRebalancePage> {
  // GD4-F4 bẫy 14: initState() không còn seed từ getter đồng bộ — hạt
  // giống 1 lần trong nhánh `data:` qua `_strategyId ??= ...`.
  String? _strategyId;

  @override
  Widget build(BuildContext context) {
    final rebalanceAsync = ref.watch(launchpadRebalanceSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final chromeReserve = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    const footerHeight = 92.0;
    final scrollTailReserve =
        chromeReserve + safeBottom + AppSpacing.x3 + footerHeight;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Cân bằng lại danh mục đầu tư',
      semanticIdentifier: 'SC-312',
      child: Material(
        type: MaterialType.transparency,
        child: rebalanceAsync.when(
          loading: () => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: scrollTailReserve,
                semanticLabel: 'Cân bằng lại danh mục đầu tư',
                semanticIdentifier: 'SC-312',
                header: VitHeader(
                  title: 'Rebalance',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: const VitSkeletonList(),
              ),
            ],
          ),
          error: (error, stackTrace) => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: scrollTailReserve,
                semanticLabel: 'Cân bằng lại danh mục đầu tư',
                semanticIdentifier: 'SC-312',
                header: VitHeader(
                  title: 'Rebalance',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: VitErrorState(
                  title: 'Không tải được dữ liệu',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(launchpadRebalanceSnapshotProvider),
                ),
              ),
            ],
          ),
          data: (snapshot) {
            final strategyId = _strategyId ??= snapshot.defaultStrategyId;
            final strategy = snapshot.strategies.firstWhere(
              (item) => item.id == strategyId,
              orElse: () => snapshot.strategies.first,
            );
            final assets = launchpadRebalanceAssetsWithTargets(
              snapshot.assets,
              strategy,
            );
            final suggestions = launchpadRebalanceSuggestionsFor(assets);
            final totalValue = assets.fold<double>(
              0,
              (sum, asset) => sum + asset.currentValue,
            );
            final totalDeviation = suggestions.fold<double>(
              0,
              (sum, item) => sum + item.deviation.abs(),
            );
            final txCount = suggestions
                .where((item) => item.action != LaunchpadRebalanceAction.hold)
                .length;
            final totalGas = txCount * 1.5;

            return Stack(
              children: [
                VitAutoHideHeaderScaffold(
                  bottomInset: scrollTailReserve,
                  semanticLabel: 'Cân bằng lại danh mục đầu tư',
                  semanticIdentifier: 'SC-312',
                  header: VitHeader(
                    title: snapshot.title,
                    subtitle:
                        'Cân bằng danh mục · Xem trước trước khi thực hiện',
                    showBack: true,
                    onBack: () => context.go(snapshot.backRoute),
                  ),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: LaunchpadRebalancePage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          LaunchpadRebalanceHero(
                            key: LaunchpadRebalancePage.heroKey,
                            totalValue: totalValue,
                            assetCount: assets.length,
                            totalDeviation: totalDeviation,
                          ),
                          VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Rebalance preview required',
                            message:
                                'Target allocation, deviation, gas estimate, risk impact and confirmation are reviewed before execution.',
                            contractId: 'launchpad-rebalance-$strategyId',
                          ),
                          LaunchpadRebalanceStrategySection(
                            sectionKey: LaunchpadRebalancePage.strategyKey,
                            strategies: snapshot.strategies,
                            activeId: strategyId,
                            strategyButtonKey:
                                LaunchpadRebalancePage.strategyButtonKey,
                            onChanged: (id) => setState(() => _strategyId = id),
                          ),
                          LaunchpadRebalanceAllocationCard(
                            key: LaunchpadRebalancePage.allocationKey,
                            assets: assets,
                          ),
                          LaunchpadRebalanceDeviationCard(
                            key: LaunchpadRebalancePage.deviationKey,
                            assets: assets,
                          ),
                          LaunchpadRebalanceSuggestionsSection(
                            sectionKey: LaunchpadRebalancePage.suggestionsKey,
                            suggestionKey: LaunchpadRebalancePage.suggestionKey,
                            suggestions: suggestions,
                          ),
                          LaunchpadRebalanceSummaryCard(
                            key: LaunchpadRebalancePage.summaryKey,
                            txCount: txCount,
                            totalGas: totalGas,
                            strategy: strategy,
                          ),
                          const LaunchpadRebalanceWarningBanner(
                            key: LaunchpadRebalancePage.warningKey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: chromeReserve + safeBottom,
                  child: VitStickyFooter(
                    backgroundColor: AppColors.surface.withValues(alpha: .94),
                    child: VitCtaButton(
                      key: LaunchpadRebalancePage.previewKey,
                      onPressed: () =>
                          unawaited(_confirmRebalance(suggestions, totalGas)),
                      child: const Text('Xem lai & Thuc hien Rebalance'),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmRebalance(
    List<RebalanceSuggestion> suggestions,
    double totalGas,
  ) async {
    final executable = suggestions
        .where((item) => item.action != LaunchpadRebalanceAction.hold)
        .toList();
    await showVitPreviewConfirmSheet(
      context: context,
      title: 'Xác nhận Rebalance',
      sheetKey: LaunchpadRebalancePage.confirmSheetKey,
      confirmKey: LaunchpadRebalancePage.confirmKey,
      cancelKey: LaunchpadRebalancePage.cancelKey,
      confirmLabel: 'Xác nhận Rebalance (Mô phỏng)',
      confirmVariant: VitCtaButtonVariant.success,
      items: executable.isEmpty
          ? const [
              VitFinancialSafetyItem(
                label: 'Trạng thái',
                value: 'Danh mục đã cân bằng — không cần giao dịch',
              ),
            ]
          : [
              for (final suggestion in executable)
                VitFinancialSafetyItem(
                  label: launchpadRebalanceActionLabel(suggestion.action),
                  value:
                      '${suggestion.asset.symbol}  '
                      '\$${suggestion.suggestedValue.toStringAsFixed(2)}',
                ),
            ],
      footer: 'Gas tổng: ~\$${totalGas.toStringAsFixed(2)}',
    );
  }
}
