import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Flat catalog sheet — no group headers on Home or in this sheet. Phone
/// presentation; the tablet surface opens the same flat catalog as a
/// centered dialog (`HomeMoreProductsDialog`). The catalog shape is the
/// shared contract, the modality is per-surface.
class HomeMoreProductsSheet extends StatelessWidget {
  const HomeMoreProductsSheet({
    super.key,
    required this.actions,
    required this.onNavigate,
    required this.density,
  });

  /// Same key value the phone page exposes as
  /// `HomePage.moreProductsSheetKey` — kept identical so surface-agnostic
  /// tests can find the sheet regardless of which page opened it.
  static const Key sheetKey = Key('sc007_home_more_products_sheet');

  final List<HomeQuickAction> actions;
  final ValueChanged<String> onNavigate;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      key: sheetKey,
      title: 'Thêm hành động',
      child: VitActionTileGrid(
        density: density,
        crossAxisSpacing: AppSpacing.x3,
        mainAxisSpacing: AppSpacing.x3,
        physics: const ClampingScrollPhysics(),
        itemCount: actions.length,
        itemBuilder: (context, index, tileDensity) {
          return buildHomeQuickActionTile(
            actions[index],
            tileDensity,
            onNavigate,
          );
        },
      ),
    );
  }
}
