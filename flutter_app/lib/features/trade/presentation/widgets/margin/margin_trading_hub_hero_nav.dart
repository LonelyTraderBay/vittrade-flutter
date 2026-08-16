part of '../../phone/pages/margin/margin_trading_hub_page.dart';

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({required this.items});

  final List<TradeMarginHubMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return _HubCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bar_chart_rounded,
                color: _hubPrimary,
                size: AppSpacing.x4,
              ),
              const SizedBox(width: _hubSpace),
              Expanded(
                child: Text(
                  'Bộ công cụ ký quỹ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _hubSpace),
          Text(
            'Điều khiển ký quỹ với hạn rủi ro, ngữ cảnh thanh lý, công bố phí và thông tin thị trường.',
            style: AppTextStyles.body.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _hubSpace),
          for (final item in items) ...[
            _MenuItem(item: item),
            if (item != items.last) const SizedBox(height: _hubSpace),
          ],
          const SizedBox(height: _hubSpace),
          const MarginHubComplianceInfoBanner(),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.item});

  final TradeMarginHubMenuItem item;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.colorHex);
    return VitCard(
      key: MarginTradingHubPage.menuKey(item.id),
      onTap: () => context.go(item.targetPath),
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: color.withValues(alpha: .28),
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            width: _hubIconTile,
            height: _hubIconTile,
            density: VitDensity.tool,
            padding: AppSpacing.zeroInsets,
            borderColor: color.withValues(alpha: .18),
            child: Icon(_menuIcon(item.id), color: color, size: AppSpacing.x5),
          ),
          const SizedBox(width: _hubSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    if (item.badge != null) ...[
                      const SizedBox(width: _hubTinySpace),
                      MarginHubStatusBadge(label: item.badge!, color: color),
                    ],
                  ],
                ),
                const SizedBox(height: _hubTinySpace),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: _hubTinySpace),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.x4,
          ),
        ],
      ),
    );
  }
}
