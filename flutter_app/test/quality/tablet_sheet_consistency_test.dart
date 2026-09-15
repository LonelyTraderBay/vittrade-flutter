// Ma trận đồng bộ bottom sheet tablet (Bottom-Sheet-Standard): mở 6 sheet
// đại diện cho 5 nhóm popup (catalog tràn, confirm thường, confirm tài
// chính footer ghim, picker, khuyến nghị) và khẳng định CÙNG một khung:
// pop-over cap 480dp căn giữa, neo đáy, nền AppColors.surface (wrapper sở
// hữu), VitSheetHandle + VitSheetPanel. Chạy surface tablet 1280×800.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/presentation/tablet/pages/arena_tablet_pages.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/deposit_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/wallet_token_approval_tablet_page.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(
        routerConfig: createAppRouter(
          surface: AppSurface.tablet,
          initialLocation: location,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Khẳng định khung sheet chuẩn — mọi sheet tablet phải vượt qua cùng
  /// một bộ đo này.
  void expectStandardSheet(WidgetTester tester) {
    final sheet = find.byType(BottomSheet);
    expect(sheet, findsOneWidget, reason: 'sheet phải đang mở');

    // Widget BottomSheet trải full-width; constraint 480 áp trên lớp
    // Material nền của nó — đo lớp đó.
    final panel = find
        .descendant(
          of: sheet,
          matching: find.byWidgetPredicate(
            (w) => w is Material && w.color == AppColors.surface,
          ),
        )
        .first;
    final size = tester.getSize(panel);
    expect(size.width, 480, reason: 'pop-over cap 480dp');
    final topLeft = tester.getTopLeft(panel);
    expect(topLeft.dx, 400, reason: 'căn giữa ngang: (1280−480)/2');
    expect(topLeft.dy + size.height, 800, reason: 'neo đáy màn hình');

    expect(
      find.byWidgetPredicate(
        (w) => w is Material && w.color == AppColors.surface,
      ),
      findsAtLeastNWidgets(1),
      reason: 'nền sheet phải là AppColors.surface của wrapper',
    );

    expect(find.byType(VitSheetPanel), findsOneWidget);
    expect(find.byType(VitSheetHandle), findsOneWidget);
    expect(tester.takeException(), isNull);
  }

  testWidgets('catalog Markets "Thêm công cụ" đạt khung chuẩn', (tester) async {
    await pumpTablet(tester, AppRoutePaths.markets);
    final more = find.text('Thêm');
    await tester.ensureVisible(more);
    await tester.tap(more);
    await tester.pumpAndSettle();
    expect(find.text('Thêm công cụ'), findsOneWidget);
    expectStandardSheet(tester);
  });

  testWidgets('catalog Home "Xem thêm" đạt khung chuẩn', (tester) async {
    await pumpTablet(tester, AppRoutePaths.home);
    final more = find.textContaining('Xem thêm');
    await tester.ensureVisible(more);
    await tester.tap(more);
    await tester.pumpAndSettle();
    expect(find.text('Tất cả sản phẩm'), findsOneWidget);
    expectStandardSheet(tester);
  });

  testWidgets('catalog Arena "Công cụ" đạt khung chuẩn', (tester) async {
    await pumpTablet(tester, AppRoutePaths.arena);
    final tools = find.byKey(ArenaHomeTabletPage.toolsActionKey);
    await tester.ensureVisible(tools);
    await tester.tap(tools);
    await tester.pumpAndSettle();
    expect(find.text('Công cụ Open Arena'), findsOneWidget);
    expectStandardSheet(tester);
  });

  testWidgets('picker cặp giao dịch Trade đạt khung chuẩn', (tester) async {
    await pumpTablet(tester, AppRoutePaths.tradePair('btcusdt'));
    final picker = find.byKey(TradeTabletKeys.pairPicker);
    await tester.ensureVisible(picker);
    await tester.tap(picker);
    await tester.pumpAndSettle();
    expect(find.text('Chọn cặp giao dịch'), findsOneWidget);
    expectStandardSheet(tester);
  });

  testWidgets('picker mạng nạp Wallet đạt khung chuẩn', (tester) async {
    await pumpTablet(tester, '/wallet/deposit/usdt');
    final selector = find.byKey(DepositTabletPage.networkSelectorKey);
    await tester.ensureVisible(selector);
    await tester.tap(selector);
    await tester.pumpAndSettle();
    expect(find.text('Chọn mạng lưới'), findsOneWidget);
    expectStandardSheet(tester);
  });

  testWidgets('confirm thu hồi token (footer ghim + tier tall) đạt khung', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.walletTokenApproval);
    final revoke = find.byKey(WalletTokenApprovalTabletPage.revokeKey('a3'));
    await tester.ensureVisible(revoke);
    await tester.tap(revoke);
    await tester.pumpAndSettle();
    // Footer ghim: nút xác nhận luôn hiện, không phụ thuộc nội dung.
    expect(
      find.byKey(WalletTokenApprovalTabletPage.revokeSheetConfirmKey),
      findsOneWidget,
    );
    expectStandardSheet(tester);
  });
}
