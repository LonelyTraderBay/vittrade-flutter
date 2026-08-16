import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';

part '../../../widgets/staking/staking_auto_compound_overview.dart';
part '../../../widgets/staking/staking_auto_compound_settings.dart';
part '../../../widgets/staking/staking_auto_compound_positions.dart';
part '../../../widgets/staking/staking_auto_compound_simulation.dart';
part '../../../widgets/staking/staking_auto_compound_shared.dart';

class StakingAutoCompoundPage extends ConsumerStatefulWidget {
  const StakingAutoCompoundPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc363_info_banner');
  static const summaryKey = Key('sc363_summary_card');
  static const settingsKey = Key('sc363_settings_card');
  static const thresholdKey = Key('sc363_threshold_field');
  static const gasOptimizationKey = Key('sc363_gas_optimization');
  static const simulationKey = Key('sc363_simulation_card');
  static const principalKey = Key('sc363_principal_field');
  static const apyKey = Key('sc363_apy_field');
  static const monthsKey = Key('sc363_months_field');
  static const saveButtonKey = Key('sc363_save_button');
  static const successToastKey = Key('sc363_success_toast');
  static const footerKey = Key('sc363_footer_note');

  static Key frequencyKey(String id) => Key('sc363_frequency_$id');

  static Key positionKey(String id) => Key('sc363_position_$id');

  static Key toggleKey(String id) => Key('sc363_toggle_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingAutoCompoundPage> createState() =>
      _StakingAutoCompoundPageState();
}

class _StakingAutoCompoundPageState
    extends ConsumerState<StakingAutoCompoundPage> {
  late final TextEditingController _thresholdController;
  late final TextEditingController _principalController;
  late final TextEditingController _apyController;
  late final TextEditingController _monthsController;
  final Map<String, bool> _enabled = {};

  String _frequency = 'daily';
  bool _gasOptimization = true;

  @override
  void initState() {
    super.initState();
    _thresholdController = TextEditingController(text: '10');
    _principalController = TextEditingController(text: '1000');
    _apyController = TextEditingController(text: '7.5');
    _monthsController = TextEditingController(text: '12');
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    _principalController.dispose();
    _apyController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(stakingAutoCompoundSnapshotProvider);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Tự động Tái đầu tư staking — cài đặt lãi kép và mô phỏng lợi nhuận',
      semanticIdentifier: 'SC-363',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingAutoCompoundSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            final positions = [
              for (final position in snapshot.positions) _resolved(position),
            ];
            final threshold = _parseDouble(_thresholdController.text, 10);
            final simulation = _buildSimulation();
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: snapshot.infoTitle,
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
                          VitInfoCallout(
                            key: StakingAutoCompoundPage.infoKey,
                            message: snapshot.infoBody,
                            icon: Icons.autorenew_rounded,
                            accentColor: AppModuleAccents.earn,
                            padding: EarnSpacingTokens.earnPaddingX4,
                          ),
                          _SummaryCard(
                            positions: positions,
                            frequency: _frequency,
                            threshold: threshold,
                          ),
                          VitPageSection(
                            label: 'Cai dat Auto-Compound',
                            accentColor: AppModuleAccents.earn,
                            children: [
                              _SettingsCard(
                                key: StakingAutoCompoundPage.settingsKey,
                                snapshot: snapshot,
                                frequency: _frequency,
                                thresholdController: _thresholdController,
                                gasOptimization: _gasOptimization,
                                onFrequencyChanged: (frequency) {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _frequency = frequency);
                                },
                                onThresholdChanged: (_) => setState(() {}),
                                onGasOptimizationChanged: () {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() {
                                    _gasOptimization = !_gasOptimization;
                                  });
                                },
                              ),
                            ],
                          ),
                          VitPageSection(
                            label: 'Vi the Auto-Compound',
                            accentColor: AppModuleAccents.earn,
                            children: [
                              for (final position in positions)
                                _PositionCard(
                                  position: position,
                                  frequency: _frequency,
                                  onToggle: () => _toggle(position),
                                ),
                            ],
                          ),
                          VitPageSection(
                            label: 'Mo phong lai kep (uoc tinh)',
                            accentColor: AppModuleAccents.earn,
                            children: [
                              _SimulationCard(
                                controllerPrincipal: _principalController,
                                controllerApy: _apyController,
                                controllerMonths: _monthsController,
                                simulation: simulation,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                          VitCtaButton(
                            key: StakingAutoCompoundPage.saveButtonKey,
                            variant: VitCtaButtonVariant.primary,
                            leading: const Icon(Icons.settings_outlined),
                            onPressed: () {
                              unawaited(HapticFeedback.lightImpact());
                              unawaited(
                                showVitNoticeSheet(
                                  context: context,
                                  title: 'Đã lưu cài đặt',
                                  message: 'Đã lưu cài đặt auto-compound',
                                  variant: VitBannerVariant.success,
                                  ctaVariant: VitCtaButtonVariant.success,
                                  primaryKey:
                                      StakingAutoCompoundPage.successToastKey,
                                ),
                              );
                            },
                            child: const Text('Lưu cài đặt'),
                          ),
                          _FooterNote(snapshot: snapshot),
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

  StakingAutoCompoundPositionDraft _resolved(
    StakingAutoCompoundPositionDraft position,
  ) {
    return StakingAutoCompoundPositionDraft(
      id: position.id,
      product: position.product,
      asset: position.asset,
      amount: position.amount,
      autoCompound: _enabled[position.id] ?? position.autoCompound,
    );
  }

  void _toggle(StakingAutoCompoundPositionDraft position) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _enabled[position.id] = !position.autoCompound);
  }

  _CompoundSimulation _buildSimulation() {
    final principal = _parseDouble(_principalController.text, 1000);
    final apy = _parseDouble(_apyController.text, 7.5);
    final months = _parseInt(_monthsController.text, 12).clamp(1, 36);
    final monthlyRate = apy / 100 / 12;
    final points = <StakingAutoCompoundPointDraft>[];

    for (var month = 0; month <= months; month++) {
      points.add(
        StakingAutoCompoundPointDraft(
          month: month,
          withCompound: principal * math.pow(1 + monthlyRate, month),
          withoutCompound: principal * (1 + monthlyRate * month),
        ),
      );
    }

    final last = points.last;
    final difference = last.withCompound - last.withoutCompound;
    final percentageGain = last.withoutCompound == 0
        ? 0.0
        : difference / last.withoutCompound * 100;

    return _CompoundSimulation(
      points: points,
      withCompound: last.withCompound,
      withoutCompound: last.withoutCompound,
      difference: difference,
      percentageGain: percentageGain,
    );
  }
}
