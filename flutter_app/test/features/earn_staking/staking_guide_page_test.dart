import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_guide_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpGuide(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnGuide,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-369 mock repository exposes staking guide BE draft', () async {
    final snapshot = await const MockStakingGuideRepository().getGuide();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-guide');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Hướng dẫn Staking');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.stakingRoute, AppRoutePaths.earnStaking);
    expect(snapshot.tutorials, hasLength(3));
    expect(snapshot.quickTips, hasLength(6));
    expect(snapshot.mistakes, hasLength(4));
    expect(snapshot.ctaLabel, 'Stake ngay');
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

  testWidgets('SC-369 renders beginner staking guide baseline', (tester) async {
    await pumpGuide(tester);

    expect(find.byType(StakingGuidePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hướng dẫn Staking'), findsOneWidget);
    expect(find.byKey(StakingGuidePage.heroKey), findsOneWidget);
    expect(find.text('Học Staking từ Zero'), findsOneWidget);
    expect(find.byKey(StakingGuidePage.tabsKey), findsOneWidget);
    expect(find.text('Beginner'), findsOneWidget);
    expect(find.text('Intermediate'), findsOneWidget);
    expect(find.text('Advanced'), findsOneWidget);
    expect(find.byKey(StakingGuidePage.tutorialsKey), findsOneWidget);
    expect(find.byKey(StakingGuidePage.tutorialKey('basic')), findsOneWidget);
    expect(find.text('Staking Cơ bản'), findsOneWidget);
    expect(find.byKey(StakingGuidePage.quickTipsKey), findsOneWidget);
    expect(find.text('Bắt đầu nhỏ'), findsOneWidget);
    expect(find.text('Theo dõi APY'), findsOneWidget);
    expect(find.byKey(StakingGuidePage.mistakesKey), findsOneWidget);
  });

  testWidgets('SC-369 switches difficulty tabs', (tester) async {
    await pumpGuide(tester);

    await tester.tap(find.text('Intermediate'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(StakingGuidePage.tutorialKey('advanced')),
      findsOneWidget,
    );
    expect(find.text('Staking Nâng cao'), findsOneWidget);

    await tester.tap(find.text('Advanced'));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingGuidePage.tutorialKey('risk')), findsOneWidget);
    expect(find.text('Quản lý Rủi ro'), findsOneWidget);
  });

  testWidgets('SC-369 opens tutorial sheet and advances steps', (tester) async {
    await pumpGuide(tester);

    await tester.tap(find.byKey(StakingGuidePage.tutorialKey('basic')));
    await tester.pumpAndSettle();

    expect(find.byKey(StakingGuidePage.tutorialSheetKey), findsOneWidget);
    expect(find.text('Staking là gì?'), findsOneWidget);
    expect(find.text('Tips quan trọng'), findsOneWidget);

    await tester.tap(find.text('Tiếp theo'));
    await tester.pumpAndSettle();

    expect(find.text('Chọn loại Staking'), findsOneWidget);
  });

  testWidgets('SC-369 CTA and back navigation return to staking hub', (
    tester,
  ) async {
    await pumpGuide(tester);

    await tester.ensureVisible(find.byKey(StakingGuidePage.ctaKey));
    await tester.tap(find.text('Stake ngay'));
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);

    await pumpGuide(tester);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
  });
}
