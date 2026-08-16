import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_blacklist_add_page.dart';
import 'package:vit_trade_flutter/features/p2p_security/presentation/pages/security/p2p_blacklist_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBlacklistAdd(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pBlacklistAdd,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-276 mock repository exposes blacklist add BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getBlacklistAdd();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-blacklist-add');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable',
    );
    expect(snapshot.title, 'Thêm vào blacklist');
    expect(snapshot.subtitle, 'An toàn · P2P');
    expect(snapshot.heroTitle, 'Chặn người dùng');
    expect(snapshot.reasons, hasLength(5));
    expect(snapshot.reasons.first.id, 'scam');
    expect(snapshot.parentRoute, AppRoutePaths.p2pBlacklist);
    expect(snapshot.blacklistRoute, AppRoutePaths.p2pBlacklist);
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

  testWidgets('SC-276 renders blacklist add baseline', (tester) async {
    await pumpBlacklistAdd(tester);

    expect(find.byType(P2PBlacklistAddPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thêm vào blacklist'), findsOneWidget);
    expect(find.text('An toàn · P2P'), findsOneWidget);
    expect(find.byKey(P2PBlacklistAddPage.heroKey), findsOneWidget);
    expect(find.text('Chặn người dùng'), findsAtLeastNWidgets(1));
    expect(find.text('Tên người dùng *'), findsOneWidget);
    expect(find.text('Nhập username...'), findsOneWidget);
    expect(find.byKey(P2PBlacklistAddPage.reasonKey('scam')), findsOneWidget);
    expect(find.text('Lừa đảo'), findsOneWidget);
    expect(find.text('Không phản hồi'), findsOneWidget);
    expect(find.text('Ghi chú (tùy chọn)'), findsOneWidget);
    expect(find.byKey(P2PBlacklistAddPage.warningKey), findsOneWidget);
    expect(find.text('Chặn người dùng'), findsAtLeastNWidgets(1));
  });

  testWidgets('SC-276 first viewport reaches user and reason controls', (
    tester,
  ) async {
    await pumpBlacklistAdd(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-276 P2PBlacklistAddPage',
      semanticLabel: 'Thêm vào danh sách chặn P2P',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(const Key('sc276_p2p_blacklist_add_username_control')),
      routeName: 'SC-276 P2PBlacklistAddPage',
      actionLabel: 'blocked username field',
      minVisibleHeight: 48,
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(P2PBlacklistAddPage.reasonKey('scam')),
      routeName: 'SC-276 P2PBlacklistAddPage',
      actionLabel: 'first blacklist reason',
      minVisibleHeight: 39,
    );
    expect(
      tester.getSize(find.byKey(P2PBlacklistAddPage.heroKey)).height,
      lessThanOrEqualTo(112),
      reason: 'Blacklist add hero should not push form controls down.',
    );
  });

  testWidgets('SC-276 reason selection updates form state', (tester) async {
    await pumpBlacklistAdd(tester);

    await tester.tap(find.byKey(P2PBlacklistAddPage.reasonKey('harassment')));
    await tester.pumpAndSettle();

    final selectedTile = tester.widget<VitCard>(
      find.byKey(P2PBlacklistAddPage.reasonKey('harassment')),
    );
    expect(selectedTile.borderColor, AppColors.accent.withValues(alpha: .46));
  });

  testWidgets('SC-276 submit navigates to blacklist route', (tester) async {
    await pumpBlacklistAdd(tester);

    await tester.enterText(
      find.byKey(P2PBlacklistAddPage.usernameKey),
      'bad_actor',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(P2PBlacklistAddPage.submitKey));
    await tester.tap(find.byKey(P2PBlacklistAddPage.submitKey));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.text('Xác nhận chặn người dùng P2P'), findsOneWidget);
    await tester.tap(find.byKey(P2PBlacklistAddPage.confirmKey));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();

    expect(find.byType(P2PBlacklistAddPage), findsNothing);
    expect(find.byType(P2PBlacklistPage), findsOneWidget);
  });

  testWidgets('SC-276 header back returns to blacklist parent', (tester) async {
    await pumpBlacklistAdd(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(P2PBlacklistAddPage), findsNothing);
    expect(find.byType(P2PBlacklistPage), findsOneWidget);
  });
}
