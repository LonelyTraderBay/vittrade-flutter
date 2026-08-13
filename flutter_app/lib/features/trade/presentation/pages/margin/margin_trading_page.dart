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
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_simple_shell.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_simple_hero.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../../widgets/margin/margin_trading_simple_form.dart';
part '../../widgets/margin/margin_trading_common.dart';
part '../../widgets/margin/margin_trading_reserved.dart';
part '../../widgets/margin/margin_trading_shared_helpers.dart';
part '../../widgets/margin/margin_trading_order_summary.dart';
part '../../widgets/margin/margin_trading_positions_orders.dart';

const _marginGreen = AppColors.buy;
const _marginAmber = AppColors.caution;
const _marginRed = AppColors.sell;

class MarginTradingPage extends ConsumerStatefulWidget {
  const MarginTradingPage({
    super.key,
    this.pairId = 'btcusdt',
    this.pairRouteVariant = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc085_margin_trading_content');
  static Key modeKey(String id) => Key('sc085_mode_$id');
  static Key tabKey(String id) => Key('sc085_tab_$id');
  static Key sideKey(String id) => Key('sc085_side_$id');
  static Key orderTypeKey(String id) => Key('sc085_order_type_$id');
  static const leverageKey = Key('sc085_leverage');
  static const maxAmountKey = Key('sc085_max_amount');
  static const submitKey = Key('sc085_submit');

  final String pairId;
  final bool pairRouteVariant;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarginTradingPage> createState() => _MarginTradingPageState();
}

class _MarginTradingPageState extends ConsumerState<MarginTradingPage> {
  final String _mode = 'cross';
  late String _side = 'long';
  final int _leverage = 5;
  String _amount = '0.00';

  Widget _buildSimpleMarginView({
    required TradeMarginTradingSnapshot snapshot,
    required TradePair pair,
    required ShellRenderMode mode,
    required TradeMarginController controller,
    required List<TradeMarginPosition> modePositions,
    required double totalPnl,
  }) {
    final daySnapshot = tradeSyntheticDaySnapshot(
      snapshot.referencePrices.lastPrice,
      pair.changePct,
    );
    return VitTradeSimpleShell(
      title: pair.symbol,
      subtitle: 'Giao dịch ký quỹ',
      semanticLabel: 'Giao dịch ký quỹ',
      semanticIdentifier: widget.pairRouteVariant ? 'SC-086' : 'SC-085',
      contentKey: MarginTradingPage.contentKey,
      shellRenderMode: mode,
      showBack: true,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      activeProductId: 'margin',
      productPair: pair,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitTradeSimpleHero(
              symbol: pair.symbol,
              priceLabel: formatTradePrice(snapshot.referencePrices.lastPrice),
              changePct: pair.changePct,
              sparklineValues: daySnapshot.sparkline,
              highLabel: daySnapshot.highLabel,
              lowLabel: daySnapshot.lowLabel,
              volumeLabel: daySnapshot.volumeLabel,
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.tight,
              density: VitDensity.tool,
              padding: AppSpacing.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng vốn',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Text(
                    formatTradeMoney(snapshot.account.totalEquity),
                    style: AppTextStyles.sectionTitle.copyWith(
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  VitMetricDeltaPill(
                    label:
                        '${totalPnl >= 0 ? '+' : ''}${formatTradeMoney(totalPnl)}',
                    tone: totalPnl >= 0
                        ? VitMetricDeltaTone.positive
                        : VitMetricDeltaTone.negative,
                  ),
                ],
              ),
            ),
          ],
        ),
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          density: VitDensity.tool,
          title: 'Rủi ro ký quỹ',
          message:
              'Đòn bẩy có thể làm bạn mất vốn nhanh hơn. Chỉ dùng số tiền bạn chấp nhận mất.',
          contractId: 'margin-trading-review',
        ),
        VitTradeSection(
          title: 'Giao dịch',
          child: _MarginSimpleForm(
            snapshot: snapshot,
            side: _side,
            leverage: _leverage,
            amount: _amount,
            onSideChanged: (side) => setState(() => _side = side),
            onMaxAmount: () => setState(() {
              _amount = controller.maxAmountFor(leverage: _leverage);
            }),
            onAmountChanged: (value) => setState(() => _amount = value),
          ),
        ),
        if (modePositions.isNotEmpty)
          VitTradeSection(
            title: 'Tài sản của bạn',
            child: _PositionsTab(positions: modePositions),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = (
      pairId: widget.pairId,
      pairRouteVariant: widget.pairRouteVariant,
    );
    final controllerAsync = ref.watch(tradeMarginControllerProvider(request));

    return controllerAsync.when(
      loading: () => const VitSkeletonList(),
      error: (error, stackTrace) => VitErrorState(
        title: 'Không tải được màn hình ký quỹ',
        message: 'Vui lòng kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: () => ref.invalidate(tradeMarginControllerProvider(request)),
      ),
      data: _buildContent,
    );
  }

  Widget _buildContent(TradeMarginController controller) {
    final snapshot = controller.state.snapshot;
    final pair = snapshot.pair;
    final modePositions = controller.positionsForMode(_mode);
    final totalPnl = controller.totalPnlForMode(_mode);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    return _buildSimpleMarginView(
      snapshot: snapshot,
      pair: pair,
      mode: mode,
      controller: controller,
      modePositions: modePositions,
      totalPnl: totalPnl,
    );
  }
}
