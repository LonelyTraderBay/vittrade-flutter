import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

part '../../../widgets/tools/advanced_tools_overview.dart';
part '../../../widgets/tools/advanced_tools_tabs_sheets.dart';
part '../../../widgets/tools/advanced_tools_common.dart';

const _toolsPrimary = AppColors.primary;
const _toolsSpace = AppSpacing.x2;
const _toolsCardSpace = AppSpacing.x3;
const _toolsBodyLineHeight = 1.24;

enum _ToolsTab { ladder, bulk, shortcuts }

class AdvancedToolsDemoPage extends ConsumerStatefulWidget {
  const AdvancedToolsDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc062_advanced_tools_scroll_content');
  static const ladderButtonKey = Key('sc062_open_ladder');
  static const bulkButtonKey = Key('sc062_open_bulk');
  static const shortcutsButtonKey = Key('sc062_open_shortcuts');
  static const ladderSubmitKey = Key('sc062_submit_ladder');
  static const bulkCancelKey = Key('sc062_bulk_cancel');
  static const shortcutTriggerKey = Key('sc062_shortcut_trigger');

  static Key tabKey(String id) => Key('sc062_tab_$id');
  static Key featureKey(String id) => Key('sc062_feature_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedToolsDemoPage> createState() =>
      _AdvancedToolsDemoPageState();
}

class _AdvancedToolsDemoPageState extends ConsumerState<AdvancedToolsDemoPage> {
  _ToolsTab _tab = _ToolsTab.ladder;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeAdvancedToolsControllerProvider);

    return VitTradeHubScaffold(
      title: 'Công cụ nâng cao',
      subtitle: 'Thang giá · Hàng loạt · Phím tắt',
      semanticLabel: 'Công cụ nâng cao',
      semanticIdentifier: 'SC-062',
      contentKey: AdvancedToolsDemoPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      showProductTabs: true,
      navigationBuilder: buildTradeProductNavigation,
      children: controllerAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được công cụ nâng cao',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeAdvancedToolsSnapshotProvider),
          ),
        ],
        data: (controller) {
          final snapshot = controller.state.snapshot;
          return [
            const _IntroCard(),
            const VitCard(
              variant: VitCardVariant.inner,
              density: VitDensity.tool,
              radius: VitCardRadius.tight,
              padding: AppSpacing.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    title: 'Xem lại công cụ lệnh nâng cao',
                    message:
                        'Thang giá, hủy hàng loạt và phím tắt giữ xem trước lệnh, xác nhận, số lệnh bị ảnh hưởng và bước tiếp theo trước khi thực thi.',
                    contractId: 'advanced-tools-review',
                    density: VitDensity.tool,
                  ),
                  SizedBox(height: _toolsSpace),
                  VitStatusPill(
                    label: 'Xem trước khi gửi lệnh',
                    status: VitStatusPillStatus.info,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ),
            for (final feature in snapshot.features)
              _FeatureCard(
                feature: feature,
                onTap: () => _onFeatureTap(feature),
              ),
            const _SpeedCard(),
            const _BenefitsCard(),
            _ProgressCard(items: snapshot.statusItems),
            _ToolsTabs(
              active: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            if (_tab == _ToolsTab.ladder)
              _ActionTab(
                description:
                    'Click any price level on the order book to place instant orders',
                buttonKey: AdvancedToolsDemoPage.ladderButtonKey,
                label: 'Open Ladder Trading',
                icon: Icons.track_changes_rounded,
                colors: const [AppColors.buy, AppColors.buyDark],
                onOpen: _openLadderSheet,
              )
            else if (_tab == _ToolsTab.bulk)
              _ActionTab(
                description: 'Select multiple orders and perform batch actions',
                buttonKey: AdvancedToolsDemoPage.bulkButtonKey,
                label: 'Open Bulk Operations',
                icon: Icons.check_box_rounded,
                colors: const [AppColors.caution, AppColors.medalBronzeMuted],
                onOpen: _openBulkSheet,
              )
            else
              _ActionTab(
                description:
                    'View all keyboard shortcuts and customize key bindings',
                buttonKey: AdvancedToolsDemoPage.shortcutsButtonKey,
                label: 'View Shortcuts Reference',
                icon: Icons.keyboard_rounded,
                colors: const [AppColors.accent, AppColors.accentDark],
                onOpen: _openShortcutsSheet,
              ),
          ];
        },
      ),
    );
  }

  void _onFeatureTap(TradeAdvancedToolFeature feature) {
    if (feature.id == 'bulk') {
      setState(() => _tab = _ToolsTab.bulk);
      unawaited(_openBulkSheet());
      return;
    }
    if (feature.id == 'shortcuts') {
      setState(() => _tab = _ToolsTab.shortcuts);
      unawaited(_openShortcutsSheet());
      return;
    }
    setState(() => _tab = _ToolsTab.ladder);
    unawaited(_openLadderSheet());
  }

  Future<void> _openLadderSheet() async {
    final controller = ref.read(tradeAdvancedToolsControllerProvider).value;
    if (controller == null) return;
    final placed = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _LadderSheet(orders: controller.state.snapshot.ladderOrders),
    );
    if (placed != true || !mounted) return;
    await controller.submitAction(
      const TradeAdvancedToolActionRequest(
        toolId: 'ladder',
        action: 'place-order',
      ),
    );
    if (!mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Đặt lệnh thành công',
        message: 'Đã đặt lệnh mua · 0.5 BTC',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }

  Future<void> _openBulkSheet() async {
    final controller = ref.read(tradeAdvancedToolsControllerProvider).value;
    if (controller == null) return;
    final orderIds = controller.state.snapshot.bulkOrders
        .map((order) => order.id)
        .toList(growable: false);
    final cancelled = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _BulkSheet(orders: controller.state.snapshot.bulkOrders),
    );
    if (cancelled != true || !mounted) return;
    final result = await controller.submitAction(
      TradeAdvancedToolActionRequest(
        toolId: 'bulk',
        action: 'cancel',
        orderIds: orderIds,
      ),
    );
    if (!mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Hủy lệnh thành công',
        message: 'Đã hủy ${result.affectedCount} lệnh',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }

  Future<void> _openShortcutsSheet() async {
    final controller = ref.read(tradeAdvancedToolsControllerProvider).value;
    if (controller == null) return;
    final triggered = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          _ShortcutsSheet(shortcuts: controller.state.snapshot.shortcuts),
    );
    if (triggered != true || !mounted) return;
    await controller.submitAction(
      const TradeAdvancedToolActionRequest(
        toolId: 'shortcuts',
        action: 'trigger',
      ),
    );
    if (!mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Kích hoạt thành công',
        message: 'Phím tắt · Quick Buy',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }
}
