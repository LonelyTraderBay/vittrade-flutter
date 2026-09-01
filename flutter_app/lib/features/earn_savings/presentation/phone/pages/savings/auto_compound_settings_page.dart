import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_custody_risk_banner.dart';
import 'package:vit_trade_flutter/features/earn_core/presentation/widgets/earn_formatters.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../../widgets/phone/auto_compound_settings_positions.dart';
part '../../../widgets/phone/auto_compound_settings_calculator.dart';
part '../../../widgets/phone/auto_compound_settings_settings_sheet.dart';
part '../../../widgets/phone/auto_compound_settings_info_sheet.dart';
part '../../../widgets/phone/auto_compound_settings_shared.dart';

class AutoCompoundSettingsPage extends ConsumerStatefulWidget {
  const AutoCompoundSettingsPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc341_summary');
  static const infoButtonKey = Key('sc341_info_button');
  static const infoSheetKey = Key('sc341_info_sheet');
  static const saveButtonKey = Key('sc341_save_button');
  static const successToastKey = Key('sc341_success_toast');
  static const calculatorKey = Key('sc341_calculator');

  static Key positionKey(String id) => Key('sc341_position_$id');
  static Key toggleKey(String id) => Key('sc341_toggle_$id');
  static Key settingsButtonKey(String id) => Key('sc341_settings_$id');
  static Key frequencyKey(String id) => Key('sc341_frequency_$id');
  static Key thresholdKey(double value) => Key('sc341_threshold_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AutoCompoundSettingsPage> createState() =>
      _AutoCompoundSettingsPageState();
}

class _AutoCompoundSettingsPageState
    extends ConsumerState<AutoCompoundSettingsPage> {
  final Map<String, bool> _enabled = {};
  final Map<String, String> _frequencies = {};
  final Map<String, double> _thresholds = {};
  String? _editingId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(autoCompoundSettingsSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lãi kép tự động',
      semanticIdentifier: 'SC-341',
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
              onAction: () =>
                  ref.invalidate(autoCompoundSettingsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final positions = [
              for (final position in snapshot.positions) _resolved(position),
            ];
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final scrollTailReserve =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x3
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: kSavingsToolsHeaderSubtitle,
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
                actions: [
                  VitHeaderActionItem(
                    key: AutoCompoundSettingsPage.infoButtonKey,
                    type: VitHeaderActionType.help,
                    onPressed: () => _openInfo(snapshot),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: AppSpacing.zeroInsets.copyWith(
                        bottom: scrollTailReserve,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          _SummaryCard(positions: positions),
                          VitPageSection(
                            label: 'Vị thế tiết kiệm',
                            accentColor: AppColors.buy,
                            children: [
                              for (final position in positions)
                                _PositionCard(
                                  position: position,
                                  onToggle: () => _toggle(position),
                                  onSettings: () =>
                                      _openSettings(snapshot, position),
                                ),
                            ],
                          ),
                          const _CalculatorPreview(),
                          _NoteCard(text: snapshot.note),
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Auto-compound settings review',
                            message:
                                'Position toggles, compound frequency, threshold changes, yield impact, save confirmation, and success feedback are reviewed before automation is updated.',
                            contractId: 'SC-341',
                          ),
                          const SavingsToolsYieldFooter(),
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

  AutoCompoundPositionDraft _resolved(AutoCompoundPositionDraft position) {
    return AutoCompoundPositionDraft(
      id: position.id,
      product: position.product,
      asset: position.asset,
      amount: position.amount,
      earned: position.earned,
      apy: position.apy,
      type: position.type,
      autoCompound: _enabled[position.id] ?? position.autoCompound,
      compoundFrequency:
          _frequencies[position.id] ?? position.compoundFrequency,
      compoundThreshold: _thresholds[position.id] ?? position.compoundThreshold,
      lastCompounded: position.lastCompounded,
      totalCompounded: position.totalCompounded,
      compoundCount: position.compoundCount,
      estimatedBoost: position.estimatedBoost,
    );
  }

  void _toggle(AutoCompoundPositionDraft position) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _enabled[position.id] = !position.autoCompound);
  }

  Future<void> _openInfo(AutoCompoundSettingsSnapshot snapshot) async {
    unawaited(HapticFeedback.selectionClick());
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return _SheetFrame(child: _InfoSheet(snapshot: snapshot));
      },
    );
  }

  Future<void> _openSettings(
    AutoCompoundSettingsSnapshot snapshot,
    AutoCompoundPositionDraft position,
  ) async {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _editingId = position.id);
    var pendingSave = false;
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return _SheetFrame(
          child: _SettingsSheet(
            snapshot: snapshot,
            position: _resolved(position),
            onToggle: () {
              _toggle(_resolved(position));
              Navigator.of(context).pop();
              unawaited(_openSettings(snapshot, position));
            },
            onFrequency: (frequency) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _frequencies[position.id] = frequency);
              Navigator.of(context).pop();
              unawaited(_openSettings(snapshot, position));
            },
            onThreshold: (threshold) {
              unawaited(HapticFeedback.selectionClick());
              setState(() => _thresholds[position.id] = threshold);
              Navigator.of(context).pop();
              unawaited(_openSettings(snapshot, position));
            },
            onSave: () {
              unawaited(HapticFeedback.lightImpact());
              pendingSave = true;
              Navigator.of(context).pop();
              setState(() => _editingId = null);
            },
          ),
        );
      },
    );
    if (mounted && _editingId == position.id) {
      setState(() => _editingId = null);
    }
    if (pendingSave && mounted) {
      unawaited(
        showVitNoticeSheet(
          context: context,
          title: 'Đã lưu cài đặt',
          message: 'Compound sẽ áp dụng từ kỳ tiếp theo.',
          variant: VitBannerVariant.success,
          ctaVariant: VitCtaButtonVariant.success,
          primaryKey: AutoCompoundSettingsPage.successToastKey,
        ),
      );
    }
  }
}
