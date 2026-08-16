import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_portfolio_overview.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_portfolio_positions.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'earn_portfolio_page.dart';

enum _PortfolioTab { overview, positions, earnings }

enum PositionFilter { all, flexible, locked }

class SavingsPortfolioPage extends ConsumerStatefulWidget {
  const SavingsPortfolioPage({super.key, this.shellRenderMode});

  static const historyButtonKey = Key('sc333_history_button');
  static const positionsTabKey = Key('sc333_tab_positions');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsPortfolioPage> createState() =>
      _SavingsPortfolioPageState();
}
