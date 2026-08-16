part of 'market_overview_page.dart';

class _FearGreedGaugePainter extends CustomPainter {
  const _FearGreedGaugePainter({required this.value});

  final int value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 4);
    final radius = size.width / 2 - 10;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final shader = const SweepGradient(
      startAngle: math.pi,
      endAngle: math.pi * 2,
      colors: [
        AppColors.sell,
        AppColors.primarySoft,
        AppAssetColors.neutralChain,
        AppColors.buy,
        AppColors.buyDark,
      ],
    ).createShader(rect);

    final basePaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = AppColors.onAccent.withValues(alpha: 0.25);
    final progressPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi, math.pi, false, basePaint);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * (value.clamp(0, 100) / 100),
      false,
      progressPaint,
    );

    // Arc runs left→top→right (π → 2π). Needle must use the same sweep.
    final needleColor = _fearGreedColor(value);
    final t = value.clamp(0, 100) / 100;
    final angle = math.pi + t * math.pi;
    final needleEnd = Offset(
      center.dx + math.cos(angle) * (radius - 12),
      center.dy + math.sin(angle) * (radius - 12),
    );
    final needlePaint = Paint()
      ..color = needleColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(center, 4, Paint()..color = needleColor);
  }

  @override
  bool shouldRepaint(covariant _FearGreedGaugePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}

class _QuickNavigation extends StatelessWidget {
  const _QuickNavigation();

  @override
  Widget build(BuildContext context) {
    const items = [
      _QuickNavItem(
        buttonKey: MarketOverviewPage.quickMoversKey,
        label: 'Biến động',
        icon: Icons.trending_up_rounded,
        color: AppColors.buy,
        route: AppRoutePaths.marketsMovers,
      ),
      _QuickNavItem(
        buttonKey: MarketOverviewPage.quickSectorsKey,
        label: 'Ngành',
        icon: Icons.layers_rounded,
        color: _sectorPurple,
        route: AppRoutePaths.marketsSectors,
      ),
      _QuickNavItem(
        buttonKey: MarketOverviewPage.quickHeatmapKey,
        label: 'Biểu đồ nhiệt',
        icon: Icons.bar_chart_rounded,
        color: _marketPrimary,
        route: AppRoutePaths.marketsHeatmap,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Expanded(child: items[i]),
          if (i < items.length - 1)
            const SizedBox(
              width: MarketsSpacingTokens.marketAnalyticsCompactGap,
            ),
        ],
      ],
    );
  }
}

class _QuickNavItem extends StatelessWidget {
  const _QuickNavItem({
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  }) : super(key: buttonKey);

  final Key buttonKey;
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      onTap: () => context.go(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VitAccentIconBox(
            icon: icon,
            color: color,
            iconSize: MarketsSpacingTokens.marketOverviewQuickNavGlyph,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoversGrid extends StatelessWidget {
  const _MoversGrid({required this.movers});

  final List<MarketMover> movers;

  @override
  Widget build(BuildContext context) {
    final gainers = movers.where((mover) => mover.change24h > 0).toList()
      ..sort((a, b) => b.change24h.compareTo(a.change24h));
    final losers = movers.where((mover) => mover.change24h < 0).toList()
      ..sort((a, b) => a.change24h.compareTo(b.change24h));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MoverListCard(
            title: 'Tăng mạnh',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            movers: gainers.take(5).toList(),
            headerKey: MarketOverviewPage.topGainersKey,
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketAnalyticsGap),
        Expanded(
          child: _MoverListCard(
            title: 'Giảm mạnh',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            movers: losers.take(5).toList(),
            headerKey: MarketOverviewPage.topLosersKey,
          ),
        ),
      ],
    );
  }
}

class _MoverListCard extends StatelessWidget {
  const _MoverListCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.movers,
    required this.headerKey,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<MarketMover> movers;
  final Key headerKey;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          Material(
            color: AppColors.transparent,
            child: InkWell(
              key: headerKey,
              onTap: () => context.go(AppRoutePaths.marketsMovers),
              borderRadius: AppRadii.inputRadius,
              child: Padding(
                padding: MarketsSpacingTokens.marketOverviewMoverHeaderPadding,
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: color,
                      size: MarketsSpacingTokens.marketOverviewMoverHeaderIcon,
                    ),
                    const SizedBox(
                      width: MarketsSpacingTokens.marketAnalyticsSmallGap,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.caption.copyWith(
                          color: color,
                          fontWeight: AppTextStyles.bold,
                          height: AppTextStyles.numericMicro.height,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.text3,
                      size: MarketsSpacingTokens.marketOverviewMoverChevron,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final mover in movers) ...[
            _QuickMoverRow(mover: mover),
            if (mover != movers.last) const SizedBox(height: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

class _QuickMoverRow extends StatelessWidget {
  const _QuickMoverRow({required this.mover});

  final MarketMover mover;

  @override
  Widget build(BuildContext context) {
    final positive = mover.change24h >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Row(
      children: [
        Material(
          color: AppAssetColors.forSymbol(mover.symbol).withValues(alpha: 0.18),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
          child: SizedBox.square(
            dimension: MarketsSpacingTokens.marketOverviewMoverAvatar,
            child: Center(
              child: Text(
                mover.symbol.substring(0, math.min(3, mover.symbol.length)),
                style: AppTextStyles.micro.copyWith(
                  color: AppAssetColors.forSymbol(mover.symbol),
                  fontWeight: AppTextStyles.bold,
                  height: AppTextStyles.numericMicro.height,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketAnalyticsSmallGap),
        Expanded(
          child: Text(
            mover.symbol,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketAnalyticsTinyGap),
        SizedBox(
          width: MarketsSpacingTokens.marketOverviewMoverPriceWidth,
          child: Text(
            formatMarketPriceAdaptive(mover.price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
        ),
        const SizedBox(width: MarketsSpacingTokens.marketAnalyticsMicroGap),
        SizedBox(
          width: MarketsSpacingTokens.marketOverviewMoverChangeWidth,
          child: VitAccentPill(
            label: _formatSignedPercent(mover.change24h),
            accentColor: color,
          ),
        ),
      ],
    );
  }
}

class _SectorPerformance extends StatelessWidget {
  const _SectorPerformance({required this.sectors});

  final List<MarketSector> sectors;

  @override
  Widget build(BuildContext context) {
    final topSectors = [...sectors]
      ..sort((a, b) => b.change24h.compareTo(a.change24h));

    return VitPageSection(
      label: 'Hiệu suất ngành',
      accentColor: _sectorPurple,
      density: VitDensity.compact,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              for (final sector in topSectors.take(5))
                _SectorRow(
                  key: Key('sc009_sector_${sector.id}'),
                  sector: sector,
                  onTap: () => context.go(
                    '${AppRoutePaths.marketsSectors}?id=${sector.id}',
                  ),
                ),
              Material(
                key: MarketOverviewPage.allSectorsKey,
                color: AppColors.transparent,
                child: InkWell(
                  onTap: () => context.go(AppRoutePaths.marketsSectors),
                  borderRadius: AppRadii.inputRadius,
                  child: Padding(
                    padding:
                        MarketsSpacingTokens.marketOverviewSectorActionPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Xem tất cả ngành',
                          style: AppTextStyles.caption.copyWith(
                            color: _marketPrimary,
                            fontWeight: AppTextStyles.bold,
                            height: AppTextStyles.numericMicro.height,
                          ),
                        ),
                        const SizedBox(
                          width: MarketsSpacingTokens.marketAnalyticsMicroGap,
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: _marketPrimary,
                          size: MarketsSpacingTokens
                              .marketOverviewMoverHeaderIcon,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectorRow extends StatelessWidget {
  const _SectorRow({super.key, required this.sector, required this.onTap});

  final MarketSector sector;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final positive = sector.change24h >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                vertical: AppSpacing.x2,
              ),
              child: Row(
                children: [
                  VitAccentIconBox(
                    icon: MarketIconTokens.icon(sector.icon),
                    color: sector.color.resolve(),
                    iconSize: MarketsSpacingTokens.marketOverviewSectorGlyph,
                  ),
                  const SizedBox(
                    width: MarketsSpacingTokens.marketAnalyticsGap,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sector.nameVi,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                            height: AppTextStyles.numericMicro.height,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          '${sector.coinCount} coins',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: AppTextStyles.numericMicro.height,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      VitAccentPill(
                        label: _formatSignedPercent(sector.change24h),
                        accentColor: color,
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        formatMarketCompact(
                          sector.totalMarketCap,
                          prefix: r'$',
                        ),
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                          height: AppTextStyles.numericMicro.height,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: MarketsSpacingTokens.marketAnalyticsSmallGap,
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: MarketsSpacingTokens.marketOverviewSectorChevron,
                  ),
                ],
              ),
            ),
            const Divider(height: AppSpacing.dividerHairline),
          ],
        ),
      ),
    );
  }
}
