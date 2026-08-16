part of '../../phone/pages/security/p2p_transaction_limits_page.dart';

class _LimitDetailRow extends StatelessWidget {
  const _LimitDetailRow({required this.item});

  final P2PTransactionLimitDetailDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.toneKey);
    return Padding(
      key: P2PTransactionLimitsPage.detailItemKey(item.id),
      padding: P2PSpacingTokens.p2pTransactionLimitsCardPadding,
      child: Row(
        children: [
          SizedBox.square(
            dimension: P2PSpacingTokens.p2pTransactionLimitsIconBox,
            child: Material(
              type: MaterialType.transparency,
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.smRadius,
              child: Icon(
                _detailIcon(item.iconKey),
                color: color,
                size: P2PSpacingTokens.p2pTransactionLimitsDetailIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_formatComma(item.value, 0)} VND',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
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

class _UpgradeCard extends StatelessWidget {
  const _UpgradeCard({required this.snapshot});

  final P2PTransactionLimitsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final tier = snapshot.nextTier;
    return Column(
      key: P2PTransactionLimitsPage.upgradeKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Nâng cấp giới hạn',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          icon: Icons.arrow_upward_rounded,
          accentColor: AppModuleAccents.p2p,
          density: VitDensity.compact,
        ),
        const SizedBox(height: _p2pLimitsSectionGap),
        VitCard(
          radius: VitCardRadius.large,
          padding: P2PSpacingTokens.p2pTransactionLimitsCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox.square(
                    dimension: P2PSpacingTokens.p2pTransactionLimitsIconBox,
                    child: Material(
                      type: MaterialType.transparency,
                      color: AppModuleAccents.p2p.withValues(alpha: .14),
                      borderRadius: AppRadii.smRadius,
                      child: const Icon(
                        Icons.arrow_upward_rounded,
                        color: AppModuleAccents.p2p,
                        size: AppSpacing.iconMd,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nâng lên Tier ${tier.tier} - ${tier.name}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          'Tăng giới hạn lên đến ${_formatMillions(tier.monthlyTotal)} VND/tháng',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: _p2pLimitsMajorGap),
              Text(
                'Yêu cầu:',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              for (final requirement in tier.requirements) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: AppColors.text3,
                      size:
                          P2PSpacingTokens.p2pTransactionLimitsRequirementIcon,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        requirement,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
              const SizedBox(height: _p2pLimitsSectionGap),
              VitCtaButton(
                key: P2PTransactionLimitsPage.upgradeCtaKey,
                onPressed: () {
                  unawaited(HapticFeedback.selectionClick());
                  context.go(snapshot.kycRequirementsRoute);
                },
                height: AppSpacing.ctaHeight,
                variant: VitCtaButtonVariant.primary,
                trailing: const Icon(Icons.chevron_right_rounded),
                child: const Text('Bắt đầu nâng cấp'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LimitInfoNotice extends StatelessWidget {
  const _LimitInfoNotice({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTransactionLimitsPage.infoKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        P2PNoticeCard(
          icon: Icons.info_outline_rounded,
          title: 'Lưu ý về giới hạn',
          message: items.first,
          titleColor: AppModuleAccents.p2p,
          borderColor: AppModuleAccents.p2p.withValues(alpha: .28),
          padding: P2PSpacingTokens.p2pTransactionLimitsInnerPadding,
        ),
        if (items.length > 1) ...[
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            padding: P2PSpacingTokens.p2pTransactionLimitsInnerPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 1; index < items.length; index++) ...[
                  if (index > 1)
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                  P2PHelpBullet(text: items[index]),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

IconData _detailIcon(String key) {
  return switch (key) {
    'calendar' => Icons.calendar_today_outlined,
    'amount' => Icons.attach_money_rounded,
    _ => Icons.trending_up_rounded,
  };
}

Color _toneColor(String key) {
  return switch (key) {
    'buy' => AppColors.buy,
    'sell' || 'danger' => AppColors.sell,
    'accent' => AppColors.accent,
    'warning' => AppColors.warn,
    _ => AppModuleAccents.p2p,
  };
}

String _formatMillions(double value) {
  return '${_formatComma(value / 1000000, 0)}M';
}

String _formatComma(double value, int decimals) {
  final fixed = value.toStringAsFixed(decimals);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (decimals == 0) return buffer.toString();
  return '$buffer.${parts.last}';
}
