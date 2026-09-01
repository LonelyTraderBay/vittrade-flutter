import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_terminal_header.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

part '../../../widgets/tools/advanced_chart_header_toolbar.dart';
part '../../../widgets/tools/advanced_chart_area_actions.dart';
part '../../../widgets/tools/advanced_chart_painter.dart';

const _tradePrimary = AppColors.primary;
const _chartBlack = AppColors.dynamicIslandBg;

class AdvancedChartPage extends ConsumerStatefulWidget {
  const AdvancedChartPage({
    super.key,
    required this.pairId,
    this.shellRenderMode,
  });

  static const pairSelectorKey = Key('sc055_pair_selector');
  static const indicatorButtonKey = Key('sc055_indicator_button');
  static const buyKey = Key('sc055_buy');
  static const sellKey = Key('sc055_sell');
  static const alertKey = Key('sc055_alert');
  static const closeIndicatorsKey = Key('sc055_close_indicators');

  static Key timeframeKey(String id) => Key('sc055_timeframe_$id');
  static Key chartTypeKey(String id) => Key('sc055_chart_type_$id');
  static Key indicatorKey(String id) => Key('sc055_indicator_$id');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedChartPage> createState() => _AdvancedChartPageState();
}

class _AdvancedChartPageState extends ConsumerState<AdvancedChartPage> {
  String _timeframe = '1h';
  String _chartType = 'candle';
  bool _showIndicators = false;

  // STATE-S23: indicators sống ở AdvancedChartStateController (một nguồn
  // sự thật) — hết `late List` seed từ ref.read + setState.

  // PERF-HN5: memoize the 3x-interpolated candle expansion so it's only
  // recomputed when the underlying candles reference actually changes (not
  // on every unrelated rebuild, e.g. toggling the indicator sheet or
  // switching timeframe/chart type). `snapshot.candles` comes from a
  // repository-level const list so its identity is stable across rebuilds
  // in practice.
  List<TradeCandle>? _expandedSource;
  List<TradeCandle>? _expandedCache;

  List<TradeCandle> _expandedCandlesFor(List<TradeCandle> candles) {
    if (!identical(candles, _expandedSource)) {
      _expandedSource = candles;
      _expandedCache = expandAdvancedTradeCandles(candles);
    }
    return _expandedCache!;
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      tradeAdvancedChartSnapshotProvider(widget.pairId),
    );
    // GD4 Cụm F7 (REALTIME): lớp cập-nhật-đè — chỉ dùng khi tick đầu tiên
    // đã tới; nếu chưa, `data:` bên dưới vẫn hiển thị snapshot Future như
    // cũ (mục 3 GD4-Async-Playbook).
    final liveSnapshot = ref
        .watch(tradeCandleStreamProvider(widget.pairId))
        .value;
    final indicators = ref
        .watch(advancedChartStateControllerProvider(widget.pairId))
        .indicators;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Biểu đồ giao dịch nâng cao',
      semanticIdentifier: 'SC-055',
      child: Material(
        type: MaterialType.transparency,
        child: VitPageContent(
          rhythm: VitPageRhythm.flush,
          padding: VitContentPadding.none,
          fullBleed: true,
          children: [
            Expanded(
              child: snapshotAsync.when(
                loading: () => const VitSkeletonList(),
                error: (error, stackTrace) => VitErrorState(
                  title: 'Không tải được biểu đồ giao dịch nâng cao',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(
                    tradeAdvancedChartSnapshotProvider(widget.pairId),
                  ),
                ),
                data: (snapshot) {
                  // GD4 Cụm F7 (REALTIME): stream đè lên snapshot Future
                  // khi đã có tick (nến đang hình thành) — pair/ohlcv/
                  // timeframes/candles đều đọc qua `effective`.
                  final effective = liveSnapshot ?? snapshot;
                  final pair = effective.pair;
                  final enabledIndicators = indicators
                      .where((indicator) => indicator.enabled)
                      .toList(growable: false);
                  final productTabs = tradeShellWithProductTabs(
                    context: context,
                    activeProductId: 'spot',
                    productPair: pair,
                    children: const [],
                  );

                  return Stack(
                    children: [
                      Column(
                        children: [
                          VitTradeTerminalHeader(
                            symbol: pair.symbol,
                            showBack: true,
                            onBack: () => goBackOrFallback(
                              context,
                              fallbackPath: AppRoutePaths.tradePair(pair.id),
                              mode: BackNavigationMode.historyThenFallback,
                            ),
                            pairTapKey: AdvancedChartPage.pairSelectorKey,
                            onPairTap: () => context.go(AppRoutePaths.markets),
                            priceLabel: formatTradePrice(pair.price),
                            changePct: pair.changePct,
                          ),
                          ...productTabs,
                          _OhlcvBar(ohlcv: effective.ohlcv),
                          _ChartToolbar(
                            timeframes: effective.timeframes,
                            activeTimeframe: _timeframe,
                            activeChartType: _chartType,
                            activeIndicatorCount: enabledIndicators.length,
                            onTimeframeChanged: (value) =>
                                setState(() => _timeframe = value),
                            onChartTypeChanged: (value) =>
                                setState(() => _chartType = value),
                            onIndicators: () =>
                                setState(() => _showIndicators = true),
                          ),
                          _ChartArea(
                            candles: _expandedCandlesFor(effective.candles),
                            indicators: indicators,
                            chartType: _chartType,
                          ),
                          _ActionBar(pairId: pair.id),
                        ],
                      ),
                      if (_showIndicators)
                        _IndicatorSheet(
                          indicators: indicators,
                          onToggle: _toggleIndicator,
                          onClose: () =>
                              setState(() => _showIndicators = false),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleIndicator(String id) {
    ref
        .read(advancedChartStateControllerProvider(widget.pairId).notifier)
        .toggleIndicator(id);
  }
}
