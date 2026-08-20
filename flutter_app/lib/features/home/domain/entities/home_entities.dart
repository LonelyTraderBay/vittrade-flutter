/// Category of a home announcement banner, driving whether it surfaces on
/// the home screen carousel.
enum HomeAnnouncementType { info, campaign, security, risk }

/// Helpers on [HomeAnnouncementType].
extension HomeAnnouncementTypeX on HomeAnnouncementType {
  bool get surfacesOnHome {
    return switch (this) {
      HomeAnnouncementType.campaign ||
      HomeAnnouncementType.security ||
      HomeAnnouncementType.risk => true,
      HomeAnnouncementType.info => false,
    };
  }

  /// Sort key for the home carousel: security and risk surface before
  /// campaigns. One shared definition so the phone and tablet compositions
  /// cannot drift apart (locked by tests on both surfaces).
  int get homePriority {
    return switch (this) {
      HomeAnnouncementType.security => 0,
      HomeAnnouncementType.risk => 1,
      HomeAnnouncementType.campaign => 2,
      HomeAnnouncementType.info => 3,
    };
  }
}

/// A single announcement banner shown in the home screen carousel.
final class HomeAnnouncement {
  const HomeAnnouncement({
    required this.id,
    required this.text,
    required this.type,
    this.active = true,
    this.routePath,
  });

  final String id;
  final String text;
  final HomeAnnouncementType type;
  final bool active;

  /// Destination for the single-announcement case, where tapping the banner
  /// has nothing left to cycle to. Null means the banner stays cycle-only.
  final String? routePath;
}

/// A shortcut tile in the home screen's quick-actions grid (e.g. Deposit,
/// Trade).
final class HomeQuickAction {
  const HomeQuickAction({
    required this.icon,
    required this.label,
    required this.routePath,
    required this.accentKey,
    this.stateLabel,
    this.riskBadge,
  });

  final String icon;
  final String label;
  final String routePath;
  final String accentKey;
  final String? stateLabel;

  /// Directly-renderable risk disclosure label (e.g. 'Rủi ro cao') for
  /// leveraged/speculative products. Null when the action carries no
  /// elevated risk. Mirrors [stateLabel]'s pattern of a display-ready
  /// string rather than an enum, keeping the domain entity resolver-free.
  final String? riskBadge;
}

/// Named product strip on Home (Giao dịch / Pro / Sinh lời / Khám phá).
final class HomeProductGroup {
  const HomeProductGroup({
    required this.id,
    required this.title,
    required this.actions,
  });

  final String id;
  final String title;
  final List<HomeQuickAction> actions;
}

/// The single "continue where you left off" suggestion card on the home
/// screen.
final class HomeNextAction {
  const HomeNextAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.routePath,
    required this.ctaLabel,
    required this.accentKey,
    required this.stateLabel,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String routePath;
  final String ctaLabel;
  final String accentKey;
  final String stateLabel;
}

/// A recently-used product entry in the home screen's recent products row.
final class HomeRecentProduct {
  const HomeRecentProduct({
    required this.id,
    required this.icon,
    required this.label,
    required this.contextLabel,
    required this.routePath,
    required this.accentKey,
    required this.stateLabel,
  });

  final String id;
  final String icon;
  final String label;
  final String contextLabel;
  final String routePath;
  final String accentKey;
  final String stateLabel;
}

/// A market pair row (symbol, price, 24h change) shown in the home screen's
/// market watchlist.
final class HomeCryptoPair {
  const HomeCryptoPair({
    required this.id,
    required this.symbol,
    required this.baseAsset,
    required this.price,
    required this.change24h,
    required this.volume24h,
    required this.sparkline,
    required this.isFavorite,
  });

  final String id;
  final String symbol;
  final String baseAsset;
  final double price;
  final double change24h;
  final double volume24h;
  final List<double> sparkline;
  final bool isFavorite;
}

/// Data contract for the home screen: balances, announcements, quick
/// actions, and watchlist.
final class HomeSnapshot {
  const HomeSnapshot({
    required this.totalBalance,
    required this.totalBtc,
    required this.spotBalance,
    required this.earnBalance,
    required this.fundingBalance,
    required this.dailyPnl,
    required this.dailyPct,
    required this.portfolioTrend7d,
    required this.notifications,
    required this.announcements,
    required this.quickActions,
    this.productGroups = const [],
    this.nextAction,
    required this.recentProducts,
    required this.pairs,
  });

  final double totalBalance;
  final double totalBtc;
  final double spotBalance;
  final double earnBalance;
  final double fundingBalance;
  final double dailyPnl;
  final double dailyPct;
  final List<double> portfolioTrend7d;
  final int notifications;
  final List<HomeAnnouncement> announcements;

  /// Compact «Hành động nhanh» strip (+ sheet overflow). No Support/Referral.
  final List<HomeQuickAction> quickActions;

  /// Grouped product strips (Giao dịch / Pro / Sinh lời / Khám phá).
  final List<HomeProductGroup> productGroups;
  final HomeNextAction? nextAction;
  final List<HomeRecentProduct> recentProducts;
  final List<HomeCryptoPair> pairs;
}
