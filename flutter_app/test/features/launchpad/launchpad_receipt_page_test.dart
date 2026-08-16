import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_portfolio_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_receipt_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  void configurePhoneView(WidgetTester tester) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> pumpReceipt(WidgetTester tester) async {
    configurePhoneView(tester);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadReceiptSub001,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pumpKnownReceipt(WidgetTester tester) async {
    configurePhoneView(tester);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: LaunchpadReceiptPage(subscriptionId: 'sub1')),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-301 mock repository exposes launchpad receipt BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getReceipt('sub001');

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-receipt-sub001');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Biên lai');
    expect(snapshot.backRoute, AppRoutePaths.launchpadPortfolio);
    expect(snapshot.launchpadRoute, AppRoutePaths.launchpad);
    expect(snapshot.portfolioRoute, AppRoutePaths.launchpadPortfolio);
    expect(snapshot.subscriptionId, 'sub001');
    expect(snapshot.subscription, isNull);
    expect(snapshot.contractNotes, contains('selected subscription'));
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

  test('SC-301 mock repository hydrates known subscription receipts', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getReceipt('sub1');

    expect(snapshot.subscription, isNotNull);
    expect(snapshot.subscription!.projectName, 'NexaAI Protocol');
    expect(
      snapshot.subscription!.status,
      LaunchpadSubscriptionStatus.partiallyAllocated,
    );
  });

  testWidgets('SC-301 renders Flutter direct-route error state', (
    tester,
  ) async {
    await pumpReceipt(tester);

    expect(find.byType(LaunchpadReceiptPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Biên lai'), findsOneWidget);
    expect(find.byKey(LaunchpadReceiptPage.contentKey), findsOneWidget);
    expect(find.byKey(LaunchpadReceiptPage.errorKey), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(find.text('Không tải được dữ liệu'), findsOneWidget);
    expect(
      find.text('Vui lòng kiểm tra kết nối mạng và thử lại.'),
      findsOneWidget,
    );
  });

  testWidgets('SC-301 first viewport reaches receipt state', (tester) async {
    await pumpReceipt(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-301 LaunchpadReceiptPage',
      semanticLabel: 'Biên lai đăng ký tham gia IDO',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(LaunchpadReceiptPage.errorKey),
      targetLabel: 'the receipt state panel',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-301 renders shared financial-safety receipt panel', (
    tester,
  ) async {
    await pumpKnownReceipt(tester);

    expect(find.byType(LaunchpadReceiptPage), findsOneWidget);
    expect(find.byType(VitHighRiskStatePanel), findsOneWidget);
    expect(find.text('Đã rà soát biên lai'), findsOneWidget);
    final panel = tester.widget<VitHighRiskStatePanel>(
      find.byType(VitHighRiskStatePanel),
    );
    expect(panel.state, VitHighRiskUiState.success);
    expect(panel.contractId, 'sub1');
  });

  testWidgets('SC-301 header back returns to launchpad portfolio', (
    tester,
  ) async {
    await pumpReceipt(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPortfolioPage), findsOneWidget);
    expect(find.text('Danh mục Launchpad'), findsWidgets);
  });
}
