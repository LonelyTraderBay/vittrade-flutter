import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_disclosure_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskDisclosure(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnStakingRiskDisclosure,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-354 mock repository exposes staking risk BE draft', () async {
    final snapshot = await const MockStakingRiskDisclosureRepository()
        .getDisclosure();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-staking-risk-disclosure');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('/earn/staking/risk-disclosure'));
    expect(snapshot.warningTitle, 'Cảnh báo Rủi ro Quan trọng');
    expect(snapshot.tabs.map((tab) => tab.id), [
      'overview',
      'categories',
      'assessment',
    ]);
    expect(snapshot.riskCounts.map((item) => item.count), [1, 3, 3]);
    expect(snapshot.products, hasLength(3));
    expect(snapshot.categories, hasLength(7));
    expect(snapshot.assessmentRoute, AppRoutePaths.earnStakingRiskAssessment);
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

  testWidgets('SC-354 renders overview baseline in Earn shell', (tester) async {
    await pumpRiskDisclosure(tester);

    expect(find.byType(StakingRiskDisclosurePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Công bố Rủi ro'), findsOneWidget);
    expect(find.text('Cảnh báo Rủi ro Quan trọng'), findsOneWidget);
    expect(find.text('Tổng quan'), findsOneWidget);
    expect(find.text('Tóm tắt Rủi ro'), findsOneWidget);
    expect(find.text('Staking Linh hoạt'), findsOneWidget);
    expect(find.text('Staking Cố định'), findsOneWidget);
    expect(find.text('DeFi Staking'), findsOneWidget);
  });

  testWidgets('SC-354 first viewport reaches first risk product', (
    tester,
  ) async {
    await pumpRiskDisclosure(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-354 StakingRiskDisclosurePage',
      semanticLabel: 'Công bố rủi ro staking theo từng danh mục',
    );
    expectActionableInFirstViewport(
      tester,
      find.text('Staking Linh hoạt'),
      routeName: 'SC-354 StakingRiskDisclosurePage',
      actionLabel: 'the first staking risk product',
    );
  });

  testWidgets('SC-354 switches to category details state', (tester) async {
    await pumpRiskDisclosure(tester);

    await tester.tap(find.text('Các loại rủi ro'));
    await tester.pumpAndSettle();

    expect(find.text('Rủi ro Smart Contract'), findsOneWidget);
    expect(find.text('Rủi ro Pháp lý'), findsOneWidget);

    await tester.tap(
      find.byKey(StakingRiskDisclosurePage.categoryKey('market')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Chi tiết:'), findsWidgets);
    expect(
      find.textContaining('Giá tài sản số có thể giảm 20-80%'),
      findsOneWidget,
    );
    expect(find.text('Cách giảm thiểu:'), findsWidgets);
  });

  testWidgets('SC-354 assessment CTA uses canonical SC-357 route', (
    tester,
  ) async {
    await pumpRiskDisclosure(tester);

    await tester.tap(find.text('Đánh giá'));
    await tester.pumpAndSettle();

    expect(find.text('Đánh giá Rủi ro Cá nhân'), findsOneWidget);
    await tester.tap(find.byKey(StakingRiskDisclosurePage.assessmentCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingRiskDisclosurePage), findsNothing);
    expect(find.text('Đánh giá Rủi ro'), findsOneWidget);
  });

  testWidgets('SC-354 header back returns to staking hub', (tester) async {
    await pumpRiskDisclosure(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
