import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/vip_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRoute(WidgetTester tester, String route) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: route),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-164 mock repository exposes VIP BE draft', () async {
    final snapshot = await const MockProfileRepository().getVip();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-vip');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.currentTier.name, 'VIP 1');
    expect(snapshot.nextTier?.name, 'VIP 2');
    expect(snapshot.monthlyVolume, 12450);
    expect(snapshot.assetHold, 54276);
    expect(snapshot.tiers, hasLength(6));
    expect(snapshot.history, hasLength(5));
    expect(
      snapshot.supportedStates,
      containsAll([
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-164 renders overview with Profile bottom nav active', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.profileVip);

    expect(find.byType(VIPPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('VIP Program'), findsOneWidget);
    expect(find.text('VIP 1'), findsWidgets);
    expect(find.text('Maker fee'), findsOneWidget);
    expect(find.text('Taker fee'), findsOneWidget);
    expect(
      find.text('Ti\u1EBFn \u0111\u1ED9 l\u00EAn h\u1EA1ng'),
      findsOneWidget,
    );
    expect(find.text('So s\u00E1nh c\u00E1c c\u1EA5p VIP'), findsOneWidget);
    expect(find.byKey(VIPPage.tierRowKey(1)), findsOneWidget);
  });

  testWidgets('SC-164 first viewport keeps upgrade progress visible', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.profileVip);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'VIPPage',
      semanticLabel: 'Chương trình hội viên VIP',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Ti\u1EBFn \u0111\u1ED9 l\u00EAn h\u1EA1ng').hitTestable(),
      minVisibleHeight: 12,
      targetLabel: 'VIP upgrade progress',
      reason:
          'VIPPage should show the upgrade progress section in the first '
          'viewport above the bottom navigation.',
    );
  });

  testWidgets('SC-164 supports tab state changes', (tester) async {
    await pumpRoute(tester, AppRoutePaths.profileVip);

    await tester.tap(find.text('L\u1ECBch s\u1EED'));
    await tester.pumpAndSettle();

    expect(find.text('2026-02-23'), findsOneWidget);
    expect(find.text('Kh\u1ED1i l\u01B0\u1EE3ng'), findsWidgets);

    await tester.tap(find.text('\u0110\u1EB7c quy\u1EC1n'));
    await tester.pumpAndSettle();

    expect(find.text('N\u00E2ng c\u1EA5p l\u00EAn VIP 2'), findsOneWidget);
    expect(find.byKey(VIPPage.tradeCtaKey), findsOneWidget);
  });

  testWidgets('SC-164 navigation edges are wired', (tester) async {
    await pumpRoute(tester, AppRoutePaths.profile);

    expect(find.byType(ProfilePage), findsOneWidget);
    await tester.ensureVisible(find.byKey(ProfilePage.menuKey('vip')));
    await tester.tap(find.byKey(ProfilePage.menuKey('vip')));
    await tester.pumpAndSettle();

    expect(find.byType(VIPPage), findsOneWidget);

    await tester.tap(find.text('\u0110\u1EB7c quy\u1EC1n'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(VIPPage.tradeCtaKey));
    await tester.tap(find.byKey(VIPPage.tradeCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
  });
}
