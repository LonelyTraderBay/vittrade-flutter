part of '../../phone/pages/ads/p2p_order_book_page.dart';

class _DepthChartCard extends StatelessWidget {
  const _DepthChartCard({required this.snapshot});

  final P2POrderBookSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2POrderBookPage.depthChartKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pOrderBookCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Biểu đồ độ sâu',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const _LegendDot(color: AppColors.buy, label: 'Mua'),
              const SizedBox(width: _p2pOrderBookSectionGap),
              const _LegendDot(color: AppColors.sell, label: 'Bán'),
            ],
          ),
          const SizedBox(height: _p2pOrderBookSectionGap),
          SizedBox(
            height: _p2pOrderBookDepthChartExtent,
            child: CustomPaint(painter: _DepthChartPainter(snapshot)),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: color,
          borderRadius: AppRadii.xsRadius,
          child: const SizedBox(
            width: _p2pOrderBookLegendDot,
            height: _p2pOrderBookLegendDot,
          ),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _BestPriceCards extends StatelessWidget {
  const _BestPriceCards({required this.snapshot});

  final P2POrderBookSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2POrderBookPage.bestPricesKey,
      children: [
        Expanded(
          child: _BestPriceCard(
            title: 'Bid cao nhất',
            icon: Icons.trending_up_rounded,
            entry: snapshot.bestBid,
            asset: snapshot.selectedAsset.asset,
            tone: AppColors.buy,
          ),
        ),
        const SizedBox(width: _p2pOrderBookSectionGap),
        Expanded(
          child: _BestPriceCard(
            title: 'Ask thấp nhất',
            icon: Icons.trending_down_rounded,
            entry: snapshot.bestAsk,
            asset: snapshot.selectedAsset.asset,
            tone: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _BestPriceCard extends StatelessWidget {
  const _BestPriceCard({
    required this.title,
    required this.icon,
    required this.entry,
    required this.asset,
    required this.tone,
  });

  final String title;
  final IconData icon;
  final P2POrderBookEntryDraft entry;
  final String asset;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      borderColor: tone.withValues(alpha: .28),
      padding: P2PSpacingTokens.p2pOrderBookCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: tone, size: _p2pOrderBookSmallIcon),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: tone,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pOrderBookSectionGap),
          Text(
            _formatVnd(entry.priceVnd),
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: _p2pOrderBookSectionGap),
          _MiniLine(
            label: 'Volume',
            value: '${_formatVolume(entry.volume)} $asset',
          ),
          const SizedBox(height: _p2pOrderBookSectionGap),
          _MiniLine(label: 'Lệnh', value: '${entry.orders}'),
        ],
      ),
    );
  }
}

class _MiniLine extends StatelessWidget {
  const _MiniLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderBookLists extends StatelessWidget {
  const _OrderBookLists({required this.snapshot});

  final P2POrderBookSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2POrderBookPage.orderListsKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _OrderBookSide(
            title: 'Mua (Bid)',
            entries: snapshot.bids,
            maxTotal: snapshot.maxTotal,
            tone: AppColors.buy,
          ),
        ),
        const SizedBox(width: _p2pOrderBookSectionGap),
        Expanded(
          child: _OrderBookSide(
            title: 'Bán (Ask)',
            entries: snapshot.asks,
            maxTotal: snapshot.maxTotal,
            tone: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _OrderBookSide extends StatelessWidget {
  const _OrderBookSide({
    required this.title,
    required this.entries,
    required this.maxTotal,
    required this.tone,
  });

  final String title;
  final List<P2POrderBookEntryDraft> entries;
  final double maxTotal;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pOrderBookCompactPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: tone,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final entry in entries)
            _OrderBookRow(entry: entry, maxTotal: maxTotal, tone: tone),
        ],
      ),
    );
  }
}

class _OrderBookRow extends StatelessWidget {
  const _OrderBookRow({
    required this.entry,
    required this.maxTotal,
    required this.tone,
  });

  final P2POrderBookEntryDraft entry;
  final double maxTotal;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final widthFactor = (entry.total / maxTotal).clamp(.08, 1.0).toDouble();
    return SizedBox(
      height: _p2pOrderBookOrderRowExtent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              child: Material(
                color: tone.withValues(alpha: .08),
                borderRadius: AppRadii.xsRadius,
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Padding(
            padding: P2PSpacingTokens.p2pOrderBookRowPadding,
            child: Row(
              children: [
                Text(
                  _formatBookPrice(entry.priceVnd),
                  style: AppTextStyles.micro.copyWith(
                    color: tone,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    _formatVolume(entry.volume),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
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
