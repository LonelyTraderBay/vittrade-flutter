import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_dca_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_smart_suggestions_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpSmartSuggestions(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsSmartSuggestions,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-347 mock repository exposes smart suggestions BE draft', () async {
    final snapshot = await const MockSavingsSmartSuggestionsRepository()
        .getSuggestions();

    expect(
      snapshot.endpoint,
      '/api/mobile/earn/earn-savings-smart-suggestions',
    );
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Gợi ý thông minh');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.tabs.map((tab) => tab.label), [
      'Gợi ý (5)',
      'Xu hướng APY',
      'Tín hiệu',
    ]);
    expect(snapshot.filters.map((filter) => filter.label), [
      'Tất cả',
      'Ưu tiên',
      'Trung bình',
      'Tham khảo',
    ]);
    expect(snapshot.suggestions, hasLength(6));
    expect(snapshot.trends, hasLength(3));
    expect(snapshot.signals, hasLength(3));
    expect(snapshot.potentialApyGainLabel, '+8.2%');
    expect(snapshot.contractNotes, contains('suggestion actions'));
    expect(snapshot.supportedStates, contains(EarnScreenState.offline));
  });

  testWidgets('SC-347 renders smart suggestions baseline', (tester) async {
    await pumpSmartSuggestions(tester);

    expect(find.byType(SavingsSmartSuggestionsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Gợi ý thông minh'), findsOneWidget);
    expect(find.byKey(SavingsSmartSuggestionsPage.summaryKey), findsOneWidget);
    expect(find.text('Smart Suggestions'), findsOneWidget);
    expect(find.text('+8.2%'), findsOneWidget);
    expect(
      find.byKey(SavingsSmartSuggestionsPage.suggestionsListKey),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsSmartSuggestionsPage.suggestionKey('sg1')),
      findsOneWidget,
    );
    expect(find.text('Thời điểm DCA USDT tốt'), findsOneWidget);
    expect(find.text('+0.6% APY so với trung bình'), findsOneWidget);
  });

  testWidgets('SC-347 filters high priority suggestions', (tester) async {
    await pumpSmartSuggestions(tester);

    await tester.tap(find.byKey(SavingsSmartSuggestionsPage.filterKey('high')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(SavingsSmartSuggestionsPage.suggestionKey('sg1')),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsSmartSuggestionsPage.suggestionKey('sg3')),
      findsNothing,
    );
  });

  testWidgets('SC-347 tabs show APY trends and market signals', (tester) async {
    await pumpSmartSuggestions(tester);

    await tester.tap(find.text('Xu hướng APY'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(SavingsSmartSuggestionsPage.trendsListKey),
      findsOneWidget,
    );
    expect(find.text('USDT Linh hoạt'), findsOneWidget);
    expect(find.text('Dự báo'), findsWidgets);

    await tester.tap(find.text('Tín hiệu').first);
    await tester.pumpAndSettle();

    expect(
      find.byKey(SavingsSmartSuggestionsPage.signalsListKey),
      findsOneWidget,
    );
    expect(find.textContaining('Fed giữ lãi suất'), findsOneWidget);
  });

  testWidgets('SC-347 suggestion action opens the DCA screen', (tester) async {
    await pumpSmartSuggestions(tester);

    await tester.tap(find.byKey(SavingsSmartSuggestionsPage.actionKey('sg1')));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsDCAPage), findsOneWidget);
  });

  testWidgets('SC-347 savings insight edge opens smart suggestions', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavings,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(SavingsPage.smartSuggestionsInsightKey),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(SavingsPage.smartSuggestionsInsightKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsSmartSuggestionsPage), findsOneWidget);
  });
}
