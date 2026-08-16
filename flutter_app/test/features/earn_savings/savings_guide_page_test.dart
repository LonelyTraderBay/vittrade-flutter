import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_guide_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
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
            initialLocation: AppRoutePaths.earnSavingsGuide,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-335 mock repository exposes savings guide BE draft', () async {
    final snapshot = await const MockSavingsGuideRepository().getGuide();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-guide');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Hướng dẫn Tiết kiệm');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.savingsRoute, AppRoutePaths.earnSavings);
    expect(snapshot.tabs.map((tab) => tab.label), ['Hướng dẫn', 'Thuật ngữ']);
    expect(snapshot.defaultTab, 'tutorials');
    expect(snapshot.tutorials, hasLength(3));
    expect(snapshot.quickTips, hasLength(6));
    expect(snapshot.terms, hasLength(7));
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

  testWidgets('SC-335 renders guide tutorial baseline', (tester) async {
    await pumpGuide(tester);

    expect(find.byType(SavingsGuidePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hướng dẫn Tiết kiệm'), findsOneWidget);
    expect(find.text('Tiết kiệm Crypto từ Zero'), findsOneWidget);
    expect(find.text('Tiến trình học'), findsOneWidget);
    expect(find.text('0/3'), findsOneWidget);
    expect(find.byKey(SavingsGuidePage.tutorialListKey), findsOneWidget);
    expect(find.text('Tiết kiệm Crypto là gì?'), findsOneWidget);
    expect(find.text('Tối ưu lãi suất Tiết kiệm'), findsOneWidget);
    expect(find.text('Rủi ro & An toàn Tiết kiệm'), findsOneWidget);
    expect(find.text('Mẹo nhanh'), findsOneWidget);
    expect(find.text('Bắt đầu nhỏ'), findsOneWidget);
  });

  testWidgets('SC-335 switches to glossary tab', (tester) async {
    await pumpGuide(tester);

    await tester.tap(find.text('Thuật ngữ'));
    await tester.pumpAndSettle();

    expect(find.byKey(SavingsGuidePage.glossaryListKey), findsOneWidget);
    expect(find.text('7 thuật ngữ'), findsOneWidget);
    expect(find.text('APY'), findsOneWidget);
    expect(find.text('Auto-compound'), findsOneWidget);
    expect(
      find.textContaining('không phải lời khuyên tài chính'),
      findsOneWidget,
    );
  });

  testWidgets('SC-335 opens tutorial sheet and tracks completion', (
    tester,
  ) async {
    await pumpGuide(tester);

    await tester.tap(find.byKey(SavingsGuidePage.firstTutorialKey));
    await tester.pumpAndSettle();

    expect(find.text('Tiết kiệm Crypto hoạt động thế nào?'), findsOneWidget);
    expect(find.text('Tips quan trọng'), findsOneWidget);

    await tester.tap(find.text('Tiếp theo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tiếp theo'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(SavingsGuidePage.completeButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('1/3'), findsOneWidget);
  });

  testWidgets('SC-335 start and back navigation edges are wired', (
    tester,
  ) async {
    await pumpGuide(tester);

    await tester.ensureVisible(find.byKey(SavingsGuidePage.startButtonKey));
    await tester.tap(find.byKey(SavingsGuidePage.startButtonKey));
    await tester.pumpAndSettle();
    expect(find.byType(SavingsPage), findsOneWidget);

    await pumpGuide(tester);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();
    expect(find.byType(SavingsPage), findsOneWidget);
  });
}
