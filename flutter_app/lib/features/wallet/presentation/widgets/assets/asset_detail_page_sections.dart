part of '../../phone/pages/assets/asset_detail_page.dart';

class _AssetHero extends StatelessWidget {
  const _AssetHero({required this.snapshot});

  final WalletAssetDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = Color(snapshot.colorHex);
    final positive = snapshot.change24h >= 0;

    return VitCard(
      variant: VitCardVariant.hero,
      density: VitDensity.compact,
      borderColor: color.withValues(alpha: .25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _AssetLogo(snapshot: snapshot),
              const SizedBox(width: WalletSpacingTokens.walletAssetPillGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: WalletSpacingTokens.walletAssetSmallGap,
                    ),
                    Text(
                      snapshot.symbol,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: WalletSpacingTokens.walletAssetHeroTopGap),
          Text(
            _formatUsd(snapshot.usdValue),
            style: AppTextStyles.amountMd.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: WalletSpacingTokens.walletAssetHeroValueGap),
          Row(
            children: [
              Flexible(
                child: Text(
                  '${_formatFixed(snapshot.balance, 6)} ${snapshot.symbol}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              const SizedBox(width: WalletSpacingTokens.walletAssetPillGap),
              VitMetricDeltaPill(
                label: _formatPct(snapshot.change24h),
                tone: positive
                    ? VitMetricDeltaTone.positive
                    : VitMetricDeltaTone.negative,
              ),
            ],
          ),
          const SizedBox(height: WalletSpacingTokens.walletAssetHeroTopGap),
          Wrap(
            spacing: WalletSpacingTokens.walletAssetSmallGap,
            runSpacing: WalletSpacingTokens.walletAssetSmallGap,
            children: [
              _AssetStatTile(
                label: 'Khả dụng',
                value: _formatFixed(snapshot.available, 6),
                valueColor: AppColors.text1,
              ),
              _AssetStatTile(
                label: 'Trong lệnh',
                value: _formatFixed(snapshot.inOrder, 6),
                valueColor: _assetPrimary,
              ),
              _AssetStatTile(
                label: 'Đóng băng',
                value: _formatFixed(snapshot.frozen, 2),
                valueColor: AppColors.caution,
              ),
              _AssetStatTile(
                label: 'Giá hiện tại',
                value: walletGroupThousands(
                  snapshot.currentPrice.toStringAsFixed(2),
                ),
                valueColor: AppColors.text1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssetLogo extends StatelessWidget {
  const _AssetLogo({required this.snapshot});

  final WalletAssetDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = Color(snapshot.colorHex);
    return VitAssetAvatar(
      label: snapshot.symbol,
      accentColor: color,
      size: WalletSpacingTokens.walletAssetLogoSize,
      radius: AppRadii.pillRadius,
      border: true,
    );
  }
}

class _AssetStatTile extends StatelessWidget {
  const _AssetStatTile({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      width: WalletSpacingTokens.walletHistoryAmountColumnWidth,
      height: WalletSpacingTokens.walletAssetStatHeight,
      padding: WalletSpacingTokens.walletAssetStatPillPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: WalletSpacingTokens.walletAssetSmallGap),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.micro.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetActionGrid extends StatelessWidget {
  const _AssetActionGrid({required this.actions, required this.onNavigate});

  final List<WalletAssetDetailAction> actions;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const VitEmptyState(
        title: 'Không có thao tác tài sản',
        icon: Icons.apps_rounded,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth =
            (constraints.maxWidth - AppSpacing.gridGap * (actions.length - 1)) /
            actions.length;
        final aspectRatio = tileWidth / AppSpacing.serviceTileMinHeight;
        return VitActionTileGrid(
          density: VitDensity.compact,
          crossAxisCount: actions.length,
          childAspectRatio: aspectRatio,
          itemCount: actions.length,
          itemBuilder: (context, index, density) {
            final action = actions[index];
            return _ActionTile(
              action: action,
              density: density,
              onTap: () => onNavigate(action.route),
            );
          },
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.action,
    required this.density,
    required this.onTap,
  });

  final WalletAssetDetailAction action;
  final VitServiceTileDensity density;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(action.colorHex);
    final icon = switch (action.iconKey) {
      'deposit' => Icons.south_west_rounded,
      'withdraw' => Icons.north_east_rounded,
      'transfer' => Icons.swap_vert_rounded,
      _ => Icons.repeat_rounded,
    };
    return VitServiceTile(
      key: AssetDetailPage.actionKey(action.id),
      density: density,
      icon: icon,
      label: action.label,
      accentColor: color,
      onTap: onTap,
    );
  }
}

class _PriceChartCard extends StatelessWidget {
  const _PriceChartCard({
    required this.snapshot,
    required this.activePeriod,
    required this.onPeriod,
  });

  final WalletAssetDetailSnapshot snapshot;
  final String activePeriod;
  final ValueChanged<String> onPeriod;

  @override
  Widget build(BuildContext context) {
    final color = Color(snapshot.colorHex);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitTabBar(
          tabs: [
            for (final period in const ['1W', '1M', '3M'])
              VitTabItem(
                key: period,
                label: period,
                widgetKey: AssetDetailPage.periodKey(period),
              ),
          ],
          activeKey: activePeriod,
          onChanged: onPeriod,
          variant: VitTabBarVariant.segment,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          density: VitDensity.compact,
          borderColor: AppColors.overlayStroke,
          child: SizedBox(
            height: WalletSpacingTokens.walletAssetChartHeight - AppSpacing.x6,
            child: VitSparkline(
              values: [for (final point in snapshot.chart) point.price],
              color: color,
              strokeWidth: AppSpacing.borderWidth,
            ),
          ),
        ),
      ],
    );
  }
}
