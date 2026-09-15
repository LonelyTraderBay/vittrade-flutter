import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Small centered pill used as the drag-handle indicator at the top of a
/// bottom sheet.
class VitSheetHandle extends StatelessWidget {
  const VitSheetHandle({
    super.key,
    this.width = SharedSpacingTokens.homeMoreProductsSheetHandleWidth,
    this.height = SharedSpacingTokens.homeMoreProductsSheetHandleHeight,
    this.color = AppColors.borderSolid,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.pillRadius,
            ),
          ),
        ),
      ),
    );
  }
}

/// Standard bottom sheet body chrome: drag handle, title, a height-clamped,
/// flexible content area for [child], and an optional pinned [footer] that
/// never scrolls with the content (Divider hairline above it — same idiom
/// as `MarketsPaneScaffold.footer`).
///
/// Chiều cao qua [maxHeightFactor] theo 3 tier của Bottom-Sheet-Standard
/// (tablet): `sheetHeightFactorCompact` 0.40 cho notice ngắn,
/// `sheetHeightFactorStandard` 0.60 mặc định, `sheetHeightFactorTall` 0.85
/// cho form nhiều bước. Không truyền = default theo surface.
class VitSheetPanel extends StatelessWidget {
  const VitSheetPanel({
    super.key,
    required this.title,
    required this.child,
    this.maxHeightFactor,
    this.footer,
  });

  final String title;
  final Widget child;
  final double? maxHeightFactor;

  /// Dải ghim dưới (CTA xác nhận/hủy…) — Divider hairline phía trên, không
  /// cuộn theo nội dung. Null = không có.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final resolvedMaxHeightFactor =
        maxHeightFactor ?? AppSurfaceSpacing.sheetPanelMaxHeightFactor;
    final maxHeight =
        MediaQuery.sizeOf(context).height * resolvedMaxHeightFactor;

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: AppSurfaceSpacing.sheetPanelPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const VitSheetHandle(),
              SizedBox(height: AppSurfaceSpacing.x4),
              Text(
                title,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              SizedBox(height: AppSurfaceSpacing.x4),
              Flexible(child: child),
              if (footer != null) ...[
                SizedBox(height: AppSurfaceSpacing.x4),
                Divider(
                  height: AppSurfaceSpacing.dividerHairline,
                  thickness: AppSurfaceSpacing.dividerHairline,
                  color: AppColors.divider,
                ),
                SizedBox(height: AppSurfaceSpacing.x4),
                footer!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Lưới 2 cột chuẩn cho nội dung sheet: bề rộng ô tính từ **bề rộng thật
/// của sheet** (LayoutBuilder), không bao giờ từ `MediaQuery.sizeOf` — nhờ
/// vậy ô không tràn khi sheet bị pop-over cap 480dp trên tablet.
class VitSheetTwoColGrid extends StatelessWidget {
  const VitSheetTwoColGrid({super.key, required this.children, this.spacing});

  final List<Widget> children;

  /// Khoảng cách ngang/dọc giữa các ô; mặc định x3 (12dp tablet / 8dp
  /// phone theo surface).
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final gap = spacing ?? AppSurfaceSpacing.x3;
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final child in children)
              SizedBox(width: tileWidth, child: child),
          ],
        );
      },
    );
  }
}

/// Rounded-top colored surface (padding + top corner radius) used as a
/// bottom sheet's outer container.
class VitSheetSurface extends StatelessWidget {
  const VitSheetSurface({
    super.key,
    required this.child,
    this.padding = SharedSpacingTokens.homeMoreProductsSheetPadding,
    this.color = AppColors.bg,
    this.borderRadius = AppRadii.sheetTopLargeRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
