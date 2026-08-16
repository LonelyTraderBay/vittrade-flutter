import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_community_governance_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_forum_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpForum(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnForum,
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

  test('SC-392 mock repository exposes forum BE draft', () async {
    final snapshot = await const MockStakingForumRepository().getForum();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-forum');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Forum');
    expect(snapshot.backRoute, AppRoutePaths.earnCommunityGovernance);
    expect(snapshot.categories, hasLength(4));
    expect(snapshot.categories.first.name, 'General Discussion');
    expect(snapshot.categories.first.threads, 1234);
    expect(snapshot.threads, hasLength(3));
    expect(snapshot.threads.first.pinned, isTrue);
    expect(snapshot.threads[1].author, 'StakeMax');
    expect(snapshot.createLabel, 'Create New Thread');
    expect(snapshot.contractNotes, contains('riskData'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-392 renders forum hero, categories, and thread list', (
    tester,
  ) async {
    await pumpForum(tester);

    expect(find.byType(StakingForumPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Forum'), findsOneWidget);
    expect(find.byKey(StakingForumPage.heroKey), findsOneWidget);
    expect(find.text('Community Forum'), findsOneWidget);
    expect(find.textContaining('Discuss strategies'), findsOneWidget);
    expect(find.byKey(StakingForumPage.categoriesKey), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(
      find.byKey(StakingForumPage.categoryKey('General Discussion')),
      findsOneWidget,
    );
    expect(find.text('Proposals & Voting'), findsOneWidget);
    expect(find.text('1234 threads - 8901 posts'), findsOneWidget);
    expect(find.byKey(StakingForumPage.threadsKey), findsOneWidget);
    expect(find.text('Trending Threads'), findsOneWidget);
    expect(
      find.text('Best validators for ETH staking in 2026?'),
      findsOneWidget,
    );
    expect(find.text('CryptoGuru'), findsOneWidget);
    expect(find.text('5678'), findsOneWidget);
    expect(find.byKey(StakingForumPage.createKey), findsOneWidget);
    expect(find.text('Create New Thread'), findsOneWidget);
  });

  testWidgets('SC-392 governance edge opens forum', (tester) async {
    await pumpForum(
      tester,
      initialLocation: AppRoutePaths.earnCommunityGovernance,
    );

    await tester.ensureVisible(
      find.byKey(StakingCommunityGovernancePage.joinForumKey),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingCommunityGovernancePage.joinForumKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingForumPage), findsOneWidget);
    expect(find.text('Forum'), findsOneWidget);
  });

  testWidgets('SC-392 header back returns to community governance', (
    tester,
  ) async {
    await pumpForum(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingCommunityGovernancePage), findsOneWidget);
    expect(find.text('Governance'), findsOneWidget);
  });

  testWidgets('SC-392 create thread CTA shows coming-soon snack bar', (
    tester,
  ) async {
    await pumpForum(tester);

    await tester.ensureVisible(find.byKey(StakingForumPage.createKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingForumPage.createKey));
    await tester.pumpAndSettle();

    expect(find.text('Tạo chủ đề sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-392 category card tap shows coming-soon snack bar', (
    tester,
  ) async {
    await pumpForum(tester);

    await tester.tap(
      find.byKey(StakingForumPage.categoryKey('General Discussion')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Xem danh mục sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-392 thread card tap shows coming-soon snack bar', (
    tester,
  ) async {
    await pumpForum(tester);

    await tester.ensureVisible(find.byKey(StakingForumPage.threadKey(0)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingForumPage.threadKey(0)));
    await tester.pumpAndSettle();

    expect(find.text('Xem chủ đề sẽ sớm ra mắt'), findsOneWidget);
  });
}
