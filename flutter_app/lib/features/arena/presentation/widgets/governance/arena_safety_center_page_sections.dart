part of '../../phone/pages/governance/arena_safety_center_page.dart';

class _SafetyHero extends StatelessWidget {
  const _SafetyHero({required this.snapshot});

  final ArenaSafetyCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.buy,
      density: VitDensity.compact,
      child: Row(
        children: [
          const _ToneIcon(icon: Icons.shield_outlined, color: AppColors.buy),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.bannerTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.bannerDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _safetyNoticeLineHeight,
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

class _SafetySection extends StatelessWidget {
  const _SafetySection({
    required this.title,
    required this.accentColor,
    required this.children,
  });

  final String title;
  final Color accentColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              width: _safetyMarkerWidth,
              height: _safetyMarkerHeight,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: accentColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: _safetySectionTitleLineHeight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final child in children) ...[
          child,
          if (child != children.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({super.key, required this.rule});

  final ArenaSafetyRuleDraft rule;

  @override
  Widget build(BuildContext context) {
    final color = _kindColor(rule.kind);
    return VitCard(
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToneIcon(icon: _kindIcon(rule.kind), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  rule.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _safetyBodyLineHeight,
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

class _BannedContentCard extends StatelessWidget {
  const _BannedContentCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  size: _safetySmallIcon,
                  color: AppColors.sell,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      height: _safetyBodyLineHeight,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _ViolationProcessCard extends StatelessWidget {
  const _ViolationProcessCard({required this.items});

  final List<ArenaSafetyProcessDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          for (final item in items)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: _safetyProcessColumnWidth,
                  child: Column(
                    children: [
                      SizedBox.square(
                        dimension: _safetyProcessStepBox,
                        child: DecoratedBox(
                          decoration: const ShapeDecoration(
                            color: AppColors.buy10,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xlRadius,
                              side: BorderSide(color: AppColors.buy20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${item.step}',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.buy,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (item != items.last)
                        const SizedBox(
                          width: _safetyProcessLineWidth,
                          height: _safetyProcessLineHeight,
                          child: ColoredBox(color: AppColors.buy20),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      bottom: item == items.last ? 0 : AppSpacing.x3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          item.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: _safetyNoticeLineHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.info});

  final ArenaSafetyInfoDraft info;

  @override
  Widget build(BuildContext context) {
    final color = _kindColor(info.kind);
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_kindIcon(info.kind), color: color, size: _safetyInfoIcon),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      info.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: _safetyNoticeLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(height: _safetyDividerHeight, color: AppColors.divider),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final item in info.items) ...[
            _SafetyCheckRow(item: item),
            if (item != info.items.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _SafetyCheckRow extends StatelessWidget {
  const _SafetyCheckRow({required this.item});

  final ArenaSafetyCheckDraft item;

  @override
  Widget build(BuildContext context) {
    final color = item.allowed ? AppColors.buy : AppColors.sell;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          item.allowed ? Icons.check_circle_outline : Icons.cancel_outlined,
          color: color,
          size: _safetySmallIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            item.text,
            style: AppTextStyles.caption.copyWith(
              color: item.allowed ? AppColors.text1 : AppColors.text2,
              height: _safetyCheckLineHeight,
            ),
          ),
        ),
      ],
    );
  }
}
