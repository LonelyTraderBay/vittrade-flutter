import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/execution/market_data_analytics_open_interest.dart';
part '../../../widgets/execution/market_data_analytics_funding_traders.dart';
part '../../../widgets/execution/market_data_analytics_liquidations.dart';
part '../../../widgets/execution/market_data_analytics_sentiment.dart';
part '../../../widgets/execution/market_data_analytics_shared.dart';

const _analyticsPanel2 = AppColors.surface2;
const _analyticsSurface3 = AppColors.surfaceNavyDeep;
const _analyticsBorder = AppColors.analyticsBorder;
const _analyticsPrimary = AppColors.primary;
const _analyticsGreen = AppColors.buy;
const _analyticsRed = AppColors.sell;
const _analyticsPurple = AppColors.accent;
const _analyticsAmber = AppColors.caution;

class MarketDataAnalyticsPage extends ConsumerStatefulWidget {
  const MarketDataAnalyticsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc089_market_data_analytics_content');
  static Key tabKey(String id) => Key('sc089_market_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MarketDataAnalyticsPage> createState() =>
      _MarketDataAnalyticsPageState();
}

class _MarketDataAnalyticsPageState
    extends ConsumerState<MarketDataAnalyticsPage> {
  String _tab = 'market';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeMarketDataAnalyticsProvider);

    return VitTradeHubScaffold(
      title: 'Phân tích thị trường',
      subtitle: 'Dữ liệu · Thanh khoản',
      semanticLabel: 'Phân tích thị trường: dữ liệu và thanh khoản',
      semanticIdentifier: 'SC-089',
      contentKey: MarketDataAnalyticsPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeMargin,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeMarketDataAnalyticsProvider),
          ),
        ],
        data: (snapshot) {
          // Domain has no real 24h price-change/series for markPrice (only
          // open-interest and funding-rate metrics, both a different unit
          // than price) — openInterest.high24h/low24h/current were
          // previously wired into the hero's price high/low/volume slots,
          // a T01-style mislabel (open-interest notional shown as price
          // stats). Derive a deterministic, price-scaled day snapshot
          // instead so Cao/Thấp/KL 24h stay consistent with the displayed
          // price (Trade Redesign V2 §3 sparkline mandate).
          final daySnapshot = tradeSyntheticDaySnapshot(
            snapshot.markPrice,
            snapshot.fundingRate.currentRatePct,
          );
          return [
            VitTradeInstrumentHero(
              symbol: snapshot.selectedPair,
              priceLabel: '\$${_formatMoney(snapshot.markPrice)}',
              changePct: snapshot.fundingRate.currentRatePct,
              sparklineValues: daySnapshot.sparkline,
              highLabel: daySnapshot.highLabel,
              lowLabel: daySnapshot.lowLabel,
              volumeLabel: daySnapshot.volumeLabel,
            ),
            _MarketAnalyticsRiskPanel(snapshot: snapshot),
            _UnderlineTabs(
              activeId: _tab,
              onChanged: (id) => setState(() => _tab = id),
            ),
            if (_tab == 'market')
              _MarketDataTab(snapshot: snapshot)
            else if (_tab == 'liquidations')
              _LiquidationsTab(snapshot: snapshot)
            else
              _SentimentTab(snapshot: snapshot),
          ];
        },
      ),
    );
  }
}

class _MarketAnalyticsRiskPanel extends StatelessWidget {
  const _MarketAnalyticsRiskPanel({required this.snapshot});

  final TradeMarketDataAnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      density: VitDensity.tool,
      title: 'Xem lại dữ liệu thị trường',
      message:
          'Phân tích ${snapshot.selectedPair} chỉ mang tính tham khảo. Xác nhận ký quỹ, rủi ro thanh lý, phí funding và giới hạn vị thế trước khi đặt lệnh.',
      contractId: 'SC-089 analytics review',
    );
  }
}

class _UnderlineTabs extends StatelessWidget {
  const _UnderlineTabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  static const _tabs = [
    ('market', 'Market Data'),
    ('liquidations', 'Liquidations'),
    ('sentiment', 'Sentiment'),
  ];

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      activeKey: activeId,
      onChanged: onChanged,
      tabs: [
        for (final tab in _tabs)
          VitTabItem(
            key: tab.$1,
            label: tab.$2,
            widgetKey: MarketDataAnalyticsPage.tabKey(tab.$1),
          ),
      ],
    );
  }
}
