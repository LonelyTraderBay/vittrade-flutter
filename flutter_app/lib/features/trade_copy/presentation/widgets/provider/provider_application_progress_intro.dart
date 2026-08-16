part of '../../phone/pages/provider/provider_application_page.dart';

class _ProgressBars extends StatelessWidget {
  const _ProgressBars({required this.steps, required this.activeStep});

  final List<TradeProviderApplicationStep> steps;
  final TradeProviderApplicationStep activeStep;

  @override
  Widget build(BuildContext context) {
    final activeIndex = steps.indexOf(activeStep);
    return Row(
      children: [
        for (var index = 0; index < steps.length; index++) ...[
          Expanded(
            child: ClipRRect(
              borderRadius: AppRadii.pillRadius,
              child: SizedBox(
                height: AppSpacing.x1 + AppSpacing.hairlineStroke,
                child: ColoredBox(
                  color: activeIndex >= index
                      ? _providerPrimary
                      : AppColors.surface3,
                ),
              ),
            ),
          ),
          if (index != steps.length - 1)
            const SizedBox(width: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({required this.snapshot});

  final TradeProviderApplicationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.groups_2_outlined, color: _providerPrimary, size: 44),
        const SizedBox(height: AppSpacing.pageRhythmRelaxedSectionGap),
        Text(
          'Trở thành Copy Trading Provider',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(
            height: TradeSpacingTokens.providerApplicationIntroTitleLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Text(
          'Chia sẻ chiến lược giao dịch và kiếm performance fee từ những người copy bạn',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: TradeSpacingTokens
                .providerApplicationIntroDescriptionLineHeight,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const VitSectionHeader(
          title: 'Lợi ích',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _providerGreen,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final benefit in snapshot.benefits) ...[
          _BenefitCard(benefit: benefit),
          if (benefit != snapshot.benefits.last)
            const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _ResponsibilitiesCard(items: snapshot.responsibilities),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        const VitSectionHeader(
          title: 'Yêu cầu cơ bản',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: AppColors.text3,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final requirement in snapshot.requirements) ...[
          _RequirementPreview(requirement: requirement),
          if (requirement != snapshot.requirements.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final TradeProviderBenefit benefit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      constraints: TradeSpacingTokens.providerApplicationBenefitCardConstraints,
      padding: TradeSpacingTokens.providerApplicationBenefitCardPadding,
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSpacing.x5 + AppSpacing.hairlineStroke,
            backgroundColor: AppColors.surfaceSuccessSoft,
            child: Icon(_benefitIcon(benefit.iconName), color: _providerGreen),
          ),
          const SizedBox(width: AppSpacing.pageRhythmFormInnerGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  benefit.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  benefit.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: TradeSpacingTokens
                        .providerApplicationBenefitDescriptionLineHeight,
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

class _ResponsibilitiesCard extends StatelessWidget {
  const _ResponsibilitiesCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.providerApplicationPanelPadding,
      borderColor: _providerWarning.withValues(alpha: .55),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _providerWarning,
            size: 22,
          ),
          const SizedBox(width: AppSpacing.pageRhythmFormInnerGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trách nhiệm quan trọng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _providerWarning,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                for (final item in items)
                  Padding(
                    padding: TradeSpacingTokens
                        .providerApplicationResponsibilityItemPadding,
                    child: Text(
                      '• $item',
                      style: AppTextStyles.caption.copyWith(
                        color: _providerWarning,
                        height: TradeSpacingTokens
                            .providerApplicationResponsibilityLineHeight,
                      ),
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

class _RequirementPreview extends StatelessWidget {
  const _RequirementPreview({required this.requirement});

  final TradeProviderRequirement requirement;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      radius: VitCardRadius.tight,
      height:
          AppSpacing.buttonCompact - AppSpacing.x1 + AppSpacing.hairlineStroke,
      padding: TradeSpacingTokens.providerApplicationRequirementPreviewPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              requirement.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Icon(
            requirement.met
                ? Icons.check_circle_rounded
                : Icons.cancel_outlined,
            color: requirement.met ? _providerGreen : AppColors.text3,
            size: 14,
          ),
        ],
      ),
    );
  }
}
