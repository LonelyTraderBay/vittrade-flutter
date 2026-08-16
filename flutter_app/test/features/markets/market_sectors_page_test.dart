import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/tools/market_sectors_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpSectors(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.marketsSectors,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-011 mock repository exposes the BE draft read model', () async {
    final snapshot = await const MockMarketRepository(
      loadDelay: Duration.zero,
    ).getMarketSectors();

    expect(snapshot.sectors, hasLength(8));
    expect(snapshot.sectors.map((sector) => sector.id), contains('ai'));
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.timeframes, ['24h', '7d', '30d']);
    expect(snapshot.screenFilters.sortOptions.map((option) => option.id), [
      'performance',
      'market_cap',
      'coin_count',
    ]);
    expect(snapshot.chartSeries['sectorDominance'], hasLength(8));
    expect(snapshot.lastUpdatedLabel, 'Dữ liệu cập nhật liên tục');
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

  testWidgets('SC-011 renders inside the Markets shell', (tester) async {
    await pumpSectors(tester);

    expect(find.byType(MarketSectorsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Ngành thị trường'), findsOneWidget);
    expect(find.text('Phân bổ vốn hóa theo ngành'), findsOneWidget);
    expect(find.byKey(MarketSectorsPage.timeframe24hKey), findsOneWidget);
    expect(find.byKey(MarketSectorsPage.sortPerformanceKey), findsOneWidget);
    expect(find.byKey(MarketSectorsPage.sectorKey('ai')), findsOneWidget);
    expect(find.byKey(MarketSectorsPage.sectorKey('layer2')), findsOneWidget);
    expect(find.text('So sánh nhanh'), findsOneWidget);
  });

  testWidgets('SC-011 controls update timeframe and sort state', (
    tester,
  ) async {
    await pumpSectors(tester);

    await tester.tap(find.byKey(MarketSectorsPage.timeframe7dKey));
    await tester.pumpAndSettle();

    expect(find.text('+15.43%'), findsWidgets);

    await tester.tap(find.byKey(MarketSectorsPage.sortCoinCountKey));
    await tester.pumpAndSettle();

    expect(find.text('234 coins'), findsOneWidget);
    expect(find.byKey(MarketSectorsPage.sectorKey('meme')), findsOneWidget);
  });

  testWidgets('SC-011 supports sector query detail and returns to list', (
    tester,
  ) async {
    await pumpSectors(
      tester,
      initialLocation: '${AppRoutePaths.marketsSectors}?id=ai',
    );

    expect(find.byType(MarketSectorsPage), findsOneWidget);
    expect(find.text('Trí tuệ nhân tạo'), findsWidgets);
    expect(find.text('Coin nổi bật'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Ngành thị trường'), findsOneWidget);
    expect(find.byKey(MarketSectorsPage.sectorKey('ai')), findsOneWidget);
  });

  testWidgets('SC-011 back button returns to SC-008 Markets', (tester) async {
    await pumpSectors(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
    expect(find.text('Tìm kiếm BTC, ETH...'), findsOneWidget);
  });

  testWidgets('SC-011 full content reaches comparison and footer', (
    tester,
  ) async {
    await pumpSectors(tester);

    await tester.ensureVisible(find.byKey(MarketSectorsPage.comparisonKey));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('So sánh nhanh'), findsOneWidget);
    expect(find.text('8 ngành · Dữ liệu cập nhật liên tục'), findsOneWidget);
    expect(find.text('-3.45%'), findsWidgets);
  });
}
