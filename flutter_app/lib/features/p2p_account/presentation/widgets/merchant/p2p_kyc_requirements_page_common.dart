part of '../../phone/pages/merchant/p2p_kyc_requirements_page.dart';

class _LimitsGrid extends StatelessWidget {
  const _LimitsGrid({required this.limits, required this.color});

  final P2PKycLimitsDraft limits;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: AppSpacing.x3,
      children: [
        SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: _LimitMetric(
                  label: 'Mua/ngày',
                  value: '${_formatVnd(limits.dailyBuy)} VND',
                  color: color,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _LimitMetric(
                  label: 'Bán/ngày',
                  value: '${_formatVnd(limits.dailySell)} VND',
                  color: color,
                ),
              ),
            ],
          ),
        ),
        _LimitMetric(
          label: 'Tổng/tháng',
          value: '${_formatVnd(limits.monthlyVolume)} VND',
          color: color,
        ),
      ],
    );
  }
}

class _LimitMetric extends StatelessWidget {
  const _LimitMetric({
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
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: P2PSpacingTokens.p2pKycRequirementsChecklistIconPadding,
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: color,
            size: _p2pKycChecklistIconExtent,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              height: _p2pKycReadableLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _KycSupportCard extends StatelessWidget {
  const _KycSupportCard({required this.snapshot});

  final P2PKycRequirementsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycRequirementsPage.supportKey,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pKycRequirementsCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.supportTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.supportBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _p2pKycReadableLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                VitCtaButton(
                  onPressed: () {
                    unawaited(HapticFeedback.selectionClick());
                    context.go(snapshot.supportRoute);
                  },
                  variant: VitCtaButtonVariant.ghost,
                  fullWidth: false,
                  height: AppSpacing.buttonCompact,
                  padding: P2PSpacingTokens.p2pKycInlineActionPadding,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Liên hệ Support',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppModuleAccents.p2p,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppModuleAccents.p2p,
                        size: AppSpacing.iconSm,
                      ),
                    ],
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

Color _tierColor(P2PKycTierDraft tier) {
  return switch (tier.toneKey) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    _ => AppModuleAccents.p2p,
  };
}

Color _tierHeaderBackground(P2PKycTierDraft tier) {
  return switch (tier.toneKey) {
    'success' => AppColors.buy10,
    'warning' => AppColors.warn10,
    _ => AppColors.primary12,
  };
}

VitStatusPillStatus _tierPillStatus(P2PKycTierDraft tier) {
  return switch (tier.toneKey) {
    'success' => VitStatusPillStatus.success,
    'warning' => VitStatusPillStatus.warning,
    _ => VitStatusPillStatus.info,
  };
}

IconData _tierIcon(String iconKey) {
  return switch (iconKey) {
    'badge' => Icons.verified_outlined,
    'star' => Icons.star_outline_rounded,
    _ => Icons.shield_outlined,
  };
}

IconData _requirementIcon(String iconKey) {
  return switch (iconKey) {
    'camera' => Icons.photo_camera_outlined,
    'check' => Icons.check_circle_outline_rounded,
    'video' => Icons.videocam_outlined,
    'shield' => Icons.verified_user_outlined,
    _ => Icons.description_outlined,
  };
}

String _formatVnd(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}
