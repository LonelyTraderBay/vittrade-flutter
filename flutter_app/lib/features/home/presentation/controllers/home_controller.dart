import 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';

export 'package:vit_trade_flutter/features/home/domain/entities/home_entities.dart';

final class HomeController {
  const HomeController({required this.state});

  final HomeViewState state;

  List<HomeCryptoPair> get hotPairs {
    return state.snapshot.pairs
        .where((pair) => pair.isFavorite)
        .take(5)
        .toList();
  }

  List<HomeCryptoPair> get gainers {
    final pairs = [...state.snapshot.pairs];
    pairs.sort((a, b) => b.change24h.compareTo(a.change24h));
    return pairs.take(5).toList();
  }

  List<HomeCryptoPair> get losers {
    final pairs = [...state.snapshot.pairs];
    pairs.sort((a, b) => a.change24h.compareTo(b.change24h));
    return pairs.take(5).toList();
  }

  /// Pairs for a market tab. Phone keeps the default 5-row feed; a denser
  /// surface (tablet watchlist panel) passes a higher [limit].
  List<HomeCryptoPair> tabPairs(String marketTab, {int limit = 5}) {
    return switch (marketTab) {
      'gainers' => _sortedByChange(descending: true).take(limit).toList(),
      'losers' => _sortedByChange(descending: false).take(limit).toList(),
      'new' => state.snapshot.pairs.reversed.take(limit).toList(),
      _ =>
        state.snapshot.pairs
            .where((pair) => pair.isFavorite)
            .take(limit)
            .toList(),
    };
  }

  List<HomeCryptoPair> _sortedByChange({required bool descending}) {
    final pairs = [...state.snapshot.pairs];
    pairs.sort(
      (a, b) => descending
          ? b.change24h.compareTo(a.change24h)
          : a.change24h.compareTo(b.change24h),
    );
    return pairs;
  }
}

final class HomeViewState {
  const HomeViewState({required this.snapshot});

  final HomeSnapshot snapshot;
}
