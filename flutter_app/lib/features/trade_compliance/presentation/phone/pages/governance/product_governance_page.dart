import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/governance/product_governance_overview_tabs.dart';
part '../../../widgets/governance/product_governance_products.dart';
part '../../../widgets/governance/product_governance_reviews_distribution.dart';

const _govBorder = AppColors.borderSolid;
const _govGreen = AppColors.buy;
const _govPrimary = AppColors.primary;
const _govAmber = AppColors.caution;
const _govRed = AppColors.sell;

/// Real display name of the governance section shown for [tabId] — mirrors
/// the visible tab label in [_Tabs] — so compliance copy never leaks the
/// raw internal tab-id state variable to end users.
String _governanceSectionLabel(String tabId) => switch (tabId) {
  'reviews' => 'Reviews',
  'distribution' => 'Distribution',
  _ => 'Products',
};

class ProductGovernancePage extends ConsumerStatefulWidget {
  const ProductGovernancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc100_product_governance_content');
  static Key tabKey(String id) => Key('sc100_product_tab_$id');
  static Key productKey(String id) => Key('sc100_product_$id');
  static Key targetMarketKey(String id) => Key('sc100_target_market_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProductGovernancePage> createState() =>
      _ProductGovernancePageState();
}

class _ProductGovernancePageState extends ConsumerState<ProductGovernancePage> {
  String? _tab;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeProductGovernanceProvider);
    return VitTradeHubScaffold(
      title: 'Product Governance',
      subtitle: 'MiFID II Oversight',
      semanticLabel: 'Quản trị sản phẩm và giám sát theo MiFID II',
      semanticIdentifier: 'SC-100',
      contentKey: ProductGovernancePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeProductGovernanceProvider),
          ),
        ],
        data: (snapshot) {
          _tab ??= snapshot.defaultTab;
          return [
            const VitTradeSection(
              title: 'Review',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                density: VitDensity.tool,
                title: 'Product governance review',
                message:
                    'Review target market, negative market, risk level, distribution channel, fee disclosure, and next review deadline before approving copy products.',
                contractId: 'SC-100 product governance review',
              ),
            ),
            VitTradeSection(
              title: 'Notice',
              child: VitTradeComplianceHero(
                title: 'All Products Compliant',
                description:
                    '${snapshot.products.length}/3 products have approved target markets. Next review: ${snapshot.nextReviewLabel}.',
                icon: Icons.check_circle_outline,
                accentColor: _govGreen,
              ),
            ),
            VitTradeComplianceSection(
              title: 'Governance review',
              statusPill: const VitStatusPill(
                label: 'Review required',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(
                  label: 'Products',
                  value: '${snapshot.products.length} tracked',
                ),
                VitTradeComplianceItem(
                  label: 'Viewing',
                  value: _governanceSectionLabel(_tab!),
                ),
              ],
            ),
            VitTradeSection(
              title: 'Products',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Stats(products: snapshot.products),
                  VitCard(
                    density: VitDensity.tool,
                    radius: VitCardRadius.tight,
                    padding: AppSpacing.zeroInsets,
                    child: VitTabBar(
                      variant: VitTabBarVariant.underline,
                      activeKey: _tab!,
                      tabs: [
                        for (final tab in const [
                          ('products', 'Products'),
                          ('reviews', 'Reviews'),
                          ('distribution', 'Distribution'),
                        ])
                          VitTabItem(
                            key: tab.$1,
                            label: tab.$2,
                            widgetKey: ProductGovernancePage.tabKey(tab.$1),
                          ),
                      ],
                      onChanged: (id) => setState(() => _tab = id),
                    ),
                  ),
                  if (_tab == 'products')
                    _ProductsTab(products: snapshot.products)
                  else if (_tab == 'reviews')
                    _ReviewsTab(products: snapshot.products)
                  else
                    _DistributionTab(products: snapshot.products),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
