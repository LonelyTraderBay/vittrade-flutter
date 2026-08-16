part of '../../phone/pages/security/p2p_transaction_limits_page.dart';

class _TierHero extends StatelessWidget {
  const _TierHero({required this.tier});

  final P2PTransactionLimitTierDraft tier;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PTransactionLimitsPage.tierHeroKey,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.p2p,
      background: const ColoredBox(color: AppModuleAccents.p2p),
      padding: P2PSpacingTokens.p2pTransactionLimitsCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.onAccent,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tier ${tier.tier} - ${tier.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Giới hạn hiện tại của bạn',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .90),
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Material(
                type: MaterialType.transparency,
                color: AppColors.onAccent.withValues(alpha: .20),
                borderRadius: AppRadii.inputRadius,
                child: Padding(
                  padding: P2PSpacingTokens.p2pTransactionLimitsBadgePadding,
                  child: Text(
                    tier.statusLabel,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pLimitsMajorGap),
          Row(
            children: [
              Expanded(
                child: _TierMetric(
                  label: 'Mua/ngày',
                  value: '${_formatMillions(tier.dailyBuy)} VND',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TierMetric(
                  label: 'Bán/ngày',
                  value: '${_formatMillions(tier.dailySell)} VND',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TierMetric extends StatelessWidget {
  const _TierMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: AppColors.onAccent.withValues(alpha: .18),
      borderRadius: AppRadii.lgRadius,
      child: Padding(
        padding: P2PSpacingTokens.p2pTransactionLimitsInnerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.onAccent.withValues(alpha: .82),
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.onAccent,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentUsage extends StatelessWidget {
  const _CurrentUsage({required this.snapshot});

  final P2PTransactionLimitsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTransactionLimitsPage.usageKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: VitSectionHeader(
                title: 'Sử dụng hiện tại',
                bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                icon: Icons.bar_chart_rounded,
                accentColor: AppModuleAccents.p2p,
                density: VitDensity.compact,
              ),
            ),
            VitCtaButton(
              key: P2PTransactionLimitsPage.trackerLinkKey,
              onPressed: () {
                unawaited(HapticFeedback.selectionClick());
                context.go(snapshot.trackerRoute);
              },
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: P2PSpacingTokens.p2pTransactionLimitsTrackerPadding,
              trailing: const Icon(Icons.chevron_right_rounded),
              child: const Text('Xem chi tiết'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: P2PSpacingTokens.p2pTransactionLimitsCardPadding,
          child: Column(
            children: [
              for (var index = 0; index < snapshot.usageItems.length; index++)
                Padding(
                  padding:
                      P2PSpacingTokens.p2pTransactionLimitsUsageItemPadding(
                        index == snapshot.usageItems.length - 1,
                      ),
                  child: _UsageLimitRow(item: snapshot.usageItems[index]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UsageLimitRow extends StatelessWidget {
  const _UsageLimitRow({required this.item});

  final P2PTransactionLimitUsageDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.toneKey);
    final nearLimit = item.percentage >= 80;

    return Column(
      key: P2PTransactionLimitsPage.usageItemKey(item.id),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              '${_formatComma(item.current, 0)} / ${_formatComma(item.max, 0)} VND',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: ColoredBox(
            color: AppColors.surface2,
            child: SizedBox(
              height: AppSpacing.pageRhythmCompactInnerGap,
              child: FractionallySizedBox(
                widthFactor: item.percentage.clamp(0, 100) / 100,
                alignment: Alignment.centerLeft,
                child: ColoredBox(color: nearLimit ? AppColors.sell : color),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Row(
          children: [
            Expanded(
              child: Text(
                '${item.percentage.toStringAsFixed(1)}% đã dùng',
                style: AppTextStyles.micro.copyWith(
                  color: nearLimit ? AppColors.sell : color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Text(
              'Còn lại: ${_formatComma(item.remaining, 0)} VND',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _LimitDetails extends StatelessWidget {
  const _LimitDetails({required this.items});

  final List<P2PTransactionLimitDetailDraft> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTransactionLimitsPage.detailsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Chi tiết giới hạn',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          icon: Icons.tune_rounded,
          accentColor: AppModuleAccents.p2p,
          density: VitDensity.compact,
        ),
        const SizedBox(height: _p2pLimitsSectionGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: AppSpacing.zeroInsets,
          child: Column(
            children: [
              for (var index = 0; index < items.length; index++) ...[
                _LimitDetailRow(item: items[index]),
                if (index != items.length - 1)
                  const Divider(
                    height: AppSpacing.dividerHairline,
                    color: AppColors.borderSolid,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
