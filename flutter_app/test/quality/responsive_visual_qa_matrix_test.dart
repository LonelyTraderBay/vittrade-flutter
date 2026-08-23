// Origin: 9048cda4 (2026-05-31) - feat(flutter): hoàn thiện nền tảng enterprise VitTrade
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_breakpoints.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_navigation_rail.dart';

void main() {
  for (final viewport in _responsiveViewports) {
    testWidgets(
      'UI-05 priority routes render without layout errors at ${viewport.label}',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(
          viewport.width.toDouble(),
          viewport.height.toDouble(),
        );
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        final failures = <String>[];
        for (final route in _filteredPriorityRoutes) {
          await _scanRoute(tester, viewport, route, failures);
        }

        if (failures.isNotEmpty) {
          fail(
            'Responsive visual QA failures for ${viewport.label}:\n'
            '${failures.join('\n')}',
          );
        }
      },
    );
  }
}

Future<void> _scanRoute(
  WidgetTester tester,
  _ResponsiveViewport viewport,
  _PriorityRoute route,
  List<String> failures,
) async {
  final errors = <FlutterErrorDetails>[];
  final previousOnError = FlutterError.onError;
  FlutterError.onError = errors.add;

  try {
    // Surface được pin theo viewport (bootstrap resolver dùng cùng ngưỡng
    // AppBreakpoints.tablet) — QA matrix không phụ thuộc compat dispatch.
    final surface = AppBreakpoints.isTablet(viewport.width.toDouble())
        ? AppSurface.tablet
        : AppSurface.phone;
    await tester.pumpWidget(
      VitTradeApp(
        routerConfig: createAppRouter(
          surface: surface,
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

    final semantics = find.byWidgetPredicate(
      (widget) =>
          widget is Semantics && widget.properties.label == route.semanticLabel,
      description: route.semanticLabel,
    );
    // Ở viewport tablet, chỉ các route đã có composition tablet thật expose
    // cùng semantic label như phone. Route còn placeholder
    // (VitTabletUtilityPage/P2PTabletUtilityPage) được đảm nhiệm bởi
    // tablet_utility_route_test.dart — matrix vẫn quét layout error và nav
    // chrome cho mọi route.
    final isTabletViewport = AppBreakpoints.isTablet(viewport.width.toDouble());
    if (!isTabletViewport || route.hasTabletComposition) {
      if (semantics.evaluate().isEmpty) {
        failures.add(
          '- ${route.name} ${viewport.label}: missing ${route.semanticLabel}',
        );
      }
    }

    // Above the tablet breakpoint, TabletAppShell renders VitNavigationRail
    // instead of VitBottomNav — check whichever chrome this viewport should
    // produce, not both at once.
    final navChrome = isTabletViewport
        ? find.byType(VitNavigationRail)
        : find.byType(VitBottomNav);
    final navChromeName = isTabletViewport ? 'navigation rail' : 'bottom nav';
    if (navChrome.evaluate().length != 1) {
      failures.add(
        '- ${route.name} ${viewport.label}: expected one $navChromeName, '
        'found ${navChrome.evaluate().length}',
      );
    } else {
      final navRect = tester.getRect(navChrome);
      if (navRect.left < -0.5 ||
          navRect.right > viewport.width + 0.5 ||
          navRect.bottom > viewport.height + 0.5) {
        failures.add(
          '- ${route.name} ${viewport.label}: $navChromeName clipped '
          '(${navRect.left.toStringAsFixed(1)}, '
          '${navRect.top.toStringAsFixed(1)}, '
          '${navRect.right.toStringAsFixed(1)}, '
          '${navRect.bottom.toStringAsFixed(1)})',
        );
      }
    }
  } catch (error) {
    failures.add('- ${route.name} ${viewport.label}: threw $error');
  } finally {
    FlutterError.onError = previousOnError;
  }

  Object? exception = tester.takeException();
  while (exception != null) {
    failures.add('- ${route.name} ${viewport.label}: exception $exception');
    exception = tester.takeException();
  }

  if (errors.isNotEmpty) {
    failures.addAll(
      errors.map(
        (details) =>
            '- ${route.name} ${viewport.label}: '
            '${_describeFlutterError(details)}',
      ),
    );
  }

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

const _responsiveViewports = [
  _ResponsiveViewport('360x800 minimum phone', 360, 800),
  _ResponsiveViewport('440x956 QA phone', 440, 956),
  _ResponsiveViewport('480x1040 large phone', 480, 1040),
  _ResponsiveViewport('768x1024 minimum tablet', 768, 1024),
  // Tablet layout tiers from the Home tablet reference contract's responsive
  // table: single-column tablet fallback (600–899), two-column at/above the
  // dashboard's own 900 threshold, and the ≥1200 wide tier (centered 800/400
  // block — nothing stretches).
  _ResponsiveViewport('834x1112 portrait tablet fallback', 834, 1112),
  _ResponsiveViewport('1024x768 two-column tablet', 1024, 768),
  _ResponsiveViewport('1280x800 wide tablet', 1280, 800),
];

final _priorityRoutes = [
  const _PriorityRoute(
    'Home',
    AppRoutePaths.home,
    'Trang chủ',
    hasTabletComposition: true,
  ),
  const _PriorityRoute(
    'Markets',
    AppRoutePaths.markets,
    'Thị trường',
    hasTabletComposition: true,
  ),
  _PriorityRoute(
    'Pair Detail',
    AppRoutePaths.pairDetail('btcusdt'),
    'Chi tiết cặp giao dịch',
  ),
  const _PriorityRoute(
    'Trade',
    AppRoutePaths.trade,
    'Giao dịch Spot',
    hasTabletComposition: true,
  ),
  const _PriorityRoute(
    'Orders History',
    AppRoutePaths.tradeOrdersHistory,
    'Lịch sử lệnh giao dịch',
  ),
  const _PriorityRoute(
    'Order Receipt',
    AppRoutePaths.tradeOrderReceipt,
    'Chi tiết lệnh giao dịch',
    hasTabletComposition: true,
  ),
  const _PriorityRoute(
    'Wallet',
    AppRoutePaths.wallet,
    'Ví - số dư minh bạch, bảo mật đa lớp',
    hasTabletComposition: true,
  ),
  _PriorityRoute(
    'Asset Detail',
    AppRoutePaths.walletAsset('btc'),
    'Chi tiết tài sản - số dư minh bạch',
  ),
  _PriorityRoute(
    'Transaction Detail',
    AppRoutePaths.walletTransaction('tx001'),
    'Chi tiết giao dịch',
  ),
  const _PriorityRoute('Deposit', AppRoutePaths.walletDeposit, 'Nạp tiền'),
  const _PriorityRoute(
    'Pending Deposits',
    AppRoutePaths.walletPendingDeposits,
    'Nạp tiền đang chờ xác nhận',
  ),
  const _PriorityRoute(
    'Portfolio Analytics',
    AppRoutePaths.walletPortfolioAnalytics,
    'Phân tích danh mục - tổng quan tài sản',
  ),
  const _PriorityRoute(
    'Wallet Health',
    AppRoutePaths.walletHealthScore,
    'Điểm sức khỏe ví - tổng quan, bảo mật và đa dạng hóa',
  ),
  const _PriorityRoute(
    'Dust Converter',
    AppRoutePaths.walletDustConverter,
    'Chuyển đổi số dư nhỏ',
  ),
  const _PriorityRoute('Withdraw', AppRoutePaths.walletWithdraw, 'Rút tiền'),
  const _PriorityRoute(
    'Transfer',
    AppRoutePaths.walletTransfer,
    'Chuyển nội bộ',
  ),
  const _PriorityRoute(
    'Address Book',
    AppRoutePaths.walletAddressBook,
    'Sổ địa chỉ - quản lý địa chỉ ví đã lưu',
  ),
  const _PriorityRoute(
    'Address Add',
    AppRoutePaths.walletAddressBookAdd,
    'Thêm địa chỉ mới vào sổ địa chỉ ví',
  ),
  const _PriorityRoute(
    'Profile',
    AppRoutePaths.profile,
    'Trang tài khoản: hồ sơ cá nhân, giới thiệu bạn bè và VIP',
    hasTabletComposition: true,
  ),
  const _PriorityRoute(
    'Prediction Home',
    AppRoutePaths.marketsPredictions,
    'Trang chủ thị trường dự đoán: xác suất và sự kiện đang mở',
  ),
  _PriorityRoute(
    'Prediction Event',
    AppRoutePaths.marketsPredictionEvent('pred-1'),
    'Chi tiết sự kiện dự đoán: xác suất, vị thế và quy tắc',
  ),
  const _PriorityRoute(
    'Prediction Risk',
    AppRoutePaths.marketsPredictionsRiskCalculator,
    'Máy tính rủi ro dự đoán',
  ),
  _PriorityRoute(
    'Prediction Receipt',
    AppRoutePaths.marketsPredictionReceipt('po-1'),
    'Chi tiết lệnh dự đoán: biên lai, phí và tiến trình',
  ),
  const _PriorityRoute(
    'Prediction Portfolio',
    AppRoutePaths.marketsPredictionsPortfolio,
    'Danh mục dự đoán',
  ),
  const _PriorityRoute(
    'Arena Home',
    AppRoutePaths.arena,
    'Trang chủ Open Arena - khám phá và tham gia thử thách công bằng',
  ),
  _PriorityRoute(
    'Arena Challenge',
    AppRoutePaths.arenaChallenge('ch003'),
    'Chi tiết thử thách trong Open Arena',
  ),
  _PriorityRoute(
    'Arena Join',
    AppRoutePaths.arenaJoin('ch003'),
    'Xác nhận tham gia thử thách trong Open Arena',
  ),
  const _PriorityRoute(
    'Token Approval',
    AppRoutePaths.walletTokenApproval,
    'Phê duyệt token - xem và thu hồi quyền truy cập',
  ),
  const _PriorityRoute(
    'P2P Dashboard',
    AppRoutePaths.p2pDashboard,
    'Tổng quan P2P',
  ),
  const _PriorityRoute(
    'P2P Payment Methods',
    AppRoutePaths.p2pPaymentMethods,
    'Phương thức thanh toán',
  ),
  const _PriorityRoute(
    'P2P Payment Add',
    AppRoutePaths.p2pPaymentMethodAdd,
    'Thêm phương thức thanh toán',
  ),
  _PriorityRoute(
    'P2P Order',
    AppRoutePaths.p2pOrder('p2p001'),
    'Chi tiết đơn hàng P2P',
  ),
  _PriorityRoute(
    'P2P Dispute',
    AppRoutePaths.p2pDispute('p2p001'),
    'Mở tranh chấp P2P',
  ),
  const _PriorityRoute(
    'Admin Home',
    AppRoutePaths.admin,
    'Trang tổng quan quản trị',
  ),
  const _PriorityRoute(
    'Analytics Dashboard',
    AppRoutePaths.adminAnalytics,
    'Bảng phân tích dữ liệu',
  ),
  const _PriorityRoute(
    'Funnel Dashboard',
    AppRoutePaths.adminFunnels,
    'Bảng phân tích phễu chuyển đổi',
  ),
  const _PriorityRoute(
    'A/B Test Dashboard',
    AppRoutePaths.adminAbtests,
    'Bảng điều khiển thử nghiệm A/B',
  ),
];

final _filteredPriorityRoutes = _routeFilter.isEmpty
    ? _priorityRoutes
    : _priorityRoutes
          .where(
            (route) =>
                route.name.toLowerCase().contains(_routeFilter) ||
                route.location.toLowerCase().contains(_routeFilter),
          )
          .toList(growable: false);

String _describeFlutterError(FlutterErrorDetails details) {
  if (_includeDiagnostics) {
    return details.toString();
  }
  return details.exceptionAsString();
}

final _routeFilter = const String.fromEnvironment(
  'RESPONSIVE_QA_ROUTE',
).toLowerCase();
const _includeDiagnostics = bool.fromEnvironment('RESPONSIVE_QA_DIAGNOSTICS');

class _ResponsiveViewport {
  const _ResponsiveViewport(this.label, this.width, this.height);

  final String label;
  final int width;
  final int height;
}

class _PriorityRoute {
  const _PriorityRoute(
    this.name,
    this.location,
    this.semanticLabel, {
    this.hasTabletComposition = false,
  });

  final String name;
  final String location;
  final String semanticLabel;

  /// Composition tablet của route expose cùng semantic label như phone
  /// (các wallet tablet detail page dùng label dạng '... trên tablet' nên
  /// không thuộc nhóm này).
  final bool hasTabletComposition;
}
