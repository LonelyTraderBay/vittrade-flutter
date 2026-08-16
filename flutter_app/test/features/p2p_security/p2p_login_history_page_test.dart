import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_login_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpLoginHistory(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pSecurityLoginHistory,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-257 mock repository exposes login history BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getLoginHistory();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-security-login-history');
    expect(
      snapshot.actionDraft,
      'POST /auth/login; POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
    );
    expect(snapshot.events, hasLength(5));
    expect(snapshot.successCount, 3);
    expect(snapshot.riskEventCount, 2);
    expect(snapshot.securityTips, hasLength(3));
    expect(snapshot.parentRoute, AppRoutePaths.p2pSecurityCenter);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ]),
    );
  });

  testWidgets('SC-257 renders login history baseline', (tester) async {
    await pumpLoginHistory(tester);

    expect(find.byType(P2PLoginHistoryPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Lịch sử đăng nhập'), findsOneWidget);
    expect(find.text('Bảo mật · P2P'), findsOneWidget);
    expect(find.byKey(P2PLoginHistoryPage.downloadKey), findsOneWidget);
    expect(find.byKey(P2PLoginHistoryPage.statsKey), findsOneWidget);
    expect(find.text('Tổng số'), findsOneWidget);
    expect(find.text('Thành công'), findsWidgets);
    expect(find.text('Đáng ngờ'), findsWidgets);
    expect(find.byKey(P2PLoginHistoryPage.filtersKey), findsOneWidget);
    expect(find.byKey(P2PLoginHistoryPage.warningKey), findsOneWidget);
    expect(find.text('Phát hiện 2 đăng nhập đáng ngờ'), findsOneWidget);
    expect(find.byKey(P2PLoginHistoryPage.eventsKey), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.text('MacBook Pro'), findsOneWidget);
    expect(find.text('Samsung Galaxy S24'), findsOneWidget);
    expect(find.text('Windows PC'), findsOneWidget);
    expect(find.text('Unknown Device'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PLoginHistoryPage.infoKey));
    expect(find.text('Lưu ý bảo mật'), findsOneWidget);
    expect(find.text('Lịch sử được lưu trong 90 ngày'), findsOneWidget);
  });

  testWidgets('SC-257 first viewport reaches filters and first event', (
    tester,
  ) async {
    await pumpLoginHistory(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-257 P2PLoginHistoryPage',
      semanticLabel: 'Lịch sử đăng nhập P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PLoginHistoryPage.filterKey('all')),
      routeName: 'SC-257 P2PLoginHistoryPage',
      actionLabel: 'the all-login filter',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PLoginHistoryPage.warningKey),
      routeName: 'SC-257 P2PLoginHistoryPage',
      actionLabel: 'the suspicious-login warning',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PLoginHistoryPage.eventKey('login_iphone_current')),
      routeName: 'SC-257 P2PLoginHistoryPage',
      actionLabel: 'the first login event',
      minVisibleHeight: 40,
    );
  });

  testWidgets('SC-257 filters suspicious events and expands details', (
    tester,
  ) async {
    await pumpLoginHistory(tester);

    await tester.tap(find.byKey(P2PLoginHistoryPage.filterKey('suspicious')));
    await tester.pumpAndSettle();

    expect(find.text('Windows PC'), findsOneWidget);
    expect(find.text('Unknown Device'), findsOneWidget);
    expect(find.text('MacBook Pro'), findsNothing);

    await tester.tap(
      find.byKey(P2PLoginHistoryPage.eventKey('login_windows_suspicious')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Địa chỉ IP'), findsOneWidget);
    expect(find.text('103.45.78.21'), findsOneWidget);
    expect(find.text('Phương thức đăng nhập'), findsOneWidget);
    expect(find.text('Đăng nhập đáng ngờ'), findsOneWidget);
  });

  testWidgets('SC-257 back returns to P2P security center', (tester) async {
    await pumpLoginHistory(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PSecurityCenterPage), findsOneWidget);
  });
}
