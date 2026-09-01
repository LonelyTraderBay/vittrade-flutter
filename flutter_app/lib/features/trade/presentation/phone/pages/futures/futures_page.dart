import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_simple_shell.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_simple_hero.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/phone/vit_trade_confirm_sheet.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_high_risk_status_ui.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../../widgets/futures/futures_page_state.dart';
part '../../../widgets/futures/futures_page_form_controls.dart';

const _futuresRed = AppColors.sell;
const _futuresGreen = AppColors.buy;

class FuturesPage extends ConsumerStatefulWidget {
  const FuturesPage({super.key, required this.pairId, this.shellRenderMode});

  static const closeKey = Key('sc057_close');
  static const marginFieldKey = Key('sc057_margin_field');
  static const submitKey = Key('sc057_submit');

  static Key quickNavKey(String id) => Key('sc057_quick_$id');
  static Key sideKey(String id) => Key('sc057_side_$id');
  static Key pctKey(int pct) => Key('sc057_pct_$pct');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<FuturesPage> createState() => _FuturesPageState();
}
