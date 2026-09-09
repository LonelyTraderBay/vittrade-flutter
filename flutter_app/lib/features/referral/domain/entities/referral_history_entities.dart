part of 'referral_entities.dart';

/// Status filter applied to the referral history/friends list.
enum ReferralFriendFilter { all, activeTrader, kycDone, pendingKyc }

/// Sort order applied to the referral history/friends list.
enum ReferralHistorySort { date, commission, volume }

/// Onboarding/activity status of a [ReferralFriendDraft].
enum ReferralFriendStatus { pendingKyc, kycDone, activeTrader, inactive }

/// Data for the referral history screen: filtered/sorted [friends] plus
/// aggregate [stats].
final class ReferralHistorySnapshot {
  const ReferralHistorySnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.searchHint,
    required this.stats,
    required this.filters,
    required this.sortOptions,
    required this.friends,
    required this.filter,
    required this.sort,
    required this.query,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String searchHint;
  final ReferralStatsDraft stats;
  final List<ReferralFilterDraft> filters;
  final List<ReferralSortDraft> sortOptions;
  final List<ReferralFriendDraft> friends;
  final ReferralFriendFilter filter;
  final ReferralHistorySort sort;
  final String query;
  final String contractNotes;
  final Set<ReferralScreenState> supportedStates;
}

/// Aggregate friend counts (total/KYC-completed/active) shown on the
/// referral history screen.
final class ReferralStatsDraft {
  const ReferralStatsDraft({
    required this.totalFriends,
    required this.kycCompleted,
    required this.activeFriends,
  });

  final int totalFriends;
  final int kycCompleted;
  final int activeFriends;
}

/// One selectable [ReferralFriendFilter] entry with its label and match
/// count.
final class ReferralFilterDraft {
  const ReferralFilterDraft({
    required this.filter,
    required this.label,
    required this.count,
  });

  final ReferralFriendFilter filter;
  final String label;
  final int count;
}

/// One selectable [ReferralHistorySort] entry with its display label.
final class ReferralSortDraft {
  const ReferralSortDraft({required this.sort, required this.label});

  final ReferralHistorySort sort;
  final String label;
}

/// One referred friend entry (status, commission, volume, trade dates)
/// shown on the referral history screen.
final class ReferralFriendDraft {
  const ReferralFriendDraft({
    required this.id,
    required this.initial,
    required this.name,
    required this.joinedDate,
    required this.status,
    required this.totalCommission,
    required this.totalVolume,
    required this.firstTradeDate,
    required this.route,
  });

  final String id;
  final String initial;
  final String name;
  final String joinedDate;
  final ReferralFriendStatus status;
  final double totalCommission;
  final double totalVolume;
  final String? firstTradeDate;
  final String route;

  bool get kycCompleted => status != ReferralFriendStatus.pendingKyc;
  bool get canRemindKyc => status == ReferralFriendStatus.pendingKyc;
}

/// Nhãn tiếng Việt user-facing (B2 composition 2026-09-09).
extension ReferralFriendStatusViLabel on ReferralFriendStatus {
  String get viLabel => switch (this) {
    ReferralFriendStatus.pendingKyc => 'Chờ KYC',
    ReferralFriendStatus.kycDone => 'Đã KYC',
    ReferralFriendStatus.activeTrader => 'Đang giao dịch',
    ReferralFriendStatus.inactive => 'Không hoạt động',
  };
}

/// Nhãn tiếng Việt cho loại phần thưởng giới thiệu.
extension ReferralRewardTypeViLabel on ReferralRewardType {
  String get viLabel => switch (this) {
    ReferralRewardType.kycBonus => 'Thưởng KYC',
    ReferralRewardType.tradeCommission => 'Hoa hồng giao dịch',
  };
}

/// Nhãn tiếng Việt cho trạng thái phần thưởng giới thiệu.
extension ReferralRewardStatusViLabel on ReferralRewardStatus {
  String get viLabel => switch (this) {
    ReferralRewardStatus.completed => 'Hoàn tất',
    ReferralRewardStatus.pending => 'Đang chờ',
  };
}
