import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Token Unlocks (SC-024): hero thống kê + lọc impact +
/// bảng unlock độ dày tablet (mở rộng xem lịch vesting), query là record
/// (sortBy, impactFilter) như trang phone.
class MarketsUnlocksPane extends ConsumerStatefulWidget {
  const MarketsUnlocksPane({super.key});

  static const contentKey = Key('sc024_tablet_content');

  @override
  ConsumerState<MarketsUnlocksPane> createState() => _MarketsUnlocksPaneState();
}

class _MarketsUnlocksPaneState extends ConsumerState<MarketsUnlocksPane> {
  final MarketUnlockSort _sortBy = MarketUnlockSort.value;
  MarketUnlockImpact? _impactFilter;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final query = (sortBy: _sortBy, impactFilter: _impactFilter);
    final unlocksAsync = ref.watch(marketTokenUnlocksSnapshotProvider(query));

    return MarketsPaneScaffold(
      title: 'Token Unlocks',
      subtitle: 'Lịch mở khóa · Markets',
      scrollKey: MarketsUnlocksPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketTokenUnlocksSnapshotProvider(query));
        await ref.read(marketTokenUnlocksSnapshotProvider(query).future);
      },
      children: unlocksAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được lịch mở khóa',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(marketTokenUnlocksSnapshotProvider(query)),
          ),
        ],
        data: (snapshot) => [
          VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Row(
              children: [
                for (final (label, value, color) in [
                  (
                    'Giá trị mở khóa 30 ngày',
                    formatMarketCompact(
                      snapshot.totalValueNext30d,
                      prefix: '\$',
                    ),
                    AppColors.text1,
                  ),
                  ('Impact cao', '${snapshot.highImpactCount}', AppColors.sell),
                  (
                    'Pha loãng TB',
                    '${snapshot.avgDilution.toStringAsFixed(1)}%',
                    AppColors.text2,
                  ),
                ]) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x1),
                        Text(
                          value,
                          style: AppTextStyles.control.copyWith(
                            color: color,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final (impact, label) in [
                (null, 'Tất cả'),
                (MarketUnlockImpact.high, 'Impact cao'),
                (MarketUnlockImpact.medium, 'Trung bình'),
                (MarketUnlockImpact.low, 'Thấp'),
              ])
                VitFilterChip(
                  label: label,
                  active: _impactFilter == impact,
                  onTap: () => setState(() => _impactFilter = impact),
                  color: AppColors.primary,
                ),
            ],
          ),
          if (snapshot.unlocks.isEmpty)
            const VitEmptyState(
              icon: Icons.lock_open_rounded,
              title: 'Không có unlock phù hợp',
              message: 'Thử đổi bộ lọc impact.',
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.zeroInsets,
              clip: true,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.unlocks.length; i++) ...[
                    _UnlockTile(
                      unlock: snapshot.unlocks[i],
                      expanded: _expandedId == snapshot.unlocks[i].id,
                      onToggle: () => setState(() {
                        _expandedId = _expandedId == snapshot.unlocks[i].id
                            ? null
                            : snapshot.unlocks[i].id;
                      }),
                    ),
                    if (i < snapshot.unlocks.length - 1)
                      const Divider(
                        height: TabletSpacingTokens.dividerHairline,
                        thickness: TabletSpacingTokens.dividerHairline,
                        color: AppColors.divider,
                      ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _UnlockTile extends StatelessWidget {
  const _UnlockTile({
    required this.unlock,
    required this.expanded,
    required this.onToggle,
  });

  final TokenUnlockDraft unlock;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: TabletSpacingTokens.tableCellPaddingTall,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    '${unlock.symbol} · ${unlock.name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    unlock.unlockDateLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    formatMarketCompact(unlock.unlockValueUsd, prefix: '\$'),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                SizedBox(
                  width: TabletSpacingTokens.x7,
                  child: VitStatusPill(
                    label: switch (unlock.impactLevel) {
                      MarketUnlockImpact.high => 'Cao',
                      MarketUnlockImpact.medium => 'TB',
                      MarketUnlockImpact.low => 'Thấp',
                    },
                    status: unlock.impactLevel == MarketUnlockImpact.high
                        ? VitStatusPillStatus.error
                        : unlock.impactLevel == MarketUnlockImpact.medium
                        ? VitStatusPillStatus.warning
                        : VitStatusPillStatus.neutral,
                    size: VitStatusPillSize.sm,
                  ),
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: TabletSpacingTokens.x2),
              Text(
                'Pha loãng lưu hành: ${unlock.unlockPctCirculating.toStringAsFixed(2)}% · '
                'Vesting: ${switch (unlock.vestingType) {
                  MarketUnlockVestingType.cliff => 'Cliff',
                  MarketUnlockVestingType.linear => 'Linear',
                  MarketUnlockVestingType.milestone => 'Milestone',
                }} · '
                'Tổng khóa: ${formatMarketCompact(unlock.totalLockedValueUsd, prefix: '\$')}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
