import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Web-owned composition for the Home surface.
///
/// This page intentionally owns the Web information hierarchy. It shares only
/// design primitives and product contracts with Phone and Tablet.
class HomeWebPage extends StatelessWidget {
  const HomeWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trang chủ trên Web',
      semanticIdentifier: 'SC-007-WEB',
      child: Column(
        children: [
          const VitHeader(
            title: 'Trang chủ',
            subtitle: 'Tổng quan tài khoản · thị trường · tác vụ ưu tiên',
            showBack: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.relaxed,
                    padding: VitContentPadding.relaxed,
                    density: VitDensity.relaxed,
                    children: [
                      VitCard(
                        variant: VitCardVariant.hero,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.dashboard_outlined,
                              color: AppColors.primary,
                              size: AppSpacing.iconLg,
                            ),
                            const SizedBox(width: AppSpacing.x4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tổng quan hôm nay',
                                    style: AppTextStyles.baseMedium,
                                  ),
                                  const SizedBox(
                                    height:
                                        AppSpacing.pageRhythmStandardInnerGap,
                                  ),
                                  Text(
                                    'Theo dõi tài sản, biến động thị trường và các thao tác cần ưu tiên trong một không gian Web rộng rãi.',
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.text2,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VitPageSection(
                        label: 'Tài khoản',
                        headerIcon: Icons.account_balance_wallet_outlined,
                        headerIconColor: AppColors.primary,
                        headerVariant: VitSectionHeaderVariant.plain,
                        accentColor: AppColors.primary,
                        rhythm: VitPageRhythm.relaxed,
                        children: [
                          VitCard(
                            variant: VitCardVariant.inner,
                            child: Wrap(
                              spacing: AppSpacing.x7,
                              runSpacing: AppSpacing.x4,
                              children: [
                                SizedBox(
                                  width: 260,
                                  child: VitInfoRow(
                                    label: 'Tổng tài sản ước tính',
                                    value: 'Đang cập nhật',
                                    density: VitDensity.relaxed,
                                  ),
                                ),
                                SizedBox(
                                  width: 260,
                                  child: VitInfoRow(
                                    label: 'Biến động hôm nay',
                                    value: 'Theo dữ liệu thị trường',
                                    density: VitDensity.relaxed,
                                  ),
                                ),
                                SizedBox(
                                  width: 260,
                                  child: VitInfoRow(
                                    label: 'Trạng thái bảo mật',
                                    value: 'Đang được bảo vệ',
                                    valueColor: AppColors.buy,
                                    density: VitDensity.relaxed,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const VitPageSection(
                        label: 'Tác vụ ưu tiên',
                        headerIcon: Icons.bolt_outlined,
                        headerIconColor: AppColors.caution,
                        headerVariant: VitSectionHeaderVariant.plain,
                        accentColor: AppColors.caution,
                        rhythm: VitPageRhythm.relaxed,
                        children: [
                          Wrap(
                            spacing: AppSpacing.x4,
                            runSpacing: AppSpacing.x4,
                            children: [
                              _HomeWebActionCard(
                                icon: Icons.candlestick_chart_outlined,
                                title: 'Theo dõi thị trường',
                                subtitle: 'Giá, xu hướng và cảnh báo',
                              ),
                              _HomeWebActionCard(
                                icon: Icons.account_balance_wallet_outlined,
                                title: 'Quản lý ví',
                                subtitle: 'Tài sản, nạp và rút',
                              ),
                              _HomeWebActionCard(
                                icon: Icons.security_outlined,
                                title: 'Kiểm tra bảo mật',
                                subtitle: '2FA, thiết bị và hoạt động',
                              ),
                            ],
                          ),
                        ],
                      ),
                      const VitCard(
                        variant: VitCardVariant.ghost,
                        child: Text(
                          'Các thao tác tài chính sẽ hiển thị phí, hạn mức, rủi ro và bước xác nhận trước khi thực thi.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeWebActionCard extends StatelessWidget {
  const _HomeWebActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: VitCard(
        variant: VitCardVariant.inner,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.baseMedium),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
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
