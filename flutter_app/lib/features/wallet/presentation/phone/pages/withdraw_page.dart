import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';

import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';

import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';

import 'package:vit_trade_flutter/features/wallet/presentation/phone/widgets/vit_wallet_detail_scaffold.dart';

import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_common.dart';

import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_form_sections.dart';

import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_network_picker.dart';

import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_preview_sheet.dart';

import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';

import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';

import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class WithdrawPage extends ConsumerStatefulWidget {
  const WithdrawPage({
    super.key,

    this.asset = 'USDT',

    this.assetScoped = false,

    this.shellRenderMode,
  });

  static const contentKey = withdrawContentKey;

  static const networkSelectorKey = withdrawNetworkSelectorKey;

  static const addressFieldKey = withdrawAddressFieldKey;

  static const amountFieldKey = withdrawAmountFieldKey;

  static const allAmountKey = withdrawAllAmountKey;

  static const nextKey = withdrawNextKey;

  static const supportKey = withdrawSupportKey;

  static const cancelConfirmKey = withdrawCancelConfirmKey;

  static const confirmWithdrawKey = withdrawConfirmWithdrawKey;

  static Key networkKey(String id) => withdrawNetworkKey(id);

  static Key recentAddressKey(String label) => withdrawRecentAddressKey(label);

  final String asset;

  final bool assetScoped;

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends ConsumerState<WithdrawPage> {
  late final TextEditingController _addressController;

  late final TextEditingController _amountController;

  String? _selectedNetworkId;

  @override
  void initState() {
    super.initState();

    _addressController = TextEditingController();

    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _addressController.dispose();

    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerRequest = (
      asset: widget.asset,
      assetScoped: widget.assetScoped,
    );
    final controllerAsync = ref.watch(
      withdrawControllerProvider(controllerRequest),
    );

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    const formInnerGap = AppSpacing.pageRhythmFormInnerGap;

    return VitWalletDetailScaffold(
      title: 'Rút ${widget.asset.toUpperCase()}',

      subtitle: 'Rút tiền · Wallet',

      semanticLabel: widget.assetScoped ? 'Rút tiền theo tài sản' : 'Rút tiền',
      semanticIdentifier: widget.assetScoped ? 'SC-140' : 'SC-139',

      contentKey: WithdrawPage.contentKey,
      shellRenderMode: mode,

      onBack: () => goBackOrFallback(
        context,

        fallbackPath: AppRoutePaths.wallet,

        mode: BackNavigationMode.historyThenFallback,
      ),

      children: controllerAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu rút tiền',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(withdrawControllerProvider(controllerRequest)),
          ),
        ],
        data: (controller) {
          final snapshot = controller.state.snapshot;
          final selected = controller.selectedNetwork(_selectedNetworkId);
          final validationMessage = controller.validationMessage(
            address: _addressController.text,
            amount: _amountController.text,
            network: selected,
          );
          final canPreview = validationMessage == null;

          return [
            if (snapshot.highRiskContractId != null)
              VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,

                title: 'Cần xem trước lệnh rút',

                message:
                    'Địa chỉ, mạng, số tiền, phí và xác nhận được theo dõi trong một hợp đồng chuyển tiền ví. Không hoàn tác sau khi xác nhận.',

                contractId: snapshot.highRiskContractId,
              ),

            WithdrawBalanceCard(
              asset: snapshot.asset,
              value: snapshot.available,
            ),

            VitPageSection(
              label: 'Mạng rút',

              headerIcon: Icons.hub_outlined,

              headerIconColor: withdrawPrimary,

              headerVariant: VitSectionHeaderVariant.plain,

              accentColor: withdrawPrimary,

              innerGap: formInnerGap,

              children: [
                WithdrawNetworkSelector(
                  asset: snapshot.asset,

                  network: selected,

                  onTap: () => _openNetworkPicker(controller),
                ),
              ],
            ),

            VitPageSection(
              label: 'Địa chỉ nhận',

              headerIcon: Icons.wallet_outlined,

              headerIconColor: withdrawPrimary,

              headerVariant: VitSectionHeaderVariant.plain,

              accentColor: withdrawPrimary,

              actionLabel: 'Quét QR',

              actionShowChevron: false,

              actionSemanticLabel: 'Scan withdrawal address QR code',

              onAction: _showScanNotice,

              innerGap: formInnerGap,

              children: [
                WithdrawAddressInput(
                  asset: snapshot.asset,

                  network: selected,

                  controller: _addressController,

                  onChanged: (_) => setState(() {}),
                ),

                WithdrawRecentAddresses(
                  addresses: snapshot.recentAddresses,

                  onSelect: (address) {
                    _addressController.text = address.address;

                    setState(() {});
                  },
                ),
              ],
            ),

            VitPageSection(
              label: 'Số lượng',

              headerIcon: Icons.payments_outlined,

              headerIconColor: withdrawPrimary,

              headerVariant: VitSectionHeaderVariant.plain,

              accentColor: withdrawPrimary,

              actionLabel: 'Tất cả',

              actionKey: withdrawAllAmountKey,

              actionShowChevron: false,

              actionSemanticLabel: 'Dùng toàn bộ số dư có thể rút',

              onAction: () {
                _amountController.text = formatWithdrawBalance(
                  snapshot.available,
                );

                setState(() {});
              },

              innerGap: formInnerGap,

              children: [
                WithdrawAmountInput(
                  asset: snapshot.asset,

                  controller: _amountController,

                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),

            VitPageSection(
              label: 'An toàn',

              headerIcon: Icons.shield_outlined,

              headerIconColor: withdrawAmber,

              headerVariant: VitSectionHeaderVariant.plain,

              accentColor: withdrawAmber,

              innerGap: formInnerGap,

              children: [
                WithdrawWarning(asset: snapshot.asset, network: selected),
              ],
            ),

            if (validationMessage != null)
              WithdrawPreviewBlockedNotice(message: validationMessage),

            WithdrawNextButton(
              onTap: canPreview
                  ? () => _showConfirmPreview(controller, selected)
                  : null,

              disabledReason: validationMessage,
            ),

            WithdrawSupportLink(
              onTap: () => context.go(
                ContextualSupportContracts.supportRouteFor(
                  ContextualSupportFlow.withdrawal,

                  referenceId: 'withdraw-${snapshot.asset.toLowerCase()}',

                  sourceRoute: widget.assetScoped
                      ? AppRoutePaths.walletWithdrawAsset(snapshot.asset)
                      : AppRoutePaths.walletWithdraw,

                  issueLabel: 'Withdrawal support for ${snapshot.asset}',
                ),
              ),
            ),
          ];
        },
      ),
    );
  }

  void _openNetworkPicker(WithdrawController controller) {
    final networks = controller.state.snapshot.networks;

    unawaited(
      showVitBottomSheet<void>(
        context: context,

        isScrollControlled: true,

        builder: (context) {
          return WithdrawNetworkPicker(
            networks: networks,

            selectedNetworkId: controller
                .selectedNetwork(_selectedNetworkId)
                .id,

            onSelected: (network) {
              setState(() => _selectedNetworkId = network.id);

              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }

  void _showScanNotice() {
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sắp ra mắt',
        message: 'Quét QR sẽ mở khi trình quét ví được kết nối',
      ),
    );
  }

  void _showConfirmPreview(
    WithdrawController controller,

    WalletWithdrawNetwork network,
  ) {
    final amount = _amountController.text.trim().isEmpty
        ? '0'
        : _amountController.text.trim();

    final address = _addressController.text.trim().isEmpty
        ? 'Chưa nhập'
        : _addressController.text.trim();

    final preview = controller.preview(
      address: address,

      amount: amount,

      network: network,
    );

    unawaited(
      showVitBottomSheet<void>(
        context: context,

        isScrollControlled: true,

        builder: (context) => WithdrawPreviewSheet(preview: preview),
      ),
    );
  }
}
