import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'p2p_security_tablet_pages_extra.dart';

Widget _secError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _secSection({required String title, required List<Widget> rows}) {
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

List<Widget> _secTips(List<String> tips) {
  return [
    for (final tip in tips)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.shield_outlined,
                size: TabletSpacingTokens.iconSm,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x2),
            Expanded(
              child: Text(
                tip,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

/// SC-253: Trung tâm bảo mật P2P.
class P2PSecurityCenterTabletPage extends ConsumerWidget {
  const P2PSecurityCenterTabletPage({super.key});

  static const contentKey = Key('sc253_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pSecurityCenterProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-253',
        semanticLabel: 'Trung tâm bảo mật P2P',
        title: 'Trung tâm bảo mật',
        subtitle: 'Điểm · Trạng thái',
        contentKey: P2PSecurityCenterTabletPage.contentKey,
        children: [
          _secError(
            'Không tải được trung tâm bảo mật',
            () => ref.invalidate(p2pSecurityCenterProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTwoColumnTabletDashboard(
        onRefresh: () async {
          ref.invalidate(p2pSecurityCenterProvider);
          await ref.read(p2pSecurityCenterProvider.future);
        },
        banner: VitCard(
          radius: VitCardRadius.tight,
          padding: TabletSpacingTokens.cardPaddingCompact,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${snapshot.score}/${snapshot.maxScore} · ${snapshot.scoreLabel}',
                      style: AppTextStyles.control.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      snapshot.scoreSubtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: VitProgressBar(
                  progress: snapshot.score / snapshot.maxScore,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        primaryChildren: [
          _secSection(
            title: 'Cấu hình bảo mật',
            rows: [
              for (final feature in snapshot.features)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: InkWell(
                    onTap: () => context.push(feature.route),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            feature.label,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          feature.scoreDelta >= 0
                              ? '+${feature.scoreDelta} điểm'
                              : '${feature.scoreDelta} điểm',
                          style: AppTextStyles.caption.copyWith(
                            color: feature.scoreDelta >= 0
                                ? AppColors.buy
                                : AppColors.sell,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                        const SizedBox(width: TabletSpacingTokens.x2),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: TabletSpacingTokens.iconMd,
                          color: AppColors.text3,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          _secSection(
            title: 'Sự kiện gần đây',
            rows: [
              for (final event in snapshot.recentEvents.take(6))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.label,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        event.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
        secondaryChildren: [
          _secSection(
            title: 'Hành động nhanh',
            rows: [
              for (final action in snapshot.quickActions)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: InkWell(
                    onTap: () => context.push(action.route),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            action.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: TabletSpacingTokens.iconMd,
                          color: AppColors.text3,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-254: Cài đặt 2FA.
class P2PTwoFactorSettingsTabletPage extends ConsumerWidget {
  const P2PTwoFactorSettingsTabletPage({super.key});

  static const contentKey = Key('sc254_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pTwoFactorSettingsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-254',
        semanticLabel: 'Cài đặt 2FA P2P',
        title: 'Cài đặt 2FA',
        subtitle: 'Phương thức · Ngưỡng',
        contentKey: P2PTwoFactorSettingsTabletPage.contentKey,
        children: [
          _secError(
            'Không tải được 2FA',
            () => ref.invalidate(p2pTwoFactorSettingsProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-254',
        semanticLabel: 'Cài đặt 2FA P2P',
        title: 'Cài đặt 2FA',
        subtitle: 'Phương thức · Ngưỡng giao dịch',
        contentKey: P2PTwoFactorSettingsTabletPage.contentKey,
        children: [
          _secSection(
            title: 'Phương thức xác thực',
            rows: [
              for (final method in snapshot.methods)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.label,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              method.description,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (method.isPrimary)
                        const VitStatusPill(
                          label: 'Chính',
                          status: VitStatusPillStatus.info,
                          size: VitStatusPillSize.sm,
                        )
                      else if (method.enabled)
                        const VitStatusPill(
                          label: 'Đang bật',
                          status: VitStatusPillStatus.success,
                          size: VitStatusPillSize.sm,
                        )
                      else if (method.setupRequired)
                        VitCtaButton(
                          fullWidth: false,
                          variant: VitCtaButtonVariant.secondary,
                          onPressed: () =>
                              context.push(AppRoutePaths.p2pSecurity2fa),
                          child: const Text('Thiết lập'),
                        ),
                    ],
                  ),
                ),
            ],
          ),

          _secSection(
            title: 'Ngưỡng yêu cầu 2FA',
            rows: [
              for (final threshold in snapshot.thresholds)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          threshold.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      Text(
                        threshold.valueLabel,
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

          _secSection(
            title: 'Khuyến nghị',
            rows: [
              Text(
                snapshot.recommendation,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-255: Quản lý thiết bị tin tưởng.
