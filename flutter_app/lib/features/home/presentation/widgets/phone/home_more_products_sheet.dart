// Phone-specific home product sheet.
import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/phone/home_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Flat catalog sheet — no group headers on Home or in this sheet.
class HomeMoreProductsSheet extends StatelessWidget {
  const HomeMoreProductsSheet({
    super.key,
    required this.actions,
    required this.onNavigate,
    required this.density,
  });

  final List<HomeQuickAction> actions;
  final ValueChanged<String> onNavigate;
  final VitDensity density;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      key: HomePage.moreProductsSheetKey,
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
