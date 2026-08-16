part of '../phone/pages/onboarding_flow_page.dart';

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({super.key, required this.welcome});

  final OnboardingWelcomeDraft welcome;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.form,
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.tight,
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          radius: VitCardRadius.large,
          clip: true,
          padding: OnboardingSpacingTokens.onboardingCardPadding,
          background: const VitHeroGlow(center: Alignment(0, -0.96)),
          child: Column(
            children: [
              const _HeroIcon(icon: Icons.auto_awesome_rounded),
              Text(
                welcome.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.pageTitle,
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                welcome.subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
        VitCard(
          padding: OnboardingSpacingTokens.onboardingCardPadding,
          radius: VitCardRadius.standard,
          child: Column(
            children: [
              for (final feature in welcome.features)
                _FeatureRow(feature: feature),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModulesStep extends StatelessWidget {
  const _ModulesStep({
    super.key,
    required this.modules,
    required this.currentIndex,
    required this.onSelect,
  });

  final List<OnboardingModuleDraft> modules;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final module = modules[currentIndex];
    final visual = _visualForId(module.id);
    final accent = visual.accent;

    return VitPageContent(
      rhythm: VitPageRhythm.form,
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.tight,
      children: [
        const _StepHeading(
          title: 'Khám phá 5 modules',
          subtitle: 'Mỗi module phục vụ một nhu cầu khác nhau',
        ),
        _HeroIcon(icon: visual.icon, color: accent),
        Column(
          children: [
            Text(
              module.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(color: accent),
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              module.description,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ),
        VitCard(
          padding: OnboardingSpacingTokens.onboardingCardPadding,
          radius: VitCardRadius.large,
          child: Column(
            children: [
              for (final feature in module.features)
                _BulletRow(text: feature, color: accent),
            ],
          ),
        ),
        VitCarouselDots(
          itemCount: modules.length,
          activeIndex: currentIndex,
          activeColor: accent,
          dotKeyBuilder: (index) =>
              OnboardingFlowPage.moduleDotKey(modules[index].id),
          onDotTap: onSelect,
        ),
      ],
    );
  }
}

class _BoundariesStep extends StatelessWidget {
  const _BoundariesStep({
    super.key,
    required this.boundaries,
    required this.separationRules,
    required this.expandedBoundaryId,
    required this.onToggle,
  });

  final List<OnboardingBoundaryDraft> boundaries;
  final List<String> separationRules;
  final String? expandedBoundaryId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.form,
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.defaultGap,
      children: [
        const _StepHeading(
          title: 'Ranh giới rõ ràng',
          subtitle: 'Hiểu sự khác biệt giữa các module để sử dụng an toàn',
        ),
        for (final boundary in boundaries)
          _BoundaryCard(
            boundary: boundary,
            expanded: expandedBoundaryId == boundary.id,
            onTap: () => onToggle(boundary.id),
          ),
        VitCard(
          padding: OnboardingSpacingTokens.onboardingCardPadding,
          radius: VitCardRadius.standard,
          borderColor: AppColors.warningBorder,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warningText,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Quy tắc tách biệt',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.warningText,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
              for (final rule in separationRules) ...[
                _BulletRow(text: rule, color: AppColors.warningText),
                if (rule != separationRules.last)
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustStep extends StatelessWidget {
  const _TrustStep({
    super.key,
    required this.pillars,
    required this.commitments,
  });

  final List<OnboardingTrustDraft> pillars;
  final List<String> commitments;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.form,
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.defaultGap,
      children: [
        const _StepHeading(
          title: 'An toàn là ưu tiên số 1',
          subtitle: 'Nền tảng được xây dựng với nguyên tắc Trust-first',
        ),
        for (final pillar in pillars) _TrustCard(pillar: pillar),
        VitCard(
          padding: OnboardingSpacingTokens.onboardingCardPadding,
          radius: VitCardRadius.standard,
          borderColor: AppColors.buy20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Cam kết của chúng tôi',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              for (final item in commitments) ...[
                _BulletRow(
                  text: item,
                  color: AppColors.buy,
                  icon: Icons.check_circle_outline_rounded,
                ),
                if (item != commitments.last)
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _GoalsStep extends StatelessWidget {
  const _GoalsStep({
    super.key,
    required this.goals,
    required this.selectedGoals,
    required this.onToggle,
  });

  final List<OnboardingGoalDraft> goals;
  final Set<OnboardingUserGoalDraft> selectedGoals;
  final ValueChanged<OnboardingUserGoalDraft> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.form,
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.defaultGap,
      children: [
        const _StepHeading(
          title: 'Bạn muốn làm gì?',
          subtitle: 'Chọn một hoặc nhiều mục tiêu để cá nhân hóa trải nghiệm',
        ),
        GridView.count(
          crossAxisCount: OnboardingSpacingTokens.onboardingGoalGridColumns,
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio:
              OnboardingSpacingTokens.onboardingGoalGridAspectRatio,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            for (final goal in goals)
              _GoalTile(
                key: OnboardingFlowPage.goalKey(goal.id),
                goal: goal,
                selected: selectedGoals.contains(goal.id),
                onTap: () => onToggle(goal.id),
              ),
          ],
        ),
        Text(
          selectedGoals.isEmpty
              ? 'Bạn có thể bỏ qua bước này'
              : 'Đã chọn ${selectedGoals.length} mục tiêu',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _CompleteStep extends StatelessWidget {
  const _CompleteStep({
    super.key,
    required this.selectedGoals,
    required this.recommendations,
    required this.onOpenRoute,
  });

  final List<OnboardingUserGoalDraft> selectedGoals;
  final Map<OnboardingUserGoalDraft, OnboardingRecommendationDraft>
  recommendations;
  final ValueChanged<String> onOpenRoute;

  @override
  Widget build(BuildContext context) {
    final visibleRecommendations = selectedGoals
        .map((goal) => recommendations[goal])
        .whereType<OnboardingRecommendationDraft>()
        .take(3)
        .toList(growable: false);

    return VitPageContent(
      rhythm: VitPageRhythm.form,
      padding: VitContentPadding.defaultPadding,
      gap: VitContentGap.tight,
      children: [
        const _HeroIcon(
          icon: Icons.check_circle_outline_rounded,
          success: true,
        ),
        Column(
          children: [
            const Text(
              'Sẵn sàng!',
              textAlign: TextAlign.center,
              style: AppTextStyles.pageTitle,
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              selectedGoals.isEmpty
                  ? 'Bạn đã sẵn sàng khám phá toàn bộ nền tảng'
                  : 'Trải nghiệm đã được cá nhân hóa theo mục tiêu của bạn',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ),
        if (visibleRecommendations.isNotEmpty) ...[
          VitPageSection(
            label: 'Đề xuất cho bạn',
            children: [
              for (final recommendation in visibleRecommendations)
                _RecommendationCard(
                  recommendation: recommendation,
                  onTap: () => onOpenRoute(recommendation.route),
                ),
            ],
          ),
        ],
        VitCard(
          padding: OnboardingSpacingTokens.onboardingCardPadding,
          radius: VitCardRadius.standard,
          borderColor: AppColors.primary20,
          child: Text.rich(
            TextSpan(
              text:
                  'Bạn có thể thiết lập bảo mật nâng cao (2FA, biometrics) bất kỳ lúc nào trong ',
              children: [
                TextSpan(
                  text: 'Cài đặt bảo mật',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}
