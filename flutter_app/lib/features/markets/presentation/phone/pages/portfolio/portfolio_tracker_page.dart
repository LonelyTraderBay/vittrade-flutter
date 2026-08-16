import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

part 'portfolio_tracker_page_overview_widgets.dart';
part 'portfolio_tracker_page_holdings_widgets.dart';
part 'portfolio_tracker_page_performance_widgets.dart';

const _marketPrimary = AppColors.primary;
const double _portfolioVisualScrollClearance = 108;
const double _portfolioNativeScrollClearance = 72;
const double _portfolioHeroTitleGap = AppSpacing.x1;
const double _portfolioHeroPnlGap = AppSpacing.x1;
const double _portfolioHeroToggleIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _portfolioHeroPnlIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _portfolioHeroPnlIconGap = AppSpacing.x2;
const double _portfolioQuickStatGap = AppSpacing.x2;
const double _portfolioMiniStatValueGap = AppSpacing.x1;
const double _portfolioAllocationTitleGap = AppSpacing.x2;
const double _portfolioDonutSize = 104;
const double _portfolioDonutGap = AppSpacing.x4;
const double _portfolioLegendGap = AppSpacing.x2;
const double _portfolioLegendDot = AppSpacing.x2;
const double _portfolioSectionGap = AppSpacing.x2;
const double _portfolioHoldingAvatarSm = 26;
const double _portfolioHoldingAvatarMd = 30;
const double _portfolioHoldingAvatarLg = AppSpacing.buttonCompact;
const double _portfolioHoldingRowGap = AppSpacing.x3;
const double _portfolioHoldingSparklineWidth = 48;
const double _portfolioHoldingSparklineHeight = 20;
const double _portfolioHoldingSparklineGap = AppSpacing.x2;
const double _portfolioHoldingValueWidth = 78;
const double _portfolioRiskTitleGap = AppSpacing.x2;
const double _portfolioRiskProgressLabelGap = AppSpacing.x1;
const double _portfolioRiskProgressHeight = AppSpacing.x1;
const double _portfolioRiskCopyGap = AppSpacing.x2;
const double _portfolioRiskLineHeight = 1.25;
const double _portfolioChipGap = AppSpacing.x2;
const double _portfolioHoldingDetailGap = AppSpacing.x3;
const double _portfolioHoldingMetricGap = AppSpacing.x1;
const double _portfolioChartTitleGap = AppSpacing.x2;
const double _portfolioChartHeight = 132;
const double _portfolioPnlRowGap = AppSpacing.x2;
const double _portfolioPnlAvatarGap = AppSpacing.x2;
const double _portfolioPnlProgressGap = AppSpacing.x1;
const double _portfolioPnlProgressHeight = AppSpacing.x1;
const double _portfolioSummaryGap = AppSpacing.x2;
const double _portfolioSummaryValueGap = AppSpacing.x1;
const double _portfolioAllocationDonutInset = AppSpacing.x2;
const double _portfolioAllocationDonutStroke = 14;
const double _portfolioPerformanceTopPadding = AppSpacing.x2;
const double _portfolioPerformanceBottomPadding = AppSpacing.x5;
const double _portfolioPerformanceLineStroke = 2;
const double _portfolioPerformanceLastPoint = AppSpacing.x1;
const double _portfolioPerformanceInnerPoint = 2;
const double _portfolioPerformanceDateBottom = AppSpacing.x4;
const double _portfolioSparklineStroke = 1.4;
const EdgeInsetsDirectional _portfolioHeroPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsDirectional _portfolioMiniStatPadding =
    EdgeInsetsDirectional.all(AppSpacing.x2);
const EdgeInsetsDirectional _portfolioAllocationPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _portfolioHoldingRowPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );
const EdgeInsetsDirectional _portfolioRiskPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsDirectional _portfolioChipPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );
const EdgeInsetsDirectional _portfolioHoldingDetailPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _portfolioChartCardPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsDirectional _portfolioPnlRowPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );
const EdgeInsetsDirectional _portfolioSummaryPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);

class PortfolioTrackerPage extends ConsumerStatefulWidget {
  const PortfolioTrackerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc021_portfolio_tracker_scroll_content');
  static const overviewTabKey = Key('sc021_tab_overview');
  static const assetsTabKey = Key('sc021_tab_assets');
  static const performanceTabKey = Key('sc021_tab_performance');
  static const hideBalanceKey = Key('sc021_hide_balance');

  static Key sortKey(MarketPortfolioSort sort) =>
      Key('sc021_sort_${sort.name}');

  static Key holdingKey(String id) => Key('sc021_holding_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PortfolioTrackerPage> createState() =>
      _PortfolioTrackerPageState();
}
