import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/token_unlocks_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpUnlocks(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsUnlocks,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-024 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getTokenUnlocks();

    expect(snapshot.unlocks.map((unlock) => unlock.id), [
      'u3',
      'u1',
      'u2',
      'u5',
      'u4',
      'u6',
    ]);
    expect(snapshot.totalValueNext30d, 612445000);
    expect(snapshot.highImpactCount, 3);
    expect(snapshot.avgDilution.toStringAsFixed(1), '3.9');
    expect(snapshot.impactConfigs[MarketUnlockImpact.high]!.label, 'Cao');
    expect(
      snapshot.categoryConfigs[MarketUnlockCategory.investor]!.label,
      'Nhà đầu tư',
    );
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Sắp mở khóa',
      'Phân tích',
      'Lịch trình',
    ]);
    expect(snapshot.chartSeries['unlockValueUsd'], hasLength(6));
    expect(snapshot.chartSeries['unlockDilutionPct'], [
      2.8,
      1.9,
      2.4,
      2.6,
      8.2,
      5.4,
    ]);
    expect(snapshot.lastUpdatedLabel, 'read-only');
    expect(
      snapshot.supportedStates,
      containsAll([
        MarketScreenState.loading,
        MarketScreenState.empty,
        MarketScreenState.error,
        MarketScreenState.offline,
        MarketScreenState.realtimeRefresh,
      ]),
    );

    final valueSorted = await repo.getTokenUnlocks(
      sortBy: MarketUnlockSort.value,
    );
    expect(valueSorted.unlocks.first.symbol, 'TIA');

    final highImpact = await repo.getTokenUnlocks(
      impactFilter: MarketUnlockImpact.high,
    );
    expect(highImpact.unlocks.map((unlock) => unlock.symbol), [
      'APT',
      'ARB',
      'TIA',
    ]);
  });

  testWidgets('SC-024 renders upcoming unlocks inside the Markets shell', (
    tester,
  ) async {
    await pumpUnlocks(tester);

    expect(find.byType(TokenUnlocksPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Mở khóa token'), findsOneWidget);
    expect(find.text('Sắp mở khóa'), findsOneWidget);
    expect(find.text('Phân tích'), findsOneWidget);
    expect(find.text('Lịch trình'), findsOneWidget);
    expect(find.text('\$612.45M'), findsOneWidget);
    expect(find.text('3 tác động cao'), findsOneWidget);
    expect(find.byKey(TokenUnlocksPage.unlockCardKey('u3')), findsOneWidget);
    expect(find.byKey(TokenUnlocksPage.unlockCardKey('u6')), findsOneWidget);
  });

  testWidgets('SC-024 first viewport reaches first unlock card', (
    tester,
  ) async {
    await pumpUnlocks(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'TokenUnlocksPage',
      semanticLabel: 'Mở khóa token',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(TokenUnlocksPage.unlockCardKey('u3')),
      targetLabel: 'first token unlock card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-024 sorts by high value and filters high impact unlocks', (
    tester,
  ) async {
    await pumpUnlocks(tester);

    await tester.tap(find.byKey(TokenUnlocksPage.sortValueKey));
    await tester.pumpAndSettle();

    final tiaTop = tester
        .getTopLeft(find.byKey(TokenUnlocksPage.unlockCardKey('u5')))
        .dy;
    final aptTop = tester
        .getTopLeft(find.byKey(TokenUnlocksPage.unlockCardKey('u3')))
        .dy;
    expect(tiaTop, lessThan(aptTop));

    await tester.tap(find.byKey(TokenUnlocksPage.impactHighKey));
    await tester.pumpAndSettle();

    expect(find.byKey(TokenUnlocksPage.unlockCardKey('u3')), findsOneWidget);
    expect(find.byKey(TokenUnlocksPage.unlockCardKey('u1')), findsOneWidget);
    expect(find.byKey(TokenUnlocksPage.unlockCardKey('u5')), findsOneWidget);
    expect(find.byKey(TokenUnlocksPage.unlockCardKey('u2')), findsNothing);
  });

  testWidgets('SC-024 expands an unlock card with risk detail', (tester) async {
    await pumpUnlocks(tester);

    await tester.tap(find.byKey(TokenUnlocksPage.unlockCardKey('u3')));
    await tester.pumpAndSettle();

    expect(find.text('Số token mở khóa'), findsOneWidget);
    expect(find.text('Giá hiện tại'), findsOneWidget);
    expect(find.text('Tổng đang khóa'), findsOneWidget);
    expect(find.textContaining('Giá giảm -6.1%'), findsOneWidget);
  });

  testWidgets('SC-024 analysis and schedule tabs render supporting views', (
    tester,
  ) async {
    await pumpUnlocks(tester);

    await tester.tap(find.byKey(TokenUnlocksPage.analysisTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Phân bổ theo tác động'), findsOneWidget);
    expect(find.text('Theo loại'), findsOneWidget);
    expect(find.text('Rủi ro pha loãng cao nhất'), findsOneWidget);
    expect(find.text('Lưu ý quan trọng'), findsOneWidget);

    await tester.tap(find.byKey(TokenUnlocksPage.scheduleTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Lịch mở khóa'), findsWidgets);
    expect(find.text('Lưu thông / Tổng cung'), findsWidgets);
  });

  testWidgets('SC-024 back button returns to SC-008 Markets', (tester) async {
    await pumpUnlocks(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
