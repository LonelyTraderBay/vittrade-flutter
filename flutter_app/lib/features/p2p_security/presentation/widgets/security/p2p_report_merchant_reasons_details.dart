part of '../../phone/pages/security/p2p_report_merchant_page.dart';

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  final P2PReportReasonDraft reason;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = _toneColor(reason.tone);
    return VitCard(
      key: P2PReportMerchantPage.reasonKey(reason.id),
      variant: VitCardVariant.ghost,
      borderColor: selected
          ? tone.withValues(alpha: 0.36)
          : AppColors.borderSolid,
      background: ColoredBox(
        color: selected ? tone.withValues(alpha: 0.10) : AppColors.surface2,
      ),
      padding: P2PSpacingTokens.p2pRiskControlsReasonPadding,
      onTap: onTap,
      clip: true,
      child: Row(
        children: [
          SizedBox.square(
            dimension: P2PSpacingTokens.p2pRiskControlsReasonIconBox,
            child: Material(
              color: tone.withValues(alpha: 0.12),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.smRadius,
              ),
              child: Icon(
                _reasonIcon(reason.iconKey),
                color: tone,
                size: P2PSpacingTokens.p2pRiskControlsReasonIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reason.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? tone : AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  reason.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _toneColor(P2PReportReasonTone tone) {
    return switch (tone) {
      P2PReportReasonTone.danger => AppColors.sell,
      P2PReportReasonTone.purple => AppColors.accent,
      P2PReportReasonTone.warning => AppColors.warn,
      P2PReportReasonTone.info => AppModuleAccents.p2p,
      P2PReportReasonTone.neutral => AppColors.text3,
    };
  }

  IconData _reasonIcon(String key) {
    return switch (key) {
      'alert' => Icons.warning_amber_rounded,
      'ban' => Icons.block_rounded,
      'message' => Icons.chat_bubble_outline_rounded,
      'currency' => Icons.attach_money_rounded,
      'eye' => Icons.visibility_outlined,
      _ => Icons.flag_outlined,
    };
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sc229_detail_field_visible'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chi tiết bổ sung (tuỳ chọn)',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitInput(
          fieldKey: P2PReportMerchantPage.detailFieldKey,
          controller: controller,
          semanticLabel: 'Chi tiết báo cáo merchant P2P',
          hintText: hintText,
          textStyle: AppTextStyles.body.copyWith(color: AppColors.text1),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.border,
      padding: P2PSpacingTokens.p2pRiskControlsInnerPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppModuleAccents.p2p,
            size: P2PSpacingTokens.p2pRiskControlsNoticeIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: P2PSpacingTokens.p2pRiskControlsNoticeLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
