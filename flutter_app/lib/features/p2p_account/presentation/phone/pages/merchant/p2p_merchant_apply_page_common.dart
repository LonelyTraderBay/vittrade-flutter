part of 'p2p_merchant_apply_page.dart';

class _StepIntro extends StatelessWidget {
  const _StepIntro({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      density: VitDensity.compact,
      children: [
        VitModuleSectionHeader(
          title: title,
          accentColor: AppModuleAccents.p2p,
          density: VitDensity.compact,
        ),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _MultilineInput extends StatelessWidget {
  const _MultilineInput({
    required this.controller,
    required this.fieldKey,
    required this.label,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final Key fieldKey;
  final String label;
  final String hintText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Material(
          color: AppColors.surface2,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.inputRadius,
            side: BorderSide(
              color: AppColors.borderSolid,
              width: AppSpacing.borderWidth,
            ),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSpacing.buttonHero),
            child: Padding(
              padding: P2PSpacingTokens.p2pMerchantApplyInputPadding,
              child: TextField(
                key: fieldKey,
                controller: controller,
                minLines: 3,
                maxLines: 3,
                cursorColor: AppColors.primary,
                style: AppTextStyles.body,
                onChanged: (_) => onChanged(),
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: AppTextStyles.body.copyWith(
                    color: AppColors.text3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AgreementCard extends StatelessWidget {
  const _AgreementCard({required this.accepted, required this.onTap});

  final bool accepted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PMerchantApplyPage.agreementKey,
      variant: VitCardVariant.inner,
      borderColor: accepted ? AppColors.buy20 : AppColors.borderSolid,
      padding: VitDensity.compact.cardPadding,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: P2PSpacingTokens.p2pMerchantApplyCheckboxMargin,
            child: SizedBox.square(
              dimension: AppSpacing.iconMd,
              child: Material(
                color: accepted ? AppColors.buy : AppColors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                  side: BorderSide(
                    color: accepted ? AppColors.buy : AppColors.text3,
                    width: AppSpacing.borderWidth,
                  ),
                ),
                child: accepted
                    ? const Icon(
                        Icons.check_rounded,
                        color: AppColors.onAccent,
                        size: AppSpacing.iconSm,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Tôi xác nhận thông tin là chính xác, đồng ý với Điều khoản Merchant và Chính sách P2P của VitTrade. Tôi hiểu rằng vi phạm có thể dẫn đến thu hồi tư cách Merchant.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: _p2pMerchantApplyReadableLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.data});

  final _MetricData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pMerchantApplyRowPadding,
      child: Row(
        children: [
          _IconBadge(icon: data.icon, color: data.color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              data.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            data.value,
            style: AppTextStyles.caption.copyWith(
              color: data.color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryData {
  const _SummaryData({required this.label, required this.value});

  final String label;
  final String value;
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.data});

  final _SummaryData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pMerchantApplyRowPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              data.value,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    this.large = false,
  });

  final IconData icon;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large
        ? P2PSpacingTokens.p2pMerchantApplyLargeIconBadgeSize
        : P2PSpacingTokens.p2pMerchantApplyIconBadgeSize;
    return SizedBox.square(
      dimension: size,
      child: Material(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        child: Icon(
          icon,
          color: color,
          size: large ? AppSpacing.iconMd : AppSpacing.iconSm,
        ),
      ),
    );
  }
}

class _CircleStatusIcon extends StatelessWidget {
  const _CircleStatusIcon({required this.met});

  final bool met;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: P2PSpacingTokens.p2pMerchantApplyStatusIconSize,
      child: Material(
        color: (met ? AppColors.buy : AppColors.sell).withValues(alpha: .12),
        shape: const CircleBorder(),
        child: Icon(
          met ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: met ? AppColors.buy : AppColors.sell,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }
}

class _TinyStatusDot extends StatelessWidget {
  const _TinyStatusDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.iconMd,
      child: Material(
        color: active ? AppColors.buy : AppColors.surface2,
        shape: const CircleBorder(),
        child: Icon(
          active ? Icons.check_rounded : Icons.radio_button_checked_rounded,
          color: active ? AppColors.onAccent : AppColors.text3,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }
}

Color _toneColor(String key) {
  return switch (key) {
    'buy' => AppColors.buy,
    'accent' => AppColors.accent,
    'primary' => AppModuleAccents.p2p,
    _ => AppColors.warn,
  };
}

IconData _iconFor(String key) {
  return switch (key) {
    'award' => Icons.workspace_premium_outlined,
    'camera' => Icons.photo_camera_outlined,
    'clock' => Icons.access_time_rounded,
    'file' => Icons.description_outlined,
    'shield' => Icons.shield_outlined,
    'star' => Icons.star_border_rounded,
    'trend' => Icons.trending_up_rounded,
    'users' => Icons.groups_outlined,
    'verified' => Icons.verified_outlined,
    'warning' => Icons.warning_amber_rounded,
    'zap' => Icons.bolt_rounded,
    _ => Icons.radio_button_checked_rounded,
  };
}
