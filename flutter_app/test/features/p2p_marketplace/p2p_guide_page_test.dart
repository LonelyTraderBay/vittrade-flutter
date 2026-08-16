import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_marketplace/presentation/phone/pages/hub/p2p_guide_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpGuide(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pGuide,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-280 mock repository exposes guide BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getGuide();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-guide');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'Hướng dẫn P2P');
    expect(snapshot.subtitle, 'Hướng dẫn · P2P');
    expect(snapshot.defaultTab, 'faq');
    expect(snapshot.tabs.map((tab) => tab.label), [
      'Hướng dẫn',
      'An toàn',
      'FAQ',
      'Video',
    ]);
    expect(snapshot.faqItems, hasLength(7));
    expect(snapshot.buySteps, hasLength(4));
    expect(snapshot.sellSteps, hasLength(4));
    expect(snapshot.safetyTips, hasLength(4));
    expect(snapshot.videos, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.supportRoute, startsWith('/support?'));
    expect(snapshot.supportRoute, contains('flow=p2p_order'));
    expect(snapshot.supportRoute, contains('p2p-emergency-guide'));
    expect(snapshot.marketRoute, AppRoutePaths.p2p);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
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

  testWidgets('SC-280 renders guide FAQ baseline', (tester) async {
    await pumpGuide(tester);

    expect(find.byType(P2PGuidePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hướng dẫn P2P'), findsOneWidget);
    expect(find.text('Hướng dẫn · P2P'), findsOneWidget);
    expect(find.byKey(P2PGuidePage.tabsKey), findsOneWidget);
    expect(find.text('Hướng dẫn'), findsWidgets);
    expect(find.text('An toàn'), findsOneWidget);
    expect(find.text('FAQ'), findsOneWidget);
    expect(find.text('Video'), findsOneWidget);
    expect(find.byKey(P2PGuidePage.faqListKey), findsOneWidget);
    expect(find.text('Câu hỏi thường gặp'), findsOneWidget);
    expect(find.text('7 câu hỏi'), findsOneWidget);
    expect(find.text('P2P Trading là gì?'), findsOneWidget);
    expect(find.textContaining('Peer-to-Peer'), findsOneWidget);
    expect(find.text('Phí giao dịch P2P là bao nhiêu?'), findsOneWidget);
    expect(find.text('VitTrade có an toàn không?'), findsOneWidget);
  });

  testWidgets('SC-280 first viewport reaches FAQ list depth', (tester) async {
    await pumpGuide(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-280 P2PGuidePage',
      semanticLabel: 'Hướng dẫn P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PGuidePage.faqKey('fees')),
      routeName: 'SC-280 P2PGuidePage',
      actionLabel: 'the second FAQ item',
      minVisibleHeight: 40,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PGuidePage.faqKey('escrow')),
      routeName: 'SC-280 P2PGuidePage',
      actionLabel: 'the escrow FAQ preview',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-280 guide mode controls fit first viewport', (tester) async {
    await pumpGuide(tester);

    await tester.tap(find.byKey(P2PGuidePage.tabKey('guide')));
    await tester.pumpAndSettle();

    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PGuidePage.buyModeKey),
      routeName: 'SC-280 P2PGuidePage',
      actionLabel: 'the buy mode control',
      minVisibleHeight: 40,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PGuidePage.startKey),
      routeName: 'SC-280 P2PGuidePage',
      actionLabel: 'the start P2P CTA',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-280 FAQ accordion toggles expanded answer', (tester) async {
    await pumpGuide(tester);

    await tester.tap(find.byKey(P2PGuidePage.faqKey('fees')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Taker'), findsOneWidget);
    expect(find.textContaining('Peer-to-Peer'), findsNothing);
  });

  testWidgets('SC-280 guide tab supports buy and sell modes', (tester) async {
    await pumpGuide(tester);

    await tester.tap(find.text('Hướng dẫn').first);
    await tester.pumpAndSettle();

    expect(find.text('Mua Crypto'), findsOneWidget);
    expect(find.text('Tìm quảng cáo'), findsOneWidget);
    expect(find.text('Bắt đầu ngay!'), findsOneWidget);

    await tester.tap(find.byKey(P2PGuidePage.sellModeKey));
    await tester.pumpAndSettle();

    expect(find.text('Đăng quảng cáo'), findsOneWidget);
    expect(find.text('Giải phóng crypto'), findsOneWidget);
  });

  testWidgets('SC-280 support and start navigation edges are wired', (
    tester,
  ) async {
    await pumpGuide(tester);

    await tester.tap(find.text('An toàn'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(P2PGuidePage.supportKey));
    await tester.tap(find.byKey(P2PGuidePage.supportKey));
    await tester.pumpAndSettle();
    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('P2P emergency trade support'), findsOneWidget);
    expect(find.text('p2p-emergency-guide'), findsOneWidget);

    await pumpGuide(tester);
    await tester.tap(find.text('Hướng dẫn').first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(P2PGuidePage.startKey));
    await tester.tap(find.byKey(P2PGuidePage.startKey));
    await tester.pumpAndSettle();
    expect(find.text('P2P'), findsOneWidget);
  });

  testWidgets('SC-280 header back returns to P2P parent', (tester) async {
    await pumpGuide(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PGuidePage), findsNothing);
    expect(find.text('P2P'), findsOneWidget);
  });
}
