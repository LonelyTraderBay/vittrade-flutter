import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part 'wallet_page_balance_sections.dart';
part 'wallet_page_dca_tool_sections.dart';
part 'wallet_page_asset_sections.dart';
part 'wallet_page_allocation_sections.dart';

const _walletPanel = AppColors.surface;
const _walletPrimary = AppModuleAccents.wallet;
const _walletGreen = AppColors.buy;
const _walletRed = AppColors.sell;
const _walletAmber = AppColors.caution;
const _walletPurple = AppColors.accent;
