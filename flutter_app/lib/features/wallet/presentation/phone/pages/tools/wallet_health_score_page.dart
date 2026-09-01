import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../../widgets/tools/wallet_health_score_page_shell.dart';
part '../../../widgets/tools/wallet_health_score_cards.dart';
part '../../../widgets/tools/wallet_health_score_charts.dart';

const _healthBackground = AppColors.bg;
const _healthPanel = AppColors.surface;
const _healthPrimary = AppColors.primary;
const _healthGreen = AppColors.buy;
const _healthAmber = AppColors.caution;
const _healthOrange = AppColors.riskHigh;
const _healthRed = AppColors.sell;
const _healthPurple = AppColors.accent;
const _healthCompactGaugeSize = 88.0;
const _healthMetricProgressHeight = 5.0;
const _healthLegendSwatchHeight = 10.0;

const _tabOverview = 'T\u1ED5ng quan';
const _tabSecurity = 'B\u1EA3o m\u1EADt';
const _tabDiversification = '\u0110a d\u1EA1ng h\u00F3a';

double _healthScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? WalletSpacingTokens.walletVisualChromePad
          : WalletSpacingTokens.walletNativeChromePad) +
      MediaQuery.paddingOf(context).bottom;
}

class WalletHealthScorePage extends ConsumerStatefulWidget {
  const WalletHealthScorePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc151_health_score_content');
  static const sheetCloseKey = Key('sc151_health_score_sheet_close');
  static Key tabKey(String label) => Key('sc151_health_score_tab_$label');
  static Key metricKey(String category) =>
      Key('sc151_health_score_metric_$category');
  static Key recommendationKey(String id) =>
      Key('sc151_health_score_recommendation_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletHealthScorePage> createState() =>
      _WalletHealthScorePageState();
}
