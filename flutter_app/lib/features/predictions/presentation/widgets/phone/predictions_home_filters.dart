part of '../../phone/pages/hub/predictions_home_page.dart';

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitSearchBar(
      key: PredictionsHomePage.searchFieldKey,
      controller: controller,
      placeholder: 'Tìm sự kiện...',
      onChanged: onChanged,
      onClear: onClear,
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String? activeCategory;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          VitFilterChip(
            key: PredictionsHomePage.categoryAllKey,
            label: 'Tất cả',
            active: activeCategory == null,
            onTap: () => onSelected(null),
            color: _marketPrimary,
            padding: PredictionsSpacingTokens.predictionHomeCategoryPadding,
          ),
          const SizedBox(width: AppSpacing.x2),
          for (var index = 0; index < categories.length; index += 1) ...[
            VitFilterChip(
              key: categories[index] == 'Live Crypto'
                  ? PredictionsHomePage.categoryLiveCryptoKey
                  : Key('sc027_category_${categories[index]}'),
              label: categories[index],
              active: activeCategory == categories[index],
              onTap: () => onSelected(
                activeCategory == categories[index] ? null : categories[index],
              ),
              color: _marketPrimary,
              padding: PredictionsSpacingTokens.predictionHomeCategoryPadding,
            ),
            if (index != categories.length - 1)
              const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}
