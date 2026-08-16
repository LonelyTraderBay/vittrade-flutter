import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_suitability_assessment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSuitability(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSuitabilityAssessment,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> answerSingleQuestion(
    WidgetTester tester,
    String questionId,
    int optionIndex,
  ) async {
    final option = find.byKey(
      StakingSuitabilityAssessmentPage.optionKey(questionId, optionIndex),
    );
    await tester.ensureVisible(option);
    await tester.tap(option);
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(StakingSuitabilityAssessmentPage.nextButtonKey),
    );
    await tester.pumpAndSettle();
  }

  Future<void> completeModerateAssessment(WidgetTester tester) async {
    await answerSingleQuestion(tester, 'experience', 0);
    await answerSingleQuestion(tester, 'net-worth', 1);
    await answerSingleQuestion(tester, 'income', 1);
    await answerSingleQuestion(tester, 'objectives', 0);
    await answerSingleQuestion(tester, 'horizon', 0);

    await tester.ensureVisible(find.byType(Slider));
    await tester.drag(find.byType(Slider), const Offset(180, 0));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(StakingSuitabilityAssessmentPage.nextButtonKey),
    );
    await tester.pumpAndSettle();

    const conservativeQuizAnswers = [0, 0, 0, 0, 0];
    for (var i = 0; i < conservativeQuizAnswers.length; i++) {
      final option = find.byKey(
        StakingSuitabilityAssessmentPage.quizOptionKey(
          i,
          conservativeQuizAnswers[i],
        ),
      );
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
    }
    await tester.tap(
      find.byKey(StakingSuitabilityAssessmentPage.nextButtonKey),
    );
    await tester.pumpAndSettle();
  }

  test('SC-376 mock repository exposes suitability BE draft', () async {
    final snapshot = await const MockStakingSuitabilityAssessmentRepository()
        .getAssessment();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-suitability-assessment');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Suitability Assessment');
    expect(snapshot.resultTitle, 'Assessment Result');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.stakingRoute, AppRoutePaths.earnStaking);
    expect(snapshot.questions, hasLength(7));
    expect(snapshot.questions.first.id, 'experience');
    expect(snapshot.questions.first.options, hasLength(5));
    expect(snapshot.questions.last.type, StakingSuitabilityQuestionType.quiz);
    expect(snapshot.questions.last.quizQuestions, hasLength(5));
    expect(
      snapshot.profiles.map((profile) => profile.level),
      containsAll([
        StakingSuitabilityProfileLevel.conservative,
        StakingSuitabilityProfileLevel.moderate,
        StakingSuitabilityProfileLevel.aggressive,
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

  testWidgets('SC-376 renders first suitability question baseline', (
    tester,
  ) async {
    await pumpSuitability(tester);

    expect(find.byType(StakingSuitabilityAssessmentPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Suitability Assessment'), findsOneWidget);
    expect(find.text('Question 1 of 7'), findsOneWidget);
    expect(find.text('14%'), findsOneWidget);
    expect(
      find.text('How long have you invested in cryptocurrency?'),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingSuitabilityAssessmentPage.questionCardKey),
      findsOneWidget,
    );
    expect(find.text('No experience'), findsOneWidget);
    expect(find.text('Less than 1 year'), findsOneWidget);
    expect(find.text('1-3 years'), findsOneWidget);
    expect(find.text('3-5 years'), findsOneWidget);
    expect(find.text('5+ years'), findsOneWidget);
    expect(
      find.byKey(StakingSuitabilityAssessmentPage.infoKey),
      findsOneWidget,
    );
    expect(find.text('Why This Assessment?'), findsOneWidget);

    await tester.tap(
      find.byKey(StakingSuitabilityAssessmentPage.nextButtonKey),
    );
    await tester.pumpAndSettle();
    expect(find.text('Question 1 of 7'), findsOneWidget);
  });

  testWidgets('SC-376 first viewport reaches first answer option', (
    tester,
  ) async {
    await pumpSuitability(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-376 StakingSuitabilityAssessmentPage',
      semanticLabel: 'Đánh giá mức độ phù hợp trước khi staking',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingSuitabilityAssessmentPage.optionKey('experience', 0)),
      routeName: 'SC-376 StakingSuitabilityAssessmentPage',
      actionLabel: 'the first suitability answer option',
    );
  });

  testWidgets('SC-376 selection advances and previous returns', (tester) async {
    await pumpSuitability(tester);

    await tester.tap(
      find.byKey(StakingSuitabilityAssessmentPage.optionKey('experience', 2)),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(StakingSuitabilityAssessmentPage.nextButtonKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Question 2 of 7'), findsOneWidget);
    expect(
      find.text('What is your total net worth (excluding primary residence)?'),
      findsOneWidget,
    );
    expect(
      find.byKey(StakingSuitabilityAssessmentPage.previousButtonKey),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(StakingSuitabilityAssessmentPage.previousButtonKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of 7'), findsOneWidget);
    expect(
      find.text('How long have you invested in cryptocurrency?'),
      findsOneWidget,
    );
  });

  testWidgets('SC-376 completes wizard and shows moderate result', (
    tester,
  ) async {
    await pumpSuitability(tester);
    await completeModerateAssessment(tester);

    expect(find.text('Assessment Result'), findsOneWidget);
    expect(
      find.byKey(StakingSuitabilityAssessmentPage.resultCardKey),
      findsOneWidget,
    );
    expect(find.text('Moderate Investor'), findsOneWidget);
    expect(find.text('ETH Fixed 60D'), findsOneWidget);
    expect(find.text('Auto-compound ETH'), findsOneWidget);
  });

  testWidgets('SC-376 result actions reset and navigate safely', (
    tester,
  ) async {
    await pumpSuitability(tester);
    await completeModerateAssessment(tester);

    await tester.ensureVisible(
      find.byKey(StakingSuitabilityAssessmentPage.resetButtonKey),
    );
    await tester.tap(
      find.byKey(StakingSuitabilityAssessmentPage.resetButtonKey),
    );
    await tester.pumpAndSettle();

    expect(find.text('Question 1 of 7'), findsOneWidget);

    await completeModerateAssessment(tester);
    await tester.ensureVisible(
      find.byKey(StakingSuitabilityAssessmentPage.exploreButtonKey),
    );
    await tester.tap(
      find.byKey(StakingSuitabilityAssessmentPage.exploreButtonKey),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });

  testWidgets('SC-376 header back returns to staking hub', (tester) async {
    await pumpSuitability(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.text('Staking & Earn'), findsOneWidget);
  });
}
