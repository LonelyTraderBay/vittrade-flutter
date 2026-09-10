// Batch test tablet các trang luồng Wallet (coverage 2026-09-10:
// transfer 78, buy-crypto 74, pending-deposits 52 dòng chưa phủ).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/buy_crypto_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/pending_deposits_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transfer_tablet_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/wallet_transfer_sections.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('trang chuyển khoản tablet render thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.walletTransfer);

    expect(find.byType(TransferTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang mua crypto tablet render thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.walletBuyCrypto);

    expect(find.byType(BuyCryptoTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('trang khoản chờ xử lý tablet render thật', (tester) async {
    await pumpTablet(tester, AppRoutePaths.walletPendingDeposits);

    expect(find.byType(PendingDepositsTabletPage), findsOneWidget);
    expect(find.byType(VitTabletUtilityPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  // Coverage đợt 2: luồng chuyển nội bộ tablet — đổi ví, chọn tài sản,
  // MAX, nhánh validate quá hạn mức, sheet xác nhận và thông báo thành công.
  testWidgets('luồng chuyển nội bộ: swap, picker, MAX, validate, xác nhận', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.walletTransfer);

    // Đảo chiều ví nguồn/đích.
    await tester.tap(find.byKey(const Key('sc146_transfer_swap')));
    await tester.pumpAndSettle();

    // Mở picker ví nguồn, chọn dòng đầu, sheet đóng.
    await tester.tap(find.byKey(const Key('sc146_transfer_from_wallet')));
    await tester.pumpAndSettle();
    expect(find.text('Chọn ví nguồn'), findsOneWidget);
    await tester.tap(find.byType(TransferWalletPickerRow).first);
    await tester.pumpAndSettle();
    expect(find.text('Chọn ví nguồn'), findsNothing);

    // Mở picker tài sản, chọn tài sản đầu.
    await tester.tap(find.byKey(const Key('sc146_transfer_asset')));
    await tester.pumpAndSettle();
    expect(find.text('Chọn tài sản'), findsOneWidget);
    await tester.tap(find.byType(TransferAssetPickerRow).first);
    await tester.pumpAndSettle();
    expect(find.text('Chọn tài sản'), findsNothing);

    // Nhập số tiền vượt khả dụng -> cảnh báo validate hiện.
    await tester.enterText(
      find.byKey(const Key('sc146_transfer_amount')),
      '999999999',
    );
    await tester.pumpAndSettle();
    expect(find.byType(TransferValidationNotice), findsOneWidget);

    // Bấm MAX -> số tiền về đúng khả dụng, hết cảnh báo.
    await tester.tap(find.byKey(const Key('sc146_transfer_max')));
    await tester.pumpAndSettle();
    expect(find.byType(TransferValidationNotice), findsNothing);

    // Submit -> sheet xem lại -> xác nhận -> thông báo thành công.
    await tester.tap(find.byKey(const Key('sc146_transfer_submit')));
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận chuyển nội bộ'), findsOneWidget);

    await tester.tap(find.byKey(const Key('sc146_transfer_confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Chuyển thành công'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
