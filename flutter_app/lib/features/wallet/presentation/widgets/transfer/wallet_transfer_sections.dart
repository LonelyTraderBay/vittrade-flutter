import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_asset_avatar.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_choice_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_icon_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_input.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/wallet_formatters.dart';

part 'wallet_transfer_confirm_sheet.dart';
part 'wallet_transfer_wallet_cards.dart';
part 'wallet_transfer_asset_amount.dart';
part 'wallet_transfer_history_picker.dart';

const _transferPrimary = AppColors.primary;
const _transferGreen = AppColors.buy;
final _transferInlineGap = AppSurfaceSpacing.rowGap;
final _transferIconBox = AppSurfaceSpacing.buttonCompact;
const _transferActionIcon = WalletSpacingTokens.transferActionIcon;

String formatTransferUsd(double value) => formatWalletUsdGrouped(value);

String formatTransferAssetAmount(double value) {
  final decimals = value >= 1000 ? 2 : 4;
  return walletGroupThousands(value.toStringAsFixed(decimals));
}
