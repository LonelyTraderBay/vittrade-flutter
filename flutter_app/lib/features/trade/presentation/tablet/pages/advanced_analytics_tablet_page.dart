import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_analytics_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/domain/entities/trade_core_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố dọc tablet của Phân tích nâng cao (SC-092): banner hero thống kê cố
/// định, cột chính là tín hiệu AI (từng tín hiệu một thẻ đầy đủ tham số),
/// cột phụ là tổng hợp rủi ro + nhật ký + sizing gợi ý.
class AdvancedAnalyticsTabletPage extends ConsumerStatefulWidget {
  const AdvancedAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc092_tablet_content');
  static const signalsKey = Key('sc092_tablet_signals');

  static Key signalKey(String id) => Key('sc092_tablet_signal_$id');
  static Key filterKey(String id) => Key('sc092_tablet_filter_$id');

  @override
  ConsumerState<AdvancedAnalyticsTabletPage> createState() =>
      _AdvancedAnalyticsTabletPageState();
}

class _AdvancedAnalyticsTabletPageState
    extends ConsumerState<AdvancedAnalyticsTabletPage> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeAdvancedAnalyticsSnapshotProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phân tích nâng cao',
      semanticIdentifier: 'SC-092',
      child: Column(
        children: [
          VitHeader(
            title: 'Phân tích nâng cao',
            subtitle: 'AI · Rủi ro · Nhật ký',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.tradeMargin,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            backKey: TradeTabletKeys.back,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được phân tích nâng cao',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(tradeAdvancedAnalyticsSnapshotProvider),
                ),
              ),
              data: (snapshot) {
                final signals = _visibleSignals(snapshot.signals);
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradeAdvancedAnalyticsSnapshotProvider);
                    await ref.read(
                      tradeAdvancedAnalyticsSnapshotProvider.future,
                    );
                  },
                  banner: VitTradeAnalyticsHero(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Phân tích nâng cao',
                    subtitle: 'Tín hiệu AI và công cụ quản trị rủi ro',
                    stats: [
                      for (final stat in snapshot.stats)
                        VitTradeAnalyticsStat(
                          label: stat.label,
                          value: stat.value,
                          color: Color(stat.colorHex),
                        ),
                    ],
                  ),
                  primaryChildren: [
                    const VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      density: VitDensity.tool,
                      title: 'Xem lại phân tích nâng cao',
                      message:
                          'Tín hiệu AI, sizing và nhật ký chỉ hỗ trợ quyết định. Xác nhận giới hạn rủi ro trước khi dùng cho lệnh thật.',
                      contractId: 'SC-092-tablet',
                    ),
                    Row(
                      children: [
                        for (final (id, label) in [
                          ('all', 'Tất cả'),
                          ('long', 'Mua'),
                          ('short', 'Bán'),
                        ]) ...[
                          VitFilterChip(
                            key: AdvancedAnalyticsTabletPage.filterKey(id),
                            label: label,
                            active: _filter == id,
                            onTap: () => setState(() => _filter = id),
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: TabletSpacingTokens.x4),
                        ],
                      ],
                    ),
                    VitCard(
                      key: AdvancedAnalyticsTabletPage.signalsKey,
                      radius: VitCardRadius.tight,
                      borderColor: AppColors.border,
                      padding: TabletSpacingTokens.zeroInsets,
                      clip: true,
                      child: Column(
                        children: [
                          for (var i = 0; i < signals.length; i++) ...[
                            _SignalTile(
                              key: AdvancedAnalyticsTabletPage.signalKey(
                                signals[i].id,
                              ),
                              signal: signals[i],
                            ),
                            if (i < signals.length - 1)
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
                  secondaryChildren: [
                    VitTradeSection(
                      innerGap: TabletSpacingTokens.x4,
                      title: 'Rủi ro danh mục',
                      child: _AnalyticsRiskSummaryCard(risk: snapshot.risk),
                    ),
                    VitTradeSection(
                      innerGap: TabletSpacingTokens.x4,
                      title: 'Nhật ký giao dịch',
                      child: _JournalCard(journal: snapshot.journal),
                    ),
                    VitTradeSection(
                      innerGap: TabletSpacingTokens.x4,
                      title: 'Khối lượng gợi ý',
                      child: _SizingCard(sizing: snapshot.sizing),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<TradeAiSignal> _visibleSignals(List<TradeAiSignal> signals) {
    if (_filter == 'long') {
      return signals.where((s) => s.direction == 'long').toList();
    }
    if (_filter == 'short') {
      return signals.where((s) => s.direction == 'short').toList();
    }
    return signals;
  }
}

class _SignalTile extends StatelessWidget {
  const _SignalTile({super.key, required this.signal});

  final TradeAiSignal signal;

  @override
  Widget build(BuildContext context) {
    final isLong = signal.direction == 'long';
    return Padding(
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: isLong ? 'MUA ' : 'BÁN ',
                    style: AppTextStyles.control.copyWith(
                      color: isLong ? AppColors.buy : AppColors.sell,
                      fontWeight: AppTextStyles.bold,
                    ),
                    children: [
                      TextSpan(
                        text: '${signal.pair} · ${signal.timeframe}',
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
              VitStatusPill(
                label: 'Tin cậy ${signal.confidence}%',
                status: signal.confidence >= 80
                    ? VitStatusPillStatus.success
                    : VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Row(
            children: [
              for (final (label, value) in [
                ('Vào lệnh', formatTradePrice(signal.entryPrice)),
                ('Mục tiêu', formatTradePrice(signal.targetPrice)),
                ('Dừng lỗ', formatTradePrice(signal.stopLoss)),
                ('R:R', signal.riskReward.toStringAsFixed(1)),
                ('Chính xác', '${signal.accuracy}%'),
              ])
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
                      Text(
                        value,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (signal.reasoning.isNotEmpty) ...[
            const SizedBox(height: TabletSpacingTokens.x2),
            Text(
              signal.reasoning.join(' · '),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _AnalyticsRiskSummaryCard extends StatelessWidget {
  const _AnalyticsRiskSummaryCard({required this.risk});

  final TradeAdvancedRiskSummary risk;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, value) in [
            ('VaR 95%', formatTradeUsdRounded(risk.var95)),
            ('Sharpe', risk.sharpeRatio.toStringAsFixed(2)),
            (
              'Sụt giảm tối đa',
              '${(risk.maxDrawdown * 100).toStringAsFixed(1)}%',
            ),
            ('Điểm rủi ro', '${risk.riskScore} · ${risk.riskLevel}'),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
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

class _JournalCard extends StatelessWidget {
  const _JournalCard({required this.journal});

  final TradeJournalSummary journal;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, value) in [
            ('Tỷ lệ thắng', '${journal.winRate.toStringAsFixed(0)}%'),
            ('Tổng giao dịch', '${journal.totalTrades}'),
            ('Tổng PnL', formatTradeSignedUsdRounded(journal.totalPnl)),
            ('Lãi trung bình', formatTradeUsdRounded(journal.avgWin)),
            ('Lỗ trung bình', formatTradeUsdRounded(journal.avgLoss)),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
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

class _SizingCard extends StatelessWidget {
  const _SizingCard({required this.sizing});

  final TradePositionSizingSummary sizing;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, value) in [
            ('Số dư', formatTradeUsdRounded(sizing.accountBalance)),
            ('Vào lệnh', formatTradePrice(sizing.entryPrice)),
            ('Dừng lỗ', formatTradePrice(sizing.stopLossPrice)),
            (
              'Rủi ro đề xuất',
              '${sizing.recommendedRiskPct.toStringAsFixed(1)}%',
            ),
            ('Khối lượng', sizing.positionSize.toStringAsFixed(4)),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
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
