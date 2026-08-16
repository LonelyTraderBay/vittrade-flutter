part of '../../phone/pages/hub/trading_bots_page.dart';

class _BotsTabs extends StatelessWidget {
  const _BotsTabs({
    required this.active,
    required this.botCount,
    required this.onChanged,
  });

  final _TradingBotsTab active;
  final int botCount;
  final ValueChanged<_TradingBotsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: active.name,
      onChanged: (key) => onChanged(
        key == _TradingBotsTab.myBots.name
            ? _TradingBotsTab.myBots
            : _TradingBotsTab.strategies,
      ),
      tabs: [
        VitTabItem(
          key: _TradingBotsTab.myBots.name,
          label: 'Bot của tôi ($botCount)',
          icon: Icons.smart_toy_outlined,
          widgetKey: TradingBotsPage.tabKey('mybots'),
        ),
        VitTabItem(
          key: _TradingBotsTab.strategies.name,
          label: 'Chiến lược',
          icon: Icons.storefront_outlined,
          widgetKey: TradingBotsPage.tabKey('strategies'),
        ),
      ],
    );
  }
}

class _BotsWorkspace extends StatelessWidget {
  const _BotsWorkspace({
    required this.tab,
    required this.botCount,
    required this.onTabChanged,
    required this.myBotsChild,
    required this.strategiesChild,
  });

  final _TradingBotsTab tab;
  final int botCount;
  final ValueChanged<_TradingBotsTab> onTabChanged;
  final Widget myBotsChild;
  final Widget strategiesChild;

  @override
  Widget build(BuildContext context) {
    return VitTradeSection(
      title: 'Danh sách',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BotsTabs(active: tab, botCount: botCount, onChanged: onTabChanged),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          if (tab == _TradingBotsTab.myBots) myBotsChild else strategiesChild,
        ],
      ),
    );
  }
}

class _MyBotsTab extends StatelessWidget {
  const _MyBotsTab({
    required this.bots,
    required this.suggestedStrategies,
    required this.onToggle,
    required this.onDelete,
    required this.onSettings,
    required this.onOpenBot,
    required this.onAdd,
    required this.onCreateSuggested,
  });

  final List<TradeBot> bots;
  final List<TradeBotStrategy> suggestedStrategies;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final ValueChanged<String> onSettings;
  final ValueChanged<String> onOpenBot;
  final VoidCallback onAdd;
  final ValueChanged<TradeBotStrategy> onCreateSuggested;

  @override
  Widget build(BuildContext context) {
    if (bots.isEmpty) {
      return _EmptyBots(
        suggestedStrategies: suggestedStrategies,
        onAdd: onAdd,
        onCreateSuggested: onCreateSuggested,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final bot in bots) ...[
          _BotCard(
            bot: bot,
            onToggle: onToggle,
            onDelete: onDelete,
            onSettings: onSettings,
            onOpen: onOpenBot,
          ),
          if (bot != bots.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}
