import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Tâm lý xã hội (SC-020): điểm tổng + progress sentiment
/// + bảng token độ dày tablet, sort theo sentiment/mentions/trending.
class MarketsSentimentPane extends ConsumerStatefulWidget {
  const MarketsSentimentPane({super.key});

  static const contentKey = Key('sc020_tablet_content');

  @override
  ConsumerState<MarketsSentimentPane> createState() =>
      _MarketsSentimentPaneState();
}

class _MarketsSentimentPaneState extends ConsumerState<MarketsSentimentPane> {
  String _tab = 'overview';
  MarketSentimentSort _sortBy = MarketSentimentSort.sentiment;

  List<SocialSentimentToken> _sortedTokens(List<SocialSentimentToken> tokens) {
    final sorted = [...tokens];
    switch (_sortBy) {
      case MarketSentimentSort.mentions:
        sorted.sort((a, b) => b.mentions24h.compareTo(a.mentions24h));
      case MarketSentimentSort.trending:
        sorted.sort((a, b) => b.socialVolume.compareTo(a.socialVolume));
      case MarketSentimentSort.sentiment:
        sorted.sort((a, b) => b.sentimentScore.compareTo(a.sentimentScore));
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final sentimentAsync = ref.watch(
      marketSocialSentimentSnapshotProvider(_sortBy),
    );

    return MarketsPaneScaffold(
      title: 'Tâm lý xã hội',
      subtitle: 'Sentiment · Markets',
      scrollKey: MarketsSentimentPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketSocialSentimentSnapshotProvider(_sortBy));
        await ref.read(marketSocialSentimentSnapshotProvider(_sortBy).future);
      },
      children: [
        VitSegmentedTabBar(
          tabs: const [
            VitTabItem(key: 'overview', label: 'Tổng quan'),
            VitTabItem(key: 'token', label: 'Theo token'),
          ],
          activeKey: _tab,
          onChanged: (value) => setState(() => _tab = value),
        ),
        sentimentAsync.when(
          loading: () => const Column(children: [VitSkeletonList()]),
          error: (error, stackTrace) => Column(
            children: [
              VitErrorState(
                title: 'Không tải được tâm lý thị trường',
                message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(
                  marketSocialSentimentSnapshotProvider(_sortBy),
                ),
              ),
            ],
          ),
          data: (snapshot) => Column(
            children: [
              _GlobalCard(global: snapshot.global),
              const SizedBox(height: TabletSpacingTokens.x3),
              if (_tab == 'overview') ...[
                for (final token in snapshot.trendingTokens.take(6))
                  _TokenRow(token: token),
              ] else ...[
                Row(
                  children: [
                    for (final (id, label) in [
                      ('sentiment', 'Sentiment'),
                      ('mentions', 'Đề cập'),
                      ('trending', 'Xu hướng'),
                    ]) ...[
                      VitFilterChip(
                        label: label,
                        active: _sortBy.name == id,
                        onTap: () => setState(
                          () => _sortBy = id == 'mentions'
                              ? MarketSentimentSort.mentions
                              : id == 'trending'
                              ? MarketSentimentSort.trending
                              : MarketSentimentSort.sentiment,
                        ),
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: TabletSpacingTokens.x3),
                    ],
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x3),
                for (final token in _sortedTokens(snapshot.tokens))
                  _TokenRow(token: token),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _GlobalCard extends StatelessWidget {
  const _GlobalCard({required this.global});

  final SocialSentimentGlobal global;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tâm lý tổng: ${global.overallLabel}',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitStatusPill(
                label: '${global.overallScore}/100',
                status: global.overallScore >= 60
                    ? VitStatusPillStatus.success
                    : global.overallScore >= 40
                    ? VitStatusPillStatus.warning
                    : VitStatusPillStatus.error,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          VitProgressBar(
            progress: global.overallScore / 100,
            label: 'Điểm tâm lý',
            trailingLabel:
                '${global.totalMentions24h.toStringAsFixed(0)} đề cập 24h',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _TokenRow extends StatelessWidget {
  const _TokenRow({required this.token});

  final SocialSentimentToken token;

  @override
  Widget build(BuildContext context) {
    final positive = token.sentimentScore >= 50;
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '${token.symbol} · ${token.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                color: AppColors.text1,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: VitProgressBar(
              progress: token.sentimentScore / 100,
              color: positive ? AppColors.buy : AppColors.sell,
              height: TabletSpacingTokens.x3,
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          SizedBox(
            width: TabletSpacingTokens.x7,
            child: Text(
              '${token.sentimentScore}',
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
    );
  }
}
