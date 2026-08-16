import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/ads/p2p_ad_detail_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpP2PAdDetail(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pAd('sample'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-224 mock repository exposes P2P ad detail BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getAdDetail('sample');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-ad-sample');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.adId, 'sample');
    expect(snapshot.sourceAdId, 'ad001');
    expect(snapshot.ad.merchant, 'CryptoKing_VN');
    expect(snapshot.ad.price, 25350);
    expect(snapshot.marketPriceVnd, 25300);
    expect(snapshot.priceDiffPct, .20);
    expect(snapshot.trustScore, 100);
    expect(snapshot.viewerCount, 7);
    expect(snapshot.totalVolume30dUsd, 850000);
    expect(snapshot.availableAmount, 10000);
    expect(snapshot.targetOrderId, 'p2p001');
    expect(snapshot.contractNotes, contains('escrow'));
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

  testWidgets('SC-224 renders P2P ad detail baseline', (tester) async {
    await pumpP2PAdDetail(tester);

    expect(find.byType(P2PAdDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Chi tiết quảng cáo'), findsOneWidget);
    expect(find.text('Quảng cáo · P2P'), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);
    expect(find.text('+0.20%'), findsOneWidget);
    expect(find.text('25.350'), findsOneWidget);
    expect(find.text('10,000.00 USDT'), findsOneWidget);
    expect(find.text('500.000 - 50.000.000'), findsOneWidget);
    expect(find.text('2 phút'), findsOneWidget);
    expect(find.text('Nhập số lượng'), findsOneWidget);
    expect(find.text('Mua USDT'), findsOneWidget);

    await tester.drag(
      find.byKey(P2PAdDetailPage.contentKey),
      const Offset(0, -620),
    );
    await tester.pumpAndSettle();

    expect(find.text('Yêu cầu đối tác'), findsOneWidget);
    expect(find.text('KYC cấp 1+'), findsOneWidget);
    expect(find.text('Điều kiện giao dịch'), findsOneWidget);
    expect(find.textContaining('Escrow VitTrade'), findsOneWidget);
  });

  testWidgets(
    'SC-224 first viewport reaches amount controls without sticky buy action',
    (tester) async {
      await pumpP2PAdDetail(tester);

      expectRouteSemanticInFirstViewport(
        tester,
        routeName: 'SC-224 P2PAdDetailPage',
        semanticLabel: 'Chi tiết quảng cáo P2P',
      );
      expectActionableInFirstViewport(
        tester,
        find.text('CryptoKing_VN'),
        routeName: 'SC-224 P2PAdDetailPage',
        actionLabel: 'the merchant summary',
        minVisibleHeight: 16,
      );
      expectActionableInFirstViewport(
        tester,
        find.byKey(P2PAdDetailPage.percentKey(25)),
        routeName: 'SC-224 P2PAdDetailPage',
        actionLabel: 'the 25 percent amount shortcut',
        minVisibleHeight: 32,
      );
      expect(find.byType(VitStickyFooter), findsNothing);
    },
  );

  testWidgets('SC-224 buy action is inline after review content', (
    tester,
  ) async {
    await pumpP2PAdDetail(tester);

    expect(find.byType(VitStickyFooter), findsNothing);

    final buyAction = find.byKey(P2PAdDetailPage.buyButtonKey);
    await tester.ensureVisible(buyAction);
    await tester.pumpAndSettle();

    final buyRect = tester.getRect(buyAction);
    final navRect = tester.getRect(find.byType(VitBottomNav));
    expect(buyRect.bottom, lessThanOrEqualTo(navRect.top));
  });

  testWidgets('SC-224 percent selection enables order creation route', (
    tester,
  ) async {
    await pumpP2PAdDetail(tester);

    await tester.tap(find.byKey(P2PAdDetailPage.percentKey(25)));
    await tester.pumpAndSettle();

    expect(find.text('12.500.000'), findsOneWidget);
    expect(find.text('493.096647'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PAdDetailPage.buyButtonKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PAdDetailPage.buyButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2POrderPage), findsOneWidget);
    expect(find.text('VT-P2P-20240223-001'), findsOneWidget);
  });
}
