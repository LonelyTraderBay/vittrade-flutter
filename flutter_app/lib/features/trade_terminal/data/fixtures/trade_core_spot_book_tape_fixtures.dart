part of '../repositories/mock_trade_terminal_repository.dart';

// Builder sổ lệnh + tape deterministic cho terminal Trade tablet (tách
// khỏi file fixtures chính theo quy ước part-file theo vai trò, giữ mỗi
// file dưới ngưỡng 600 dòng của guardrail size-debt).

/// Hạt giống đoán định (LCG) cho builder sổ lệnh/tape — cùng (seed, pair)
/// luôn trả cùng dữ liệu, an toàn cho widget test và golden (khuôn
/// deterministic của terminal SC-044 vẽ lại cho Trade tablet 2026-08-31).
int _fixtureNextRand(int state) => (1103515245 * state + 12345) & 0x7FFFFFFF;

int _fixtureSeed(String input) {
  var hash = 5381;
  for (final code in input.codeUnits) {
    hash = ((hash << 5) + hash + code) & 0x7FFFFFFF;
  }
  return hash == 0 ? 7 : hash;
}

/// Sổ lệnh 12 MỨC MỖI BÊN neo quanh [pair.price] — mật độ chuẩn terminal
/// Bybit (bản cũ chỉ 3 mức/bên làm panel trống 2/3 khi vẽ 12+12). `total`
/// giữ ngữ nghĩa gốc của fixture: notional mức giá × khối lượng.
TradeOrderBook _buildOrderBook(TradePair pair) {
  final baseAmount = pair.id == 'btcusdt'
      ? 0.8
      : pair.id == 'ethusdt'
      ? 6.0
      : 120.0;
  var state = _fixtureSeed('${pair.id}|book');
  final bids = <TradeBookLevel>[];
  final asks = <TradeBookLevel>[];
  for (var level = 0; level < 12; level += 1) {
    final tick = pair.price * 0.00022;
    state = _fixtureNextRand(state);
    final bidNoise = ((state % 1000) / 1000) * 0.6 + 0.4;
    state = _fixtureNextRand(state);
    final askNoise = ((state % 1000) / 1000) * 0.6 + 0.4;
    final bidPrice =
        ((pair.price - tick * (level + 1) * (0.6 + bidNoise * 0.8)) * 100)
            .round() /
        100;
    final askPrice =
        ((pair.price + tick * (level + 1) * (0.6 + askNoise * 0.8)) * 100)
            .round() /
        100;
    final bidAmount =
        ((baseAmount * bidNoise * (1 + level * 0.12)) * 1000).round() / 1000;
    final askAmount =
        ((baseAmount * askNoise * (1 + level * 0.12)) * 1000).round() / 1000;
    bids.add(
      TradeBookLevel(
        price: bidPrice,
        amount: bidAmount,
        total: (bidPrice * bidAmount).roundToDouble(),
      ),
    );
    asks.add(
      TradeBookLevel(
        price: askPrice,
        amount: askAmount,
        total: (askPrice * askAmount).roundToDouble(),
      ),
    );
  }
  return TradeOrderBook(bids: bids, asks: asks);
}

/// Tape 24 print gần đây neo quanh [pair.price] — thời gian lùi đều từng
/// print, hướng mua/bán xen kẽ theo hạt deterministic.
List<TradeTapePrint> _buildTape(TradePair pair) {
  final baseAmount = pair.id == 'btcusdt'
      ? 0.05
      : pair.id == 'ethusdt'
      ? 0.4
      : 8.0;
  var state = _fixtureSeed('${pair.id}|tape');
  var seconds = 23 * 3600 + 29 * 60 + 14;
  final prints = <TradeTapePrint>[];
  for (var index = 0; index < 24; index += 1) {
    state = _fixtureNextRand(state);
    final priceNoise = (((state % 2000) - 1000) / 1000) * pair.price * 0.0003;
    state = _fixtureNextRand(state);
    final amountNoise = ((state % 1000) / 1000) * 1.6 + 0.2;
    state = _fixtureNextRand(state);
    final step = 1 + (state % 3);
    final price = ((pair.price + priceNoise) * 100).round() / 100;
    final hh = (seconds ~/ 3600).toString().padLeft(2, '0');
    final mm = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    prints.add(
      TradeTapePrint(
        price: price,
        amount: ((baseAmount * amountNoise) * 1000).round() / 1000,
        time: '$hh:$mm:$ss',
        isBuy: index % 3 != 1,
      ),
    );
    seconds -= step;
  }
  return prints;
}
