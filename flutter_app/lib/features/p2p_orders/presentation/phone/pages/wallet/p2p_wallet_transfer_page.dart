import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
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
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_notice_widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/wallet/p2p_wallet_transfer_form.dart';
part '../../../widgets/wallet/p2p_wallet_transfer_amount.dart';
part '../../../widgets/wallet/p2p_wallet_transfer_confirm.dart';

const _p2pTransferMajorGap = AppSpacing.x3;
const _p2pTransferTightGap = AppSpacing.x2;
const _p2pTransferSwitchSize = AppSpacing.searchBarCompactHeight;
const _p2pTransferAssetTileMinHeight = AppSpacing.x7 + AppSpacing.x3;
const _p2pTransferAssetMarkSize = AppSpacing.searchBarCompactHeight;
const _p2pTransferAssetIcon = AppSpacing.iconMd;
const _p2pTransferConfirmIconBox = AppSpacing.x7;
const _p2pTransferConfirmIcon = AppSpacing.iconLg;
const _p2pTransferConfirmButtonHeight = AppSpacing.searchBarCompactHeight;
const _p2pTransferVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const _p2pTransferNativeNavClearance =
    _p2pTransferVisualNavClearance - AppSpacing.x4;
const _p2pTransferVisualClearance = AppSpacing.x3;
const _p2pTransferNativeClearance = AppSpacing.x2;

class P2PWalletTransferPage extends ConsumerStatefulWidget {
  const P2PWalletTransferPage({
    super.key,
    this.initialAsset,
    this.initialType,
    this.shellRenderMode,
  });

  static const directionKey = Key('sc261_p2p_wallet_transfer_direction');
  static const switchKey = Key('sc261_p2p_wallet_transfer_switch');
  static const assetSelectorKey = Key('sc261_p2p_wallet_transfer_assets');
  static const amountFieldKey = Key('sc261_p2p_wallet_transfer_amount');
  static const maxKey = Key('sc261_p2p_wallet_transfer_max');
  static const submitKey = Key('sc261_p2p_wallet_transfer_submit');
  static const confirmKey = Key('sc261_p2p_wallet_transfer_confirm');
  static const feeKey = Key('sc261_p2p_wallet_transfer_fee');
  static const escrowNoteKey = Key('sc261_p2p_wallet_transfer_escrow_note');
  static const confirmPanelKey = Key('sc261_p2p_wallet_transfer_confirm_panel');

  static Key assetKey(String symbol) =>
      Key('sc261_p2p_wallet_transfer_asset_$symbol');
  static Key activeAssetKey(String symbol) =>
      Key('sc261_p2p_wallet_transfer_active_asset_$symbol');

  static Key percentKey(int value) =>
      Key('sc261_p2p_wallet_transfer_percent_$value');

  final String? initialAsset;
  final String? initialType;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PWalletTransferPage> createState() =>
      _P2PWalletTransferPageState();
}

class _P2PWalletTransferPageState extends ConsumerState<P2PWalletTransferPage> {
  late final TextEditingController _amountController;
  late String _asset;
  late String _type;
  bool _showConfirm = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _asset = (widget.initialAsset ?? 'USDT').toUpperCase();
    _type = widget.initialType == 'withdraw' ? 'withdraw' : 'deposit';
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount =>
      double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      p2pWalletTransferProvider((asset: _asset, type: _type)),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pTransferVisualNavClearance + _p2pTransferVisualClearance
            : _p2pTransferNativeNavClearance + _p2pTransferNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chuyển tiền trong ví P2P',
      semanticIdentifier: 'SC-261',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pWallet),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pWallet),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                p2pWalletTransferProvider((asset: _asset, type: _type)),
              ),
            ),
          ),
          data: (snapshot) {
            if (!snapshot.assets.any((item) => item.symbol == _asset)) {
              _asset = snapshot.defaultAsset;
            }
            final source = snapshot.sourceBalance(_type, _asset);
            final destination = snapshot.destinationBalance(_type, _asset);
            final canTransfer = _amount > 0 && _amount <= source.available;
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: _showConfirm ? 'Xác nhận chuyển tiền' : 'Chuyển tiền',
                subtitle: 'Ví · P2P',
                showBack: true,
                onBack: () {
                  if (_showConfirm) {
                    setState(() => _showConfirm = false);
                    return;
                  }
                  context.go(snapshot.parentRoute);
                },
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding:
                            P2PSpacingTokens.p2pWalletTransferScrollPadding(
                              scrollEndPadding,
                            ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.standard,
                          padding: VitContentPadding.none,
                          // Confirm step uses relaxed breathing room (SDD B2).
                          density: _showConfirm
                              ? VitDensity.relaxed
                              : VitDensity.compact,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            if (_showConfirm)
                              _ConfirmTransferView(
                                snapshot: snapshot,
                                source: source,
                                destination: destination,
                                amount: _amount,
                                asset: _asset,
                                onEdit: () =>
                                    setState(() => _showConfirm = false),
                                onConfirm: () {
                                  unawaited(HapticFeedback.mediumImpact());
                                  context.go(snapshot.parentRoute);
                                },
                              )
                            else
                              _TransferForm(
                                snapshot: snapshot,
                                source: source,
                                destination: destination,
                                type: _type,
                                asset: _asset,
                                amountController: _amountController,
                                amount: _amount,
                                canTransfer: canTransfer,
                                onSwitch: _switchDirection,
                                onAssetChanged: _setAsset,
                                onMax: () => _setAmount(source.available),
                                onPercent: (percent) => _setAmount(
                                  source.available * percent / 100,
                                ),
                                onAmountChanged: () => setState(() {}),
                                onSubmit: canTransfer
                                    ? () {
                                        unawaited(
                                          HapticFeedback.mediumImpact(),
                                        );
                                        setState(() => _showConfirm = true);
                                      }
                                    : null,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _switchDirection() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _type = _type == 'deposit' ? 'withdraw' : 'deposit';
      _amountController.clear();
      _showConfirm = false;
    });
  }

  void _setAsset(String symbol) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _asset = symbol;
      _amountController.clear();
      _showConfirm = false;
    });
  }

  void _setAmount(double value) {
    unawaited(HapticFeedback.selectionClick());
    _amountController.text = _formatTransferAmount(value, _asset);
    setState(() {});
  }
}
