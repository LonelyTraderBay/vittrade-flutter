import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_goal_page.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpGoals(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsGoals,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-342 mock repository exposes savings goals BE draft', () async {
    final snapshot = await const MockSavingsGoalsRepository().getGoals();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-goals');
    expect(snapshot.actionDraft, contains('POST /earn/savings/goals'));
    expect(snapshot.title, 'Mục tiêu tiết kiệm');
    expect(snapshot.subtitle, 'Đặt mục tiêu & theo dõi tiến độ');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.goals, hasLength(3));
    expect(
      snapshot.goals.where((goal) => goal.status == SavingsGoalStatus.active),
      hasLength(2),
    );
    expect(
      snapshot.goals.where(
        (goal) => goal.status == SavingsGoalStatus.completed,
      ),
      hasLength(1),
    );
    expect(snapshot.templates, hasLength(6));
    expect(snapshot.tips.map((tip) => tip.title), [
      'Tự động đóng góp đều đặn',
      'Milestone rewards tích lũy',
    ]);
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

  testWidgets('SC-342 renders savings goal baseline', (tester) async {
    await pumpGoals(tester);

    expect(find.byType(SavingsGoalPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Mục tiêu tiết kiệm'), findsOneWidget);
    expect(find.text(kSavingsToolsHeaderSubtitle), findsOneWidget);
    expect(find.byKey(SavingsGoalPage.summaryKey), findsOneWidget);
    expect(find.text('\$4,950.00'), findsOneWidget);
    expect(find.text('mục tiêu \$8,000.00'), findsOneWidget);
    expect(find.text('2'), findsWidgets);
    expect(find.text('8/12'), findsOneWidget);
    expect(find.byKey(SavingsGoalPage.createButtonKey), findsOneWidget);
    expect(find.text('Đang thực hiện'), findsWidgets);
    expect(find.text('Đã hoàn thành'), findsWidgets);
    expect(find.byKey(SavingsGoalPage.goalKey('g1')), findsOneWidget);
    expect(find.byKey(SavingsGoalPage.goalKey('g2')), findsOneWidget);
    expect(find.byKey(SavingsGoalPage.goalKey('g3')), findsOneWidget);
    expect(find.text('Quỹ khẩn cấp'), findsOneWidget);
    expect(find.text('Du lịch Nhật Bản'), findsOneWidget);
    expect(find.text('Quỹ đầu tư BTC'), findsOneWidget);
    expect(find.text('Tự động đóng góp đều đặn'), findsOneWidget);
  });

  testWidgets('SC-342 create goal sheet shows templates and draft summary', (
    tester,
  ) async {
    await pumpGoals(tester);

    await tester.tap(find.byKey(SavingsGoalPage.createButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsGoalPage.createSheetKey), findsOneWidget);
    expect(find.text('Tạo mục tiêu mới'), findsWidgets);
    expect(find.byKey(SavingsGoalPage.templateKey('t1')), findsOneWidget);
    expect(find.byKey(SavingsGoalPage.templateKey('t6')), findsOneWidget);
    expect(find.text('Mục tiêu gợi ý'), findsOneWidget);
    expect(find.text('Milestone rewards'), findsOneWidget);
  });

  testWidgets('SC-342 goal card opens detail sheet with milestones', (
    tester,
  ) async {
    await pumpGoals(tester);

    await tester.tap(find.byKey(SavingsGoalPage.goalKey('g1')));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsGoalPage.detailSheetKey), findsOneWidget);
    expect(find.text('Milestone Rewards'), findsOneWidget);
    expect(find.text('Đóng góp gần đây'), findsOneWidget);
    expect(find.text('75% Sắp hoàn thành'), findsOneWidget);
    expect(find.text('+0.2% APY Boost 30 ngày'), findsOneWidget);
  });

  testWidgets('SC-342 header back returns to savings overview', (tester) async {
    await pumpGoals(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
