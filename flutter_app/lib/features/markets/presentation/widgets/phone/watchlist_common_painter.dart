part of '../../phone/pages/hub/watchlist_page.dart';

class _EmptyWatchlist extends StatelessWidget {
  const _EmptyWatchlist({required this.searchActive, required this.onAddPair});

  final bool searchActive;
  final VoidCallback onAddPair;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MarketsSpacingTokens.watchlistEmptyPadding,
      child: VitEmptyState(
        icon: Icons.star_border_rounded,
        title: searchActive
            ? 'Không tìm thấy cặp nào'
            : 'Chưa có cặp trong danh sách theo dõi',
        message: searchActive
            ? 'Thử tìm BTC, ETH hoặc SOL'
            : 'Thêm cặp giao dịch để theo dõi nhanh giá và ghi chú.',
        actionLabel: searchActive ? null : 'Thêm cặp giao dịch',
        onAction: searchActive ? null : onAddPair,
      ),
    );
  }
}

class _WatchlistItem {
  const _WatchlistItem({required this.entry, required this.pair});

  final MarketWatchlistEntry entry;
  final MarketPair pair;
}

MarketPair? _findPair(List<MarketPair> pairs, String id) {
  for (final pair in pairs) {
    if (pair.id == id) return pair;
  }
  return null;
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value)}';
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatNumber(double value) {
  final fractionDigits = value >= 100
      ? 2
      : value >= 1
      ? 2
      : 4;
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    final remaining = integer.length - i;
    buffer.write(integer[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return '${buffer.toString()}.${parts.last}';
}
