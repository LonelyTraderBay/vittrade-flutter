import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for Wallet deposit flows SC-137/SC-138.
class DepositTabletPage extends ConsumerStatefulWidget {
  const DepositTabletPage({
    super.key,
    this.asset = 'USDT',
    this.assetScoped = false,
  });

  static const contentKey = Key('sc137_deposit_tablet_content');
  static const networkSelectorKey = Key('sc137_deposit_tablet_network');
  static const copyAddressKey = Key('sc137_deposit_tablet_copy_address');

  final String asset;
  final bool assetScoped;

  @override
  ConsumerState<DepositTabletPage> createState() => _DepositTabletPageState();
}

class _DepositTabletPageState extends ConsumerState<DepositTabletPage> {
  String? _selectedNetworkId;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final request = (asset: widget.asset, assetScoped: widget.assetScoped);
    final snapshotAsync = ref.watch(walletDepositControllerProvider(request));

    return snapshotAsync.when(
      loading: () => WalletTabletDetailSurface(
        semanticLabel: 'Nạp tiền trên tablet',
        semanticIdentifier: widget.assetScoped
            ? 'SC-138-TABLET'
            : 'SC-137-TABLET',
        title: 'Nạp ${widget.asset.toUpperCase()}',
        subtitle: 'Nạp tiền · Ví',
        onBack: () => context.go(AppRoutePaths.wallet),
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => WalletTabletDetailSurface(
        semanticLabel: 'Nạp tiền trên tablet',
        semanticIdentifier: widget.assetScoped
            ? 'SC-138-TABLET'
            : 'SC-137-TABLET',
        title: 'Nạp ${widget.asset.toUpperCase()}',
        subtitle: 'Nạp tiền · Ví',
        onBack: () => context.go(AppRoutePaths.wallet),
        primary: VitErrorState(
          title: 'Không tải được dữ liệu nạp tiền',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () =>
              ref.invalidate(walletDepositControllerProvider(request)),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) {
        final network = _selectedNetwork(snapshot.networks);
        return WalletTabletDetailSurface(
          semanticLabel: 'Nạp tiền trên tablet',
          semanticIdentifier: widget.assetScoped
              ? 'SC-138-TABLET'
              : 'SC-137-TABLET',
          title: 'Nạp ${snapshot.asset.toUpperCase()}',
          subtitle: 'Nạp tiền · Ví',
          onBack: () => context.go(AppRoutePaths.wallet),
          primary: _buildPrimary(snapshot, network),
          secondary: _buildSecondary(snapshot, network),
        );
      },
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

  Widget _buildPrimary(
    WalletDepositSnapshot snapshot,
    WalletDepositNetwork network,
  ) {
    return Column(
      key: DepositTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Mạng nạp',
          headerIcon: Icons.hub_outlined,
          headerIconColor: AppModuleAccents.wallet,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppModuleAccents.wallet,
          rhythm: VitPageRhythm.standard,
          children: [
            VitCard(
              padding: TabletSpacingTokens.zeroInsets,
              key: DepositTabletPage.networkSelectorKey,
              variant: VitCardVariant.inner,
              borderColor: AppModuleAccents.wallet,
              onTap: () => _openNetworkPicker(snapshot.networks),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          network.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x4),
                        Text(
                          'Phí ${network.fee} · Tối thiểu ${network.minDeposit} ${snapshot.asset}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ],
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Địa chỉ nạp',
          headerIcon: Icons.qr_code_2_rounded,
          headerIconColor: AppModuleAccents.wallet,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppModuleAccents.wallet,
          rhythm: VitPageRhythm.standard,
          children: [
            VitCard(
              padding: TabletSpacingTokens.zeroInsets,
              child: Column(
                children: [
                  const Icon(
                    Icons.qr_code_2_rounded,
                    size: 144,
                    color: AppColors.text1,
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  Text(
                    'Địa chỉ ${snapshot.asset} · ${network.name}',
                    style: AppTextStyles.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  SelectableText(
                    network.address,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.monoCode,
                  ),
                  const SizedBox(height: TabletSpacingTokens.x4),
                  VitCtaButton(
                    key: DepositTabletPage.copyAddressKey,
                    onPressed: () => _copyAddress(network.address),
                    variant: _copied
                        ? VitCtaButtonVariant.success
                        : VitCtaButtonVariant.primary,
                    leading: Icon(
                      _copied ? Icons.check_rounded : Icons.copy_rounded,
                    ),
                    child: Text(
                      _copied ? 'Đã sao chép địa chỉ' : 'Sao chép địa chỉ',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondary(
    WalletDepositSnapshot snapshot,
    WalletDepositNetwork network,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Kiểm tra trước khi nạp',
          subtitle: 'Bảo vệ tài sản',
          icon: Icons.shield_outlined,
          iconColor: AppColors.sell,
          variant: VitSectionHeaderVariant.plain,
          bottomGap: TabletSpacingTokens.x4,
        ),
        VitBanner(
          variant: VitBannerVariant.warning,
          message:
              'Chỉ gửi ${snapshot.asset} qua mạng ${network.name}. Gửi sai mạng có thể làm mất tài sản và không thể hoàn tác.',
          icon: Icons.warning_amber_rounded,
        ),
        const SizedBox(
          height: TabletSpacingTokens.pageRhythmStandardSectionGap,
        ),

        VitCard(
          padding: TabletSpacingTokens.zeroInsets,
          variant: VitCardVariant.inner,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chi tiết mạng',
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              const _DetailRow(label: 'Trạng thái', value: 'Đang hoạt động'),
              _DetailRow(label: 'Thời gian nhận', value: network.arrivalTime),
              _DetailRow(
                label: 'Xác nhận cần thiết',
                value: '${network.confirmations} lần',
              ),
              _DetailRow(
                label: 'Nạp tối thiểu',
                value: '${network.minDeposit} ${snapshot.asset}',
              ),
              if (network.memoLabel != null)
                _DetailRow(label: 'Memo', value: network.memoLabel!),
            ],
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        VitCtaButton(
          onPressed: () {
            setState(() => _copied = false);
            unawaited(
              showVitNoticeSheet(
                context: context,
                title: 'Đã làm mới',
                message: 'Thông tin địa chỉ nạp đã được cập nhật.',
                variant: VitBannerVariant.info,
              ),
            );
          },
          variant: VitCtaButtonVariant.ghost,
          leading: const Icon(Icons.refresh_rounded),
          child: const Text('Làm mới thông tin'),
        ),
      ],
    );
  }

  Future<void> _copyAddress(String address) async {
    await Clipboard.setData(ClipboardData(text: address));
    if (mounted) setState(() => _copied = true);
  }

  void _openNetworkPicker(List<WalletDepositNetwork> networks) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => VitSheetPanel(
          title: 'Chọn mạng lưới',
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: networks.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: TabletSpacingTokens.x4),
            itemBuilder: (context, index) {
              final network = networks[index];
              return VitCard(
                padding: TabletSpacingTokens.zeroInsets,
                variant: VitCardVariant.inner,
                onTap: () {
                  setState(() => _selectedNetworkId = network.id);
                  Navigator.of(sheetContext).pop();
                },
                child: Text(
                  network.name,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: TabletSpacingTokens.pageRhythmFormInnerGap,
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.caption)),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ],
      ),
    );
  }
}
