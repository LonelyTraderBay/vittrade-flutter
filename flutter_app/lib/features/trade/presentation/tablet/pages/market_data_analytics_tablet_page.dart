import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Phân tích thị trường (SC-089): hero instrument ghim
/// trên, cột chính là 3 tab dữ liệu (Market | Thanh lý | Tâm lý) dạng bảng
/// rộng, cột phụ là funding + trạng thái cập nhật.
class MarketDataAnalyticsTabletPage extends ConsumerStatefulWidget {
  const MarketDataAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc089_tablet_content');

  static Key tabKey(String id) => Key('sc089_tablet_tab_$id');

  @override
  ConsumerState<MarketDataAnalyticsTabletPage> createState() =>
      _MarketDataAnalyticsTabletPageState();
}

class _MarketDataAnalyticsTabletPageState
    extends ConsumerState<MarketDataAnalyticsTabletPage> {
  String _tab = 'market';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeMarketDataAnalyticsProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phân tích thị trường: dữ liệu và thanh khoản',
      semanticIdentifier: 'SC-089',
      child: Column(
        children: [
          VitHeader(
            title: 'Phân tích thị trường',
            subtitle: 'Dữ liệu · Thanh khoản',
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
            child: async.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được dữ liệu',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(tradeMarketDataAnalyticsProvider),
                ),
              ),
              data: (snapshot) {
                final day = tradeSyntheticDaySnapshot(
                  snapshot.markPrice,
                  snapshot.fundingRate.currentRatePct,
                );
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradeMarketDataAnalyticsProvider);
                    await ref.read(tradeMarketDataAnalyticsProvider.future);
                  },
                  banner: VitTradeInstrumentHero(
                    symbol: snapshot.selectedPair,
                    priceLabel: formatTradeUsd(snapshot.markPrice),
                    changePct: snapshot.fundingRate.currentRatePct,
                    sparklineValues: day.sparkline,
                    highLabel: day.highLabel,
                    lowLabel: day.lowLabel,
                    volumeLabel: day.volumeLabel,
                  ),
                  primaryChildren: [
                    VitCard(
                      key: MarketDataAnalyticsTabletPage.contentKey,
                      variant: VitCardVariant.inner,
                      radius: VitCardRadius.tight,
                      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            density: VitDensity.tool,
                            title: 'Xem lại dữ liệu thị trường',
                            message:
                                'Phân tích ${snapshot.selectedPair} chỉ mang tính tham khảo. Xác nhận ký quỹ, rủi ro thanh lý, phí funding và giới hạn vị thế trước khi đặt lệnh.',
                            contractId: 'SC-089-tablet-analytics-review',
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          VitSegmentedTabBar(
                            tabs: [
                              VitTabItem(
                                key: 'market',
                                label: 'Dữ liệu thị trường',
                                widgetKey: MarketDataAnalyticsTabletPage.tabKey(
                                  'market',
                                ),
                              ),
                              VitTabItem(
                                key: 'liquidations',
                                label: 'Thanh lý',
                                widgetKey: MarketDataAnalyticsTabletPage.tabKey(
                                  'liquidations',
                                ),
                              ),
                              VitTabItem(
                                key: 'sentiment',
                                label: 'Tâm lý',
                                widgetKey: MarketDataAnalyticsTabletPage.tabKey(
                                  'sentiment',
                                ),
                              ),
                            ],
                            activeKey: _tab,
                            onChanged: (tab) => setState(() => _tab = tab),
                          ),
                        ],
                      ),
                    ),
                    if (_tab == 'market')
                      _MarketTab(snapshot: snapshot)
                    else if (_tab == 'liquidations')
                      _LiquidationTab(snapshot: snapshot)
                    else
                      _SentimentTab(sentiment: snapshot.sentiment),
                  ],
                  secondaryChildren: [
                    _RowsCard(
                      title: 'Funding',
                      rows: [
                        (
                          'Hiện tại',
                          '${snapshot.fundingRate.currentRatePct.toStringAsFixed(3)}%',
                        ),
                        (
                          'Bình quân',
                          '${snapshot.fundingRate.avgRatePct.toStringAsFixed(3)}%',
                        ),
                        (
                          'Biên độ',
                          '${snapshot.fundingRate.rangePct.toStringAsFixed(3)}%',
                        ),
                        ('Kỳ tiếp theo', snapshot.fundingRate.nextFundingLabel),
                      ],
                    ),
                    _RowsCard(
                      title: 'Trạng thái',
                      rows: [
                        ('Cặp đang xem', snapshot.selectedPair),
                        ('Cập nhật', snapshot.lastUpdatedLabel),
                      ],
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
}

class _RowsCard extends StatelessWidget {
  const _RowsCard({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
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
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    textAlign: TextAlign.end,
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

class _MarketTab extends StatelessWidget {
  const _MarketTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final oi = snapshot.openInterest;
    final ls = snapshot.longShortRatio;
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Open Interest',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final (label, value) in [
            ('Hiện tại', formatTradeUsdWhole(oi.current)),
            (
              'Biến động 24h',
              '${formatTradeUsdWhole(oi.change24h)} (${oi.change24hPct.toStringAsFixed(1)}%)',
            ),
            ('Cao 24h', formatTradeUsdWhole(oi.high24h)),
            ('Thấp 24h', formatTradeUsdWhole(oi.low24h)),
          ])
            _labelValueRow(label, value),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Text(
            'Tỷ lệ Long/Short',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          VitProgressBar(
            progress: ls.longPct / 100,
            label: 'Long',
            trailingLabel: '${ls.longPct.toStringAsFixed(0)}%',
            color: AppColors.buy,
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          VitProgressBar(
            progress: ls.shortPct / 100,
            label: 'Short',
            trailingLabel: '${ls.shortPct.toStringAsFixed(0)}%',
            color: AppColors.sell,
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          _labelValueRow(
            'Top trader long',
            '${snapshot.topTraders.longPct.toStringAsFixed(1)}% '
                '(${snapshot.topTraders.change24h >= 0 ? '+' : ''}${snapshot.topTraders.change24h.toStringAsFixed(1)}% 24h)',
          ),
        ],
      ),
    );
  }
}

class _LiquidationTab extends StatelessWidget {
  const _LiquidationTab({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.liquidationStats;
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thống kê thanh lý',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final (label, value) in [
            ('Tổng 24h', formatTradeUsdWhole(stats.total24h)),
            (
              'Long / Short 24h',
              '${formatTradeUsdWhole(stats.long24h)} / ${formatTradeUsdWhole(stats.short24h)}',
            ),
            ('Lớn nhất 24h', formatTradeUsdWhole(stats.largest24h)),
            ('Số lệnh 24h', formatTradeInt(stats.count24h)),
            ('Tổng 7 ngày', formatTradeUsdWhole(stats.total7d)),
            ('Tổng 30 ngày', formatTradeUsdWhole(stats.total30d)),
          ])
            _labelValueRow(label, value),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Text(
            'Sự kiện gần đây',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final event in snapshot.recentLiquidations.take(6))
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x1,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: TabletSpacingTokens.x7,
                    child: Text(
                      event.timeLabel,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${event.side} ${event.pair}',
                      style: AppTextStyles.caption.copyWith(
                        color: event.side == 'long'
                            ? AppColors.sell
                            : AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    formatTradeUsdWhole(event.size),
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

class _SentimentTab extends StatelessWidget {
  const _SentimentTab({required this.sentiment});

  final TradeMarketSentiment sentiment;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tâm lý thị trường: ${sentiment.overall}',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitStatusPill(
                label: 'Điểm ${sentiment.score}/100',
                status: sentiment.score >= 60
                    ? VitStatusPillStatus.success
                    : sentiment.score >= 40
                    ? VitStatusPillStatus.warning
                    : VitStatusPillStatus.error,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          for (final component in sentiment.components)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      component.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    '${component.score}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          for (final implication in sentiment.implications)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Text(
                'Nếu ${implication.condition} → ${implication.action}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _labelValueRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: TabletSpacingTokens.x2),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
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
  );
}
