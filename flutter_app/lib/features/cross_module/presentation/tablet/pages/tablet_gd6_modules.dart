part of 'cross_module_tablet_pages.dart';

/// SC-320: Trạng thái doanh nghiệp.
class EnterpriseStatesTabletPage extends ConsumerWidget {
  const EnterpriseStatesTabletPage({super.key});

  static const contentKey = Key('sc320_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(enterpriseStatesSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _g6Frame(
        context: context,
        semanticIdentifier: 'SC-320',
        semanticLabel: 'Trạng thái doanh nghiệp',
        title: 'Trạng thái doanh nghiệp',
        subtitle: 'Cổng vận hành',
        contentKey: EnterpriseStatesTabletPage.contentKey,
        child: _g6Body('Không tải được trạng thái doanh nghiệp.'),
      ),
      data: (snapshot) => _g6Frame(
        context: context,
        semanticIdentifier: 'SC-320',
        semanticLabel: 'Trạng thái doanh nghiệp',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: EnterpriseStatesTabletPage.contentKey,
        child: _g6Section(
          title: 'Các cổng trạng thái',
          rows: [
            for (final tab in snapshot.tabs)
              Padding(
                padding: TabletSpacingTokens.tableCellPaddingV,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        tab.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    Text(
                      tab.section.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// SC-321: Danh mục hợp nhất.
class UnifiedPortfolioTabletPage extends ConsumerWidget {
  const UnifiedPortfolioTabletPage({super.key});

  static const contentKey = Key('sc321_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-321',
      semanticLabel: 'Danh mục hợp nhất',
      title: 'Danh mục hợp nhất',
      subtitle: 'Spot · Kiếm · Dự đoán',
      contentKey: UnifiedPortfolioTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Phạm vi hợp nhất',
            rows: _g6Bullets([
              'Số dư giao dịch spot theo tài sản',
              'Vị thế kiếm (staking, tiết kiệm) đang chạy',
              'Vị thế thị trường dự đoán và phần thưởng',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-322: Phân tích liên mô-đun.
class CrossModuleAnalyticsTabletPage extends ConsumerWidget {
  const CrossModuleAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc322_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(crossModuleAnalyticsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _g6Frame(
        context: context,
        semanticIdentifier: 'SC-322',
        semanticLabel: 'Phân tích liên mô-đun',
        title: 'Phân tích liên mô-đun',
        subtitle: 'ROI · Tỷ lệ thắng',
        contentKey: CrossModuleAnalyticsTabletPage.contentKey,
        child: _g6Body('Không tải được phân tích liên mô-đun.'),
      ),
      data: (snapshot) => _g6Frame(
        context: context,
        semanticIdentifier: 'SC-322',
        semanticLabel: 'Phân tích liên mô-đun',
        title: snapshot.title,
        subtitle: 'ROI ${snapshot.averageRoi.toStringAsFixed(1)}%',
        contentKey: CrossModuleAnalyticsTabletPage.contentKey,
        child: _g6Section(
          title: 'Chỉ số theo mô-đun',
          rows: [
            for (final module in snapshot.modules)
              Padding(
                padding: TabletSpacingTokens.tableCellPaddingV,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        module.name,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                        ),
                      ),
                    ),
                    Text(
                      'ROI ${module.roi.toStringAsFixed(1)}% · thắng ${module.winRate.toStringAsFixed(1)}% · ${module.totalTrades} lệnh',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// SC-323: Trung tâm cảnh báo thông minh.
class SmartAlertCenterTabletPage extends ConsumerWidget {
  const SmartAlertCenterTabletPage({super.key});

  static const contentKey = Key('sc323_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-323',
      semanticLabel: 'Cảnh báo thông minh',
      title: 'Cảnh báo thông minh',
      subtitle: 'Kích hoạt · Điều kiện',
      contentKey: SmartAlertCenterTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Loại cảnh báo',
            rows: _g6Bullets([
              'Giá vượt ngưỡng theo tài sản theo dõi',
              'Biến động tỷ lệ phần trăm bất thường trong ngày',
              'Sự kiện lịch quan trọng sắp diễn ra',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-324: Trung tâm báo cáo thuế.
class TaxReportCenterTabletPage extends ConsumerWidget {
  const TaxReportCenterTabletPage({super.key});

  static const contentKey = Key('sc324_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-324',
      semanticLabel: 'Trung tâm báo cáo thuế',
      title: 'Báo cáo thuế',
      subtitle: 'Tổng hợp · Xuất',
      contentKey: TaxReportCenterTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Nội dung báo cáo',
            rows: _g6Bullets([
              'Thu nhập staking và tiết kiệm theo năm',
              'Lãi vốn từ giao dịch spot',
              'Xuất theo định dạng phục vụ kê khai',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-325: Thông báo hợp nhất.
class NotificationsHubTabletPage extends ConsumerWidget {
  const NotificationsHubTabletPage({super.key});

  static const contentKey = Key('sc325_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(notificationsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _g6Frame(
        context: context,
        semanticIdentifier: 'SC-325',
        semanticLabel: 'Thông báo hợp nhất',
        title: 'Thông báo',
        subtitle: 'Toàn nền tảng',
        contentKey: NotificationsHubTabletPage.contentKey,
        child: _g6Body('Không tải được thông báo.'),
      ),
      data: (snapshot) => _g6Frame(
        context: context,
        semanticIdentifier: 'SC-325',
        semanticLabel: 'Thông báo hợp nhất',
        title: snapshot.title,
        subtitle: '${snapshot.notifications.length} thông báo',
        contentKey: NotificationsHubTabletPage.contentKey,
        child: _g6Section(
          title: 'Thông báo',
          rows: [
            for (final notification in snapshot.notifications.take(10))
              Padding(
                padding: TabletSpacingTokens.tableCellPaddingV,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${notification.title} · ${notification.time}',
                        style: AppTextStyles.caption.copyWith(
                          color: notification.isRead
                              ? AppColors.text2
                              : AppColors.text1,
                          fontWeight: notification.isRead
                              ? AppTextStyles.normal
                              : AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      notification.type.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// SC-326: Tìm kiếm hợp nhất.
class UnifiedSearchTabletPage extends ConsumerWidget {
  const UnifiedSearchTabletPage({super.key});

  static const contentKey = Key('sc326_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-326',
      semanticLabel: 'Tìm kiếm hợp nhất',
      title: 'Tìm kiếm',
      subtitle: 'Cặp · Token · Chủ đề',
      contentKey: UnifiedSearchTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Phạm vi tìm kiếm',
            rows: _g6Bullets([
              'Cặp giao dịch và token theo mã/tên',
              'Chủ đề thị trường và sự kiện',
              'Trang tính năng trong ứng dụng',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-327: Hub chủ đề.
class TopicHubTabletPage extends ConsumerWidget {
  const TopicHubTabletPage({super.key});

  static const contentKey = Key('sc327_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-327',
      semanticLabel: 'Hub chủ đề',
      title: 'Chủ đề',
      subtitle: 'Khám phá theo mối quan tâm',
      contentKey: TopicHubTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Chủ đề nổi bật',
            rows: _g6Bullets([
              'Tiền điện tử — tin tức và phân tích theo tài sản',
              'Khối lượng và xu hướng thị trường',
              'Giáo dục giao dịch cho người mới',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-328: Chủ đề tiền điện tử.
class TopicCryptoTabletPage extends ConsumerWidget {
  const TopicCryptoTabletPage({super.key});

  static const contentKey = Key('sc328_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-328',
      semanticLabel: 'Chủ đề tiền điện tử',
      title: 'Chủ đề: Tiền điện tử',
      subtitle: 'Bài viết · Tài sản liên quan',
      contentKey: TopicCryptoTabletPage.contentKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Nội dung',
            rows: _g6Bullets([
              'Tin nhanh theo tài sản và chuỗi',
              'Phân tích kỹ thuật tổng hợp từ mô-đun markets',
              'Liên kết nhanh tới chi tiết token',
            ]),
          ),
        ],
      ),
    );
  }
}
