part of '../../phone/pages/hub/active_copies_page.dart';

class _ActiveCopyCard extends StatelessWidget {
  const _ActiveCopyCard({
    super.key,
    required this.copy,
    required this.expanded,
    required this.onToggle,
    required this.onViewDetails,
    required this.onConfigure,
    required this.onStop,
  });

  final TradeActiveCopy copy;
  final bool expanded;
  final VoidCallback onToggle;
  final VoidCallback onViewDetails;
  final VoidCallback onConfigure;
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(copy.status);
    final positive = copy.pnl >= 0;
    final pnlColor = positive ? AppColors.buy : AppColors.sell;

    return Padding(
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProviderAvatar(copy: copy),
              const SizedBox(width: AppSpacing.cardGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            copy.providerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (copy.providerVerified) ...[
                          const SizedBox(width: AppSpacing.x2),
                          const Icon(
                            Icons.check_circle_rounded,
                            color: _copyPrimary,
                            size: TradeSpacingTokens.activeCopiesVerifiedIcon,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        _StatusPill(style: status),
                        if (copy.coolingOffUntil != null) ...[
                          const SizedBox(
                            width: WalletSpacingTokens.walletAssetSmallGap,
                          ),
                          Flexible(
                            child: Text(
                              'đến ${copy.coolingOffUntil}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              VitInlineIconAction(
                key: ActiveCopiesPage.expandKey(copy.id),
                icon: expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                tooltip: expanded
                    ? 'Collapse copy details'
                    : 'Expand copy details',
                onPressed: onToggle,
                color: AppColors.text3,
                size: TradeSpacingTokens.activeCopiesExpandIcon,
                padding: TradeSpacingTokens.activeCopiesExpandPadding,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _MiniValueCard(
                  label: 'Vốn',
                  value: _formatUsd(copy.capital),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniValueCard(
                  label: 'Hiện tại',
                  value: _formatUsd(copy.currentValue),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniValueCard(
                  label: 'P/L',
                  value: _formatSignedUsd(copy.pnl),
                  valueColor: pnlColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _ReturnBar(value: copy.pnlPct),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            _ExpandedCopyDetails(
              copy: copy,
              onViewDetails: onViewDetails,
              onConfigure: onConfigure,
              onStop: onStop,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.copy});

  final TradeActiveCopy copy;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: copy.providerAvatar,
      accentColor: _copyPrimary,
      size: WalletSpacingTokens.walletTokenHeroIcon,
      radius: AppRadii.avatarRadius,
      border: true,
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.style});

  final _StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: style.label, accentColor: style.color);
  }
}

class _MiniValueCard extends StatelessWidget {
  const _MiniValueCard({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReturnBar extends StatelessWidget {
  const _ReturnBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    final widthFactor = (value.abs() * .05).clamp(.0, 1.0).toDouble();

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Return',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: AppSpacing.x2),
              const Expanded(child: SizedBox.shrink()),
              Text(
                _formatPercent(value),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: widthFactor,
              backgroundColor: AppColors.borderSolid,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
