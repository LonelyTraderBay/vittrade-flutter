import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'dca_rebalance_config_page_allocation_strategy.dart';
part 'dca_rebalance_config_page_settings_and_preview.dart';
part 'dca_rebalance_config_page_common.dart';

const _dcaRebalancePreviewNavClearance = 72.0;
const _dcaRebalanceSummaryRingSize = 104.0;
const _dcaRebalanceBodyLineHeight = DcaSpacingTokens.dcaRebalanceBodyLineHeight;
const _dcaRebalanceCompactLineHeight =
    DcaSpacingTokens.dcaRebalanceCompactLineHeight;
const _dcaRebalanceTightLineHeight =
    DcaSpacingTokens.dcaRebalanceTightLineHeight;
const _dcaRebalanceToggleHeight = DcaSpacingTokens.dcaRebalanceToggleHeight;
const _dcaRebalanceHeroPadding = EdgeInsetsDirectional.all(AppSpacing.x4);
const _dcaRebalanceCardPadding = EdgeInsetsDirectional.all(AppSpacing.x3);

class DCARebalanceConfigPage extends ConsumerStatefulWidget {
  const DCARebalanceConfigPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc170_rebalance_content');
  static const addTargetKey = Key('sc170_add_target');
  static const previewKey = Key('sc170_preview');
  static const saveKey = Key('sc170_save');
  static const previewSheetKey = Key('sc170_preview_sheet');
  static const confirmSaveKey = Key('sc170_confirm_save');
  static const advancedToggleKey = Key('sc170_advanced_toggle');

  static Key strategyKey(DcaRebalanceStrategy strategy) {
    return Key('sc170_strategy_${strategy.name}');
  }

  static Key targetSliderKey(String id) {
    return Key('sc170_target_slider_$id');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCARebalanceConfigPage> createState() =>
      _DCARebalanceConfigPageState();
}

class _DCARebalanceConfigPageState
    extends ConsumerState<DCARebalanceConfigPage> {
  bool _autoExecute = false;
  bool _showAdvanced = false;
  bool _showPreview = false;

  // STATE-S23: targets/strategy/frequency/driftThreshold/minTradeAmountUsd
  // sống ở DcaRebalanceConfigStateController (một nguồn sự thật) — hết
  // `late List`/`late` seed từ snapshot + setState.

  @override
  Widget build(BuildContext context) {
    final dcaRebalanceConfigAsync = ref.watch(dcaRebalanceConfigProvider);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Cấu hình tự động cân bằng lại danh mục DCA',
      semanticIdentifier: 'SC-170',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Auto-Rebalance',
            subtitle: 'Đầu tư có kỷ luật · cân bằng danh mục',
            showBack: true,
            onBack: _close,
          ),
          child: dcaRebalanceConfigAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được cấu hình cân bằng',
              message: 'Thử lại sau hoặc quay lại màn DCA.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(dcaRebalanceConfigProvider),
            ),
            data: (_) => _buildBody(context, scrollEndPadding),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double scrollEndPadding) {
    final viewState = ref.watch(dcaRebalanceConfigStateControllerProvider);
    final snapshot = viewState.snapshot;

    return Stack(
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: VitInsetScrollView(
            key: DCARebalanceConfigPage.contentKey,
            physics: const ClampingScrollPhysics(),
            bottomInset: scrollEndPadding,
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                const VitInfoCallout(
                  title: 'Tự động cân bằng danh mục',
                  message:
                      'Duy trì tỷ lệ phân bổ tài sản theo mục tiêu. Hệ thống tự động mua/bán khi danh mục lệch khỏi ngưỡng.',
                  icon: Icons.verified_user_outlined,
                  accentColor: AppModuleAccents.trade,
                  radius: VitCardRadius.large,
                  padding: _dcaRebalanceHeroPadding,
                ),
                _AllocationSummary(
                  targets: viewState.targets,
                  totalPercent: _totalPercent(viewState.targets),
                  onAdd: _addTarget,
                ),
                _TargetList(
                  targets: viewState.targets,
                  onPercentChanged: _updateTargetPercent,
                  onToleranceChanged: _updateTargetTolerance,
                  onRemove: _removeTarget,
                ),
                _StrategySection(
                  options: snapshot.strategyOptions,
                  active: viewState.strategy,
                  onChanged: (strategy) {
                    unawaited(HapticFeedback.selectionClick());
                    ref
                        .read(
                          dcaRebalanceConfigStateControllerProvider.notifier,
                        )
                        .setStrategy(strategy);
                  },
                ),
                if (viewState.strategy == DcaRebalanceStrategy.threshold ||
                    viewState.strategy == DcaRebalanceStrategy.hybrid)
                  _ThresholdCard(
                    value: viewState.driftThreshold,
                    onChanged: (value) => ref
                        .read(
                          dcaRebalanceConfigStateControllerProvider.notifier,
                        )
                        .setDriftThreshold(value),
                  ),
                if (viewState.strategy == DcaRebalanceStrategy.periodic ||
                    viewState.strategy == DcaRebalanceStrategy.hybrid)
                  _FrequencyCard(
                    options: snapshot.frequencyOptions,
                    active: viewState.frequency,
                    onChanged: (frequency) {
                      unawaited(HapticFeedback.selectionClick());
                      ref
                          .read(
                            dcaRebalanceConfigStateControllerProvider.notifier,
                          )
                          .setFrequency(frequency);
                    },
                  ),
                _AdvancedSettings(
                  expanded: _showAdvanced,
                  minTradeAmountUsd: viewState.minTradeAmountUsd,
                  autoExecute: _autoExecute,
                  onToggleExpanded: () {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _showAdvanced = !_showAdvanced);
                  },
                  onMinTradeChanged: (value) => ref
                      .read(dcaRebalanceConfigStateControllerProvider.notifier)
                      .setMinTradeAmount(value),
                  onAutoExecuteChanged: (value) {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _autoExecute = value);
                  },
                ),
                _InlineRebalanceActions(
                  valid: _isValidTotal(viewState.targets),
                  onPreview: _openPreview,
                  onSave: _openPreview,
                ),
                const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'DCA rebalance configuration state review',
                  message:
                      'Target allocations, strategy, threshold, frequency, advanced settings, auto-execute risk, preview sheet, fees, and disabled save state remain visible before saving rebalance automation.',
                  contractId: 'SC-170',
                  density: VitDensity.compact,
                ),
              ],
            ),
          ),
        ),
        if (_showPreview)
          _PreviewSheet(
            previews: _tradePreviews(
              viewState.targets,
              viewState.minTradeAmountUsd,
              snapshot.totalPortfolioUsd,
            ),
            totalFeesUsd: _totalFeesUsd(
              viewState.targets,
              viewState.minTradeAmountUsd,
              snapshot.totalPortfolioUsd,
            ),
            onClose: _closePreview,
            onConfirm: _saveConfig,
          ),
      ],
    );
  }

  double _totalPercent(List<DcaRebalanceTarget> targets) {
    return targets.fold<double>(0, (sum, target) => sum + target.targetPercent);
  }

  bool _isValidTotal(List<DcaRebalanceTarget> targets) =>
      (_totalPercent(targets) - 100).abs() < 0.01;

  void _addTarget() {
    unawaited(HapticFeedback.selectionClick());
    ref.read(dcaRebalanceConfigStateControllerProvider.notifier).addTarget();
  }

  void _removeTarget(String id) {
    unawaited(HapticFeedback.selectionClick());
    ref
        .read(dcaRebalanceConfigStateControllerProvider.notifier)
        .removeTarget(id);
  }

  void _updateTargetPercent(String id, double value) {
    ref
        .read(dcaRebalanceConfigStateControllerProvider.notifier)
        .updateTargetPercent(id, value);
  }

  void _updateTargetTolerance(String id, double value) {
    ref
        .read(dcaRebalanceConfigStateControllerProvider.notifier)
        .updateTargetTolerance(id, value);
  }

  void _openPreview() {
    final targets = ref.read(dcaRebalanceConfigStateControllerProvider).targets;
    if (!_isValidTotal(targets)) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _showPreview = true);
  }

  void _closePreview() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _showPreview = false);
  }

  void _saveConfig() {
    unawaited(HapticFeedback.selectionClick());
    context.go(AppRoutePaths.dcaRebalanceDashboard);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  List<DcaRebalanceTradePreview> _tradePreviews(
    List<DcaRebalanceTarget> targets,
    double minTradeAmountUsd,
    int totalPortfolioUsd,
  ) {
    return targets.map((target) {
      final targetValue = totalPortfolioUsd * target.targetPercent / 100;
      final diff = targetValue - target.currentValueUsd;
      final tradeAmount = diff.abs();
      final action = tradeAmount < minTradeAmountUsd
          ? DcaRebalanceTradeAction.hold
          : diff > 0
          ? DcaRebalanceTradeAction.buy
          : DcaRebalanceTradeAction.sell;
      return DcaRebalanceTradePreview(
        symbol: target.symbol,
        action: action,
        currentPercent: target.currentPercent,
        targetPercent: target.targetPercent,
        tradeAmountUsd: tradeAmount,
        tradeQuantity: target.unitPriceUsd == 0
            ? 0
            : tradeAmount / target.unitPriceUsd,
      );
    }).toList();
  }

  double _totalFeesUsd(
    List<DcaRebalanceTarget> targets,
    double minTradeAmountUsd,
    int totalPortfolioUsd,
  ) {
    return _tradePreviews(targets, minTradeAmountUsd, totalPortfolioUsd)
        .where((preview) => preview.action != DcaRebalanceTradeAction.hold)
        .fold<double>(
          0,
          (sum, preview) => sum + preview.tradeAmountUsd * 0.001,
        );
  }
}
