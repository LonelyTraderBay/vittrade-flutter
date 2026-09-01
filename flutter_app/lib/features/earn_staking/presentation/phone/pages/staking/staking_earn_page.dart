import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/earn_hub_tools_catalog.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/earn_legal_catalog.dart';
part '../../../widgets/staking/staking_earn_hero_tabs.dart';
part '../../../widgets/staking/staking_earn_products.dart';
part '../../../widgets/staking/staking_earn_positions_common.dart';
part '../../../widgets/staking/staking_earn_tools.dart';

enum _EarnTab { products, positions }

enum _EarnFilter { all, fixed, flexible, defi }

class StakingEarnPage extends ConsumerStatefulWidget {
  const StakingEarnPage({
    super.key,
    this.shellRenderMode,
    this.route = StakingEarnRoute.earn,
  });

  static const productsTabKey = Key('sc327_tab_products');
  static const positionsTabKey = Key('sc327_tab_positions');
  static const savingsButtonKey = Key('sc327_savings_button');
  static const dashboardButtonKey = Key('sc327_dashboard_button');
  static const toolsSectionKey = Key('sc327_tools_section');
  static const legalEntryKey = Key('sc327_legal_entry');
  static const legalSheetKey = Key('sc327_legal_sheet');
  static Key filterKey(String filter) => Key('sc327_filter_$filter');
  static Key productKey(String id) => Key('sc327_product_$id');
  static Key toolKey(String id) => Key('sc327_tool_$id');
  static Key legalGroupKey(String id) => Key('sc327_legal_group_$id');
  static Key legalItemKey(String id) => Key('sc327_legal_item_$id');

  final ShellRenderMode? shellRenderMode;
  final StakingEarnRoute route;

  @override
  ConsumerState<StakingEarnPage> createState() => _StakingEarnPageState();
}

class _StakingEarnPageState extends ConsumerState<StakingEarnPage> {
  _EarnTab _tab = _EarnTab.products;
  _EarnFilter _filter = _EarnFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingEarnSnapshotProvider(widget.route));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    // Same clearance as DeviceMetrics shell chrome without density-audit markers.
    final scrollEndPad =
        (mode.usesVisualQaFrame ? 90.0 + AppSpacing.x7 : 72.0 + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Trang chủ Earn & Stake — sản phẩm tiết kiệm lãi cố định, linh hoạt và các vị thế đang sinh lời',
      semanticIdentifier: widget.route == StakingEarnRoute.earn
          ? 'SC-327'
          : 'SC-328',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.rootModule,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.home),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.rootModule,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.home),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingEarnSnapshotProvider(widget.route)),
            ),
          ),
          data: (snapshot) {
            final products = _filteredProducts(snapshot.products, _filter);
            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.rootModule,
                title: snapshot.title,
                subtitle: snapshot.subtitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: VitInsetScrollView(
                  physics: const ClampingScrollPhysics(),
                  bottomInset: scrollEndPad,
                  child: VitPageContent(
                    rhythm: VitPageRhythm.standard,
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.defaultGap,
                    density: VitDensity.compact,
                    children: [
                      _EarnHero(snapshot: snapshot),
                      _EarnCtaRow(
                        savingsRoute: snapshot.savingsRoute,
                        dashboardRoute: AppRoutePaths.earnDashboard,
                      ),
                      if (snapshot.highRiskContractId != null)
                        VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Trạng thái rủi ro sinh lời đang bật',
                          message:
                              'Điều khoản, thiết lập validator, xem trước rủi ro, xác nhận, biên nhận, quản lý và hỗ trợ được theo dõi trong một hợp đồng Earn.',
                          contractId: snapshot.highRiskContractId,
                        ),
                      _MainTabs(
                        activeTab: _tab,
                        positionCount: snapshot.positions.length,
                        onChanged: (tab) {
                          unawaited(HapticFeedback.selectionClick());
                          setState(() => _tab = tab);
                        },
                      ),
                      if (_tab == _EarnTab.products) ...[
                        _FilterRow(
                          activeFilter: _filter,
                          onChanged: (filter) {
                            unawaited(HapticFeedback.selectionClick());
                            setState(() => _filter = filter);
                          },
                        ),
                        _ProductList(products: products),
                      ] else
                        _PositionsList(
                          snapshot: snapshot,
                          onExploreProducts: () {
                            unawaited(HapticFeedback.selectionClick());
                            setState(() => _tab = _EarnTab.products);
                          },
                        ),
                      _StakingToolsSection(
                        tools: EarnHubToolsCatalog.stakingTools,
                        onNavigate: context.go,
                      ),
                      _EarnLegalEntry(
                        onTap: () => _showEarnLegalSheet(context),
                      ),
                      const _YieldDisclaimer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

void _showEarnLegalSheet(BuildContext context) {
  final rootContext = context;
  unawaited(HapticFeedback.selectionClick());
  unawaited(
    showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _EarnLegalSheet(
          onNavigate: (route) {
            Navigator.of(sheetContext).pop();
            unawaited(rootContext.push<void>(route));
          },
        );
      },
    ),
  );
}
