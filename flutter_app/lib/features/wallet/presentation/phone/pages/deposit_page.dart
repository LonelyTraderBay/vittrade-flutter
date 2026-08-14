import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/widgets/vit_wallet_detail_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../../widgets/transfer/deposit_page_sections.dart';
part '../../widgets/transfer/deposit_page_common.dart';

const _depositPrimary = AppColors.primary;
const _depositGreen = AppColors.buy;
const _depositRed = AppColors.sell;
const _depositGap = 8.0;
const _depositTinyGap = 4.0;
const _depositInlineGap = 8.0;
// A11Y-3: was 60 — raised so the network name + fee/min line fit at the
// app-wide 1.3x text-scaling clamp without overflowing.
const _depositSelectorHeight = 64.0;
const _depositQrSize = 132.0;
const _depositStatusDotSize = AppSpacing.x2 - AppSpacing.dividerHairline * 2;
const _depositCopyButtonHeight = 44.0;

class DepositPage extends ConsumerStatefulWidget {
  const DepositPage({
    super.key,
    this.asset = 'USDT',
    this.assetScoped = false,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc137_deposit_content');
  static const networkSelectorKey = Key('sc137_deposit_network_selector');
  static const copyAddressKey = Key('sc137_deposit_copy_address');
  static const refreshKey = Key('sc137_deposit_refresh');
  static Key networkKey(String id) => Key('sc137_deposit_network_$id');

  final String asset;
  final bool assetScoped;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends ConsumerState<DepositPage> {
  String? _selectedNetworkId;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      walletDepositControllerProvider((
        asset: widget.asset,
        assetScoped: widget.assetScoped,
      )),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    return VitWalletDetailScaffold(
      title: 'Nạp ${widget.asset.toUpperCase()}',
      subtitle: 'Nạp tiền · Wallet',
      semanticLabel: widget.assetScoped ? 'Nạp tiền theo tài sản' : 'Nạp tiền',
      semanticIdentifier: widget.assetScoped ? 'SC-138' : 'SC-137',
      contentKey: DepositPage.contentKey,
      shellRenderMode: mode,
      onBack: () => context.go(AppRoutePaths.wallet),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu nạp tiền',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(
              walletDepositControllerProvider((
                asset: widget.asset,
                assetScoped: widget.assetScoped,
              )),
            ),
          ),
        ],
        data: (snapshot) {
          final selected = _selectedNetwork(snapshot.networks);
          return [
            VitPageSection(
              label: 'Mạng nạp',
              headerIcon: Icons.hub_outlined,
              headerIconColor: _depositPrimary,
              headerVariant: VitSectionHeaderVariant.plain,
              accentColor: _depositPrimary,
              innerGap: AppSpacing.pageRhythmFormInnerGap,
              children: [
                _NetworkSelector(
                  asset: snapshot.asset,
                  selected: selected,
                  onTap: () => _openNetworkPicker(snapshot.networks),
                ),
              ],
            ),
            VitPageSection(
              label: 'Địa chỉ nạp',
              headerIcon: Icons.qr_code_2_rounded,
              headerIconColor: _depositPrimary,
              headerVariant: VitSectionHeaderVariant.plain,
              accentColor: _depositPrimary,
              innerGap: AppSpacing.pageRhythmFormInnerGap,
              children: [
                _QrAddressCard(
                  asset: snapshot.asset,
                  network: selected,
                  copied: _copied,
                  onCopy: () => _copyAddress(selected.address),
                ),
              ],
            ),
            VitPageSection(
              label: 'An toàn',
              headerIcon: Icons.shield_outlined,
              headerIconColor: _depositRed,
              headerVariant: VitSectionHeaderVariant.plain,
              accentColor: _depositRed,
              innerGap: AppSpacing.pageRhythmFormInnerGap,
              children: [
                _WarningCard(asset: snapshot.asset, network: selected),
              ],
            ),
            VitPageSection(
              label: 'Chi tiết nạp',
              headerIcon: Icons.receipt_long_outlined,
              headerIconColor: _depositPrimary,
              headerVariant: VitSectionHeaderVariant.plain,
              accentColor: _depositPrimary,
              innerGap: AppSpacing.pageRhythmFormInnerGap,
              children: [
                _DepositInfoCard(asset: snapshot.asset, network: selected),
                _RefreshButton(onTap: _refreshDepositIntent),
              ],
            ),
          ];
        },
      ),
    );
  }

  WalletDepositNetwork _selectedNetwork(List<WalletDepositNetwork> networks) {
    final selectedId = _selectedNetworkId;
    if (selectedId != null) {
      for (final network in networks) {
        if (network.id == selectedId) return network;
      }
    }
    return networks.first;
  }

  Future<void> _copyAddress(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (!mounted) return;
    setState(() => _copied = true);
  }

  void _refreshDepositIntent() {
    setState(() => _copied = false);
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Đã làm mới',
        message:
            'Thông tin địa chỉ nạp tiền đã được cập nhật. Luôn kiểm tra lại địa chỉ và mạng lưới trước khi nạp.',
      ),
    );
  }

  void _openNetworkPicker(List<WalletDepositNetwork> networks) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return VitSheetPanel(
            title: 'Chọn mạng lưới',
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: networks.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: _depositTinyGap),
              itemBuilder: (context, index) {
                final network = networks[index];
                return _NetworkOption(
                  network: network,
                  selected:
                      network.id == _selectedNetworkId ||
                      (_selectedNetworkId == null &&
                          network.id == networks.first.id),
                  onTap: () {
                    setState(() => _selectedNetworkId = network.id);
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
}
