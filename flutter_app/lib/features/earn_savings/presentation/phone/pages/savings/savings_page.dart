import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/earn_core/domain/earn_hub_tools_catalog.dart';
part '../../../widgets/savings/savings_home_hero.dart';
part '../../../widgets/savings/savings_home_products.dart';
part '../../../widgets/savings/savings_home_positions.dart';
part '../../../widgets/savings/savings_home_common.dart';

enum _SavingsTab { products, my }

enum _SavingsFilter { all, flexible, locked }

class SavingsPage extends ConsumerStatefulWidget {
  const SavingsPage({super.key, this.shellRenderMode});

  static const productsTabKey = Key('sc329_tab_products');
  static const myTabKey = Key('sc329_tab_my');
  static const portfolioButtonKey = Key('sc329_portfolio_button');
  static const productDetailButtonKey = Key('sc329_product_detail_button');
  static const guideButtonKey = Key('sc329_guide_button');
  static const exportButtonKey = Key('sc329_export_button');
  static const toolsSectionKey = Key('sc329_tools_section');
  static const moreToolsKey = Key('sc329_more_tools');
  static const moreToolsSheetKey = Key('sc329_more_tools_sheet');
  static const dcaInsightKey = Key('sc329_dca_insight');
  static const exportInsightKey = Key('sc329_export_insight');
  static const backtestInsightKey = Key('sc329_backtest_insight');
  static const autopilotInsightKey = Key('sc329_autopilot_insight');
  static const ladderInsightKey = Key('sc329_ladder_insight');
  static const whatIfInsightKey = Key('sc329_whatif_insight');
  static const smartSuggestionsInsightKey = Key(
    'sc329_smart_suggestions_insight',
  );
  static Key filterKey(String filter) => Key('sc329_filter_$filter');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends ConsumerState<SavingsPage> {
  _SavingsTab _tab = _SavingsTab.products;
  _SavingsFilter _filter = _SavingsFilter.all;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(savingsControllerProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tiết kiệm',
      semanticIdentifier: 'SC-329',
      child: Material(
        color: AppColors.bg,
        child: controllerAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => goBackOrFallback(
                context,
                fallbackPath: '/earn',
                mode: BackNavigationMode.historyThenFallback,
              ),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => goBackOrFallback(
                context,
                fallbackPath: '/earn',
                mode: BackNavigationMode.historyThenFallback,
              ),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(savingsSnapshotProvider),
            ),
          ),
          data: (controller) {
            final snapshot = controller.state.snapshot;
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;
            final products = _filteredProducts(controller, _filter);

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: snapshot.subtitle,
                showBack: true,
                onBack: () => goBackOrFallback(
                  context,
                  fallbackPath: snapshot.backRoute,
                  mode: BackNavigationMode.historyThenFallback,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _SavingsHero(snapshot: snapshot),
                          _SavingsTabs(
                            activeTab: _tab,
                            positionCount: snapshot.positions.length,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          if (_tab == _SavingsTab.products) ...[
                            _SavingsFilters(
                              activeFilter: _filter,
                              onChanged: (filter) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _filter = filter);
                              },
                            ),
                            _SavingsProductList(
                              products: products,
                              detailRoute: snapshot.productDetailRoute,
                            ),
                          ] else
                            _SavingsPositions(positions: snapshot.positions),
                          _SavingsToolsSection(
                            tools: EarnHubToolsCatalog.savingsTools,
                            onNavigate: (route) => context.go(route),
                          ),
                          const _YieldDisclaimer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
