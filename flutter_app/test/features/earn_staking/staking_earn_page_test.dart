import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_dashboard_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpStakingEarn(
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
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.earn),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> pumpStakingRoute(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnStaking,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-327 mock repository exposes Earn BE draft', () async {
    final snapshot = await const MockStakingEarnRepository().getStakingEarn();

    expect(snapshot.endpoint, '/api/mobile/earn/earn');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Staking & Earn');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.savingsRoute, '/earn/savings');
    expect(snapshot.products, hasLength(6));
    expect(snapshot.positions, hasLength(2));
    expect(snapshot.contractNotes, contains('earnProducts'));
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

  test('SC-328 mock repository exposes staking route BE draft', () async {
    final snapshot = await const MockStakingEarnRepository().getStakingEarn(
      route: StakingEarnRoute.staking,
    );

    expect(snapshot.endpoint, '/api/mobile/earn/earn-staking');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.products, hasLength(6));
    expect(snapshot.supportedStates, contains(EarnScreenState.offline));
  });

  test('SC-327 keeps the Home-standard page foundation contract', () {
    final pageSource = File(
      'lib/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart',
    ).readAsStringSync();

    expect(pageSource, contains('VitInsetScrollView'));
    expect(pageSource, contains('VitContentPadding.compact'));
    expect(pageSource, contains('VitDensity.compact'));
    expect(
      pageSource,
      isNot(contains('EarnSpacingTokens.earnBottomInsetPadding')),
    );
    expect(pageSource, isNot(contains('child: Column(')));
  });

  test('SC-327 keeps positions cards compact and readable', () {
    final positionsSource = File(
      'lib/features/earn_staking/presentation/widgets/staking/staking_earn_positions_common.dart',
    ).readAsStringSync();

    expect(positionsSource, contains('_PositionStatRow'));
    expect(positionsSource, contains('AppTextStyles.baseMedium'));
    expect(positionsSource, contains('AppTextStyles.amountSm'));
    expect(positionsSource, contains('AppTextStyles.body.copyWith'));
    expect(positionsSource, isNot(contains('GridView.count')));
    expect(
      positionsSource,
      isNot(contains('stakingCommunityPositionsGridAspect')),
    );
  });

  testWidgets('SC-327 renders staking earn product baseline', (tester) async {
    await pumpStakingEarn(tester);

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
    expect(find.text('Sản phẩm'), findsOneWidget);
    expect(find.text('Của tôi (2)'), findsOneWidget);
    expect(find.text('Bitcoin Fixed'), findsOneWidget);
    expect(find.text('Ethereum Flexible'), findsOneWidget);
    expect(find.text('5.8%'), findsOneWidget);
    expect(find.text('Rui ro: Thap'), findsWidgets);
    expect(find.text('APY ước tính'), findsWidgets);
    expect(find.textContaining('APY là ước tính tham khảo'), findsOneWidget);
    expect(find.byKey(StakingEarnPage.dashboardButtonKey), findsOneWidget);
    expect(find.byKey(StakingEarnPage.savingsButtonKey), findsOneWidget);
    expect(find.text('Tiết kiệm'), findsOneWidget);
    expect(find.byKey(StakingEarnPage.toolsSectionKey), findsOneWidget);
    expect(find.byKey(StakingEarnPage.toolKey('analytics')), findsOneWidget);
    expect(find.byKey(StakingEarnPage.toolKey('staking')), findsOneWidget);
    expect(find.byKey(StakingEarnPage.legalEntryKey), findsOneWidget);
  });

  testWidgets('SC-327 360px viewport follows Home rhythm', (tester) async {
    await pumpStakingEarn(tester, viewport: const Size(360, 800));

    final navTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;
    final heroRect = tester.getRect(find.byType(VitCard).first);
    final tabsRect = tester.getRect(find.byType(VitTabBar).first);
    final firstProductRect = tester.getRect(
      find.byKey(StakingEarnPage.productKey('btc-fixed-90')),
    );

    expect(heroRect.left, lessThanOrEqualTo(24));
    expect(heroRect.width, greaterThanOrEqualTo(312));
    expect(tabsRect.left, heroRect.left);
    expect(tabsRect.width, heroRect.width);
    expect(firstProductRect.top, lessThan(navTop - 24));
  });

  testWidgets('SC-327 filters products and switches positions tab', (
    tester,
  ) async {
    await pumpStakingEarn(tester);

    await tester.tap(find.byKey(StakingEarnPage.filterKey('defi')));
    await tester.pump();
    expect(find.text('ETH-USDT LP Pool'), findsOneWidget);
    expect(find.text('Bitcoin Fixed'), findsNothing);

    await tester.tap(find.text('Của tôi (2)'));
    await tester.pump();
    expect(find.text('Thu nhap uoc tinh'), findsOneWidget);
    expect(find.text('0.05 BTC'), findsOneWidget);

    await tester.tap(find.text('Sản phẩm'));
    await tester.pump();
    expect(find.text('Thu nhap uoc tinh'), findsNothing);
    expect(find.text('ETH-USDT LP Pool'), findsOneWidget);
  });

  testWidgets('SC-327 navigation edges open dashboard, savings and home', (
    tester,
  ) async {
    await pumpStakingEarn(tester);

    await tester.tap(find.byKey(StakingEarnPage.dashboardButtonKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(StakingDashboardPage), findsOneWidget);

    await pumpStakingEarn(tester);
    await tester.tap(find.byKey(StakingEarnPage.savingsButtonKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(SavingsPage), findsOneWidget);

    await pumpStakingEarn(tester);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('SC-327 product detail CTA shows placeholder feedback', (
    tester,
  ) async {
    await pumpStakingEarn(tester);

    await tester.tap(find.text('Xem chi tiet').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Xem chi tiết sản phẩm sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('STEP-P3.2 opens Earn legal sheet with grouped GOM rows', (
    tester,
  ) async {
    await pumpStakingEarn(tester);

    await tester.ensureVisible(find.byKey(StakingEarnPage.legalEntryKey));
    await tester.tap(find.byKey(StakingEarnPage.legalEntryKey));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingEarnPage.legalSheetKey), findsOneWidget);
    expect(find.text('Tài liệu & rủi ro'), findsWidgets);
    expect(
      find.byKey(StakingEarnPage.legalGroupKey('legal-terms')),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingEarnPage.legalItemKey('staking-terms')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(StakingEarnPage.legalGroupKey('community-governance')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(StakingEarnPage.legalItemKey('voting-proposal-demo')),
      findsOneWidget,
    );
  });

  testWidgets('SC-328 renders the staking route variant', (tester) async {
    await pumpStakingRoute(tester);

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
    expect(find.text('Bitcoin Fixed'), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
  });
}
