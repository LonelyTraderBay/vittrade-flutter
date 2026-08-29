import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pair_chart_math.dart';

/// Khóa máy cho helper chart giá (P1 2026-08-29 "một UI chi tiết coin hoàn
/// chỉnh"): timeframe PHẢI đổi chuỗi dữ liệu (hết nút giả), cùng (TF, seed)
/// phải deterministic, MA/volume/labels đúng hợp đồng.
void main() {
  const base = <double>[
    100.0,
    101.5,
    99.8,
    102.2,
    103.0,
    101.9,
    100.5,
    102.8,
    104.1,
    103.2,
    102.0,
    101.4,
    103.6,
    104.8,
    103.9,
    102.5,
    101.8,
    103.3,
    104.6,
    105.2,
    104.0,
    102.9,
    103.7,
    104.9,
  ];

  test('timeframe khác nhau sinh chuỗi khác nhau (nút wired thật)', () {
    final h1 = pairChartSeriesForTimeframe(base, timeframe: '1H', seed: 'btc');
    final d1 = pairChartSeriesForTimeframe(base, timeframe: '1D', seed: 'btc');
    expect(h1, isNot(equals(d1)));
    // Số điểm cũng khác nhịp: TF ngắn nhiều điểm hơn TF dài.
    expect(h1.length, greaterThan(d1.length));
  });

  test('cùng (timeframe, seed) deterministic giữa các lần gọi', () {
    final a = pairChartSeriesForTimeframe(base, timeframe: '4H', seed: 'eth');
    final b = pairChartSeriesForTimeframe(base, timeframe: '4H', seed: 'eth');
    expect(a, equals(b));
  });

  test('seed khác (coin khác) sinh chuỗi khác', () {
    final btc = pairChartSeriesForTimeframe(base, timeframe: '1D', seed: 'btc');
    final eth = pairChartSeriesForTimeframe(base, timeframe: '1D', seed: 'eth');
    expect(btc, isNot(equals(eth)));
  });

  test('chuỗi neo về giá hiện tại ở điểm cuối', () {
    final series = pairChartSeriesForTimeframe(
      base,
      timeframe: '1W',
      seed: 'sol',
    );
    expect(series.last, closeTo(base.last, 1e-9));
    expect(series.first, isNot(closeTo(base.last, 1e-9)));
  });

  test('MA(7) đúng hợp đồng SMA', () {
    const series = <double>[1, 2, 3, 4, 5, 6, 7, 8, 9];
    final ma = computeMovingAverage(series);
    expect(ma.length, series.length - 7 + 1);
    expect(ma.first, closeTo(28 / 7, 1e-9));
    expect(ma.last, closeTo(42 / 7, 1e-9));
  });

  test('MA chuỗi ngắn hơn period trả rỗng', () {
    expect(computeMovingAverage([1, 2, 3]), isEmpty);
  });

  test('volume profile: đúng số nến và không âm', () {
    final volumes = computeVolumeProfile(base, seed: 'btc');
    expect(volumes.length, base.length - 1);
    for (final value in volumes) {
      expect(value, greaterThan(0));
    }
  });

  test('nhãn thời gian tiếng Việt, mốc cuối là Hiện tại', () {
    // 96 nến × 15 phút = 24 giờ → mốc 75% là 18 giờ.
    final labels = pairChartTimeLabels('15m', 96, 4);
    expect(labels.length, 4);
    expect(labels.last, 'Hiện tại');
    expect(labels.first, contains('giờ'));
  });

  test('nhãn trục giá 2 số thập phân', () {
    expect(pairChartAxisLabel(67543.219), '67543.22');
  });
}
