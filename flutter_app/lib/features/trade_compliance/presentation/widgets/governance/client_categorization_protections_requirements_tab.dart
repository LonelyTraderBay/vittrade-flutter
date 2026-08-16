part of '../../phone/pages/governance/client_categorization_page.dart';

class _ProtectionsTab extends StatelessWidget {
  const _ProtectionsTab({required this.categories});

  final List<TradeClientCategoryInfo> categories;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'So sánh bảo vệ',
      density: VitDensity.tool,
      children: [
        for (final category in categories)
          _ListCard(category: category, values: category.protections),
      ],
    );
  }
}

class _RequirementsTab extends StatelessWidget {
  const _RequirementsTab({required this.categories});

  final List<TradeClientCategoryInfo> categories;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Yêu cầu đủ điều kiện',
      density: VitDensity.tool,
      children: [
        for (final category in categories)
          _ListCard(
            category: category,
            values: category.requirements,
            requirementMode: true,
          ),
      ],
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.category,
    required this.values,
    this.requirementMode = false,
  });

  final TradeClientCategoryInfo category;
  final List<String> values;
  final bool requirementMode;

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyle(category.id);
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      child: VitPageContent(
        rhythm: VitPageRhythm.standard,
        padding: VitContentPadding.none,
        fullBleed: true,
        density: VitDensity.tool,
        children: [
          Row(
            children: [
              Icon(
                Icons.square_rounded,
                color: style.color,
                size: TradeSpacingTokens.tradeBotClientMarker,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                category.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          for (final value in values)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  requirementMode
                      ? Icons.track_changes_outlined
                      : Icons.check_circle_outline,
                  color: requirementMode ? AppColors.text3 : style.color,
                  size: AppSpacing.x4,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
