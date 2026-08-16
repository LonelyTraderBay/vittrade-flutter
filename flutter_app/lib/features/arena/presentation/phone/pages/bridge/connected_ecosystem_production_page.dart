import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part 'connected_ecosystem_production_page_canonical_states_section.dart';
part 'connected_ecosystem_production_page_flows_registry_handoff.dart';
part 'connected_ecosystem_production_page_handoff_and_shared_widgets.dart';

enum _EcosystemSection { canonical, states, flows, registry, handoff }

const _ecosystemIntroLineHeight = 1.16;
const _ecosystemTitleLineHeight = 1.12;
const _ecosystemBodyLineHeight = 1.22;
const _ecosystemMetricLineHeight = 1.12;
const _ecosystemCheckLineHeight = 1.18;
const _ecosystemFlowConnectorHeight = 36.0;

class ConnectedEcosystemProductionPage extends ConsumerStatefulWidget {
  const ConnectedEcosystemProductionPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc208_ecosystem_content');
  static const tabsKey = Key('sc208_ecosystem_tabs');

  static Key tabKey(String id) => Key('sc208_tab_$id');
  static Key screenKey(String name) => Key('sc208_screen_$name');
  static Key flowStepKey(String flowId, String label) =>
      Key('sc208_flow_${flowId}_$label');
  static Key handoffKey(String id) => Key('sc208_handoff_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ConnectedEcosystemProductionPage> createState() =>
      _ConnectedEcosystemProductionPageState();
}

class _ConnectedEcosystemProductionPageState
    extends ConsumerState<ConnectedEcosystemProductionPage> {
  _EcosystemSection _activeSection = _EcosystemSection.canonical;
  String _activeHandoffBoard = 'routes';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      connectedEcosystemProductionSnapshotProvider,
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollEndPadding =
        navClearance +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x6 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Hệ sinh thái kết nối Arena - trạng thái canonical, luồng E2E và tài liệu bàn giao release',
      semanticIdentifier: 'SC-208',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: '09E - Connected Ecosystem',
            subtitle: 'Release Readiness',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ConnectedEcosystemProductionPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      scrollEndPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Connected Ecosystem',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              connectedEcosystemProductionSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          const _EcosystemHero(),
                          _SectionTabs(
                            active: _activeSection,
                            onChanged: (section) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _activeSection = section);
                            },
                          ),
                          _ActiveSection(
                            section: _activeSection,
                            snapshot: snapshot,
                            activeHandoffBoard: _activeHandoffBoard,
                            onHandoffBoardChanged: (board) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _activeHandoffBoard = board);
                            },
                            onRoute: (route) => _go(context, route),
                          ),
                          _EcosystemFooter(text: snapshot.footerDisclosure),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String route) {
    unawaited(HapticFeedback.selectionClick());
    context.go(_resolveConnectedRoute(route));
  }

  void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}
