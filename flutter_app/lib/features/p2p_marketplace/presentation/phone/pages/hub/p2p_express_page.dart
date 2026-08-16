import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/phone/p2p_express_page_state.dart';
part '../../../widgets/phone/p2p_express_form_cards.dart';
part '../../../widgets/phone/p2p_express_page_common.dart';

const double _p2pExpressVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pExpressNativeNavClearance =
    _p2pExpressVisualNavClearance - AppSpacing.x4;
const double _p2pExpressVisualClearance = AppSpacing.x3;
const double _p2pExpressNativeClearance = AppSpacing.x2;
const double _p2pExpressTightGap = AppSpacing.x2;
const double _p2pExpressToggleHeight = AppSpacing.buttonCompact + AppSpacing.x2;
const double _p2pExpressAmountHeight = AppSpacing.inputHeight;
const double _p2pExpressIconBox = AppSpacing.x5;
const double _p2pExpressAssetMark = AppSpacing.x4;

class P2PExpressPage extends ConsumerStatefulWidget {
  const P2PExpressPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc211_p2p_express_content');
  static const amountFieldKey = Key('sc211_p2p_express_amount');
  static const ctaKey = Key('sc211_p2p_express_cta');
  static const buyToggleKey = Key('sc211_p2p_express_buy');
  static const sellToggleKey = Key('sc211_p2p_express_sell');
  static const marketplaceKey = Key('sc211_p2p_express_marketplace');

  static Key quickAmountKey(int amount) =>
      Key('sc211_p2p_express_quick_$amount');

  static Key paymentKey(String id) => Key('sc211_p2p_express_payment_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PExpressPage> createState() => _P2PExpressPageState();
}
