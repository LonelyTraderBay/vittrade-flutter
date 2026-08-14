part of 'home_page.dart';

class _HomeDiscoverySection extends StatelessWidget {
  const _HomeDiscoverySection({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Dự đoán & Thách đấu',
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
        ),
        VitDiscoveryActionCard(
          title: 'Thị trường dự đoán',
          badgeLabel: 'Ví / PnL',
          subtitle: 'Thị trường xác suất, vị thế và danh mục',
          actionLabel: 'Khám phá thị trường',
          icon: Icons.adjust_rounded,
          accentColor: AppColors.accent,
          borderColor: AppColors.accent20,
          variant: VitDiscoveryActionCardVariant.compact,
          background: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.accent15, AppColors.primary08],
          ),
          onTap: () => onNavigate('/markets/predictions'),
        ),
        const SizedBox(height: SharedSpacingTokens.homeSectionInnerGap),
        VitDiscoveryActionCard(
          title: 'Arena',
          badgeLabel: 'Chỉ điểm Arena',
          subtitle: 'Tạo chế độ chơi, mở phòng, dùng điểm Arena',
          actionLabel: 'Vào Arena',
          icon: Icons.sports_esports_outlined,
          accentColor: AppColors.riskWarning,
          borderColor: AppColors.warningBorder,
          badgeStatus: VitStatusPillStatus.warning,
          variant: VitDiscoveryActionCardVariant.compact,
          background: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.riskWarning15, AppColors.riskWarning10],
          ),
          onTap: () => onNavigate('/arena'),
        ),
        const SizedBox(height: SharedSpacingTokens.homeSectionInnerGap),
        const VitRiskDisclaimerNote(
          message:
              'Dự đoán dùng vị thế thật. Arena chỉ dùng điểm (không phải tiền thật).',
          semanticsLabel:
              'Lưu ý rủi ro: Dự đoán dùng vị thế thật. Arena chỉ dùng điểm '
              '(không phải tiền thật).',
        ),
      ],
    );
  }
}

class _MarketSection extends StatelessWidget {
  const _MarketSection({
    required this.activeTab,
    required this.pairs,
    required this.onTabChanged,
    required this.onNavigate,
  });

  final String activeTab;
  final List<HomeCryptoPair> pairs;
  final ValueChanged<String> onTabChanged;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: 'Thị trường',
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
          actionLabel: 'Xem tất cả',
          actionSemanticLabel: 'Xem tất cả thị trường',
          onAction: () => onNavigate('/markets'),
        ),
        VitTabBar(
          activeKey: activeTab,
          onChanged: onTabChanged,
          tabs: const [
            VitTabItem(
              key: 'hot',
              label: 'Hot',
              icon: Icons.local_fire_department_rounded,
            ),
            VitTabItem(
              key: 'gainers',
              label: 'Tăng',
              icon: Icons.trending_up_rounded,
            ),
            VitTabItem(
              key: 'losers',
              label: 'Giảm',
              icon: Icons.trending_down_rounded,
            ),
            VitTabItem(key: 'new', label: 'Mới', icon: Icons.fiber_new_rounded),
          ],
        ),
        const SizedBox(height: SharedSpacingTokens.homeSectionInnerGap),
        if (pairs.isEmpty)
          const VitEmptyState(
            title: 'Chưa có cặp nào trong mục này',
            message: 'Thử chọn tab khác để xem thêm thị trường.',
            icon: Icons.candlestick_chart_rounded,
          )
        else
          VitCard(
            clip: true,
            child: Column(
              children: [
                for (var i = 0; i < pairs.length; i++) ...[
                  _MarketRow(
                    pair: pairs[i],
                    showSparkline: true,
                    onTap: () => onNavigate('/pair/${pairs[i].id}'),
                  ),
                  if (i < pairs.length - 1)
                    const Divider(
                      height: AppSpacing.dividerHairline,
                      thickness: AppSpacing.dividerHairline,
                      color: AppColors.divider,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _MarketRow extends StatelessWidget {
  const _MarketRow({
    required this.pair,
    required this.showSparkline,
    required this.onTap,
  });

  final HomeCryptoPair pair;
  final bool showSparkline;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final trend = pair.change24h >= 0
        ? VitTrendDirection.positive
        : VitTrendDirection.negative;

    return VitMarketPairRow(
      leading: VitAssetAvatar(
        label: pair.baseAsset,
        accentColor: AppAssetColors.forSymbol(pair.baseAsset),
      ),
      title: pair.symbol,
      subtitle: 'Vol \$${_formatBillions(pair.volume24h)}B',
      price: formatUsd(pair.price),
      changeLabel: formatPct(pair.change24h),
      trend: trend,
      sparkline: pair.sparkline,
      showSparkline: showSparkline,
      onTap: onTap,
    );
  }
}
