part of '../../phone/pages/hub/trading_bots_page.dart';

IconData _botIconData(String icon) {
  return switch (icon) {
    'calendar' => Icons.calendar_month_rounded,
    'bolt' => Icons.bolt_rounded,
    'chart' => Icons.show_chart_rounded,
    'target' => Icons.gps_fixed_rounded,
    _ => Icons.smart_toy_outlined,
  };
}

class _BotCard extends StatelessWidget {
  const _BotCard({
    required this.bot,
    required this.onToggle,
    required this.onDelete,
    required this.onSettings,
    required this.onOpen,
  });

  final TradeBot bot;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onDelete;
  final ValueChanged<String> onSettings;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final color = Color(bot.colorHex);
    final running = bot.status == TradeBotStatus.running;
    final profitColor = bot.profit >= 0 ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: TradingBotsPage.botCardKey(bot.id),
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.tradeBotCompactCardPadding,
      onTap: () => onOpen(bot.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitAccentIconBox(icon: _botIconData(bot.icon), color: color),
              const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bot.strategyName,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    VitStatusPill(
                      label: running ? 'Đang chạy' : 'Tạm dừng',
                      status: running
                          ? VitStatusPillStatus.success
                          : VitStatusPillStatus.warning,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotInlineIconGap),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatSignedMoney(bot.profit),
                    style: AppTextStyles.baseMedium.copyWith(
                      color: profitColor,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: TradeSpacingTokens.tradeBotTinyGap),
                  Text(
                    '${bot.profitPct >= 0 ? '+' : ''}${bot.profitPct.toStringAsFixed(2)}%',
                    style: AppTextStyles.caption.copyWith(
                      color: profitColor,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            '${bot.pair} · \$${_formatWholeNumber(bot.investment)} · ${bot.runtime}',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              VitAccentPill(
                label: '${bot.trades} lệnh',
                accentColor: AppColors.text2,
                size: VitStatusPillSize.sm,
              ),
              VitAccentPill(
                label:
                    'ROI ${bot.profitPct >= 0 ? '+' : ''}${bot.profitPct.toStringAsFixed(1)}%',
                accentColor: profitColor,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: TradingBotsPage.botToggleKey(bot.id),
                  onPressed: () => onToggle(bot.id),
                  density: VitDensity.tool,
                  height: TradeSpacingTokens.tradeBotFooterButtonHeight,
                  variant: running
                      ? VitCtaButtonVariant.warning
                      : VitCtaButtonVariant.success,
                  padding: TradeSpacingTokens.tradeBotActionButtonPadding(
                    false,
                  ),
                  leading: Icon(
                    running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  child: Text(running ? 'Tạm dừng' : 'Tiếp tục'),
                ),
              ),
              const SizedBox(width: TradeSpacingTokens.tradeBotInlineIconGap),
              PopupMenuButton<String>(
                key: TradingBotsPage.botSettingsKey(bot.id),
                tooltip: 'Tùy chọn bot',
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (action) {
                  if (action == 'settings') {
                    onSettings(bot.id);
                  } else if (action == 'delete') {
                    onDelete(bot.id);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings_outlined),
                      title: Text('Cài đặt'),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  PopupMenuItem(
                    key: TradingBotsPage.botDeleteKey(bot.id),
                    value: 'delete',
                    child: const ListTile(
                      leading: Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.sell,
                      ),
                      title: Text('Xóa bot'),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StrategiesTab extends StatelessWidget {
  const _StrategiesTab({
    required this.strategies,
    required this.riskFilter,
    required this.onRiskFilterChanged,
    required this.onCreate,
  });

  final List<TradeBotStrategy> strategies;
  final _StrategyRiskFilter riskFilter;
  final ValueChanged<_StrategyRiskFilter> onRiskFilterChanged;
  final ValueChanged<TradeBotStrategy> onCreate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            for (final filter in _StrategyRiskFilter.values)
              VitFilterChip(
                key: TradingBotsPage.riskFilterKey(filter.name),
                label: _riskFilterLabel(filter),
                active: riskFilter == filter,
                onTap: () => onRiskFilterChanged(filter),
                color: _riskFilterColor(filter),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        if (strategies.isEmpty)
          const VitEmptyState(
            title: 'Không có chiến lược phù hợp',
            message: 'Thử bộ lọc rủi ro khác để xem thêm chiến lược.',
            icon: Icons.storefront_outlined,
          )
        else
          for (final strategy in strategies) ...[
            _StrategyCard(
              strategy: strategy,
              onCreate: () => onCreate(strategy),
            ),
            if (strategy != strategies.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
      ],
    );
  }

  String _riskFilterLabel(_StrategyRiskFilter filter) {
    return switch (filter) {
      _StrategyRiskFilter.all => 'Tất cả',
      _StrategyRiskFilter.low => 'Thấp',
      _StrategyRiskFilter.medium => 'Trung bình',
      _StrategyRiskFilter.high => 'Cao',
    };
  }

  Color _riskFilterColor(_StrategyRiskFilter filter) {
    return switch (filter) {
      _StrategyRiskFilter.all => AppColors.primary,
      _StrategyRiskFilter.low => AppColors.buy,
      _StrategyRiskFilter.medium => AppColors.warn,
      _StrategyRiskFilter.high => AppColors.sell,
    };
  }
}
