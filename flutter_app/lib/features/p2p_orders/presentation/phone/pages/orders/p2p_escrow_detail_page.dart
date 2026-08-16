import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_notice_widgets.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/orders/p2p_escrow_detail_status_address.dart';
part '../../../widgets/orders/p2p_escrow_detail_multisig_order.dart';
part '../../../widgets/orders/p2p_escrow_detail_timeline_actions.dart';

const double _p2pEscrowVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pEscrowNativeNavClearance =
    _p2pEscrowVisualNavClearance - AppSpacing.x4;
const double _p2pEscrowVisualClearance = AppSpacing.x3;
const double _p2pEscrowNativeClearance = AppSpacing.x2;
const double _p2pEscrowSectionGap = AppSpacing.x3;
const double _p2pEscrowTightGap = AppSpacing.x2;
const double _p2pEscrowRingSize = AppSpacing.buttonCompact + AppSpacing.x2;
const double _p2pEscrowTimelineConnectorHeight = AppSpacing.x4;
const double _p2pEscrowBodyLineHeight = 1.35;

class P2PEscrowDetailPage extends ConsumerStatefulWidget {
  const P2PEscrowDetailPage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc246_p2p_escrow_detail_hero');
  static const addressKey = Key('sc246_p2p_escrow_detail_address');
  static const copyKey = Key('sc246_p2p_escrow_detail_copy');
  static const revealKey = Key('sc246_p2p_escrow_detail_reveal');
  static const explorerKey = Key('sc246_p2p_escrow_detail_explorer');
  static const multisigKey = Key('sc246_p2p_escrow_detail_multisig');
  static const orderInfoKey = Key('sc246_p2p_escrow_detail_order_info');
  static const timelineKey = Key('sc246_p2p_escrow_detail_timeline');
  static const securityKey = Key('sc246_p2p_escrow_detail_security');
  static const orderLinkKey = Key('sc246_p2p_escrow_detail_order_link');
  static const feedbackKey = Key('sc246_p2p_escrow_detail_feedback');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PEscrowDetailPage> createState() =>
      _P2PEscrowDetailPageState();
}

class _P2PEscrowDetailPageState extends ConsumerState<P2PEscrowDetailPage> {
  bool _showFullAddress = false;
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pEscrowDetailProvider(widget.orderId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pEscrowVisualNavClearance + _p2pEscrowVisualClearance
            : _p2pEscrowNativeNavClearance + _p2pEscrowNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        semanticLabel: 'Chi tiết Escrow',
        semanticIdentifier: 'SC-246',
        title: 'Đang tải…',
        onBack: () => context.go(AppRoutePaths.p2pOrder(widget.orderId)),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        semanticLabel: 'Chi tiết Escrow',
        semanticIdentifier: 'SC-246',
        title: 'Không tải được',
        onBack: () => context.go(AppRoutePaths.p2pOrder(widget.orderId)),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(p2pEscrowDetailProvider(widget.orderId)),
          ),
        ],
      ),
      data: (snapshot) {
        final order = snapshot.order;
        return VitP2PFlowScaffold(
          semanticLabel: 'Chi tiết Escrow',
          semanticIdentifier: 'SC-246',
          title: 'Chi tiết Escrow',
          subtitle: 'Escrow · P2P',
          onBack: () => context.go(snapshot.parentRoute),
          shellRenderMode: mode,
          bottomInset: scrollEndPadding,
          children: [
            _EscrowStatusHero(snapshot: snapshot),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _EscrowAddressCard(
                  snapshot: snapshot,
                  showFullAddress: _showFullAddress,
                  onReveal: () {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _showFullAddress = !_showFullAddress);
                  },
                  onCopy: () {
                    unawaited(HapticFeedback.selectionClick());
                    unawaited(
                      Clipboard.setData(
                        ClipboardData(text: snapshot.escrowAddress),
                      ),
                    );
                    setState(() => _feedback = 'Đã copy địa chỉ escrow');
                  },
                  onExplorer: () {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _feedback = 'Đã mở Blockchain Explorer');
                  },
                ),
                if (_feedback != null) ...[
                  const SizedBox(height: _p2pEscrowTightGap),
                  _FeedbackBanner(message: _feedback!),
                ],
              ],
            ),
            _MultiSigCard(snapshot: snapshot),
            _OrderInfoCard(order: order),
            _EscrowTimelineCard(events: snapshot.timeline),
            _SecurityNotice(snapshot: snapshot),
            _OrderLink(orderId: widget.orderId),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại chi tiết escrow',
              message:
                  'Địa chỉ escrow đã che, thao tác hiện/copy, trạng thái multisig, liên kết đơn, timeline và bước an toàn tiếp theo được xem lại trước thao tác tiền.',
              contractId: 'p2p-escrow-detail-review',
            ),
          ],
        );
      },
    );
  }
}
