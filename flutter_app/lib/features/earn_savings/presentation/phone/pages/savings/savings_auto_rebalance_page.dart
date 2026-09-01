import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/savings/savings_auto_rebalance_allocation.dart';
part '../../../widgets/savings/savings_auto_rebalance_drift_history.dart';
part '../../../widgets/savings/savings_auto_rebalance_strategy.dart';
part '../../../widgets/savings/savings_auto_rebalance_history.dart';
part '../../../widgets/savings/savings_auto_rebalance_settings.dart';
part '../../../widgets/savings/savings_auto_rebalance_preview.dart';
part '../../../widgets/savings/savings_auto_rebalance_painters.dart';
part '../../../widgets/savings/savings_auto_rebalance_shared.dart';

TextStyle get _captionMedium =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.medium);
TextStyle get _baseBold =>
    AppTextStyles.base.copyWith(fontWeight: AppTextStyles.bold);
TextStyle get _smBold =>
    AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold);

const double _savingsRebalanceRingExtent = 104;
const double _savingsRebalanceAssetBadge = AppSpacing.x6;
const double _savingsRebalanceIconBox = AppSpacing.inputHeight;
const double _savingsRebalanceIcon = AppSpacing.iconSm;
const double _savingsRebalanceInlineIcon = AppSpacing.iconSm;
const double _savingsRebalanceSelectedIcon = AppSpacing.iconSm;
const double _savingsRebalanceLockIcon = AppSpacing.iconSm;
const double _savingsRebalanceTrackHeight = AppSpacing.x2;
const double _savingsRebalanceDriftChartHeight = 150;
const double _savingsRebalanceCompareLabelWidth = 84;
const double _savingsRebalanceLegendDot = AppSpacing.x2;
const EdgeInsetsDirectional _savingsRebalanceCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);

class SavingsAutoRebalancePage extends ConsumerStatefulWidget {
  const SavingsAutoRebalancePage({super.key, this.shellRenderMode});

  static const allocationKey = Key('sc344_allocation');
  static const driftStatusKey = Key('sc344_drift_status');
  static const driftChartKey = Key('sc344_drift_chart');
  static const autoStatusKey = Key('sc344_auto_status');
  static const statsKey = Key('sc344_stats');
  static const previewButtonKey = Key('sc344_preview_button');
  static const previewSheetKey = Key('sc344_preview_sheet');

  static Key tabKey(String tab) => Key('sc344_tab_$tab');
  static Key strategyKey(String id) => Key('sc344_strategy_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsAutoRebalancePage> createState() =>
      _SavingsAutoRebalancePageState();
}

class _SavingsAutoRebalancePageState
    extends ConsumerState<SavingsAutoRebalancePage> {
  String? _tab;
  String? _strategyId;
  bool? _autoEnabled;
  bool _showPreview = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsAutoRebalanceSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tái cân bằng',
      semanticIdentifier: 'SC-344',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(savingsAutoRebalanceSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _tab ?? snapshot.defaultTab;
            final strategy = _activeStrategy(snapshot);
            final drift = _totalDrift(snapshot.positions, strategy);
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return Stack(
              children: [
                VitAutoHideHeaderScaffold(
                  header: VitHeader(
                    title: snapshot.title,
                    subtitle: kSavingsToolsHeaderSubtitle,
                    showBack: true,
                    onBack: () => context.go(snapshot.backRoute),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        color: AppColors.surface,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EarnSpacingTokens
                                  .earnContentHorizontalPadding,
                              child: VitTabBar(
                                variant: VitTabBarVariant.underline,
                                activeKey: activeTab,
                                onChanged: (tab) {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _tab = tab);
                                },
                                tabs: [
                                  for (final tab in snapshot.tabs)
                                    VitTabItem(key: tab, label: tab),
                                ],
                              ),
                            ),
                            const Divider(
                              color: AppColors.divider,
                              height: AppSpacing.x1,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          padding: EarnSpacingTokens.earnBottomInsetPadding(
                            bottomInset,
                          ),
                          child: VitPageContent(
                            rhythm: VitPageRhythm.standard,
                            padding: VitContentPadding.compact,
                            density: VitDensity.compact,
                            children: [
                              if (activeTab == 'Tổng quan') ...[
                                _AllocationComparisonCard(
                                  snapshot: snapshot,
                                  strategy: strategy,
                                ),
                                _DriftStatusCard(
                                  drift: drift,
                                  threshold: snapshot.settings.driftThreshold,
                                  onPreview: _openPreview,
                                ),
                                _DriftHistoryCard(
                                  points: snapshot.driftHistory,
                                ),
                                _AutoStatusCard(
                                  autoEnabled:
                                      _autoEnabled ??
                                      snapshot.settings.autoEnabled,
                                  settings: snapshot.settings,
                                  onChanged: (value) =>
                                      setState(() => _autoEnabled = value),
                                ),
                                _StatsRow(
                                  snapshot: snapshot,
                                  strategy: strategy,
                                ),
                              ] else if (activeTab == 'Chiến lược') ...[
                                _StrategyList(
                                  snapshot: snapshot,
                                  activeId: strategy.id,
                                  onChanged: (id) {
                                    unawaited(HapticFeedback.selectionClick());
                                    setState(() => _strategyId = id);
                                  },
                                ),
                                _StrategyComparison(
                                  strategies: snapshot.strategies,
                                ),
                              ] else if (activeTab == 'Lịch sử')
                                _HistoryList(history: snapshot.history)
                              else
                                _SettingsPanel(
                                  settings: snapshot.settings,
                                  autoEnabled:
                                      _autoEnabled ??
                                      snapshot.settings.autoEnabled,
                                  onAutoChanged: (value) =>
                                      setState(() => _autoEnabled = value),
                                ),
                              const VitHighRiskStatePanel(
                                density: VitDensity.compact,
                                state: VitHighRiskUiState.riskReview,
                                title: 'Xem lại tái cân bằng Savings',
                                message:
                                    'Phân bổ mục tiêu, ngưỡng lệch, xử lý vị thế khóa, số tiền giao dịch ước tính, xem trước, xác nhận và phản hồi kết quả được rà soát trước khi chạy tái cân bằng tự động.',
                                contractId: 'SC-344',
                              ),
                              const SavingsToolsYieldFooter(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showPreview)
                  Positioned.fill(
                    child: _PreviewSheet(
                      snapshot: snapshot,
                      strategy: strategy,
                      drift: drift,
                      onClose: () => setState(() => _showPreview = false),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  SavingsRebalanceStrategyDraft _activeStrategy(
    SavingsAutoRebalanceSnapshot snapshot,
  ) {
    final id = _strategyId ?? snapshot.defaultStrategyId;
    return snapshot.strategies.firstWhere(
      (item) => item.id == id,
      orElse: () => snapshot.strategies.first,
    );
  }

  void _openPreview() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _showPreview = true);
  }
}
