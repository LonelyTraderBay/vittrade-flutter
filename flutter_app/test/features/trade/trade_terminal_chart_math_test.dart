import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_chart_math.dart';

void main() {
  group('tradeTerminalCandles — deterministic theo (pairId, timeframe)', () {
    test('cùng (cặp, khung giờ) trả cùng chuỗi', () {
      final a = tradeTerminalCandles(
        anchorPrice: 67543.21,
        pairId: 'btcusdt',
        timeframe: '1h',
      );
      final b = tradeTerminalCandles(
        anchorPrice: 67543.21,
        pairId: 'btcusdt',
        timeframe: '1h',
      );
      expect(a.length, b.length);
      for (var i = 0; i < a.length; i++) {
        expect(a[i].open, b[i].open);
        expect(a[i].high, b[i].high);
        expect(a[i].low, b[i].low);
        expect(a[i].close, b[i].close);
      }
    });

    test('nến cuối đóng đúng giá neo (giá hiện tại của cặp)', () {
      final candles = tradeTerminalCandles(
        anchorPrice: 3521.44,
        pairId: 'ethusdt',
        timeframe: '4h',
      );
      expect(candles.last.close, 3521.44);
    });

    test('khung ngắn nhiều nến hơn khung dài', () {
      final short = tradeTerminalCandles(
        anchorPrice: 100,
        pairId: 'btcusdt',
        timeframe: '1m',
      );
      final long = tradeTerminalCandles(
        anchorPrice: 100,
        pairId: 'btcusdt',
        timeframe: '1D',
      );
      expect(short.length, 96);
      expect(long.length, 48);
    });

    test('high >= max(open, close) và low <= min(open, close) mỗi nến', () {
      final candles = tradeTerminalCandles(
        anchorPrice: 146.72,
        pairId: 'solusdt',
        timeframe: '15m',
      );
      for (final candle in candles) {
        expect(
          candle.high,
          greaterThanOrEqualTo(
            candle.open > candle.close ? candle.open : candle.close,
          ),
        );
        expect(
          candle.low,
          lessThanOrEqualTo(
            candle.open < candle.close ? candle.open : candle.close,
          ),
        );
      }
    });
  });

  group('tradeTerminalMovingAverage', () {
    test('chuỗi không đổi trả không có đường MA', () {
      expect(tradeTerminalMovingAverage(const [1, 2]), isEmpty);
    });

    test('SMA của chuỗi hằng bằng đúng hằng số', () {
      final ma = tradeTerminalMovingAverage(List.filled(10, 5.0));
      expect(ma.length, 4); // 10 − 7 + 1
      expect(ma.every((value) => value == 5.0), isTrue);
    });
  });

  group('tradeTerminalVolumeProfile', () {
    test('mỗi nến (trừ nến đầu) có một khối lượng không âm', () {
      final candles = tradeTerminalCandles(
        anchorPrice: 67543.21,
        pairId: 'btcusdt',
        timeframe: '1h',
      );
      final volumes = tradeTerminalVolumeProfile(candles, seed: 'btcusdt');
      expect(volumes.length, candles.length - 1);
      expect(volumes.every((value) => value >= 0), isTrue);
    });
  });

  group('tradeTerminalTimeLabels', () {
    test('mốc cuối luôn là "Hiện tại"', () {
      final labels = tradeTerminalTimeLabels('1h', 72, 4);
      expect(labels.last, 'Hiện tại');
      expect(labels.length, 4);
    });
  });
}
