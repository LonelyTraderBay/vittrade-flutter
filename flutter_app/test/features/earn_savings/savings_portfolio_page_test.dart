import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_history_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_portfolio_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpPortfolio(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnSavingsPortfolio,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-333 keeps the Home-standard page foundation contract', () {
    final pageSource = File(
      'lib/features/earn_savings/presentation/phone/pages/savings/earn_portfolio_page.dart',
    ).readAsStringSync();

    expect(pageSource, contains('VitInsetScrollView'));
    expect(pageSource, contains('VitContentPadding.compact'));
    expect(pageSource, contains('VitDensity.compact'));
    expect(pageSource, isNot(contains('SingleChildScrollView')));
    expect(pageSource, isNot(contains('EdgeInsetsDirectional.fromSTEB')));
  });

  test('SC-333 mock repository exposes savings portfolio BE draft', () async {
    final snapshot = await const MockSavingsPortfolioRepository()
        .getPortfolio();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-savings-portfolio');
    expect(snapshot.actionDraft, contains('POST /earn/subscribe'));
    expect(snapshot.title, 'Savings Portfolio');
    expect(snapshot.backRoute, AppRoutePaths.earnSavings);
    expect(snapshot.historyRoute, AppRoutePaths.earnSavingsHistory);
    expect(snapshot.totalDepositedUsd, '\$10,340.86');
    expect(snapshot.positions, hasLength(4));
    expect(snapshot.incomeProjections, hasLength(3));
    expect(snapshot.maturityEvents, hasLength(3));
    expect(snapshot.contractNotes, contains('earnProducts'));
    expect(snapshot.supportedStates, contains(EarnScreenState.loading));
    expect(snapshot.supportedStates, contains(EarnScreenState.empty));
    expect(snapshot.supportedStates, contains(EarnScreenState.error));
    expect(snapshot.supportedStates, contains(EarnScreenState.offline));
  });

  testWidgets('SC-333 renders savings portfolio overview baseline', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    expect(find.byType(SavingsPortfolioPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Savings Portfolio'), findsOneWidget);
    expect(find.text('Tổng quan'), findsOneWidget);
    expect(find.text('\$10,340.86'), findsAtLeastNWidgets(1));
    expect(find.text('Phân bổ tài sản'), findsOneWidget);
    expect(find.text('USDT'), findsOneWidget);
    expect(find.text('BTC'), findsAtLeastNWidgets(1));
  });

  testWidgets('SC-333 first viewport reaches history action', (tester) async {
    await pumpPortfolio(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-333 SavingsPortfolioPage',
      semanticLabel: 'Danh mục tiết kiệm',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(SavingsPortfolioPage.historyButtonKey),
      routeName: 'SC-333 SavingsPortfolioPage',
      actionLabel: 'the savings history action',
    );
  });

  testWidgets('SC-333 360px viewport follows Home rhythm', (tester) async {
    await pumpPortfolio(tester, viewport: const Size(360, 800));

    final navTop = tester.getTopLeft(find.byType(VitBottomNav)).dy;
    final tabCardRect = tester.getRect(find.byType(VitCard).first);
    final heroCardRect = tester.getRect(find.byType(VitCard).at(1));
    final allocationRect = tester.getRect(find.text('Phân bổ tài sản'));

    expect(tabCardRect.left, lessThanOrEqualTo(24));
    expect(tabCardRect.width, greaterThanOrEqualTo(312));
    expect(heroCardRect.left, tabCardRect.left);
    expect(heroCardRect.width, tabCardRect.width);
    expect(allocationRect.top, lessThan(navTop - 24));
  });

  testWidgets('SC-333 switches to positions tab with local state', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.tap(find.text('Vị thế').first);
    await tester.pumpAndSettle();

    expect(find.text('Tất cả'), findsOneWidget);
    expect(find.text('BTC Cố định 60D'), findsOneWidget);
    expect(find.text('+0.000019 BTC'), findsOneWidget);
  });

  testWidgets('SC-334 history edge opens migrated savings history', (
    tester,
  ) async {
    await pumpPortfolio(tester);

    await tester.tap(find.byKey(SavingsPortfolioPage.historyButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(SavingsHistoryPage), findsOneWidget);
  });
}
