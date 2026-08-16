import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/market_repository.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/research/social_signals_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSignals(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsSignals,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-025 mock repository exposes the BE draft read model', () async {
    final repo = const MockMarketRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getSocialSignals();

    expect(snapshot.signals.map((signal) => signal.id), [
      's1',
      's2',
      's3',
      's4',
      's5',
      's6',
      's7',
    ]);
    expect(snapshot.totalSignals, 7);
    expect(snapshot.hitSignals, 1);
    expect(snapshot.stoppedSignals, 1);
    expect(snapshot.overallWinRate.toStringAsFixed(1), '50.0');
    expect(snapshot.avgPnl.toStringAsFixed(2), '-0.07');
    expect(snapshot.providers.first.name, 'CryptoWhale_VN');
    expect(snapshot.tierConfigs[TradingSignalProviderTier.gold]!.label, 'Vàng');
    expect(
      snapshot.statusConfigs[TradingSignalStatus.targetHit]!.label,
      'Đạt mục tiêu',
    );
    expect(snapshot.marketPairs, hasLength(10));
    expect(snapshot.watchlist, containsAll(['btcusdt', 'ethusdt', 'solusdt']));
    expect(snapshot.alerts, hasLength(2));
    expect(snapshot.screenFilters.categories, [
      'Tín hiệu',
      'Nhà cung cấp',
      'Hiệu suất',
    ]);
    expect(snapshot.chartSeries['pnlPct'], hasLength(7));
    expect(snapshot.chartSeries['s1']!.take(3), [66800, 67543, 64500]);
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

    final targetHit = await repo.getSocialSignals(
      statusFilter: TradingSignalStatus.targetHit,
    );
    expect(targetHit.signals.single.pair, 'LINK/USDT');

    final scalp = await repo.getSocialSignals(
      categoryFilter: TradingSignalCategory.scalp,
    );
    expect(scalp.signals.single.providerName, 'ScalpKing');
  });

  testWidgets('SC-025 renders signals inside the Markets shell', (
    tester,
  ) async {
    await pumpSignals(tester);

    expect(find.byType(SocialSignalsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Tín hiệu giao dịch'), findsOneWidget);
    expect(find.text('Tín hiệu'), findsOneWidget);
    expect(find.text('Nhà cung cấp'), findsOneWidget);
    expect(find.text('Hiệu suất'), findsOneWidget);
    expect(
      find.textContaining('Không phải khuyến nghị đầu tư'),
      findsOneWidget,
    );
    expect(find.byKey(SocialSignalsPage.signalCardKey('s1')), findsOneWidget);
    expect(find.byKey(SocialSignalsPage.signalCardKey('s4')), findsOneWidget);
  });

  testWidgets('SC-025 first viewport reaches the second signal card', (
    tester,
  ) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);
    await pumpSignals(tester);

    expectFirstViewportVisible(
      tester,
      find.byKey(SocialSignalsPage.signalCardKey('s2')),
      targetLabel: 'the second social signal card',
      minVisibleHeight: 24,
    );
  });

  testWidgets('SC-025 filters by status and category', (tester) async {
    await pumpSignals(tester);

    await tester.ensureVisible(
      find.byKey(SocialSignalsPage.statusTargetHitKey),
    );
    await tester.tap(find.byKey(SocialSignalsPage.statusTargetHitKey));
    await tester.pumpAndSettle();

    expect(find.byKey(SocialSignalsPage.signalCardKey('s6')), findsOneWidget);
    expect(find.byKey(SocialSignalsPage.signalCardKey('s1')), findsNothing);
    expect(find.text('LINK/USDT'), findsOneWidget);

    await tester.ensureVisible(find.byKey(SocialSignalsPage.statusAllKey));
    await tester.tap(find.byKey(SocialSignalsPage.statusAllKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(SocialSignalsPage.categoryScalpKey));
    await tester.tap(find.byKey(SocialSignalsPage.categoryScalpKey));
    await tester.pumpAndSettle();

    expect(find.byKey(SocialSignalsPage.signalCardKey('s4')), findsOneWidget);
    expect(find.text('ScalpKing'), findsOneWidget);
    expect(find.byKey(SocialSignalsPage.signalCardKey('s2')), findsNothing);
  });

  testWidgets('SC-025 expands a signal with targets and reasoning', (
    tester,
  ) async {
    await pumpSignals(tester);

    await tester.tap(find.byKey(SocialSignalsPage.signalCardKey('s1')));
    await tester.pumpAndSettle();

    expect(find.text('Mục tiêu'), findsOneWidget);
    expect(find.text('TP1'), findsOneWidget);
    expect(find.text('68,500.00'), findsOneWidget);
    expect(find.text('Độ tin cậy: '), findsOneWidget);
    expect(find.textContaining('BTC phá kháng cự'), findsOneWidget);
    expect(find.text('89 copies'), findsOneWidget);
  });

  testWidgets('SC-025 provider and performance tabs render supporting views', (
    tester,
  ) async {
    await pumpSignals(tester);

    await tester.tap(find.byKey(SocialSignalsPage.providersTabKey));
    await tester.pumpAndSettle();
    expect(
      find.byKey(SocialSignalsPage.providerCardKey('CryptoWhale_VN')),
      findsOneWidget,
    );
    expect(find.text('Win rate'), findsWidgets);
    expect(find.text('Tổng signals'), findsWidgets);

    await tester.tap(find.byKey(SocialSignalsPage.performanceTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Hiệu suất tổng hợp'), findsOneWidget);
    expect(find.text('Phân bổ trạng thái'), findsOneWidget);
    expect(find.text('Kết quả tín hiệu'), findsOneWidget);
    expect(find.text('DOGE/USDT'), findsOneWidget);
  });

  testWidgets('SC-025 back button returns to SC-008 Markets', (tester) async {
    await pumpSignals(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MarketListPage), findsOneWidget);
  });
}
