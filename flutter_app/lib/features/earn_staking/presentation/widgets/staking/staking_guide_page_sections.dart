part of '../../phone/pages/staking/staking_guide_page.dart';

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.snapshot});

  final StakingGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingGuidePage.heroKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            color: AppModuleAccents.earn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.heroTitle, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  snapshot.heroBody,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DifficultyTabs extends StatelessWidget {
  const _DifficultyTabs({required this.active, required this.onChanged});

  final StakingGuideDifficulty active;
  final ValueChanged<StakingGuideDifficulty> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      key: StakingGuidePage.tabsKey,
      color: AppColors.surface,
      child: Padding(
        padding: EarnSpacingTokens.earnSurfaceTabsPadding,
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active.name,
          onChanged: (key) => onChanged(
            StakingGuideDifficulty.values.firstWhere(
              (difficulty) => difficulty.name == key,
            ),
          ),
          tabs: [
            for (final difficulty in StakingGuideDifficulty.values)
              VitTabItem(
                key: difficulty.name,
                label: _difficultyTabLabel(difficulty),
              ),
          ],
        ),
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({required this.tutorial, required this.onTap});

  final StakingGuideTutorialDraft tutorial;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingGuidePage.tutorialKey(tutorial.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      onTap: onTap,
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX4,
        child: Row(
          children: [
            const _RoundIcon(
              icon: Icons.play_circle_outline_rounded,
              color: AppModuleAccents.earn,
              size: AppSpacing.buttonStandard,
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tutorial.title, style: AppTextStyles.baseMedium),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x1,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _DifficultyPill(difficulty: tutorial.difficulty),
                      Text(
                        '${tutorial.duration} - ${tutorial.steps.length} bước',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickTipsGrid extends StatelessWidget {
  const _QuickTipsGrid({required this.snapshot});

  final StakingGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingGuidePage.quickTipsKey,
      label: 'Quick Tips',
      accentColor: AppModuleAccents.earn,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - AppSpacing.x3) / 2;
            return Wrap(
              spacing: AppSpacing.x3,
              runSpacing: AppSpacing.x3,
              children: [
                for (final tip in snapshot.quickTips)
                  SizedBox(
                    width: itemWidth,
                    child: _QuickTipCard(tip: tip),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _QuickTipCard extends StatelessWidget {
  const _QuickTipCard({required this.tip});

  final StakingGuideQuickTipDraft tip;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(tip.tone);
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RoundIcon(icon: _guideIcon(tip.iconKey), color: color),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            tip.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            tip.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CommonMistakes extends StatelessWidget {
  const _CommonMistakes({required this.snapshot});

  final StakingGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingGuidePage.mistakesKey,
      label: 'Tránh sai lầm phổ biến',
      accentColor: AppModuleAccents.earn,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX4,
          child: Column(
            children: [
              for (var i = 0; i < snapshot.mistakes.length; i++) ...[
                if (i > 0)
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _MistakeRow(mistake: snapshot.mistakes[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MistakeRow extends StatelessWidget {
  const _MistakeRow({required this.mistake});

  final StakingGuideMistakeDraft mistake;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(mistake.tone);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mistake.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  mistake.correction,
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

class _StartStakingCard extends StatelessWidget {
  const _StartStakingCard({required this.snapshot});

  final StakingGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingGuidePage.ctaKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(snapshot.ctaTitle, style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.ctaBody,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          SizedBox(
            width: AppSpacing.buttonHero * 1.55,
            child: VitCtaButton(
              onPressed: () {
                unawaited(HapticFeedback.selectionClick());
                context.go(snapshot.stakingRoute);
              },
              trailing: const Icon(Icons.arrow_forward_rounded),
              child: Text(snapshot.ctaLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.stepIndex,
    required this.total,
    required this.progress,
  });

  final int stepIndex;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return VitProgressBar(
      progress: progress,
      label: 'Bước ${stepIndex + 1}/$total',
      trailingLabel: '${(progress * 100).round()}% hoàn thành',
      trackColor: AppColors.borderSolid,
      height: EarnSpacingTokens.earnGuideProgressHeight,
      gap: AppSpacing.pageRhythmCompactInnerGap,
      borderRadius: AppRadii.xsRadius,
    );
  }
}
