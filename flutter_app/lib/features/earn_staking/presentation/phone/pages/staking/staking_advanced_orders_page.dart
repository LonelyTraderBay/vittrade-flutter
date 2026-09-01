import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

part '../../../widgets/staking/staking_advanced_orders_overview_orders.dart';
part '../../../widgets/staking/staking_advanced_orders_guidance.dart';
part '../../../widgets/staking/staking_advanced_orders_sheet_fields.dart';

enum _AdvancedOrderTab { active, history }

class StakingAdvancedOrdersPage extends ConsumerStatefulWidget {
  const StakingAdvancedOrdersPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc366_info_banner');
  static const statsKey = Key('sc366_stats');
  static const createButtonKey = Key('sc366_create_order');
  static const tabsKey = Key('sc366_tabs');
  static const createSheetKey = Key('sc366_create_sheet');
  static const howItWorksKey = Key('sc366_how_it_works');
  static const riskKey = Key('sc366_risk');

  static Key tabKey(String id) => Key('sc366_tab_$id');

  static Key orderKey(String id) => Key('sc366_order_$id');

  static Key typeKey(StakingAdvancedOrderType type) =>
      Key('sc366_order_type_${type.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAdvancedOrdersPage> createState() =>
      _StakingAdvancedOrdersPageState();
}

class _StakingAdvancedOrdersPageState
    extends ConsumerState<StakingAdvancedOrdersPage> {
  _AdvancedOrderTab _tab = _AdvancedOrderTab.active;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingAdvancedOrdersSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Lệnh stake nâng cao — đặt chốt lời, cắt lỗ tự động và xem lịch sử lệnh',
      semanticIdentifier: 'SC-366',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingAdvancedOrdersSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;
            final orders = _tab == _AdvancedOrderTab.active
                ? snapshot.activeOrders
                : snapshot.orderHistory;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: snapshot.infoTitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
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
                          VitInfoCallout(
                            key: StakingAdvancedOrdersPage.infoKey,
                            message: snapshot.infoBody,
                            icon: Icons.track_changes_rounded,
                            accentColor: AppModuleAccents.earn,
                          ),
                          _StatsCard(snapshot: snapshot),
                          VitCtaButton(
                            key: StakingAdvancedOrdersPage.createButtonKey,
                            leading: const Icon(Icons.add_rounded),
                            onPressed: () => _showCreateOrder(snapshot),
                            child: const Text('Create Order'),
                          ),
                          _OrderTabs(
                            active: _tab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          VitPageSection(
                            label: _tab == _AdvancedOrderTab.active
                                ? 'Active Orders'
                                : 'Order History',
                            accentColor: AppModuleAccents.earn,
                            children: [
                              for (final order in orders)
                                _OrderCard(order: order),
                            ],
                          ),
                          _HowItWorks(snapshot: snapshot),
                          _RiskDisclosure(snapshot: snapshot),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Advanced staking order review',
                            message:
                                'Order type, trigger condition, asset amount, risk disclosure, create-order preview, submitting state, and result handling are reviewed before an advanced staking order is placed.',
                            contractId: 'SC-366',
                          ),
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

  Future<void> _showCreateOrder(StakingAdvancedOrdersSnapshot snapshot) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _SheetFrame(child: _CreateOrderSheet(snapshot: snapshot)),
    );
  }
}
