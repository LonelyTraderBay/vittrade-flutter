import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/wallet_transfer_sections.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_section_header.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

/// Independent Tablet composition for the internal wallet transfer flow SC-146.
class TransferTabletPage extends ConsumerStatefulWidget {
  const TransferTabletPage({super.key});

  static const contentKey = Key('sc146_transfer_tablet_content');
  static const fromWalletKey = Key('sc146_transfer_from_wallet');
  static const toWalletKey = Key('sc146_transfer_to_wallet');
  static const swapKey = Key('sc146_transfer_swap');
  static const assetSelectorKey = Key('sc146_transfer_asset');
  static const amountFieldKey = Key('sc146_transfer_amount');
  static const maxKey = Key('sc146_transfer_max');
  static const submitKey = Key('sc146_transfer_submit');
  static const confirmKey = Key('sc146_transfer_confirm');

  @override
  ConsumerState<TransferTabletPage> createState() => _TransferTabletPageState();
}

class _TransferTabletPageState extends ConsumerState<TransferTabletPage> {
  final TextEditingController _amountController = TextEditingController();
  String _fromWalletId = 'spot';
  String _toWalletId = 'funding';
  String _assetId = 'usdt';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount =>
      double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletTransferProvider);

    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được dữ liệu chuyển nội bộ',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletTransferProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) {
        final fromWallet = _wallet(snapshot, _fromWalletId);
        final toWallet = _wallet(snapshot, _toWalletId);
        final asset = _asset(snapshot, _assetId);
        final usdValue = _amount * asset.usdRate;
        final validationMessage = _transferValidationMessage(asset);
        final canTransfer = validationMessage == null;

        return _frame(
          primary: _buildPrimary(
            snapshot: snapshot,
            fromWallet: fromWallet,
            toWallet: toWallet,
            asset: asset,
            usdValue: usdValue,
            validationMessage: validationMessage,
            canTransfer: canTransfer,
          ),
          secondary: _buildSecondary(snapshot: snapshot),
        );
      },
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Chuyển nội bộ trên tablet',
      semanticIdentifier: 'SC-146-TABLET',
      title: 'Chuyển nội bộ',
      subtitle: 'Chuyển tiền · Ví',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary({
    required WalletTransferSnapshot snapshot,
    required WalletTransferWallet fromWallet,
    required WalletTransferWallet toWallet,
    required WalletTransferAsset asset,
    required double usdValue,
    required String? validationMessage,
    required bool canTransfer,
  }) {
    return Column(
      key: TransferTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Ví nguồn và ví nhận',
          headerIcon: Icons.account_balance_wallet_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            TransferDirectionCard(
              fromKey: TransferTabletPage.fromWalletKey,
              toKey: TransferTabletPage.toWalletKey,
              fromWallet: fromWallet,
              toWallet: toWallet,
              onSwap: _swapWallets,
              onFromTap: () => _showWalletPicker(
                title: 'Chọn ví nguồn',
                snapshot: snapshot,
                excludedWalletId: _toWalletId,
                selectedWalletId: _fromWalletId,
                onSelected: (id) => setState(() => _fromWalletId = id),
              ),
              onToTap: () => _showWalletPicker(
                title: 'Chọn ví nhận',
                snapshot: snapshot,
                excludedWalletId: _fromWalletId,
                selectedWalletId: _toWalletId,
                onSelected: (id) => setState(() => _toWalletId = id),
              ),
            ),
          ],
        ),
        VitPageSection(
          label: 'Tài sản và số lượng',
          headerIcon: Icons.payments_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
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
            if (validationMessage != null)
              TransferValidationNotice(message: validationMessage),
            TransferButton(
              key: TransferTabletPage.submitKey,
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
          ],
        ),
      ],
    );
  }

  Widget _buildSecondary({required WalletTransferSnapshot snapshot}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'An toàn giao dịch',
          subtitle: 'Kiểm tra trước khi xác nhận',
          icon: Icons.shield_outlined,
          iconColor: AppColors.primary,
          variant: VitSectionHeaderVariant.plain,
          bottomGap: AppSpacing.pageRhythmFormInnerGap,
        ),
        if (_amount > 0)
          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Xem lại trước khi chuyển',
            message:
                'Kiểm tra ví nguồn, ví nhận, số lượng và phí trước khi xác nhận. '
                'Không hoàn tác sau khi xác nhận.',
          )
        else
          const TransferInfoNotice(),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitPageSection(
          label: 'Lịch sử gần đây',
          headerIcon: Icons.history_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [RecentTransfersList(transfers: snapshot.recentTransfers)],
        ),
      ],
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
      return 'Nhập số lượng trước khi xem lại chuyển nội bộ.';
    }
    if (_amount <= 0) {
      return 'Số lượng phải lớn hơn 0 trước khi xem lại.';
    }
    if (_amount > asset.available) {
      return 'Số lượng vượt quá khả dụng ${formatTransferAssetAmount(asset.available)} ${asset.symbol}.';
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
        builder: (sheetContext) => VitSheetPanel(
          title: title,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: eligibleWallets.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x4),
            itemBuilder: (context, index) {
              final wallet = eligibleWallets[index];
              return TransferWalletPickerRow(
                wallet: wallet,
                selected: wallet.id == selectedWalletId,
                onTap: () {
                  onSelected(wallet.id);
                  Navigator.of(sheetContext).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showAssetPicker(WalletTransferSnapshot snapshot) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => VitSheetPanel(
          title: 'Chọn tài sản',
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.assets.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x4),
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
                  Navigator.of(sheetContext).pop();
                },
              );
            },
          ),
        ),
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
        builder: (_) => TransferConfirmSheet(
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
