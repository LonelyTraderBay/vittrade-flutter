part of '../../phone/pages/merchant/p2p_address_proof_page.dart';

class _AddressConfirmCard extends StatelessWidget {
  const _AddressConfirmCard({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.addressConfirmKey,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pAddressProofCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Xác nhận địa chỉ',
            icon: Icons.location_on_outlined,
            iconColor: AppModuleAccents.p2p,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          Text(
            address,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: _p2pAddressProofSectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Địa chỉ này phải khớp với địa chỉ trên tài liệu và CMND/CCCD của bạn.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: P2PSpacingTokens.p2pAddressProofReadableLineHeight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.snapshot});

  final P2PAddressProofSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.securityKey,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pAddressProofCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Bảo mật thông tin',
            icon: Icons.verified_user_outlined,
            iconColor: AppColors.buy,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (final note in snapshot.securityNotes) ...[
            _ChecklistRow(text: note, color: AppColors.buy),
            if (note != snapshot.securityNotes.last)
              const SizedBox(height: _p2pAddressProofTightGap),
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
          padding: P2PSpacingTokens.p2pAddressProofChecklistIconPadding,
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: color,
            size: P2PSpacingTokens.p2pAddressProofChecklistIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: P2PSpacingTokens.p2pAddressProofReadableLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

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
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

IconData _documentIcon(String iconKey) {
  return switch (iconKey) {
    'receipt' => Icons.receipt_long_outlined,
    'bank_card' => Icons.credit_card_rounded,
    'government' => Icons.description_outlined,
    'home' => Icons.home_outlined,
    _ => Icons.file_present_outlined,
  };
}
