import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_recommendations_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_risk_assessment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

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
            initialLocation: AppRoutePaths.earnSavingsRiskAssessment,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-339 mock repository exposes risk assessment BE draft', () async {
    final snapshot = await const MockSavingsRiskAssessmentRepository()
        .getRiskAssessment();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-risk-assessment');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Đánh giá Rủi ro');
    expect(snapshot.resultTitle, 'Kết quả Đánh giá');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.savingsRoute, AppRoutePaths.earnSavings);
    expect(
      snapshot.recommendationsRoute,
      AppRoutePaths.earnSavingsRecommendations,
    );
    expect(snapshot.questions, hasLength(7));
    expect(snapshot.questions.first.id, 'experience');
    expect(snapshot.questions.first.options, hasLength(4));
    expect(snapshot.results, hasLength(3));
    expect(
      snapshot.results.map((result) => result.level),
      containsAll([
        SavingsRiskProfileLevel.conservative,
        SavingsRiskProfileLevel.moderate,
        SavingsRiskProfileLevel.aggressive,
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

  testWidgets('SC-339 renders first risk question baseline', (tester) async {
    await pumpRiskAssessment(tester);

    expect(find.byType(SavingsRiskAssessmentPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Đánh giá Rủi ro'), findsOneWidget);
    expect(find.text('Câu hỏi 1/7'), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
    expect(
      find.text('Kinh nghiệm đầu tư / tiết kiệm crypto của bạn?'),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsRiskAssessmentPage.questionCardKey),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsRiskAssessmentPage.firstOptionKey),
      findsOneWidget,
    );
    expect(find.text('Hoàn toàn mới'), findsOneWidget);
    expect(find.text('Cơ bản'), findsOneWidget);
    expect(find.text('Có kinh nghiệm'), findsOneWidget);
    expect(find.text('Thành thạo'), findsOneWidget);
    expect(find.textContaining('Trả lời trung thực'), findsOneWidget);
    expect(
      find.byKey(SavingsRiskAssessmentPage.previousButtonKey),
      findsNothing,
    );
  });

  testWidgets('SC-339 first viewport reaches first risk option', (
    tester,
  ) async {
    await pumpRiskAssessment(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-339 SavingsRiskAssessmentPage',
      semanticLabel: 'Đánh giá Rủi ro',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(SavingsRiskAssessmentPage.firstOptionKey),
      routeName: 'SC-339 SavingsRiskAssessmentPage',
      actionLabel: 'the first risk answer option',
    );
  });

  testWidgets('SC-339 option selection advances and previous returns', (
    tester,
  ) async {
    await pumpRiskAssessment(tester);

    await tester.tap(
      find.byKey(SavingsRiskAssessmentPage.optionKey('experience', 1)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Câu hỏi 2/7'), findsOneWidget);
    expect(find.text('Mục tiêu gửi tiết kiệm chính của bạn?'), findsOneWidget);
    expect(
      find.byKey(SavingsRiskAssessmentPage.previousButtonKey),
      findsOneWidget,
    );

    await tester.tap(find.byKey(SavingsRiskAssessmentPage.previousButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Câu hỏi 1/7'), findsOneWidget);
    expect(
      find.text('Kinh nghiệm đầu tư / tiết kiệm crypto của bạn?'),
      findsOneWidget,
    );
  });

  testWidgets('SC-339 completes wizard and shows moderate result', (
    tester,
  ) async {
    await pumpRiskAssessment(tester);

    const questionIds = [
      'experience',
      'savings-goal',
      'risk-tolerance',
      'liquidity',
      'asset-preference',
      'lock-comfort',
      'amount-ratio',
    ];

    for (final questionId in questionIds) {
      final option = find.byKey(
        SavingsRiskAssessmentPage.optionKey(questionId, 2),
      );
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
    }

    expect(find.text('Kết quả Đánh giá'), findsOneWidget);
    expect(find.byKey(SavingsRiskAssessmentPage.resultCardKey), findsOneWidget);
    expect(find.text('Cân bằng (Moderate)'), findsOneWidget);
    expect(find.text('Tăng trưởng Cân bằng'), findsOneWidget);
    expect(find.text('Điểm hồ sơ: 14'), findsOneWidget);
    expect(find.text('USDT Cố định 90D'), findsOneWidget);
  });

  testWidgets('SC-339 result navigation edges are wired', (tester) async {
    await pumpRiskAssessment(tester);

    const questionIds = [
      'experience',
      'savings-goal',
      'risk-tolerance',
      'liquidity',
      'asset-preference',
      'lock-comfort',
      'amount-ratio',
    ];

    for (final questionId in questionIds) {
      final option = find.byKey(
        SavingsRiskAssessmentPage.optionKey(questionId, 1),
      );
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
    }

    await tester.ensureVisible(
      find.byKey(SavingsRiskAssessmentPage.recommendationsButtonKey),
    );
    await tester.tap(
      find.byKey(SavingsRiskAssessmentPage.recommendationsButtonKey),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SavingsRecommendationsPage), findsOneWidget);

    await pumpRiskAssessment(tester);
    for (final questionId in questionIds) {
      final option = find.byKey(
        SavingsRiskAssessmentPage.optionKey(questionId, 1),
      );
      await tester.ensureVisible(option);
      await tester.tap(option);
      await tester.pumpAndSettle();
    }

    await tester.ensureVisible(
      find.byKey(SavingsRiskAssessmentPage.productsButtonKey),
    );
    await tester.tap(find.byKey(SavingsRiskAssessmentPage.productsButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
