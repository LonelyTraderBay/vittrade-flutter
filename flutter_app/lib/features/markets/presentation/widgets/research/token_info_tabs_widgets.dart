part of '../../phone/pages/research/token_info_page.dart';

String _tokenTabKey(_TokenInfoTab tab) => switch (tab) {
  _TokenInfoTab.overview => 'overview',
  _TokenInfoTab.onchain => 'onchain',
  _TokenInfoTab.project => 'project',
};

_TokenInfoTab _tokenTabFromKey(String key) => switch (key) {
  'onchain' => _TokenInfoTab.onchain,
  'project' => _TokenInfoTab.project,
  _ => _TokenInfoTab.overview,
};

class _TokenTabs extends StatelessWidget {
  const _TokenTabs({required this.active, required this.onChanged});

  final _TokenInfoTab active;
  final ValueChanged<_TokenInfoTab> onChanged;

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
                activeKey: _tokenTabKey(active),
                variant: VitTabBarVariant.underline,
                onChanged: (key) => onChanged(_tokenTabFromKey(key)),
                tabs: const [
                  VitTabItem(
                    key: 'overview',
                    label: 'Tổng quan',
                    widgetKey: TokenInfoPage.overviewTabKey,
                  ),
                  VitTabItem(
                    key: 'onchain',
                    label: 'On-chain',
                    widgetKey: TokenInfoPage.onchainTabKey,
                  ),
                  VitTabItem(
                    key: 'project',
                    label: 'Dự án',
                    widgetKey: TokenInfoPage.projectTabKey,
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
        const SizedBox(height: _tokenInfoSectionGap),
        VitSectionHeader(
          title: 'Thống kê thị trường',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppAssetColors.forSymbol(pair.baseAsset),
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _InfoCard(
          key: TokenInfoPage.marketStatsCardKey,
          rows: [
            _InfoRowData(
              icon: Icons.bar_chart_rounded,
              iconColor: _marketPrimary,
              label: 'Von hoa thi truong',
              value: _formatCompact(fundamentalsMarketCap(pair), prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.layers_rounded,
              iconColor: AppColors.accent,
              label: 'FDV',
              value: _formatCompact(
                fundamentals.fullyDilutedValuation,
                prefix: r'$',
              ),
            ),
            _InfoRowData(
              icon: Icons.show_chart_rounded,
              iconColor: AppColors.buy,
              label: 'Khối lượng 24h',
              value: _formatCompact(pair.volume24h, prefix: r'$'),
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
              label: 'ROI 1 nam',
              value: '+${fundamentals.roi1y.toStringAsFixed(2)}%',
              valueColor: AppColors.buy,
            ),
          ],
        ),
        const SizedBox(height: _tokenInfoSectionGap),
        const VitSectionHeader(
          title: 'Cung token',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: _marketPrimary,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _SupplyCard(fundamentals: fundamentals, supplyPct: supplyPct),
        const SizedBox(height: _tokenInfoSectionGap),
        const VitSectionHeader(
          title: 'Phan bo cung',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppColors.accent,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _DistributionCard(distribution: fundamentals.supplyDistribution),
        const SizedBox(height: _tokenInfoSectionGap),
        const VitSectionHeader(
          title: 'Ky luc gia',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          accentColor: AppColors.warn,
          variant: VitSectionHeaderVariant.accentBar,
        ),
        _AthAtlCards(
          fundamentals: fundamentals,
          athDropPct: athDropPct,
          atlGainPct: atlGainPct,
        ),
        const SizedBox(height: _tokenInfoSectionGap),
        _ChartLink(pairId: pair.id),
      ],
    );
  }
}

double fundamentalsMarketCap(MarketPair pair) => pair.marketCap;

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pair = snapshot.pair;
    final fundamentals = snapshot.fundamentals;
    return VitCard(
      padding: _tokenInfoHeroPadding,
      borderColor: _marketPrimary.withValues(alpha: 0.22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TokenAvatar(
                symbol: pair.baseAsset,
                color: AppAssetColors.forSymbol(pair.baseAsset),
              ),
              const SizedBox(width: _tokenInfoHeroAvatarGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fundamentals.name, style: AppTextStyles.sectionTitle),
                    const SizedBox(height: _tokenInfoHeroSubtitleGap),
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
          const SizedBox(height: _tokenInfoHeroPriceGap),
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

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: symbol,
      accentColor: color,
      size: _tokenInfoHeroAvatar,
      radius: AppRadii.cardRadius,
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
      padding: _tokenInfoInfoCardPadding,
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
          padding: _tokenInfoInfoRowPadding,
          child: Row(
            children: [
              Icon(row.icon, size: _tokenInfoInfoIcon, color: row.iconColor),
              const SizedBox(width: _tokenInfoInfoIconGap),
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
