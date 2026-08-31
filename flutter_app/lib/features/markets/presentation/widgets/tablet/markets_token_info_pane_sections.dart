part of 'markets_token_info_pane.dart';

// Copy chuẩn widget của part family Phone (`token_info_tabs_widgets.dart` /
// `token_info_market_widgets.dart`) — R2: widget private của Phone được
// port thành section của pane tablet. Chuỗi copy viết lại đủ dấu (chính
// sách i18n); các SizedBox token x2/x3 đổi sang rhythm token cùng giá trị
// để không sinh visual-debt mới trong file tablet.

class _TokenTabs extends StatelessWidget {
  const _TokenTabs({required this.active, required this.onChanged});

  final MarketsTokenInfoTab active;
  final ValueChanged<MarketsTokenInfoTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: MarketsSpacingTokens.marketDepthTabsHeight,
        child: Column(
          children: [
            Expanded(
              child: VitTabBar(
                activeKey: marketsTokenInfoTabKey(active),
                variant: VitTabBarVariant.underline,
                onChanged: (key) => onChanged(marketsTokenInfoTabFromKey(key)),
                tabs: [
                  VitTabItem(
                    key: 'overview',
                    label: 'Tổng quan',
                    widgetKey: MarketsTabletKeys.tokenTab('overview'),
                  ),
                  VitTabItem(
                    key: 'onchain',
                    label: 'On-chain',
                    widgetKey: MarketsTabletKeys.tokenTab('onchain'),
                  ),
                  VitTabItem(
                    key: 'project',
                    label: 'Dự án',
                    widgetKey: MarketsTabletKeys.tokenTab('project'),
                  ),
                ],
              ),
            ),
            const Divider(
              height: AppSpacing.dividerHairline,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pair = snapshot.pair;
    final fundamentals = snapshot.fundamentals;
    final supplyPct = fundamentals.maxSupply == null
        ? null
        : (fundamentals.circulatingSupply / fundamentals.maxSupply!) * 100;
    final athDropPct =
        ((pair.price - fundamentals.allTimeHigh) / fundamentals.allTimeHigh) *
        100;
    final atlGainPct =
        ((pair.price - fundamentals.allTimeLow) / fundamentals.allTimeLow) *
        100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.x4),
        VitSectionHeader(
          title: 'Thống kê thị trường',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppAssetColors.forSymbol(pair.baseAsset),
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _InfoCard(
          key: MarketsTabletKeys.tokenStatsCard,
          rows: [
            _InfoRowData(
              icon: Icons.bar_chart_rounded,
              iconColor: marketListPrimary,
              label: 'Vốn hóa thị trường',
              value: formatMarketCompact(pair.marketCap, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.layers_rounded,
              iconColor: AppColors.accent,
              label: 'FDV',
              value: formatMarketCompact(
                fundamentals.fullyDilutedValuation,
                prefix: r'$',
              ),
            ),
            _InfoRowData(
              icon: Icons.show_chart_rounded,
              iconColor: AppColors.buy,
              label: 'Khối lượng 24h',
              value: formatMarketCompact(pair.volume24h, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.warn,
              label: 'Vol/MCap',
              value:
                  '${((pair.volume24h / pair.marketCap) * 100).toStringAsFixed(2)}%',
            ),
            _InfoRowData(
              icon: Icons.arrow_outward_rounded,
              iconColor: AppColors.buy,
              label: 'ROI 1 năm',
              value: '+${fundamentals.roi1y.toStringAsFixed(2)}%',
              valueColor: AppColors.buy,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        const VitSectionHeader(
          title: 'Cung token',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppColors.primary,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _SupplyCard(fundamentals: fundamentals, supplyPct: supplyPct),
        const SizedBox(height: AppSpacing.x4),
        const VitSectionHeader(
          title: 'Phân bổ cung',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppColors.accent,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _DistributionCard(distribution: fundamentals.supplyDistribution),
        const SizedBox(height: AppSpacing.x4),
        const VitSectionHeader(
          title: 'Kỷ lục giá',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppColors.warn,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _AthAtlCards(
          fundamentals: fundamentals,
          athDropPct: athDropPct,
          atlGainPct: atlGainPct,
        ),
        const SizedBox(height: AppSpacing.x4),
        _ChartLink(pairId: pair.id),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pair = snapshot.pair;
    final fundamentals = snapshot.fundamentals;
    return VitCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      borderColor: AppColors.primary.withValues(alpha: 0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VitAssetAvatar(
                label: pair.baseAsset,
                accentColor: AppAssetColors.forSymbol(pair.baseAsset),
                size: AppSpacing.buttonCompact,
                radius: AppRadii.cardRadius,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fundamentals.name, style: AppTextStyles.sectionTitle),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      fundamentals.consensus,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  formatMarketPriceFixed2(pair.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.amountMd.copyWith(
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              VitAccentPill(
                label:
                    '${pair.change24h >= 0 ? '+' : ''}${pair.change24h.toStringAsFixed(2)}%',
                accentColor: pair.change24h >= 0
                    ? AppColors.buy
                    : AppColors.sell,
                semanticStatus: pair.change24h >= 0
                    ? VitStatusPillStatus.success
                    : VitStatusPillStatus.error,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRowData {
  const _InfoRowData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({super.key, required this.rows});

  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x3),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i += 1)
            _InfoRow(row: rows[i], showDivider: i != rows.length - 1),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.row, required this.showDivider});

  final _InfoRowData row;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: [
              Icon(row.icon, size: AppSpacing.iconSm, color: row.iconColor),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Text(
                  row.label,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                row.value,
                textAlign: TextAlign.right,
                style: AppTextStyles.caption.copyWith(
                  color: row.valueColor ?? AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: AppSpacing.dividerHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class _SupplyCard extends StatelessWidget {
  const _SupplyCard({required this.fundamentals, required this.supplyPct});

  final TokenFundamentalsDraft fundamentals;
  final double? supplyPct;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        children: [
          _MetricLine(
            label: 'Lưu hành',
            value:
                '${formatMarketCompact(fundamentals.circulatingSupply)} ${fundamentals.symbol}',
          ),
          if (supplyPct != null) ...[
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: AppRadii.swatchRadius,
                    child: LinearProgressIndicator(
                      minHeight: AppSpacing.x1,
                      value: (supplyPct! / 100).clamp(0, 1).toDouble(),
                      backgroundColor: AppColors.surface3,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primarySoft,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Text(
                  '${supplyPct!.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.x4),
          _MetricLine(
            label: 'Tổng cung',
            value:
                '${formatMarketCompact(fundamentals.totalSupply)} ${fundamentals.symbol}',
            muted: true,
          ),
          _MetricLine(
            label: 'Cung tối đa',
            value:
                '${formatMarketCompact(fundamentals.maxSupply ?? 0)} ${fundamentals.symbol}',
            muted: true,
          ),
          _MetricLine(
            label: 'Tỷ lệ lạm phát',
            value: '+${fundamentals.inflationRate.toStringAsFixed(2)}%',
            valueColor: AppColors.warn,
          ),
        ],
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.label,
    required this.value,
    this.muted = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool muted;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x1),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor ?? (muted ? AppColors.text2 : AppColors.text1),
              fontWeight: muted ? AppTextStyles.medium : AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.distribution});

  final List<SupplyDistributionDraft> distribution;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Row(
        children: [
          CustomPaint(
            size: const Size.square(70),
            painter: _DonutPainter(distribution),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              children: [
                for (final item in distribution)
                  Padding(
                    padding: const EdgeInsetsDirectional.symmetric(
                      vertical: AppSpacing.x1,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: AppSpacing.pageRhythmCompactInnerGap,
                          color: item.color.resolve(),
                        ),
                        const SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                        Text(
                          '${item.percentage.toStringAsFixed(1)}%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
