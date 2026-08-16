import 'dart:async';

import 'dart:math' as math;

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
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/phone/dca_currency_formatters.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_delete_button.dart';

part 'dca_multi_asset_page_setup.dart';
part 'dca_multi_asset_page_assets_and_performance.dart';
part 'dca_multi_asset_page_common.dart';

enum _MultiAssetTab { setup, assets, performance }

class DCAMultiAssetPage extends ConsumerStatefulWidget {
  const DCAMultiAssetPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc177_multi_asset_content');
  static const addAssetKey = Key('sc177_add_asset');
  static const rebalanceToggleKey = Key('sc177_rebalance_toggle');
  static const budgetFieldKey = Key('sc177_budget_field');
  static const thresholdFieldKey = Key('sc177_threshold_field');

  static Key tabKey(String tabName) => Key('sc177_tab_$tabName');
  static Key assetKey(String symbol) => Key('sc177_asset_$symbol');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAMultiAssetPage> createState() => _DCAMultiAssetPageState();
}
