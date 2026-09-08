part of 'copy_trading_list.dart';

class _CopyTraderHeader extends StatelessWidget {
  const _CopyTraderHeader({
    required this.trader,
    required this.tier,
    required this.skin,
    required this.risk,
  });

  final TradeCopyTrader trader;
  final _CopyTierStyle tier;
  final CopyTradingListSkin skin;
  final _CopyRiskStyle? risk;

  @override
  Widget build(BuildContext context) {
    final followColor = skin == CopyTradingListSkin.classic
        ? AppColors.caution
        : AppColors.warn;
    final followSize = skin == CopyTradingListSkin.classic
        ? TradeSpacingTokens.tradeBotSmallIcon
        : AppSpacing.iconSm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                trader.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            if (trader.isFollowing) ...[
              SizedBox(
                width: skin == CopyTradingListSkin.classic
                    ? AppSpacing.x1
                    : AppSpacing.x2,
              ),
              Icon(Icons.star_rounded, color: followColor, size: followSize),
            ],
          ],
        ),
        SizedBox(
          height: skin == CopyTradingListSkin.classic
              ? AppSpacing.x1
              : AppSpacing.x2,
        ),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            if (risk != null)
              VitAccentPill(
                label: 'Rủi ro: ${risk!.label}',
                accentColor: risk!.color,
              ),
            if (skin == CopyTradingListSkin.v2)
              VitAccentPill(label: tier.label, accentColor: tier.color),
            if (skin == CopyTradingListSkin.v2)
              for (final tag in trader.tags.take(2))
                VitAccentPill(label: tag, accentColor: AppColors.text2),
          ],
        ),
      ],
    );
  }
}

class _CopyAvatarBadge extends StatelessWidget {
  const _CopyAvatarBadge({
    required this.trader,
    required this.tier,
    required this.skin,
  });

  final TradeCopyTrader trader;
  final _CopyTierStyle tier;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    if (skin == CopyTradingListSkin.classic) {
      return VitAssetAvatar(
        label: trader.avatar,
        accentColor: AppColors.primary,
        size: TradeSpacingTokens.tradeToolIconTileMd,
        radius: AppRadii.xlRadius,
        border: true,
      );
    }

    return SizedBox(
      width: TradeSpacingTokens.copyTradingV2TraderAvatarStackWidth,
      height: TradeSpacingTokens.copyTradingV2TraderAvatarStackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            width: TradeSpacingTokens.copyTradingV2TraderAvatarSize,
            height: TradeSpacingTokens.copyTradingV2TraderAvatarSize,
            alignment: Alignment.center,
            radius: VitCardRadius.tight,
            variant: VitCardVariant.ghost,
            borderColor: AppColors.primary.withValues(alpha: .27),
            background: ColoredBox(
              color: AppColors.primary.withValues(alpha: .13),
            ),
            clip: true,
            child: Text(
              trader.avatar,
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Transform.translate(
              offset: const Offset(
                AppSpacing.dividerHairline,
                -AppSpacing.hairlineStroke,
              ),
              // card-tile: allow-start — fixed surface, not horizontal strip tile
              child: VitCard(
                width: TradeSpacingTokens.copyTradingV2TraderTierBadgeSize,
                height: TradeSpacingTokens.copyTradingV2TraderTierBadgeSize,
                alignment: Alignment.center,
                radius: VitCardRadius.tight,
                borderColor: tier.color,
                child: Icon(
                  tier.icon,
                  color: tier.color,
                  size: TradeSpacingTokens.copyTradingV2TraderTierBadgeIcon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyRoiBlock extends StatelessWidget {
  const _CopyRoiBlock({required this.trader, required this.skin});

  final TradeCopyTrader trader;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    final maxWidth = skin == CopyTradingListSkin.classic
        ? 116.0
        : TradeSpacingTokens.copyTradingV2RoiMaxWidth;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: skin == CopyTradingListSkin.classic
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '+${trader.totalPnlPct.toStringAsFixed(1)}%',
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.buy,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        '${trader.maxDrawdown.toStringAsFixed(1)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  )
                : Text(
                    '+${trader.totalPnlPct.toStringAsFixed(1)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
          ),
          SizedBox(
            height: skin == CopyTradingListSkin.classic
                ? AppSpacing.x1
                : AppSpacing.x2,
          ),
          Text(
            skin == CopyTradingListSkin.classic
                ? 'Tổng ROI  ·  Max DD'
                : 'Tổng ROI',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CopyProviderStats extends StatelessWidget {
  const _CopyProviderStats({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Drawdown tối đa',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '${trader.maxDrawdown.toStringAsFixed(1)}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thời gian hoạt động',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                trader.avgHoldingTime,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CopyDetailsButton extends StatelessWidget {
  const _CopyDetailsButton({
    required this.traderId,
    required this.onOpen,
    required this.keys,
    required this.skin,
  });

  final String traderId;
  final VoidCallback onOpen;
  final CopyTradingListKeys keys;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    if (skin == CopyTradingListSkin.classic) {
      return VitCtaButton(
        key: keys.detailKey(traderId),
        onPressed: onOpen,
        variant: VitCtaButtonVariant.secondary,
        density: VitDensity.tool,
        height: SharedSpacingTokens.homeHeroActionHeight,
        trailing: const Icon(Icons.chevron_right_rounded),
        child: const Text('Xem chi tiết'),
      );
    }

    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: keys.detailKey(traderId),
      onTap: onOpen,
      height: TradeSpacingTokens.copyTradingV2DetailsButtonHeight,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Xem chi tiết',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text1,
            size: TradeSpacingTokens.tradeTpslIcon,
          ),
        ],
      ),
    );
  }
}

final class _CopyTierStyle {
  const _CopyTierStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

final class _CopyRiskStyle {
  const _CopyRiskStyle({required this.label, required this.color});

  final String label;
  final Color color;
}

_CopyTierStyle _tierFor(int copiers, CopyTradingListSkin skin) {
  if (copiers > 3000) {
    return _CopyTierStyle(
      label: skin == CopyTradingListSkin.classic ? 'Pro Trader' : 'Pro',
      color: skin == CopyTradingListSkin.classic
          ? AppColors.caution
          : AppColors.warn,
      icon: skin == CopyTradingListSkin.classic
          ? Icons.star_rounded
          : Icons.star_outline_rounded,
    );
  }
  if (copiers > 1000) {
    return _CopyTierStyle(
      label: 'Verified',
      color: AppColors.buy,
      icon: skin == CopyTradingListSkin.classic
          ? Icons.check_circle_rounded
          : Icons.check_circle_outline_rounded,
    );
  }
  return _CopyTierStyle(
    label: 'Basic',
    color: AppColors.text3,
    icon: skin == CopyTradingListSkin.classic
        ? Icons.info_rounded
        : Icons.info_outline_rounded,
  );
}

_CopyRiskStyle _riskFor(TradeCopyRiskLevel risk) {
  return switch (risk) {
    TradeCopyRiskLevel.low => const _CopyRiskStyle(
      label: 'Thấp',
      color: AppColors.buy,
    ),
    TradeCopyRiskLevel.medium => const _CopyRiskStyle(
      label: 'Trung bình',
      color: AppColors.caution,
    ),
    TradeCopyRiskLevel.high => const _CopyRiskStyle(
      label: 'Cao',
      color: AppColors.sell,
    ),
  };
}
