import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';

/// SEC-S45 (A-Plus GĐ3): trang lỗi điều hướng dùng cho `errorBuilder` của
/// GoRouter — thay ErrorScreen mặc định TIẾNG ANH của go_router bằng copy
/// tiếng Việt chuẩn sản phẩm. Hiện khi route không khớp (deep link sai,
/// nội dung đã gỡ). Độc lập shell/bottom-nav — người dùng thoát bằng CTA
/// về trang chủ.
class VitRouteErrorPage extends StatelessWidget {
  const VitRouteErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bg,
      child: SafeArea(
        child: Center(
          child: VitErrorState(
            title: 'Không tìm thấy trang',
            message: 'Liên kết không hợp lệ hoặc nội dung đã bị gỡ.',
            icon: Icons.explore_off_rounded,
            actionLabel: 'Về trang chủ',
            onAction: () => context.go(AppRoutePaths.home),
          ),
        ),
      ),
    );
  }
}

/// SEC-S45: lấy path param BẮT BUỘC của một route đã match.
///
/// Với route đã khai `:key` trong path, go_router luôn cung cấp param khi
/// match — thiếu param ở đây chỉ có thể là LỖI LẬP TRÌNH (goNamed thiếu
/// pathParameters, gọi builder tay trong test với state thiếu). Fail-loud
/// bằng [StateError] thay vì fallback sang một thực thể demo
/// (`?? 'p2p001'`...) — fallback demo từng che giấu lỗi điều hướng và render
/// dữ liệu KHÔNG PHẢI của thực thể người dùng yêu cầu trong các luồng tài
/// chính (dispute, lệnh, khiếu nại). Guardrail:
/// test/quality/route_param_fallback_guardrail_test.dart.
String requireRouteParam(GoRouterState state, String key) {
  final value = state.pathParameters[key];
  if (value == null || value.isEmpty) {
    throw StateError(
      'Thiếu path param bắt buộc "$key" cho route ${state.uri} — '
      'kiểm tra lời gọi điều hướng (goNamed/pathParameters).',
    );
  }
  return value;
}
