import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

part '../../../widgets/tools/launchpad_gas_tracker_hero.dart';
part '../../../widgets/tools/launchpad_gas_tracker_prices.dart';
part '../../../widgets/tools/launchpad_gas_tracker_chains.dart';
part '../../../widgets/tools/launchpad_gas_tracker_estimator.dart';
part '../../../widgets/tools/launchpad_gas_tracker_alerts.dart';
part '../../../widgets/tools/launchpad_gas_tracker_alert_sheet.dart';
part '../../../widgets/tools/launchpad_gas_tracker_common.dart';

enum _GasTab { prices, estimator, alerts }

class LaunchpadGasTrackerPage extends ConsumerStatefulWidget {
  const LaunchpadGasTrackerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc311_launchpad_gas_content');
  static const heroKey = Key('sc311_launchpad_gas_hero');
  static const tabsKey = Key('sc311_launchpad_gas_tabs');
  static const pricesTabKey = Key('sc311_launchpad_gas_tab_prices');
  static const estimatorTabKey = Key('sc311_launchpad_gas_tab_estimator');
  static const alertsTabKey = Key('sc311_launchpad_gas_tab_alerts');
  static const chainSelectorKey = Key('sc311_launchpad_gas_chains');
  static const chartKey = Key('sc311_launchpad_gas_chart');
  static const eipKey = Key('sc311_launchpad_gas_eip1559');
  static const allChainsKey = Key('sc311_launchpad_gas_all_chains');
  static const estimatesKey = Key('sc311_launchpad_gas_estimates');
  static const alertsKey = Key('sc311_launchpad_gas_alerts');
  static const addAlertKey = Key('sc311_launchpad_gas_add_alert');
  static const addSheetKey = Key('sc311_launchpad_gas_add_sheet');
  static const addSubmitKey = Key('sc311_launchpad_gas_add_submit');
  static const addCloseKey = Key('sc311_launchpad_gas_add_close');

  static Key chainKey(String chain) => Key('sc311_launchpad_gas_chain_$chain');
  static Key estimateKey(String operation) =>
      Key('sc311_launchpad_gas_estimate_$operation');
  static Key alertKey(String id) => Key('sc311_launchpad_gas_alert_$id');
  static Key alertToggleKey(String id) =>
      Key('sc311_launchpad_gas_alert_toggle_$id');
  static Key alertDeleteKey(String id) =>
      Key('sc311_launchpad_gas_alert_delete_$id');
  static Key sheetChainKey(String chain) =>
      Key('sc311_launchpad_gas_sheet_chain_$chain');
  static Key sheetDirectionKey(String value) =>
      Key('sc311_launchpad_gas_sheet_direction_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadGasTrackerPage> createState() =>
      _LaunchpadGasTrackerPageState();
}

class _LaunchpadGasTrackerPageState
    extends ConsumerState<LaunchpadGasTrackerPage> {
  // STATE-S23: alerts sống ở LaunchpadGasTrackerStateController (một nguồn
  // sự thật) — hết `late List` seed từ ref.read + setState.
  // GD4-F4 bẫy 14: initState() không còn seed từ getter đồng bộ — hạt
  // giống 1 lần trong nhánh `data:` qua `_selectedChain ??= ...`.
  var _activeTab = _GasTab.prices;
  String? _selectedChain;
  var _showAddAlert = false;

  @override
  Widget build(BuildContext context) {
    final gasTrackerAsync = ref.watch(launchpadGasTrackerSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.x3;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Theo dõi phí gas trên nhiều chuỗi',
      semanticIdentifier: 'SC-311',
      child: Material(
        type: MaterialType.transparency,
        child: gasTrackerAsync.when(
          loading: () => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: scrollTailReserve,
                semanticLabel: 'Theo dõi phí gas trên nhiều chuỗi',
                semanticIdentifier: 'SC-311',
                header: VitHeader(
                  title: 'Gas Tracker',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: const VitSkeletonList(),
              ),
            ],
          ),
          error: (error, stackTrace) => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: scrollTailReserve,
                semanticLabel: 'Theo dõi phí gas trên nhiều chuỗi',
                semanticIdentifier: 'SC-311',
                header: VitHeader(
                  title: 'Gas Tracker',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: VitErrorState(
                  title: 'Không tải được dữ liệu',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(launchpadGasTrackerSnapshotProvider),
                ),
              ),
            ],
          ),
          data: (_) {
            final viewState = ref.watch(
              launchpadGasTrackerStateControllerProvider,
            );
            final snapshot = viewState.snapshot;
            final selectedChain = _selectedChain ??=
                snapshot.prices.first.chain;
            final selectedGas = snapshot.prices.firstWhere(
              (price) => price.chain == selectedChain,
              orElse: () => snapshot.prices.first,
            );

            return Stack(
              children: [
                VitAutoHideHeaderScaffold(
                  bottomInset: scrollTailReserve,
                  semanticLabel: 'Theo dõi phí gas trên nhiều chuỗi',
                  semanticIdentifier: 'SC-311',
                  header: VitHeader(
                    title: snapshot.title,
                    subtitle: 'Theo dõi phí gas · Lập kế hoạch giao dịch',
                    showBack: true,
                    onBack: () => context.go(snapshot.backRoute),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            LaunchpadSpacingTokens.launchpadHeaderStatsPadding,
                        child: _FeaturedGasCard(price: selectedGas),
                      ),
                      ColoredBox(
                        key: LaunchpadGasTrackerPage.tabsKey,
                        color: AppColors.surface,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(height: AppSpacing.hairlineStroke),
                            Padding(
                              padding: LaunchpadSpacingTokens
                                  .launchpadHorizontalContentPadding,
                              child: _GasTabs(
                                activeTab: _activeTab,
                                onChanged: (tab) =>
                                    setState(() => _activeTab = tab),
                              ),
                            ),
                            const Divider(height: AppSpacing.hairlineStroke),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(
                            context,
                          ).copyWith(scrollbars: false),
                          child: SingleChildScrollView(
                            key: LaunchpadGasTrackerPage.contentKey,
                            physics: const ClampingScrollPhysics(),
                            child: VitPageContent(
                              rhythm: VitPageRhythm.standard,
                              padding: VitContentPadding.compact,
                              gap: VitContentGap.tight,
                              children: [
                                switch (_activeTab) {
                                  _GasTab.prices => _PricesTab(
                                    prices: snapshot.prices,
                                    selectedGas: selectedGas,
                                    selectedChain: selectedChain,
                                    onSelected: (chain) =>
                                        setState(() => _selectedChain = chain),
                                  ),
                                  _GasTab.estimator => _EstimatorTab(
                                    estimates: snapshot.estimates,
                                  ),
                                  _GasTab.alerts => _AlertsTab(
                                    alerts: viewState.alerts,
                                    onAdd: () =>
                                        setState(() => _showAddAlert = true),
                                    onToggle: _toggleAlert,
                                    onDelete: _deleteAlert,
                                  ),
                                },
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showAddAlert)
                  Positioned.fill(
                    child: _AddAlertSheet(
                      prices: snapshot.prices,
                      onClose: () => setState(() => _showAddAlert = false),
                      onAdd: _addAlert,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _toggleAlert(String id) {
    ref
        .read(launchpadGasTrackerStateControllerProvider.notifier)
        .toggleAlert(id);
  }

  void _deleteAlert(String id) {
    ref
        .read(launchpadGasTrackerStateControllerProvider.notifier)
        .deleteAlert(id);
  }

  void _addAlert(LaunchpadGasAlertDraft alert) {
    ref
        .read(launchpadGasTrackerStateControllerProvider.notifier)
        .addAlert(alert);
    setState(() => _showAddAlert = false);
  }
}

class _GasTabs extends StatelessWidget {
  const _GasTabs({required this.activeTab, required this.onChanged});

  final _GasTab activeTab;
  final ValueChanged<_GasTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeTab.name,
      tabs: const [
        VitTabItem(
          key: 'prices',
          label: 'prices',
          widgetKey: LaunchpadGasTrackerPage.pricesTabKey,
        ),
        VitTabItem(
          key: 'estimator',
          label: 'estimator',
          widgetKey: LaunchpadGasTrackerPage.estimatorTabKey,
        ),
        VitTabItem(
          key: 'alerts',
          label: 'alerts',
          widgetKey: LaunchpadGasTrackerPage.alertsTabKey,
        ),
      ],
      onChanged: (key) => onChanged(_GasTab.values.byName(key)),
    );
  }
}
