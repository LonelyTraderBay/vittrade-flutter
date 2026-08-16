import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/predictions_controller_providers.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/controllers/predictions_controller.dart';

part '../../../widgets/social/predictions_leaderboard_filters_tabs.dart';
part '../../../widgets/social/predictions_leaderboard_podium_rankings.dart';
part '../../../widgets/social/predictions_leaderboard_rows_wins.dart';

const _predictionPrimary = AppColors.primary;
const _boardSpace = AppSpacing.x2;
const _boardTinySpace = AppSpacing.x1;
const _boardVisualScrollClearance = 112.0;
const _boardNativeScrollClearance = 72.0;
const _boardPodiumExtent = 168.0;
const _boardPodiumColumns = [70.0, 88.0, 60.0];
const _boardRankHeaderExtent = 34.0;
const _boardRankRowExtent = 50.0;
const _boardRankSlot = 28.0;
const _boardMetricSlot = 76.0;
const _boardWinRateSlot = 50.0;
const _boardBadgeExtent = 20.0;
const _boardWinTile = 36.0;
const _boardLineTight = 1.2;

class PredictionsLeaderboardPage extends ConsumerStatefulWidget {
  const PredictionsLeaderboardPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc033_predictions_leaderboard_content');
  static const todayFilterKey = Key('sc033_filter_today');
  static const weeklyFilterKey = Key('sc033_filter_weekly');
  static const monthlyFilterKey = Key('sc033_filter_monthly');
  static const allTimeFilterKey = Key('sc033_filter_all_time');
  static const pnlMetricKey = Key('sc033_metric_pnl');
  static const volumeMetricKey = Key('sc033_metric_volume');
  static const infoKey = Key('sc033_pnl_info');

  static Key traderKey(String user) => Key('sc033_trader_$user');
  static Key biggestWinKey(String user) => Key('sc033_biggest_win_$user');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsLeaderboardPage> createState() =>
      _PredictionsLeaderboardPageState();
}

class _PredictionsLeaderboardPageState
    extends ConsumerState<PredictionsLeaderboardPage> {
  PredictionLeaderboardTimeFilter _timeFilter =
      PredictionLeaderboardTimeFilter.weekly;
  PredictionLeaderboardMetric _metric = PredictionLeaderboardMetric.pnl;

  @override
  Widget build(BuildContext context) {
    final leaderboardQuery = (timeFilter: _timeFilter, metric: _metric);
    final leaderboardAsync = ref.watch(
      predictionsLeaderboardSnapshotProvider(leaderboardQuery),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame
            ? _boardVisualScrollClearance
            : _boardNativeScrollClearance);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Bảng xếp hạng nhà giao dịch dự đoán',
      semanticIdentifier: 'SC-033',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Leaderboard',
            subtitle: 'Bảng xếp hạng · Prediction',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: PredictionsLeaderboardPage.contentKey,
                    padding: EdgeInsetsDirectional.only(
                      bottom: scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: leaderboardAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được bảng xếp hạng',
                            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              predictionsLeaderboardSnapshotProvider(
                                leaderboardQuery,
                              ),
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          _TimeFilters(
                            active: _timeFilter,
                            onSelected: (value) => setState(() {
                              _timeFilter = value;
                            }),
                          ),
                          _MetricTabs(
                            active: _metric,
                            onSelected: (value) => setState(() {
                              _metric = value;
                            }),
                            onInfoTap: () => _showPnlInfo(context),
                          ),
                          _Podium(traders: snapshot.traders.take(3).toList()),
                          _Rankings(snapshot: snapshot),
                          _BiggestWins(snapshot: snapshot),
                        ],
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

  void _showPnlInfo(BuildContext context) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (context) => Padding(
          padding: AppSpacing.cardPaddingCompact,
          child: Text(
            'P/L (Profit/Loss) shows how much a trader has gained or lost. '
            'A positive P/L means profit, negative means loss.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _boardLineTight,
            ),
          ),
        ),
      ),
    );
  }
}
