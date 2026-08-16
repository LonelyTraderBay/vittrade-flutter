import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_formatters.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/staking/staking_analytics_summary.dart';
part '../../../widgets/staking/staking_analytics_earnings_tab.dart';
part '../../../widgets/staking/staking_analytics_apy_tab.dart';
part '../../../widgets/staking/staking_analytics_roi_tab.dart';
part '../../../widgets/staking/staking_analytics_products_tab.dart';
part '../../../widgets/staking/staking_analytics_chart_shared.dart';

const EdgeInsetsDirectional _stakingAnalyticsCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);

class StakingAnalyticsPage extends ConsumerStatefulWidget {
  const StakingAnalyticsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc359_summary_card');
  static const calculateButtonKey = Key('sc359_calculate_button');
  static const exportButtonKey = Key('sc359_export_button');
  static const tabBarKey = Key('sc359_tab_bar');
  static const earningsChartKey = Key('sc359_earnings_chart');
  static const assetGridKey = Key('sc359_asset_grid');
  static const calculatorKey = Key('sc359_calculator');
  static const apyChartKey = Key('sc359_apy_chart');
  static const roiChartKey = Key('sc359_roi_chart');
  static const productListKey = Key('sc359_product_list');

  static Key assetKey(String asset) => Key('sc359_asset_$asset');
  static Key productKey(String asset) => Key('sc359_product_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAnalyticsPage> createState() =>
      _StakingAnalyticsPageState();
}

class _StakingAnalyticsPageState extends ConsumerState<StakingAnalyticsPage> {
  String? _tab;
  bool _showCalculator = false;
  bool _compound = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingAnalyticsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Phân tích hiệu suất staking — lợi nhuận, APY và ROI theo thời gian',
      semanticIdentifier: 'SC-359',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnDashboard),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnDashboard),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(stakingAnalyticsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _tab ?? snapshot.defaultTab;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final scrollEndPadding =
                (mode.usesVisualQaFrame
                    ? SharedSpacingTokens.bottomNavVisualClearance
                    : SharedSpacingTokens.bottomNavNativeClearance) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        density: VitDensity.compact,
                        children: [
                          _SummaryCard(
                            snapshot: snapshot,
                            showCalculator: _showCalculator,
                            onCalculate: _toggleCalculator,
                            onExport: _exportReport,
                          ),
                          if (_showCalculator)
                            _CalculatorCard(
                              key: StakingAnalyticsPage.calculatorKey,
                              compound: _compound,
                              onToggleCompound: () {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _compound = !_compound);
                              },
                            ),
                          _AnalyticsTabs(
                            key: StakingAnalyticsPage.tabBarKey,
                            tabs: snapshot.tabs,
                            activeTab: activeTab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          if (activeTab == 'earnings')
                            _EarningsTab(snapshot: snapshot)
                          else if (activeTab == 'apy')
                            _ApyTab(snapshot: snapshot)
                          else if (activeTab == 'roi')
                            _RoiTab(snapshot: snapshot)
                          else
                            _ProductsTab(snapshot: snapshot),
                          const EarnDisclaimerBanner(
                            text:
                                'APY là ước tính tham khảo và có thể thay đổi. '
                                'Giá tài sản và APY có thể biến động; DeFi có rủi ro smart contract.',
                          ),
                          _FooterNote(note: snapshot.footerNote),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _toggleCalculator() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _showCalculator = !_showCalculator);
  }

  void _exportReport() {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sẽ sớm ra mắt',
        message: 'Xuất báo cáo CSV/PDF sẽ sớm ra mắt',
      ),
    );
  }
}

class _AnalyticsTabs extends StatelessWidget {
  const _AnalyticsTabs({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.onChanged,
  });

  final List<StakingAnalyticsTabDraft> tabs;
  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeTab,
      onChanged: onChanged,
      tabs: [for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label)],
    );
  }
}
