part of '../../phone/pages/security/p2p_tax_reporting_page.dart';

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    this.tone = AppColors.text1,
    this.toneBg,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color tone;
  final Color? toneBg;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      variant: toneBg == null ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: toneBg == null ? null : tone.withValues(alpha: .18),
      padding: P2PSpacingTokens.p2pTaxCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: tone == AppColors.text1 ? AppColors.text3 : tone,
                size: P2PSpacingTokens.p2pDocumentInlineIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: tone == AppColors.text1 ? AppColors.text3 : tone,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pTaxSectionGap),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: tone,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaxDocuments extends StatelessWidget {
  const _TaxDocuments({required this.snapshot});

  final P2PTaxReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PTaxReportingPage.documentsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Download Tax Documents',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _p2pTaxSectionGap),
        for (var index = 0; index < snapshot.documents.length; index++) ...[
          _TaxDocumentRow(document: snapshot.documents[index]),
          if (index != snapshot.documents.length - 1)
            const SizedBox(height: _p2pTaxSectionGap),
        ],
      ],
    );
  }
}

class _TaxDocumentRow extends StatelessWidget {
  const _TaxDocumentRow({required this.document});

  final P2PTaxDocumentDraft document;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(document.toneKey);
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pTaxCardPadding,
      child: Row(
        children: [
          SizedBox.square(
            dimension: _p2pTaxIconBox,
            child: Material(
              color: color.withValues(alpha: .14),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.lgRadius,
              ),
              child: Icon(
                Icons.description_outlined,
                color: color,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: _p2pTaxSectionGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  document.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: _p2pTaxSectionGap),
          VitChoicePill(
            label: document.format,
            selected: true,
            onTap: () => HapticFeedback.selectionClick(),
            accentColor: color,
            height: AppSpacing.buttonCompact,
            padding: P2PSpacingTokens.p2pDocumentDownloadPadding,
            leading: const Icon(Icons.download_rounded),
            semanticLabel: 'Tải báo cáo ${document.format}',
          ),
        ],
      ),
    );
  }
}

class _TaxDisclaimer extends StatelessWidget {
  const _TaxDisclaimer({required this.snapshot});

  final P2PTaxReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PTaxReportingPage.disclaimerKey,
      color: AppColors.sell10,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppColors.sell20),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pTaxCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.sell,
              size: P2PSpacingTokens.p2pDocumentInlineIcon,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: _p2pTaxNoticeLineHeight,
                  ),
                  children: [
                    TextSpan(
                      text: 'Tax Disclaimer: ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    TextSpan(text: snapshot.disclaimer),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _toneColor(String toneKey) {
  return switch (toneKey) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    'primary' => AppColors.primary,
    _ => AppColors.accent,
  };
}
