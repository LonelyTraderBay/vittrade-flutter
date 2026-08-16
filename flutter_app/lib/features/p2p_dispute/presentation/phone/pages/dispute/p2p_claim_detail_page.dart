import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part 'p2p_claim_detail_page_state.dart';
part 'p2p_claim_detail_page_sections.dart';
part 'p2p_claim_detail_page_common.dart';

enum _ClaimDetailSection { timeline, evidence, notes }

const double _p2pClaimDividerExtent = AppSpacing.dividerHairline;
const double _p2pClaimProgressLineExtent =
    P2PSpacingTokens.p2pClaimProgressLineHeight;
const double _p2pClaimIconBoxExtent = AppSpacing.x7;
const double _p2pClaimTimelineNodeExtent =
    P2PSpacingTokens.p2pClaimTimelineNodeSize;
const double _p2pClaimTimelineConnectorExtent =
    P2PSpacingTokens.p2pClaimTimelineConnectorHeight;
const double _p2pClaimBodyLine = P2PSpacingTokens.p2pClaimBodyLineHeight;
const double _p2pClaimDescriptionLine =
    P2PSpacingTokens.p2pClaimDescriptionLineHeight;

class P2PClaimDetailPage extends ConsumerStatefulWidget {
  const P2PClaimDetailPage({
    super.key,
    required this.claimId,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc243_p2p_claim_hero');
  static const benchmarksKey = Key('sc243_p2p_claim_benchmarks');
  static const descriptionKey = Key('sc243_p2p_claim_description');
  static const tabsKey = Key('sc243_p2p_claim_tabs');
  static const timelineKey = Key('sc243_p2p_claim_timeline');
  static const evidenceKey = Key('sc243_p2p_claim_evidence');
  static const notesKey = Key('sc243_p2p_claim_notes');
  static const notificationsKey = Key('sc243_p2p_claim_notifications');
  static const orderLinkKey = Key('sc243_p2p_claim_order_link');
  static const supportLinkKey = Key('sc243_p2p_claim_support_link');
  static const receiptKey = Key('sc243_p2p_claim_receipt');
  static const feedbackKey = Key('sc243_p2p_claim_feedback');

  final String claimId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PClaimDetailPage> createState() => _P2PClaimDetailPageState();
}
