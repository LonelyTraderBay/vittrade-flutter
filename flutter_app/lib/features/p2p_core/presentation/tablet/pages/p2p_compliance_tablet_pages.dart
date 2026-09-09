import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'p2p_compliance_tablet_pages_sections.dart';

Widget _cmpError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _cmpSection({required String title, required List<Widget> rows}) {
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

List<Widget> _cmpRows(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

/// SC-266: Hạn mức giao dịch.
class P2PTransactionLimitsTabletPage extends ConsumerWidget {
  const P2PTransactionLimitsTabletPage({super.key});

  static const contentKey = Key('sc266_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pTransactionLimitsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-266',
        semanticLabel: 'Hạn mức giao dịch P2P',
        title: 'Hạn mức giao dịch',
        subtitle: 'Hạng · Hạn mức',
        contentKey: P2PTransactionLimitsTabletPage.contentKey,
        children: [
          _cmpError(
            'Không tải được hạn mức',
            () => ref.invalidate(p2pTransactionLimitsProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-266',
        semanticLabel: 'Hạn mức giao dịch P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PTransactionLimitsTabletPage.contentKey,
        children: [
          _cmpSection(
            title:
                'Hạng hiện tại: ${snapshot.currentTier.name} (${snapshot.currentTier.statusLabel})',
            rows: _cmpRows([
              ('Mua/ngày', formatP2PVnd(snapshot.currentTier.dailyBuy)),
              ('Bán/ngày', formatP2PVnd(snapshot.currentTier.dailySell)),
              ('Tổng/tuần', formatP2PVnd(snapshot.currentTier.weeklyTotal)),
              ('Tổng/tháng', formatP2PVnd(snapshot.currentTier.monthlyTotal)),
              (
                'Mỗi giao dịch',
                formatP2PVnd(snapshot.currentTier.perTransaction),
              ),
            ]),
          ),

          _cmpSection(
            title:
                'Hạng kế tiếp: ${snapshot.nextTier.name} — yêu cầu ${snapshot.nextTier.requirements.join(", ")}',
            rows: _cmpRows([
              ('Mua/ngày', formatP2PVnd(snapshot.nextTier.dailyBuy)),
              ('Bán/ngày', formatP2PVnd(snapshot.nextTier.dailySell)),
            ]),
          ),

          _cmpSection(
            title: 'Sử dụng hạn mức',
            rows: [
              for (final usage in snapshot.usageItems)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: VitProgressBar(
                    progress: usage.max == 0 ? 0 : usage.current / usage.max,
                    label: usage.label,
                    trailingLabel:
                        '${formatP2PVnd(usage.current)} / ${formatP2PVnd(usage.max)}',
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),

          _cmpSection(
            title: 'Chi tiết',
            rows: _cmpRows([
              for (final detail in snapshot.detailItems)
                (detail.label, formatP2PVnd(detail.value)),
            ]),
          ),

          _cmpSection(
            title: 'Thông tin',
            rows: [
              ...[
                for (final bullet in snapshot.infoBullets)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      '• $bullet',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.3,
                      ),
                    ),
                  ),
              ],
            ],
          ),

          const SizedBox(height: TabletSpacingTokens.x4),

          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              VitCtaButton(
                fullWidth: false,
                variant: VitCtaButtonVariant.secondary,
                onPressed: () => context.push(snapshot.trackerRoute),
                child: const Text('Theo dõi hạn mức'),
              ),
              VitCtaButton(
                fullWidth: false,
                variant: VitCtaButtonVariant.ghost,
                onPressed: () => context.push(snapshot.kycRequirementsRoute),
                child: const Text('Nâng hạng KYC'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-265: Theo dõi hạn mức.
class P2PLimitTrackerTabletPage extends ConsumerWidget {
  const P2PLimitTrackerTabletPage({super.key});

  static const contentKey = Key('sc265_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pLimitTrackerProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-265',
        semanticLabel: 'Theo dõi hạn mức P2P',
        title: 'Theo dõi hạn mức',
        subtitle: 'Đã dùng · Còn lại',
        contentKey: P2PLimitTrackerTabletPage.contentKey,
        children: [
          _cmpError(
            'Không tải được theo dõi hạn mức',
            () => ref.invalidate(p2pLimitTrackerProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-265',
        semanticLabel: 'Theo dõi hạn mức P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PLimitTrackerTabletPage.contentKey,
        children: [
          for (final usage in snapshot.usages)
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${usage.label} (${usage.period})',
                      style: AppTextStyles.control.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x2),
                    VitProgressBar(
                      progress: usage.limit == 0 ? 0 : usage.used / usage.limit,
                      label: 'Đã dùng',
                      trailingLabel:
                          '${formatP2PVnd(usage.used)} / ${formatP2PVnd(usage.limit)}',
                      color: usage.percentage >= 90
                          ? AppColors.sell
                          : usage.percentage >= 70
                          ? AppColors.caution
                          : AppColors.buy,
                    ),
                  ],
                ),
              ),
            ),

          _cmpSection(
            title: 'Chi tiết theo ngày',
            rows: [
              for (final day in snapshot.breakdown.take(10))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          day.date,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      Text(
                        'Mua ${formatP2PVnd(day.buy)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.buy,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(width: TabletSpacingTokens.x3),
                      Text(
                        'Bán ${formatP2PVnd(day.sell)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.sell,
                          fontFeatures: AppTextStyles.tabularFigures,
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

/// SC-267: Tổng quan tuân thủ.
class P2PComplianceOverviewTabletPage extends ConsumerWidget {
  const P2PComplianceOverviewTabletPage({super.key});

  static const contentKey = Key('sc267_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pComplianceOverviewProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-267',
        semanticLabel: 'Tổng quan tuân thủ P2P',
        title: 'Tuân thủ',
        subtitle: 'Trạng thái',
        contentKey: P2PComplianceOverviewTabletPage.contentKey,
        children: [
          _cmpError(
            'Không tải được tuân thủ',
            () => ref.invalidate(p2pComplianceOverviewProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-267',
        semanticLabel: 'Tổng quan tuân thủ P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PComplianceOverviewTabletPage.contentKey,
        children: [
          VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.heroTitle,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  snapshot.heroSubtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          for (final item in snapshot.items)
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: InkWell(
                  onTap: () => context.push(item.route),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.label,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              item.value,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VitStatusPill(
                        label: item.status,
                        status:
                            item.status.contains('Đạt') ||
                                item.status.contains('Hoàn tất')
                            ? VitStatusPillStatus.success
                            : VitStatusPillStatus.warning,
                        size: VitStatusPillSize.sm,
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
            ),
        ],
      ),
    );
  }
}

/// SC-268: AML screening.
