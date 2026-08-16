import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/pair/market_heatmap_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_movers_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/hub/market_overview_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_sectors_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpOverview(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsOverview,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-009 mock repository exposes the BE draft read model', () async {
    final snapshot = await const MockMarketRepository(
      loadDelay: Duration.zero,
    ).getMarketOverview();

    expect(snapshot.globalStats.totalMarketCap, 2456789012345);
    expect(snapshot.marketBreadth.advancing, 5843);
    expect(snapshot.fearGreedHistory, hasLength(8));
    expect(snapshot.sectors.map((sector) => sector.id), contains('ai'));
    expect(snapshot.movers.map((mover) => mover.symbol), contains('ZRO'));
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, contains('Tất cả'));
    expect(snapshot.chartSeries['fearGreed7d'], hasLength(8));
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
  });

  testWidgets('SC-009 renders inside the Markets shell', (tester) async {
    await pumpOverview(tester);

    expect(find.byType(MarketOverviewPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Tổng quan thị trường'), findsOneWidget);
    expect(find.text('Tổng vốn hóa thị trường'), findsOneWidget);
    expect(find.text(r'$2,456.79B'), findsOneWidget);
    expect(find.text('Sợ hãi & Tham lam'), findsOneWidget);
    expect(find.text('Biến động thị trường'), findsOneWidget);
    expect(find.text('Ngành'), findsOneWidget);
    expect(find.text('Biểu đồ nhiệt'), findsNWidgets(2));
  });

  testWidgets('SC-009 first viewport reaches market navigation cards', (
    tester,
  ) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);
    await pumpOverview(tester);

    expectFirstViewportVisible(
      tester,
      find.byKey(MarketOverviewPage.quickMoversKey),
      targetLabel: 'the market movers shortcut',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-009 back button returns to SC-008 Markets', (tester) async {
    await pumpOverview(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
    expect(find.text('Tìm kiếm BTC, ETH...'), findsOneWidget);
  });

  testWidgets('SC-009 wires top navigation cards to SC-013 heatmap', (
    tester,
  ) async {
    await pumpOverview(tester);

    await tester.tap(find.byKey(MarketOverviewPage.quickHeatmapKey));
    await tester.pumpAndSettle();

    expect(find.byType(MarketOverviewPage), findsNothing);
    expect(find.byType(MarketHeatmapPage), findsOneWidget);
    expect(find.text('Bản đồ thị trường'), findsOneWidget);
  });

  testWidgets('SC-009 wires movers and sector controls', (tester) async {
    await pumpOverview(tester);

    await tester.ensureVisible(find.byKey(MarketOverviewPage.topGainersKey));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(MarketOverviewPage.topGainersKey));
    await tester.pumpAndSettle();

    expect(find.byType(MarketMoversPage), findsOneWidget);
    expect(find.text('Biến động thị trường'), findsOneWidget);

    await pumpOverview(tester);
    await tester.ensureVisible(find.byKey(const Key('sc009_sector_ai')));
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(const Key('sc009_sector_ai')));
    await tester.pumpAndSettle();

    expect(find.byType(MarketSectorsPage), findsOneWidget);
    expect(find.text('Trí tuệ nhân tạo'), findsWidgets);
  });

  testWidgets('SC-009 full content reaches tools and wires visible links', (
    tester,
  ) async {
    await pumpOverview(tester);

    await tester.ensureVisible(find.text('Công cụ thị trường'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Danh sách theo dõi'), findsOneWidget);
    expect(find.text('Cảnh báo giá'), findsOneWidget);
    expect(find.text('Biểu đồ nhiệt'), findsNWidgets(2));
    expect(find.text('Danh sách thị trường'), findsOneWidget);

    await tester.tap(find.byKey(MarketOverviewPage.watchlistToolKey));
    await tester.pumpAndSettle();
    expect(find.text('Danh sách theo dõi'), findsOneWidget);

    await pumpOverview(tester);
    await tester.ensureVisible(
      find.byKey(MarketOverviewPage.marketListToolKey),
    );
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(MarketOverviewPage.marketListToolKey));
    await tester.pumpAndSettle();
    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
