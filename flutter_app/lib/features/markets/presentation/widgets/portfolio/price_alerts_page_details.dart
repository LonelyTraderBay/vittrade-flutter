part of '../../phone/pages/portfolio/price_alerts_page.dart';

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.pair,
    required this.onToggle,
    required this.onDelete,
  });

  final MarketPriceAlert alert;
  final MarketPair? pair;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  bool get _isAbove => alert.condition == MarketAlertCondition.above;

  bool get _isTriggered => !alert.isActive && alert.triggeredAt != null;

  @override
  Widget build(BuildContext context) {
    final progress = (alert.currentPrice / alert.targetPrice).clamp(0.0, 1.0);
    final conditionColor = _isAbove ? AppColors.buy : AppColors.sell;
    final currentPair = pair;
    final avatarColor = currentPair != null
        ? AppAssetColors.forSymbol(currentPair.baseAsset)
        : _marketPrimary;
    final avatarLabel = alert.symbol.split('/').first;

    return VitCard(
      key: PriceAlertsPage.cardKey(alert.id),
      padding: _alertsCardPadding,
      density: VitDensity.compact,
      borderColor: _isTriggered
          ? AppColors.buy.withValues(alpha: .24)
          : AppColors.cardBorder,
      clip: _isTriggered,
      background: _isTriggered
          ? ColoredBox(color: AppColors.buy.withValues(alpha: .04))
          : null,
      child: Column(
        children: [
          Row(
            children: [
              VitAssetAvatar(
                label: avatarLabel,
                accentColor: avatarColor,
                size: _alertsAvatar,
                radius: AppRadii.pillRadius,
              ),
              const SizedBox(width: _alertsHeaderGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.symbol,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: _alertsLineHeightShort,
                      ),
                    ),
                    const SizedBox(height: _alertsTrendGap),
                    Row(
                      children: [
                        Icon(
                          _isAbove
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          color: conditionColor,
                          size: _alertsTrendIcon,
                        ),
                        const SizedBox(width: _alertsTrendGap),
                        Flexible(
                          child: Text(
                            '${_isAbove ? 'Tr\u00EAn' : 'D\u01B0\u1EDBi'} ${formatMarketPriceTiered(alert.targetPrice, prefix: r'$')}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: conditionColor,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                              height: _alertsLineHeightTight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_isTriggered)
                const VitAccentPill(
                  label: '\u0110\u00E3 k\u00EDch ho\u1EA1t',
                  accentColor: AppColors.buy,
                  size: VitStatusPillSize.md,
                  semanticStatus: VitStatusPillStatus.success,
                )
              else
                VitInlineIconAction(
                  key: PriceAlertsPage.toggleKey(alert.id),
                  icon: alert.isActive
                      ? Icons.toggle_on_rounded
                      : Icons.toggle_off_rounded,
                  tooltip: alert.isActive
                      ? 'Táº¯t cáº£nh bÃ¡o giÃ¡'
                      : 'Báº­t cáº£nh bÃ¡o giÃ¡',
                  onPressed: onToggle,
                  color: alert.isActive ? AppColors.buy : AppColors.text3,
                  size: _alertsToggleIcon,
                  padding: AppSpacing.x1,
                ),
              const SizedBox(width: _alertsActionGap),
              VitIconButton(
                key: PriceAlertsPage.deleteKey(alert.id),
                icon: Icons.delete_outline_rounded,
                tooltip: 'Xóa cảnh báo giá',
                variant: VitIconButtonVariant.danger,
                size: VitIconButtonSize.sm,
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: _alertsHeaderGap),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Gi\u00E1 hi\u1EC7n t\u1EA1i',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                              height: _alertsLineHeightTight,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Flexible(
                          child: Text(
                            formatMarketPriceTiered(
                              alert.currentPrice,
                              prefix: r'$',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                              height: _alertsLineHeightTight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: _alertsProgressGap),
                    ClipRRect(
                      borderRadius: AppRadii.pillRadius,
                      child: SizedBox(
                        height: _alertsProgressHeight,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            const ColoredBox(color: AppColors.surface3),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: ColoredBox(
                                color: _progressColor(alert, progress),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: _alertsTargetGap),
              SizedBox(
                width: _alertsTargetWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'M\u1EE5c ti\u00EAu',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: _alertsLineHeightTight,
                      ),
                    ),
                    const SizedBox(height: _alertsActionGap),
                    Text(
                      formatMarketPriceTiered(alert.targetPrice, prefix: r'$'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: conditionColor,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                        height: _alertsLineHeightTight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isTriggered) ...[
            const SizedBox(height: _alertsTriggeredGap),
            const Divider(
              height: AppSpacing.hairlineStroke,
              thickness: AppSpacing.hairlineStroke,
              color: AppColors.divider,
            ),
            const SizedBox(height: _alertsTriggeredDividerGap),
            Row(
              children: [
                const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.buy,
                  size: _alertsTriggeredIcon,
                ),
                const SizedBox(width: _alertsTriggeredIconGap),
                Expanded(
                  child: Text(
                    'K\u00EDch ho\u1EA1t l\u00FAc 11:30:00 17/2/2024',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      height: _alertsLineHeightTight,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyAlertsCard extends StatelessWidget {
  const _EmptyAlertsCard();

  @override
  Widget build(BuildContext context) {
    return const VitEmptyState(
      density: VitDensity.compact,
      icon: Icons.notifications_none_rounded,
      title: 'Ch\u01B0a c\u00F3 c\u1EA3nh b\u00E1o n\u00E0o',
    );
  }
}
