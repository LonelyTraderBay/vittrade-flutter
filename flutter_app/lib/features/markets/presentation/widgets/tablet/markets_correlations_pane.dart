import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Tương quan thị trường (SC-026): timeframe chips + 3 tab
/// (Ma trận | Cặp | Đa dạng hóa) dựng bảng giá trị color-coded, không dùng
/// Container/BoxDecoration (home-reference divergence rule).
class MarketsCorrelationsPane extends ConsumerStatefulWidget {
  const MarketsCorrelationsPane({super.key});

  static const contentKey = Key('sc026_tablet_content');

  @override
  ConsumerState<MarketsCorrelationsPane> createState() =>
      _MarketsCorrelationsPaneState();
}

class _MarketsCorrelationsPaneState
    extends ConsumerState<MarketsCorrelationsPane> {
  String _tab = 'matrix';
  MarketCorrelationTimeframe _timeframe = MarketCorrelationTimeframe.d7;
  CorrelationSortOrder _sortOrder = CorrelationSortOrder.high;

  double _correlationFor(CorrelationPairDraft pair) => switch (_timeframe) {
    MarketCorrelationTimeframe.d7 => pair.correlation7d,
    MarketCorrelationTimeframe.d30 => pair.correlation30d,
    MarketCorrelationTimeframe.d90 => pair.correlation90d,
  };

  @override
  Widget build(BuildContext context) {
    final correlationsAsync = ref.watch(
      marketCorrelationsSnapshotProvider((
        timeframe: _timeframe,
        sortOrder: _sortOrder,
      )),
    );

    return MarketsPaneScaffold(
      title: 'Tương quan thị trường',
      subtitle: 'Tương quan · Markets',
      scrollKey: MarketsCorrelationsPane.contentKey,
      onRefresh: () async {
        ref.invalidate(
          marketCorrelationsSnapshotProvider((
            timeframe: _timeframe,
            sortOrder: _sortOrder,
          )),
        );
        await ref.read(
          marketCorrelationsSnapshotProvider((
            timeframe: _timeframe,
            sortOrder: _sortOrder,
          )).future,
        );
      },
      children: [
        Row(
          children: [
            Expanded(
              child: VitSegmentedTabBar(
                tabs: const [
                  VitTabItem(key: 'matrix', label: 'Ma trận'),
                  VitTabItem(key: 'pairs', label: 'Cặp'),
                  VitTabItem(key: 'diversify', label: 'Đa dạng hóa'),
                ],
                activeKey: _tab,
                onChanged: (value) => setState(() => _tab = value),
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x4),
            for (final (tf, label) in [
              (MarketCorrelationTimeframe.d7, '7 ngày'),
              (MarketCorrelationTimeframe.d30, '30 ngày'),
              (MarketCorrelationTimeframe.d90, '90 ngày'),
            ]) ...[
              VitFilterChip(
                label: label,
                active: _timeframe == tf,
                onTap: () => setState(() => _timeframe = tf),
                color: AppColors.primary,
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
            ],
          ],
        ),
        correlationsAsync.when(
          loading: () => const Column(children: [VitSkeletonList()]),
          error: (error, stackTrace) => Column(
            children: [
              VitErrorState(
                title: 'Không tải được tương quan thị trường',
                message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                actionLabel: 'Thử lại',
                onAction: () => ref.invalidate(
                  marketCorrelationsSnapshotProvider((
                    timeframe: _timeframe,
                    sortOrder: _sortOrder,
                  )),
                ),
              ),
            ],
          ),
          data: (snapshot) => Column(
            children: [
              if (_tab == 'matrix')
                _MatrixCard(assets: snapshot.assets, matrix: snapshot.matrix)
              else if (_tab == 'pairs') ...[
                Wrap(
                  spacing: TabletSpacingTokens.x3,
                  children: [
                    VitFilterChip(
                      label: 'Tương quan cao',
                      active: _sortOrder == CorrelationSortOrder.high,
                      onTap: () => setState(
                        () => _sortOrder = CorrelationSortOrder.high,
                      ),
                      color: AppColors.primary,
                    ),
                    VitFilterChip(
                      label: 'Tương quan thấp',
                      active: _sortOrder == CorrelationSortOrder.low,
                      onTap: () =>
                          setState(() => _sortOrder = CorrelationSortOrder.low),
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x3),
                for (final pair in snapshot.pairs.take(12))
                  _PairRow(
                    label: '${pair.assetA} ↔ ${pair.assetB}',
                    value: _correlationFor(pair),
                  ),
              ] else
                _CorrDiversificationCard(score: snapshot.diversificationScore),
            ],
          ),
        ),
      ],
    );
  }
}

class _MatrixCard extends StatelessWidget {
  const _MatrixCard({required this.assets, required this.matrix});

  final List<CorrelationAsset> assets;
  final List<List<double>> matrix;

  Color _cellColor(double value) {
    if (value >= 0.7) return AppColors.sell;
    if (value >= 0.4) return AppColors.caution;
    if (value <= -0.4) return AppColors.buy;
    return AppColors.text3;
  }

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: TabletSpacingTokens.x3),
                for (final asset in assets)
                  SizedBox(
                    width: TabletSpacingTokens.x7,
                    child: Text(
                      asset.symbol,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
              ],
            ),
            for (var row = 0; row < assets.length; row++)
              Row(
                children: [
                  SizedBox(
                    width: TabletSpacingTokens.x7,
                    child: Text(
                      assets[row].symbol,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  for (var col = 0; col < assets.length; col++)
                    SizedBox(
                      width: TabletSpacingTokens.x7,
                      child: Text(
                        row == col ? '—' : matrix[row][col].toStringAsFixed(2),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.micro.copyWith(
                          color: row == col
                              ? AppColors.text3
                              : _cellColor(matrix[row][col]),
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _PairRow extends StatelessWidget {
  const _PairRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: AppTextStyles.caption.copyWith(
              color: value >= 0 ? AppColors.sell : AppColors.buy,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _CorrDiversificationCard extends StatelessWidget {
  const _CorrDiversificationCard({required this.score});

  final DiversificationScoreDraft score;

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
                  'Điểm đa dạng hóa: ${score.label}',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitStatusPill(
                label: '${score.score}/100',
                status: score.score >= 60
                    ? VitStatusPillStatus.success
                    : score.score >= 40
                    ? VitStatusPillStatus.warning
                    : VitStatusPillStatus.error,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          VitProgressBar(
            progress: score.score / 100,
            label: 'Tương quan trung bình',
            trailingLabel: score.avgCorrelation.toStringAsFixed(2),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
