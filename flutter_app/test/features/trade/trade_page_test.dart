import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/convert/convert_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTrade(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.trade,
    Size viewport = const Size(440, 956),
    TradeRepository? repository,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // GD4 Cụm F3: previewOrder giờ Future<T>, watch theo family key =
          // draft (đổi mỗi keystroke) — loadDelay mặc định 300ms để lại
          // pending timer mồ côi khi draft cũ bị autoDispose trước khi
          // Future resolve (xem GD4-Async-Playbook.md mục 9).
          tradeRepositoryProvider.overrideWithValue(
            repository ?? const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-048 mock repository exposes the trade BE draft read model',
    () async {
      final repo = const MockTradeRepository(loadDelay: Duration.zero);
      final snapshot = await repo.getTrade();
      final pairSnapshot = await repo.getTrade(pairId: 'btcusdt');

      expect(snapshot.pair.symbol, 'BTC/USDT');
      expect(pairSnapshot.pair.id, 'btcusdt');
      expect(snapshot.pairs, hasLength(3));
      expect(snapshot.orderBook.bids, isNotEmpty);
      expect(snapshot.trades, isNotEmpty);
      expect(snapshot.orders, isNotEmpty);
      expect(snapshot.positions, isNotEmpty);
      expect(snapshot.copyProviders, isNotEmpty);
      expect(snapshot.botStrategies, isNotEmpty);
      expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
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

      final preview = await repo.previewOrder(
        const TradeOrderDraft(
          pairId: 'btcusdt',
          side: TradeOrderSide.buy,
          type: TradeOrderType.limit,
          price: 67543.21,
          amount: .1,
        ),
      );
      expect(preview.total, closeTo(6754.321, .001));
      expect(preview.feeRate, .00085);
    },
  );

  testWidgets('SC-049 renders the BTC pair route variant', (tester) async {
    await pumpTrade(
      tester,
      initialLocation: AppRoutePaths.tradePair('btcusdt'),
    );

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC/USDT'), findsAtLeastNWidgets(1));
    expect(find.text('67,543.21'), findsAtLeastNWidgets(1));
    expect(find.byKey(TradePage.buySideKey), findsOneWidget);
    expect(find.text('BÁN'), findsOneWidget);
  });

  testWidgets('SC-049 side query preselects sell and invalid side falls back', (
    tester,
  ) async {
    await pumpTrade(
      tester,
      initialLocation: '${AppRoutePaths.tradePair('btcusdt')}?side=sell',
    );

    expect(
      find.byKey(const Key('sc048_trade_active_sell_side')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('sc048_trade_active_buy_side')), findsNothing);

    await pumpTrade(
      tester,
      initialLocation: '${AppRoutePaths.tradePair('btcusdt')}?side=short',
    );

    expect(
      find.byKey(const Key('sc048_trade_active_buy_side')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('sc048_trade_active_sell_side')), findsNothing);
  });

  testWidgets('SC-048 renders trade form inside the Trade shell', (
    tester,
  ) async {
    await pumpTrade(tester);

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC/USDT'), findsAtLeastNWidgets(1));
    expect(find.byKey(TradePage.quickNavKey('spot')), findsOneWidget);
    expect(find.byKey(TradePage.quickNavKey('convert')), findsOneWidget);
    expect(find.byKey(TradePage.quickNavKey('futures')), findsOneWidget);
    expect(find.text('Giao ngay'), findsOneWidget);
    expect(find.text('Chuyển đổi'), findsOneWidget);
    expect(find.text('Phái sinh'), findsOneWidget);
    // STEP-P2.4 / D5 header chrome
    expect(find.byTooltip('Lệnh'), findsOneWidget);
    expect(find.byTooltip('Vị thế'), findsOneWidget);
    expect(find.text('67,543.21'), findsAtLeastNWidgets(1));
    expect(find.text('Chế độ Pro'), findsNothing);
    expect(find.text('Giao dịch Spot'), findsOneWidget);
    expect(find.text('Charts'), findsNothing);
    expect(find.byKey(TradePage.buySideKey), findsOneWidget);
    expect(find.text('BÁN'), findsOneWidget);
    expect(find.text('Tiếp theo'), findsOneWidget);
    expect(find.textContaining('Số dư khả dụng'), findsAtLeastNWidgets(1));
    expect(find.text('Trượt giá'), findsWidgets);
    expect(
      find.textContaining('Giá thị trường có thể thay đổi'),
      findsOneWidget,
    );
    expect(find.text('Đánh giá rủi ro'), findsOneWidget);
    expect(
      find.textContaining('Không hoàn tác sau khi xác nhận gửi'),
      findsWidgets,
    );
  });

  testWidgets('SC-048 first viewport reaches order side switch', (
    tester,
  ) async {
    await pumpTrade(tester);

    expectActionableInFirstViewport(
      tester,
      find.byKey(TradePage.buySideKey),
      routeName: 'TradePage',
      actionLabel: 'buy side switch',
    );
  });

  testWidgets('SC-048 amount shortcuts update the order draft', (tester) async {
    await pumpTrade(tester);

    await tester.scrollUntilVisible(
      find.byKey(TradePage.pctKey(25)),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(TradePage.pctKey(25)));
    await tester.pumpAndSettle();

    expect(find.textContaining('0.037'), findsWidgets);
    expect(find.text('Xác nhận MUA'), findsOneWidget);
  });

  testWidgets('SC-048 confirm sheet gates order submission', (tester) async {
    await pumpTrade(tester);

    await tester.scrollUntilVisible(
      find.byKey(TradePage.pctKey(25)),
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(TradePage.pctKey(25)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(TradePage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byKey(TradePage.confirmSheetKey), findsOneWidget);
    expect(find.text('Xác nhận gửi'), findsOneWidget);

    await tester.tap(find.byKey(VitTradeConfirmKeys.confirmSubmit));
    await tester.pumpAndSettle();

    expect(find.textContaining('ORD-'), findsWidgets);
  });

  testWidgets(
    'SC-048 nhánh lỗi ADR-001: repo ném thì ở lại trang, hiện error, không điều hướng receipt',
    (tester) async {
      // GD4 Cụm F3: `simulateError: true` giờ ảnh hưởng CẢ đường đọc
      // (getTrade cũng qua `_simulateNetwork()`) — test này muốn trang tải
      // bình thường và CHỈ submitOrder thất bại, nên dùng double riêng thay
      // vì cờ `simulateError` toàn repo (khuôn `_OfflineSubmitTradeRepository`
      // trong trade_controller_test.dart).
      await pumpTrade(tester, repository: const _SubmitFailsTradeRepository());

      await tester.scrollUntilVisible(
        find.byKey(TradePage.pctKey(25)),
        120,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.byKey(TradePage.pctKey(25)));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(TradePage.submitKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(VitTradeConfirmKeys.confirmSubmit));
      await tester.pumpAndSettle();

      expect(find.byType(TradePage), findsOneWidget);
      expect(find.textContaining('ORD-'), findsNothing);
      expect(find.text('Gửi lệnh thất bại'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('SC-048 quick nav opens SC-056 ConvertPage', (tester) async {
    await pumpTrade(tester);

    final convertNav = find.byKey(TradePage.quickNavKey('convert'));
    await tester.ensureVisible(convertNav);
    await tester.tap(convertNav);
    await tester.pumpAndSettle();

    expect(find.byType(ConvertPage), findsOneWidget);
    expect(find.text('Đổi tài sản nhanh'), findsOneWidget);
  });

  testWidgets('SC-048 360px simple layout stays usable', (tester) async {
    configureFirstViewport(tester, VitFirstViewport.minimumPhone);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.trade),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expectActionableInFirstViewport(
      tester,
      find.byKey(TradePage.buySideKey),
      routeName: 'TradePage',
      actionLabel: 'buy side switch',
    );
    expect(find.text('Charts'), findsNothing);
  });

  testWidgets('SC-048 product hub follows enterprise product order', (
    tester,
  ) async {
    await pumpTrade(tester);

    const primaryIds = ['spot', 'convert', 'futures', 'margin'];
    for (final id in primaryIds) {
      expect(find.byKey(TradePage.quickNavKey(id)), findsOneWidget);
    }

    expect(find.text('Thêm'), findsNothing);
  });
}

/// Double chỉ phục vụ nhánh lỗi generic (không offline) của máy trạng thái
/// ADR-001: đường đọc forward sang mock thật (zero delay), submitOrder ném
/// lỗi generic — mirror `_OfflineSubmitTradeRepository` trong
/// trade_controller_test.dart nhưng cho nhánh `error` thay vì `offline`.
final class _SubmitFailsTradeRepository implements TradeRepository {
  const _SubmitFailsTradeRepository();

  static const _mock = MockTradeRepository(loadDelay: Duration.zero);

  @override
  Future<TradeScreenSnapshot> getTrade({String pairId = 'btcusdt'}) =>
      _mock.getTrade(pairId: pairId);

  @override
  Future<TradeOrderPreview> previewOrder(TradeOrderDraft draft) =>
      _mock.previewOrder(draft);

  @override
  Future<TradeOrderReceipt> submitOrder(TradeOrderDraft draft) async {
    throw StateError('trade_submit_failed_test');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}
