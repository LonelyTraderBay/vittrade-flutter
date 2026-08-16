part of '../../phone/pages/merchant/p2p_identity_verification_page.dart';

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.snapshot});

  final P2PIdentityVerificationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PIdentityVerificationPage.securityKey,
      radius: VitCardRadius.standard,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Bảo mật & Quyền riêng tư',
            icon: Icons.verified_user_outlined,
            iconColor: AppColors.buy,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (final note in snapshot.securityNotes) ...[
            _ChecklistRow(text: note, color: AppColors.buy),
            if (note != snapshot.securityNotes.last)
              const SizedBox(height: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(top: AppSpacing.x1),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: color,
            size: AppSpacing.iconSm,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _documentIcon(String iconKey) {
  return switch (iconKey) {
    'badge' => Icons.badge_outlined,
    'passport' => Icons.contact_page_outlined,
    _ => Icons.credit_card_rounded,
  };
}
