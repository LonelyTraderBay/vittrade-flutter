import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/phone/wallet_page_sections.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/phone/wallet_unavailable_banner.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc135_wallet_content');
  static const balanceToggleKey = Key('sc135_wallet_balance_toggle');
  static const moreActionsKey = Key('sc135_wallet_more_actions');
  static const moreActionsSheetKey = Key('sc135_wallet_more_actions_sheet');
  static const searchKey = Key('sc135_wallet_search');
  static const filterKey = Key('sc135_wallet_filter');
  static Key actionKey(String id) => Key('sc135_wallet_action_$id');
  static Key tabKey(String id) => Key('sc135_wallet_tab_$id');
  static Key assetKey(String id) => Key('sc135_wallet_asset_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  late final TextEditingController _searchController;
  bool _balanceHidden = false;
  bool _hideSmallBalances = false;
  String _tab = 'assets';
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletSnapshotProvider);
    final pendingDepositsAsync = ref.watch(walletPendingDepositsProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  WalletSpacingTokens.walletVisualChromePad
            : DeviceMetrics.nativeBottomChrome +
                  WalletSpacingTokens.walletNativeChromePad) +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.searchBarCompactHeight;
    final showBack = context.canPop();

    return VitAutoHidePageScaffold(
      semanticLabel: 'Ví - số dư minh bạch, bảo mật đa lớp',
      semanticIdentifier: 'SC-135',
      header: VitTopChrome(
        type: VitTopChromeType.rootModule,
        title: 'V\u00ED',
        subtitle:
            'S\u1ED1 d\u01B0 minh b\u1EA1ch \u00B7 b\u1EA3o m\u1EADt \u0111a l\u1EDBp',
        showBack: showBack,
        onBack: showBack
            ? () => goBackOrFallback(
                context,
                fallbackPath: AppRoutePaths.home,
                mode: BackNavigationMode.historyThenFallback,
              )
            : null,
      ),
      body: VitInsetScrollView(
        key: WalletPage.contentKey,
        bottomInset: bottomInset,
        child: VitPageContent(
          // Tab-root rhythm stays compact; overview density is standard (SDD B2).
          rhythm: VitPageRhythm.compact,
          padding: VitContentPadding.defaultPadding,
          density: VitDensity.standard,
          children: [
            // GD4-F2: pendingDeposits ch\u1EC9 l\u00E0 banner ph\u1EE5, kh\u00F4ng ch\u1EB7n to\u00E0n
            // trang khi v\u1EABn \u0111ang t\u1EA3i/l\u1ED7i \u2014 d\u00F9ng .value (xem
            // GD4-Async-Playbook.md, m\u1EE5c "async ph\u1EE5").
            ...walletAsync.when(
              loading: () => const [VitSkeletonList()],
              error: (error, stackTrace) => [
                VitErrorState(
                  title:
                      'Kh\u00F4ng t\u1EA3i \u0111\u01B0\u1EE3c d\u1EEF li\u1EC7u v\u00ED',
                  message:
                      'Vui l\u00F2ng ki\u1EC3m tra k\u1EBFt n\u1ED1i v\u00E0 th\u1EED l\u1EA1i.',
                  actionLabel: 'Th\u1EED l\u1EA1i',
                  onAction: () => ref.invalidate(walletSnapshotProvider),
                ),
              ],
              data: (snapshot) {
                final pendingDeposits = pendingDepositsAsync.value;
                final assets = _filteredAssets(snapshot.assets);
                return [
                  if (snapshot.supportedStates.contains(
                    WalletScreenState.error,
                  ))
                    WalletUnavailableBanner(message: snapshot.actionDraft),
                  WalletBalanceHero(
                    snapshot: snapshot,
                    change24hPct: walletPortfolioChange24h(snapshot.assets),
                    hidden: _balanceHidden,
                    onToggle: () =>
                        setState(() => _balanceHidden = !_balanceHidden),
                    onNavigate: _navigate,
                  ),
                  if (snapshot.actions.isNotEmpty &&
                      (pendingDeposits?.pendingCount ?? 0) > 0)
                    WalletPendingDepositStatusCard(
                      pendingDeposits: pendingDeposits!,
                      onNavigate: _navigate,
                    ),
                  VitPageSection(
                    label: 'T\u00E0i s\u1EA3n',
                    headerIcon: Icons.account_balance_wallet_outlined,
                    headerIconColor: AppModuleAccents.wallet,
                    accentColor: AppModuleAccents.wallet,
                    headerVariant: VitSectionHeaderVariant.plain,
                    actionLabel: 'Ph\u00E2n t\u00EDch',
                    onAction: () => _navigate('/wallet/portfolio-analytics'),
                    innerGap: AppSpacing.pageRhythmCompactInnerGap,
                    children: [
                      if (_tab == 'assets')
                        WalletSearchAndFilter(
                          controller: _searchController,
                          filterActive: _hideSmallBalances,
                          onChanged: (value) => setState(() => _query = value),
                          onFilter: () => setState(
                            () => _hideSmallBalances = !_hideSmallBalances,
                          ),
                        ),
                      WalletSegmentedTabs(active: _tab, onChanged: _setTab),
                      if (_tab == 'assets') ...[
                        WalletAssetHeader(
                          count: assets.length,
                          onNavigate: _navigate,
                        ),
                        WalletAssetList(
                          assets: assets,
                          hidden: _balanceHidden,
                          onNavigate: _navigate,
                        ),
                      ] else
                        WalletAllocationCard(assets: snapshot.assets),
                      WalletPortfolioHint(onNavigate: _navigate),
                    ],
                  ),
                  VitPageSection(
                    label: 'C\u00F4ng c\u1EE5 v\u00ED',
                    headerIcon: Icons.grid_view_rounded,
                    headerIconColor: AppModuleAccents.wallet,
                    accentColor: AppModuleAccents.wallet,
                    headerVariant: VitSectionHeaderVariant.plain,
                    innerGap: AppSpacing.pageRhythmCompactInnerGap,
                    children: [
                      WalletToolGrid(
                        tools: snapshot.tools,
                        onNavigate: _navigate,
                        onShowMore: () => _showMoreActions(snapshot.actions),
                      ),
                    ],
                  ),
                  VitPageSection(
                    label: 'Mua \u0111\u1ECBnh k\u1EF3',
                    headerIcon: Icons.sync_alt_rounded,
                    headerIconColor: AppColors.accent,
                    accentColor: AppColors.accent,
                    headerVariant: VitSectionHeaderVariant.plain,
                    innerGap: AppSpacing.pageRhythmCompactInnerGap,
                    children: [WalletDcaCard(dca: snapshot.dca)],
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  List<WalletAsset> _filteredAssets(List<WalletAsset> assets) {
    final query = _query.trim().toLowerCase();
    return assets.where((asset) {
      if (_hideSmallBalances && asset.usdValue < 1) return false;
      if (query.isEmpty) return true;
      return asset.symbol.toLowerCase().contains(query) ||
          asset.name.toLowerCase().contains(query);
    }).toList();
  }

  void _setTab(String tab) {
    setState(() => _tab = tab);
  }

  void _navigate(String route) {
    context.go(route);
  }

  void _showMoreActions(List<WalletAction> actions) {
    const primaryIds = {'deposit', 'withdraw'};
    final overflowActions = actions
        .where((action) => !primaryIds.contains(action.id))
        .toList(growable: false);
    if (overflowActions.isEmpty) return;

    final rootContext = context;
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.bg,
        barrierColor: AppColors.modalScrim,
        builder: (sheetContext) {
          return VitSheetPanel(
            key: WalletPage.moreActionsSheetKey,
            title: 'Th\u00EAm thao t\u00E1c',
            child: VitActionTileGrid(
              density: VitDensity.compact,
              crossAxisSpacing: AppSpacing.x3,
              mainAxisSpacing: AppSpacing.x3,
              physics: const ClampingScrollPhysics(),
              itemCount: overflowActions.length,
              itemBuilder: (context, index, density) {
                final action = overflowActions[index];
                return VitServiceTile(
                  key: WalletPage.actionKey(action.id),
                  density: density,
                  icon: _walletOverflowActionIcon(action.iconKey),
                  label: action.label,
                  accentColor: Color(action.colorHex),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    rootContext.go(action.route);
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

IconData _walletOverflowActionIcon(String key) => switch (key) {
  'deposit' => Icons.file_download_outlined,
  'withdraw' => Icons.file_upload_outlined,
  'buy' => Icons.shopping_cart_outlined,
  'transfer' => Icons.swap_vert_rounded,
  'history' => Icons.schedule_rounded,
  'pending' => Icons.south_west_rounded,
  'limits' => Icons.speed_rounded,
  'dust' => Icons.auto_awesome_rounded,
  'network' => Icons.wifi_rounded,
  'gas' => Icons.local_gas_station_outlined,
  'multi' => Icons.account_tree_outlined,
  'approval' => Icons.verified_user_outlined,
  _ => Icons.account_balance_wallet_outlined,
};
