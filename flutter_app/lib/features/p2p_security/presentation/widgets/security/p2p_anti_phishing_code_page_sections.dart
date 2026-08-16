part of '../../phone/pages/security/p2p_anti_phishing_code_page.dart';

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.snapshot});

  final P2PAntiPhishingCodeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = snapshot.hasCode ? AppColors.buy : AppColors.warn;

    return Material(
      key: P2PAntiPhishingCodePage.statusKey,
      type: MaterialType.transparency,
      color: color,
      borderRadius: AppRadii.cardLargeRadius,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: AppSpacing.buttonCompact,
              child: Material(
                type: MaterialType.transparency,
                color: AppColors.onAccent.withValues(alpha: .18),
                borderRadius: AppRadii.lgRadius,
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppColors.onAccent,
                  size: AppSpacing.iconMd,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.statusTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.onAccent,
                      height: AppTextStyles.baseMedium.height,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.statusBody,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent.withValues(alpha: .9),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplainerCard extends StatelessWidget {
  const _ExplainerCard({required this.snapshot});

  final P2PAntiPhishingCodeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAntiPhishingCodePage.explainerKey,
      radius: VitCardRadius.large,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.explainerTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            snapshot.explainerBody,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.35,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          for (final benefit in snapshot.benefits) ...[
            _CheckRow(text: benefit),
            if (benefit != snapshot.benefits.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _EmailExamples extends StatelessWidget {
  const _EmailExamples({required this.examples});

  final List<P2PAntiPhishingExampleDraft> examples;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PAntiPhishingCodePage.examplesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < examples.length; index++) ...[
          _EmailExampleCard(example: examples[index]),
          if (index != examples.length - 1)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _EmailExampleCard extends StatelessWidget {
  const _EmailExampleCard({required this.example});

  final P2PAntiPhishingExampleDraft example;

  @override
  Widget build(BuildContext context) {
    final color = example.isLegit ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: P2PAntiPhishingCodePage.exampleKey(example.id),
      radius: VitCardRadius.large,
      borderColor: color,
      padding: const EdgeInsetsDirectional.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                example.isLegit
                    ? Icons.check_circle_outline_rounded
                    : Icons.warning_amber_rounded,
                color: color,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.text3,
                          size: P2PSpacingTokens.p2pSecurityDetailsInlineIcon,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Expanded(
                          child: Text(
                            example.subject,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    VitCard(
                      radius: VitCardRadius.standard,
                      variant: VitCardVariant.inner,
                      borderColor: AppColors.transparent,
                      padding: P2PSpacingTokens.p2pSecurityDetailsInnerPadding,
                      child: Text(
                        example.preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          height: 1.35,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Align(
            alignment: Alignment.centerLeft,
            child: VitStatusPill(
              label: example.isLegit ? 'Email chính thức' : 'Email lừa đảo',
              icon: example.isLegit ? Icons.check_rounded : Icons.close_rounded,
              status: example.isLegit
                  ? VitStatusPillStatus.success
                  : VitStatusPillStatus.error,
              size: VitStatusPillSize.sm,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.snapshot});

  final P2PAntiPhishingCodeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PAntiPhishingCodePage.warningKey,
      type: MaterialType.transparency,
      color: AppColors.sell10,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppColors.sell20),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pSecurityDetailsInnerPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.warningTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  for (final warning in snapshot.warnings) ...[
                    _BulletRow(text: warning),
                    if (warning != snapshot.warnings.last)
                      const SizedBox(height: AppSpacing.x1),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.buy,
          size: P2PSpacingTokens.p2pSecurityDetailsCheckIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: P2PSpacingTokens.p2pSecurityDetailsBulletPadding,
          child: Icon(
            Icons.circle,
            color: AppColors.text3,
            size: P2PSpacingTokens.p2pSecurityDetailsSmallBullet,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
