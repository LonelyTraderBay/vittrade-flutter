part of '../../phone/pages/merchant/p2p_address_proof_page.dart';

class _AddressHero extends StatelessWidget {
  const _AddressHero({required this.snapshot});

  final P2PAddressProofSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.heroKey,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary20,
      padding: P2PSpacingTokens.p2pAddressProofCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Material(
            color: AppColors.primary15,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
              side: BorderSide(color: AppColors.primary20),
            ),
            child: Padding(
              padding: P2PSpacingTokens.p2pAddressProofHeroIconPadding,
              child: Icon(
                Icons.location_on_outlined,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.sectionTitleXs.copyWith(
                    color: AppModuleAccents.p2p,
                  ),
                ),
                const SizedBox(height: _p2pAddressProofTightGap),
                Text(
                  snapshot.heroBody,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: P2PSpacingTokens.p2pAddressProofReadableLineHeight,
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

class _RequirementsCard extends StatelessWidget {
  const _RequirementsCard({required this.snapshot});

  final P2PAddressProofSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.requirementsKey,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pAddressProofCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Yêu cầu tài liệu',
            icon: Icons.info_outline_rounded,
            iconColor: AppModuleAccents.p2p,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (final requirement in snapshot.requirements) ...[
            _ChecklistRow(text: requirement, color: AppColors.buy),
            if (requirement != snapshot.requirements.last)
              const SizedBox(height: _p2pAddressProofTightGap),
          ],
        ],
      ),
    );
  }
}

class _DocumentTypePicker extends StatelessWidget {
  const _DocumentTypePicker({
    required this.documents,
    required this.onSelected,
  });

  final List<P2PAddressDocumentTypeDraft> documents;
  final ValueChanged<P2PAddressDocumentTypeDraft> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PAddressProofPage.documentTypesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn loại tài liệu',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _p2pAddressProofSectionGap),
        for (final document in documents) ...[
          VitCard(
            key: P2PAddressProofPage.documentTypeKey(document.id),
            radius: VitCardRadius.large,
            padding: P2PSpacingTokens.p2pAddressProofCardPadding,
            onTap: () => onSelected(document),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: AppColors.primary12,
                      borderRadius: AppRadii.smRadius,
                      child: Padding(
                        padding:
                            P2PSpacingTokens.p2pAddressProofExampleTilePadding,
                        child: Icon(
                          _documentIcon(document.iconKey),
                          color: AppModuleAccents.p2p,
                          size: AppSpacing.iconSm,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.label,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          const SizedBox(height: _p2pAddressProofTightGap),
                          Text(
                            document.description,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.text3,
                      size: AppSpacing.iconSm,
                    ),
                  ],
                ),
                const SizedBox(height: _p2pAddressProofSectionGap),
                Padding(
                  padding:
                      P2PSpacingTokens.p2pAddressProofDocumentExamplePadding,
                  child: Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      for (final example in document.examples)
                        Material(
                          color: AppColors.surface2,
                          borderRadius: AppRadii.cardLargeRadius,
                          child: Padding(
                            padding:
                                P2PSpacingTokens.p2pAddressProofExamplePadding,
                            child: Text(
                              example,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (document != documents.last)
            const SizedBox(height: _p2pAddressProofSectionGap),
        ],
      ],
    );
  }
}

class _UploadSection extends StatelessWidget {
  const _UploadSection({
    required this.selectedDocument,
    required this.uploaded,
    required this.onChangeType,
    required this.onUpload,
    required this.onRemove,
  });

  final P2PAddressDocumentTypeDraft selectedDocument;
  final bool uploaded;
  final VoidCallback onChangeType;
  final VoidCallback onUpload;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Upload tài liệu',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            VitCtaButton(
              onPressed: onChangeType,
              variant: VitCtaButtonVariant.ghost,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: P2PSpacingTokens.p2pAddressProofActionHorizontalPadding,
              child: const Text('Đổi loại tài liệu'),
            ),
          ],
        ),
        const SizedBox(height: _p2pAddressProofSectionGap),
        VitCard(
          key: P2PAddressProofPage.uploadKey,
          radius: VitCardRadius.large,
          variant: uploaded ? VitCardVariant.inner : VitCardVariant.ghost,
          borderColor: uploaded ? AppColors.buy20 : AppColors.borderSolid,
          padding: P2PSpacingTokens.p2pAddressProofCardPadding,
          onTap: uploaded ? null : onUpload,
          child: uploaded
              ? Row(
                  children: [
                    const Material(
                      color: AppColors.buy10,
                      borderRadius: AppRadii.lgRadius,
                      child: Padding(
                        padding:
                            P2PSpacingTokens.p2pAddressProofUploadIconPadding,
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.buy,
                          size: AppSpacing.iconSm,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tài liệu đã sẵn sàng',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            '${selectedDocument.label} · OCR quality 94%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.buy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VitIconButton(
                      icon: Icons.close_rounded,
                      tooltip: 'Xóa tài liệu',
                      variant: VitIconButtonVariant.ghost,
                      onPressed: onRemove,
                    ),
                  ],
                )
              : Padding(
                  padding:
                      P2PSpacingTokens.p2pAddressProofUploadVerticalPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Material(
                        color: AppColors.primary12,
                        shape: CircleBorder(),
                        child: Padding(
                          padding:
                              P2PSpacingTokens.p2pAddressProofUploadIconPadding,
                          child: Icon(
                            Icons.cloud_upload_outlined,
                            color: AppModuleAccents.p2p,
                            size: AppSpacing.iconMd,
                          ),
                        ),
                      ),
                      const SizedBox(height: _p2pAddressProofSectionGap),
                      Text(
                        'Chụp hoặc tải tài liệu',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        '${selectedDocument.label} · JPG, PNG, PDF · Tối đa 10MB',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _ExtractedDataCard extends StatelessWidget {
  const _ExtractedDataCard({required this.snapshot});

  final P2PAddressProofSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAddressProofPage.extractedDataKey,
      radius: VitCardRadius.standard,
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: P2PSpacingTokens.p2pAddressProofCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Đã trích xuất thông tin',
            icon: Icons.check_circle_outline_rounded,
            iconColor: AppColors.buy,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          _MetadataRow(label: 'Tên', value: snapshot.extractedName),
          const SizedBox(height: _p2pAddressProofTightGap),
          _MetadataRow(label: 'Ngày phát hành', value: snapshot.extractedDate),
        ],
      ),
    );
  }
}
