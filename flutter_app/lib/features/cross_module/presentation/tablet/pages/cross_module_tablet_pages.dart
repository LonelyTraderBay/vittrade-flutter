import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'tablet_gd6_modules.dart';
part 'tablet_gd6_dev.dart';

Widget _g6Frame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required Widget child,
  Key? contentKey,
  String backFallback = AppRoutePaths.home,
}) {
  final showBack = context.canPop();
  return VitPageLayout(
    variant: VitPageVariant.flush,
    semanticLabel: semanticLabel,
    semanticIdentifier: semanticIdentifier,
    child: Column(
      children: [
        VitHeader(
          title: title,
          subtitle: subtitle,
          showBack: showBack,
          onBack: showBack
              ? () => goBackOrFallback(
                  context,
                  fallbackPath: backFallback,
                  mode: BackNavigationMode.historyThenFallback,
                )
              : null,
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: SingleChildScrollView(
                key: contentKey,
                padding: const EdgeInsets.fromLTRB(
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x4,
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x6,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _g6Section({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _g6Bullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

Widget _g6Body(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

/// SC-307b: Trung tâm hỗ trợ.
class SupportHubTabletPage extends ConsumerWidget {
  const SupportHubTabletPage({super.key});

  static const contentKey = Key('support_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-314',
      semanticLabel: 'Trung tâm hỗ trợ',
      title: 'Hỗ trợ VitTrade',
      subtitle: 'Kênh hỗ trợ · Yêu cầu',
      contentKey: SupportHubTabletPage.contentKey,
      backFallback: AppRoutePaths.profile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Kênh hỗ trợ',
            rows: _g6Bullets([
              'Trò chuyện trực tiếp với bộ phận chăm sóc',
              'Gửi yêu cầu và theo dõi trạng thái xử lý',
              'Câu hỏi thường gặp theo chủ đề',
              'Thông báo vận hành và bảo trì hệ thống',
            ]),
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          _g6Section(
            title: 'Cam kết phục vụ',
            rows: [
              _g6Body(
                'Mọi yêu cầu đều được ghi nhận với mã theo dõi; thời hạn phản hồi '
                'đầu tiên được hiển thị ngay khi gửi.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Trung tâm trợ giúp.
class SupportHelpTabletPage extends ConsumerWidget {
  const SupportHelpTabletPage({super.key});

  static const contentKey = Key('support_help_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-315',
      semanticLabel: 'Trung tâm trợ giúp',
      title: 'Trợ giúp',
      subtitle: 'Hướng dẫn · Giải đáp',
      contentKey: SupportHelpTabletPage.contentKey,
      backFallback: AppRoutePaths.support,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Chủ đề phổ biến',
            rows: _g6Bullets([
              'Xác minh danh tính và bảo mật tài khoản',
              'Nạp và rút tiền — quy trình, thời gian, phí',
              'Giao dịch và sổ lệnh: cách đọc, cách hủy',
              'Sự cố đăng nhập và xác thực hai lớp',
            ]),
          ),
        ],
      ),
    );
  }
}

/// Thông báo vận hành.
class SupportAnnouncementsTabletPage extends ConsumerWidget {
  const SupportAnnouncementsTabletPage({super.key});

  static const contentKey = Key('support_ann_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-316',
      semanticLabel: 'Thông báo vận hành',
      title: 'Thông báo',
      subtitle: 'Bảo trì · Cập nhật',
      contentKey: SupportAnnouncementsTabletPage.contentKey,
      backFallback: AppRoutePaths.support,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Theo dõi',
            rows: _g6Bullets([
              'Bảo trì định kỳ được thông báo trước ít nhất 48 giờ',
              'Cập nhật tính năng kèm ghi chú chi tiết',
              'Cảnh báo sự cố hiển thị ở mức ưu tiên cao nhất',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-180: Hub quản trị.
class AdminHomeTabletPage extends ConsumerWidget {
  const AdminHomeTabletPage({super.key});

  static const contentKey = Key('sc180_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-180',
      semanticLabel: 'Quản trị',
      title: 'Quản trị',
      subtitle: 'Giám sát hệ thống',
      contentKey: AdminHomeTabletPage.contentKey,
      backFallback: AppRoutePaths.home,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Khối chức năng',
            rows: _g6Bullets([
              'Bảng điều khiển phân tích tổng hợp',
              'Phễu chuyển đổi người dùng',
              'Thí nghiệm A/B và kết quả',
              'Cài đặt quyền và cấu hình nền tảng',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-181: Phân tích quản trị.
class AdminAnalyticsTabletPage extends ConsumerWidget {
  const AdminAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc181_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-181',
      semanticLabel: 'Phân tích quản trị',
      title: 'Phân tích',
      subtitle: 'Chỉ số nền tảng',
      contentKey: AdminAnalyticsTabletPage.contentKey,
      backFallback: AppRoutePaths.admin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Theo dõi',
            rows: _g6Bullets([
              'Người dùng hoạt động theo ngày/tuần/tháng',
              'Khối lượng giao dịch theo phân khúc',
              'Tỷ lệ giữ chân và rời bỏ',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-182: Thí nghiệm A/B.
class AdminAbtestsTabletPage extends ConsumerWidget {
  const AdminAbtestsTabletPage({super.key});

  static const contentKey = Key('sc182_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-182',
      semanticLabel: 'Thí nghiệm A/B',
      title: 'Thí nghiệm A/B',
      subtitle: 'Nhóm · Kết quả',
      contentKey: AdminAbtestsTabletPage.contentKey,
      backFallback: AppRoutePaths.admin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Quy trình',
            rows: _g6Bullets([
              'Khai báo giả thuyết và chỉ số đo lường',
              'Chia nhóm người dùng theo tỷ lệ an toàn',
              'Kết luận dựa trên ngưỡng ý nghĩa thống kê',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-183: Phễu chuyển đổi.
class AdminFunnelsTabletPage extends ConsumerWidget {
  const AdminFunnelsTabletPage({super.key});

  static const contentKey = Key('sc183_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-183',
      semanticLabel: 'Phễu chuyển đổi',
      title: 'Phễu chuyển đổi',
      subtitle: 'Các bước · Tỷ lệ',
      contentKey: AdminFunnelsTabletPage.contentKey,
      backFallback: AppRoutePaths.admin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Phễu mẫu',
            rows: _g6Bullets([
              'Đăng ký → xác minh → nạp tiền đầu tiên',
              'Xem thị trường → đặt lệnh đầu tiên',
              'Mở tài khoản → bật xác thực hai lớp',
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-410: Cài đặt quản trị.
class AdminSettingsTabletPage extends ConsumerWidget {
  const AdminSettingsTabletPage({super.key});

  static const contentKey = Key('sc410_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _g6Frame(
      context: context,
      semanticIdentifier: 'SC-410',
      semanticLabel: 'Cài đặt quản trị',
      title: 'Cài đặt quản trị',
      subtitle: 'Quyền · Cấu hình',
      contentKey: AdminSettingsTabletPage.contentKey,
      backFallback: AppRoutePaths.admin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _g6Section(
            title: 'Lưu ý thay đổi',
            rows: _g6Bullets([
              'Mọi thay đổi cấu hình đều cần xác nhận trước khi lưu',
              'Nhật ký thay đổi được ghi vết đầy đủ',
            ]),
          ),
        ],
      ),
    );
  }
}
