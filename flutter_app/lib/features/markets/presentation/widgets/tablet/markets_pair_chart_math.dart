// Toán tử chuỗi cho khung nhìn biểu đồ giá của pane chi tiết cặp (SC-044)
// — thuần Dart, DETERMINISTIC theo (timeframe, seed) để widget test và
// golden ổn định, không phụ thuộc Random() không hạt giống.
//
// Bối cảnh 2026-08-29 (P1 "một UI chi tiết coin hoàn chỉnh"): hàng
// timeframe và hàng chỉ báo từng là NÚT GIẢ — đổi timeframe không đổi
// chuỗi (`activeChartSeries` không nhận TF), bật MA không vẽ gì. Helper
// này là nguồn dữ liệu thật cho painter.

/// Hạt giả đoán định (LCG) — đủ nhiễu cho mock, lặp lại được giữa các lần
/// chạy với cùng seed.
int _nextRand(int state) => (1103515245 * state + 12345) & 0x7FFFFFFF;

int _hashSeed(String input) {
  var hash = 5381;
  for (final code in input.codeUnits) {
    hash = ((hash << 5) + hash + code) & 0x7FFFFFFF;
  }
  return hash == 0 ? 7 : hash;
}

/// Số phút mỗi khung thời gian — dùng cho nhãn trục và biên độ chuỗi.
int pairTimeframeMinutes(String timeframe) => switch (timeframe) {
  '15m' => 15,
  '1H' => 60,
  '4H' => 240,
  '1D' => 1440,
  '1W' => 10080,
  _ => 43200, // 1M
};

/// Sinh chuỗi giá [points] điểm cho khung [timeframe], neo quanh
/// [baseSeries] (sparkline gốc của pair): TF ngắn = biên độ nhỏ và nhiều
/// điểm (dao động trong phiên); TF dài = biên độ lớn và thưa (xu hướng).
/// Cùng (timeframe, seed) luôn trả cùng chuỗi — khóa test hành vi.
List<double> pairChartSeriesForTimeframe(
  List<double> baseSeries, {
  required String timeframe,
  required String seed,
  int? points,
}) {
  if (baseSeries.isEmpty) return const [];
  final minutes = pairTimeframeMinutes(timeframe);
  final count =
      points ??
      (minutes <= 15
          ? 96
          : minutes <= 60
          ? 72
          : 48);
  final anchor = baseSeries.last;
  // TF càng dài biên độ quanh mốc càng rộng (1M ~ ±9%, 15m ~ ±1.2%).
  final band =
      anchor *
      (minutes >= 43200
          ? 0.09
          : minutes >= 1440
          ? 0.05
          : minutes >= 240
          ? 0.03
          : 0.012);
  var state = _hashSeed('$seed|$timeframe');
  final series = <double>[];
  var value = anchor + (baseSeries.first - anchor) * 0.6;
  for (var index = 0; index < count; index += 1) {
    state = _nextRand(state);
    final shock = ((state % 2000) - 1000) / 1000; // −1..1
    // Hồi về mốc neo để chuỗi khép quanh giá hiện tại.
    final pull = (anchor - value) * 0.12;
    value = value + pull + shock * band * 0.22;
    series.add(value);
  }
  series[series.length - 1] = anchor;
  return series;
}

/// Trung bình động đơn giản (SMA) — đường MA thật cho chart, period mặc
/// định 7 nến. Trả danh sách rỗng nếu chuỗi ngắn hơn period.
List<double> computeMovingAverage(List<double> series, {int period = 7}) {
  if (series.length < period) return const [];
  final result = <double>[];
  var sum = 0.0;
  for (var index = 0; index < series.length; index += 1) {
    sum += series[index];
    if (index >= period) sum -= series[index - period];
    if (index >= period - 1) result.add(sum / period);
  }
  return result;
}

/// Khối lượng mỗi nến — đồng biến với biên độ chuyển giá giữa 2 điểm
/// (nến dao động mạnh = khối lượng lớn), thêm hạt nhiễu theo seed.
List<double> computeVolumeProfile(List<double> series, {required String seed}) {
  if (series.length < 2) return const [];
  var state = _hashSeed('vol|$seed');
  final volumes = <double>[];
  for (var index = 1; index < series.length; index += 1) {
    state = _nextRand(state);
    final move = (series[index] - series[index - 1]).abs();
    final noise = ((state % 100) / 100) * 0.5 + 0.75;
    volumes.add((move + 1e-9) * noise);
  }
  return volumes;
}

/// Nhãn thời gian tương đối tiếng Việt cho trục ngang: từ tổng phút của
/// cửa sổ, trả [count] mốc cách đều (mốc cuối = 'Hiện tại').
List<String> pairChartTimeLabels(String timeframe, int points, int count) {
  final totalMinutes = pairTimeframeMinutes(timeframe) * points;
  final labels = <String>[];
  for (var index = count - 1; index >= 0; index -= 1) {
    if (index == 0) {
      labels.add('Hiện tại');
      continue;
    }
    final minutes = (totalMinutes * index / count).round();
    labels.add(
      minutes < 60
          ? '−$minutes phút'
          : minutes < 1440
          ? '−${(minutes / 60).round()} giờ'
          : '−${(minutes / 1440).round()} ngày',
    );
  }
  return labels;
}

/// Định dạng giá trục — 2 số thập phân, tabular để canh cột.
String pairChartAxisLabel(double value) => value.toStringAsFixed(2);
