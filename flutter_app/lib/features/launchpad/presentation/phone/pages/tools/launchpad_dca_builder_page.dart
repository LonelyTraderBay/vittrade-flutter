import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_common.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_create_form.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_history.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_strategies.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_summary.dart';

class LaunchpadDcaBuilderPage extends ConsumerStatefulWidget {
  const LaunchpadDcaBuilderPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc316_launchpad_dca_content');
  static const tabsKey = Key('sc316_launchpad_dca_tabs');
  static const summaryKey = Key('sc316_launchpad_dca_summary');
  static const strategiesKey = Key('sc316_launchpad_dca_strategies');
  static const historyKey = Key('sc316_launchpad_dca_history');
  static const chartKey = Key('sc316_launchpad_dca_chart');
  static const createKey = Key('sc316_launchpad_dca_create');
  static const headerCreateKey = Key('sc316_launchpad_dca_header_create');
  static const tokenFieldKey = Key('sc316_launchpad_dca_token_field');
  static const amountFieldKey = Key('sc316_launchpad_dca_amount_field');
  static const budgetFieldKey = Key('sc316_launchpad_dca_budget_field');
  static const startDateFieldKey = Key('sc316_launchpad_dca_start_field');
  static const previewKey = Key('sc316_launchpad_dca_preview');
  static const reviewStateKey = Key('sc316_launchpad_dca_review_state');
  static const ctaKey = Key('sc316_launchpad_dca_cta');

  static Key strategyKey(String id) => Key('sc316_launchpad_dca_strategy_$id');
  static Key frequencyKey(LaunchpadDcaFrequency frequency) =>
      Key('sc316_launchpad_dca_frequency_${frequency.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadDcaBuilderPage> createState() =>
      _LaunchpadDcaBuilderPageState();
}

class _LaunchpadDcaBuilderPageState
    extends ConsumerState<LaunchpadDcaBuilderPage> {
  late final TextEditingController _tokenController;
  late final TextEditingController _amountController;
  late final TextEditingController _budgetController;
  late final TextEditingController _startDateController;
  var _activeTab = LaunchpadDcaBuilderTab.strategies;
  var _frequency = LaunchpadDcaFrequency.weekly;

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: 'ARB');
    _amountController = TextEditingController();
    _budgetController = TextEditingController();
    _startDateController = TextEditingController();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _amountController.dispose();
    _budgetController.dispose();
    _startDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dcaBuilderAsync = ref.watch(launchpadDcaBuilderSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navInset = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final showCta =
        _activeTab == LaunchpadDcaBuilderTab.create &&
        _amountController.text.trim().isNotEmpty &&
        _budgetController.text.trim().isNotEmpty &&
        _startDateController.text.trim().isNotEmpty;
    final ctaInset = showCta ? 118.0 : 0.0;
    final scrollTailReserve = navInset + safeBottom + AppSpacing.x3 + ctaInset;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Xây dựng chiến lược đầu tư định kỳ DCA',
      semanticIdentifier: 'SC-316',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            VitAutoHideHeaderScaffold(
              bottomInset: scrollTailReserve,
              semanticLabel: 'Xây dựng chiến lược đầu tư định kỳ DCA',
              semanticIdentifier: 'SC-316',
              header: VitHeader(
                title: 'DCA Builder',
                subtitle: 'Chiến lược DCA · Không cam kết lợi nhuận',
                showBack: true,
                onBack: () => context.go(AppRoutePaths.launchpad),
                actions: [
                  VitHeaderActionItem(
                    key: LaunchpadDcaBuilderPage.headerCreateKey,
                    type: VitHeaderActionType.add,
                    onPressed: () => setState(() {
                      _activeTab = LaunchpadDcaBuilderTab.create;
                    }),
                  ),
                ],
              ),
              child: Column(
                children: [
                  LaunchpadDcaTabs(
                    tabsKey: LaunchpadDcaBuilderPage.tabsKey,
                    activeTab: _activeTab,
                    onChanged: (tab) => setState(() => _activeTab = tab),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      key: LaunchpadDcaBuilderPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          ...dcaBuilderAsync.when(
                            loading: () => const [VitSkeletonList()],
                            error: (error, stackTrace) => [
                              VitErrorState(
                                title: 'Không tải được DCA builder',
                                message:
                                    'Vui lòng kiểm tra kết nối và thử lại.',
                                actionLabel: 'Thử lại',
                                onAction: () => ref.invalidate(
                                  launchpadDcaBuilderSnapshotProvider,
                                ),
                              ),
                            ],
                            data: (snapshot) => [
                              if (_activeTab ==
                                  LaunchpadDcaBuilderTab.strategies) ...[
                                LaunchpadDcaSummaryCard(
                                  key: LaunchpadDcaBuilderPage.summaryKey,
                                  snapshot: snapshot,
                                ),
                                LaunchpadDcaStrategiesSection(
                                  sectionKey:
                                      LaunchpadDcaBuilderPage.strategiesKey,
                                  strategyKey:
                                      LaunchpadDcaBuilderPage.strategyKey,
                                  strategies: snapshot.strategies,
                                ),
                              ] else if (_activeTab ==
                                  LaunchpadDcaBuilderTab.history) ...[
                                LaunchpadDcaHistorySection(
                                  sectionKey:
                                      LaunchpadDcaBuilderPage.historyKey,
                                  chartKey: LaunchpadDcaBuilderPage.chartKey,
                                  executions: snapshot.executions,
                                ),
                              ] else ...[
                                LaunchpadDcaCreateSection(
                                  sectionKey: LaunchpadDcaBuilderPage.createKey,
                                  tokenFieldKey:
                                      LaunchpadDcaBuilderPage.tokenFieldKey,
                                  amountFieldKey:
                                      LaunchpadDcaBuilderPage.amountFieldKey,
                                  budgetFieldKey:
                                      LaunchpadDcaBuilderPage.budgetFieldKey,
                                  startDateFieldKey:
                                      LaunchpadDcaBuilderPage.startDateFieldKey,
                                  previewKey:
                                      LaunchpadDcaBuilderPage.previewKey,
                                  reviewStateKey:
                                      LaunchpadDcaBuilderPage.reviewStateKey,
                                  frequencyKey:
                                      LaunchpadDcaBuilderPage.frequencyKey,
                                  tokenController: _tokenController,
                                  amountController: _amountController,
                                  budgetController: _budgetController,
                                  startDateController: _startDateController,
                                  frequency: _frequency,
                                  onFrequencyChanged: (frequency) =>
                                      setState(() => _frequency = frequency),
                                  onInputChanged: () => setState(() {}),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showCta)
              Positioned(
                // notice-ack: allow-sticky-footer-form-cta — in-progress
                // create-tab CTA footer, not a success toast overlay.
                left: 0,
                right: 0,
                bottom: navInset + safeBottom,
                child: VitStickyFooter(
                  backgroundColor: AppColors.surface.withValues(alpha: .94),
                  child: VitCtaButton(
                    key: LaunchpadDcaBuilderPage.ctaKey,
                    onPressed: () => unawaited(_submitStrategy()),
                    leading: const Icon(Icons.add_rounded),
                    child: const Text('Tao DCA Strategy'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitStrategy() async {
    await showVitNoticeSheet(
      context: context,
      title: 'Đã tạo chiến lược DCA',
      message:
          '${launchpadDcaFrequencyLabel(_frequency)} '
          '${_amountController.text.trim()} USD vào '
          '${_tokenController.text.trim()}.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}
