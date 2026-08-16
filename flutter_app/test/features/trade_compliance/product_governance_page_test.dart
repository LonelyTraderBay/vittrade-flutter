import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/trade_compliance_repository.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/phone/pages/governance/product_governance_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpProductGovernance(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyProductGovernance,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-100 mock repository exposes product governance BE draft', () async {
    final snapshot = await const MockTradeRegulatoryRepository(
      loadDelay: Duration.zero,
    ).getProductGovernance();

    expect(snapshot.defaultTab, 'products');
    expect(snapshot.nextReviewLabel, 'June 2026');
    expect(snapshot.products.map((product) => product.name), [
      'Mirror Copy Trading',
      'Fixed Ratio Copy',
      'Smart Allocation Copy',
    ]);
    expect(snapshot.products.first.status, 'approved');
    expect(snapshot.products.last.status, 'under-review');
    expect(snapshot.products.last.nextReview, '6/1/2026');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-100 renders product governance inside Trade shell', (
    tester,
  ) async {
    await pumpProductGovernance(tester);

    expect(find.byType(ProductGovernancePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Product Governance'), findsOneWidget);
    expect(find.text('MiFID II Oversight'), findsOneWidget);
    expect(find.text('All Products Compliant'), findsOneWidget);
    expect(find.text('Copy Trading Products'), findsOneWidget);
    expect(
      find.byKey(ProductGovernancePage.productKey('prod-1')),
      findsOneWidget,
    );
    expect(find.text('Mirror Copy Trading'), findsOneWidget);
    expect(find.text('Fixed Ratio Copy'), findsOneWidget);
  });

  testWidgets('SC-100 first viewport reaches first product card', (
    tester,
  ) async {
    await pumpProductGovernance(tester);

    expectFirstViewportVisible(
      tester,
      ProductGovernancePage.productKey('prod-1').asFinder(),
      targetLabel: 'first product governance card',
    );
  });

  testWidgets('SC-100 switches reviews and distribution tabs', (tester) async {
    await pumpProductGovernance(tester);

    await tester.tap(ProductGovernancePage.tabKey('reviews').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Review Schedule'), findsOneWidget);
    expect(find.text('Due: 6/1/2026'), findsOneWidget);
    expect(find.text('Action needed'), findsOneWidget);

    await tester.tap(ProductGovernancePage.tabKey('distribution').asFinder());
    await tester.pumpAndSettle();
    expect(find.text('Distribution Channels'), findsOneWidget);
    expect(find.text('Web Platform'), findsOneWidget);
    expect(find.text('API'), findsOneWidget);
  });

  testWidgets('SC-100 target market edge opens SC-101 route', (tester) async {
    await pumpProductGovernance(tester);

    await tester.tap(
      ProductGovernancePage.targetMarketKey('prod-1').asFinder(),
    );
    await tester.pumpAndSettle();

    expect(find.text('Target Market Definition'), findsOneWidget);
  });
}

extension on Key {
  Finder asFinder() => find.byKey(this);
}
