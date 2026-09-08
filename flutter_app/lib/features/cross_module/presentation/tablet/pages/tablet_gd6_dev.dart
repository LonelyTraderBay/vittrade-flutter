part of 'cross_module_tablet_pages.dart';

/// SC-329: Giới thiệu referral.
class ReferralHomeTabletPage extends ConsumerWidget {
  const ReferralHomeTabletPage({super.key});

  static const contentKey = Key('ref_home_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-329',
      semanticLabel: 'Giới thiệu bạn bè',
      title: 'Giới thiệu bạn bè',
      subtitle: 'Mã · Thưởng',
      contentKey: ReferralHomeTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Cách hoạt động',
            rows: _g6Bullets([
              'Chia sẻ mã giới thiệu cá nhân',
              'Bạn bè đăng ký và hoàn tất xác minh',
              'Nhận thưởng khi điều kiện khối lượng đạt mục tiêu',
            ]),
          ),
        ],
      ),
    );
  }
}

/// Lịch sử giới thiệu.
class ReferralHistoryTabletPage extends ConsumerWidget {
  const ReferralHistoryTabletPage({super.key});

  static const contentKey = Key('ref_history_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-330',
      semanticLabel: 'Lịch sử giới thiệu',
      title: 'Lịch sử giới thiệu',
      subtitle: 'Trạng thái · Thưởng',
      contentKey: ReferralHistoryTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Theo dõi',
            rows: _g6Bullets([
              'Trạng thái từng lượt giới thiệu: chờ, hoàn tất',
              'Thưởng ghi nhận theo mốc khối lượng của người được mời',
            ]),
          ),
        ],
      ),
    );
  }
}

/// Phần thưởng giới thiệu.
class ReferralRewardsTabletPage extends ConsumerWidget {
  const ReferralRewardsTabletPage({super.key});

  static const contentKey = Key('ref_rewards_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-331',
      semanticLabel: 'Phần thưởng giới thiệu',
      title: 'Phần thưởng',
      subtitle: 'Điều kiện nhận',
      contentKey: ReferralRewardsTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Điều kiện',
            rows: _g6Bullets([
              'Người được mời hoàn tất xác minh danh tính',
              'Khối lượng giao dịch đạt mốc quy định',
              'Thưởng tự ghi vào số dư khả dụng',
            ]),
          ),
        ],
      ),
    );
  }
}

/// Quy tắc chương trình.
class ReferralRulesTabletPage extends ConsumerWidget {
  const ReferralRulesTabletPage({super.key});

  static const contentKey = Key('ref_rules_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-332',
      semanticLabel: 'Quy tắc giới thiệu',
      title: 'Quy tắc chương trình',
      subtitle: 'Điều khoản áp dụng',
      contentKey: ReferralRulesTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Nguyên tắc',
            rows: _g6Bullets([
              'Một tài khoản chỉ tham gia với một mã giới thiệu',
              'Cấm tự giới thiệu hoặc gian lận địa chỉ',
              'Nền tảng giữ quyền hủy thưởng khi phát hiện lạm dụng',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-407: Kiểm tra route (dev).
class RouteCheckerTabletPage extends ConsumerWidget {
  const RouteCheckerTabletPage({super.key});

  static const contentKey = Key('route_checker_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-407',
      semanticLabel: 'Kiểm tra route',
      title: 'Kiểm tra route',
      subtitle: 'Công cụ nội bộ',
      contentKey: RouteCheckerTabletPage.contentKey,
      backFallback: AppRoutePaths.devShowcase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Chức năng',
            rows: _g6Bullets([
              'Nhập một đường dẫn để xem route khớp trong bảng route',
              'Hiển thị tham số bắt buộc và trang đích',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-408: Giám sát hiệu năng (dev).
class PerformanceMonitorTabletPage extends ConsumerWidget {
  const PerformanceMonitorTabletPage({super.key});

  static const contentKey = Key('perf_monitor_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-408',
      semanticLabel: 'Giám sát hiệu năng',
      title: 'Giám sát hiệu năng',
      subtitle: 'FPS · Bộ nhớ',
      contentKey: PerformanceMonitorTabletPage.contentKey,
      backFallback: AppRoutePaths.devShowcase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Chỉ số trực tiếp',
            rows: _g6Bullets([
              'Tần suất khung hình thời gian thực',
              'Sử dụng bộ nhớ của phiên hiện tại',
              'Thời gian dựng khung trung bình và p99',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-409: Showcase màn hình (dev).
class MissingScreensShowcaseTabletPage extends ConsumerWidget {
  const MissingScreensShowcaseTabletPage({super.key});

  static const contentKey = Key('showcase_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-409',
      semanticLabel: 'Showcase màn hình',
      title: 'Showcase màn hình',
      subtitle: 'Danh mục demo',
      contentKey: MissingScreensShowcaseTabletPage.contentKey,
      backFallback: AppRoutePaths.home,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Nhóm demo',
            rows: _g6Bullets([
              'Màn hình đang phát triển — mở trực tiếp để xem tiến độ',
              'Bố cục thay thế cho cùng một trang',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-412: Hệ thống thiết kế (dev).
class DesignSystemTabletPage extends ConsumerWidget {
  const DesignSystemTabletPage({super.key});

  static const contentKey = Key('design_system_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-412',
      semanticLabel: 'Hệ thống thiết kế',
      title: 'Hệ thống thiết kế',
      subtitle: 'Token · Thành phần',
      contentKey: DesignSystemTabletPage.contentKey,
      backFallback: AppRoutePaths.home,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Tham chiếu',
            rows: _g6Bullets([
              'Thang màu và trạng thái ngữ nghĩa',
              'Thang khoảng cách và bán kính bo góc',
              'Thư viện Vit* widget dùng chung toàn ứng dụng',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-413: Demo tổng quan DCA (dev).
class DevDcaOverviewTabletPage extends ConsumerWidget {
  const DevDcaOverviewTabletPage({super.key});

  static const contentKey = Key('dev_dca_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-413',
      semanticLabel: 'Demo tổng quan DCA',
      title: 'Demo DCA overview',
      subtitle: 'Trang mẫu cho dev',
      contentKey: DevDcaOverviewTabletPage.contentKey,
      backFallback: AppRoutePaths.devShowcase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Nội dung demo',
            rows: _g6Bullets([
              'Bố cục tổng quan chiến lược DCA ở khổ tablet',
              'Dữ liệu hiển thị là dữ liệu demo nội bộ',
            ]),
          ),
        ],
      ),
    );
  }
}
