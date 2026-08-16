import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/dca_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/dca_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/phone/dca_currency_formatters.dart';

part '../../../widgets/phone/dca_overview_demo_shell.dart';
part '../../../widgets/phone/dca_overview_demo_metrics.dart';
part '../../../widgets/phone/dca_overview_demo_actions.dart';

enum _DcaUiMode { live, loading, empty, error, offline }

class DCAOverviewDemo extends ConsumerStatefulWidget {
  const DCAOverviewDemo({super.key, this.shellRenderMode});

  static const contentKey = Key('sc400_dca_overview_content');
  static const statesKey = Key('sc400_dca_overview_states');
  static const loadingToggleKey = Key('sc400_loading_toggle');
  static const loadingSectionKey = Key('sc400_loading_section');
  static const mobilePreviewKey = Key('sc400_mobile_preview');
  static const footerKey = Key('sc400_footer');

  static Key scenarioKey(String id) => Key('sc400_scenario_$id');
  static Key cardKey(String id) => Key('sc400_card_$id');
  static Key actionKey(String id, String action) => Key('sc400_${id}_$action');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAOverviewDemo> createState() => _DCAOverviewDemoState();
}

class _DCAOverviewDemoState extends ConsumerState<DCAOverviewDemo> {
  bool _showLoading = false;
  _DcaUiMode _uiMode = _DcaUiMode.live;

  @override
  Widget build(BuildContext context) {
    final dcaOverviewDemoAsync = ref.watch(dcaOverviewDemoProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    // GD4 (mục 5, biến thể 2): header phụ thuộc snapshot.title/subtitle/
    // backRoute (không suy ra được từ tham số trang) — bọc toàn bộ scaffold,
    // mỗi nhánh AsyncValue trả về đầy đủ với fallback title/subtitle/
    // backRoute tĩnh khớp hằng số trong fixture cho loading/error.
    return dcaOverviewDemoAsync.when(
      loading: () => _scaffold(
        title: 'DCA Overview Card Demo',
        subtitle: 'Demo · DCA',
        backRoute: '/home',
        actions: const [],
        body: const VitSkeletonList(),
      ),
      error: (error, stackTrace) => _scaffold(
        title: 'DCA Overview Card Demo',
        subtitle: 'Demo · DCA',
        backRoute: '/home',
        actions: const [],
        body: VitErrorState(
          title: 'Không tải được demo tổng quan DCA',
          message: 'Thử lại sau.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(dcaOverviewDemoProvider),
        ),
      ),
      data: (snapshot) => _scaffold(
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        backRoute: snapshot.backRoute,
        actions: [
          VitHeaderActionItem(
            key: DCAOverviewDemo.loadingToggleKey,
            type: VitHeaderActionType.help,
            tooltip: 'Loading demo',
            active: _showLoading,
            onPressed: () {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _showLoading = !_showLoading);
            },
          ),
        ],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: DCAOverviewDemo.contentKey,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsetsDirectional.only(bottom: scrollEndClearance),
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  gap: VitContentGap.tight,
                  children: [
                    _DcaStateBar(
                      key: DCAOverviewDemo.statesKey,
                      supportedStates: snapshot.supportedStates,
                      active: _uiMode,
                      onChanged: (mode) {
                        unawaited(HapticFeedback.selectionClick());
                        setState(() => _uiMode = mode);
                      },
                    ),
                    switch (_uiMode) {
                      _DcaUiMode.loading => const _DcaOverviewLoading(),
                      _DcaUiMode.empty => const VitEmptyState(
                        title: 'No DCA scenarios',
                        message:
                            'Add overview card scenarios to preview profitable and loss states.',
                      ),
                      _DcaUiMode.error => VitErrorState(
                        title: 'Overview demo unavailable',
                        message:
                            'Could not load DCA card scenarios. Retry when back online.',
                        onAction: () =>
                            setState(() => _uiMode = _DcaUiMode.live),
                      ),
                      _DcaUiMode.offline => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const VitOfflineBanner(
                            detail: 'Showing cached scenario fixtures.',
                          ),
                          ..._liveSections(snapshot),
                        ],
                      ),
                      _DcaUiMode.live => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _liveSections(snapshot),
                      ),
                    },
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scaffold({
    required String title,
    required String subtitle,
    required String backRoute,
    required List<VitHeaderActionItem> actions,
    required Widget body,
  }) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Demo thẻ tổng quan DCA với các kịch bản lãi, lỗ và lỗi',
      semanticIdentifier: 'SC-400',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: true,
            onBack: () => context.go(backRoute),
            actions: actions,
          ),
          child: body,
        ),
      ),
    );
  }

  List<Widget> _liveSections(DcaOverviewDemoSnapshot snapshot) {
    return [
      VitPageSection(
        label: snapshot.componentName,
        children: [
          Text(
            snapshot.componentLocation,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
      if (_showLoading)
        _DemoSection(
          key: DCAOverviewDemo.loadingSectionKey,
          title: 'Loading State (Skeleton Shimmer)',
          description: 'Hiệu ứng shimmer khi data đang tải.',
          child: _DcaOverviewCardPreview(
            scenario: snapshot.scenarios.first,
            isLoading: true,
          ),
        ),
      for (final scenario in snapshot.scenarios)
        _DemoSection(
          key: DCAOverviewDemo.scenarioKey(scenario.id),
          title: scenario.title,
          description: scenario.description,
          child: _DcaOverviewCardPreview(scenario: scenario),
        ),
      _DemoSection(
        key: DCAOverviewDemo.mobilePreviewKey,
        title: snapshot.mobilePreview.title,
        description: snapshot.mobilePreview.description,
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: DcaSpacingTokens.dcaOverviewPreviewMaxWidth,
            ),
            child: VitCard(
              variant: VitCardVariant.ghost,
              radius: VitCardRadius.large,
              borderColor: AppColors.borderSolid,
              padding: const EdgeInsetsDirectional.all(AppSpacing.x2),
              child: _DcaOverviewCardPreview(
                scenario: snapshot.mobilePreview,
                compact: true,
              ),
            ),
          ),
        ),
      ),
      _DemoFooter(snapshot: snapshot),
    ];
  }
}

class _DcaStateBar extends StatelessWidget {
  const _DcaStateBar({
    super.key,
    required this.supportedStates,
    required this.active,
    required this.onChanged,
  });

  final List<DcaScreenState> supportedStates;
  final _DcaUiMode active;
  final ValueChanged<_DcaUiMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <VitPresetChipItem<_DcaUiMode>>[
      const VitPresetChipItem(value: _DcaUiMode.live, label: 'Live'),
      if (supportedStates.contains(DcaScreenState.loading))
        const VitPresetChipItem(value: _DcaUiMode.loading, label: 'Loading'),
      if (supportedStates.contains(DcaScreenState.empty))
        const VitPresetChipItem(value: _DcaUiMode.empty, label: 'Empty'),
      if (supportedStates.contains(DcaScreenState.error))
        const VitPresetChipItem(value: _DcaUiMode.error, label: 'Error'),
      if (supportedStates.contains(DcaScreenState.offline))
        const VitPresetChipItem(value: _DcaUiMode.offline, label: 'Offline'),
    ];

    return VitPageSection(
      label: 'Screen states',
      children: [
        VitPresetChipRow<_DcaUiMode>(
          items: items,
          selectedValue: active,
          onTap: onChanged,
          accentColor: AppModuleAccents.trade,
        ),
      ],
    );
  }
}

class _DcaOverviewLoading extends StatelessWidget {
  const _DcaOverviewLoading();

  @override
  Widget build(BuildContext context) {
    return const VitSkeletonList(rows: 3);
  }
}
