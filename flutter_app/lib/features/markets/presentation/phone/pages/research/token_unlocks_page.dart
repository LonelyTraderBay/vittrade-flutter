import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
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

part 'token_unlocks_page_upcoming_widgets.dart';
part 'token_unlocks_page_card_analysis_widgets.dart';
part 'token_unlocks_page_schedule_widgets.dart';
part 'token_unlocks_page_formatters.dart';

const _marketPrimary = AppColors.primary;
const double _unlockVisualScrollClearance = 108;
const double _unlockNativeScrollClearance = 72;
const double _unlockHeroLabelGap = AppSpacing.x1;
const double _unlockHeroValueGap = AppSpacing.x2;
const double _unlockFilterGap = AppSpacing.x2;
const double _unlockListGap = AppSpacing.rowGap;
const double _unlockDateGap = AppSpacing.x1;
const double _unlockValueGap = AppSpacing.x1;
const double _unlockExpandedMetricGap = AppSpacing.x2;
const double _unlockPriceWarningGap = AppSpacing.x2;
const double _unlockDetailMetricGap = AppSpacing.x1;
const double _unlockImpactTitleGap = AppSpacing.x2;
const double _unlockImpactStatValueGap = AppSpacing.x1;
const double _unlockCategoryGap = AppSpacing.x2;
const double _unlockCategoryProgressGap = AppSpacing.x1;
const double _unlockCategoryProgressHeight = 5;
const double _unlockDilutionRowGap = AppSpacing.x2;
const double _unlockScheduleGap = AppSpacing.x2;
const double _unlockScheduleSupplyGap = AppSpacing.x2;
const double _unlockScheduleProgressGap = AppSpacing.x1;
const double _unlockScheduleTitleGap = AppSpacing.x2;

class TokenUnlocksPage extends ConsumerStatefulWidget {
  const TokenUnlocksPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc024_token_unlocks_scroll_content');
  static const upcomingTabKey = Key('sc024_tab_upcoming');
  static const analysisTabKey = Key('sc024_tab_analysis');
  static const scheduleTabKey = Key('sc024_tab_schedule');
  static const sortValueKey = Key('sc024_sort_value');
  static const impactHighKey = Key('sc024_impact_high');

  static Key unlockCardKey(String id) => Key('sc024_unlock_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TokenUnlocksPage> createState() => _TokenUnlocksPageState();
}
