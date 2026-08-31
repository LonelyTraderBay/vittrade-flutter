import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/tablet/wallet_page_sections.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/tablet/wallet_tablet_keys.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/tablet/wallet_unavailable_banner.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet composition of Wallet (SC-135) — same route, same
/// [walletSnapshotProvider] data and the same public Wallet widgets as
/// [WalletPage], but laid out as a persistent two-column dashboard instead
/// of one scrolling phone column: balance + assets on the left, tools + DCA
/// on the right. Does not touch `wallet_page.dart` — reached via
/// `createTabletAppRouter`/surface bootstrap. Second reference implementation for
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`
/// (see `home_tablet_page.dart` for the first).
class WalletTabletPage extends ConsumerStatefulWidget {
  const WalletTabletPage({super.key});

  @override
  ConsumerState<WalletTabletPage> createState() => _WalletTabletPageState();
}

class _WalletTabletPageState extends ConsumerState<WalletTabletPage> {
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

  List<WalletAsset> _filteredAssets(List<WalletAsset> assets) {
    final query = _query.trim().toLowerCase();
    return assets.where((asset) {
      if (_hideSmallBalances && asset.usdValue < 1) return false;
      if (query.isEmpty) return true;
      return asset.symbol.toLowerCase().contains(query) ||
          asset.name.toLowerCase().contains(query);
    }).toList();
  }

  void _setTab(String tab) => setState(() => _tab = tab);

  void _navigate(String route) => context.go(route);

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
            key: WalletTabletKeys.moreActionsSheet,
            title: 'Thêm thao tác',
            child: VitActionTileGrid(
              density: VitDensity.compact,
              crossAxisSpacing: TabletSpacingTokens.x3,
              mainAxisSpacing: TabletSpacingTokens.x3,
              physics: const ClampingScrollPhysics(),
              itemCount: overflowActions.length,
              itemBuilder: (context, index, density) {
                final action = overflowActions[index];
                return VitServiceTile(
                  key: WalletTabletKeys.action(action.id),
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

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletSnapshotProvider);
    final pendingDepositsAsync = ref.watch(walletPendingDepositsProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Ví - số dư minh bạch, bảo mật đa lớp',
      semanticIdentifier: 'SC-135',
      child: Column(
        children: [
          VitTopChrome(
            type: VitTopChromeType.rootModule,
            title: 'Ví',
            subtitle: 'Số dư minh bạch · bảo mật đa lớp',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.home,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: walletAsync.when(
              loading: () =>
                  const SingleChildScrollView(child: VitSkeletonList()),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được dữ liệu ví',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(walletSnapshotProvider),
                ),
              ),
              data: (snapshot) =>
                  _buildDashboard(snapshot, pendingDepositsAsync.value),
            ),
          ),
        ],
      ),
    );
  }

  // Two-column threshold and per-column width caps are owned by
  // [VitTwoColumnTabletDashboard] (`TabletDashboardWidths` defaults) —
  // Wallet's own content confirmed the same values as `HomeTabletPage` hold
  // (verified via `wallet_tablet_page_test.dart`'s wide-tablet + Phân bổ-tab
  // cases, not just assumed). Pass constructor overrides on the call below
  // instead of editing the shared widths if Wallet's content ever needs a
  // different number.

  Widget _buildDashboard(
    WalletSnapshot snapshot,
    WalletPendingDepositsSnapshot? pendingDeposits,
  ) {
    final assets = _filteredAssets(snapshot.assets);

    final primaryChildren = [
      if (snapshot.supportedStates.contains(WalletScreenState.error))
        WalletUnavailableBanner(message: snapshot.actionDraft),
      WalletBalanceHero(
        snapshot: snapshot,
        change24hPct: walletPortfolioChange24h(snapshot.assets),
        hidden: _balanceHidden,
        onToggle: () => setState(() => _balanceHidden = !_balanceHidden),
        onNavigate: _navigate,
      ),
      if (snapshot.actions.isNotEmpty &&
          (pendingDeposits?.pendingCount ?? 0) > 0)
        WalletPendingDepositStatusCard(
          pendingDeposits: pendingDeposits!,
          onNavigate: _navigate,
        ),
      VitPageSection(
        label: 'Tài sản',
        headerIcon: Icons.account_balance_wallet_outlined,
        headerIconColor: AppModuleAccents.wallet,
        accentColor: AppModuleAccents.wallet,
        headerVariant: VitSectionHeaderVariant.plain,
        actionLabel: 'Phân tích',
        onAction: () => _navigate('/wallet/portfolio-analytics'),
        innerGap: TabletSpacingTokens.x4,
        children: [
          if (_tab == 'assets')
            WalletSearchAndFilter(
              controller: _searchController,
              filterActive: _hideSmallBalances,
              onChanged: (value) => setState(() => _query = value),
              onFilter: () =>
                  setState(() => _hideSmallBalances = !_hideSmallBalances),
            ),
          WalletSegmentedTabs(active: _tab, onChanged: _setTab),
          if (_tab == 'assets') ...[
            WalletAssetHeader(count: assets.length, onNavigate: _navigate),
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
    ];

    final secondaryChildren = [
      VitPageSection(
        label: 'Công cụ ví',
        headerIcon: Icons.grid_view_rounded,
        headerIconColor: AppModuleAccents.wallet,
        accentColor: AppModuleAccents.wallet,
        headerVariant: VitSectionHeaderVariant.plain,
        innerGap: TabletSpacingTokens.x4,
        children: [
          WalletToolGrid(
            tools: snapshot.tools,
            onNavigate: _navigate,
            onShowMore: () => _showMoreActions(snapshot.actions),
          ),
        ],
      ),
      VitPageSection(
        label: 'Mua định kỳ',
        headerIcon: Icons.sync_alt_rounded,
        headerIconColor: AppColors.accent,
        accentColor: AppColors.accent,
        headerVariant: VitSectionHeaderVariant.plain,
        innerGap: TabletSpacingTokens.x4,
        children: [WalletDcaCard(dca: snapshot.dca)],
      ),
    ];

    return VitTwoColumnTabletDashboard(
      primaryChildren: primaryChildren,
      secondaryChildren: secondaryChildren,
      // Luật 13dp (2026-08-31): section gap dashboard = 13.
      primaryContentGap: TabletSpacingTokens.x4,
      secondaryContentGap: TabletSpacingTokens.x4,
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
