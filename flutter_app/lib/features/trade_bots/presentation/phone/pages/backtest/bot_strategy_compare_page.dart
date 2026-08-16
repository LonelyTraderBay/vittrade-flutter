import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/backtest/bot_strategy_compare_selection.dart';
part '../../../widgets/backtest/bot_strategy_compare_metrics.dart';
part '../../../widgets/backtest/bot_strategy_compare_recommendations_common.dart';
part '../../../widgets/backtest/bot_strategy_compare_painters.dart';

const _compareGreen = AppColors.buy;
const _compareAxis = AppColors.chartAxisStrong;

class BotStrategyComparePage extends ConsumerStatefulWidget {
  const BotStrategyComparePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc126_bot_strategy_compare_content');

  static Key strategyKey(String id) => Key('sc126_bot_strategy_compare_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotStrategyComparePage> createState() =>
      _BotStrategyComparePageState();
}

class _BotStrategyComparePageState
    extends ConsumerState<BotStrategyComparePage> {
  final Set<String> _selected = {'grid', 'momentum'};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotStrategyCompareProvider);
    return VitTradeHubScaffold(
      title: 'So sánh chiến lược',
      subtitle: 'So sánh hiệu suất các chiến lược bot',
      semanticLabel: 'So sánh chiến lược bot giao dịch',
      semanticIdentifier: 'SC-126',
      contentKey: BotStrategyComparePage.contentKey,
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
            title: 'Không tải được so sánh chiến lược',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotStrategyCompareProvider),
          ),
        ],
        data: (snapshot) {
          final selectedStrategies = snapshot.strategies
              .where((strategy) => _selected.contains(strategy.id))
              .toList();
          final best = selectedStrategies.reduce(
            (best, current) =>
                current.metrics.sharpeRatio > best.metrics.sharpeRatio
                ? current
                : best,
          );
          return [
            VitBotSubpageHero(
              primaryLabel: 'Đã chọn',
              primaryValue: '${selectedStrategies.length}',
              secondaryLabel: 'Sharpe tốt nhất',
              secondaryValue: best.metrics.sharpeRatio.toStringAsFixed(2),
              secondaryColor: _compareGreen,
            ),
            VitTradeSection(
              title: 'Chọn chiến lược (2-4)',
              child: _StrategySelectionGrid(
                strategies: snapshot.strategies,
                selectedIds: _selected,
                onToggle: _toggleStrategy,
              ),
            ),
            VitTradeSection(
              title: 'Chiến lược tốt nhất',
              child: _BestStrategyCard(strategy: best),
            ),
            VitTradeSection(
              title: 'So sánh đường cong vốn',
              child: _EquityChartCard(
                points: snapshot.equityPoints,
                strategies: selectedStrategies,
              ),
            ),
            VitTradeSection(
              title: 'Biểu đồ radar hiệu suất',
              child: _RadarCard(strategies: selectedStrategies),
            ),
            VitTradeSection(
              title: 'Chỉ số chi tiết',
              child: _MetricsTable(strategies: selectedStrategies),
            ),
            VitTradeSection(
              title: 'Which Strategy to Choose?',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final recommendation in snapshot.recommendations)
                    _RecommendationCard(
                      recommendation: recommendation,
                      strategy: snapshot.strategies.firstWhere(
                        (item) => item.id == recommendation.strategyId,
                      ),
                    ),
                ],
              ),
            ),
            VitTradeSection(
              title: 'Khoảng thời gian phân tích',
              child: _AnalysisPeriodCard(text: snapshot.analysisPeriod),
            ),
            const VitBotRiskReviewFooter(
              title: 'Xem lại so sánh chiến lược',
              message:
                  'Chiến lược đã chọn, chênh lệch hiệu suất, chỉ số radar, lý do khuyến nghị và bước tiếp theo được xem lại trước khi thay đổi phân bổ vốn.',
              contractId: 'bot-strategy-compare-review',
            ),
          ];
        },
      ),
    );
  }

  void _toggleStrategy(String id) {
    setState(() {
      if (_selected.contains(id)) {
        if (_selected.length > 1) _selected.remove(id);
      } else if (_selected.length < 4) {
        _selected.add(id);
      }
    });
  }
}
