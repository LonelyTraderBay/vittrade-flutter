import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/home_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet presentation of the «Xem thêm (+N)» catalog: bottom sheet chuẩn
/// (Bottom-Sheet-Standard — neo đáy, pop-over cap 480dp tự động từ
/// wrapper) listing the catalog as compact rows (icon + label + badge on
/// one scan line) — cùng khuôn sheet "Thêm công cụ" của Markets/Arena:
/// mọi mô-đal "danh mục tràn" trên tablet là một kiểu duy nhất. Phone giữ
/// sheet riêng (`HomeMoreProductsSheet`); hàng compact là contract chung.
class HomeMoreProductsTabletSheet extends StatelessWidget {
  const HomeMoreProductsTabletSheet({
    super.key,
    required this.actions,
    required this.onNavigate,
  });

  /// Same key value the phone page exposes as `moreProductsSheetKey` — kept
  /// identical so surface-agnostic tests find the catalog regardless of
  /// which surface (or presentation) opened it.
  static const Key sheetKey = Key('sc007_home_more_products_sheet');

  final List<HomeQuickAction> actions;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      key: sheetKey,
      title: 'Tất cả sản phẩm',
      footer: VitCtaButton(
        onPressed: () => Navigator.of(context).pop(),
        variant: VitCtaButtonVariant.secondary,
        child: const Text('Đóng'),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final action in actions)
              Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                  vertical: TabletSpacingTokens.x1,
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
    );
  }
}
