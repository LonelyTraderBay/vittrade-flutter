import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Tin tức thị trường (SC-022): chip category + sentiment +
/// danh sách tin dạng hàng rộng (re-compose, thay card dọc của phone).
class MarketsNewsPane extends ConsumerStatefulWidget {
  const MarketsNewsPane({super.key});

  static const contentKey = Key('sc022_tablet_content');

  @override
  ConsumerState<MarketsNewsPane> createState() => _MarketsNewsPaneState();
}

class _MarketsNewsPaneState extends ConsumerState<MarketsNewsPane> {
  String _category = 'all';
  MarketNewsSentiment? _sentimentFilter;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(
      marketNewsSnapshotProvider((
        category: _category,
        sentiment: _sentimentFilter,
      )),
    );

    return MarketsPaneScaffold(
      title: 'Tin tức thị trường',
      subtitle: 'News · Markets',
      scrollKey: MarketsNewsPane.contentKey,
      onRefresh: () async {
        ref.invalidate(
          marketNewsSnapshotProvider((
            category: _category,
            sentiment: _sentimentFilter,
          )),
        );
        await ref.read(
          marketNewsSnapshotProvider((
            category: _category,
            sentiment: _sentimentFilter,
          )).future,
        );
      },
      children: newsAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được tin tức',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(
              marketNewsSnapshotProvider((
                category: _category,
                sentiment: _sentimentFilter,
              )),
            ),
          ),
        ],
        data: (snapshot) => [
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final category in snapshot.categories)
                VitFilterChip(
                  label: category.label,
                  active: _category == category.id,
                  onTap: () => setState(() => _category = category.id),
                  color: AppColors.primary,
                ),
            ],
          ),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final entry in snapshot.sentimentBadges.entries)
                VitFilterChip(
                  label: entry.value.label,
                  active: _sentimentFilter == entry.key,
                  onTap: () => setState(() {
                    _sentimentFilter = _sentimentFilter == entry.key
                        ? null
                        : entry.key;
                  }),
                  color: AppColors.primary,
                ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          if (snapshot.news.isEmpty)
            const VitEmptyState(
              icon: Icons.newspaper_rounded,
              title: 'Không có tin phù hợp',
              message: 'Thử đổi category hoặc bộ lọc sentiment.',
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.zeroInsets,
              clip: true,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.news.length; i++) ...[
                    _NewsTile(
                      item: snapshot.news[i],
                      expanded: _expandedId == snapshot.news[i].id,
                      onToggle: () => setState(() {
                        _expandedId = _expandedId == snapshot.news[i].id
                            ? null
                            : snapshot.news[i].id;
                      }),
                    ),
                    if (i < snapshot.news.length - 1)
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

class _NewsTile extends StatelessWidget {
  const _NewsTile({
    required this.item,
    required this.expanded,
    required this.onToggle,
  });

  final MarketNewsItem item;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: TabletSpacingTokens.tilePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: expanded ? 3 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x3),
                if (item.isBreaking)
                  const VitStatusPill(
                    label: 'Breaking',
                    status: VitStatusPillStatus.error,
                    size: VitStatusPillSize.sm,
                  )
                else
                  Text(
                    item.timeAgo,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: TabletSpacingTokens.x2),
              Text(
                item.summary,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x2),
              Text(
                '${item.source} · ${item.readTime} đọc · ${item.timeAgo}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
