import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';

/// Wrapper bắt buộc cho mọi bottom sheet trong app (xem
/// Bottom-Sheet-Standard.md). Ngoài shape/scrim/root-navigator, wrapper còn
/// tự áp **pop-over cap** trên tablet surface: khi `tabletSurfaceActive` bật
/// và caller không tự truyền `constraints`, sheet bị kẹp bề rộng
/// `TabletSpacingTokens.sheetMaxWidth` (480dp) và căn giữa — caller không
/// cần (và không nên) tự tính bề rộng theo viewport.
Future<T?> showVitBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useRootNavigator = true,
  Color? backgroundColor,
  Color? barrierColor,
  ShapeBorder? shape,
  BoxConstraints? constraints,
  bool enableDrag = true,
  bool isDismissible = true,
  bool useSafeArea = false,
}) {
  final effectiveConstraints =
      constraints ??
      (TabletSpacingTokens.tabletSurfaceActive
          ? const BoxConstraints(maxWidth: TabletSpacingTokens.sheetMaxWidth)
          : null);
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    backgroundColor: backgroundColor ?? AppColors.surface,
    barrierColor: barrierColor ?? AppColors.modalScrim,
    shape:
        shape ??
        const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopLargeRadius,
        ),
    constraints: effectiveConstraints,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    useSafeArea: useSafeArea,
    builder: builder,
  );
}
