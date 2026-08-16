import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/support/data/support_repository.dart';
import 'package:vit_trade_flutter/features/support/presentation/phone/pages/help_center_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpHelp(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.supportHelp,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-292 mock repository exposes support help BE draft', () async {
    final snapshot = await const MockSupportRepository(
      loadDelay: Duration.zero,
    ).getHelpCenter();

    expect(snapshot.endpoint, '/api/mobile/support/support-help');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Trung tâm trợ giúp');
    expect(snapshot.subtitle, 'Trung tâm · Hỗ trợ');
    expect(snapshot.backRoute, AppRoutePaths.support);
    expect(snapshot.chatRoute, AppRoutePaths.support);
    expect(snapshot.ticketRoute, AppRoutePaths.support);
    expect(snapshot.categories, hasLength(8));
    expect(snapshot.articles, hasLength(8));
    expect(snapshot.categories.first.name, 'Bắt đầu');
    expect(snapshot.articles.first.title, 'Cách tạo tài khoản VitTrade');
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

  testWidgets('SC-292 renders help center baseline', (tester) async {
    await pumpHelp(tester);

    expect(find.byType(HelpCenterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Trung tâm trợ giúp'), findsOneWidget);
    expect(find.text('Trung tâm · Hỗ trợ'), findsOneWidget);
    expect(find.text('Bạn cần giúp gì?'), findsOneWidget);
    expect(find.byKey(HelpCenterPage.searchKey), findsOneWidget);
    expect(find.text('Chat hỗ trợ'), findsOneWidget);
    expect(find.text('Gửi ticket'), findsOneWidget);
    expect(find.byKey(HelpCenterPage.categoriesKey), findsOneWidget);
    expect(find.text('Danh mục'), findsOneWidget);
    expect(find.text('Bắt đầu'), findsOneWidget);
    expect(find.text('API Trading'), findsOneWidget);
    expect(find.byKey(HelpCenterPage.articlesKey), findsOneWidget);
    expect(find.text('Bài viết phổ biến'), findsOneWidget);
    expect(find.text('Cách tạo tài khoản VitTrade'), findsOneWidget);
  });

  testWidgets('SC-292 search filters help articles and empty state', (
    tester,
  ) async {
    await pumpHelp(tester);

    await tester.enterText(find.byType(TextField), '2FA');
    await tester.pumpAndSettle();

    expect(find.text('Kết quả (1)'), findsOneWidget);
    expect(find.text('Cách bật xác thực 2 lớp (2FA)'), findsOneWidget);
    expect(find.text('Cách tạo tài khoản VitTrade'), findsNothing);

    await tester.enterText(find.byType(TextField), 'không tồn tại');
    await tester.pumpAndSettle();

    expect(find.text('Kết quả (0)'), findsOneWidget);
    expect(find.byKey(HelpCenterPage.emptyKey), findsOneWidget);
    expect(find.text('Không tìm thấy bài viết'), findsOneWidget);
  });

  testWidgets('SC-292 category filter and article expansion work', (
    tester,
  ) async {
    await pumpHelp(tester);

    await tester.ensureVisible(find.byKey(HelpCenterPage.categoryKey('p2p')));
    await tester.tap(find.byKey(HelpCenterPage.categoryKey('p2p')));
    await tester.pumpAndSettle();

    expect(find.text('P2P Trading'), findsWidgets);
    expect(find.text('Quy trình giao dịch P2P'), findsOneWidget);
    expect(find.text('Cách tạo tài khoản VitTrade'), findsNothing);

    await tester.tap(find.byKey(HelpCenterPage.articleKey('h007')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Hướng dẫn mua/bán USDT'), findsOneWidget);
  });

  testWidgets('SC-292 support actions and back edge use support hub', (
    tester,
  ) async {
    await pumpHelp(tester);

    await tester.tap(find.byKey(HelpCenterPage.chatActionKey));
    await tester.pumpAndSettle();
    expect(find.text('Liên hệ · Hỗ trợ'), findsOneWidget);

    await pumpHelp(tester);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Liên hệ · Hỗ trợ'), findsOneWidget);
  });
}
