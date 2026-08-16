part of '../../phone/pages/backtest/bot_optimization_page.dart';

class _StartFooter extends StatelessWidget {
  const _StartFooter({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _optimizationBackground.withValues(alpha: .96),
      child: Padding(
        padding: TradeSpacingTokens.tradeBotFooterPadding.copyWith(
          top: TradeSpacingTokens.tradeBotSmallGap,
          bottom: TradeSpacingTokens.tradeBotSmallGap,
        ),
        child: VitCtaButton(
          key: BotOptimizationPage.startKey,
          onPressed: onStart,
          height: TradeSpacingTokens.tradeBotSheetActionHeight,
          leading: const Icon(Icons.play_arrow_outlined),
          child: const Text('Bắt đầu tối ưu hóa'),
        ),
      ),
    );
  }
}
