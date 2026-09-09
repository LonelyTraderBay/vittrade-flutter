import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/enterprise_states_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/referral_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/support_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'tablet_gd6_modules.dart';
part 'tablet_gd6_dev.dart';

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
    final snapshotAsync = ref.watch(supportHubSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-314',
        semanticLabel: 'Trung tâm hỗ trợ',
        title: 'Hỗ trợ VitTrade',
        subtitle: 'Kênh hỗ trợ · Yêu cầu',
        contentKey: SupportHubTabletPage.contentKey,
        backFallback: AppRoutePaths.profile,
        children: [_g6Body('Không tải được trung tâm hỗ trợ.')],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-314',
        semanticLabel: 'Trung tâm hỗ trợ',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: SupportHubTabletPage.contentKey,
        backFallback: AppRoutePaths.profile,
        children: [
          _g6Section(
            title: 'Kênh hỗ trợ',
            rows: [
              // Email/hotline là dữ liệu liên lạc chính — VitInfoRow value
              // text1 đậm thay bullet text2 nhạt (phát hiện từ ảnh nghiệm
              // thu: hotline gần không đọc được).
              VitInfoRow(
                label: 'Email',
                value: snapshot.email,
                density: VitDensity.compact,
              ),
              VitInfoRow(
                label: 'Hotline',
                value: snapshot.hotline,
                density: VitDensity.compact,
                showDivider: false,
              ),
            ],
          ),

          _g6Section(
            title: 'Yêu cầu gần đây',
            rows: [
              for (final ticket in snapshot.tickets.take(6))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${ticket.subject} · ${ticket.category.viLabel}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${ticket.status.viLabel} · ${ticket.priority.viLabel}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _g6Section(
            title: 'Khám phá',
            rows: [
              Wrap(
                spacing: TabletSpacingTokens.x2,
                runSpacing: TabletSpacingTokens.x2,
                children: [
                  for (final (label, path) in [
                    ('Trung tâm trợ giúp', AppRoutePaths.supportHelp),
                    ('Thông báo vận hành', AppRoutePaths.supportAnnouncements),
                  ])
                    VitFilterChip(
                      label: label,
                      active: false,
                      color: AppColors.primary,
                      onTap: () => context.go(path),
                    ),
                ],
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
    final snapshotAsync = ref.watch(helpCenterSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-315',
        semanticLabel: 'Trung tâm trợ giúp',
        title: 'Trợ giúp',
        subtitle: 'Hướng dẫn · Giải đáp',
        contentKey: SupportHelpTabletPage.contentKey,
        backFallback: AppRoutePaths.support,
        children: [_g6Body('Không tải được trung tâm trợ giúp.')],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-315',
        semanticLabel: 'Trung tâm trợ giúp',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: SupportHelpTabletPage.contentKey,
        backFallback: AppRoutePaths.support,
        children: [
          _g6Section(
            title: snapshot.heroTitle,
            rows: [_g6Body(snapshot.heroBody)],
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
    final snapshotAsync = ref.watch(announcementsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-316',
        semanticLabel: 'Thông báo vận hành',
        title: 'Thông báo',
        subtitle: 'Bảo trì · Cập nhật',
        contentKey: SupportAnnouncementsTabletPage.contentKey,
        backFallback: AppRoutePaths.support,
        children: [_g6Body('Không tải được thông báo vận hành.')],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-316',
        semanticLabel: 'Thông báo vận hành',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: SupportAnnouncementsTabletPage.contentKey,
        backFallback: AppRoutePaths.support,
        children: [
          _g6Section(
            title: 'Thông báo',
            rows: [
              for (final announcement in snapshot.announcements.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${announcement.title} · ${announcement.publishedDate}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        announcement.type.viLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
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
    final snapshotAsync = ref.watch(adminHomeSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-180',
        semanticLabel: 'Quản trị',
        title: 'Quản trị',
        subtitle: 'Giám sát hệ thống',
        contentKey: AdminHomeTabletPage.contentKey,
        backFallback: AppRoutePaths.home,
        children: [_g6Body('Không tải được bảng quản trị.')],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-180',
        semanticLabel: 'Quản trị',
        title: 'Quản trị',
        subtitle: 'Giám sát hệ thống',
        contentKey: AdminHomeTabletPage.contentKey,
        backFallback: AppRoutePaths.home,
        children: [
          _g6Section(
            title: 'Chỉ số nhanh',
            rows: [
              for (final stat in snapshot.quickStats.take(6))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          stat.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      Text(
                        '${stat.value} · ${stat.deltaLabel}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _g6Section(
            title: 'Bảng điều khiển',
            rows: [
              for (final link in snapshot.dashboards)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Material(
                    color: AppColors.transparent,
                    child: InkWell(
                      onTap: () => context.go(link.route),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${link.title} — ${link.description}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                              ),
                            ),
                          ),
                          Text(
                            link.stat,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: TabletSpacingTokens.x2),
              Wrap(
                spacing: TabletSpacingTokens.x2,
                runSpacing: TabletSpacingTokens.x2,
                children: [
                  for (final (label, path) in [
                    ('Phân tích', AppRoutePaths.adminAnalytics),
                    ('Thí nghiệm A/B', AppRoutePaths.adminAbtests),
                    ('Phễu chuyển đổi', AppRoutePaths.adminFunnels),
                    ('Cài đặt', AppRoutePaths.adminSettings),
                  ])
                    VitFilterChip(
                      label: label,
                      active: false,
                      color: AppColors.primary,
                      onTap: () => context.go(path),
                    ),
                ],
              ),
            ],
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
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-181',
      semanticLabel: 'Phân tích quản trị',
      title: 'Phân tích',
      subtitle: 'Chỉ số nền tảng',
      contentKey: AdminAnalyticsTabletPage.contentKey,
      backFallback: AppRoutePaths.admin,
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
    );
  }
}

/// SC-182: Thí nghiệm A/B.
class AdminAbtestsTabletPage extends ConsumerWidget {
  const AdminAbtestsTabletPage({super.key});

  static const contentKey = Key('sc182_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-182',
      semanticLabel: 'Thí nghiệm A/B',
      title: 'Thí nghiệm A/B',
      subtitle: 'Nhóm · Kết quả',
      contentKey: AdminAbtestsTabletPage.contentKey,
      backFallback: AppRoutePaths.admin,
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
    );
  }
}

/// SC-183: Phễu chuyển đổi.
class AdminFunnelsTabletPage extends ConsumerWidget {
  const AdminFunnelsTabletPage({super.key});

  static const contentKey = Key('sc183_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-183',
      semanticLabel: 'Phễu chuyển đổi',
      title: 'Phễu chuyển đổi',
      subtitle: 'Các bước · Tỷ lệ',
      contentKey: AdminFunnelsTabletPage.contentKey,
      backFallback: AppRoutePaths.admin,
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
    );
  }
}

/// SC-410: Cài đặt quản trị.
class AdminSettingsTabletPage extends ConsumerWidget {
  const AdminSettingsTabletPage({super.key});

  static const contentKey = Key('sc410_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return VitTabletSectionFrame(
      semanticIdentifier: 'SC-410',
      semanticLabel: 'Cài đặt quản trị',
      title: 'Cài đặt quản trị',
      subtitle: 'Quyền · Cấu hình',
      contentKey: AdminSettingsTabletPage.contentKey,
      backFallback: AppRoutePaths.admin,
      children: [
        _g6Section(
          title: 'Lưu ý thay đổi',
          rows: _g6Bullets([
            'Mọi thay đổi cấu hình đều cần xác nhận trước khi lưu',
            'Nhật ký thay đổi được ghi vết đầy đủ',
          ]),
        ),
      ],
    );
  }
}
