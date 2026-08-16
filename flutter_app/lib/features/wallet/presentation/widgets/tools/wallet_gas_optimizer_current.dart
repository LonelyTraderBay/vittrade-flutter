part of '../../phone/pages/tools/wallet_gas_optimizer_page.dart';

class _GasTabs extends StatelessWidget {
  const _GasTabs({required this.activeTab, required this.onChanged});

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      tabs: [
        for (final tab in const [_tabCurrent, _tabTrends, _tabTips])
          VitTabItem(
            key: tab,
            label: tab,
            icon: switch (tab) {
              _tabCurrent => Icons.bolt_rounded,
              _tabTrends => Icons.show_chart_rounded,
              _ => Icons.lightbulb_outline_rounded,
            },
            widgetKey: WalletGasOptimizerPage.tabKey(tab),
          ),
      ],
      activeKey: activeTab,
      onChanged: onChanged,
      variant: VitTabBarVariant.segment,
    );
  }
}

class _CurrentGasTab extends StatelessWidget {
  const _CurrentGasTab({
    required this.snapshot,
    required this.selectedSpeed,
    required this.onSelectSpeed,
    required this.onRefresh,
  });

  final WalletGasOptimizerSnapshot snapshot;
  final String selectedSpeed;
  final ValueChanged<String> onSelectSpeed;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sectionChildren,
    );
  }

  List<Widget> get sectionChildren => [
    _GasStatusCard(snapshot: snapshot),
    VitPageSection(
      label: 'Ch\u1ECDn t\u1ED1c \u0111\u1ED9 giao d\u1ECBch',
      accentColor: _gasPrimary,
      innerGap: AppSpacing.pageRhythmStandardInnerGap,
      children: [
        for (var i = 0; i < snapshot.levels.length; i++)
          _GasLevelCard(
            level: snapshot.levels[i],
            selected: selectedSpeed == snapshot.levels[i].speed,
            onTap: () => onSelectSpeed(snapshot.levels[i].speed),
          ),
      ],
    ),
    _ComparisonCard(comparisons: snapshot.comparisons),
    _RefreshButton(onPressed: onRefresh),
  ];
}

class _GasStatusCard extends StatelessWidget {
  const _GasStatusCard({required this.snapshot});

  final WalletGasOptimizerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final vsAverage = snapshot.vsAveragePct;
    final isLow = vsAverage < -10;
    final isHigh = vsAverage > 10;
    final color = isLow ? _gasGreen : (isHigh ? _gasRed : _gasAmber);
    final title = isLow
        ? 'Gas is below 24h average'
        : (isHigh ? 'Gas is above 24h average' : 'Gas is near average');

    return VitCard(
      density: VitDensity.compact,
      borderColor: color.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bolt_rounded,
                color: color,
                size: WalletSpacingTokens.walletGasIcon,
              ),
              const SizedBox(width: WalletSpacingTokens.walletGasIconGap),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.control.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitStatusPill(
                label: snapshot.recommendedLevel.label,
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text.rich(
            TextSpan(
              text: 'Current gas is estimated ',
              children: [
                TextSpan(
                  text:
                      '${vsAverage.abs().toStringAsFixed(0)}% ${vsAverage < 0 ? 'below' : 'above'}',
                  style: AppTextStyles.control.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const TextSpan(
                  text: ' 24h average. Fees can change before confirmation.',
                ),
              ],
            ),
            style: AppTextStyles.control.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _GasLevelCard extends StatelessWidget {
  const _GasLevelCard({
    required this.level,
    required this.selected,
    required this.onTap,
  });

  final WalletGasLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(level.colorHex);
    return VitCard(
      key: WalletGasOptimizerPage.speedKey(level.speed),
      onTap: onTap,
      density: VitDensity.compact,
      borderColor: selected ? _gasPrimary : _gasBorder,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          level.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.control.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        if (selected)
                          const VitStatusPill(
                            label: 'Selected',
                            status: VitStatusPillStatus.info,
                            size: VitStatusPillSize.sm,
                          ),
                        if (level.recommended) const _RecommendedBadge(),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      level.timeEstimate,
                      style: AppTextStyles.badge.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${level.gwei} Gwei',
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '~\$${level.usd.toStringAsFixed(2)} est.',
                    style: AppTextStyles.badge.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.hairlineRadius,
            child: LinearProgressIndicator(
              minHeight: 5,
              value: level.gwei / 50,
              color: color,
              backgroundColor: AppColors.bg,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  const _RecommendedBadge();

  @override
  Widget build(BuildContext context) {
    return Text(
      'RECOMMENDED',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.badge.copyWith(
        color: _gasGreen,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({required this.comparisons});

  final List<WalletGasComparison> comparisons;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: _gasBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Transaction Type Comparison',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (var i = 0; i < comparisons.length; i++) ...[
            _ComparisonRow(comparison: comparisons[i]),
            if (i != comparisons.length - 1)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.comparison});

  final WalletGasComparison comparison;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: WalletGasOptimizerPage.comparisonKey(comparison.type),
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comparison.type,
                style: AppTextStyles.control.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${_withCommas(comparison.gas.toString())} gas',
                style: AppTextStyles.badge.copyWith(
                  color: AppColors.text3,
                  fontWeight: AppTextStyles.normal,
                ),
              ),
            ],
          ),
        ),
        Text(
          '~\$${comparison.usd.toStringAsFixed(2)}',
          style: AppTextStyles.control.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: WalletGasOptimizerPage.refreshKey,
      onPressed: onPressed,
      variant: VitCtaButtonVariant.ghost,
      height: VitDensity.compact.controlHeight,
      leading: const Icon(Icons.refresh_rounded),
      child: Text(
        'Refresh Prices',
        style: AppTextStyles.control.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
