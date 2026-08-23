// Guardrail: Tablet orientation policy (docs/02_FLUTTER_MIGRATION/standards/
// Tablet-Adaptive-Standard.md — mục "Orientation policy").
//
// Tablet hỗ trợ CẢ HAI hướng xoay với 0 chỗ dispatch theo orientation (R1c —
// nửa tĩnh đã khóa tuyệt đối bởi tool/tablet_route_surface_audit.dart).
// Guardrail này khóa nửa hành vi: xoay một root đã có composition tablet
// giữa portrait ↔ landscape phải RELAYOUT KHÔNG LỖI LAYOUT, vẫn còn đúng
// MỘT navigation rail trong khung, và nội dung semantic của route vẫn
// hiện — mỗi cặp xoay chạy KHỨ HỒI, nên trang sống được portrait→landscape
// nhưng hỏng trên đường quay lại (hoặc mất composition sau relayout) sẽ
// đỏ ở đây thay vì trên máy thật.
//
// Hai cặp xoay phủ hai họ nguy cơ: portrait→landscape hẹp chiều cao
// (834×1112 → 1112×834 — banner/hero cao đủ ăn cột làm việc) và
// landscape→portrait hẹp chiều rộng (1280×800 → 800×1280 — hai cột 900+
// rơi về fallback một cột <900).
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';

void main() {
  for (final rotation in _rotationPairs) {
    testWidgets('tablet roots survive rotation ${rotation.label} and back', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      final failures = <String>[];
      for (final route in _tabletComposedRoots) {
        await _rotateRoute(tester, rotation, route, failures);
      }

      if (failures.isNotEmpty) {
        fail(
          'Tablet rotation guardrail failures for ${rotation.label}:\n'
          '${failures.join('\n')}',
        );
      }
    });
  }
}

Future<void> _rotateRoute(
  WidgetTester tester,
  _RotationPair rotation,
  _TabletRoute route,
  List<String> failures,
) async {
  final errors = <FlutterErrorDetails>[];
  final previousOnError = FlutterError.onError;
  FlutterError.onError = errors.add;

  try {
    tester.view.physicalSize = rotation.from;
    await tester.pumpWidget(
      VitTradeApp(
        routerConfig: createAppRouter(
          surface: AppSurface.tablet,
          initialLocation: route.location,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 50),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 3),
    );
    _verifyStop(
      tester,
      rotation,
      route,
      'before rotation',
      rotation.from,
      failures,
    );

    // Xoay: chỉ đổi kích thước view rồi pump — cây widget KHÔNG được tạo lại,
    // nên đây là relayout thật như xoay máy (state của router/shell phải sống).
    tester.view.physicalSize = rotation.to;
    await tester.pump();
    await tester.pumpAndSettle(
      const Duration(milliseconds: 50),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 3),
    );
    _verifyStop(
      tester,
      rotation,
      route,
      'after rotation',
      rotation.to,
      failures,
    );

    // Khứ hồi: xoay về hướng ban đầu — relayout lần hai không được vỡ.
    tester.view.physicalSize = rotation.from;
    await tester.pump();
    await tester.pumpAndSettle(
      const Duration(milliseconds: 50),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 3),
    );
    _verifyStop(
      tester,
      rotation,
      route,
      'after round trip',
      rotation.from,
      failures,
    );
  } catch (error) {
    failures.add('- ${route.name} ${rotation.label}: threw $error');
  } finally {
    FlutterError.onError = previousOnError;
  }

  Object? exception = tester.takeException();
  while (exception != null) {
    failures.add('- ${route.name} ${rotation.label}: exception $exception');
    exception = tester.takeException();
  }

  if (errors.isNotEmpty) {
    failures.addAll(
      errors.map(
        (details) =>
            '- ${route.name} ${rotation.label}: '
            '${details.toString().split('\n').first}',
      ),
    );
  }

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

void _verifyStop(
  WidgetTester tester,
  _RotationPair rotation,
  _TabletRoute route,
  String stopLabel,
  Size stopSize,
  List<String> failures,
) {
  final semantics = find.byWidgetPredicate(
    (widget) =>
        widget is Semantics && widget.properties.label == route.semanticLabel,
    description: route.semanticLabel,
  );
  if (semantics.evaluate().isEmpty) {
    failures.add(
      '- ${route.name} ${rotation.label} ($stopLabel): missing '
      '${route.semanticLabel}',
    );
  }

  // Sau relayout, TabletAppShell vẫn phải render đúng MỘT VitNavigationRail
  // nằm trọn trong khung — không phải hai rail, không rail tràn.
  final rail = find.byType(VitNavigationRail);
  final railCount = rail.evaluate().length;
  if (railCount != 1) {
    failures.add(
      '- ${route.name} ${rotation.label} ($stopLabel): expected one '
      'navigation rail, found $railCount',
    );
  } else {
    final railRect = tester.getRect(rail);
    if (railRect.left < -0.5 ||
        railRect.right > stopSize.width + 0.5 ||
        railRect.bottom > stopSize.height + 0.5) {
      failures.add(
        '- ${route.name} ${rotation.label} ($stopLabel): navigation rail '
        'clipped (${railRect.left.toStringAsFixed(1)}, '
        '${railRect.top.toStringAsFixed(1)}, '
        '${railRect.right.toStringAsFixed(1)}, '
        '${railRect.bottom.toStringAsFixed(1)})',
      );
    }
  }
}

/// Cặp xoay — mỗi cặp là một test độc lập; cả hai hướng đều là viewport
/// tablet (≥ AppBreakpoints.tablet theo chiều rộng) nên surface không đổi.
const _rotationPairs = [
  _RotationPair(
    '834x1112 -> 1112x834 (portrait -> landscape)',
    Size(834, 1112),
    Size(1112, 834),
  ),
  _RotationPair(
    '1280x800 -> 800x1280 (landscape -> portrait)',
    Size(1280, 800),
    Size(800, 1280),
  ),
];

/// Các root đã có composition tablet thật (hasTabletComposition trong
/// responsive_visual_qa_matrix_test) — đặt chung một nguồn danh sách bằng
/// comment ở hai file; thêm root tablet mới thì thêm vào CẢ HAI.
const _tabletComposedRoots = [
  _TabletRoute('Home', AppRoutePaths.home, 'Trang chủ'),
  _TabletRoute('Markets', AppRoutePaths.markets, 'Thị trường'),
  _TabletRoute('Trade', AppRoutePaths.trade, 'Giao dịch Spot'),
  _TabletRoute(
    'Order Receipt',
    AppRoutePaths.tradeOrderReceipt,
    'Chi tiết lệnh giao dịch',
  ),
  _TabletRoute(
    'Wallet',
    AppRoutePaths.wallet,
    'Ví - số dư minh bạch, bảo mật đa lớp',
  ),
  _TabletRoute(
    'Profile',
    AppRoutePaths.profile,
    'Trang tài khoản: hồ sơ cá nhân, giới thiệu bạn bè và VIP',
  ),
];

class _RotationPair {
  const _RotationPair(this.label, this.from, this.to);

  final String label;
  final Size from;
  final Size to;
}

class _TabletRoute {
  const _TabletRoute(this.name, this.location, this.semanticLabel);

  final String name;
  final String location;
  final String semanticLabel;
}
