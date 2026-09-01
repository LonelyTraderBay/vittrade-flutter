import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_notice_widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/orders/p2p_order_page_state.dart';
part '../../../widgets/orders/p2p_order_content_cards.dart';
part '../../../widgets/orders/p2p_order_page_common.dart';

const double _p2pOrderVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pOrderNativeNavClearance =
    _p2pOrderVisualNavClearance - AppSpacing.x4;
const double _p2pOrderVisualClearance = AppSpacing.x3;
const double _p2pOrderNativeClearance = AppSpacing.x2;
const double _p2pOrderDividerHeight = AppSpacing.dividerHairline;
const double _p2pOrderStepperConnectorHeight = AppSpacing.hairlineStroke;
const double _p2pOrderTimelineNodeSize = AppSpacing.x6;
const double _p2pOrderTimelineConnectorHeight = AppSpacing.x5;
const double _p2pOrderSafetyIconBox = AppSpacing.x5;

enum _P2POrderUiStep { payment, confirm }

class P2POrderPage extends ConsumerStatefulWidget {
  const P2POrderPage({super.key, required this.orderId, this.shellRenderMode});

  static const contentKey = Key('sc216_p2p_order_content');
  static const markPaidKey = Key('sc216_p2p_order_mark_paid');
  static const cancelKey = Key('sc216_p2p_order_cancel');
  static const proofKey = Key('sc216_p2p_order_proof');
  static const chatKey = Key('sc216_p2p_order_chat');
  static const copyAllKey = Key('sc216_p2p_order_copy_all');
  static const escrowKey = Key('sc216_p2p_order_escrow');
  static const disputeKey = Key('sc216_p2p_order_dispute');
  static const qrToggleKey = Key('sc216_p2p_order_qr_toggle');

  static Key copyKey(String id) => Key('sc216_p2p_order_copy_$id');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2POrderPage> createState() => _P2POrderPageState();
}
