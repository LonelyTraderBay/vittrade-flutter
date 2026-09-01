import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/bridge/launchpad_bridge_order_hero.dart';
part '../../../widgets/bridge/launchpad_bridge_order_timeline.dart';
part '../../../widgets/bridge/launchpad_bridge_order_events.dart';
part '../../../widgets/bridge/launchpad_bridge_order_details.dart';

class LaunchpadBridgeOrderPage extends ConsumerStatefulWidget {
  const LaunchpadBridgeOrderPage({
    super.key,
    this.txId = 'tx001',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc303_launchpad_bridge_order_content');
  static const heroKey = Key('sc303_launchpad_bridge_order_hero');
  static const timelineKey = Key('sc303_launchpad_bridge_order_timeline');
  static const eventLogKey = Key('sc303_launchpad_bridge_order_event_log');
  static const detailsKey = Key('sc303_launchpad_bridge_order_details');
  static const safetyKey = Key('sc303_launchpad_bridge_order_safety');
  static const supportKey = Key('sc303_launchpad_bridge_order_support');

  static Key stepKey(String id) => Key('sc303_launchpad_bridge_step_$id');
  static Key eventKey(String id) => Key('sc303_launchpad_bridge_event_$id');

  final String txId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadBridgeOrderPage> createState() =>
      _LaunchpadBridgeOrderPageState();
}

class _LaunchpadBridgeOrderPageState
    extends ConsumerState<LaunchpadBridgeOrderPage> {
  var _logExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bridgeOrderAsync = ref.watch(
      launchpadBridgeOrderSnapshotProvider(widget.txId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    // GD4-F4: subtitle phụ thuộc snapshot.order nên bọc CẢ scaffold.
    return bridgeOrderAsync.when(
      loading: () => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Theo dõi trạng thái đơn bridge',
        semanticIdentifier: 'SC-303',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            semanticLabel: 'Đơn bridge – vùng cuộn nội dung',
            semanticIdentifier: 'SC-303',
            header: VitHeader(
              title: 'Chi tiet Bridge',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpadIdoBridgeSample),
            ),
            child: const VitSkeletonList(),
          ),
        ),
      ),
      error: (error, stackTrace) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Theo dõi trạng thái đơn bridge',
        semanticIdentifier: 'SC-303',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            semanticLabel: 'Đơn bridge – vùng cuộn nội dung',
            semanticIdentifier: 'SC-303',
            header: VitHeader(
              title: 'Chi tiet Bridge',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpadIdoBridgeSample),
            ),
            child: VitErrorState(
              title: 'Không tải được dữ liệu',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                launchpadBridgeOrderSnapshotProvider(widget.txId),
              ),
            ),
          ),
        ),
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Theo dõi trạng thái đơn bridge',
        semanticIdentifier: 'SC-303',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            semanticLabel: 'Đơn bridge – vùng cuộn nội dung',
            semanticIdentifier: 'SC-303',
            header: VitHeader(
              title: snapshot.title,
              subtitle:
                  '${snapshot.order.sourceChain} → ${snapshot.order.targetChain}',
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                key: LaunchpadBridgeOrderPage.contentKey,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsetsDirectional.only(bottom: scrollEndPadding),
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  padding: VitContentPadding.compact,
                  density: VitDensity.compact,
                  children: [
                    _BridgeStatusHero(order: snapshot.order),
                    if (snapshot.highRiskContractId != null)
                      VitHighRiskStatePanel(
                        state: VitHighRiskUiState.success,
                        title: 'Đã theo dõi trạng thái bridge',
                        message:
                            'Điều kiện, xem trước hợp đồng, xác nhận, trạng thái gửi, biên lai và hỗ trợ gắn với hợp đồng rủi ro cao Launchpad.',
                        contractId: snapshot.highRiskContractId,
                      ),
                    _BridgeTimeline(order: snapshot.order),
                    _BridgeEventLog(
                      order: snapshot.order,
                      events: snapshot.events,
                      expanded: _logExpanded,
                      onToggle: () =>
                          setState(() => _logExpanded = !_logExpanded),
                    ),
                    _BridgeDetails(order: snapshot.order),
                    const _SimulationDisclosure(),
                    _BridgeSupportAction(supportRoute: snapshot.supportRoute),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
