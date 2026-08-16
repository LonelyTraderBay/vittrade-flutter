import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/market_icon_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

part 'advanced_charts_page_tabs_filters_widgets.dart';
part 'advanced_charts_page_indicator_drawing_widgets.dart';
part 'advanced_charts_page_signal_widgets.dart';

const _marketPrimary = AppColors.primary;
const double _advancedVisualScrollClearance = 108;
const double _advancedNativeScrollClearance = 72;
const double _advancedActionMinHeight = 28;
const double _advancedChipRemoveIcon = 12;
const double _advancedTinyGap = 3;
const double _advancedMicroGap = AppSpacing.x1;
const double _advancedSmallGap = 6;
const double _advancedCompactGap = AppSpacing.x2;
const double _advancedGap = AppSpacing.x2;
const double _advancedFooterGap = AppSpacing.x2;
const double _advancedMiniHeaderGap = AppSpacing.x1;
const double _advancedIndicatorAvatar = 30;
const double _advancedToggleSize = 30;
const double _advancedToggleIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _advancedInfoIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _advancedToolIcon = AppSpacing.iconMd;
const double _advancedTipIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _advancedSignalBarHeight = 6;
const double _advancedLineHeightCaption = 1.15;
const double _advancedLineHeightReadable = 1.25;
const int _advancedGridColumns = 3;
const double _advancedGridAspectRatio = 1.0;
const EdgeInsetsGeometry _advancedClearButtonPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x2,
      vertical: AppSpacing.x1,
    );
const EdgeInsetsGeometry _advancedActiveChipPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x2,
      vertical: AppSpacing.x1,
    );
const EdgeInsetsGeometry _advancedFilterChipPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x3,
      vertical: AppSpacing.x2,
    );
const EdgeInsetsGeometry _advancedIndicatorHeaderPadding =
    EdgeInsetsDirectional.all(AppSpacing.x3);
const EdgeInsetsGeometry _advancedCategoryBadgePadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x2,
      vertical: AppSpacing.x1,
    );
const EdgeInsetsGeometry _advancedDetailsPadding =
    EdgeInsetsDirectional.fromSTEB(
      AppSpacing.x3,
      AppSpacing.x2,
      AppSpacing.x3,
      AppSpacing.x3,
    );
const EdgeInsetsGeometry _advancedParamPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x2,
      vertical: AppSpacing.x1,
    );
const EdgeInsetsGeometry _advancedSignalMetricPadding =
    EdgeInsetsDirectional.all(AppSpacing.x2);
const EdgeInsetsGeometry _advancedPivotPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x2,
      vertical: AppSpacing.x1,
    );
const EdgeInsetsGeometry _advancedCardPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsGeometry _advancedCardPaddingCompact =
    EdgeInsetsDirectional.all(AppSpacing.x2);

class AdvancedChartsPage extends ConsumerStatefulWidget {
  const AdvancedChartsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc023_advanced_charts_scroll_content');
  static const indicatorsTabKey = Key('sc023_tab_indicators');
  static const drawingTabKey = Key('sc023_tab_drawing');
  static const signalsTabKey = Key('sc023_tab_signals');
  static const clearAllKey = Key('sc023_clear_all');
  static const categoryAllKey = Key('sc023_category_all');
  static const categoryTrendKey = Key('sc023_category_trend');
  static const drawingLineKey = Key('sc023_drawing_category_line');

  static Key indicatorKey(String id) => Key('sc023_indicator_$id');
  static Key indicatorToggleKey(String id) => Key('sc023_indicator_toggle_$id');
  static Key drawingToolKey(String id) => Key('sc023_drawing_tool_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedChartsPage> createState() => _AdvancedChartsPageState();
}
