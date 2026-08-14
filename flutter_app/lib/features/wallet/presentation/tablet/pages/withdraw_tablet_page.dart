import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_common.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_form_sections.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_network_picker.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/transfer/withdraw_preview_sheet.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for Wallet withdrawal flows SC-139/SC-140.
class WithdrawTabletPage extends ConsumerStatefulWidget {
  const WithdrawTabletPage({
    super.key,
    this.asset = 'USDT',
    this.assetScoped = false,
  });

  static const contentKey = Key('sc139_withdraw_tablet_content');

  final String asset;
  final bool assetScoped;

  @override
  ConsumerState<WithdrawTabletPage> createState() => _WithdrawTabletPageState();
}

class _WithdrawTabletPageState extends ConsumerState<WithdrawTabletPage> {
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
    final request = (asset: widget.asset, assetScoped: widget.assetScoped);
    final controllerAsync = ref.watch(withdrawControllerProvider(request));

    return controllerAsync.when(
      loading: () => WalletTabletDetailSurface(
        semanticLabel: 'Rút tiền trên tablet',
        semanticIdentifier: widget.assetScoped
            ? 'SC-140-TABLET'
            : 'SC-139-TABLET',
        title: 'Rút ${widget.asset.toUpperCase()}',
        subtitle: 'Rút tiền · Ví',
        onBack: () => _goBackToWallet(context),
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => WalletTabletDetailSurface(
        semanticLabel: 'Rút tiền trên tablet',
        semanticIdentifier: widget.assetScoped
            ? 'SC-140-TABLET'
            : 'SC-139-TABLET',
        title: 'Rút ${widget.asset.toUpperCase()}',
        subtitle: 'Rút tiền · Ví',
        onBack: () => _goBackToWallet(context),
        primary: VitErrorState(
          title: 'Không tải được dữ liệu rút tiền',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(withdrawControllerProvider(request)),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        final network = controller.selectedNetwork(_selectedNetworkId);
        final validation = controller.validationMessage(
          address: _addressController.text,
          amount: _amountController.text,
          network: network,
        );
        return WalletTabletDetailSurface(
          semanticLabel: 'Rút tiền trên tablet',
          semanticIdentifier: widget.assetScoped
              ? 'SC-140-TABLET'
              : 'SC-139-TABLET',
          title: 'Rút ${snapshot.asset.toUpperCase()}',
          subtitle: 'Rút tiền · Ví',
          onBack: () => _goBackToWallet(context),
          primary: _buildPrimary(controller, network, validation),
          secondary: _buildSecondary(snapshot, network, validation),
        );
      },
    );
  }

  Widget _buildPrimary(
    WithdrawController controller,
    WalletWithdrawNetwork network,
    String? validation,
  ) {
    final snapshot = controller.state.snapshot;
    final canPreview = validation == null;
    return Column(
      key: WithdrawTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WithdrawBalanceCard(asset: snapshot.asset, value: snapshot.available),
        VitPageSection(
          label: 'Mạng rút',
          headerIcon: Icons.hub_outlined,
          headerIconColor: AppModuleAccents.wallet,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppModuleAccents.wallet,
          rhythm: VitPageRhythm.form,
          children: [
            WithdrawNetworkSelector(
              asset: snapshot.asset,
              network: network,
              onTap: () => _openNetworkPicker(snapshot.networks, network.id),
            ),
          ],
        ),
        VitPageSection(
          label: 'Địa chỉ nhận',
          headerIcon: Icons.wallet_outlined,
          headerIconColor: AppModuleAccents.wallet,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppModuleAccents.wallet,
          rhythm: VitPageRhythm.form,
          children: [
            WithdrawAddressInput(
              asset: snapshot.asset,
              network: network,
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
          headerIconColor: AppModuleAccents.wallet,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppModuleAccents.wallet,
          rhythm: VitPageRhythm.form,
          headerTrailing: VitCtaButton(
            onPressed: () {
              _amountController.text = formatWithdrawBalance(
                snapshot.available,
              );
              setState(() {});
            },
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            variant: VitCtaButtonVariant.ghost,
            child: const Text('Tất cả'),
          ),
          children: [
            WithdrawAmountInput(
              asset: snapshot.asset,
              controller: _amountController,
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
        if (validation != null)
          WithdrawPreviewBlockedNotice(message: validation),
        WithdrawNextButton(
          onTap: canPreview ? () => _showPreview(controller, network) : null,
          disabledReason: validation,
        ),
      ],
    );
  }

  Widget _buildSecondary(
    WalletWithdrawSnapshot snapshot,
    WalletWithdrawNetwork network,
    String? validation,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (snapshot.highRiskContractId != null)
          VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Cần xem trước lệnh rút',
            message:
                'Địa chỉ, mạng, số tiền, phí và xác nhận phải được kiểm tra trước khi gửi. Không hoàn tác sau khi xác nhận.',
            contractId: snapshot.highRiskContractId,
          ),
        const VitSectionHeader(
          title: 'An toàn giao dịch',
          subtitle: 'Kiểm tra trước khi xác nhận',
          icon: Icons.shield_outlined,
          iconColor: AppModuleAccents.wallet,
          variant: VitSectionHeaderVariant.plain,
          bottomGap: AppSpacing.pageRhythmFormInnerGap,
        ),
        WithdrawWarning(asset: snapshot.asset, network: network),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitBanner(
          variant: validation == null
              ? VitBannerVariant.info
              : VitBannerVariant.warning,
          message:
              validation ??
              'Bạn có thể xem trước phí, số tiền nhận và địa chỉ đã che trước khi xác nhận.',
          icon: validation == null
              ? Icons.fact_check_outlined
              : Icons.info_outline_rounded,
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        WithdrawSupportLink(
          onTap: () => context.go(
            ContextualSupportContracts.supportRouteFor(
              ContextualSupportFlow.withdrawal,
              referenceId: 'withdraw-${snapshot.asset.toLowerCase()}',
              sourceRoute: widget.assetScoped
                  ? AppRoutePaths.walletWithdrawAsset(snapshot.asset)
                  : AppRoutePaths.walletWithdraw,
              issueLabel: 'Hỗ trợ rút ${snapshot.asset}',
            ),
          ),
        ),
      ],
    );
  }

  void _openNetworkPicker(
    List<WalletWithdrawNetwork> networks,
    String selectedId,
  ) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => WithdrawNetworkPicker(
          networks: networks,
          selectedNetworkId: selectedId,
          onSelected: (network) {
            setState(() => _selectedNetworkId = network.id);
            Navigator.of(sheetContext).pop();
          },
        ),
      ),
    );
  }

  void _showPreview(
    WithdrawController controller,
    WalletWithdrawNetwork network,
  ) {
    final preview = controller.preview(
      address: _addressController.text,
      amount: _amountController.text,
      network: network,
    );
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => WithdrawPreviewSheet(preview: preview),
      ),
    );
  }

  void _goBackToWallet(BuildContext context) {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.wallet,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}
