import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/rewards_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

/// Bố cục tablet của Trung tâm phần thưởng (SC-319): thẻ tổng quan điểm +
/// check-in + lọc nhiệm vụ + danh sách nhiệm vụ/bonus dạng hàng rộng.
class RewardsTabletPage extends ConsumerStatefulWidget {
  const RewardsTabletPage({super.key});

  static const contentKey = Key('sc319_tablet_content');

  @override
  ConsumerState<RewardsTabletPage> createState() => _RewardsTabletPageState();
}

class _RewardsTabletPageState extends ConsumerState<RewardsTabletPage> {
  String _activeFilter = 'Tất cả';

  @override
  Widget build(BuildContext context) {
    final rewardsAsync = ref.watch(rewardsHubSnapshotProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trung tâm phần thưởng',
      semanticIdentifier: 'SC-319',
      child: Column(
        children: [
          VitHeader(
            title: 'Trung tâm phần thưởng',
            subtitle: 'Nhiệm vụ · điểm · hạng',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.home,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: rewardsAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được phần thưởng',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(rewardsHubSnapshotProvider),
                ),
              ),
              data: (snapshot) {
                final visibleTasks = [
                  for (final task in snapshot.tasks)
                    if (_activeFilter == 'Tất cả' ||
                        task.filter == _activeFilter)
                      task,
                ];
                return VitTabletSectionBody(
                  contentKey: RewardsTabletPage.contentKey,
                  children: [
                    _RewardsSummaryCard(summary: snapshot.summary),

                    Wrap(
                      spacing: TabletSpacingTokens.x3,
                      runSpacing: TabletSpacingTokens.x2,
                      children: [
                        for (final filter in ['Tất cả', ...snapshot.filters])
                          VitFilterChip(
                            label: filter,
                            active: _activeFilter == filter,
                            onTap: () => setState(() {
                              _activeFilter = filter;
                            }),
                            color: AppColors.primary,
                          ),
                      ],
                    ),

                    if (visibleTasks.isEmpty)
                      const VitEmptyState(
                        icon: Icons.emoji_events_outlined,
                        title: 'Không có nhiệm vụ phù hợp',
                        message: 'Thử chọn bộ lọc khác.',
                      )
                    else
                      VitCard(
                        radius: VitCardRadius.tight,
                        padding: TabletSpacingTokens.zeroInsets,
                        clip: true,
                        child: Column(
                          children: [
                            for (var i = 0; i < visibleTasks.length; i++) ...[
                              _TaskRow(task: visibleTasks[i]),
                              if (i < visibleTasks.length - 1)
                                const Divider(
                                  height: TabletSpacingTokens.dividerHairline,
                                  thickness:
                                      TabletSpacingTokens.dividerHairline,
                                  color: AppColors.divider,
                                ),
                            ],
                          ],
                        ),
                      ),

                    if (snapshot.bonusRows.isNotEmpty)
                      _BonusCard(rows: snapshot.bonusRows),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardsSummaryCard extends StatelessWidget {
  const _RewardsSummaryCard({required this.summary});

  final RewardSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Điểm hiện có',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  '${summary.currentPoints}',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  summary.tierLabel,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đang chờ',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  '${summary.pendingCount}',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hạng',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  '#${summary.rank} · Top ${summary.topPercent}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task});

  final RewardTaskDraft task;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.tableCellPadding,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
                Text(
                  task.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: VitProgressBar(
              progress: task.progress.clamp(0.0, 1.0),
              height: TabletSpacingTokens.x3,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          SizedBox(
            width: TabletSpacingTokens.x7,
            child: Text(
              task.rewardLabel,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BonusCard extends StatelessWidget {
  const _BonusCard({required this.rows});

  final List<RewardBonusDraft> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thưởng thêm',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final row in rows)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    row.subtitle,
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
    );
  }
}
