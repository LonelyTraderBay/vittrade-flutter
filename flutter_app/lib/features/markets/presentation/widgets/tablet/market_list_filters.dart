import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

const double _marketCategoryCompactHeight = AppSpacing.buttonCompact;
const EdgeInsets _marketFilterCompactPadding =
    MarketsSpacingTokens.marketListFilterCompactPadding;

// Sorting moved onto the pair table's column headers
// (`MarketListTableHeader`) — the phone-only sort chip sheet has no tablet
// counterpart anymore.

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
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.x4),
        itemBuilder: (context, index) {
          final category = categories[index];
          return VitFilterChip(
            key: MarketsTabletKeys.category(category),
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
