import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/predictions_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/phone/prediction_enum_tab_bar.dart';

part '../../../widgets/portfolio/prediction_market_maker_provide.dart';
part '../../../widgets/portfolio/prediction_market_maker_returns.dart';
part '../../../widgets/portfolio/prediction_market_maker_positions.dart';
part '../../../widgets/portfolio/prediction_market_maker_earnings.dart';

const _predictionPrimary = AppColors.primary;

enum _MarketMakerTab { provide, positions, earnings }

class PredictionMarketMakerPage extends ConsumerStatefulWidget {
  const PredictionMarketMakerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc037_market_maker_content');
  static const provideTabKey = Key('sc037_tab_provide');
  static const positionsTabKey = Key('sc037_tab_positions');
  static const earningsTabKey = Key('sc037_tab_earnings');
  static const amountFieldKey = Key('sc037_liquidity_amount');
  static const spread25Key = Key('sc037_spread_25');
  static const spread50Key = Key('sc037_spread_50');
  static const spread100Key = Key('sc037_spread_100');
  static const spread200Key = Key('sc037_spread_200');
  static const addLiquidityKey = Key('sc037_add_liquidity');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionMarketMakerPage> createState() =>
      _PredictionMarketMakerPageState();
}

class _PredictionMarketMakerPageState
    extends ConsumerState<PredictionMarketMakerPage> {
  _MarketMakerTab _activeTab = _MarketMakerTab.provide;
  // GD4-F5 (bẫy 14): controller giờ dựng lười trong nhánh `data:` (thay
  // initState đọc repo giờ đã async) — nullable, `_ensureControllers` chỉ
  // seed 1 lần, không ghi đè khi user đã chỉnh.
  TextEditingController? _eventController;
  TextEditingController? _amountController;
  TextEditingController? _minDepthController;
  int _spreadBps = 50;

  void _ensureControllers(PredictionMarketMakerSnapshot snapshot) {
    if (_eventController != null) return;
    _spreadBps = snapshot.defaultSpreadBps;
    _eventController = TextEditingController(text: snapshot.defaultEventName);
    _amountController = TextEditingController();
    _minDepthController = TextEditingController(
      text: _formatInput(snapshot.defaultMinDepth),
    );
    _amountController!.addListener(_refresh);
  }

  @override
  void dispose() {
    _amountController?.removeListener(_refresh);
    _amountController?.dispose();
    _eventController?.dispose();
    _minDepthController?.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final marketMakerAsync = ref.watch(predictionsMarketMakerSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : AppSpacing.contentPad);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tạo lập thị trường dự đoán: cung cấp thanh khoản',
      semanticIdentifier: 'SC-037',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Market Maker',
            subtitle: 'Thanh khoản · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MarketMakerTabBar(
                activeTab: _activeTab,
                onChanged: (tab) => setState(() => _activeTab = tab),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionMarketMakerPage.contentKey,
                    padding:
                        PredictionsSpacingTokens.predictionMarketMakerScrollPadding(
                          scrollEndPadding,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      density: VitDensity.compact,
                      children: marketMakerAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được market maker',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsMarketMakerSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) {
                          _ensureControllers(snapshot);
                          return _activeTab == _MarketMakerTab.provide
                              ? [
                                  _AddLiquidityForm(
                                    eventController: _eventController!,
                                    amountController: _amountController!,
                                    minDepthController: _minDepthController!,
                                    spreadBps: _spreadBps,
                                    onSpreadChanged: (value) =>
                                        setState(() => _spreadBps = value),
                                  ),
                                  _LiquidityOverview(snapshot: snapshot),
                                  const _LiquidityWarning(),
                                ]
                              : _activeTab == _MarketMakerTab.positions
                              ? [_PositionsTab(snapshot: snapshot)]
                              : [_EarningsTab(snapshot: snapshot)];
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
