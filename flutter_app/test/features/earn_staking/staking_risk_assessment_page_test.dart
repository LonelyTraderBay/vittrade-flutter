import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_risk_assessment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRiskAssessment(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnStakingRiskAssessment,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-357 mock repository exposes staking assessment BE draft', () async {
    final snapshot = await const MockStakingRiskAssessmentRepository()
        .getRiskAssessment();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-staking-risk-assessment');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.actionDraft, contains('/earn/staking/risk-assessment'));
    expect(snapshot.title, 'Đánh giá Rủi ro');
    expect(snapshot.resultTitle, 'Kết quả Đánh giá');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.stakingRoute, AppRoutePaths.earnStaking);
    expect(snapshot.questions, hasLength(7));
    expect(snapshot.questions.first.id, 'experience');
    expect(snapshot.questions.first.options, hasLength(4));
    expect(snapshot.results, hasLength(3));
    expect(
      snapshot.results.map((result) => result.level),
      containsAll([
        StakingRiskProfileLevel.conservative,
        StakingRiskProfileLevel.moderate,
        StakingRiskProfileLevel.aggressive,
      ]),
    );
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

  testWidgets('SC-357 renders first staking risk question baseline', (
    tester,
  ) async {
    await pumpRiskAssessment(tester);

    expect(find.byType(StakingRiskAssessmentPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Đánh giá Rủi ro'), findsOneWidget);
    expect(find.text('Câu hỏi 1/7'), findsOneWidget);
    expect(find.text('14%'), findsOneWidget);
    expect(find.text('Kinh nghiệm đầu tư crypto của bạn?'), findsOneWidget);
    expect(
      find.byKey(StakingRiskAssessmentPage.questionCardKey),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingRiskAssessmentPage.firstOptionKey),
      findsOneWidget,
    );
    expect(find.text('Người mới (< 6 tháng)'), findsOneWidget);
    expect(find.text('Trung bình (6 tháng - 2 năm)'), findsOneWidget);
    expect(find.text('Có kinh nghiệm (2-5 năm)'), findsOneWidget);
    expect(find.text('Chuyên nghiệp (> 5 năm)'), findsOneWidget);
    expect(find.textContaining('Trả lời trung thực'), findsOneWidget);
    expect(
      find.byKey(StakingRiskAssessmentPage.previousButtonKey),
      findsNothing,
    );
  });

  testWidgets('SC-357 first viewport reaches first answer option', (
    tester,
  ) async {
    await pumpRiskAssessment(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-357 StakingRiskAssessmentPage',
      semanticLabel: 'Đánh giá rủi ro trước khi chọn sản phẩm staking',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingRiskAssessmentPage.firstOptionKey),
      routeName: 'SC-357 StakingRiskAssessmentPage',
      actionLabel: 'the first risk answer option',
    );
  });

  testWidgets('SC-357 option selection advances and previous returns', (
    tester,
  ) async {
    await pumpRiskAssessment(tester);

    await tester.tap(
      find.byKey(StakingRiskAssessmentPage.optionKey('experience', 1)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Câu hỏi 2/7'), findsOneWidget);
    expect(find.text('Hiểu biết về staking?'), findsOneWidget);
    expect(
      find.byKey(StakingRiskAssessmentPage.previousButtonKey),
      findsOneWidget,
    );

    await tester.tap(find.byKey(StakingRiskAssessmentPage.previousButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Câu hỏi 1/7'), findsOneWidget);
    expect(find.text('Kinh nghiệm đầu tư crypto của bạn?'), findsOneWidget);
  });

  testWidgets('SC-357 completes wizard and shows moderate result', (
    tester,
  ) async {
    await pumpRiskAssessment(tester);

    const questionIds = [
      'experience',
      'knowledge',
      'risk-tolerance',
      'reaction',
      'horizon',
      'liquidity',
      'allocation',
    ];

    for (final questionId in questionIds) {
      final option = find.byKey(
        StakingRiskAssessmentPage.optionKey(questionId, 2),
      );
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
    }

    expect(find.text('Kết quả Đánh giá'), findsOneWidget);
    expect(find.byKey(StakingRiskAssessmentPage.resultCardKey), findsOneWidget);
    expect(find.text('Cân bằng (Moderate)'), findsOneWidget);
    expect(find.text('14/21 điểm'), findsOneWidget);
    expect(find.text('USDT Cố định 60D'), findsOneWidget);
    expect(find.text('ETH-USDT LP Pool'), findsOneWidget);
  });

  testWidgets('SC-357 result actions navigate and reset safely', (
    tester,
  ) async {
    await pumpRiskAssessment(tester);

    const questionIds = [
      'experience',
      'knowledge',
      'risk-tolerance',
      'reaction',
      'horizon',
      'liquidity',
      'allocation',
    ];

    for (final questionId in questionIds) {
      final option = find.byKey(
        StakingRiskAssessmentPage.optionKey(questionId, 1),
      );
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
    }

    await tester.ensureVisible(
      find.byKey(StakingRiskAssessmentPage.resetButtonKey),
    );
    await tester.tap(find.byKey(StakingRiskAssessmentPage.resetButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Câu hỏi 1/7'), findsOneWidget);

    for (final questionId in questionIds) {
      final option = find.byKey(
        StakingRiskAssessmentPage.optionKey(questionId, 1),
      );
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
    }

    await tester.ensureVisible(
      find.byKey(StakingRiskAssessmentPage.exploreButtonKey),
    );
    await tester.tap(find.byKey(StakingRiskAssessmentPage.exploreButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });

  testWidgets('SC-357 header back returns to staking hub', (tester) async {
    await pumpRiskAssessment(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
