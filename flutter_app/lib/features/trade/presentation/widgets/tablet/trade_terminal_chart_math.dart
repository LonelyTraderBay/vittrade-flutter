// Toán tử chuỗi cho khung nhìn biểu đồ nến của terminal Trade tablet
// (SC-048) — thuần Dart, DETERMINISTIC theo (pairId, timeframe) để widget
// test và golden ổn định, không phụ thuộc `Random()` không hạt giống.
// Mô hình theo khuôn deterministic đã chứng minh ở terminal Markets
// (SC-044); giữ riêng cho Trade vì guardrail cross-feature import cấm
// `trade` dùng widget/toán tử của `markets`.

/// Hạt giả đoán định (LCG).
int _nextRand(int state) => (1103515245 * state + 12345) & 0x7FFFFFFF;

int _hashSeed(String input) {
  var hash = 5381;
  for (final code in input.codeUnits) {
    hash = ((hash << 5) + hash + code) & 0x7FFFFFFF;
  }
  return hash == 0 ? 7 : hash;
}

/// Khung giờ của terminal Trade — trùng bộ timeframes mà mock
/// `getAdvancedChart()` đã khai báo ('1m'…'1W').
const tradeTerminalTimeframes = ['1m', '5m', '15m', '1h', '4h', '1D', '1W'];

/// Số phút mỗi khung thời gian — dùng cho nhãn trục và biên độ chuỗi.
int tradeTerminalTimeframeMinutes(String timeframe) => switch (timeframe) {
  '1m' => 1,
  '5m' => 5,
  '15m' => 15,
  '1h' => 60,
  '4h' => 240,
  '1W' => 10080,
  _ => 1440, // 1D
};

/// Một nến OHLC của terminal. Bull = close >= open (thân RỖNG khi vẽ),
/// bear = close < open (thân đặc) — khác biệt hình dạng, không phụ thuộc
/// màu (a11y theo khuyến nghị chart tài chính).
class TradeTerminalCandle {
  const TradeTerminalCandle({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  final double open;
  final double high;
  final double low;
  final double close;

  bool get bullish => close >= open;
}

/// Sinh chuỗi NẾN cho khung [timeframe], neo quanh [anchorPrice] (giá hiện
/// tại của cặp): TF ngắn = biên độ nhỏ và nhiều nến; TF dài = biên độ lớn
/// và thưa. Cùng (pairId, timeframe) luôn trả cùng chuỗi; nến cuối đóng
/// đúng [anchorPrice].
List<TradeTerminalCandle> tradeTerminalCandles({
  required double anchorPrice,
  required String pairId,
  required String timeframe,
}) {
  final minutes = tradeTerminalTimeframeMinutes(timeframe);
  final count = minutes <= 5
      ? 96
      : minutes <= 60
      ? 72
      : minutes <= 240
      ? 60
      : 48;
  final band =
      anchorPrice *
      (minutes >= 10080
          ? 0.09
          : minutes >= 1440
          ? 0.05
          : minutes >= 240
          ? 0.03
          : 0.012);
  var state = _hashSeed('$pairId|$timeframe');
  final closes = <double>[];
  var value = anchorPrice * (1 - band * 0.5);
  for (var index = 0; index < count; index += 1) {
    state = _nextRand(state);
    final shock = ((state % 2000) - 1000) / 1000; // −1..1
    // Hồi về mốc neo để chuỗi khép quanh giá hiện tại.
    final pull = (anchorPrice - value) * 0.12;
    value = value + pull + shock * band * 0.22;
    closes.add(value);
  }
  closes[count - 1] = anchorPrice;

  final wickBand =
      anchorPrice *
      (minutes >= 10080
          ? 0.012
          : minutes >= 1440
          ? 0.007
          : minutes >= 240
          ? 0.004
          : 0.0018);
  var wickState = _hashSeed('candle|$pairId|$timeframe');
  final candles = <TradeTerminalCandle>[];
  for (var index = 0; index < count; index += 1) {
    wickState = _nextRand(wickState);
    final wickUp = ((wickState % 1000) / 1000) * wickBand;
    wickState = _nextRand(wickState);
    final wickDown = ((wickState % 1000) / 1000) * wickBand;
    final close = closes[index];
    final open = index == 0 ? closes.first : closes[index - 1];
    final top = close > open ? close : open;
    final bottom = close < open ? close : open;
    candles.add(
      TradeTerminalCandle(
        open: open,
        high: top + wickUp + 1e-9,
        low: bottom - wickDown - 1e-9,
        close: close,
      ),
    );
  }
  return candles;
}

/// Trung bình động đơn giản (SMA) — đường MA thật, period mặc định 7 nến.
/// Trả danh sách rỗng nếu chuỗi ngắn hơn period.
List<double> tradeTerminalMovingAverage(List<double> series, {int period = 7}) {
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

/// Khối lượng mỗi nến — đồng biến với biên độ chuyển giá giữa 2 nến, thêm
/// hạt nhiễu theo seed.
List<double> tradeTerminalVolumeProfile(
  List<TradeTerminalCandle> candles, {
  required String seed,
}) {
  if (candles.length < 2) return const [];
  var state = _hashSeed('vol|$seed');
  final volumes = <double>[];
  for (var index = 1; index < candles.length; index += 1) {
    state = _nextRand(state);
    final move = (candles[index].close - candles[index - 1].close).abs();
    final noise = ((state % 100) / 100) * 0.5 + 0.75;
    volumes.add((move + 1e-9) * noise);
  }
  return volumes;
}

/// Nhãn thời gian tương đối tiếng Việt cho trục ngang: từ tổng phút của
/// cửa sổ, trả [count] mốc cách đều (mốc cuối = 'Hiện tại').
List<String> tradeTerminalTimeLabels(String timeframe, int points, int count) {
  final totalMinutes = tradeTerminalTimeframeMinutes(timeframe) * points;
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
String tradeTerminalAxisLabel(double value) => value.toStringAsFixed(2);
