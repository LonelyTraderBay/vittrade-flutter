import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_express_confirm_page.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_express_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpP2PExpress(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pExpress,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-211 keeps the Home-standard page foundation contract', () async {
    final pageSource = File(
      'lib/features/p2p_marketplace/presentation/widgets/phone/p2p_express_page_state.dart',
    ).readAsStringSync();

    expect(pageSource, contains('VitInsetScrollView'));
    expect(pageSource, contains('VitContentPadding.compact'));
    expect(pageSource, contains('VitDensity.compact'));
    expect(pageSource, isNot(contains('SingleChildScrollView')));
  });

  test('SC-211 mock repository exposes P2P Express BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getExpress();
    final bestAd = snapshot.bestAd(
      tradeType: P2PTradeType.buy,
      asset: 'USDT',
      fiatAmount: 1000000,
    );

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-express');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.quickAmountsVnd, contains(1000000));
    expect(snapshot.paymentMethods.length, 3);
    expect(snapshot.assets.first.symbol, 'USDT');
    expect(bestAd?.id, 'ad001');
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-211 renders P2P Express empty baseline', (tester) async {
    await pumpP2PExpress(tester);

    expect(find.byType(P2PExpressPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Giao dịch Express'), findsOneWidget);
    expect(find.text('Mua bán nhanh'), findsOneWidget);
    expect(find.text('MUA NHANH'), findsOneWidget);
    expect(find.text('BÁN NHANH'), findsOneWidget);
    expect(find.text('Tôi muốn mua'), findsOneWidget);
    expect(find.text('25.300'), findsOneWidget);
    expect(find.text('Số tiền (VND)'), findsOneWidget);
    expect(find.text('Nhập số tiền...'), findsOneWidget);
    expect(find.text('Thanh toán qua'), findsOneWidget);
    expect(find.text('Bảo vệ bởi Escrow VitTrade'), findsOneWidget);
    expect(find.text('Express hoạt động thế nào?'), findsOneWidget);
    expect(find.text('Mua nhanh USDT'), findsOneWidget);
    expect(find.text('Offer tốt nhất được tìm thấy'), findsNothing);
  });

  testWidgets('SC-211 360px viewport follows Home rhythm', (tester) async {
    await pumpP2PExpress(tester, viewport: const Size(360, 800));

    final navTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;
    final firstCard = tester.getRect(find.byType(VitCard).first);
    final ctaTop = tester.getTopLeft(find.byKey(P2PExpressPage.ctaKey)).dy;

    expect(firstCard.left, lessThanOrEqualTo(24));
    expect(firstCard.width, greaterThanOrEqualTo(312));
    expect(ctaTop, lessThan(navTop - 24));
  });

  testWidgets('SC-211 quick amount auto-matches and opens confirm', (
    tester,
  ) async {
    await pumpP2PExpress(tester);

    await tester.tap(find.byKey(P2PExpressPage.quickAmountKey(1000000)));
    await tester.pumpAndSettle();

    expect(find.text('Offer tốt nhất được tìm thấy'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PExpressPage.ctaKey));
    await tester.tap(find.byKey(P2PExpressPage.ctaKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PExpressConfirmPage), findsOneWidget);
    expect(find.text('Xác nhận mua nhanh'), findsOneWidget);
    expect(find.text('1.000.000 VND'), findsOneWidget);
  });

  testWidgets('SC-211 sell toggle updates state and merchant edge is safe', (
    tester,
  ) async {
    await pumpP2PExpress(tester);

    await tester.tap(find.byKey(P2PExpressPage.sellToggleKey));
    await tester.pumpAndSettle();
    expect(find.text('Tôi muốn bán'), findsOneWidget);

    await tester.tap(find.byKey(P2PExpressPage.quickAmountKey(2000000)));
    await tester.pumpAndSettle();
    expect(find.text('VIPTrader_HN'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_right_rounded).last);
    await tester.pumpAndSettle();
    expect(find.text('Hồ sơ Merchant'), findsOneWidget);
    expect(find.text('VIPTrader_HN'), findsOneWidget);
  });

  testWidgets('SC-211 marketplace button returns to P2P parent route', (
    tester,
  ) async {
    await pumpP2PExpress(tester);

    await tester.tap(find.byKey(P2PExpressPage.marketplaceKey));
    await tester.pumpAndSettle();

    expect(find.text('P2P'), findsOneWidget);
  });
}
