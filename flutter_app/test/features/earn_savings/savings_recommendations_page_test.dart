import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_recommendations_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

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
            initialLocation: AppRoutePaths.earnSavingsRecommendations,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-338 mock repository exposes savings recommendations BE draft',
    () async {
      final snapshot = await const MockSavingsRecommendationsRepository()
          .getRecommendations();

      expect(
        snapshot.endpoint,
        '/api/mobile/earn/earn-savings-recommendations',
      );
      expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
      expect(snapshot.title, 'Gợi ý Tiết kiệm');
      expect(snapshot.backRoute, AppRoutePaths.earnSavings);
      expect(
        snapshot.riskAssessmentRoute,
        AppRoutePaths.earnSavingsRiskAssessment,
      );
      expect(snapshot.savingsRoute, AppRoutePaths.earnSavings);
      expect(snapshot.profile.totalAvailable, 15000);
      expect(snapshot.profile.preferredAssets, ['USDT', 'BTC', 'ETH']);
      expect(snapshot.strategies, hasLength(3));
      expect(
        snapshot.strategies.singleWhere((strategy) => strategy.recommended).id,
        'balanced-growth',
      );
      expect(snapshot.insights, hasLength(4));
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
    },
  );

  testWidgets('SC-338 renders recommendations baseline', (tester) async {
    await pumpRecommendations(tester);

    expect(find.byType(SavingsRecommendationsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Gợi ý Tiết kiệm'), findsOneWidget);
    expect(find.text('Gợi ý Tiết kiệm Cá nhân hóa'), findsOneWidget);
    expect(find.text('Hồ sơ của bạn'), findsOneWidget);
    expect(find.text('Trung bình'), findsWidgets);
    expect(
      find.byKey(SavingsRecommendationsPage.amountFieldKey),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsRecommendationsPage.compareButtonKey),
      findsOneWidget,
    );
    expect(
      find.byKey(SavingsRecommendationsPage.strategyListKey),
      findsOneWidget,
    );
    expect(find.text('Lãi suất Ổn định'), findsOneWidget);
    expect(find.text('Tăng trưởng Cân bằng'), findsOneWidget);
    expect(find.text('Tối đa Lợi suất'), findsOneWidget);
    expect(find.text('Gợi ý Cá nhân hóa'), findsOneWidget);
  });

  testWidgets('SC-338 first viewport reaches compare action', (tester) async {
    await pumpRecommendations(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-338 SavingsRecommendationsPage',
      semanticLabel: 'Gợi ý Tiết kiệm',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(SavingsRecommendationsPage.compareButtonKey),
      routeName: 'SC-338 SavingsRecommendationsPage',
      actionLabel: 'the strategy compare action',
    );
  });

  testWidgets('SC-338 quick amount updates projected yearly yield', (
    tester,
  ) async {
    await pumpRecommendations(tester);

    expect(find.text('+\$705.00/năm'), findsOneWidget);

    await tester.tap(
      find.byKey(SavingsRecommendationsPage.amountChipKey(50000)),
    );
    await tester.pumpAndSettle();

    expect(find.text('+\$2,350/năm'), findsOneWidget);
  });

  testWidgets('SC-338 opens strategy detail sheet and CTA returns to savings', (
    tester,
  ) async {
    await pumpRecommendations(tester);

    await tester.ensureVisible(
      find.byKey(SavingsRecommendationsPage.strategyKey('balanced-growth')),
    );
    await tester.tap(
      find.byKey(SavingsRecommendationsPage.strategyKey('balanced-growth')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Phân bổ chi tiết'), findsOneWidget);
    expect(find.text('Ưu điểm'), findsOneWidget);
    expect(find.text('Đăng ký sản phẩm theo chiến lược'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(SavingsRecommendationsPage.detailCtaKey),
    );
    await tester.tap(find.byKey(SavingsRecommendationsPage.detailCtaKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsPage), findsOneWidget);
  });

  testWidgets('SC-338 compare and risk navigation edges are wired', (
    tester,
  ) async {
    await pumpRecommendations(tester);

    await tester.tap(find.byKey(SavingsRecommendationsPage.compareButtonKey));
    await tester.pumpAndSettle();
    expect(find.text('So sánh Chiến lược'), findsOneWidget);
    expect(find.text('Lãi/năm'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close_rounded).last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(
      find.byKey(SavingsRecommendationsPage.riskButtonKey),
    );
    await tester.tap(find.byKey(SavingsRecommendationsPage.riskButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Đánh giá Rủi ro'), findsOneWidget);
  });
}
