import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_common.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_form.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_preview.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

/// Independent Tablet composition for the high-risk address-book flow SC-143.
class AddressAddTabletPage extends ConsumerStatefulWidget {
  const AddressAddTabletPage({super.key});

  static const contentKey = Key('sc143_address_add_tablet_content');
  static const labelFieldKey = Key('sc143_address_label_field');
  static const addressFieldKey = Key('sc143_address_address_field');
  static const memoFieldKey = Key('sc143_address_memo_field');
  static const whitelistKey = Key('sc143_address_whitelist');
  static const agreementKey = Key('sc143_address_agreement');
  static const saveKey = Key('sc143_address_save');
  static Key networkKey(String id) => Key('sc143_address_network_$id');
  static Key assetKey(String asset) => Key('sc143_address_asset_$asset');

  @override
  ConsumerState<AddressAddTabletPage> createState() =>
      _AddressAddTabletPageState();
}

class _AddressAddTabletPageState extends ConsumerState<AddressAddTabletPage> {
  late final TextEditingController _labelController;
  late final TextEditingController _addressController;
  late final TextEditingController _memoController;
  String _networkId = 'erc20';
  String _asset = 'ETH';
  bool _whitelist = false;
  bool _agreed = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _labelController = TextEditingController();
    _addressController = TextEditingController();
    _memoController = TextEditingController();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  bool _canSave(AddressAddController controller) {
    return controller.canPreview(
      label: _labelController.text,
      address: _addressController.text,
      agreed: _agreed,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_saved) return _buildSaved();

    final controllerAsync = ref.watch(addressAddControllerProvider);
    return controllerAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được dữ liệu sổ địa chỉ',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletAddressAddSnapshotProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        final sections = AddressAddForm.sections(
          snapshot: snapshot,
          selectedNetworkId: _networkId,
          selectedAsset: _asset,
          labelController: _labelController,
          addressController: _addressController,
          memoController: _memoController,
          whitelist: _whitelist,
          agreed: _agreed,
          onNetworkChanged: (id) => setState(() => _networkId = id),
          onAssetChanged: (asset) => setState(() => _asset = asset),
          onWhitelistChanged: () => setState(() => _whitelist = !_whitelist),
          onAgreementChanged: () => setState(() => _agreed = !_agreed),
          onInputChanged: () => setState(() {}),
        );

        return _frame(
          primary: Column(
            key: AddressAddTabletPage.contentKey,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: sections.take(2).toList(growable: false),
          ),
          secondary: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              sections[2],
              const SizedBox(height: TabletSpacingTokens.x4),
              AddressPrimaryActionButton(
                key: AddressAddTabletPage.saveKey,
                enabled: _canSave(controller),
                semanticLabel: 'Lưu địa chỉ ví trên tablet',
                label: 'Lưu địa chỉ',
                onTap: () => _showConfirmPreview(controller),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Thêm địa chỉ ví trên tablet',
      semanticIdentifier: 'SC-143-TABLET',
      title: 'Thêm địa chỉ mới',
      subtitle: 'Sổ địa chỉ · Ví',
      onBack: () => _goBackToAddressBook(context),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildSaved() {
    return _frame(
      primary: const VitHighRiskStatePanel(
        state: VitHighRiskUiState.success,
        title: 'Đã lưu thành công!',
        message: 'Địa chỉ đã được thêm vào sổ địa chỉ ví.',
        contractId: 'Address book save',
      ),
      secondary: VitCard(
        density: VitDensity.compact,
        borderColor: AppColors.buy20,
        child: VitInfoRow(
          label: 'Danh sách trắng',
          value: _whitelist
              ? 'Đã thêm vào danh sách trắng'
              : 'Chưa vào danh sách trắng - có thể bật sau',
          leading: const Icon(Icons.shield_outlined),
          valueColor: AppColors.buy,
          density: VitDensity.compact,
        ),
      ),
    );
  }

  void _showConfirmPreview(AddressAddController controller) {
    if (!_canSave(controller)) return;

    final preview = controller.preview(
      label: _labelController.text,
      address: _addressController.text,
      memo: _memoController.text,
      selectedNetworkId: _networkId,
      selectedAsset: _asset,
      whitelist: _whitelist,
    );
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => AddressConfirmPreviewSheet(
          preview: preview,
          onConfirm: () {
            Navigator.of(sheetContext).pop();
            setState(() => _saved = true);
            Future<void>.delayed(const Duration(milliseconds: 900), () {
              if (mounted) context.go(AppRoutePaths.walletAddressBook);
            });
          },
        ),
      ),
    );
  }

  void _goBackToAddressBook(BuildContext context) {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.walletAddressBook,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}
