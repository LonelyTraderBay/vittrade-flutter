import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/dashboard/bot_performance_timeframe_view.dart';
part '../../../widgets/dashboard/bot_performance_charts_strategy.dart';
part '../../../widgets/dashboard/bot_performance_metrics_summary.dart';
part '../../../widgets/dashboard/bot_performance_painters.dart';

const _analyticsPrimary = AppColors.primary;
const _analyticsGreen = AppColors.buy;
const _analyticsAmber = AppColors.caution;
const _analyticsRed = AppColors.sell;
const _chartAxis = AppColors.chartAxisStrong;
const _chartTrack = AppColors.chartTrack;
const double _analyticsChartExtent =
    TradeSpacingTokens.tradeBotCompactChartHeight;
const double _analyticsDistributionExtent =
    TradeSpacingTokens.tradeBotCompactChartHeight;
const double _analyticsProgressExtent = AppSpacing.x2;
const double _analyticsPainterLineHeight =
    TradeSpacingTokens.tradeBotLineHeightTight;

enum _AnalyticsTimeframe { sevenDays, thirtyDays, allTime }

class BotPerformanceAnalyticsPage extends ConsumerStatefulWidget {
  const BotPerformanceAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc124_bot_performance_content');
  static const pnlChartKey = Key('sc124_bot_performance_pnl_chart');
  static const historyCtaKey = Key('sc124_bot_performance_history_cta');

  static Key timeframeKey(String id) => Key('sc124_bot_performance_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotPerformanceAnalyticsPage> createState() =>
      _BotPerformanceAnalyticsPageState();
}

class _BotPerformanceAnalyticsPageState
    extends ConsumerState<BotPerformanceAnalyticsPage>
    with SingleTickerProviderStateMixin {
  _AnalyticsTimeframe _timeframe = _AnalyticsTimeframe.sevenDays;
  late final AnimationController _revealController;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    unawaited(_revealController.forward());
  }

  @override
  void dispose() {
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotPerformanceAnalyticsProvider);
    return VitTradeHubScaffold(
      title: 'Phân tích hiệu suất',
      subtitle: 'Phân tích hiệu suất bot theo thời gian',
      semanticLabel: 'Phân tích hiệu suất bot theo khung thời gian',
      semanticIdentifier: 'SC-124',
      contentKey: BotPerformanceAnalyticsPage.contentKey,
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
            title: 'Không tải được phân tích hiệu suất',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeBotPerformanceAnalyticsProvider),
          ),
        ],
        data: (snapshot) {
          final view = _buildPerformanceView(snapshot, _timeframe);
          return [
            _AnalyticsOpening(
              view: view,
              timeframe: _timeframe,
              onTimeframeChanged: (timeframe) {
                setState(() => _timeframe = timeframe);
                _revealController.reset();
                unawaited(_revealController.forward());
              },
            ),
            VitTradeSection(
              title: 'Chỉ số chính',
              child: _KeyMetricsCard(metrics: view.metrics),
            ),
            VitTradeSection(
              title: 'Lãi/lỗ luỹ kế',
              child: _PnlChartCard(
                points: view.pnlPoints,
                reveal: _revealController,
              ),
            ),
            VitTradeSection(
              title: 'Phân bố thắng/thua',
              child: _WinLossChartCard(
                points: view.winLossPoints,
                netTrades: view.netWinLossTrades,
                onViewHistory: () {
                  context.go(AppRoutePaths.tradeBotHistory);
                },
              ),
            ),
            VitTradeSection(
              title: 'Hiệu suất theo chiến lược',
              child: _StrategyPerformanceCard(
                strategies: view.strategyPerformance,
                reveal: _revealController,
              ),
            ),
            VitTradeSection(
              title: 'Chỉ số nâng cao',
              child: _AdvancedMetricsGrid(metrics: view.metrics),
            ),
            VitTradeSection(
              title: 'Phân bố thời gian giữ lệnh',
              child: _DurationCard(distribution: view.durationDistribution),
            ),
            const VitTradeSection(title: 'Xếp hạng', child: _RatingCard()),
            const VitBotRiskReviewFooter(
              title: 'Xem lại phân tích hiệu suất Bot',
              message:
                  'Lãi/lỗ, phân bố thắng/thua, tỷ trọng chiến lược, thời lượng và xếp hạng rủi ro được xem lại trước khi thay đổi bot.',
              contractId: 'bot-performance-analytics-review',
              statusLabel: 'Phân tích có tính đến rủi ro',
            ),
          ];
        },
      ),
    );
  }
}

class _AnalyticsOpening extends StatelessWidget {
  const _AnalyticsOpening({
    required this.view,
    required this.timeframe,
    required this.onTimeframeChanged,
  });

  final TradeBotPerformanceView view;
  final _AnalyticsTimeframe timeframe;
  final ValueChanged<_AnalyticsTimeframe> onTimeframeChanged;

  @override
  Widget build(BuildContext context) {
    final showDelta = view.deltaVsPrior.abs() >= 0.05;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Lãi/lỗ',
          primaryValue: _formatSignedMoney(view.metrics.totalPnl),
          primaryColor: view.metrics.totalPnl >= 0
              ? _analyticsGreen
              : _analyticsRed,
          secondaryLabel: 'Tỷ lệ thắng',
          secondaryValue: '${view.metrics.winRate.toStringAsFixed(1)}%',
          secondaryColor: _analyticsGreen,
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _TimeframeTabs(active: timeframe, onChanged: onTimeframeChanged),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Wrap(
          spacing: TradeSpacingTokens.tradeBotInlineIconGap,
          runSpacing: TradeSpacingTokens.tradeBotTinyGap,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            VitStatusPill(
              label: view.insightLabel,
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.sm,
            ),
            if (showDelta)
              VitAccentPill(
                label:
                    '${_formatSignedMoney(view.deltaVsPrior)} so với kỳ trước',
                accentColor: view.deltaVsPrior >= 0
                    ? _analyticsGreen
                    : _analyticsRed,
              ),
          ],
        ),
      ],
    );
  }
}

String _formatSignedMoney(double value) => VitFormat.usdSigned(value);
