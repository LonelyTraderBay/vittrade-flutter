import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_chat_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_e2e_info_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpE2EInfo(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pE2EInfo,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpP2PChat(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pChat('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-259 mock repository exposes E2E info BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getE2EInfo();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-e2e-info');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.heroTitle, 'End-to-End Encryption');
    expect(snapshot.infoItems, hasLength(4));
    expect(snapshot.steps, hasLength(4));
    expect(snapshot.parentRoute, AppRoutePaths.p2pChat('p2p001'));
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

  testWidgets('SC-259 renders E2E info baseline', (tester) async {
    await pumpE2EInfo(tester);

    expect(find.byType(P2PE2EInfoPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Mã hóa đầu cuối'), findsOneWidget);
    expect(find.text('Bảo mật · P2P'), findsOneWidget);
    expect(find.byKey(P2PE2EInfoPage.heroKey), findsOneWidget);
    expect(find.text('End-to-End Encryption'), findsOneWidget);
    expect(find.text('Bảo mật cấp quân sự'), findsOneWidget);
    expect(find.byKey(P2PE2EInfoPage.diagramKey), findsOneWidget);
    expect(
      find.text('Chỉ bạn và đối tác mới đọc được tin nhắn'),
      findsOneWidget,
    );
    expect(find.byKey(P2PE2EInfoPage.infoItemsKey), findsOneWidget);
    expect(find.text('AES-256 + RSA-2048'), findsOneWidget);
    expect(find.text('Khóa phiên tạm thời'), findsOneWidget);
    expect(find.text('Xác minh danh tính'), findsOneWidget);
    expect(find.text('Cảnh báo bảo mật'), findsOneWidget);

    await tester.ensureVisible(find.byKey(P2PE2EInfoPage.serverKey));
    expect(find.byKey(P2PE2EInfoPage.fingerprintKey), findsOneWidget);
    expect(find.text('MÃ XÁC MINH BẢO MẬT'), findsOneWidget);
    expect(find.byKey(P2PE2EInfoPage.stepsKey), findsOneWidget);
    expect(find.text('Cách hoạt động'), findsOneWidget);
    expect(find.textContaining('Zero-Knowledge'), findsOneWidget);
  });

  testWidgets('SC-259 first viewport reaches first security item', (
    tester,
  ) async {
    await pumpE2EInfo(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-259 P2PE2EInfoPage',
      semanticLabel: 'Mã hóa đầu cuối P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PE2EInfoPage.infoItemKey('aes_rsa')),
      routeName: 'SC-259 P2PE2EInfoPage',
      actionLabel: 'the first E2E security explanation card',
    );
  });

  testWidgets('SC-259 chat E2E action opens info page', (tester) async {
    await pumpP2PChat(tester);

    await tester.tap(find.byKey(P2PChatPage.e2eKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PE2EInfoPage), findsOneWidget);
  });

  testWidgets('SC-259 back returns to P2P chat', (tester) async {
    await pumpE2EInfo(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PChatPage), findsOneWidget);
  });
}
