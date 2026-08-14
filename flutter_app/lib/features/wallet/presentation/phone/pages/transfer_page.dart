import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/widgets/vit_wallet_detail_scaffold.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/wallet_transfer_sections.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

const _transferPrimary = AppColors.primary;

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc146_transfer_content');
  static const fromWalletKey = Key('sc146_transfer_from_wallet');
  static const toWalletKey = Key('sc146_transfer_to_wallet');
  static const swapKey = Key('sc146_transfer_swap');
  static const assetSelectorKey = Key('sc146_transfer_asset');
  static const amountFieldKey = Key('sc146_transfer_amount');
  static const maxKey = Key('sc146_transfer_max');
  static const submitKey = Key('sc146_transfer_submit');
  static const confirmKey = Key('sc146_transfer_confirm');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final TextEditingController _amountController = TextEditingController();
  String _fromWalletId = 'spot';
  String _toWalletId = 'funding';
  String _assetId = 'usdt';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount {
    return double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletTransferProvider);

    return VitWalletDetailScaffold(
      title: 'Chuy\u1ec3n n\u1ed9i b\u1ed9',
      subtitle: 'Chuy\u1ec3n ti\u1ec1n \u00b7 Wallet',
      semanticLabel: 'Chuyển nội bộ',
      semanticIdentifier: 'SC-146',
      contentKey: TransferPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      contentGap: VitContentGap.tight,
      onBack: () => context.go(AppRoutePaths.wallet),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu chuyển nội bộ',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(walletTransferProvider),
          ),
        ],
        data: (snapshot) {
          final fromWallet = _wallet(snapshot, _fromWalletId);
          final toWallet = _wallet(snapshot, _toWalletId);
          final asset = _asset(snapshot, _assetId);
          final usdValue = _amount * asset.usdRate;
          final validationMessage = _transferValidationMessage(asset);
          final canTransfer = validationMessage == null;

          return [
            TransferDirectionCard(
              fromKey: TransferPage.fromWalletKey,
              toKey: TransferPage.toWalletKey,
              fromWallet: fromWallet,
              toWallet: toWallet,
              onSwap: _swapWallets,
              onFromTap: () => _showWalletPicker(
                title: 'Ch\u1ecdn v\u00ed ngu\u1ed3n',
                snapshot: snapshot,
                excludedWalletId: _toWalletId,
                selectedWalletId: _fromWalletId,
                onSelected: (id) => setState(() => _fromWalletId = id),
              ),
              onToTap: () => _showWalletPicker(
                title: 'Ch\u1ecdn v\u00ed nh\u1eadn',
                snapshot: snapshot,
                excludedWalletId: _fromWalletId,
                selectedWalletId: _toWalletId,
                onSelected: (id) => setState(() => _toWalletId = id),
              ),
            ),
            TransferAmountCard(
              controller: _amountController,
              asset: asset,
              errorText: validationMessage,
              onAssetTap: () => _showAssetPicker(snapshot),
              onChanged: () => setState(() {}),
              onMax: () {
                _amountController.text = formatTransferAssetAmount(
                  asset.available,
                );
                setState(() {});
              },
            ),
            if (_amount > 0) TransferAmountEstimate(usdValue: usdValue),
            if (_amount > 0)
              const VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem lại trước khi chuyển',
                message:
                    'Kiểm tra ví nguồn, ví nhận, số lượng và phí trước khi xác nhận. '
                    'Không hoàn tác sau khi xác nhận. Bước tiếp theo: ghi nhận lệnh chuyển nội bộ.',
                // WalletTransferSnapshot has no highRiskContractId — do not invent one.
              ),
            if (validationMessage != null)
              TransferValidationNotice(message: validationMessage),
            TransferButton(
              key: TransferPage.submitKey,
              enabled: canTransfer,
              disabledReason: validationMessage,
              onTap: canTransfer
                  ? () => _showConfirmSheet(
                      fromWallet: fromWallet,
                      toWallet: toWallet,
                      asset: asset,
                      amount: _amount,
                      usdValue: usdValue,
                    )
                  : null,
            ),
            VitPageSection(
              label: 'L\u1ecbch s\u1eed g\u1ea7n \u0111\u00e2y',
              headerIcon: Icons.history_rounded,
              headerIconColor: _transferPrimary,
              headerVariant: VitSectionHeaderVariant.plain,
              accentColor: _transferPrimary,
              innerGap: AppSpacing.pageRhythmFormInnerGap,
              children: [
                RecentTransfersList(transfers: snapshot.recentTransfers),
              ],
            ),
          ];
        },
      ),
    );
  }

  WalletTransferWallet _wallet(
    WalletTransferSnapshot snapshot,
    String walletId,
  ) {
    return snapshot.wallets.firstWhere(
      (wallet) => wallet.id == walletId,
      orElse: () => snapshot.wallets.first,
    );
  }

  WalletTransferAsset _asset(WalletTransferSnapshot snapshot, String assetId) {
    return snapshot.assets.firstWhere(
      (asset) => asset.id == assetId,
      orElse: () => snapshot.assets.first,
    );
  }

  void _swapWallets() {
    setState(() {
      final from = _fromWalletId;
      _fromWalletId = _toWalletId;
      _toWalletId = from;
    });
  }

  String? _transferValidationMessage(WalletTransferAsset asset) {
    final rawAmount = _amountController.text.trim();
    if (rawAmount.isEmpty) {
      return 'Nh\u1eadp s\u1ed1 l\u01b0\u1ee3ng tr\u01b0\u1edbc khi xem l\u1ea1i chuy\u1ec3n n\u1ed9i b\u1ed9.';
    }
    if (_amount <= 0) {
      return 'S\u1ed1 l\u01b0\u1ee3ng ph\u1ea3i l\u1edbn h\u01a1n 0 tr\u01b0\u1edbc khi xem l\u1ea1i.';
    }
    if (_amount > asset.available) {
      return 'S\u1ed1 l\u01b0\u1ee3ng v\u01b0\u1ee3t qu\u00e1 kh\u1ea3 d\u1ee5ng ${formatTransferAssetAmount(asset.available)} ${asset.symbol}.';
    }
    return null;
  }

  void _showWalletPicker({
    required String title,
    required WalletTransferSnapshot snapshot,
    required String excludedWalletId,
    required String selectedWalletId,
    required ValueChanged<String> onSelected,
  }) {
    final eligibleWallets = snapshot.wallets
        .where((wallet) => wallet.id != excludedWalletId)
        .toList(growable: false);

    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return VitSheetPanel(
            title: title,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: eligibleWallets.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x1),
              itemBuilder: (context, index) {
                final wallet = eligibleWallets[index];
                return TransferWalletPickerRow(
                  wallet: wallet,
                  selected: wallet.id == selectedWalletId,
                  onTap: () {
                    onSelected(wallet.id);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showAssetPicker(WalletTransferSnapshot snapshot) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return VitSheetPanel(
            title: 'Ch\u1ecdn t\u00e0i s\u1ea3n',
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.assets.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x1),
              itemBuilder: (context, index) {
                final asset = snapshot.assets[index];
                return TransferAssetPickerRow(
                  asset: asset,
                  selected: asset.id == _assetId,
                  onTap: () {
                    setState(() {
                      _assetId = asset.id;
                      _amountController.clear();
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showConfirmSheet({
    required WalletTransferWallet fromWallet,
    required WalletTransferWallet toWallet,
    required WalletTransferAsset asset,
    required double amount,
    required double usdValue,
  }) {
    final pageContext = context;
    unawaited(
      showVitBottomSheet<void>(
        context: pageContext,
        isScrollControlled: true,
        builder: (context) => TransferConfirmSheet(
          fromWallet: fromWallet,
          toWallet: toWallet,
          asset: asset,
          amount: amount,
          usdValue: usdValue,
          onConfirm: () {
            Navigator.of(context).pop();
            _amountController.clear();
            setState(() {});
            if (mounted) {
              unawaited(
                showVitNoticeSheet(
                  context: pageContext,
                  title: 'Chuyển thành công',
                  message: 'Lệnh chuyển nội bộ đã được ghi nhận.',
                  variant: VitBannerVariant.success,
                  ctaVariant: VitCtaButtonVariant.success,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
