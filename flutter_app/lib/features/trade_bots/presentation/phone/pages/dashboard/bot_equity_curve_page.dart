import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/dashboard/bot_equity_curve_summary_tabs.dart';
part '../../../widgets/dashboard/bot_equity_curve_charts_cards.dart';
part '../../../widgets/dashboard/bot_equity_curve_analysis_painters.dart';

const _equityGreen = AppColors.buy;
const _equityPrimary = AppColors.primary;
const _equityRed = AppColors.sell;
const _equityAxis = AppColors.chartAxisStrong;
const double _equitySummaryMetricExtent =
    AppSpacing.buttonCompact + AppSpacing.x4;
const double _equityChartExtent = AppSpacing.buttonStandard * 3 + AppSpacing.x4;
const double _equitySharpeExtent =
    AppSpacing.buttonStandard * 2 + AppSpacing.x6;
const double _equityProgressExtent = AppSpacing.x2 + AppSpacing.x1;

class BotEquityCurvePage extends ConsumerStatefulWidget {
  const BotEquityCurvePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc130_bot_equity_curve_content');
  static Key tabKey(String id) => Key('sc130_equity_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotEquityCurvePage> createState() => _BotEquityCurvePageState();
}

class _BotEquityCurvePageState extends ConsumerState<BotEquityCurvePage> {
  String _view = 'equity';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotEquityCurveProvider);
    return VitTradeHubScaffold(
      title: 'Đường cong vốn',
      subtitle: 'Đường cong vốn và so sánh thị trường',
      semanticLabel: 'Đường cong vốn bot và so sánh với thị trường',
      semanticIdentifier: 'SC-130',
      contentKey: BotEquityCurvePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được đường cong vốn',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotEquityCurveProvider),
          ),
        ],
        data: (snapshot) => [
          VitBotSubpageHero(
            primaryLabel: 'Lợi nhuận bot',
            primaryValue:
                '+${snapshot.summary.botReturnPct.toStringAsFixed(1)}%',
            primaryColor: _equityGreen,
            secondaryLabel: 'Alpha',
            secondaryValue: '+${snapshot.summary.alphaPct.toStringAsFixed(1)}%',
            secondaryColor: _equityPrimary,
          ),
          VitTradeSection(
            title: 'Tổng quan',
            child: _SummaryRow(summary: snapshot.summary),
          ),
          VitTradeSection(
            title: 'Chế độ xem',
            child: VitTabBar(
              tabs: [
                VitTabItem(
                  key: 'equity',
                  label: 'Equity Curve',
                  widgetKey: BotEquityCurvePage.tabKey('equity'),
                ),
                VitTabItem(
                  key: 'sharpe',
                  label: 'Rolling Sharpe',
                  widgetKey: BotEquityCurvePage.tabKey('sharpe'),
                ),
                VitTabItem(
                  key: 'alpha',
                  label: 'Monthly Alpha',
                  widgetKey: BotEquityCurvePage.tabKey('alpha'),
                ),
              ],
              activeKey: _view,
              onChanged: (id) => setState(() => _view = id),
              variant: VitTabBarVariant.segment,
            ),
          ),
          if (_view == 'equity')
            VitTradeSection(
              title: 'Equity Curve vs Buy & Hold',
              child: _EquityChartCard(points: snapshot.equityPoints),
            )
          else if (_view == 'sharpe')
            VitTradeSection(
              title: 'Tỷ lệ Sharpe trượt 30 ngày',
              child: _SharpeCard(points: snapshot.equityPoints),
            )
          else
            VitTradeSection(
              title: 'Alpha hằng tháng (Bot so với thị trường)',
              child: _MonthlyAlphaCard(months: snapshot.monthlyReturns),
            ),
          VitTradeSection(
            title: 'Thống kê hiệu suất',
            child: _PerformanceCard(stats: snapshot.performanceStats),
          ),
          VitTradeSection(
            title: 'Phân tích',
            child: _AnalysisCard(items: snapshot.analysisItems),
          ),
          const VitBotRiskReviewFooter(
            title: 'Xem lại đường cong vốn',
            message:
                'Xu hướng vốn, alpha, sụt giảm vốn, bối cảnh Sharpe và bước xử lý rủi ro tiếp theo được xem lại trước khi thay đổi bot.',
            contractId: 'bot-equity-curve-review',
            statusLabel: 'Hiệu suất không được đảm bảo',
            status: VitStatusPillStatus.warning,
          ),
        ],
      ),
    );
  }
}
