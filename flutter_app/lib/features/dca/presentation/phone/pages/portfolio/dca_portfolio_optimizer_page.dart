import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'dca_portfolio_optimizer_page_common.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_header_drift.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_comparison_hero.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_tabs.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_frontier.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_tab_panels.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_floating_actions.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_common_widgets.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_allocation_widgets.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_stat_widgets.dart';
part '../../../widgets/portfolio/dca_portfolio_optimizer_frontier_painter.dart';

enum _OptimizerTab { frontier, correlation, backtest, risk }

const double _dcaPortfolioBodyLineHeight = 1.35;
const double _dcaPortfolioTightLineHeight = 1.0;
const double _dcaPortfolioFrontierChartHeight = 180;
const double _dcaPortfolioFrontierChipListHeight = AppSpacing.inputHeight;
const double _dcaPortfolioFrontierChipWidth =
    AppSpacing.buttonStandard + AppSpacing.x7;
const double _dcaPortfolioBacktestChartHeight = 180;
const double _dcaPortfolioDividerWidth = AppSpacing.hairlineStroke;
const int _dcaPortfolioRiskGridColumns = 2;
const double _dcaPortfolioRiskGridAspect = 1.35;
const double _dcaPortfolioAlertIconExtent = AppSpacing.buttonCompact;
const double _dcaPortfolioHeroIconExtent = AppSpacing.inputHeight;
const EdgeInsetsDirectional _dcaPortfolioCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _dcaPortfolioHeroPadding =
    EdgeInsetsDirectional.all(AppSpacing.x4);

class DCAPortfolioOptimizerPage extends ConsumerStatefulWidget {
  const DCAPortfolioOptimizerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc174_portfolio_optimizer_content');
  static const applyKey = Key('sc174_apply_allocation');
  static const driftSettingsKey = Key('sc174_drift_settings');

  static Key tabKey(String tabName) => Key('sc174_tab_$tabName');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAPortfolioOptimizerPage> createState() =>
      _DCAPortfolioOptimizerPageState();
}

class _DCAPortfolioOptimizerPageState
    extends ConsumerState<DCAPortfolioOptimizerPage> {
  _OptimizerTab _activeTab = _OptimizerTab.frontier;
  bool _showSuggestions = true;
  bool _showCompareHint = false;
  bool _showDriftBanner = true;

  @override
  Widget build(BuildContext context) {
    final dcaPortfolioOptimizerAsync = ref.watch(dcaPortfolioOptimizerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'Tối ưu hóa phân bổ danh mục đầu tư DCA',
      semanticIdentifier: 'SC-174',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Portfolio Optimizer',
          subtitle: 'Đầu tư có kỷ luật · tối ưu danh mục',
          showBack: true,
          onBack: _close,
          actions: [
            VitHeaderActionItem(
              type: VitHeaderActionType.share,
              onPressed: _showExportNotice,
            ),
          ],
        ),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: VitInsetScrollView(
            key: DCAPortfolioOptimizerPage.contentKey,
            physics: const ClampingScrollPhysics(),
            bottomInset: scrollEndPadding,
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.compact,
              density: VitDensity.compact,
              children: [
                ...dcaPortfolioOptimizerAsync.when(
                  loading: () => const [VitSkeletonList()],
                  error: (error, stackTrace) => [
                    VitErrorState(
                      title: 'Không tải được tối ưu danh mục',
                      message: 'Thử lại sau hoặc quay lại màn DCA.',
                      actionLabel: 'Thử lại',
                      onAction: () =>
                          ref.invalidate(dcaPortfolioOptimizerProvider),
                    ),
                  ],
                  data: (snapshot) => [
                    if (_showDriftBanner)
                      _DriftBanner(
                        snapshot: snapshot,
                        onDismiss: () {
                          setState(() => _showDriftBanner = false);
                        },
                        onSettings: _showDriftSettings,
                      ),
                    _ComparisonHero(snapshot: snapshot),
                    _OptimizerTabs(
                      activeTab: _activeTab,
                      onChanged: (tab) {
                        setState(() => _activeTab = tab);
                      },
                    ),
                    _TabContent(
                      activeTab: _activeTab,
                      snapshot: snapshot,
                      showSuggestions: _showSuggestions,
                      showCompareHint: _showCompareHint,
                      onToggleSuggestions: () {
                        setState(() => _showSuggestions = !_showSuggestions);
                      },
                      onCompare: () {
                        setState(() => _showCompareHint = true);
                      },
                    ),
                    const VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      title: 'Xem lại phân bổ đề xuất',
                      message:
                          'Tối ưu danh mục chỉ mang tính tham khảo; áp dụng phân bổ mới cần xem lại drift, phí và xác nhận trước khi tái cân bằng.',
                      contractId: 'SC-174',
                      density: VitDensity.compact,
                    ),
                    _OptimizerApplyAction(
                      snapshot: snapshot,
                      onApply: () =>
                          context.go(AppRoutePaths.dcaRebalanceConfig),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }

  void _showExportNotice() {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Chia sẻ báo cáo danh mục sẽ sớm ra mắt.',
      ),
    );
  }

  void _showDriftSettings() {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Ngưỡng tái cân bằng',
        message: 'Ngưỡng tái cân bằng: 5%.',
      ),
    );
  }
}
