import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_portfolio_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_receipt_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPortfolio(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadPortfolio,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-296 mock repository exposes launchpad portfolio BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getPortfolio();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-portfolio');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Danh mục Launchpad');
    expect(snapshot.subtitle, 'Các dự án đã tham gia');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.launchpadRoute, AppRoutePaths.launchpad);
    expect(snapshot.receiptRoute, AppRoutePaths.launchpadReceiptSub001);
    expect(snapshot.subscriptions, hasLength(3));
    expect(snapshot.subscriptions.first.projectName, 'NexaAI Protocol');
    expect(
      snapshot.subscriptions.first.status,
      LaunchpadSubscriptionStatus.partiallyAllocated,
    );
    expect(snapshot.contractNotes, contains('subscriptions'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-296 renders portfolio summary and subscriptions', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.byType(LaunchpadPortfolioPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Danh mục Launchpad'), findsWidgets);
    expect(find.text('Các dự án đã tham gia'), findsOneWidget);
    expect(find.byKey(LaunchpadPortfolioPage.heroKey), findsOneWidget);
    expect(find.text('Tổng đã đầu tư'), findsOneWidget);
    expect(find.text(r'$3,500.00'), findsOneWidget);
    expect(find.text('Đã phân bổ'), findsWidgets);
    expect(find.byKey(LaunchpadPortfolioPage.tabsKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadPortfolioPage.subscriptionKey('sub1')),
      findsOneWidget,
    );
    expect(find.text('NexaAI Protocol'), findsOneWidget);
    expect(find.text('Phân bổ 1 phần'), findsOneWidget);
    expect(find.byKey(LaunchpadPortfolioPage.claimKey('sub1')), findsOneWidget);
    expect(
      find.byKey(LaunchpadPortfolioPage.refundKey('sub1')),
      findsOneWidget,
    );
  });

  testWidgets('SC-296 first viewport reaches first subscription', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-296 LaunchpadPortfolioPage',
      semanticLabel: 'Danh mục dự án Launchpad đã tham gia',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadPortfolioPage.subscriptionKey('sub1')),
      routeName: 'SC-296 LaunchpadPortfolioPage',
      actionLabel: 'the first portfolio subscription',
    );
  });

  testWidgets('SC-296 tab filter shows claimed subscription', (tester) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byKey(LaunchpadPortfolioPage.tabKey('claimed')));
    await tester.pumpAndSettle();

    expect(find.text('ZetaPay Finance'), findsOneWidget);
    expect(find.text('NexaAI Protocol'), findsNothing);
    expect(find.text('Đã nhận'), findsWidgets);
  });

  testWidgets('SC-296 subscription tap navigates to receipt screen', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.tap(
      find.byKey(LaunchpadPortfolioPage.subscriptionKey('sub1')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadReceiptPage), findsOneWidget);
    expect(find.text('Biên lai'), findsOneWidget);
  });

  testWidgets('SC-296 header back returns to launchpad', (tester) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
    expect(find.text('Launchpad'), findsOneWidget);
  });
}
