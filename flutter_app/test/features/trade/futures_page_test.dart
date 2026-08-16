import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/futures/futures_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

void main() {
  Future<void> pumpFutures(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // GD4 Cụm F3: previewFuturesOrder giờ Future<T>, watch theo family
          // key = draft (đổi mỗi keystroke) — loadDelay mặc định 300ms để
          // lại pending timer mồ côi khi draft cũ bị autoDispose trước khi
          // Future resolve (xem GD4-Async-Playbook.md mục 9).
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeFutures('btcusdt'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-057 mock repository exposes futures BE draft', () async {
    final repo = const MockTradeRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getFutures(pairId: 'btcusdt');
    final preview = await repo.previewFuturesOrder(
      const TradeFuturesOrderDraft(
        pairId: 'btcusdt',
        side: TradeFuturesSide.long,
        type: TradeFuturesOrderType.market,
        margin: 500,
        leverage: 10,
      ),
    );
    final receipt = await repo.submitFuturesOrder(
      const TradeFuturesOrderDraft(
        pairId: 'btcusdt',
        side: TradeFuturesSide.long,
        type: TradeFuturesOrderType.market,
        margin: 500,
        leverage: 10,
      ),
    );

    expect(snapshot.pair.symbol, 'BTC/USDT');
    expect(snapshot.positions, hasLength(2));
    expect(snapshot.leverages, [1, 2, 3, 5, 10, 20, 50, 75, 100]);
    expect(snapshot.indexPrice.toStringAsFixed(2), '67529.70');
    expect(snapshot.fundingRate, .01);
    expect(preview.positionSize, 5000);
    expect(preview.canOpen, isTrue);
    expect(receipt.orderId, 'FUT-DEMO-057');
    expect(
      snapshot.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.submitting,
        TradeScreenState.success,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-057 renders FuturesPage inside the Trade shell', (
    tester,
  ) async {
    await pumpFutures(tester);

    expect(find.byType(FuturesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('BTC/USDT'), findsAtLeastNWidgets(1));
    expect(find.text('Chế độ Pro'), findsNothing);
    expect(find.text('Giá tăng'), findsOneWidget);
    expect(find.text('Giá giảm'), findsOneWidget);
    expect(find.textContaining('10x'), findsWidgets);
    expect(find.byKey(FuturesPage.marginFieldKey), findsOneWidget);
  });

  testWidgets('SC-320 uses full-width futures simple workspace at 360x800', (
    tester,
  ) async {
    await pumpFutures(tester, viewport: const Size(360, 800));

    expect(find.byType(FuturesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(FuturesPage.closeKey), findsOneWidget);
    expect(find.byKey(FuturesPage.sideKey('long')), findsOneWidget);

    final scrollFinder = find.descendant(
      of: find.byType(FuturesPage),
      matching: find.byType(SingleChildScrollView),
    );
    expect(scrollFinder, findsWidgets);

    await tester.ensureVisible(find.byKey(FuturesPage.submitKey));
    await tester.pumpAndSettle();

    final submitRect = tester.getRect(find.byKey(FuturesPage.submitKey));
    expect(submitRect.bottom, lessThanOrEqualTo(800));
  });

  testWidgets('SC-057 side, percent, and confirm submit stay local', (
    tester,
  ) async {
    await pumpFutures(tester);

    await tester.tap(find.byKey(FuturesPage.sideKey('short')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(FuturesPage.pctKey(25)),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(FuturesPage.pctKey(25)));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Xem trước lệnh Futures'));
    await tester.pumpAndSettle();
    expect(find.text('Xem trước lệnh Futures'), findsOneWidget);
    expect(find.text('Ước tính giá thanh lý'), findsOneWidget);
    expect(find.text('Kiểm tra rủi ro'), findsOneWidget);
    await tester.ensureVisible(find.byKey(FuturesPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(FuturesPage.submitKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(VitTradeConfirmKeys.confirmSubmit));
    await tester.pumpAndSettle();

    expect(find.byType(FuturesPage), findsOneWidget);
    expect(find.text('Nhập ký quỹ để tiếp tục'), findsOneWidget);
    // Success notice sheet shown after order submit (replaces old inline banner).
    expect(find.text('Đã gửi lệnh'), findsWidgets);
  });

  testWidgets('SC-057 close returns to SC-049 TradePage', (tester) async {
    await pumpFutures(tester);

    await tester.tap(find.byKey(FuturesPage.closeKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
  });

  testWidgets('SC-048 Futures quick action opens SC-057', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.trade),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(TradePage.quickNavKey('futures')));
    await tester.tap(find.byKey(TradePage.quickNavKey('futures')));
    await tester.pumpAndSettle();

    expect(find.byType(FuturesPage), findsOneWidget);
  });
}
