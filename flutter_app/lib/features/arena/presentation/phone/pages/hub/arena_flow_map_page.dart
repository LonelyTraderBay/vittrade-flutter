import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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

part '../../../widgets/phone/arena_flow_map_overview.dart';
part '../../../widgets/phone/arena_flow_map_nodes.dart';
part '../../../widgets/phone/arena_flow_map_qa.dart';

const double _flowMapVisualScrollClearance = 108;
const double _flowMapNativeScrollClearance = 72;
const double _flowMapDividerHeight = AppSpacing.dividerHairline;
const double _flowMapSmallIcon = AppSpacing.iconSm + AppSpacing.x1;
const double _flowMapInlineIcon = AppSpacing.iconSm + AppSpacing.x2;
const double _flowMapSectionIcon = AppSpacing.iconMd;
const double _flowMapConnectionLineHeight = 1.25;
const double _flowMapHeroLineHeight = 1.28;
const double _flowMapBodyLineHeight = 1.25;
const double _flowMapQaLineHeight = 1.25;
const EdgeInsetsDirectional _flowMapCardPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsDirectional _flowMapInnerPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsDirectional _flowMapSectionTogglePadding =
    EdgeInsetsDirectional.symmetric(vertical: AppSpacing.x2);
const EdgeInsetsDirectional _flowMapRouteHeaderPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x4,
      vertical: AppSpacing.x2,
    );
const EdgeInsetsDirectional _flowMapRouteRowPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: AppSpacing.x4,
      vertical: AppSpacing.x2,
    );

class ArenaFlowMapPage extends ConsumerStatefulWidget {
  const ArenaFlowMapPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc197_flow_map_content');
  static const checkAllKey = Key('sc197_check_all');

  static Key sectionKey(String id) => Key('sc197_section_$id');
  static Key routeKey(String path) => Key('sc197_route_$path');
  static Key nodeKey(String label) => Key('sc197_node_$label');
  static Key qaKey(String id) => Key('sc197_qa_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaFlowMapPage> createState() => _ArenaFlowMapPageState();
}

class _ArenaFlowMapPageState extends ConsumerState<ArenaFlowMapPage> {
  String _expandedSection = 'flow';
  final Set<String> _checkedQa = <String>{};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaFlowMapSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _flowMapVisualScrollClearance
            : _flowMapNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Sơ đồ luồng điều hướng Open Arena - route, node và checklist QA nội bộ',
      semanticIdentifier: 'SC-197',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Open Arena Flow Map',
            subtitle: '06F — Prototype & QA',
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
                    key: ArenaFlowMapPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Flow Map',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(arenaFlowMapSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) => [
                          _FlowHero(stats: snapshot.stats),
                          _CollapsibleSection(
                            id: 'flow',
                            title: 'SECTION 1 — Flow Map',
                            badge: '${snapshot.groups.length} flows',
                            icon: Icons.map_outlined,
                            color: AppColors.primary,
                            expanded: _expandedSection == 'flow',
                            onTap: () => _toggle('flow'),
                            child: _FlowMapBody(
                              snapshot: snapshot,
                              onRoute: (route) => _go(context, route),
                            ),
                          ),
                          _CollapsibleSection(
                            id: 'handoff',
                            title: 'SECTION 2 — Handoff Notes',
                            badge: '${snapshot.handoffNotes.length} notes',
                            icon: Icons.menu_book_outlined,
                            color: AppColors.warn,
                            expanded: _expandedSection == 'handoff',
                            onTap: () => _toggle('handoff'),
                            child: _HandoffNotes(notes: snapshot.handoffNotes),
                          ),
                          _CollapsibleSection(
                            id: 'qa',
                            title: 'SECTION 3 — QA Checklist',
                            badge:
                                '${_checkedQa.length}/${snapshot.qaItems.length}',
                            icon: Icons.check_circle_outline,
                            color: AppColors.buy,
                            expanded: _expandedSection == 'qa',
                            onTap: () => _toggle('qa'),
                            child: _QaChecklist(
                              items: snapshot.qaItems,
                              checkedIds: _checkedQa,
                              onToggle: (id) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  if (!_checkedQa.add(id)) {
                                    _checkedQa.remove(id);
                                  }
                                });
                              },
                              onCheckAll: () {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() {
                                  _checkedQa
                                    ..clear()
                                    ..addAll(
                                      snapshot.qaItems.map((item) => item.id),
                                    );
                                });
                              },
                            ),
                          ),
                          _FlowDisclaimer(text: snapshot.disclaimer),
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

  void _toggle(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _expandedSection = _expandedSection == id ? '' : id);
  }

  void _go(BuildContext context, String route) {
    unawaited(HapticFeedback.selectionClick());
    context.go(route);
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
