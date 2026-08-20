import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/tablet/home_tablet_keys.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Primary quick-action grid only. Full catalog opens via «Xem thêm».
class HomeProductsSection extends StatelessWidget {
  const HomeProductsSection({
    super.key,
    required this.quickActions,
    required this.maxVisibleQuickActions,
    required this.moreActionCount,
    required this.onNavigate,
    required this.onMore,
    required this.density,
  });

  final List<HomeQuickAction> quickActions;
  final int maxVisibleQuickActions;
  final int moreActionCount;
  final ValueChanged<String> onNavigate;
  final VoidCallback? onMore;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: HomeTabletKeys.productsSection,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(
          title: 'Hành động nhanh',
          bottomGap: AppSpacing.pageRhythmCompactInnerGap,
          actionLabel: moreActionCount <= 0
              ? null
              : 'Xem thêm (+$moreActionCount)',
          actionSemanticLabel: 'Xem thêm $moreActionCount hành động khác',
          onAction: onMore,
          density: density,
        ),
        HomeQuickActionsGrid(
          actions: quickActions,
          maxVisibleItems: maxVisibleQuickActions,
          onNavigate: onNavigate,
          density: density,
        ),
      ],
    );
  }
}

class HomeQuickActionsGrid extends StatelessWidget {
  const HomeQuickActionsGrid({
    super.key,
    required this.actions,
    required this.maxVisibleItems,
    required this.onNavigate,
    required this.density,
  });

  final List<HomeQuickAction> actions;
  final int maxVisibleItems;
  final ValueChanged<String> onNavigate;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const VitEmptyState(
        title: 'Chưa có sản phẩm nào',
        message: 'Danh sách sản phẩm sẽ sớm xuất hiện ở đây.',
        icon: Icons.grid_view_rounded,
      );
    }
    return VitActionTileGrid(
      density: density,
      itemCount: actions.length,
      maxVisibleItems: maxVisibleItems,
      crossAxisCount: AppSpacing.serviceTileCrossAxisCount,
      itemBuilder: (context, index, tileDensity) {
        return buildHomeQuickActionTile(
          actions[index],
          tileDensity,
          onNavigate,
        );
      },
    );
  }
}
