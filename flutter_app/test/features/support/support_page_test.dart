import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/features/support/data/support_repository.dart';
import 'package:vit_trade_flutter/features/support/presentation/phone/pages/announcements_page.dart';
import 'package:vit_trade_flutter/features/support/presentation/phone/pages/help_center_page.dart';
import 'package:vit_trade_flutter/features/support/presentation/phone/pages/support_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSupport(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.support,
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

  test('SC-294 mock repository exposes support hub BE draft', () async {
    final snapshot = await const MockSupportRepository(
      loadDelay: Duration.zero,
    ).getSupportHub();

    expect(snapshot.endpoint, '/api/mobile/support/support');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Hỗ trợ');
    expect(snapshot.subtitle, 'Liên hệ · Hỗ trợ');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.helpRoute, AppRoutePaths.supportHelp);
    expect(snapshot.announcementsRoute, AppRoutePaths.supportAnnouncements);
    expect(snapshot.email, 'support@vittrade.vn');
    expect(snapshot.hotline, '1900 xxxx');
    expect(snapshot.tickets, hasLength(2));
    expect(snapshot.faqItems, hasLength(4));
    expect(snapshot.tickets.first.status, SupportTicketStatus.inProgress);
    expect(snapshot.tickets.last.status, SupportTicketStatus.resolved);
    expect(snapshot.contractNotes, contains('supportArticles'));
    expect(
      snapshot.supportedStates,
      containsAll([
        SupportScreenState.loading,
        SupportScreenState.empty,
        SupportScreenState.error,
        SupportScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-294 renders support hub tickets baseline', (tester) async {
    await pumpSupport(tester);

    expect(find.byType(SupportPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hỗ trợ'), findsWidgets);
    expect(find.text('Liên hệ · Hỗ trợ'), findsOneWidget);
    expect(find.byKey(SupportPage.quickLinksKey), findsOneWidget);
    expect(find.text('Trợ giúp'), findsOneWidget);
    expect(find.text('Hệ thống'), findsOneWidget);
    expect(find.text('support@...'), findsOneWidget);
    expect(find.text('1900 xxxx'), findsOneWidget);
    expect(find.text('Tickets (2)'), findsOneWidget);
    expect(find.text('FAQ'), findsOneWidget);
    expect(find.byKey(SupportPage.createTicketKey), findsOneWidget);
    expect(find.text('Tạo ticket mới'), findsOneWidget);
    expect(find.text('ĐANG XỬ LÝ (1)'), findsOneWidget);
    expect(find.byKey(SupportPage.ticketKey('ticket001')), findsOneWidget);
    expect(find.text('Rút USDT bị pending quá lâu'), findsOneWidget);
    expect(find.text('ĐÃ HOÀN THÀNH'), findsOneWidget);
    expect(find.byKey(SupportPage.ticketKey('ticket002')), findsOneWidget);
    expect(find.text('Không thể đăng nhập vào tài khoản'), findsOneWidget);
  });

  testWidgets('SC-294 first viewport reaches support quick actions', (
    tester,
  ) async {
    await pumpSupport(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-294 SupportPage',
      semanticLabel: 'Hỗ trợ',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(SupportPage.quickLinkKey('help')),
      routeName: 'SC-294 SupportPage',
      actionLabel: 'the help center quick action',
    );
  });

  testWidgets('SC-294 renders contextual support route metadata', (
    tester,
  ) async {
    final route = ContextualSupportContracts.supportRouteFor(
      ContextualSupportFlow.withdrawal,
      referenceId: 'tx001',
      sourceRoute: AppRoutePaths.walletWithdrawAsset('USDT'),
    );

    await pumpSupport(tester, initialLocation: route);

    expect(find.byType(SupportPage), findsOneWidget);
    expect(find.byKey(SupportPage.contextKey), findsOneWidget);
    expect(find.text('Hồ sơ hỗ trợ'), findsOneWidget);
    expect(find.text('Withdrawal delayed or failed'), findsOneWidget);
    expect(find.text('Wallet and Treasury'), findsOneWidget);
    expect(find.text('wallet'), findsOneWidget);
    expect(find.text('tx001'), findsOneWidget);
    expect(find.textContaining('Context captured'), findsOneWidget);
    expect(find.textContaining('Wallet operations queue'), findsOneWidget);
  });

  testWidgets('SC-294 quick links navigate to support child routes', (
    tester,
  ) async {
    await pumpSupport(tester);

    await tester.tap(find.byKey(SupportPage.quickLinkKey('help')));
    await tester.pumpAndSettle();
    expect(find.byType(HelpCenterPage), findsOneWidget);
    expect(find.text('Trung tâm trợ giúp'), findsOneWidget);

    await pumpSupport(tester);
    await tester.tap(find.byKey(SupportPage.quickLinkKey('announcements')));
    await tester.pumpAndSettle();
    expect(find.byType(AnnouncementsPage), findsOneWidget);
    expect(find.text('Thông báo'), findsWidgets);
  });

  testWidgets('SC-294 FAQ tab and accordion render answers', (tester) async {
    await pumpSupport(tester);

    await tester.tap(find.byKey(SupportPage.faqTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Câu hỏi thường gặp'), findsOneWidget);
    expect(find.text('Làm sao để nạp tiền vào tài khoản?'), findsOneWidget);

    await tester.tap(find.byKey(SupportPage.faqKey(0)));
    await tester.pumpAndSettle();

    expect(find.textContaining('copy địa chỉ ví'), findsOneWidget);
  });

  testWidgets('SC-294 header back returns to home', (tester) async {
    await pumpSupport(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('VitTrade'), findsOneWidget);
  });
}
