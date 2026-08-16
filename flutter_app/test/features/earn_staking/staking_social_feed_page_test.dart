import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_social_feed_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSocialFeed(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnSocialFeed,
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

  test('SC-387 mock repository exposes social feed BE draft', () async {
    final snapshot = await const MockStakingSocialFeedRepository().getFeed();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-social-feed');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Community Feed');
    expect(snapshot.backRoute, AppRoutePaths.earn);
    expect(snapshot.tabs.map((tab) => tab.id), [
      'trending',
      'following',
      'my-posts',
    ]);
    expect(snapshot.defaultTabId, 'trending');
    expect(snapshot.posts, hasLength(4));
    expect(snapshot.posts.first.author, 'CryptoWhale');
    expect(snapshot.posts[1].apy, '4.5% APY');
    expect(snapshot.stats.last.value, '89%');
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

  testWidgets('SC-387 renders feed hero, composer, and trending posts', (
    tester,
  ) async {
    await pumpSocialFeed(tester);

    expect(find.byType(StakingSocialFeedPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Community Feed'), findsOneWidget);
    expect(find.byKey(StakingSocialFeedPage.infoKey), findsOneWidget);
    expect(find.text('Share Your Staking Journey'), findsOneWidget);
    expect(find.textContaining('Connect with fellow stakers'), findsOneWidget);
    expect(find.byKey(StakingSocialFeedPage.composerKey), findsOneWidget);
    expect(
      find.text('Share your staking wins, tips, or questions...'),
      findsOneWidget,
    );
    expect(find.byKey(StakingSocialFeedPage.tabsKey), findsOneWidget);
    expect(find.text('Trending Posts'), findsOneWidget);
    expect(find.byKey(StakingSocialFeedPage.postKey('p1')), findsOneWidget);
    expect(find.text('CryptoWhale'), findsOneWidget);
    expect(find.text('VIP'), findsOneWidget);
    expect(find.text('Milestone'), findsOneWidget);
    expect(find.text('234'), findsOneWidget);
  });

  testWidgets('SC-387 first viewport reaches feed composer', (tester) async {
    await pumpSocialFeed(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-387 StakingSocialFeedPage',
      semanticLabel: 'Bảng tin cộng đồng staking',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingSocialFeedPage.composerKey),
      routeName: 'SC-387 StakingSocialFeedPage',
      actionLabel: 'the community composer',
    );
  });

  testWidgets('SC-387 switches social feed section tabs', (tester) async {
    await pumpSocialFeed(tester);

    await tester.tap(find.text('Following'));
    await tester.pumpAndSettle();
    expect(find.text('From People You Follow'), findsOneWidget);

    await tester.tap(find.text('My Posts'));
    await tester.pumpAndSettle();
    expect(find.text('Your Posts'), findsOneWidget);
    expect(find.text('SafeStaker'), findsOneWidget);
  });

  testWidgets('SC-387 renders stats and community guidelines footer', (
    tester,
  ) async {
    await pumpSocialFeed(tester);

    await tester.ensureVisible(find.byKey(StakingSocialFeedPage.statsKey));
    await tester.pumpAndSettle();

    expect(find.text('Community Stats'), findsOneWidget);
    expect(find.text('12.5K'), findsOneWidget);
    expect(find.text('Members'), findsOneWidget);
    expect(find.text('3.2K'), findsOneWidget);
    expect(find.text('Posts Today'), findsOneWidget);
    expect(find.text('89%'), findsOneWidget);
    expect(find.text('Active Rate'), findsOneWidget);

    await tester.ensureVisible(find.byKey(StakingSocialFeedPage.footerKey));
    await tester.pumpAndSettle();
    expect(find.textContaining('Community guidelines apply'), findsOneWidget);
    expect(
      find.textContaining('referral links are prohibited'),
      findsOneWidget,
    );
  });

  testWidgets('SC-387 header back returns to Earn route', (tester) async {
    await pumpSocialFeed(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
  });
}
