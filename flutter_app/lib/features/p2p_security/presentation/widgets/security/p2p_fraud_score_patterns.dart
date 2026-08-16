part of '../../phone/pages/security/p2p_fraud_prevention_page.dart';

class _SafetyScoreCard extends StatelessWidget {
  const _SafetyScoreCard({
    required this.score,
    required this.checkedCount,
    required this.totalCount,
  });

  final int score;
  final int checkedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(score);

    return VitCard(
      key: P2PFraudPreventionPage.scoreKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pFraudCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: color,
                size: P2PSpacingTokens.p2pFraudHeaderIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Chỉ số an toàn',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '$score%',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: _p2pFraudMajorGap),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: P2PSpacingTokens.p2pFraudProgressHeight,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: _p2pFraudSectionGap),
          Text(
            '$checkedCount/$totalCount biện pháp bảo vệ đã áp dụng',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          if (score < 100) ...[
            const SizedBox(height: _p2pFraudSectionGap),
            Material(
              color: AppColors.warn10,
              borderRadius: AppRadii.lgRadius,
              child: Padding(
                padding: P2PSpacingTokens.p2pFraudInnerPadding,
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warn,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        'Hoàn thành checklist bên dưới để tăng chỉ số an toàn',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.warn,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PatternSection extends StatelessWidget {
  const _PatternSection({
    required this.patterns,
    required this.expandedPatternId,
    required this.onToggle,
  });

  final List<P2PScamPatternDraft> patterns;
  final String? expandedPatternId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PFraudPreventionPage.patternsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.gpp_bad_outlined,
              color: AppColors.sell,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                'Các hình thức gian lận phổ biến',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: _p2pFraudMajorGap),
        for (var index = 0; index < patterns.length; index++) ...[
          _PatternCard(
            pattern: patterns[index],
            expanded: expandedPatternId == patterns[index].id,
            onTap: () => onToggle(patterns[index].id),
          ),
          if (index != patterns.length - 1)
            const SizedBox(height: _p2pFraudSectionGap),
        ],
      ],
    );
  }
}

class _PatternCard extends StatelessWidget {
  const _PatternCard({
    required this.pattern,
    required this.expanded,
    required this.onTap,
  });

  final P2PScamPatternDraft pattern;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(pattern.severity);

    return VitCard(
      key: P2PFraudPreventionPage.patternKey(pattern.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.zeroInsets,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: P2PSpacingTokens.p2pFraudPatternPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox.square(
                  dimension: _p2pFraudPatternIconBox,
                  child: Material(
                    color: color.withValues(alpha: .12),
                    borderRadius: AppRadii.lgRadius,
                    child: Icon(_patternIcon(pattern.iconKey), color: color),
                  ),
                ),
                const SizedBox(width: _p2pFraudMajorGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              pattern.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.x2),
                          _SeverityBadge(severity: pattern.severity),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        pattern.description,
                        maxLines: expanded ? null : 2,
                        overflow: expanded ? null : TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          height: _p2pFraudBodyLineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                AnimatedRotation(
                  turns: expanded ? .5 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
                ),
              ],
            ),
          ),
          if (expanded) _ExpandedPattern(pattern: pattern),
        ],
      ),
    );
  }
}

class _ExpandedPattern extends StatelessWidget {
  const _ExpandedPattern({required this.pattern});

  final P2PScamPatternDraft pattern;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: AppSpacing.dividerHairline,
          child: ColoredBox(color: AppColors.divider),
        ),
        Padding(
          padding: P2PSpacingTokens.p2pFraudPatternPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DetailList(
                title: 'CÁCH THỨC HOẠT ĐỘNG',
                items: pattern.howItWorks,
                color: AppColors.text2,
                numbered: true,
              ),
              const SizedBox(height: _p2pFraudMajorGap),
              _DetailList(
                title: 'DẤU HIỆU NHẬN BIẾT',
                items: pattern.redFlags,
                color: AppColors.sell,
                icon: Icons.error_outline_rounded,
              ),
              const SizedBox(height: _p2pFraudMajorGap),
              _DetailList(
                title: 'CÁCH PHÒNG TRÁNH',
                items: pattern.prevention,
                color: AppColors.buy,
                icon: Icons.check_circle_outline_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailList extends StatelessWidget {
  const _DetailList({
    required this.title,
    required this.items,
    required this.color,
    this.numbered = false,
    this.icon,
  });

  final String title;
  final List<String> items;
  final Color color;
  final bool numbered;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: _p2pFraudSectionGap),
        for (var index = 0; index < items.length; index++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (numbered)
                SizedBox.square(
                  dimension: P2PSpacingTokens.p2pFraudChecklistBox,
                  child: Material(
                    color: AppColors.surface2,
                    shape: const CircleBorder(),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Icon(
                  icon,
                  color: color,
                  size: P2PSpacingTokens.p2pFraudDetailIcon,
                ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  items[index],
                  style: AppTextStyles.caption.copyWith(
                    color: color == AppColors.text2 ? AppColors.text2 : color,
                    height: _p2pFraudBodyLineHeight,
                  ),
                ),
              ),
            ],
          ),
          if (index != items.length - 1)
            const SizedBox(height: _p2pFraudSectionGap),
        ],
      ],
    );
  }
}
