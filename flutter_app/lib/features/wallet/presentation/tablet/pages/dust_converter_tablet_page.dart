import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for dust conversion SC-154.
class DustConverterTabletPage extends ConsumerStatefulWidget {
  const DustConverterTabletPage({super.key});

  static const contentKey = Key('sc154_dust_converter_tablet_content');
  static const selectAllKey = Key('sc154_dust_converter_select_all_tablet');
  static const ctaKey = Key('sc154_dust_converter_cta_tablet');
  static const confirmSheetKey = Key(
    'sc154_dust_converter_confirm_sheet_tablet',
  );
  static const confirmCancelKey = Key(
    'sc154_dust_converter_confirm_cancel_tablet',
  );
  static const confirmButtonKey = Key(
    'sc154_dust_converter_confirm_button_tablet',
  );
  static Key targetKey(String symbol) =>
      Key('sc154_dust_converter_target_tablet_$symbol');
  static Key assetKey(String id) =>
      Key('sc154_dust_converter_asset_tablet_$id');

  @override
  ConsumerState<DustConverterTabletPage> createState() =>
      _DustConverterTabletPageState();
}

class _DustConverterTabletPageState
    extends ConsumerState<DustConverterTabletPage> {
  String _targetSymbol = 'USDT';
  final Set<String> _selectedIds = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletDustConverterProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được số dư nhỏ',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletDustConverterProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) => _frame(
        primary: _buildPrimary(snapshot),
        secondary: _buildSecondary(snapshot),
      ),
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Chuyển đổi số dư nhỏ trên tablet',
      semanticIdentifier: 'SC-154-TABLET',
      title: 'Chuyển đổi số dư nhỏ',
      subtitle: 'Dọn dẹp số dư · xem trước phí và số nhận',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(WalletDustConverterSnapshot snapshot) {
    final assets = snapshot.eligibleAssets(_targetSymbol);
    final selectedAssets = assets
        .where((asset) => _selectedIds.contains(asset.id))
        .toList(growable: false);
    final selectedTotal = _sumUsd(selectedAssets);
    final selectedAll =
        assets.isNotEmpty && _selectedIds.length == assets.length;

    return Column(
      key: DustConverterTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Xem lại chuyển đổi số dư nhỏ',
          message:
              'Xác nhận tài sản, phí, số nhận và tài sản đích trước khi gửi yêu cầu chuyển đổi.',
          contractId: '${_selectedIds.length} đã chọn / $_targetSymbol',
          density: VitDensity.compact,
        ),

        VitCard(
          padding: TabletSpacingTokens.zeroInsets,
          variant: VitCardVariant.hero,
          child: Row(
            children: [
              const Icon(
                Icons.auto_awesome_outlined,
                color: AppColors.caution,
                size: TabletSpacingTokens.iconLg,
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Số dư nhỏ có thể chuyển đổi'),
                    const SizedBox(height: TabletSpacingTokens.x4),
                    Text(
                      '${assets.length} tài sản · ${VitFormat.usd(selectedTotal)} đang chọn',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                VitFormat.usd(snapshot.dustThresholdUsd),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.caution,
                ),
              ),
            ],
          ),
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Chuyển đổi sang',
          headerIcon: Icons.currency_exchange_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitTabBar(
              tabs: [
                for (final target in snapshot.targets)
                  VitTabItem(
                    key: target.symbol,
                    label: '${target.name} (${target.symbol})',
                    widgetKey: DustConverterTabletPage.targetKey(target.symbol),
                  ),
              ],
              activeKey: _targetSymbol,
              onChanged: (symbol) => setState(() {
                _targetSymbol = symbol;
                _selectedIds.clear();
              }),
              variant: VitTabBarVariant.segment,
            ),
          ],
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Số dư nhỏ (${assets.length})',
          headerIcon: Icons.inventory_2_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                key: DustConverterTabletPage.selectAllKey,
                onPressed: assets.isEmpty
                    ? null
                    : () => setState(() {
                        if (selectedAll) {
                          _selectedIds.clear();
                        } else {
                          _selectedIds
                            ..clear()
                            ..addAll(assets.map((asset) => asset.id));
                        }
                      }),
                child: Text(selectedAll ? 'Bỏ chọn tất cả' : 'Chọn tất cả'),
              ),
            ),
            if (assets.isEmpty)
              const VitEmptyState(
                title: 'Không có số dư nhỏ',
                message: 'Tài sản dưới ngưỡng dust sẽ hiển thị tại đây.',
                icon: Icons.auto_awesome_outlined,
              )
            else
              for (final asset in assets) _assetCard(asset),
          ],
        ),
        VitCtaButton(
          key: DustConverterTabletPage.ctaKey,
          onPressed: selectedAssets.isEmpty
              ? null
              : () =>
                    _showConfirmSheet(snapshot, selectedAssets, selectedTotal),
          variant: VitCtaButtonVariant.primary,
          leading: const Icon(Icons.transform_rounded),
          child: Text(
            selectedAssets.isEmpty
                ? 'Chọn tài sản để chuyển đổi'
                : 'Chuyển đổi ${selectedAssets.length} tài sản → $_targetSymbol',
          ),
        ),
      ],
    );
  }

  Widget _assetCard(WalletDustAsset asset) {
    final selected = _selectedIds.contains(asset.id);
    return VitCard(
      padding: TabletSpacingTokens.zeroInsets,
      key: DustConverterTabletPage.assetKey(asset.id),
      variant: selected ? VitCardVariant.hero : VitCardVariant.inner,
      onTap: () => setState(() {
        if (selected) {
          _selectedIds.remove(asset.id);
        } else {
          _selectedIds.add(asset.id);
        }
      }),
      child: Row(
        children: [
          VitAssetAvatar(
            label: asset.symbol,
            accentColor: Color(asset.colorHex),
            size: TabletSpacingTokens.iconLg,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(asset.name),
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  '${asset.availableLabel} · ${VitFormat.usd(asset.usdValue)}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          Icon(
            selected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? AppColors.buy : AppColors.text3,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondary(WalletDustConverterSnapshot snapshot) {
    final selectedAssets = snapshot
        .eligibleAssets(_targetSymbol)
        .where((asset) => _selectedIds.contains(asset.id))
        .toList(growable: false);
    final selectedTotal = _sumUsd(selectedAssets);
    final fee = selectedTotal * snapshot.conversionFeePct / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Tóm tắt xem trước',
          headerIcon: Icons.receipt_long_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitCard(
              padding: TabletSpacingTokens.zeroInsets,
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  VitInfoRow(
                    label: 'Số tài sản',
                    value: '${selectedAssets.length} loại',
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Tổng giá trị',
                    value: VitFormat.usd(selectedTotal),
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Phí chuyển đổi',
                    value:
                        '${VitFormat.usd(fee)} (${snapshot.conversionFeePct}%)',
                    valueColor: AppColors.caution,
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Tài sản đích',
                    value: _targetSymbol,
                    valueColor: AppColors.buy,
                    density: VitDensity.compact,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
        const VitCard(
          padding: TabletSpacingTokens.zeroInsets,
          variant: VitCardVariant.ghost,
          child: Text(
            'Giá trị và phí có thể thay đổi trước khi xác nhận. Kiểm tra lại số nhận cuối cùng trong bước xem trước.',
          ),
        ),
      ],
    );
  }

  Future<void> _showConfirmSheet(
    WalletDustConverterSnapshot snapshot,
    List<WalletDustAsset> selectedAssets,
    double selectedTotal,
  ) async {
    final fee = selectedTotal * snapshot.conversionFeePct / 100;
    final received = selectedTotal - fee;
    final confirmed = await showVitPreviewConfirmSheet(
      context: context,
      title: 'Xác nhận chuyển đổi',
      sheetKey: DustConverterTabletPage.confirmSheetKey,
      cancelKey: DustConverterTabletPage.confirmCancelKey,
      confirmKey: DustConverterTabletPage.confirmButtonKey,
      confirmLabel: 'Chuyển đổi sang $_targetSymbol',
      confirmVariant: VitCtaButtonVariant.danger,
      items: [
        VitFinancialSafetyItem(
          label: 'Số tài sản',
          value: '${selectedAssets.length} loại',
        ),
        VitFinancialSafetyItem(
          label: 'Tổng giá trị',
          value: VitFormat.usd(selectedTotal),
        ),
        VitFinancialSafetyItem(
          label: 'Phí chuyển đổi',
          value: '${VitFormat.usd(fee)} (${snapshot.conversionFeePct}%)',
        ),
        VitFinancialSafetyItem(
          label: 'Nhận được',
          value: '${received.toStringAsFixed(4)} $_targetSymbol',
          valueColor: AppColors.buy,
        ),
      ],
    );
    if (!confirmed || !mounted) return;
    setState(() => _selectedIds.clear());
    await showVitNoticeSheet(
      context: context,
      title: 'Đã chuyển đổi thành công',
      message:
          'Đã nhận ${received.toStringAsFixed(4)} $_targetSymbol từ chuyển đổi số dư nhỏ.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  double _sumUsd(List<WalletDustAsset> assets) =>
      assets.fold<double>(0, (sum, asset) => sum + asset.usdValue);
}
