import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/phone/pages/tools/advanced_chart_page.dart';

/// PERF-HN5: painter perf/repaint regression coverage for the advanced
/// chart. `_AdvancedTradeChartPainter` and `_expandedCandlesFor` are private
/// to `advanced_chart_page.dart`'s library, so:
/// - the pure candle-expansion math is tested directly via the exposed
///   `@visibleForTesting` top-level function `expandAdvancedTradeCandles`;
/// - `shouldRepaint` and the page-level memo are pinned together through the
///   real widget tree — `TradeCandle`/`TradeChartIndicator` have no value
///   `==` (default identity), so there is no way to build "equal but not
///   identical" candle lists; the only meaningful pin is "same production
///   painter instance, unrelated rebuild -> shouldRepaint false" and "no
///   repaint actually happens" (via `advancedTradeChartPainterDebugPaintCount`).
void main() {
  group('expandAdvancedTradeCandles (pure)', () {
    const c1 = TradeCandle(
      time: '09:00',
      open: 100,
      high: 110,
      low: 95,
      close: 105,
      volume: 10,
    );
    const c2 = TradeCandle(
      time: '09:05',
      open: 105,
      high: 115,
      low: 100,
      close: 108,
      volume: 12,
    );
    const c3 = TradeCandle(
      time: '09:10',
      open: 108,
      high: 118,
      low: 103,
      close: 112,
      volume: 14,
    );

    test('returns the same source when it has fewer than 2 candles', () {
      const single = [c1];
      expect(identical(expandAdvancedTradeCandles(single), single), isTrue);

      const empty = <TradeCandle>[];
      expect(identical(expandAdvancedTradeCandles(empty), empty), isTrue);
    });

    test('expands (n - 1) * 3 + 1 candles and preserves the last candle', () {
      final source = [c1, c2, c3];
      final expanded = expandAdvancedTradeCandles(source);

      expect(expanded, hasLength((source.length - 1) * 3 + 1));
      expect(identical(expanded.last, c3), isTrue);
    });

    test('first expanded open matches the source series open', () {
      final expanded = expandAdvancedTradeCandles([c1, c2, c3]);
      expect(expanded.first.open, c1.open);
    });

    test('is pure — repeated calls on the same input produce equal output', () {
      final source = [c1, c2, c3];
      final first = expandAdvancedTradeCandles(source);
      final second = expandAdvancedTradeCandles(source);

      expect(first, hasLength(second.length));
      for (var i = 0; i < first.length; i++) {
        expect(first[i].close, second[i].close);
        expect(first[i].open, second[i].open);
        expect(first[i].high, second[i].high);
        expect(first[i].low, second[i].low);
        expect(first[i].volume, second[i].volume);
      }
    });
  });

  group('_AdvancedTradeChartPainter repaint discipline', () {
    Future<void> pumpAdvancedChart(WidgetTester tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(440, 956);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          child: VitTradeApp(
            routerConfig: createAppRouter(
              initialLocation: AppRoutePaths.tradeAdvancedChart('btcusdt'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Finder chartPainterFinder() => find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint &&
          widget.painter.runtimeType.toString() == '_AdvancedTradeChartPainter',
    );

    testWidgets(
      'shouldRepaint is false for the same production painter across an '
      'unrelated rebuild (opening/closing the indicator sheet)',
      (tester) async {
        await pumpAdvancedChart(tester);

        final beforePainter = tester
            .widget<CustomPaint>(chartPainterFinder())
            .painter!;

        // Unrelated rebuild: toggles `_showIndicators` only, touches neither
        // `candles` nor `indicators`.
        await tester.tap(find.byKey(AdvancedChartPage.indicatorButtonKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(AdvancedChartPage.closeIndicatorsKey));
        await tester.pumpAndSettle();

        final afterPainter = tester
            .widget<CustomPaint>(chartPainterFinder())
            .painter!;

        expect(afterPainter.shouldRepaint(beforePainter), isFalse);
      },
    );

    testWidgets(
      'debugPaintCount does not increase after the first paint when only '
      'the indicator sheet is opened and closed',
      (tester) async {
        await pumpAdvancedChart(tester);
        // First paint (and any pumpAndSettle-driven repaints) already
        // happened above — snapshot the counter now as the baseline.
        final baseline = advancedTradeChartPainterDebugPaintCount;

        await tester.tap(find.byKey(AdvancedChartPage.indicatorButtonKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(AdvancedChartPage.closeIndicatorsKey));
        await tester.pumpAndSettle();

        expect(advancedTradeChartPainterDebugPaintCount, baseline);
      },
    );

    testWidgets(
      'debugPaintCount DOES increase when an indicator is actually toggled '
      '(sanity check — the guardrail above must not be vacuously true)',
      (tester) async {
        await pumpAdvancedChart(tester);
        final baseline = advancedTradeChartPainterDebugPaintCount;

        await tester.tap(find.byKey(AdvancedChartPage.indicatorButtonKey));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(AdvancedChartPage.indicatorKey('ma7')));
        await tester.pumpAndSettle();

        expect(advancedTradeChartPainterDebugPaintCount, greaterThan(baseline));
      },
    );
  });
}
