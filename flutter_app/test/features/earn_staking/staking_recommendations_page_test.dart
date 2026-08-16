import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_recommendations_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_assessment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpRecommendations(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnRecommendations,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-372 mock repository exposes staking recommendations BE draft',
    () async {
      final snapshot = await const MockStakingRecommendationsRepository()
          .getRecommendations();

      expect(snapshot.endpoint, '/api/mobile/earn/earn-recommendations');
      expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
      expect(snapshot.title, 'Gợi ý Staking');
      expect(snapshot.backRoute, AppRoutePaths.earnStaking);
      expect(
        snapshot.riskAssessmentRoute,
        AppRoutePaths.earnStakingRiskAssessment,
      );
      expect(snapshot.stakingRoute, AppRoutePaths.earnStaking);
      expect(snapshot.profile.totalPortfolio, 10000);
      expect(snapshot.strategies, hasLength(3));
      expect(
        snapshot.strategies.singleWhere((strategy) => strategy.recommended).id,
        'balanced',
      );
      expect(snapshot.tips, hasLength(3));
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
    },
  );

  testWidgets('SC-372 renders recommendations baseline', (tester) async {
    await pumpRecommendations(tester);

    expect(find.byType(StakingRecommendationsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Gợi ý Staking'), findsOneWidget);
    expect(find.byKey(StakingRecommendationsPage.heroKey), findsOneWidget);
    expect(find.text('Gợi ý Staking Cá nhân hóa'), findsOneWidget);
    expect(find.byKey(StakingRecommendationsPage.profileKey), findsOneWidget);
    expect(find.text('Profile của bạn'), findsOneWidget);
    expect(find.text('Trung bình'), findsWidgets);
    expect(
      find.byKey(StakingRecommendationsPage.amountFieldKey),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingRecommendationsPage.strategyListKey),
      findsOneWidget,
    );
    expect(find.text('Chiến lược An toàn'), findsOneWidget);
    expect(find.text('Chiến lược Cân bằng'), findsOneWidget);
    expect(find.text('Chiến lược Tăng trưởng'), findsOneWidget);
  });

  testWidgets('SC-372 amount simulator updates projected yearly yield', (
    tester,
  ) async {
    await pumpRecommendations(tester);

    expect(find.text('~\$580.00/năm'), findsOneWidget);

    await tester.enterText(
      find.byKey(StakingRecommendationsPage.amountFieldKey),
      '20000',
    );
    await tester.pumpAndSettle();

    expect(find.text('~\$1,160/năm'), findsOneWidget);
  });

  testWidgets('SC-372 opens strategy detail sheet and CTA returns to staking', (
    tester,
  ) async {
    await pumpRecommendations(tester);

    await tester.ensureVisible(
      find.byKey(StakingRecommendationsPage.strategyKey('balanced')),
    );
    await tester.tap(
      find.byKey(StakingRecommendationsPage.strategyKey('balanced')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Phân bổ chi tiết'), findsOneWidget);
    expect(find.text('Ưu điểm'), findsOneWidget);
    expect(find.text('Nhược điểm'), findsOneWidget);
    expect(find.byKey(StakingRecommendationsPage.detailCtaKey), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(StakingRecommendationsPage.detailCtaKey),
    );
    await tester.tap(find.byKey(StakingRecommendationsPage.detailCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });

  testWidgets('SC-372 profile update edge opens risk assessment', (
    tester,
  ) async {
    await pumpRecommendations(tester);

    await tester.tap(find.byKey(StakingRecommendationsPage.riskButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingRiskAssessmentPage), findsOneWidget);
    expect(find.text('Đánh giá Rủi ro'), findsOneWidget);
  });
}
