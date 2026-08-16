part of 'arena_guide_page.dart';

class _GuideTabs extends StatelessWidget {
  const _GuideTabs({required this.active, required this.onChanged});

  final _GuideTab active;
  final ValueChanged<_GuideTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: ArenaSpacingTokens.arenaGuideTabsPadding,
            child: VitTabBar(
              variant: VitTabBarVariant.underline,
              activeKey: active.name,
              onChanged: (key) => onChanged(
                _GuideTab.values.firstWhere((tab) => tab.name == key),
              ),
              tabs: [
                VitTabItem(
                  key: _GuideTab.guide.name,
                  widgetKey: ArenaGuidePage.tabKey('guide'),
                  label: 'Hướng dẫn',
                  icon: Icons.menu_book_outlined,
                ),
                VitTabItem(
                  key: _GuideTab.tips.name,
                  widgetKey: ArenaGuidePage.tabKey('tips'),
                  label: 'Mẹo hay',
                  icon: Icons.lightbulb_outline,
                ),
                VitTabItem(
                  key: _GuideTab.safety.name,
                  widgetKey: ArenaGuidePage.tabKey('safety'),
                  label: 'An toàn',
                  icon: Icons.shield_outlined,
                ),
                VitTabItem(
                  key: _GuideTab.faq.name,
                  widgetKey: ArenaGuidePage.tabKey('faq'),
                  label: 'FAQ',
                  icon: Icons.help_outline,
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.border,
          ),
        ],
      ),
    );
  }
}

class _GuideHero extends StatelessWidget {
  const _GuideHero({required this.snapshot});

  final ArenaGuideSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      padding: ArenaSpacingTokens.arenaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hướng dẫn - Open Arena',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            snapshot.heroTitle,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            snapshot.heroSubtitle,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.mode, required this.onChanged});

  final _GuideMode mode;
  final ValueChanged<_GuideMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice.withPrimaryAccent(
      selected: mode,
      onChanged: onChanged,
      height: _guideActionExtent,
      accentColor: _arenaAccent,
      options: [
        const VitSegmentedChoiceOption(
          key: ArenaGuidePage.modeCreateKey,
          activeKey: ArenaGuidePage.modeCreateKey,
          value: _GuideMode.create,
          label: 'Tạo Challenge',
          leading: Icon(
            Icons.auto_awesome,
            size: ArenaSpacingTokens.arenaGuideModeIcon,
          ),
          semanticLabel: 'Chế độ tạo challenge',
        ),
        const VitSegmentedChoiceOption(
          key: ArenaGuidePage.modeJoinKey,
          activeKey: ArenaGuidePage.modeJoinKey,
          value: _GuideMode.join,
          label: 'Tham gia',
          leading: Icon(
            Icons.play_arrow_outlined,
            size: ArenaSpacingTokens.arenaGuideModeIcon,
          ),
          semanticLabel: 'Chế độ tham gia challenge',
        ),
      ],
    );
  }
}

class _StepsTimeline extends StatelessWidget {
  const _StepsTimeline({required this.steps});

  final List<ArenaGuideStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          left: ArenaSpacingTokens.arenaGuideTimelineLeft,
          top: ArenaSpacingTokens.arenaGuideTimelineInset,
          bottom: ArenaSpacingTokens.arenaGuideTimelineInset,
          child: SizedBox(
            width: ArenaSpacingTokens.arenaGuideTimelineLineWidth,
            child: ColoredBox(color: AppColors.divider),
          ),
        ),
        Column(
          children: [
            for (var index = 0; index < steps.length; index++)
              Padding(
                padding: ArenaSpacingTokens.arenaGuideTimelineStepPadding(
                  index == steps.length - 1,
                ),
                child: _StepRow(step: steps[index]),
              ),
          ],
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final ArenaGuideStepDraft step;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(step.tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ArenaSpacingTokens.arenaGuideStepIconBox,
          height: ArenaSpacingTokens.arenaGuideStepIconBox,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color.withValues(alpha: .12),
              shape: CircleBorder(
                side: BorderSide(
                  color: color,
                  width: ArenaSpacingTokens.arenaGuideStepBorderWidth,
                ),
              ),
            ),
            child: Center(
              child: Icon(
                _iconFor(step.iconKey),
                color: color,
                size: ArenaSpacingTokens.arenaGuideStepGlyph,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Padding(
            padding: ArenaSpacingTokens.arenaGuideStepTextPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    _SmallBadge(label: 'Bước ${step.step}', color: color),
                    Text(
                      step.title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  step.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _guideStepBodyLineRatio,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                _GuideTipCallout(text: step.tip, color: color),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GuideFooter extends StatelessWidget {
  const _GuideFooter({required this.onRules});

  final VoidCallback onRules;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCommunityRulesLink(onTap: onRules),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Text(
          'Arena Points chỉ dùng trong Open Arena — completion và fair play, không phải tài sản tài chính.',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _StartCard extends StatelessWidget {
  const _StartCard({required this.mode, required this.onPressed});

  final _GuideMode mode;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final creating = mode == _GuideMode.create;
    return VitCard(
      borderColor: AppColors.primary20,
      padding: ArenaSpacingTokens.arenaPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: ArenaSpacingTokens.arenaGuideStartIconBox,
                height: ArenaSpacingTokens.arenaGuideStartIconBox,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.primary12,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.bolt_outlined,
                      color: AppColors.primary,
                      size: ArenaSpacingTokens.arenaGuideStartGlyph,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sẵn sàng bắt đầu!',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      creating
                          ? 'Tạo challenge đầu tiên của bạn'
                          : 'Khám phá challenge đang mở',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            key: ArenaGuidePage.ctaKey,
            onPressed: onPressed,
            child: Text(creating ? 'Tạo challenge ngay' : 'Khám phá challenge'),
          ),
        ],
      ),
    );
  }
}
