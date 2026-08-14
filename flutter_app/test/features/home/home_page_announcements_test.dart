import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/home_mock_data.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';
import 'package:vit_trade_flutter/features/home/presentation/pages/home_page.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/withdraw_page.dart';

void main() {
  Future<void> pumpHome(
    WidgetTester tester, {
    HomeSnapshot? snapshot,
    bool simulateError = false,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            snapshot != null
                ? _StaticHomeRepository(snapshot)
                : MockHomeRepository(
                    simulateError: simulateError,
                    loadDelay: Duration.zero,
                  ),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SC-007 campaign announcement hides after session scroll', (
    tester,
  ) async {
    await pumpHome(
      tester,
      snapshot: _homeSnapshotWithAnnouncements(const [
        HomeAnnouncement(
          id: 'campaign-test',
          text: 'Campaign test',
          type: HomeAnnouncementType.campaign,
        ),
      ]),
    );

    expect(find.text('Campaign test'), findsOneWidget);

    await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -260));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(find.text('Campaign test'), findsNothing);
  });

  testWidgets('SC-007 security announcement does not auto-hide on scroll', (
    tester,
  ) async {
    await pumpHome(
      tester,
      snapshot: _homeSnapshotWithAnnouncements(const [
        HomeAnnouncement(
          id: 'security-test',
          text: 'Security test',
          type: HomeAnnouncementType.security,
        ),
      ]),
    );

    expect(find.text('Security test'), findsOneWidget);

    await tester.drag(find.byKey(HomePage.contentKey), const Offset(0, -260));
    await tester.pumpAndSettle(const Duration(milliseconds: 220));

    expect(find.text('Security test'), findsOneWidget);
  });

  testWidgets('SC-007 security announcement is prioritized over campaign', (
    tester,
  ) async {
    await pumpHome(
      tester,
      snapshot: _homeSnapshotWithAnnouncements(const [
        HomeAnnouncement(
          id: 'campaign-test',
          text: 'Campaign test',
          type: HomeAnnouncementType.campaign,
        ),
        HomeAnnouncement(
          id: 'security-test',
          text: 'Security test',
          type: HomeAnnouncementType.security,
        ),
      ]),
    );

    expect(find.text('Security test'), findsOneWidget);
    expect(find.text('Campaign test'), findsNothing);
  });

  testWidgets('SC-007 announcement cycles on tap', (tester) async {
    await pumpHome(
      tester,
      snapshot: _homeSnapshotWithAnnouncements(const [
        HomeAnnouncement(
          id: 'security-test',
          text: 'Security test',
          type: HomeAnnouncementType.security,
        ),
        HomeAnnouncement(
          id: 'campaign-test',
          text: 'Campaign test',
          type: HomeAnnouncementType.campaign,
        ),
      ]),
    );

    expect(find.text('Security test'), findsOneWidget);

    await tester.tap(find.byKey(HomePage.announcementKey));
    await tester.pumpAndSettle();

    expect(find.text('Campaign test'), findsOneWidget);
  });

  testWidgets('SC-007 opens the next action route from Home', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(HomePage.nextActionKey));
    await tester.pumpAndSettle();

    expect(find.byType(WithdrawPage), findsOneWidget);
  });

  testWidgets('SC-007 hides next action after dismiss', (tester) async {
    await pumpHome(tester);

    expect(find.byKey(HomePage.nextActionKey), findsOneWidget);

    await tester.tap(find.byTooltip('Ẩn gợi ý'));
    await tester.pumpAndSettle();

    expect(find.byKey(HomePage.nextActionKey), findsNothing);
  });

  testWidgets('SC-007 hides next action when snapshot has none', (
    tester,
  ) async {
    await pumpHome(tester, snapshot: _homeSnapshotWithoutNextAction());

    expect(find.byKey(HomePage.nextActionKey), findsNothing);
  });
}

final class _StaticHomeRepository implements HomeRepository {
  const _StaticHomeRepository(this.snapshot);

  final HomeSnapshot snapshot;

  @override
  Future<HomeSnapshot> fetchHome() async => snapshot;
}

HomeSnapshot _homeSnapshotWithAnnouncements(
  List<HomeAnnouncement> announcements,
) {
  final snapshot = HomeMockData.snapshot;
  return HomeSnapshot(
    totalBalance: snapshot.totalBalance,
    totalBtc: snapshot.totalBtc,
    spotBalance: snapshot.spotBalance,
    earnBalance: snapshot.earnBalance,
    fundingBalance: snapshot.fundingBalance,
    dailyPnl: snapshot.dailyPnl,
    dailyPct: snapshot.dailyPct,
    portfolioTrend7d: snapshot.portfolioTrend7d,
    notifications: snapshot.notifications,
    announcements: announcements,
    quickActions: snapshot.quickActions,
    nextAction: snapshot.nextAction,
    recentProducts: snapshot.recentProducts,
    pairs: snapshot.pairs,
  );
}

HomeSnapshot _homeSnapshotWithoutNextAction() {
  final snapshot = HomeMockData.snapshot;
  return HomeSnapshot(
    totalBalance: snapshot.totalBalance,
    totalBtc: snapshot.totalBtc,
    spotBalance: snapshot.spotBalance,
    earnBalance: snapshot.earnBalance,
    fundingBalance: snapshot.fundingBalance,
    dailyPnl: snapshot.dailyPnl,
    dailyPct: snapshot.dailyPct,
    portfolioTrend7d: snapshot.portfolioTrend7d,
    notifications: snapshot.notifications,
    announcements: snapshot.announcements,
    quickActions: snapshot.quickActions,
    nextAction: null,
    recentProducts: snapshot.recentProducts,
    pairs: snapshot.pairs,
  );
}
