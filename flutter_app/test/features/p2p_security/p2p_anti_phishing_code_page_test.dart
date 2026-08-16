import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_anti_phishing_code_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_security_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAntiPhishing(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pSecurityAntiPhishing,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-256 mock repository exposes anti-phishing BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getAntiPhishingCode();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-security-anti-phishing');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; PATCH /user/settings or module settings',
    );
    expect(snapshot.hasCode, isTrue);
    expect(snapshot.currentCode, 'SECURE2026');
    expect(snapshot.benefits, hasLength(3));
    expect(snapshot.examples, hasLength(2));
    expect(snapshot.warnings, hasLength(4));
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

  testWidgets('SC-256 renders anti-phishing baseline', (tester) async {
    await pumpAntiPhishing(tester);

    expect(find.byType(P2PAntiPhishingCodePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Mã chống phishing'), findsOneWidget);
    expect(find.text('Bảo mật · P2P'), findsOneWidget);
    expect(find.byKey(P2PAntiPhishingCodePage.statusKey), findsOneWidget);
    expect(find.text('Anti-Phishing Code đã bật'), findsOneWidget);
    expect(find.byKey(P2PAntiPhishingCodePage.explainerKey), findsOneWidget);
    expect(find.text('Anti-Phishing Code là gì?'), findsOneWidget);
    expect(find.text('Bảo vệ khỏi email phishing'), findsOneWidget);
    expect(find.byKey(P2PAntiPhishingCodePage.codeCardKey), findsOneWidget);
    expect(find.text('Code hiện tại'), findsOneWidget);
    expect(find.text('Mã của bạn'), findsOneWidget);
    expect(find.byKey(P2PAntiPhishingCodePage.examplesKey), findsOneWidget);
    expect(find.text('Ví dụ email'), findsOneWidget);
    expect(find.text('[VitTrade] P2P Order Confirmed'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PAntiPhishingCodePage.warningKey));
    expect(find.text('Cảnh báo quan trọng'), findsOneWidget);
    expect(find.text('Không chia sẻ code này với bất kỳ ai'), findsOneWidget);
  });

  testWidgets('SC-256 first viewport reaches code actions', (tester) async {
    await pumpAntiPhishing(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-256 P2PAntiPhishingCodePage',
      semanticLabel: 'Mã chống lừa đảo P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAntiPhishingCodePage.codeCardKey),
      routeName: 'SC-256 P2PAntiPhishingCodePage',
      actionLabel: 'the current anti-phishing code card',
      minVisibleHeight: 48,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAntiPhishingCodePage.revealKey),
      routeName: 'SC-256 P2PAntiPhishingCodePage',
      actionLabel: 'the reveal code control',
      minVisibleHeight: 32,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PAntiPhishingCodePage.editKey),
      routeName: 'SC-256 P2PAntiPhishingCodePage',
      actionLabel: 'the edit code action',
      minVisibleHeight: 32,
    );
  });

  testWidgets('SC-256 reveals and updates the anti-phishing code', (
    tester,
  ) async {
    await pumpAntiPhishing(tester);

    expect(find.text('SECURE2026'), findsNothing);

    await tester.tap(find.byKey(P2PAntiPhishingCodePage.revealKey));
    await tester.pumpAndSettle();

    expect(find.text('SECURE2026'), findsOneWidget);

    await tester.tap(find.byKey(P2PAntiPhishingCodePage.editKey));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(P2PAntiPhishingCodePage.inputKey),
      'guard2026',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PAntiPhishingCodePage.saveKey));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận thay đổi mã chống lừa đảo'), findsOneWidget);
    expect(find.byKey(P2PAntiPhishingCodePage.saveConfirmKey), findsOneWidget);
    expect(find.text('GU•••••26'), findsOneWidget);

    await tester.tap(find.byKey(P2PAntiPhishingCodePage.saveConfirmKey));
    await tester.pumpAndSettle();

    expect(find.text('GUARD2026'), findsOneWidget);
  });

  testWidgets('SC-256 cancel keeps edit mode and does not apply the code', (
    tester,
  ) async {
    await pumpAntiPhishing(tester);

    await tester.tap(find.byKey(P2PAntiPhishingCodePage.editKey));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(P2PAntiPhishingCodePage.inputKey),
      'guard2026',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PAntiPhishingCodePage.saveKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(P2PAntiPhishingCodePage.saveCancelKey));
    await tester.pumpAndSettle();

    expect(find.byKey(P2PAntiPhishingCodePage.inputKey), findsOneWidget);
    expect(find.text('Thiết lập code'), findsOneWidget);
  });

  testWidgets('SC-256 back returns to P2P security center', (tester) async {
    await pumpAntiPhishing(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PSecurityCenterPage), findsOneWidget);
  });
}
