import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/backtest/bot_backtesting_widgets.dart';

const _backtestPrimary = AppColors.primary;

class BotBacktestingPage extends ConsumerStatefulWidget {
  const BotBacktestingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc125_bot_backtesting_content');
  static const capitalKey = Key('sc125_bot_backtesting_capital');
  static const runKey = Key('sc125_bot_backtesting_run');

  static Key strategyKey(String id) =>
      Key('sc125_bot_backtesting_strategy_$id');
  static Key pairKey(String pair) =>
      Key('sc125_bot_backtesting_pair_${pair.replaceAll('/', '_')}');
  static Key rangeKey(String id) => Key('sc125_bot_backtesting_range_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotBacktestingPage> createState() => _BotBacktestingPageState();
}

class _BotBacktestingPageState extends ConsumerState<BotBacktestingPage> {
  late final TextEditingController _capitalController;
  String _selectedStrategy = 'grid';
  String _selectedPair = 'BTC/USDT';
  String _selectedRange = '6m';

  @override
  void initState() {
    super.initState();
    _capitalController = TextEditingController(text: '1000');
  }

  @override
  void dispose() {
    _capitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotBacktestingProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    const runFooterHeight = AppSpacing.inputHeight + AppSpacing.x4;
    final scrollEndClearance =
        tradeScrollBottomInset(context, shellRenderMode: mode) +
        runFooterHeight;

    return VitTradeDetailScaffold(
      title: 'Kiểm thử chiến lược',
      subtitle: 'Mô phỏng chiến lược trên dữ liệu lịch sử',
      semanticLabel: 'Kiểm thử chiến lược bot trên dữ liệu lịch sử',
      semanticIdentifier: 'SC-125',
      contentKey: BotBacktestingPage.contentKey,
      shellRenderMode: mode,
      bottomInset: scrollEndClearance,
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
            title: 'Không tải được dữ liệu backtest',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotBacktestingProvider),
          ),
        ],
        data: (snapshot) {
          final range = snapshot.dateRanges.firstWhere(
            (item) => item.id == _selectedRange,
            orElse: () => snapshot.dateRanges.first,
          );
          return [
            VitBotSubpageHero(
              primaryLabel: 'Chiến lược',
              primaryValue: '${snapshot.strategies.length}',
              secondaryLabel: 'Cặp giao dịch',
              secondaryValue: '${snapshot.pairs.length}',
            ),
            VitTradeSection(
              title: 'Chọn chiến lược',
              child: _StrategyGrid(
                strategies: snapshot.strategies,
                selectedId: _selectedStrategy,
                onChanged: (id) => setState(() => _selectedStrategy = id),
              ),
            ),
            VitTradeSection(
              title: 'Cặp giao dịch',
              child: _PairGrid(
                pairs: snapshot.pairs,
                selectedPair: _selectedPair,
                onChanged: (pair) => setState(() => _selectedPair = pair),
              ),
            ),
            VitTradeSection(
              title: 'Khoảng thời gian',
              child: _DateRangeGrid(
                ranges: snapshot.dateRanges,
                selectedId: _selectedRange,
                onChanged: (id) => setState(() => _selectedRange = id),
              ),
            ),
            VitTradeSection(
              title: 'Vốn ban đầu',
              child: _CapitalInput(controller: _capitalController),
            ),
            VitTradeSection(
              title: 'Khoảng thời gian kiểm thử',
              child: _BacktestPeriodCard(
                strategyId: _selectedStrategy,
                pair: _selectedPair,
                range: range,
                capital: _capitalController.text,
              ),
            ),
            _RunFooter(onRun: () => _handleRun(snapshot)),
            const TradeBodyReviewSection(
              title: 'Xem lại nội dung kiểm thử chiến lược',
              message: 'Đã xem lại nội dung kiểm thử bot',
              detail:
                  'Chiến lược, cặp giao dịch, khoảng thời gian, vốn, giai đoạn mô phỏng, trạng thái đang gửi và kết quả luôn hiển thị.',
              primary:
                  'Phần xem lại giả định luôn nằm trên cùng, trước các ô điều khiển chiến lược và vốn.',
              secondary:
                  'Chiến lược, cặp giao dịch và khoảng thời gian đã chọn luôn hiển thị trước khi chạy.',
              tertiary:
                  'Kết quả kiểm thử chiến lược chỉ là mô phỏng, không đảm bảo hiệu suất thực tế.',
            ),
            const VitBotRiskReviewFooter(
              title: 'Xem lại giả định kiểm thử chiến lược',
              message:
                  'Kết quả kiểm thử chiến lược chỉ là mô phỏng. Xác nhận chiến lược, cặp giao dịch, khoảng thời gian, vốn và giới hạn rủi ro trước khi chạy.',
            ),
          ];
        },
      ),
    );
  }

  void _handleRun(TradeBotBacktestingSnapshot snapshot) {
    final capital =
        double.tryParse(_capitalController.text) ?? snapshot.defaultCapital;
    unawaited(
      ref
          .read(tradeBotAnalyticsRepositoryProvider)
          .runBotBacktest(
            TradeBotBacktestRequest(
              strategyId: _selectedStrategy,
              pair: _selectedPair,
              dateRangeId: _selectedRange,
              initialCapital: capital,
            ),
          ),
    );
  }
}
