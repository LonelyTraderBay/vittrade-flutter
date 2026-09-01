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

part '../../widgets/missing_screens_showcase_page_sections.dart';
part '../../widgets/missing_screens_showcase_page_common.dart';

class MissingScreensShowcasePage extends ConsumerStatefulWidget {
  const MissingScreensShowcasePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc398_missing_screens_content');
  static const tabsKey = Key('sc398_missing_screens_tabs');
  static const statesKey = Key('sc398_missing_screens_states');
  static const newSectionKey = Key('sc398_missing_screens_new');
  static const v2SectionKey = Key('sc398_missing_screens_v2');
  static Key screenKey(String id) => Key('sc398_screen_$id');
  static Key v2PageKey(String id) => Key('sc398_v2_$id');
  static Key flowKey(String id) => Key('sc398_flow_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MissingScreensShowcasePage> createState() =>
      _MissingScreensShowcasePageState();
}

class _MissingScreensShowcasePageState
    extends ConsumerState<MissingScreensShowcasePage> {
  String _activeTab = 'new';
  DevUiMode _uiMode = DevUiMode.live;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(missingScreensShowcaseSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return snapshotAsync.when(
      loading: () => _ShowcaseScaffold(
        title: '03 – Missing Screens & Flow Fix',
        subtitle: 'No redesign • Chỉ tạo mới + v2 entry points',
        bottomInset: bottomInset,
        body: const _ShowcaseLoading(),
      ),
      error: (error, stackTrace) => _ShowcaseScaffold(
        title: '03 – Missing Screens & Flow Fix',
        subtitle: 'No redesign • Chỉ tạo mới + v2 entry points',
        bottomInset: bottomInset,
        body: VitErrorState(
          title: 'Showcase unavailable',
          message: 'Could not load screen catalog. Retry when back online.',
          actionLabel: 'Thử lại',
          onAction: () =>
              ref.invalidate(missingScreensShowcaseSnapshotProvider),
        ),
      ),
      data: (snapshot) => _ShowcaseScaffold(
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        bottomInset: bottomInset,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DevStateBar(
              key: MissingScreensShowcasePage.statesKey,
              supportedStates: snapshot.supportedStates,
              active: _uiMode,
              onChanged: (mode) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _uiMode = mode);
              },
            ),
            switch (_uiMode) {
              DevUiMode.loading => const _ShowcaseLoading(),
              DevUiMode.empty => const VitEmptyState(
                title: 'No showcase entries',
                message:
                    'Add missing screens to the dev registry to preview flows here.',
              ),
              DevUiMode.error => VitErrorState(
                title: 'Showcase unavailable',
                message:
                    'Could not load screen catalog. Retry when back online.',
                onAction: () => setState(() => _uiMode = DevUiMode.live),
              ),
              DevUiMode.offline => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VitOfflineBanner(
                    detail: 'Cached routes remain navigable offline.',
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

  List<Widget> _liveSections(MissingScreensShowcaseSnapshot snapshot) {
    return [
      VitPageSection(
        label: 'Catalog',
        children: [
          VitTabBar(
            key: MissingScreensShowcasePage.tabsKey,
            tabs: [
              for (final tab in snapshot.tabs)
                VitTabItem(key: tab.id, label: tab.label),
            ],
            activeKey: _activeTab,
            onChanged: (tab) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _activeTab = tab);
            },
            variant: VitTabBarVariant.segment,
          ),
          if (_activeTab == 'new')
            _NewScreensSection(snapshot: snapshot)
          else
            _V2ScreensSection(snapshot: snapshot),
        ],
      ),
    ];
  }
}

class _ShowcaseLoading extends StatelessWidget {
  const _ShowcaseLoading();

  @override
  Widget build(BuildContext context) {
    return const VitSkeletonList(rows: 3);
  }
}

class _ShowcaseScaffold extends StatelessWidget {
  const _ShowcaseScaffold({
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
      semanticLabel:
          'Danh sách màn hình bổ sung và điểm vào v2 (công cụ nội bộ)',
      semanticIdentifier: 'SC-398',
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
                  key: MissingScreensShowcasePage.contentKey,
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
