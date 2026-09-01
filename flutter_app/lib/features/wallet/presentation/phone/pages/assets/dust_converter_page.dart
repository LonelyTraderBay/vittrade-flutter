import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/widgets/vit_wallet_detail_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../../../widgets/assets/wallet_dust_converter_hero.dart';
part '../../../widgets/assets/wallet_dust_converter_targets.dart';
part '../../../widgets/assets/wallet_dust_converter_assets.dart';
part '../../../widgets/assets/wallet_dust_converter_confirm.dart';

const _dustAmber = AppColors.caution;
const _dustMuted = AppColors.text3;
const _dustGap = AppSpacing.x2;
const _dustTinyGap = AppSpacing.x1;
const _dustInlineGap = AppSpacing.x2;
const _dustHeroIconBox = AppSpacing.buttonCompact;
const _dustTokenLogo = AppSpacing.buttonCompact - AppSpacing.x1;

class DustConverterPage extends ConsumerStatefulWidget {
  const DustConverterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc154_dust_converter_content');
  static const selectAllKey = Key('sc154_dust_converter_select_all');
  static const ctaKey = Key('sc154_dust_converter_cta');
  static const confirmSheetKey = Key('sc154_dust_converter_confirm_sheet');
  static const confirmCancelKey = Key('sc154_dust_converter_confirm_cancel');
  static const confirmButtonKey = Key('sc154_dust_converter_confirm_button');
  static Key targetKey(String symbol) =>
      Key('sc154_dust_converter_target_$symbol');
  static Key assetKey(String id) => Key('sc154_dust_converter_asset_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DustConverterPage> createState() => _DustConverterPageState();
}

class _DustConverterPageState extends ConsumerState<DustConverterPage> {
  String _targetSymbol = 'USDT';
  final Set<String> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletDustConverterProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    const formInnerGap = AppSpacing.pageRhythmFormInnerGap;

    return VitWalletDetailScaffold(
      title: 'Chuy\u1EC3n \u0111\u1ED5i s\u1ED1 d\u01B0 nh\u1ECF',
      subtitle: 'D\u1ECDn d\u1EB9p \u00b7 Wallet',
      semanticLabel: 'Chuyển đổi số dư nhỏ',
      semanticIdentifier: 'SC-154',
      contentKey: DustConverterPage.contentKey,
      shellRenderMode: mode,
      onBack: () => context.go(AppRoutePaths.wallet),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được số dư nhỏ',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(walletDustConverterProvider),
          ),
        ],
        data: (snapshot) {
          final assets = snapshot.eligibleAssets(_targetSymbol);
          final selectedAssets = assets
              .where((asset) => _selectedIds.contains(asset.id))
              .toList(growable: false);
          final selectedTotal = _sumUsd(selectedAssets);
          final selectedAll =
              assets.isNotEmpty && _selectedIds.length == assets.length;

          return [
            VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại chuy\u1EC3n \u0111\u1ED5i dust',
              message:
                  'X\u00E1c nh\u1EADn t\u00E0i s\u1EA3n \u0111\u00E3 ch\u1ECDn, ph\u00ED, s\u1ED1 nh\u1EADn v\u00E0 t\u00E0i s\u1EA3n \u0111\u00EDch tr\u01B0\u1EDBc khi g\u1EEDi.',
              contractId:
                  '${_selectedIds.length} \u0111\u00E3 ch\u1ECDn / $_targetSymbol',
              density: VitDensity.compact,
            ),
            _DustHero(
              snapshot: snapshot,
              targetSymbol: _targetSymbol,
              foundCount: assets.length,
              selectedCount: _selectedIds.length,
              selectedValue: selectedTotal,
            ),
            VitPageSection(
              label: 'Chuy\u1EC3n \u0111\u1ED5i sang',
              headerVariant: VitSectionHeaderVariant.plain,
              headerDensity: VitDensity.compact,
              innerGap: formInnerGap,
              children: [
                _TargetSelector(
                  targets: snapshot.targets,
                  selected: _targetSymbol,
                  onSelected: (symbol) => setState(() {
                    _targetSymbol = symbol;
                    _selectedIds.clear();
                  }),
                ),
              ],
            ),
            VitPageSection(
              label: 'S\u1ED1 d\u01B0 nh\u1ECF (${assets.length})',
              headerVariant: VitSectionHeaderVariant.plain,
              headerDensity: VitDensity.compact,
              actionLabel: assets.isEmpty
                  ? null
                  : selectedAll
                  ? 'B\u1ECF ch\u1ECDn t\u1EA5t c\u1EA3'
                  : 'Ch\u1ECDn t\u1EA5t c\u1EA3',
              actionKey: assets.isEmpty ? null : DustConverterPage.selectAllKey,
              actionShowChevron: false,
              actionSemanticLabel: 'Toggle all dust assets',
              onAction: assets.isEmpty
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
              innerGap: formInnerGap,
              children: [
                if (assets.isEmpty)
                  const VitEmptyState(
                    title: 'Kh\u00F4ng c\u00F3 s\u1ED1 d\u01B0 nh\u1ECF',
                    message:
                        'C\u00E1c t\u00E0i s\u1EA3n d\u01B0\u1EDBi ng\u01B0\u1EE1ng dust s\u1EBD hi\u1EC3n th\u1ECB t\u1EA1i \u0111\u00E2y.',
                    icon: Icons.auto_awesome_outlined,
                  )
                else
                  _DustAssetList(
                    assets: assets,
                    selectedIds: _selectedIds,
                    onToggle: _toggleAsset,
                  ),
              ],
            ),
            _PrimaryButton(
              key: DustConverterPage.ctaKey,
              enabled: _selectedIds.isNotEmpty,
              label: _selectedIds.isNotEmpty
                  ? 'Chuy\u1EC3n \u0111\u1ED5i ${_selectedIds.length} t\u00E0i s\u1EA3n \u2192 $_targetSymbol'
                  : 'Ch\u1ECDn t\u00E0i s\u1EA3n \u0111\u1EC3 chuy\u1EC3n \u0111\u1ED5i',
              onTap: () => _showConfirmSheet(
                context,
                snapshot,
                selectedAssets,
                selectedTotal,
              ),
            ),
          ];
        },
      ),
    );
  }

  void _toggleAsset(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  Future<void> _showConfirmSheet(
    BuildContext context,
    WalletDustConverterSnapshot snapshot,
    List<WalletDustAsset> selectedAssets,
    double selectedTotal,
  ) async {
    if (selectedAssets.isEmpty) return;
    final fee = selectedTotal * snapshot.conversionFeePct / 100;
    final received = selectedTotal - fee;

    final confirmed = await showVitPreviewConfirmSheet(
      context: context,
      title: 'X\u00E1c nh\u1EADn chuy\u1EC3n \u0111\u1ED5i',
      sheetKey: DustConverterPage.confirmSheetKey,
      cancelKey: DustConverterPage.confirmCancelKey,
      confirmKey: DustConverterPage.confirmButtonKey,
      confirmLabel: 'Chuy\u1EC3n \u0111\u1ED5i sang $_targetSymbol',
      confirmVariant: VitCtaButtonVariant.danger,
      items: [
        VitFinancialSafetyItem(
          label: 'S\u1ED1 t\u00E0i s\u1EA3n',
          value: '${selectedAssets.length} lo\u1EA1i',
        ),
        VitFinancialSafetyItem(
          label: 'T\u1ED5ng gi\u00E1 tr\u1ECB',
          value: VitFormat.usd(selectedTotal),
        ),
        VitFinancialSafetyItem(
          label: 'Ph\u00ED chuy\u1EC3n \u0111\u1ED5i',
          value: '${VitFormat.usd(fee)} (${snapshot.conversionFeePct}%)',
        ),
        VitFinancialSafetyItem(
          label: 'Nh\u1EADn \u0111\u01B0\u1EE3c',
          value: '${_formatAmount(received)} $_targetSymbol',
          valueColor: AppColors.buy,
        ),
      ],
    );

    if (!confirmed || !context.mounted) return;
    setState(() {
      _selectedIds.clear();
    });
    await showVitNoticeSheet(
      context: context,
      title: 'Đã chuyển đổi thành công',
      message:
          'Đã nhận ${_formatAmount(received)} $_targetSymbol '
          'từ chuyển đổi số dư nhỏ.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}
