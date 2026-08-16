part of '../../phone/pages/safety/copy_education_page.dart';

class _EducationTabs extends StatelessWidget {
  const _EducationTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<TradeCopyEducationTab> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: TradeSpacingTokens.copyEducationTabHeight,
      child: ColoredBox(
        color: AppColors.surface,
        child: VitTabBar(
          activeKey: active,
          onChanged: onChanged,
          variant: VitTabBarVariant.underline,
          tabs: [
            for (final tab in tabs)
              VitTabItem(
                key: tab.id,
                label: _tabLabel(tab),
                widgetKey: CopyEducationPage.tabKey(tab.id),
              ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksContent extends StatelessWidget {
  const _HowItWorksContent({required this.snapshot});

  final TradeCopyEducationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepsCard(steps: snapshot.steps),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _CopyModesCard(modes: snapshot.copyModes),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        _ConceptsCard(concepts: snapshot.concepts),
      ],
    );
  }
}

class _StepsCard extends StatelessWidget {
  const _StepsCard({required this.steps});

  final List<TradeCopyEducationStep> steps;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Copy Trading hoạt động như thế nào?',
            style: AppTextStyles.baseMedium,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final step in steps) ...[
            _StepRow(step: step),
            if (step != steps.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final TradeCopyEducationStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: AppSpacing.iconLg,
          child: Padding(
            padding: TradeSpacingTokens.copyEducationStepNumberPadding,
            child: Text(
              '${step.number}',
              textAlign: TextAlign.center,
              style: AppTextStyles.baseMedium.copyWith(color: _copyPrimary),
            ),
          ),
        ),
        const SizedBox(width: WalletSpacingTokens.walletAddressFilterGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _iconFor(step.iconName),
                    color: AppColors.text1,
                    size: WalletSpacingTokens.walletAddressSectionIcon,
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Text(
                      step.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.tabBarPillVertical),
              Text(
                step.description,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CopyModesCard extends StatelessWidget {
  const _CopyModesCard({required this.modes});

  final List<TradeCopyModeGuide> modes;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Các chế độ sao chép', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final mode in modes) ...[
            _CopyModeTile(mode: mode),
            if (mode != modes.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          ],
        ],
      ),
    );
  }
}

class _CopyModeTile extends StatelessWidget {
  const _CopyModeTile({required this.mode});

  final TradeCopyModeGuide mode;

  @override
  Widget build(BuildContext context) {
    final color = Color(mode.colorHex);
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      constraints: const BoxConstraints(
        minHeight: TradeSpacingTokens.copyEducationModeMinHeight,
      ),
      padding: AppSpacing.cardPaddingCompact,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VitAssetAvatar(
                label: '',
                accentColor: color,
                size: AppSpacing.x3,
                radius: AppRadii.avatarRadius,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                mode.title,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            mode.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SmallGuideLine(
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  text: mode.pro,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SmallGuideLine(
                  icon: Icons.cancel_outlined,
                  color: AppColors.sell,
                  text: mode.con,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConceptsCard extends StatelessWidget {
  const _ConceptsCard({required this.concepts});

  final List<TradeCopyConceptGuide> concepts;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Khái niệm quan trọng', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final concept in concepts) ...[
            _ConceptRow(concept: concept),
            if (concept != concepts.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}
