import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/support/data/support_repository.dart';
import 'package:vit_trade_flutter/features/support/presentation/phone/pages/announcements_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAnnouncements(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.supportAnnouncements,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-293 mock repository exposes support announcements BE draft',
    () async {
      final snapshot = await const MockSupportRepository(
        loadDelay: Duration.zero,
      ).getAnnouncements();

      expect(snapshot.endpoint, '/api/mobile/support/support-announcements');
      expect(snapshot.actionDraft, 'read-only or local navigation action');
      expect(snapshot.title, 'Thông báo');
      expect(snapshot.subtitle, 'Thông báo · Hỗ trợ');
      expect(snapshot.backRoute, AppRoutePaths.support);
      expect(snapshot.filters.map((item) => item.label), [
        'Tất cả',
        'Khuyến mãi',
        'Tính năng',
        'Niêm yết',
        'Bảo trì',
        'Bảo mật',
      ]);
      expect(snapshot.announcements, hasLength(5));
      expect(
        snapshot.announcements.where((item) => item.isPinned),
        hasLength(2),
      );
      expect(
        snapshot.announcements.first.title,
        'Phí giao dịch 0% cho BTC/USDT',
      );
      expect(snapshot.contractNotes, contains('announcements'));
      expect(
        snapshot.supportedStates,
        containsAll([
          SupportScreenState.loading,
          SupportScreenState.empty,
          SupportScreenState.error,
          SupportScreenState.offline,
        ]),
      );
    },
  );

  testWidgets('SC-293 renders announcements baseline', (tester) async {
    await pumpAnnouncements(tester);

    expect(find.byType(AnnouncementsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thông báo'), findsOneWidget);
    expect(find.text('Thông báo · Hỗ trợ'), findsOneWidget);
    expect(find.byKey(AnnouncementsPage.filtersKey), findsOneWidget);
    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('Khuyến mãi'), findsWidgets);
    expect(find.byKey(AnnouncementsPage.pinnedKey), findsOneWidget);
    expect(find.text('GHIM'), findsOneWidget);
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsOneWidget);
    expect(find.text('Ra mắt tính năng P2P Trading'), findsOneWidget);
    expect(find.byKey(AnnouncementsPage.listKey), findsOneWidget);
    expect(find.text('Listing mới: MATIC/USDT'), findsOneWidget);
    expect(find.text('Bảo trì hệ thống định kỳ'), findsOneWidget);
  });

  testWidgets('SC-293 first viewport reaches announcement filters', (
    tester,
  ) async {
    await pumpAnnouncements(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-293 AnnouncementsPage',
      semanticLabel: 'Thông báo',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(AnnouncementsPage.filterKey('all')),
      routeName: 'SC-293 AnnouncementsPage',
      actionLabel: 'the all announcements filter',
    );
  });

  testWidgets('SC-293 filters announcements by type', (tester) async {
    await pumpAnnouncements(tester);

    await tester.tap(find.byKey(AnnouncementsPage.filterKey('new-feature')));
    await tester.pumpAndSettle();

    expect(find.text('Ra mắt tính năng P2P Trading'), findsOneWidget);
    expect(find.byKey(AnnouncementsPage.pinnedKey), findsOneWidget);
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsNothing);

    await tester.drag(
      find.byKey(AnnouncementsPage.filtersKey),
      const Offset(-360, 0),
    );
    await tester.pumpAndSettle();

    final securityFilter = find.byKey(AnnouncementsPage.filterKey('security'));
    await tester.ensureVisible(securityFilter);
    await tester.pumpAndSettle();
    await tester.tap(securityFilter);
    await tester.pumpAndSettle();

    expect(find.text('Tăng cường bảo mật tài khoản'), findsOneWidget);
    expect(find.text('Phí giao dịch 0% cho BTC/USDT'), findsNothing);
    expect(find.byKey(AnnouncementsPage.pinnedKey), findsNothing);
  });

  testWidgets('SC-293 announcement card expands content and tags', (
    tester,
  ) async {
    await pumpAnnouncements(tester);

    await tester.tap(find.byKey(AnnouncementsPage.announcementKey('news001')));
    await tester.pumpAndSettle();

    expect(find.textContaining('Từ ngày 23/02 đến 29/02'), findsOneWidget);
    expect(find.text('#BTC'), findsOneWidget);
    expect(find.text('#Phí'), findsOneWidget);
  });

  testWidgets('SC-293 scroll offset is retained after dragging down', (
    tester,
  ) async {
    await pumpAnnouncements(tester);

    final content = find.byKey(AnnouncementsPage.contentKey);
    await tester.drag(content, const Offset(0, -220));
    await tester.pumpAndSettle();

    final verticalScrollable = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    );
    final offset = tester
        .state<ScrollableState>(verticalScrollable.first)
        .position
        .pixels;

    expect(
      offset,
      greaterThan(8),
      reason:
          'Announcements must keep scroll position; auto-hide header must not snap back.',
    );
    expect(find.text('Bảo trì hệ thống định kỳ'), findsOneWidget);
  });

  testWidgets('SC-293 header back returns to support hub placeholder', (
    tester,
  ) async {
    await pumpAnnouncements(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.text('Liên hệ · Hỗ trợ'), findsOneWidget);
  });
}
