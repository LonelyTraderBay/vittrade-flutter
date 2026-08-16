import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/phone/p2p_home_page_state.dart';
part '../../../widgets/phone/p2p_home_offer_list.dart';
part '../../../widgets/phone/p2p_home_page_common.dart';
part '../../../widgets/phone/p2p_home_tools.dart';

const double _p2pHomeVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pHomeNativeNavClearance =
    _p2pHomeVisualNavClearance - AppSpacing.x4;
const double _p2pHomeVisualClearance = AppSpacing.x3;
const double _p2pHomeNativeClearance = AppSpacing.x2;

class P2PHomePage extends ConsumerStatefulWidget {
  const P2PHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc282_p2p_home_content');
  static const offlineKey = Key('sc282_p2p_home_offline');
  static const quickHubKey = Key('sc282_p2p_home_quick_hub');
  static const tradeTabsKey = Key('sc282_p2p_home_trade_tabs');
  static const assetRailKey = Key('sc282_p2p_home_asset_rail');
  static const searchKey = Key('sc282_p2p_home_search');
  static const filterKey = Key('sc282_p2p_home_filter');
  static const myOrdersKey = Key('sc282_p2p_home_my_orders');
  static const createKey = Key('sc282_p2p_home_create');
  static const toolsKey = Key('sc282_p2p_home_tools');
  static const toolsSheetKey = Key('sc282_p2p_home_tools_sheet');
  static const emptyKey = Key('sc282_p2p_home_empty');
  static const kycBannerKey = Key('sc282_p2p_home_kyc_banner');
  static const guideLinkKey = Key('sc282_p2p_home_guide');
  static const escrowDisclaimerKey = Key('sc282_p2p_home_escrow_disclaimer');

  static Key tradeTabKey(P2PTradeType type) =>
      Key('sc282_p2p_home_tab_${type.name}');
  static Key assetKey(String asset) => Key('sc282_p2p_home_asset_$asset');
  static Key fiatKey(String fiat) => Key('sc282_p2p_home_fiat_$fiat');
  static Key actionKey(String id) => Key('sc282_p2p_home_action_$id');
  static Key toolKey(String id) => Key('sc282_p2p_home_tool_$id');
  static Key adKey(String id) => Key('sc282_p2p_home_ad_$id');
  static Key adMenuKey(String id) => Key('sc282_p2p_home_ad_menu_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PHomePage> createState() => _P2PHomePageState();
}
