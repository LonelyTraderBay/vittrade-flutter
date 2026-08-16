import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_suspicious_activity_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSuspiciousActivity(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pSecuritySuspiciousActivity,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpSecurityCenter(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pSecurityCenter,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-258 mock repository exposes suspicious activity BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getSuspiciousActivity();

    expect(
      snapshot.endpoint,
      '/api/mobile/p2p/p2p-security-suspicious-activity',
    );
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
    );
    expect(snapshot.alerts, hasLength(3));
    expect(snapshot.unreviewedCount, 2);
    expect(snapshot.parentRoute, AppRoutePaths.p2pSecurityCenter);
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

  testWidgets('SC-258 renders suspicious activity baseline', (tester) async {
    await pumpSuspiciousActivity(tester);

    expect(find.byType(P2PSuspiciousActivityPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hoạt động đáng ngờ'), findsOneWidget);
    expect(find.text('An toàn · P2P'), findsOneWidget);
    expect(find.byKey(P2PSuspiciousActivityPage.summaryKey), findsOneWidget);
    expect(find.text('2 cảnh báo mới'), findsOneWidget);
    expect(find.text('Xem lại hoạt động đáng ngờ'), findsOneWidget);
    expect(find.byKey(P2PSuspiciousActivityPage.alertsKey), findsOneWidget);
    expect(find.text('Đăng nhập từ vị trí lạ: Singapore'), findsOneWidget);
    expect(find.text('Giao dịch bất thường: 100M VND'), findsOneWidget);
    expect(find.text('Thiết bị mới: Unknown Android'), findsOneWidget);
    expect(find.text('Đã xem lại'), findsOneWidget);
  });

  testWidgets('SC-258 dismiss marks an alert reviewed', (tester) async {
    await pumpSuspiciousActivity(tester);

    await tester.tap(
      find.byKey(
        P2PSuspiciousActivityPage.dismissKey('suspicious_login_singapore'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 cảnh báo mới'), findsOneWidget);
    expect(find.text('Đăng nhập từ vị trí lạ: Singapore'), findsOneWidget);
    expect(find.text('Đã xem lại'), findsNWidgets(2));
  });

  testWidgets('SC-258 security center action opens suspicious activity', (
    tester,
  ) async {
    await pumpSecurityCenter(tester);

    await tester.ensureVisible(
      find.byKey(P2PSecurityCenterPage.quickActionKey('activity')),
    );
    await tester.tap(
      find.byKey(P2PSecurityCenterPage.quickActionKey('activity')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(P2PSuspiciousActivityPage), findsOneWidget);
  });

  testWidgets('SC-258 back returns to P2P security center', (tester) async {
    await pumpSuspiciousActivity(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PSecurityCenterPage), findsOneWidget);
  });
}
