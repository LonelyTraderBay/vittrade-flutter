import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dev_tools_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
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

part '../../widgets/performance_monitor_sections.dart';
part '../../widgets/performance_monitor_common.dart';

class PerformanceMonitor extends ConsumerStatefulWidget {
  const PerformanceMonitor({super.key, this.shellRenderMode});

  static const contentKey = Key('sc326_performance_monitor_content');
  static const statesKey = Key('sc326_performance_monitor_states');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends ConsumerState<PerformanceMonitor> {
  DevUiMode _uiMode = DevUiMode.live;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(performanceMonitorSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => _PerformanceMonitorScaffold(
        title: 'Performance Monitor',
        subtitle: 'Based on Core Web Vitals',
        bottomInset: bottomInset,
        body: const _PerformanceLoading(),
      ),
      error: (error, stackTrace) => _PerformanceMonitorScaffold(
        title: 'Performance Monitor',
        subtitle: 'Based on Core Web Vitals',
        bottomInset: bottomInset,
        body: VitErrorState(
          title: 'Monitor unavailable',
          message:
              'Performance metrics could not be loaded. Retry when back online.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(performanceMonitorSnapshotProvider),
        ),
      ),
      data: (snapshot) => _PerformanceMonitorScaffold(
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        bottomInset: bottomInset,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DevStateBar(
              key: PerformanceMonitor.statesKey,
              supportedStates: snapshot.supportedStates,
              active: _uiMode,
              onChanged: (mode) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _uiMode = mode);
              },
            ),
            switch (_uiMode) {
              DevUiMode.loading => const _PerformanceLoading(),
              DevUiMode.empty => const VitEmptyState(
                title: 'No performance samples',
                message:
                    'Run a profiling session to populate vitals and resource timings.',
              ),
              DevUiMode.error => VitErrorState(
                title: 'Monitor unavailable',
                message:
                    'Performance metrics could not be loaded. Retry when back online.',
                onAction: () => setState(() => _uiMode = DevUiMode.live),
              ),
              DevUiMode.offline => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VitOfflineBanner(
                    detail: 'Showing last captured session.',
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  ..._liveSections(snapshot),
                ],
              ),
              DevUiMode.live => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _liveSections(snapshot),
              ),
            },
          ],
        ),
      ),
    );
  }

  List<Widget> _liveSections(PerformanceMonitorSnapshot snapshot) {
    return [
      _PerformanceScoreCard(snapshot: snapshot),
      VitPageSection(
        label: 'Core Web Vitals',
        children: [_VitalsCard(metrics: snapshot.vitals)],
      ),
      VitPageSection(
        label: 'Memory Usage',
        children: [_MemoryCard(memory: snapshot.memory)],
      ),
      VitPageSection(
        label: 'Lazy Loaded Chunks',
        children: [_LazyChunksCard(chunks: snapshot.lazyChunks)],
      ),
      VitPageSection(
        label: 'Top 10 Slowest Resources',
        children: [_ResourcesCard(resources: snapshot.resources)],
      ),
      VitPageSection(
        label: 'Optimization Tips',
        children: [for (final tip in snapshot.tips) _TipCard(tip: tip)],
      ),
      _TargetsCard(targets: snapshot.targets),
      _InternalNotice(text: snapshot.contractNotes),
    ];
  }
}

class _PerformanceLoading extends StatelessWidget {
  const _PerformanceLoading();

  @override
  Widget build(BuildContext context) {
    return const VitSkeletonList(rows: 5);
  }
}

class _PerformanceMonitorScaffold extends StatelessWidget {
  const _PerformanceMonitorScaffold({
    required this.title,
    required this.subtitle,
    required this.bottomInset,
    required this.body,
  });

  final String title;
  final String subtitle;
  final double bottomInset;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Công cụ theo dõi hiệu năng ứng dụng (nội bộ)',
      semanticIdentifier: 'SC-326',
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
                  key: PerformanceMonitor.contentKey,
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
