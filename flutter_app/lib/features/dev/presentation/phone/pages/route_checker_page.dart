import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dev_tools_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/dev_state_bar.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

part '../../widgets/route_checker_page_sections.dart';
part '../../widgets/route_checker_page_common.dart';

class RouteChecker extends ConsumerStatefulWidget {
  const RouteChecker({super.key, this.shellRenderMode});

  static const contentKey = Key('sc325_route_checker_content');
  static const resetButtonKey = Key('sc325_route_checker_reset');
  static const statesKey = Key('sc325_route_checker_states');
  static Key phaseKey(int? phase) => Key('sc325_phase_${phase ?? 'all'}');
  static Key routeKey(String path) => Key('sc325_route_$path');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RouteChecker> createState() => _RouteCheckerState();
}

class _RouteCheckerState extends ConsumerState<RouteChecker> {
  final Set<String> _testedRoutes = {};
  int? _activePhase;
  DevUiMode _uiMode = DevUiMode.live;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(routeCheckerSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => _RouteCheckerScaffold(
        title: 'Staking Route Checker',
        subtitle: null,
        bottomInset: bottomInset,
        body: const VitSkeletonList(rows: 4),
      ),
      error: (error, stackTrace) => _RouteCheckerScaffold(
        title: 'Staking Route Checker',
        subtitle: null,
        bottomInset: bottomInset,
        body: VitErrorState(
          title: 'Route checker unavailable',
          message: 'Could not load the route registry. Retry when back online.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(routeCheckerSnapshotProvider),
        ),
      ),
      data: (snapshot) {
        final filteredRoutes = _activePhase == null
            ? snapshot.routes
            : snapshot.routes
                  .where((route) => route.phase == _activePhase)
                  .toList();

        return _RouteCheckerScaffold(
          title: snapshot.title,
          subtitle: snapshot.subtitle,
          bottomInset: bottomInset,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DevStateBar(
                key: RouteChecker.statesKey,
                supportedStates: snapshot.supportedStates,
                active: _uiMode,
                onChanged: (mode) {
                  unawaited(HapticFeedback.selectionClick());
                  setState(() => _uiMode = mode);
                },
              ),
              switch (_uiMode) {
                DevUiMode.loading => const _RouteCheckerLoading(),
                DevUiMode.empty => VitEmptyState(
                  title: 'No routes in this phase',
                  message: 'Switch phase filter or return to live data.',
                  actionLabel: 'Show all routes',
                  onAction: () => setState(() {
                    _uiMode = DevUiMode.live;
                    _activePhase = null;
                  }),
                ),
                DevUiMode.error => VitErrorState(
                  title: 'Route checker unavailable',
                  message:
                      'Could not load the route registry. Retry when back online.',
                  onAction: () => setState(() => _uiMode = DevUiMode.live),
                ),
                DevUiMode.offline => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VitOfflineBanner(
                      detail: 'Local route checks still work offline.',
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    ..._liveSections(
                      snapshot: snapshot,
                      filteredRoutes: filteredRoutes,
                    ),
                  ],
                ),
                DevUiMode.live => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: filteredRoutes.isEmpty
                      ? [
                          VitEmptyState(
                            title: 'No routes in this phase',
                            message: 'Pick another phase or reset the filter.',
                            actionLabel: 'Show all routes',
                            onAction: () => setState(() => _activePhase = null),
                          ),
                        ]
                      : _liveSections(
                          snapshot: snapshot,
                          filteredRoutes: filteredRoutes,
                        ),
                ),
              },
            ],
          ),
        );
      },
    );
  }

  List<Widget> _liveSections({
    required RouteCheckerSnapshot snapshot,
    required List<DevRouteDraft> filteredRoutes,
  }) {
    return [
      _IntroBlock(snapshot: snapshot),
      _ProgressCard(
        testedCount: _testedRoutes.length,
        totalCount: snapshot.totalRoutes,
      ),
      VitPageSection(
        label: 'Phase filter',
        children: [
          _PhaseFilters(
            snapshot: snapshot,
            activePhase: _activePhase,
            onChanged: (phase) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _activePhase = phase);
            },
          ),
        ],
      ),
      VitPageSection(
        label: 'Routes',
        children: [
          _RouteList(
            routes: filteredRoutes,
            testedRoutes: _testedRoutes,
            onTapRoute: (route) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _testedRoutes.add(route.path));
            },
          ),
        ],
      ),
      _ActionsRow(
        testedCount: _testedRoutes.length,
        totalCount: snapshot.totalRoutes,
        onReset: () {
          unawaited(HapticFeedback.selectionClick());
          setState(_testedRoutes.clear);
        },
      ),
      _PhaseStats(snapshot: snapshot, testedRoutes: _testedRoutes),
      _InternalNotice(text: snapshot.contractNotes),
    ];
  }
}

class _RouteCheckerLoading extends StatelessWidget {
  const _RouteCheckerLoading();

  @override
  Widget build(BuildContext context) {
    return const VitSkeletonList(rows: 4);
  }
}

class _RouteCheckerScaffold extends StatelessWidget {
  const _RouteCheckerScaffold({
    required this.title,
    required this.subtitle,
    required this.bottomInset,
    required this.body,
  });

  final String title;
  final String? subtitle;
  final double bottomInset;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Công cụ kiểm tra tuyến đường Staking (nội bộ)',
      semanticIdentifier: 'SC-325',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: true,
            onBack: () => context.go(AppRoutePaths.home),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: RouteChecker.contentKey,
                  physics: const ClampingScrollPhysics(),
                  padding: AdminSpacingTokens.devScrollPadding(bottomInset),
                  child: VitPageContent(
                    rhythm: VitPageRhythm.flush,
                    gap: VitContentGap.defaultGap,
                    children: [body],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
