part of '../../phone/pages/dispute/p2p_insurance_certificate_page.dart';

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: AppColors.buy20,
      padding: P2PSpacingTokens.p2pInsuranceCertificateCardPadding,
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: P2PSpacingTokens.p2pDocumentCalloutIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pInsuranceCertificateCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: P2PSpacingTokens.p2pDocumentInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              snapshot.disclosure,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: _p2pInsuranceBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateInfoRow extends StatelessWidget {
  const _CertificateInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.bottomGap = _p2pInsuranceSectionGap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final double bottomGap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pDocumentInfoRowPadding(bottomGap),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.text3,
            size: P2PSpacingTokens.p2pDocumentRowIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverageLine extends StatelessWidget {
  const _CoverageLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pInsuranceCertificateBulletPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatVnd(int value) => formatP2PVnd(value);
