import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/home_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_asset_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_announcement_banner.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_formatters.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_header.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_market_ticker_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_more_products_sheet.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_next_action_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_portfolio_card.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_products_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_recent_products_section.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_scroll_shell.dart';
import 'package:vit_trade_flutter/features/home/presentation/widgets/phone/home_status_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/home_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part 'home_page_state.dart';
part 'home_page_sections.dart';
part 'home_page_common.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc007_home_scroll_content');
  static const headerKey = Key('sc007_home_header');
  static const announcementKey = Key('sc007_home_announcement');
  static const portfolioCardKey = Key('sc007_home_portfolio_card');
  static const portfolioDepositKey = Key('sc007_home_portfolio_deposit');
  static const nextActionKey = Key('sc007_home_next_action');
  static const marketTickerKey = Key('sc007_home_market_ticker');
  static const productsSectionKey = Key('sc007_home_products_section');
  static const recentProductsKey = Key('sc007_home_recent_products');
  static const recentProductsSectionKey = Key(
    'sc007_home_recent_products_section',
  );
  static const moreProductsSheetKey = Key('sc007_home_more_products_sheet');

  static Key recentProductKey(String id) => Key('sc007_home_recent_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

enum HomeDensityVariant { compact, comfortable }

const double _framedScrollClearance = AppSpacing.buttonStandard + AppSpacing.x7;
const double _nativeScrollClearance = AppSpacing.buttonStandard + AppSpacing.x5;
