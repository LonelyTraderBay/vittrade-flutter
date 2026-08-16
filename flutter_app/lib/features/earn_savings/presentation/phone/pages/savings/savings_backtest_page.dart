import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_compare.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_formatters.dart'
    as backtest_fmt;
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_hero.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_results.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_backtest_setup.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class SavingsBacktestPage extends ConsumerStatefulWidget {
  const SavingsBacktestPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc349_summary');
  static const amountFieldKey = Key('sc349_amount_field');
  static const allocationKey = Key('sc349_allocation');
  static const runKey = Key('sc349_run');
  static const resultsKey = Key('sc349_results');
  static const compareKey = Key('sc349_compare');
  static const applyKey = Key('sc349_apply');

  static Key tabKey(String id) => Key('sc349_tab_$id');
  static Key amountKey(int amount) => Key('sc349_amount_$amount');
  static Key periodKey(SavingsBacktestPeriod id) =>
      Key('sc349_period_${id.name}');
  static Key presetKey(SavingsBacktestPreset id) =>
      Key('sc349_preset_${id.name}');
  static Key slotKey(String id) => Key('sc349_slot_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsBacktestPage> createState() =>
      _SavingsBacktestPageState();
}

class _SavingsBacktestPageState extends ConsumerState<SavingsBacktestPage> {
  String? _tab;
  SavingsBacktestPreset? _preset;
  SavingsBacktestPeriod? _period;
  late final TextEditingController _amountController;
  int _amountUsd = 10000;
  bool _hasRun = false;

  @override
  void initState() {
    super.initState();
    // Bẫy 14 (GD4 playbook): repo giờ đã async — không seed từ initState
    // nữa; `_amountUsd` giữ literal default (khớp
    // MockSavingsBacktestRepository.getBacktest().defaultAmountUsd).
    _amountController = TextEditingController(text: '$_amountUsd');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsBacktestSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Mô phỏng đầu tư',
      semanticIdentifier: 'SC-349',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnSavings),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(savingsBacktestSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _tab ?? snapshot.defaultTab;
            final selectedPreset = _preset ?? snapshot.defaultPreset;
            final selectedPeriod = _period ?? snapshot.defaultPeriod;
            final preset = backtest_fmt.presetById(snapshot, selectedPreset);
            final period = backtest_fmt.periodById(snapshot, selectedPeriod);
            final weightedApy = backtest_fmt.weightedApy(preset.slots);
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.defaultGap,
                        children: [
                          BacktestHero(
                            snapshot: snapshot,
                            amountUsd: _amountUsd,
                            preset: preset,
                            period: period,
                            weightedApy: weightedApy,
                            hasRun: _hasRun,
                            result: snapshot.result,
                          ),
                          BacktestTabs(
                            tabs: snapshot.tabs,
                            active: activeTab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          if (activeTab == 'setup')
                            ..._buildSetup(
                              snapshot,
                              preset,
                              selectedPeriod,
                              weightedApy,
                            )
                          else if (activeTab == 'results')
                            if (_hasRun)
                              ResultsTab(
                                snapshot: snapshot,
                                amountUsd: _amountUsd,
                                period: period,
                                preset: preset,
                                onReset: _reset,
                                onApply: () =>
                                    context.go(snapshot.recommendationsRoute),
                              )
                            else
                              NoResults(
                                onSetup: () => setState(() => _tab = 'setup'),
                              )
                          else
                            CompareTab(
                              snapshot: snapshot,
                              amountUsd: _amountUsd,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSetup(
    SavingsBacktestSnapshot snapshot,
    SavingsBacktestPresetDraft preset,
    SavingsBacktestPeriod selectedPeriod,
    double weightedApy,
  ) {
    return [
      const SectionTitle(label: 'Vốn ban đầu (USD)'),
      AmountField(
        controller: _amountController,
        quickAmounts: snapshot.quickAmounts,
        amountUsd: _amountUsd,
        onAmountChanged: (amount) {
          unawaited(HapticFeedback.selectionClick());
          setState(() {
            _amountUsd = amount;
            _amountController.text = '$amount';
            _hasRun = false;
          });
        },
      ),
      const SectionTitle(label: 'Thời gian mô phỏng'),
      PeriodRow(
        periods: snapshot.periods,
        selected: selectedPeriod,
        onChanged: (period) {
          unawaited(HapticFeedback.selectionClick());
          setState(() {
            _period = period;
            _hasRun = false;
          });
        },
      ),
      const SectionTitle(label: 'Chiến lược phân bổ'),
      PresetList(
        presets: snapshot.presets,
        selected: preset.id,
        onChanged: (preset) {
          unawaited(HapticFeedback.selectionClick());
          setState(() {
            _preset = preset;
            _hasRun = false;
          });
        },
      ),
      const SectionTitle(label: 'Phân bổ hiện tại'),
      AllocationCard(
        preset: preset,
        weightedApy: weightedApy,
        amountUsd: _amountUsd,
      ),
      EarnWarningBanner(
        text: snapshot.disclaimer,
        lineHeight: EarnSpacingTokens.savingsBacktestWarningLineHeight,
      ),
      VitCtaButton(
        key: SavingsBacktestPage.runKey,
        onPressed: () {
          unawaited(HapticFeedback.mediumImpact());
          setState(() {
            _hasRun = true;
            _tab = 'results';
          });
        },
        leading: const Icon(Icons.play_arrow_rounded),
        child: const Text('Chạy mô phỏng'),
      ),
    ];
  }

  void _reset() {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _hasRun = false;
      _tab = 'setup';
    });
  }
}
