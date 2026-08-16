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

part '../../../widgets/orders/p2p_escrow_balance_page_sections.dart';
part '../../../widgets/orders/p2p_escrow_balance_page_common.dart';

const double _p2pEscrowBalanceVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pEscrowBalanceNativeNavClearance =
    _p2pEscrowBalanceVisualNavClearance - AppSpacing.x4;
const double _p2pEscrowBalanceVisualClearance = AppSpacing.x3;
const double _p2pEscrowBalanceNativeClearance = AppSpacing.x2;
const double _p2pEscrowBalanceSectionGap = AppSpacing.x3;
const double _p2pEscrowBalanceTightGap = AppSpacing.x2;
const double _p2pEscrowBalanceIconBox = AppSpacing.x6;
const double _p2pEscrowBalanceEmptyIconBox = AppSpacing.x7;
const double _p2pEscrowBalanceBodyLineHeight = 1.35;
const double _p2pEscrowBalanceAccentLineWidth = AppSpacing.x4;
const double _p2pEscrowBalanceAccentLineHeight = AppSpacing.hairlineStroke * 2;

class P2PEscrowBalancePage extends ConsumerStatefulWidget {
  const P2PEscrowBalancePage({
    super.key,
    this.initialAsset = 'USDT',
    this.shellRenderMode,
  });

  static const heroKey = Key('sc245_p2p_escrow_hero');
  static const infoKey = Key('sc245_p2p_escrow_info');
  static const tabsKey = Key('sc245_p2p_escrow_tabs');
  static const ordersKey = Key('sc245_p2p_escrow_orders');
  static const helpKey = Key('sc245_p2p_escrow_help');
  static const emptyKey = Key('sc245_p2p_escrow_empty');

  final String initialAsset;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PEscrowBalancePage> createState() =>
      _P2PEscrowBalancePageState();
}

class _P2PEscrowBalancePageState extends ConsumerState<P2PEscrowBalancePage> {
  late String _asset;

  @override
  void initState() {
    super.initState();
    _asset = widget.initialAsset;
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pEscrowBalanceProvider(_asset));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pEscrowBalanceVisualNavClearance +
                  _p2pEscrowBalanceVisualClearance
            : _p2pEscrowBalanceNativeNavClearance +
                  _p2pEscrowBalanceNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => VitP2PFlowScaffold(
        semanticLabel: 'Số dư ký quỹ Escrow',
        semanticIdentifier: 'SC-245',
        title: 'Đang tải…',
        onBack: () => context.go(AppRoutePaths.p2p),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitP2PFlowScaffold(
        semanticLabel: 'Số dư ký quỹ Escrow',
        semanticIdentifier: 'SC-245',
        title: 'Không tải được',
        onBack: () => context.go(AppRoutePaths.p2p),
        children: [
          VitErrorState(
            title: 'Không tải được',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pEscrowBalanceProvider(_asset)),
          ),
        ],
      ),
      data: (snapshot) {
        final selectedAsset = snapshot.selectedAsset;
        final selectedBalance = snapshot.assetBalance(selectedAsset);
        final orders = snapshot.ordersFor(selectedAsset);
        if (_asset != selectedAsset) {
          _asset = selectedAsset;
        }
        return VitP2PFlowScaffold(
          semanticLabel: 'Số dư ký quỹ Escrow',
          semanticIdentifier: 'SC-245',
          title: snapshot.title,
          subtitle: snapshot.subtitle,
          onBack: () => context.go(snapshot.parentRoute),
          shellRenderMode: mode,
          bottomInset: scrollEndPadding,
          children: [
            _EscrowHeroCard(balance: selectedBalance),
            _EscrowInfoCard(snapshot: snapshot),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AssetTabs(
                  assets: snapshot.assets,
                  selectedAsset: selectedAsset,
                  onChanged: (asset) {
                    unawaited(HapticFeedback.selectionClick());
                    setState(() => _asset = asset);
                  },
                ),
                const SizedBox(height: _p2pEscrowBalanceTightGap),
                if (orders.isEmpty)
                  _EscrowEmptyState(snapshot: snapshot)
                else
                  _OrdersList(orders: orders),
                if (orders.isNotEmpty) ...[
                  const SizedBox(height: _p2pEscrowBalanceSectionGap),
                  _EscrowHelpCard(snapshot: snapshot),
                ],
              ],
            ),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại số dư escrow',
              message:
                  'Tài sản, số tiền đang giữ, đơn mở, trạng thái rỗng và hướng dẫn escrow được xem lại trước quyết định P2P.',
              contractId: 'SC-245',
            ),
          ],
        );
      },
    );
  }
}
