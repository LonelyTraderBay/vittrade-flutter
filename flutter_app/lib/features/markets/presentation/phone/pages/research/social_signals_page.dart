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
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/market_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/market_formatters.dart';

part 'social_signals_page_tabs_widgets.dart';
part 'social_signals_page_signal_provider_widgets.dart';
part 'social_signals_page_performance_widgets.dart';

const _marketPrimary = AppColors.primary;

class SocialSignalsPage extends ConsumerStatefulWidget {
  const SocialSignalsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc025_social_signals_scroll_content');
  static const signalsTabKey = Key('sc025_tab_signals');
  static const providersTabKey = Key('sc025_tab_providers');
  static const performanceTabKey = Key('sc025_tab_performance');
  static const statusAllKey = Key('sc025_status_all');
  static const statusActiveKey = Key('sc025_status_active');
  static const statusTargetHitKey = Key('sc025_status_target_hit');
  static const statusStoppedKey = Key('sc025_status_stopped');
  static const categoryAllKey = Key('sc025_category_all');
  static const categoryScalpKey = Key('sc025_category_scalp');
  static const categorySwingKey = Key('sc025_category_swing');
  static const categoryPositionKey = Key('sc025_category_position');

  static Key signalCardKey(String id) => Key('sc025_signal_$id');
  static Key providerCardKey(String name) => Key('sc025_provider_$name');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SocialSignalsPage> createState() => _SocialSignalsPageState();
}
