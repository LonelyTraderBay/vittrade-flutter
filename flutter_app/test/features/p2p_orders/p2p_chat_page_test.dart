import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_chat_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/phone/pages/security/p2p_e2e_info_page.dart';
import 'package:vit_trade_flutter/features/p2p_orders/presentation/phone/pages/orders/p2p_order_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PChat(
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
            initialLocation: AppRoutePaths.p2pChat('p2p001'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-217 mock repository exposes P2P chat BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getChat('p2p001');

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-chat-p2p001');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.orderId, 'p2p001');
    expect(snapshot.merchant, 'CryptoKing_VN');
    expect(snapshot.messages.length, 5);
    expect(snapshot.quickReplies, contains('Tôi đã chuyển khoản xong'));
    expect(snapshot.contractNotes, contains('escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-217 renders encrypted P2P chat baseline', (tester) async {
    await pumpP2PChat(tester);

    expect(find.byType(P2PChatPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('CryptoKing_VN'), findsOneWidget);
    expect(find.text('Đang hoạt động'), findsOneWidget);
    expect(find.text('Chi tiết'), findsOneWidget);
    expect(
      find.text('Không chia sẻ thông tin cá nhân hay mật khẩu trong chat.'),
      findsOneWidget,
    );
    expect(find.text('Mã hóa đầu cuối (E2E)'), findsOneWidget);
    expect(find.text('Tin nhắn được mã hóa đầu cuối'), findsOneWidget);
    expect(find.text('Hôm nay'), findsOneWidget);
    expect(
      find.text('Đã chuyển khoản xong, vui lòng xác nhận nhé!'),
      findsOneWidget,
    );
    expect(find.text('Chia sẻ bằng chứng'), findsOneWidget);
    expect(find.byKey(P2PChatPage.inputKey), findsOneWidget);
  });

  testWidgets('SC-320 uses full-height chat workspace at 360x800', (
    tester,
  ) async {
    await pumpP2PChat(tester, viewport: const Size(360, 800));

    expect(find.byType(P2PChatPage), findsOneWidget);
    expect(find.byKey(P2PChatPage.contentKey), findsOneWidget);
    expect(find.byKey(P2PChatPage.inputKey), findsOneWidget);
    expect(find.byKey(P2PChatPage.sendKey), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);

    final contentRect = tester.getRect(find.byKey(P2PChatPage.contentKey));
    final inputRect = tester.getRect(find.byKey(P2PChatPage.inputKey));
    final sendRect = tester.getRect(find.byKey(P2PChatPage.sendKey));

    expect(contentRect.left, closeTo(0, 0.5));
    expect(contentRect.right, closeTo(360, 0.5));
    expect(contentRect.height, greaterThan(220));
    expect(inputRect.bottom, lessThanOrEqualTo(800));
    expect(sendRect.bottom, lessThanOrEqualTo(800));
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-217 quick reply and send add local message', (tester) async {
    await pumpP2PChat(tester);

    await tester.tap(
      find.byKey(P2PChatPage.quickReplyKey('Tôi đã chuyển khoản xong')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tôi đã chuyển khoản xong'), findsWidgets);

    await tester.tap(find.byKey(P2PChatPage.sendKey));
    await tester.pumpAndSettle();
    expect(find.text('11:08'), findsOneWidget);
  });

  testWidgets('SC-217 attach image action shows coming-soon snackbar', (
    tester,
  ) async {
    await pumpP2PChat(tester);

    await tester.tap(find.byTooltip('Attach payment proof image'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(
      find.text('Đính kèm ảnh bằng chứng thanh toán sẽ sớm ra mắt'),
      findsOneWidget,
    );
  });

  testWidgets('SC-217 detail and E2E actions navigate safely', (tester) async {
    await pumpP2PChat(tester);

    await tester.tap(find.byKey(P2PChatPage.detailKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2POrderPage), findsOneWidget);

    await pumpP2PChat(tester);
    await tester.tap(find.byKey(P2PChatPage.e2eKey));
    await tester.pumpAndSettle();
    expect(find.byType(P2PE2EInfoPage), findsOneWidget);
  });
}
