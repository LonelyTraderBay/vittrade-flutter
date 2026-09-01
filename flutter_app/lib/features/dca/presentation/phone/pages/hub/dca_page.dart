import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/phone/dca_currency_formatters.dart';

part 'dca_page_state_overview.dart';
part 'dca_page_plans_and_tools.dart';
part 'dca_page_history_and_create_sheet.dart';
part 'dca_page_common.dart';

enum _DcaTab { plans, history }

class DCAPage extends ConsumerStatefulWidget {
  const DCAPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc169_dca_content');
  static const createPlanKey = Key('sc169_create_plan');
  static const overviewCreateKey = Key('sc169_overview_create');
  static const pauseAllKey = Key('sc169_pause_all');
  static const chartKey = Key('sc169_chart');
  static const historyKey = Key('sc169_history');
  static const createSheetKey = Key('sc169_create_sheet');
  static const loadingKey = Key('sc169_dca_loading');
  static const errorKey = Key('sc169_dca_error');
  static const offlineKey = Key('sc169_dca_offline');
  static const emptyKey = Key('sc169_dca_empty');

  static Key toolKey(String route) => Key('sc169_tool_$route');
  static Key tabKey(String id) => Key('sc169_tab_$id');
  static Key planKey(String id) => Key('sc169_plan_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAPage> createState() => _DCAPageState();
}
