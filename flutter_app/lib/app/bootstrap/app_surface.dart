import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';

/// Presentation surface được chọn ở composition root.
///
/// Surface là boundary triển khai UI, không phải business context. Vì vậy
/// cùng một feature/domain contract có thể có ba composition khác nhau mà
/// không cần nhân bản nghiệp vụ.
enum AppSurface { phone, tablet, web }

/// Quy tắc chọn surface thuần, có thể kiểm thử mà không cần dựng widget tree.
final class AppSurfaceResolver {
  const AppSurfaceResolver._();

  static AppSurface resolve({
    required double viewportWidth,
    required bool isWeb,
  }) {
    if (isWeb) return AppSurface.web;
    return AppBreakpoints.isTablet(viewportWidth)
        ? AppSurface.tablet
        : AppSurface.phone;
  }
}
