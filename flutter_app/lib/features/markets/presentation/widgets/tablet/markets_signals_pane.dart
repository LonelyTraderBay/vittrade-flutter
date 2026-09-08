import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/markets_pane_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane tablet của Social Signals (SC-025): thống kê win-rate + lọc
/// status/category + bảng tín hiệu độ dày tablet (mở rộng xem reasoning),
/// query record (statusFilter, categoryFilter) như trang phone.
class MarketsSignalsPane extends ConsumerStatefulWidget {
  const MarketsSignalsPane({super.key});

  static const contentKey = Key('sc025_tablet_content');

  @override
  ConsumerState<MarketsSignalsPane> createState() => _MarketsSignalsPaneState();
}

class _MarketsSignalsPaneState extends ConsumerState<MarketsSignalsPane> {
  TradingSignalStatus? _statusFilter;
  TradingSignalCategory? _categoryFilter;
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final query = (
      statusFilter: _statusFilter,
      categoryFilter: _categoryFilter,
    );
    final signalsAsync = ref.watch(marketSocialSignalsSnapshotProvider(query));

    return MarketsPaneScaffold(
      title: 'Social Signals',
      subtitle: 'Tín hiệu · Markets',
      scrollKey: MarketsSignalsPane.contentKey,
      onRefresh: () async {
        ref.invalidate(marketSocialSignalsSnapshotProvider(query));
        await ref.read(marketSocialSignalsSnapshotProvider(query).future);
      },
      children: signalsAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được tín hiệu',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(marketSocialSignalsSnapshotProvider(query)),
          ),
        ],
        data: (snapshot) => [
          VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Row(
              children: [
                for (final (label, value, color) in [
                  ('Tín hiệu', '${snapshot.totalSignals}', AppColors.text1),
                  (
                    'Win rate',
                    '${snapshot.overallWinRate.toStringAsFixed(0)}%',
                    AppColors.buy,
                  ),
                  ('Dừng lỗ', '${snapshot.stoppedSignals}', AppColors.sell),
                  (
                    'PnL TB',
                    '${snapshot.avgPnl >= 0 ? '+' : ''}${snapshot.avgPnl.toStringAsFixed(1)}%',
                    snapshot.avgPnl >= 0 ? AppColors.buy : AppColors.sell,
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
              for (final (status, label) in [
                (null, 'Tất cả trạng thái'),
                (TradingSignalStatus.active, 'Đang chạy'),
                (TradingSignalStatus.targetHit, 'Đã chạm mục tiêu'),
                (TradingSignalStatus.stopped, 'Đã dừng'),
                (TradingSignalStatus.expired, 'Hết hạn'),
              ])
                VitFilterChip(
                  label: label,
                  active: _statusFilter == status,
                  onTap: () => setState(() => _statusFilter = status),
                  color: AppColors.primary,
                ),
            ],
          ),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final (category, label) in [
                (null, 'Mọi khung'),
                (TradingSignalCategory.scalp, 'Scalp'),
                (TradingSignalCategory.swing, 'Swing'),
                (TradingSignalCategory.position, 'Position'),
              ])
                VitFilterChip(
                  label: label,
                  active: _categoryFilter == category,
                  onTap: () => setState(() => _categoryFilter = category),
                  color: AppColors.primary,
                ),
            ],
          ),
          if (snapshot.signals.isEmpty)
            const VitEmptyState(
              icon: Icons.online_prediction_rounded,
              title: 'Không có tín hiệu phù hợp',
              message: 'Thử đổi bộ lọc trạng thái hoặc khung giao dịch.',
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.zeroInsets,
              clip: true,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.signals.length; i++) ...[
                    _SignalTile(
                      signal: snapshot.signals[i],
                      expanded: _expandedId == snapshot.signals[i].id,
                      onToggle: () => setState(() {
                        _expandedId = _expandedId == snapshot.signals[i].id
                            ? null
                            : snapshot.signals[i].id;
                      }),
                    ),
                    if (i < snapshot.signals.length - 1)
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

class _SignalTile extends StatelessWidget {
  const _SignalTile({
    required this.signal,
    required this.expanded,
    required this.onToggle,
  });

  final TradingSignalDraft signal;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final long = signal.direction == TradingSignalDirection.long;
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
                  flex: 3,
                  child: Text.rich(
                    TextSpan(
                      text: long ? 'LONG ' : 'SHORT ',
                      style: AppTextStyles.caption.copyWith(
                        color: long ? AppColors.buy : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                      children: [
                        TextSpan(
                          text: '${signal.pair} · ${signal.providerName}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Vào ${formatMarketPriceAdaptive(signal.entry)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'SL ${formatMarketPriceAdaptive(signal.stopLoss)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                SizedBox(
                  width: TabletSpacingTokens.x7,
                  child: VitStatusPill(
                    label: switch (signal.status) {
                      TradingSignalStatus.active => 'Đang chạy',
                      TradingSignalStatus.targetHit => 'Chạm mục tiêu',
                      TradingSignalStatus.stopped => 'Đã dừng',
                      TradingSignalStatus.expired => 'Hết hạn',
                    },
                    status: signal.status == TradingSignalStatus.targetHit
                        ? VitStatusPillStatus.success
                        : signal.status == TradingSignalStatus.stopped
                        ? VitStatusPillStatus.error
                        : VitStatusPillStatus.info,
                    size: VitStatusPillSize.sm,
                  ),
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: TabletSpacingTokens.x2),
              Text(
                'Mục tiêu: ${[for (final t in signal.targets) formatMarketPriceAdaptive(t)].join(' → ')} · '
                'PnL: ${signal.pnlPct >= 0 ? '+' : ''}${signal.pnlPct.toStringAsFixed(1)}% · '
                'Confidence: ${signal.confidence.name}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x1),
              Text(
                signal.reasoning,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
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
