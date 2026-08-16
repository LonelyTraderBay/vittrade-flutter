import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_analysis.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_builder_config.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_formatters.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_hero.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_rung_manager.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_ladder_timeline.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

const _visualNavClearance = 90.0;
const _nativeNavClearance = 72.0;
const _visualScrollExtra = 28.0;
const _nativeScrollExtra = 20.0;
const _disclaimerLineHeight = 1.22;

class SavingsLadderPage extends ConsumerStatefulWidget {
  const SavingsLadderPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc351_summary');
  static const amountKey = Key('sc351_amount');
  static const templatesKey = Key('sc351_templates');
  static const rungsKey = Key('sc351_rungs');
  static const timelineKey = Key('sc351_timeline');
  static const analysisKey = Key('sc351_analysis');
  static const addRungKey = Key('sc351_add_rung');
  static const confirmKey = Key('sc351_confirm');

  static Key presetKey(SavingsLadderPreset preset) =>
      Key('sc351_preset_${preset.name}');
  static Key amountChipKey(int amount) => Key('sc351_amount_$amount');
  static Key rungKey(String id) => Key('sc351_rung_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsLadderPage> createState() => _SavingsLadderPageState();
}

class _SavingsLadderPageState extends ConsumerState<SavingsLadderPage> {
  String? _tab;
  SavingsLadderPreset? _preset;
  int? _amountUsd;
  List<SavingsLadderRungDraft>? _customRungs;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(savingsLadderSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thang đáo hạn tiết kiệm',
      semanticIdentifier: 'SC-351',
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
              onAction: () => ref.invalidate(savingsLadderSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final activeTab = _tab ?? snapshot.defaultTab;
            final selectedPreset = _preset ?? snapshot.defaultPreset;
            final amountUsd = _amountUsd ?? snapshot.defaultAmountUsd;
            final template = savingsLadderTemplateById(
              snapshot,
              selectedPreset,
            );
            final rungs = selectedPreset == SavingsLadderPreset.custom
                ? (_customRungs ?? const <SavingsLadderRungDraft>[])
                : savingsLadderGenerateRungs(template, amountUsd);
            final totalAllocated = savingsLadderTotalAllocated(rungs);
            final weightedApy = savingsLadderWeightedApy(rungs);
            final annualInterest = savingsLadderAnnualInterest(rungs);
            final liquidityScore = savingsLadderLiquidityScore(rungs);
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final scrollEndPadding =
                (mode.usesVisualQaFrame
                    ? _visualNavClearance + _visualScrollExtra
                    : _nativeNavClearance + _nativeScrollExtra) +
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
                      padding: EdgeInsetsDirectional.only(
                        bottom: scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        density: VitDensity.compact,
                        children: [
                          LadderHero(
                            snapshot: snapshot,
                            amountUsd: amountUsd,
                            annualInterest: annualInterest,
                            rungCount: rungs.length,
                            weightedApy: weightedApy,
                            liquidityScore: liquidityScore,
                          ),
                          LadderTabs(
                            tabs: snapshot.tabs,
                            active: activeTab,
                            onChanged: (tab) {
                              unawaited(HapticFeedback.selectionClick());
                              setState(() => _tab = tab);
                            },
                          ),
                          if (activeTab == 'builder')
                            ..._buildBuilder(
                              snapshot,
                              amountUsd,
                              selectedPreset,
                              rungs,
                              totalAllocated,
                            )
                          else if (activeTab == 'timeline')
                            TimelineTab(
                              snapshot: snapshot,
                              rungs: rungs,
                              onEmptyCta: _goToBuilderTab,
                            )
                          else
                            AnalysisTab(
                              snapshot: snapshot,
                              rungs: rungs,
                              amountUsd: amountUsd,
                              weightedApy: weightedApy,
                              annualInterest: annualInterest,
                              liquidityScore: liquidityScore,
                              onEmptyCta: _goToBuilderTab,
                            ),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            density: VitDensity.compact,
                            title: 'Savings ladder confirmation review',
                            message:
                                'Capital allocation, rung schedule, APY estimate, liquidity score, auto-renew flags, confirmation sheet, success state, and risk disclaimer are reviewed before a ladder is created.',
                            contractId: 'SC-351',
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

  List<Widget> _buildBuilder(
    SavingsLadderSnapshot snapshot,
    int amountUsd,
    SavingsLadderPreset selectedPreset,
    List<SavingsLadderRungDraft> rungs,
    double totalAllocated,
  ) {
    final unallocated = amountUsd - totalAllocated;
    return [
      const SectionTitle(label: 'Tổng vốn (USD)'),
      AmountSelector(
        amountUsd: amountUsd,
        quickAmounts: snapshot.quickAmounts,
        onChanged: (value) {
          unawaited(HapticFeedback.selectionClick());
          setState(() => _amountUsd = value);
        },
      ),
      const SectionTitle(label: 'Chiến lược ladder'),
      TemplateList(
        templates: snapshot.templates,
        selected: selectedPreset,
        amountUsd: amountUsd,
        onChanged: (preset) {
          unawaited(HapticFeedback.selectionClick());
          setState(() {
            _preset = preset;
            _customRungs = preset == SavingsLadderPreset.custom
                ? savingsLadderGenerateRungs(
                    savingsLadderTemplateById(snapshot, selectedPreset),
                    amountUsd,
                  )
                : null;
          });
        },
      ),
      SectionTitle(label: 'Các bậc ladder (${rungs.length})'),
      RungList(
        rungs: rungs,
        onToggleRenew: _toggleAutoRenew,
        onRemove: _removeRung,
      ),
      AddRungButton(
        onTap: () => _addProduct(snapshot.availableProducts.first, rungs),
      ),
      AllocationStatus(
        amountUsd: amountUsd,
        totalAllocated: totalAllocated,
        unallocated: unallocated,
      ),
      if (rungs.isNotEmpty)
        VitCtaButton(
          key: SavingsLadderPage.confirmKey,
          onPressed: () => _showConfirmSheet(snapshot, rungs, amountUsd),
          leading: const Icon(Icons.layers_rounded),
          child: Text('Xác nhận Ladder · ${rungs.length} bậc'),
        ),
      EarnDisclaimerBanner(
        text: snapshot.disclaimer,
        lineHeight: _disclaimerLineHeight,
      ),
    ];
  }

  void _goToBuilderTab() {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _tab = 'builder');
  }

  void _removeRung(String id) {
    // Bẫy 15 (GD4 playbook): repo trong event handler — đọc lười qua
    // `.value` (đã có sẵn vì chỉ tap được nút này sau khi nhánh data:
    // render), không cần provider trung gian mới.
    final snapshot = ref.read(savingsLadderSnapshotProvider).value;
    if (snapshot == null) return;
    final amountUsd = _amountUsd ?? snapshot.defaultAmountUsd;
    final preset = _preset ?? snapshot.defaultPreset;
    final current = preset == SavingsLadderPreset.custom
        ? (_customRungs ?? const <SavingsLadderRungDraft>[])
        : savingsLadderGenerateRungs(
            savingsLadderTemplateById(snapshot, preset),
            amountUsd,
          );
    unawaited(HapticFeedback.mediumImpact());
    setState(() {
      _preset = SavingsLadderPreset.custom;
      _customRungs = current.where((rung) => rung.id != id).toList();
    });
  }

  void _toggleAutoRenew(String id) {
    // Bẫy 15: xem _removeRung ở trên.
    final snapshot = ref.read(savingsLadderSnapshotProvider).value;
    if (snapshot == null) return;
    final amountUsd = _amountUsd ?? snapshot.defaultAmountUsd;
    final preset = _preset ?? snapshot.defaultPreset;
    final current = preset == SavingsLadderPreset.custom
        ? (_customRungs ?? const <SavingsLadderRungDraft>[])
        : savingsLadderGenerateRungs(
            savingsLadderTemplateById(snapshot, preset),
            amountUsd,
          );
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _preset = SavingsLadderPreset.custom;
      _customRungs = [
        for (final rung in current)
          if (rung.id == id)
            SavingsLadderRungDraft(
              id: rung.id,
              product: rung.product,
              asset: rung.asset,
              colorKey: rung.colorKey,
              lockDays: rung.lockDays,
              apyPct: rung.apyPct,
              amountUsd: rung.amountUsd,
              startDate: rung.startDate,
              maturityDate: rung.maturityDate,
              autoRenew: !rung.autoRenew,
            )
          else
            rung,
      ];
    });
  }

  void _addProduct(
    SavingsLadderProductDraft product,
    List<SavingsLadderRungDraft> current,
  ) {
    final amountUsd = _amountUsd ?? 10000;
    final allocated = savingsLadderTotalAllocated(current);
    final amount = math.max(100, amountUsd - allocated).toDouble();
    unawaited(HapticFeedback.mediumImpact());
    setState(() {
      _preset = SavingsLadderPreset.custom;
      _customRungs = [
        ...current,
        SavingsLadderRungDraft(
          id: 'custom-${current.length + 1}',
          product: product.product,
          asset: product.asset,
          colorKey: product.colorKey,
          lockDays: product.lockDays,
          apyPct: product.apyPct,
          amountUsd: amount,
          startDate: savingsLadderToday,
          maturityDate: savingsLadderAddDays(
            savingsLadderToday,
            product.lockDays,
          ),
          autoRenew: true,
        ),
      ];
    });
  }

  void _showConfirmSheet(
    SavingsLadderSnapshot snapshot,
    List<SavingsLadderRungDraft> rungs,
    int amountUsd,
  ) {
    unawaited(HapticFeedback.mediumImpact());
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.transparent,
        builder: (context) {
          return SafeArea(
            child: Material(
              color: AppColors.surface,
              borderRadius: AppRadii.sheetTopLargeRadius,
              child: Padding(
                padding: EarnSpacingTokens.earnPaddingX5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const RoundIcon(
                          icon: Icons.layers_rounded,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Expanded(
                          child: Text(
                            'Xác nhận ladder',
                            style: savingsLadderCaptionBoldStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    DetailRow(
                      label: 'Tổng vốn',
                      value: savingsLadderMoney(amountUsd),
                    ),
                    DetailRow(label: 'Số bậc', value: '${rungs.length}'),
                    DetailRow(
                      label: 'APY bình quân',
                      value:
                          '${savingsLadderWeightedApy(rungs).toStringAsFixed(1)}%',
                      color: AppColors.buy,
                    ),
                    DetailRow(
                      label: 'Lãi dự kiến/năm',
                      value:
                          '+${savingsLadderMoney(savingsLadderAnnualInterest(rungs))}',
                      color: AppColors.buy,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    EarnDisclaimerBanner(
                      text: snapshot.disclaimer,
                      lineHeight: _disclaimerLineHeight,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    VitCtaButton(
                      onPressed: () {
                        unawaited(HapticFeedback.lightImpact());
                        Navigator.of(context).pop();
                      },
                      child: const Text('Xác nhận tạo ladder'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
