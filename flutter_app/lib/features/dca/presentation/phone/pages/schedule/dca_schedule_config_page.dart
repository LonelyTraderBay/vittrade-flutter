import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

part '../../../widgets/schedule/dca_schedule_strategy_time.dart';
part '../../../widgets/schedule/dca_schedule_limits_enable.dart';
part '../../../widgets/schedule/dca_schedule_common.dart';

const double _dcaScheduleStrategyChipWidth = 148;
const double _dcaScheduleTwoColumnMinWidth = 280;
const EdgeInsetsDirectional _dcaScheduleHeroPadding = EdgeInsetsDirectional.all(
  AppSpacing.x4,
);
const EdgeInsetsDirectional _dcaScheduleCardPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);

class DCAScheduleConfigPage extends ConsumerStatefulWidget {
  const DCAScheduleConfigPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc172_schedule_content');
  static const saveKey = Key('sc172_schedule_save');
  static const enabledKey = Key('sc172_schedule_enabled');
  static const maxDelayKey = Key('sc172_max_delay');
  static const maxAdvanceKey = Key('sc172_max_advance');
  static const volatilityKey = Key('sc172_volatility_threshold');
  static const gasKey = Key('sc172_gas_threshold');

  static Key strategyKey(DcaScheduleStrategy strategy) {
    return Key('sc172_strategy_${strategy.name}');
  }

  static Key timeKey(DcaScheduleTimePreference preference) {
    return Key('sc172_time_${preference.name}');
  }

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<DCAScheduleConfigPage> createState() =>
      _DCAScheduleConfigPageState();
}

class _DCAScheduleConfigPageState extends ConsumerState<DCAScheduleConfigPage> {
  late DcaScheduleStrategy _strategy;
  late DcaScheduleTimePreference _timePreference;
  late double _maxDelayHours;
  late double _maxAdvanceHours;
  late double _volatilityThreshold;
  late double _gasPriceThreshold;
  bool _enabled = true;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final dcaScheduleConfigAsync = ref.watch(dcaScheduleConfigProvider);

    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? SharedSpacingTokens.bottomNavVisualClearance
        : SharedSpacingTokens.bottomNavNativeClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'Cấu hình lịch mua DCA thông minh',
      semanticIdentifier: 'SC-172',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Smart Scheduling',
          subtitle: 'Đầu tư có kỷ luật · lịch mua tự động',
          showBack: true,
          onBack: _close,
        ),
        child: dcaScheduleConfigAsync.when(
          loading: () => const VitSkeletonList(),
          error: (error, stackTrace) => VitErrorState(
            title: 'Không tải được lịch mua DCA',
            message: 'Thử lại sau hoặc quay lại màn DCA.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(dcaScheduleConfigProvider),
          ),
          data: (snapshot) {
            _initialize(snapshot);
            return _buildBody(context, snapshot, scrollEndPadding);
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    DcaScheduleConfigSnapshot snapshot,
    double scrollEndPadding,
  ) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: VitInsetScrollView(
        key: DCAScheduleConfigPage.contentKey,
        physics: const ClampingScrollPhysics(),
        bottomInset: scrollEndPadding,
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.compact,
          density: VitDensity.compact,
          children: [
            const VitInfoCallout(
              title: 'Lịch trình thông minh',
              message:
                  'Tự động điều chỉnh thời điểm DCA theo volatility, gas hoặc khối lượng — giữ kỷ luật mua định kỳ.',
              icon: Icons.auto_awesome_outlined,
              accentColor: AppColors.primary,
              padding: _dcaScheduleHeroPadding,
              radius: VitCardRadius.large,
            ),
            _StrategySection(
              strategies: snapshot.strategies,
              active: _strategy,
              onChanged: _setStrategy,
            ),
            _TimePreferenceSection(
              preferences: snapshot.timePreferences,
              active: _timePreference,
              activeAccent: _strategyAccent,
              onChanged: _setTimePreference,
            ),
            _LimitsCard(
              maxDelayHours: _maxDelayHours,
              maxAdvanceHours: _maxAdvanceHours,
              onDelayChanged: (value) {
                setState(() => _maxDelayHours = value.roundToDouble());
              },
              onAdvanceChanged: (value) {
                setState(() => _maxAdvanceHours = value.roundToDouble());
              },
            ),
            if (_strategy == DcaScheduleStrategy.volatility ||
                _strategy == DcaScheduleStrategy.hybrid)
              _ThresholdCard(
                key: DCAScheduleConfigPage.volatilityKey,
                title: 'Volatility Settings',
                icon: Icons.trending_down,
                accent: AppColors.accent,
                label: 'Ngưỡng volatility',
                valueLabel: '${_volatilityThreshold.toStringAsFixed(1)}%',
                min: 0.5,
                max: 10,
                divisions: 19,
                value: _volatilityThreshold,
                helper:
                    'Ưu tiên thời điểm volatility < ${_volatilityThreshold.toStringAsFixed(1)}%',
                onChanged: (value) {
                  setState(() => _volatilityThreshold = value);
                },
              ),
            if (_strategy == DcaScheduleStrategy.gasOptimized ||
                _strategy == DcaScheduleStrategy.hybrid)
              _ThresholdCard(
                key: DCAScheduleConfigPage.gasKey,
                title: 'Gas Settings',
                icon: Icons.bolt_outlined,
                accent: AppColors.warn,
                label: 'Ngưỡng gas price',
                valueLabel: '${_gasPriceThreshold.round()} gwei',
                min: 5,
                max: 100,
                divisions: 19,
                value: _gasPriceThreshold,
                helper:
                    'Ưu tiên thời điểm gas < ${_gasPriceThreshold.round()} gwei',
                onChanged: (value) {
                  setState(() => _gasPriceThreshold = value.roundToDouble());
                },
              ),
            _EnableCard(
              enabled: _enabled,
              onChanged: (value) {
                unawaited(HapticFeedback.selectionClick());
                setState(() => _enabled = value);
              },
            ),
            if (_strategy == DcaScheduleStrategy.fixed)
              const _FixedWarningCard(),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại lịch mua tự động',
              message:
                  'Thay đổi chiến lược và khung giờ ảnh hưởng trực tiếp đến thời điểm thực thi DCA.',
              contractId: 'SC-172',
            ),
            VitCtaButton(
              key: DCAScheduleConfigPage.saveKey,
              onPressed: _save,
              leading: const Icon(Icons.save_outlined),
              child: const Text('Lưu cấu hình'),
            ),
          ],
        ),
      ),
    );
  }

  void _initialize(DcaScheduleConfigSnapshot snapshot) {
    if (_initialized) return;
    _strategy = snapshot.strategy;
    _timePreference = snapshot.timePreference;
    _maxDelayHours = snapshot.maxDelayHours.toDouble();
    _maxAdvanceHours = snapshot.maxAdvanceHours.toDouble();
    _volatilityThreshold = snapshot.volatilityThreshold;
    _gasPriceThreshold = snapshot.gasPriceThreshold.toDouble();
    _enabled = snapshot.enabled;
    _initialized = true;
  }

  Color get _strategyAccent => _accentForStrategy(_strategy);

  void _setStrategy(DcaScheduleStrategy strategy) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _strategy = strategy);
  }

  void _setTimePreference(DcaScheduleTimePreference preference) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _timePreference = preference);
  }

  void _save() {
    unawaited(HapticFeedback.mediumImpact());
    context.go(AppRoutePaths.dcaScheduleAnalytics);
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.dca);
  }
}
