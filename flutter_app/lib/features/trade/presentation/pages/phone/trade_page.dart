import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_high_risk_status_ui.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/features/trade/presentation/pages/phone/order_receipt_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_simple_shell.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_simple_hero.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_simple_order_form.dart';

part 'trade_page_state.dart';

class TradePage extends ConsumerStatefulWidget {
  const TradePage({
    super.key,
    this.pairId = 'btcusdt',
    this.chartVariant = TradeChartVariant.defaultRoute,
    this.initialSide = TradeOrderSide.buy,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc048_trade_scroll_content');
  static const backKey = Key('sc048_trade_back');
  static const buySideKey = Key('sc048_trade_buy_side');
  static const sellSideKey = Key('sc048_trade_sell_side');
  static const amountFieldKey = Key('sc048_trade_amount_field');
  static const submitKey = Key('sc048_trade_submit');
  static const confirmSheetKey = Key('sc048_trade_confirm_sheet');
  static const nextActionKey = Key('sc048_trade_next_action');

  static Key quickNavKey(String id) => Key('sc048_quick_$id');
  static Key pctKey(int pct) => Key('sc048_pct_$pct');

  final String pairId;
  final TradeChartVariant chartVariant;
  final TradeOrderSide initialSide;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradePage> createState() => _TradePageState();
}

/// Kept for route compatibility; chart UI lives on L2 advanced chart.
enum TradeChartVariant { defaultRoute, pairRoute }
