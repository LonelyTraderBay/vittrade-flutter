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
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part 'p2p_merchant_apply_page_state.dart';
part 'p2p_merchant_apply_steps.dart';
part 'p2p_merchant_apply_page_common.dart';

const double _p2pMerchantApplyVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pMerchantApplyNativeNavClearance =
    _p2pMerchantApplyVisualNavClearance - AppSpacing.x4;
const _p2pMerchantApplyBenefitExtent =
    P2PSpacingTokens.p2pMerchantApplyBenefitMainAxisExtent;
const _p2pMerchantApplyConnectorHeight =
    P2PSpacingTokens.p2pMerchantApplyConnectorHeight;
const _p2pMerchantApplyCompactLineHeight =
    P2PSpacingTokens.p2pMerchantApplyCompactLineHeight;
const _p2pMerchantApplyReadableLineHeight =
    P2PSpacingTokens.p2pMerchantApplyReadableLineHeight;
const _p2pMerchantApplyTightLineHeight =
    P2PSpacingTokens.p2pMerchantApplyTightLineHeight;

class P2PMerchantApplyPage extends ConsumerStatefulWidget {
  const P2PMerchantApplyPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc227_p2p_merchant_apply_content');
  static const nextButtonKey = Key('sc227_p2p_merchant_apply_next');
  static const previousButtonKey = Key('sc227_p2p_merchant_apply_previous');
  static const submitButtonKey = Key('sc227_p2p_merchant_apply_submit');
  static const successCtaKey = Key('sc227_p2p_merchant_apply_success_cta');
  static const agreementKey = Key('sc227_p2p_merchant_apply_agreement');
  static const businessNameFieldKey = Key('sc227_business_name');
  static const businessDescriptionFieldKey = Key('sc227_business_description');

  static Key stepKey(int index) => Key('sc227_step_$index');

  static Key businessTypeKey(String value) => Key('sc227_business_type_$value');

  static Key documentKey(String id) => Key('sc227_document_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PMerchantApplyPage> createState() =>
      _P2PMerchantApplyPageState();
}
