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
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part 'arena_prediction_bridge_foundation_page_principles_section.dart';
part 'arena_prediction_bridge_foundation_page_topics_boundary_bridge_sections.dart';
part 'arena_prediction_bridge_foundation_page_examples_and_shared_widgets.dart';

enum _BridgeSection { principles, topics, boundary, bridge, examples }

const _bridgeHeroLineHeight = 1.08;
const _bridgeIntroLineHeight = 1.16;
const _bridgeTitleLineHeight = 1.12;
const _bridgeBodyLineHeight = 1.22;
const _bridgeMetricLineHeight = 1.12;

class ArenaPredictionBridgeFoundationPage extends ConsumerStatefulWidget {
  const ArenaPredictionBridgeFoundationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc207_bridge_content');
  static const tabsKey = Key('sc207_bridge_tabs');
  static const predictionProfileKey = Key('sc207_profile_predictions');
  static const arenaProfileKey = Key('sc207_profile_arena');

  static Key tabKey(String id) => Key('sc207_tab_$id');
  static Key topicKey(String id) => Key('sc207_topic_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaPredictionBridgeFoundationPage> createState() =>
      _ArenaPredictionBridgeFoundationPageState();
}
