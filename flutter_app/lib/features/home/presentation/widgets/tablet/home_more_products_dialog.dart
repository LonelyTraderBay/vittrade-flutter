import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_module_components.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet presentation of the «Xem thêm (+N)» catalog: a centered dialog
/// listing the catalog as compact rows (icon + label + badge on one scan
/// line) — denser and shorter than a tile grid, matching the sidebar's row
/// idiom. Phone keeps the bottom-sheet presentation
/// (`HomeMoreProductsSheet`) — each surface owns its modality, the flat
/// catalog shape is the shared contract.
///
/// Dialog chrome follows the house style of `showVitConfirmDialog`
/// (`AlertDialog` + `AppColors.surface` + `AppRadii.cardRadius`).
class HomeMoreProductsDialog extends StatelessWidget {
  const HomeMoreProductsDialog({
    super.key,
    required this.actions,
    required this.onNavigate,
  });

  /// Same key value the phone page exposes as `moreProductsSheetKey` — kept
  /// identical so surface-agnostic tests find the catalog regardless of
  /// which surface (or presentation) opened it.
  static const Key dialogKey = Key('sc007_home_more_products_sheet');

  final List<HomeQuickAction> actions;
  final ValueChanged<String> onNavigate;

  /// One scan line per row at compact density — deliberately narrower than
  /// the old tile grid so the dialog reads as a compact command list.
  static const double _contentWidth = 440;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: dialogKey,
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      title: Text(
        'Thêm hành động',
        style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
      ),
      content: SizedBox(
        width: _contentWidth,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final action in actions)
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    vertical: AppSpacing.x1,
                  ),
                  child: buildHomeQuickActionTile(
                    action,
                    VitServiceTileDensity.compact,
                    onNavigate,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
