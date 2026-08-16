part of '../../phone/pages/payment/p2p_payment_method_verification_page.dart';

class _MethodChooser extends StatelessWidget {
  const _MethodChooser({required this.snapshot, required this.onSelected});

  final P2PPaymentMethodVerificationSnapshot snapshot;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _OwnershipHero(),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Text(
          'Chọn phương thức xác minh',
          style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (var index = 0; index < snapshot.methods.length; index++) ...[
          _VerificationMethodCard(
            method: snapshot.methods[index],
            onTap: () => onSelected(snapshot.methods[index].id),
          ),
          if (index != snapshot.methods.length - 1)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        const SizedBox(height: AppSpacing.x1),
        _WarningNote(note: snapshot.warningNote),
      ],
    );
  }
}

class _OwnershipHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pPaymentCardPadding,
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Material(
            color: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
            child: SizedBox(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              child: Icon(
                Icons.shield_outlined,
                color: AppColors.text1,
                size: P2PSpacingTokens.p2pPaymentHeroIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xác minh sở hữu',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppModuleAccents.p2p,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Xác minh tài khoản ngân hàng thuộc sở hữu của bạn để đảm bảo an toàn giao dịch.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationMethodCard extends StatelessWidget {
  const _VerificationMethodCard({required this.method, required this.onTap});

  final P2PPaymentVerificationMethodDraft method;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PPaymentMethodVerificationPage.methodKey(method.id),
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pPaymentCardPadding,
      borderColor: method.recommended
          ? AppColors.primary30
          : AppColors.borderSolid,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MethodIcon(icon: _iconForKey(method.iconKey)),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        method.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    if (method.recommended) ...[
                      const SizedBox(width: AppSpacing.x2),
                      const VitStatusPill(
                        label: 'Đề xuất',
                        status: VitStatusPillStatus.success,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  method.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: AppColors.text3,
                      size: P2PSpacingTokens.p2pPaymentMetaIcon,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      method.duration,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: P2PSpacingTokens.p2pPaymentChevronIcon,
          ),
        ],
      ),
    );
  }

  IconData _iconForKey(String key) {
    switch (key) {
      case 'camera':
        return Icons.photo_camera_outlined;
      case 'upload':
        return Icons.upload_rounded;
      case 'card':
      default:
        return Icons.credit_card_rounded;
    }
  }
}
