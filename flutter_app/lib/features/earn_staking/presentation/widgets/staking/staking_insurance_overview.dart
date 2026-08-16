part of '../../phone/pages/staking/staking_insurance_page.dart';

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final insuredPositions = snapshot.positions.where((p) => p.insured).length;
    final totalInsured = snapshot.positions
        .where((p) => p.insured)
        .fold<double>(0, (sum, p) => sum + p.usdValue);
    final totalPremium = snapshot.positions
        .where((p) => p.insured)
        .fold<double>(0, (sum, position) {
          final plan = snapshot.planById(position.insurancePlanId);
          return sum +
              (plan == null ? 0 : position.usdValue * plan.premium / 100);
        });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          key: StakingInsurancePage.overviewSummaryKey,
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnPaddingX4,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giá trị được bảo hiểm',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const Padding(
                          padding: EarnSpacingTokens.earnTopPaddingX3,
                        ),
                        Text(
                          _formatUsd(totalInsured),
                          style: AppTextStyles.heroNumber.copyWith(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: EarnSpacingTokens.stakingInsuranceShieldIconBox,
                    height: EarnSpacingTokens.stakingInsuranceShieldIconBox,
                    child: Material(
                      color: AppColors.buy10,
                      shape: CircleBorder(
                        side: BorderSide(
                          color: AppColors.buy,
                          width: EarnSpacingTokens
                              .stakingInsuranceShieldBorderWidth,
                        ),
                      ),
                      child: Icon(
                        Icons.shield_outlined,
                        color: AppColors.buy,
                        size: AppSpacing.iconLg,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Vị thế có BH',
                      value: '$insuredPositions/${snapshot.positions.length}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: _SummaryMetric(
                      label: 'Phí/năm',
                      value: _formatUsd(totalPremium),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _BenefitsGrid(snapshot: snapshot),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _WarningNote(snapshot: snapshot),
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsGrid extends StatelessWidget {
  const _BenefitsGrid({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingInsurancePage.benefitsKey,
      label: 'Lợi ích Bảo hiểm',
      accentColor: AppColors.primarySoft,
      children: [
        GridView.builder(
          itemCount: snapshot.benefits.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:
                EarnSpacingTokens.stakingInsuranceBenefitGridColumns,
            crossAxisSpacing: AppSpacing.x4,
            mainAxisSpacing: AppSpacing.x4,
            childAspectRatio:
                EarnSpacingTokens.stakingInsuranceBenefitGridAspect,
          ),
          itemBuilder: (context, index) {
            final benefit = snapshot.benefits[index];
            return _BenefitCard(benefit: benefit);
          },
        ),
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final StakingInsuranceBenefitDraft benefit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.ctaHeight,
            height: AppSpacing.ctaHeight,
            child: Material(
              color: _iconFillColor(benefit.icon),
              shape: CircleBorder(
                side: BorderSide(color: _iconBorder(benefit.icon)),
              ),
              child: Icon(
                _benefitIcon(benefit.icon),
                color: _iconColor(benefit.icon),
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            benefit.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            benefit.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.snapshot});

  final StakingInsuranceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInsurancePage.warningKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.warningTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                for (final bullet in snapshot.warningBullets)
                  Padding(
                    padding: EarnSpacingTokens.earnBottomPaddingX1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EarnSpacingTokens.earnBulletTopMarginX3,
                          child: SizedBox(
                            width: AppSpacing.x1,
                            height: AppSpacing.x1,
                            child: Material(
                              color: AppColors.warn,
                              shape: CircleBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: Text(
                            bullet,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                      ],
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

IconData _benefitIcon(String icon) {
  return switch (icon) {
    'shield' => Icons.shield_outlined,
    'clock' => Icons.schedule_rounded,
    'cost' => Icons.attach_money_rounded,
    'audit' => Icons.check_circle_outline_rounded,
    _ => Icons.shield_outlined,
  };
}

Color _iconColor(String icon) {
  return switch (icon) {
    'shield' => AppColors.buy,
    'clock' => AppColors.primarySoft,
    'cost' => AppColors.warn,
    'audit' => AppColors.accent,
    _ => AppColors.primarySoft,
  };
}

Color _iconFillColor(String icon) {
  return switch (icon) {
    'shield' => AppColors.buy10,
    'clock' => AppColors.primary12,
    'cost' => AppColors.warn10,
    'audit' => AppColors.accent12,
    _ => AppColors.primary12,
  };
}

Color _iconBorder(String icon) {
  return switch (icon) {
    'shield' => AppColors.buy20,
    'clock' => AppColors.primary30,
    'cost' => AppColors.warningBorder,
    'audit' => AppColors.accent30,
    _ => AppColors.primary30,
  };
}
