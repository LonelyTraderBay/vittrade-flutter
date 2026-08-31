part of 'markets_pair_detail_pane.dart';

/// Port tablet của `_PriceOverview` Phone: giá hiện tại + pill biến động +
/// 3 chỉ số 24h, đóng bằng hairline divider.
class MarketsPairPriceOverviewPanel extends StatelessWidget {
  const MarketsPairPriceOverviewPanel({super.key, required this.pair});

  final MarketPair pair;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          // S7: scaffold pane đã chèn section gap — children chỉ inset ngang,
          // không mang margin dọc của trang Phone (đã từng stack 13+14=27dp).
          padding: MarketsSpacingTokens.pairPaneChildFlushPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      formatMarketPriceFixed2(pair.price),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.amountLg.copyWith(
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x4),
                  VitAccentPill(
                    label:
                        '${positive ? '▲' : '▼'} ${pair.change24h.abs().toStringAsFixed(2)}%',
                    accentColor: positive ? AppColors.buy : AppColors.sell,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  Expanded(
                    child: _PriceStat(
                      label: '24h Cao',
                      value: formatMarketPriceFixed2(pair.high24h),
                      color: AppColors.buy,
                    ),
                  ),
                  Expanded(
                    child: _PriceStat(
                      label: '24h Thấp',
                      value: formatMarketPriceFixed2(pair.low24h),
                      color: AppColors.sell,
                    ),
                  ),
                  Expanded(
                    child: _PriceStat(
                      label: 'KL 24h',
                      value: formatMarketCompact(pair.volume24h, prefix: '\$'),
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.divider,
          height: AppSpacing.dividerHairline,
        ),
      ],
    );
  }
}

class _PriceStat extends StatelessWidget {
  const _PriceStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          value,
          style: AppTextStyles.numericMicro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

/// Port tablet của `_ViewTabs` Phone — VitTabBar underline các khung nhìn
/// (Biểu đồ / Sổ lệnh / Giao dịch / Độ sâu), key theo
/// `MarketsTabletKeys.pairViewTab`. [views] thu gọn danh sách tab: desk
/// 2 cột chỉ còn Biểu đồ | Độ sâu (Sổ lệnh + Giao dịch đã lên cột phụ).
class _PairViewTabs extends StatelessWidget {
  const _PairViewTabs({required this.activeView, required this.onChanged});

  final MarketsPairView activeView;
  final ValueChanged<MarketsPairView> onChanged;

  static const List<MarketsPairView> views = [
    MarketsPairView.chart,
    MarketsPairView.orderBook,
    MarketsPairView.trades,
    MarketsPairView.depth,
  ];

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
                activeKey: marketsPairViewKey(activeView),
                variant: VitTabBarVariant.underline,
                onChanged: (key) => onChanged(marketsPairViewFromKey(key)),
                tabs: [
                  for (final view in views)
                    VitTabItem(
                      key: marketsPairViewKey(view),
                      label: switch (view) {
                        MarketsPairView.chart => 'Biểu đồ',
                        MarketsPairView.orderBook => 'Sổ lệnh',
                        MarketsPairView.trades => 'Giao dịch',
                        MarketsPairView.depth => 'Độ sâu',
                      },
                      icon: switch (view) {
                        MarketsPairView.chart => Icons.show_chart_rounded,
                        MarketsPairView.orderBook => Icons.bar_chart_rounded,
                        MarketsPairView.trades =>
                          Icons.currency_exchange_rounded,
                        MarketsPairView.depth => Icons.layers_rounded,
                      },
                      widgetKey: MarketsTabletKeys.pairViewTab(
                        marketsPairViewKey(view),
                      ),
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

/// V2-C (Bybit pattern, 2026-08-30): cột phụ là MỘT panel tabbed
/// "Sổ lệnh | Giao dịch" — thay 2 card xếp chồng chật vốn bị gạch là
/// "dính nhau"; nội dung tab nhúng dạng trần (framed: false).
class _PairBookPanel extends StatefulWidget {
  const _PairBookPanel({required this.snapshot});

  final MarketPairDetailSnapshot snapshot;

  @override
  State<_PairBookPanel> createState() => _PairBookPanelState();
}

class _PairBookPanelState extends State<_PairBookPanel> {
  bool _showBook = true;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.border,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: MarketsSpacingTokens.pairChartToolbarPadding,
            child: Row(
              children: [
                _PairBookTabButton(
                  label: 'Sổ lệnh',
                  active: _showBook,
                  widgetKey: MarketsTabletKeys.pairBookTab('book'),
                  onTap: () => setState(() => _showBook = true),
                ),
                const SizedBox(width: AppSpacing.x4),
                _PairBookTabButton(
                  label: 'Giao dịch',
                  active: !_showBook,
                  widgetKey: MarketsTabletKeys.pairBookTab('trades'),
                  onTap: () => setState(() => _showBook = false),
                ),
                const Spacer(),
                Expanded(
                  child: Text(
                    'Mid ${formatMarketPriceFixed2(widget.snapshot.depth.midPrice)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          Padding(
            padding: MarketsSpacingTokens.pairBookContentPadding,
            child: _showBook
                ? MarketsPairOrderBookPanel(
                    snapshot: widget.snapshot,
                    framed: false,
                  )
                : MarketsPairTradesPanel(
                    trades: widget.snapshot.recentTrades,
                    framed: false,
                  ),
          ),
        ],
      ),
    );
  }
}

/// Nút tab của panel cột phụ — cùng ngôn ngữ text phẳng + gạch chân mảnh
/// khi active (nhất quán toolbar chart).
class _PairBookTabButton extends StatelessWidget {
  const _PairBookTabButton({
    required this.label,
    required this.active,
    required this.onTap,
    this.widgetKey,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final Key? widgetKey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: widgetKey,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x1),
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.text1 : AppColors.text3,
                fontWeight: active ? AppTextStyles.bold : null,
              ),
            ),
          ),
          SizedBox(
            width: MarketsSpacingTokens.pairBookTabUnderline,
            child: Divider(
              height: AppSpacing.hairlineStroke * 2,
              thickness: AppSpacing.hairlineStroke * 2,
              color: active ? marketListPrimary : AppColors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dải đáy GHIM của desk (không cuộn theo nội dung phân tích): giá hiện
/// tại + pill biến động + MUA/BÁN luôn trong tầm mắt — đúng hành vi
/// terminal; render qua `MarketsPaneScaffold.footer`.
class _PairDeskFooter extends StatelessWidget {
  const _PairDeskFooter({
    required this.pair,
    required this.onBuy,
    required this.onSell,
  });

  final MarketPair pair;
  final VoidCallback onBuy;
  final VoidCallback onSell;

  @override
  Widget build(BuildContext context) {
    final positive = pair.change24h >= 0;
    return Padding(
      key: MarketsTabletKeys.pairDeskFooter,
      padding: MarketsSpacingTokens.pairDeskFooterPadding,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    formatMarketPriceFixed2(pair.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                VitAccentPill(
                  label:
                      '${positive ? '▲' : '▼'} ${pair.change24h.abs().toStringAsFixed(2)}%',
                  accentColor: positive ? AppColors.buy : AppColors.sell,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: VitCtaButton(
              key: MarketsTabletKeys.pairPaneBuyCta,
              variant: VitCtaButtonVariant.success,
              density: VitDensity.compact,
              onPressed: onBuy,
              child: const Text('MUA'),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: VitCtaButton(
              key: MarketsTabletKeys.pairPaneSellCta,
              variant: VitCtaButtonVariant.danger,
              density: VitDensity.compact,
              onPressed: onSell,
              child: const Text('BÁN'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PairRiskWarning extends StatelessWidget {
  const _PairRiskWarning();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      // S7: chỉ inset ngang — margin dọc 10/13 của Phone từng stack thành
      // 23–26dp trên section gap 13 của scaffold.
      padding: MarketsSpacingTokens.pairPaneChildFlushPadding,
      child: VitBanner(
        variant: VitBannerVariant.warning,
        icon: Icons.warning_amber_rounded,
        message: 'Giao dịch crypto có rủi ro cao.',
        detail: 'Chỉ đầu tư số tiền bạn có thể chịu mất.',
      ),
    );
  }
}

/// Port tablet của `_LinkCard` Phone — thẻ điều hướng section liên quan.
class MarketsPairLinkCard extends StatelessWidget {
  const MarketsPairLinkCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // S7: chỉ inset ngang contentPad — lề trái của link card phải thẳng
      // hàng với khối giá và hàng khung giờ (đã từng lệch vì token Phone).
      padding: MarketsSpacingTokens.pairPaneChildFlushPadding,
      child: VitCard(
        borderColor: iconColor.withValues(alpha: .12),
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: Padding(
          padding: MarketsSpacingTokens.pairLinkPadding,
          child: Row(
            children: [
              Material(
                color: iconColor.withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
                child: SizedBox(
                  width: MarketsSpacingTokens.pairLinkIconBox,
                  height: MarketsSpacingTokens.pairLinkIconBox,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: MarketsSpacingTokens.pairLinkIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: iconColor,
                size: MarketsSpacingTokens.pairLinkChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PairTradeCtas extends StatelessWidget {
  const _PairTradeCtas({
    required this.pairId,
    required this.onBuy,
    required this.onSell,
  });

  final String pairId;
  final VoidCallback onBuy;
  final VoidCallback onSell;

  @override
  Widget build(BuildContext context) {
    // S7: wrapper ngoài chỉ inset ngang; khoảng thở đáy cuộn là nội dung
    // widget (pattern _Disclaimer), không phải margin trang Phone.
    return Padding(
      padding: MarketsSpacingTokens.pairPaneChildFlushPadding,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.x4),
        child: Row(
          children: [
            Expanded(
              child: VitCtaButton(
                key: MarketsTabletKeys.pairPaneBuyCta,
                variant: VitCtaButtonVariant.success,
                density: VitDensity.compact,
                onPressed: onBuy,
                child: const Text('MUA'),
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: VitCtaButton(
                key: MarketsTabletKeys.pairPaneSellCta,
                variant: VitCtaButtonVariant.danger,
                density: VitDensity.compact,
                onPressed: onSell,
                child: const Text('BÁN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
