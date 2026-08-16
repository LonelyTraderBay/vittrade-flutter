import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_2fa_settings_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_login_history_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSecurityCenter(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.p2pSecurityCenter,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-253 mock repository exposes security center BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getSecurityCenter();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-security-center');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
    );
    expect(snapshot.score, 90);
    expect(snapshot.maxScore, 100);
    expect(snapshot.features, hasLength(5));
    expect(snapshot.quickActions, hasLength(4));
    expect(snapshot.recentEvents, hasLength(3));
    expect(snapshot.parentRoute, AppRoutePaths.p2p);
    expect(snapshot.settingsRoute, AppRoutePaths.p2pSettings);
    expect(snapshot.loginHistoryRoute, AppRoutePaths.p2pSecurityLoginHistory);
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

  testWidgets('SC-253 renders security center baseline', (tester) async {
    await pumpSecurityCenter(tester);

    expect(find.byType(P2PSecurityCenterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trung tâm bảo mật'), findsOneWidget);
    expect(find.text('Bảo mật · P2P'), findsOneWidget);
    expect(find.byKey(P2PSecurityCenterPage.scoreKey), findsOneWidget);
    expect(find.text('Điểm bảo mật'), findsOneWidget);
    expect(find.text('90'), findsOneWidget);
    expect(find.text('Xuất sắc'), findsOneWidget);
    expect(find.byKey(P2PSecurityCenterPage.featuresKey), findsOneWidget);
    expect(find.text('2FA cho P2P'), findsOneWidget);
    expect(find.text('Mã chống phishing'), findsOneWidget);
    expect(find.text('Thiết bị tin cậy'), findsOneWidget);
    expect(find.text('Chế độ whitelist'), findsOneWidget);
    expect(find.text('Khóa sinh trắc học'), findsOneWidget);
    expect(find.byKey(P2PSecurityCenterPage.quickActionsKey), findsOneWidget);
    expect(find.text('Đổi mật khẩu'), findsOneWidget);
    expect(find.text('Hoạt động đáng ngờ'), findsOneWidget);
    expect(find.byKey(P2PSecurityCenterPage.eventsKey), findsOneWidget);
    expect(find.text('Đăng nhập thành công'), findsOneWidget);
    expect(find.text('Thiết bị mới'), findsOneWidget);
    expect(find.text('Đăng nhập thất bại'), findsOneWidget);
  });

  testWidgets('SC-253 feature row opens a security route edge', (tester) async {
    await pumpSecurityCenter(tester);

    await tester.tap(find.byKey(P2PSecurityCenterPage.featureKey('2fa')));
    await tester.pumpAndSettle();

    expect(find.byType(P2P2FASettingsPage), findsOneWidget);
  });

  testWidgets('SC-253 first viewport reaches security features', (
    tester,
  ) async {
    await pumpSecurityCenter(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-253 P2PSecurityCenterPage',
      semanticLabel: 'Trung tâm bảo mật P2P',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(P2PSecurityCenterPage.featuresKey),
      targetLabel: 'security feature list',
      minVisibleHeight: 18,
    );
  });

  testWidgets('SC-253 whitelist route first viewport reaches device review', (
    tester,
  ) async {
    await pumpSecurityCenter(
      tester,
      initialLocation: AppRoutePaths.p2pSecurityWhitelist,
    );

    expect(find.byType(P2PWhitelistModePage), findsOneWidget);
    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-404 P2PWhitelistModePage',
      semanticLabel: 'Chế độ danh sách trắng P2P',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(P2PWhitelistModePage.devicesKey),
      targetLabel: 'trusted device review action',
      minVisibleHeight: 18,
    );
  });

  testWidgets('SC-253 view all opens login history edge', (tester) async {
    await pumpSecurityCenter(tester);

    await tester.ensureVisible(find.byKey(P2PSecurityCenterPage.viewAllKey));
    await tester.tap(find.byKey(P2PSecurityCenterPage.viewAllKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PLoginHistoryPage), findsOneWidget);
  });

  testWidgets('SC-253 back returns to P2P hub', (tester) async {
    await pumpSecurityCenter(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('P2P'), findsWidgets);
  });
}
