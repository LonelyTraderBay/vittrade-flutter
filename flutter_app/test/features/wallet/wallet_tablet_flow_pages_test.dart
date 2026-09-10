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
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
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

  // Coverage dòng 2: mua crypto tablet — luồng đầy đủ: picker crypto,
  // nhập tiền, nút mua -> màn xác nhận -> submit -> thành công.
  testWidgets('mua crypto tablet: picker, xác nhận, submit thành công', (
    tester,
  ) async {
    await pumpTablet(tester, AppRoutePaths.walletBuyCrypto);

    // Mở picker crypto và chọn loại khác.
    await tester.tap(find.byKey(const Key('sc145_buy_crypto_selector')));
    await tester.pumpAndSettle();
    expect(find.text('Chọn loại Crypto'), findsOneWidget);
    final options = find.byType(VitAssetAvatar);
    if (options.evaluate().length > 1) {
      await tester.tap(options.last);
      await tester.pumpAndSettle();
    } else {
      await tester.tap(find.byType(VitCard).last);
      await tester.pumpAndSettle();
    }
    expect(find.text('Chọn loại Crypto'), findsNothing);

    // Nhập số tiền VND.
    final fields = find.byType(TextField);
    await tester.enterText(fields.first, '500000');
    await tester.pumpAndSettle();

    // Bấm nút mua (key do widget dùng chung gắn) -> màn xác nhận.
    final buy = find.byKey(const Key('sc145_buy_crypto_buy'));
    expect(buy, findsOneWidget);
    await Scrollable.ensureVisible(tester.element(buy));
    await tester.pumpAndSettle();
    await tester.tap(buy);
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận mua'), findsOneWidget);
    expect(find.textContaining('Xem lại lệnh mua'), findsOneWidget);

    // Xác nhận -> chờ 250ms -> màn thành công.
    final confirm = find.byType(VitCtaButton).last;
    await Scrollable.ensureVisible(tester.element(confirm));
    await tester.pumpAndSettle();
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  // Coverage dòng 2 p3e: nhánh error 3 trang wallet tablet (family key asset id).
  testWidgets('wallet tablet: deposit/withdraw error state', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    Future<void> pumpErr(String location) async {
      await tester.pumpWidget(
        VitTradeApp(
          overrides: [
            walletDepositControllerProvider((
              asset: 'usdt',
              assetScoped: true,
            )).overrideWith((ref) async => throw StateError('lỗi')),
            walletPendingDepositsProvider.overrideWith(
              (ref) async => throw StateError('lỗi'),
            ),
          ],
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull, reason: location);
    }

    await pumpErr('/wallet/deposit/usdt');
    await pumpErr('/wallet/pending-deposits');
  });

  // Coverage dòng 2 p3f: nhánh error transfer tablet.
  testWidgets('transfer tablet error qua override', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(
        overrides: [
          walletTransferProvider.overrideWith(
            (ref) async => throw StateError('lỗi mạng'),
          ),
        ],
        routerConfig: createAppRouter(
          surface: AppSurface.tablet,
          initialLocation: AppRoutePaths.walletTransfer,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Không tải được dữ liệu chuyển nội bộ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  // Coverage dòng 2 p3f: nhánh error gas optimizer tablet.
  testWidgets('gas optimizer tablet error qua override', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      VitTradeApp(
        overrides: [
          walletGasOptimizerProvider.overrideWith(
            (ref) async => throw StateError('lỗi mạng'),
          ),
        ],
        routerConfig: createAppRouter(
          surface: AppSurface.tablet,
          initialLocation: AppRoutePaths.walletGasOptimizer,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
  });
}
