part of '../../phone/pages/dispute/p2p_insurance_certificate_page.dart';

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsuranceCertificatePage.cardKey,
      clip: true,
      radius: VitCardRadius.large,
      borderColor: AppColors.primary40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _CertificateHero(),
          Padding(
            padding: P2PSpacingTokens.p2pInsuranceCertificateLargePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CertificateIdBlock(snapshot: snapshot),
                const SizedBox(height: _p2pInsuranceSectionGap),
                _IdentityRows(snapshot: snapshot),
                const SizedBox(height: _p2pInsuranceSectionGap),
                _CoverageBox(snapshot: snapshot),
                const SizedBox(height: _p2pInsuranceSectionGap),
                _ValidityRow(snapshot: snapshot),
                const SizedBox(height: _p2pInsuranceSectionGap),
                _ProtectedCases(snapshot: snapshot),
                const SizedBox(height: _p2pInsuranceSectionGap),
                _AuditCallout(snapshot: snapshot),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateHero extends StatelessWidget {
  const _CertificateHero();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppModuleAccents.p2p,
      child: Padding(
        padding: P2PSpacingTokens.p2pInsuranceCertificateHeroPadding,
        child: Column(
          children: [
            const SizedBox.square(
              dimension: _p2pInsuranceHeroIconBox,
              child: Material(
                color: AppColors.portfolioBtnGhost,
                shape: CircleBorder(
                  side: BorderSide(color: AppColors.portfolioBtnGhostBorder),
                ),
                child: Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.onAccent,
                  size: AppSpacing.iconLg,
                ),
              ),
            ),
            const SizedBox(height: _p2pInsuranceTightGap),
            Text(
              'CHỨNG NHẬN BẢO HIỂM',
              textAlign: TextAlign.center,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.onAccent.withValues(alpha: .78),
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              'Giao dịch P2P',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.onAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertificateIdBlock extends StatelessWidget {
  const _CertificateIdBlock({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: P2PSpacingTokens.p2pInsuranceCertificateDividerPadding,
          child: Column(
            children: [
              Text(
                'Mã chứng nhận',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                snapshot.certId,
                textAlign: TextAlign.center,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: AppSpacing.dividerHairline),
      ],
    );
  }
}

class _IdentityRows extends StatelessWidget {
  const _IdentityRows({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CertificateInfoRow(
          icon: Icons.person_outline_rounded,
          label: 'Người được bảo hiểm',
          value: snapshot.holderName,
        ),
        _CertificateInfoRow(
          icon: Icons.workspace_premium_outlined,
          label: 'Tier',
          value: snapshot.tierName,
          valueColor: AppModuleAccents.p2p,
        ),
        _CertificateInfoRow(
          icon: Icons.shield_outlined,
          label: 'Mức bảo hiểm',
          value: '${snapshot.coveragePct}%',
          valueColor: AppColors.buy,
        ),
      ],
    );
  }
}

class _CoverageBox extends StatelessWidget {
  const _CoverageBox({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pInsuranceCertificateCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'PHẠM VI BẢO HIỂM',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _CoverageLine(
            label: 'Hạn mức / claim',
            value: '${_formatVnd(snapshot.maxCoveragePerClaim)} đ',
          ),
          _CoverageLine(
            label: 'Hạn mức / 30 ngày',
            value: '${_formatVnd(snapshot.maxCoveragePer30Days)} đ',
          ),
          _CoverageLine(
            label: 'Cửa sổ claim',
            value: '${snapshot.claimWindowDays} ngày',
          ),
        ],
      ),
    );
  }
}

class _ValidityRow extends StatelessWidget {
  const _ValidityRow({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: P2PSpacingTokens.p2pInsuranceCertificateDividerPadding,
          child: _CertificateInfoRow(
            icon: Icons.calendar_month_outlined,
            label: 'Hiệu lực',
            value: '${snapshot.issueDate} — ${snapshot.validUntil}',
            bottomGap: 0,
          ),
        ),
        const Divider(height: AppSpacing.dividerHairline),
      ],
    );
  }
}

class _ProtectedCases extends StatelessWidget {
  const _ProtectedCases({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'CÁC TRƯỜNG HỢP ĐƯỢC BẢO VỆ',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final item in snapshot.coveredCases) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: P2PSpacingTokens.p2pDocumentSmallIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _p2pInsuranceBodyLineHeight,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _AuditCallout extends StatelessWidget {
  const _AuditCallout({required this.snapshot});

  final P2PInsuranceCertificateSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: AppColors.primary20,
      padding: P2PSpacingTokens.p2pInsuranceCertificateCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.gpp_good_outlined,
            color: AppModuleAccents.p2p,
            size: P2PSpacingTokens.p2pDocumentCalloutIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kiểm toán bởi ${snapshot.auditor}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Gần nhất: ${snapshot.lastAuditDate}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.snapshot, required this.onFeedback});

  final P2PInsuranceCertificateSnapshot snapshot;
  final ValueChanged<String> onFeedback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: P2PInsuranceCertificatePage.downloadKey,
            onPressed: () => _downloadCertificate(context, snapshot),
            leading: const Icon(Icons.download_rounded),
            child: const Text('Tải chứng nhận'),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        VitIconButton(
          key: P2PInsuranceCertificatePage.shareKey,
          icon: Icons.share_outlined,
          tooltip: 'Chia sẻ chứng nhận',
          size: VitIconButtonSize.lg,
          variant: VitIconButtonVariant.ghost,
          onPressed: () => _shareCertificate(context, snapshot),
        ),
      ],
    );
  }

  void _downloadCertificate(
    BuildContext context,
    P2PInsuranceCertificateSnapshot snapshot,
  ) {
    unawaited(HapticFeedback.mediumImpact());
    unawaited(Clipboard.setData(ClipboardData(text: snapshot.exportText)));
    onFeedback('Đã chuẩn bị chứng nhận ${snapshot.certId}');
  }

  void _shareCertificate(
    BuildContext context,
    P2PInsuranceCertificateSnapshot snapshot,
  ) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(Clipboard.setData(ClipboardData(text: snapshot.shareText)));
    onFeedback('Đã sao chép thông tin chứng nhận');
  }
}
