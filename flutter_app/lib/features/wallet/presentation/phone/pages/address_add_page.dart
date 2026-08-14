import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/address/wallet_address_add_sections.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_inset_scroll_view.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class AddressAddPage extends ConsumerStatefulWidget {
  const AddressAddPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc143_address_add_content');
  static const labelFieldKey = Key('sc143_address_label_field');
  static const addressFieldKey = Key('sc143_address_address_field');
  static const memoFieldKey = Key('sc143_address_memo_field');
  static const whitelistKey = Key('sc143_address_whitelist');
  static const agreementKey = Key('sc143_address_agreement');
  static const saveKey = Key('sc143_address_save');
  static Key networkKey(String id) => Key('sc143_address_network_$id');
  static Key assetKey(String asset) => Key('sc143_address_asset_$asset');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AddressAddPage> createState() => _AddressAddPageState();
}

class _AddressAddPageState extends ConsumerState<AddressAddPage> {
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
    final controllerAsync = ref.watch(addressAddControllerProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    if (_saved) {
      return AddressSavedState(
        label: _labelController.text.trim(),
        whitelist: _whitelist,
        onBack: () => goBackOrFallback(
          context,
          fallbackPath: AppRoutePaths.walletAddressBook,
        ),
      );
    }

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thêm địa chỉ mới vào sổ địa chỉ ví',
      semanticIdentifier: 'SC-143',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Thêm địa chỉ mới',
            subtitle: 'Sổ địa chỉ · Wallet',
            showBack: true,
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.walletAddressBook,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VitInsetScrollView(
                  key: AddressAddPage.contentKey,
                  bottomInset: _scrollBottomInset(context, mode),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.form,
                    padding: VitContentPadding.compact,
                    density: VitDensity.compact,
                    gap: VitContentGap.tight,
                    children: [
                      ...controllerAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được dữ liệu',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              walletAddressAddSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (controller) {
                          final snapshot = controller.state.snapshot;
                          return [
                            ...AddressAddForm.sections(
                              snapshot: snapshot,
                              selectedNetworkId: _networkId,
                              selectedAsset: _asset,
                              labelController: _labelController,
                              addressController: _addressController,
                              memoController: _memoController,
                              whitelist: _whitelist,
                              agreed: _agreed,
                              onNetworkChanged: (id) =>
                                  setState(() => _networkId = id),
                              onAssetChanged: (asset) =>
                                  setState(() => _asset = asset),
                              onWhitelistChanged: () =>
                                  setState(() => _whitelist = !_whitelist),
                              onAgreementChanged: () =>
                                  setState(() => _agreed = !_agreed),
                              onInputChanged: () => setState(() {}),
                            ),
                            AddressPrimaryActionButton(
                              key: AddressAddPage.saveKey,
                              enabled: _canSave(controller),
                              semanticLabel: 'Lưu địa chỉ ví',
                              label: 'Lưu địa chỉ',
                              onTap: () => _showConfirmPreview(controller),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _scrollBottomInset(BuildContext context, ShellRenderMode mode) {
    return (mode.usesVisualQaFrame
            ? WalletSpacingTokens.walletVisualChromePad
            : WalletSpacingTokens.walletNativeChromePad) +
        MediaQuery.paddingOf(context).bottom;
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
        backgroundColor: AppColors.surface,
        builder: (context) => AddressConfirmPreviewSheet(
          preview: preview,
          onConfirm: () {
            final router = GoRouter.of(this.context);
            Navigator.of(context).pop();
            setState(() => _saved = true);
            Future<void>.delayed(const Duration(milliseconds: 900), () {
              if (mounted) router.go(AppRoutePaths.walletAddressBook);
            });
          },
        ),
      ),
    );
  }
}
