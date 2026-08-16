import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part 'arena_production_ready_page_screens_states_section.dart';
part 'arena_production_ready_page_flows_registry_handoff.dart';
part 'arena_production_ready_page_handoff_and_shared_widgets.dart';

enum _ProductionSection { screens, states, flows, registry, handoff }

class ArenaProductionReadyPage extends ConsumerStatefulWidget {
  const ArenaProductionReadyPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc206_production_ready_content');
  static const tabsKey = Key('sc206_production_ready_tabs');

  static Key tabKey(String id) => Key('sc206_tab_$id');
  static Key screenKey(String name) => Key('sc206_screen_$name');
  static Key flowStepKey(String id, String label) =>
      Key('sc206_flow_${id}_$label');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaProductionReadyPage> createState() =>
      _ArenaProductionReadyPageState();
}
