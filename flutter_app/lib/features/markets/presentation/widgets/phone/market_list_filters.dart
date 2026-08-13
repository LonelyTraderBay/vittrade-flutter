// Phone-specific Markets filters.
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/markets/domain/entities/market_entities.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/phone/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

const double _marketCategoryCompactHeight = AppSpacing.buttonCompact;
const double _marketCategoryCompactGap = AppSpacing.x2;
const EdgeInsets _marketFilterCompactPadding =
    MarketsSpacingTokens.marketListFilterCompactPadding;

class MarketListSortSheet extends StatelessWidget {
  const MarketListSortSheet({
    super.key,
    required this.sortOptions,
    required this.activeSort,
    required this.onSelected,
  });

  final List<MarketSortOption> sortOptions;
  final String activeSort;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: MarketsSpacingTokens.marketFilterSheetPadding,
      child: Wrap(
        spacing: MarketsSpacingTokens.marketFilterGap,
        runSpacing: MarketsSpacingTokens.marketFilterGap,
        children: [
          for (final option in sortOptions)
            VitFilterChip(
              label: option.label,
              active: option.id == activeSort,
              onTap: () => onSelected(option.id),
              color: marketListPrimary,
              height: _marketCategoryCompactHeight,
              padding: _marketFilterCompactPadding,
            ),
        ],
      ),
    );
  }
}

class MarketListCategoryTabs extends StatelessWidget {
  const MarketListCategoryTabs({
    super.key,
    required this.categories,
    required this.activeCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _marketCategoryCompactHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: categories.length,
        separatorBuilder: (_, _) =>
            const SizedBox(width: _marketCategoryCompactGap),
        itemBuilder: (context, index) {
          final category = categories[index];
          return VitFilterChip(
            key: MarketListKeys.category(category),
            label: category,
            active: category == activeCategory,
            color: marketListPrimary,
            height: _marketCategoryCompactHeight,
            padding: _marketFilterCompactPadding,
            onTap: () => onSelected(category),
          );
        },
      ),
    );
  }
}
