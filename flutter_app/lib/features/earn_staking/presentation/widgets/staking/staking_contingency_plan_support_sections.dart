part of '../../phone/pages/staking/staking_contingency_plan_page.dart';

class _ValidationSection extends StatelessWidget {
  const _ValidationSection({required this.items, required this.body});

  final List<StakingContingencyValidationDraft> items;
  final String body;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingContingencyPlanPage.validationKey,
      label: 'Testing & Validation',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in items) _ValidationRow(item: item),
              Text(
                body,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: EarnSpacingTokens.stakingContingencyBodyLineHeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValidationRow extends StatelessWidget {
  const _ValidationRow({required this.item});

  final StakingContingencyValidationDraft item;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(item.tone);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EarnSpacingTokens.earnBottomPaddingX3,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      item.dateLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                item.tone == 'success'
                    ? Icons.check_circle_outline_rounded
                    : Icons.warning_amber_rounded,
                color: color,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.borderSolid,
          height: AppSpacing.dividerHairline,
        ),
      ],
    );
  }
}

class _DocumentationSection extends StatelessWidget {
  const _DocumentationSection({required this.documents});

  final List<StakingContingencyDocumentDraft> documents;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingContingencyPlanPage.documentsKey,
      label: 'Documentation',
      accentColor: AppColors.primarySoft,
      children: [
        for (final document in documents) _DocumentRow(document: document),
      ],
    );
  }
}

class _DocumentRow extends StatelessWidget {
  const _DocumentRow({required this.document});

  final StakingContingencyDocumentDraft document;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppColors.primarySoft,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  document.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${document.size} - Updated ${document.updatedLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.text3,
            size: EarnSpacingTokens.stakingContingencyExternalIcon,
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingContingencyPlanPage.footerKey,
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: VitRiskDisclaimerNote(
        message: note,
        height: EarnSpacingTokens.stakingContingencyFooterLineHeight,
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
    this.emphasis = false,
  });

  final String label;
  final Color color;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: emphasis ? 0.16 : 0.08),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: emphasis
                    ? AppTextStyles.bold
                    : AppTextStyles.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _impactColor(String impact) {
  return switch (impact) {
    'Critical' => AppColors.sell,
    'High' => AppColors.warn,
    'Medium' => AppColors.primarySoft,
    _ => AppColors.text3,
  };
}

Color _toneColor(String tone) {
  return switch (tone) {
    'success' => AppColors.buy,
    'warning' => AppColors.warn,
    _ => AppColors.text2,
  };
}
