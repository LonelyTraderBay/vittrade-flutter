import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/controllers/trade_copy_controller_models.dart';

part '../../../widgets/phone/copy_settings_modes.dart';
part '../../../widgets/phone/copy_settings_controls.dart';
part '../../../widgets/phone/copy_settings_contacts_privacy.dart';

const _settingsPrimary = AppColors.primary;
const _sliderInactive = AppColors.tierPlatinum;

class CopySettingsPage extends ConsumerStatefulWidget {
  const CopySettingsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc067_copy_settings_scroll_content');
  static const circuitBreakerKey = Key('sc067_circuit_breaker_toggle');
  static const saveKey = Key('sc067_save_settings');
  static const emailChannelKey = Key('sc067_email_channel');
  static const pushChannelKey = Key('sc067_push_channel');

  static Key modeKey(TradeCopySettingsMode mode) =>
      Key('sc067_mode_${mode.name}');
  static Key notificationKey(String id) => Key('sc067_notification_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopySettingsPage> createState() => _CopySettingsPageState();
}

class _CopySettingsPageState extends ConsumerState<CopySettingsPage> {
  TradeCopySettings? _settings;
  bool _saved = false;
  Timer? _savedTimer;

  @override
  void dispose() {
    _savedTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(tradeCopySettingsControllerProvider);

    return controllerAsync.when(
      loading: () => _scaffold(context, const [VitSkeletonList()]),
      error: (error, stackTrace) => _scaffold(context, [
        VitErrorState(
          title: 'Không tải được cài đặt copy trading',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(tradeCopySettingsControllerProvider),
        ),
      ]),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        final settings = _settings ?? snapshot.settings;
        _settings ??= snapshot.settings;
        return _scaffold(context, _body(settings, controller));
      },
    );
  }

  Widget _scaffold(BuildContext context, List<Widget> children) {
    return VitTradeDetailScaffold(
      title: 'Cài đặt Copy Trading',
      semanticLabel: 'Cài đặt Copy Trading',
      semanticIdentifier: 'SC-067',
      contentKey: CopySettingsPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: children,
    );
  }

  List<Widget> _body(
    TradeCopySettings settings,
    TradeCopySettingsController controller,
  ) {
    return [
      VitTradeSection(
        title: 'Đánh giá rủi ro',
        child: VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          density: VitDensity.tool,
          title: 'Review copy trading defaults',
          message:
              'Confirm stop-loss, take-profit, allocation limits, circuit breaker, and emergency contact before saving copy defaults.',
          contractId: settings.enableCircuitBreaker
              ? 'Circuit breaker: on'
              : 'Circuit breaker: off',
        ),
      ),
      _SettingsSection(
        label: 'Cài đặt mặc định',
        accent: _settingsPrimary,
        showAccent: false,
        children: [
          _ModeCard(
            selected: settings.defaultCopyMode,
            onChanged: (value) =>
                _update(settings.copyWith(defaultCopyMode: value)),
          ),
          if (settings.defaultCopyMode == TradeCopySettingsMode.fixed)
            _SliderCard(
              title: 'Copy Ratio mặc định',
              valueLabel: '${settings.defaultCopyRatio.toStringAsFixed(0)}%',
              caption:
                  'Copy ${settings.defaultCopyRatio.toStringAsFixed(0)}% position size của provider',
              value: settings.defaultCopyRatio,
              min: 10,
              max: 100,
              divisions: 18,
              color: _settingsPrimary,
              onChanged: (value) =>
                  _update(settings.copyWith(defaultCopyRatio: value)),
            ),
          _SliderCard(
            title: 'Stop-Loss mặc định',
            valueLabel: '-${settings.defaultStopLoss.toStringAsFixed(0)}%',
            value: settings.defaultStopLoss,
            min: 5,
            max: 50,
            divisions: 9,
            color: AppColors.sell,
            onChanged: (value) =>
                _update(settings.copyWith(defaultStopLoss: value)),
          ),
          _SliderCard(
            title: 'Take-Profit mặc định',
            valueLabel: '+${settings.defaultTakeProfit.toStringAsFixed(0)}%',
            value: settings.defaultTakeProfit,
            min: 10,
            max: 100,
            divisions: 18,
            color: AppColors.buy,
            onChanged: (value) =>
                _update(settings.copyWith(defaultTakeProfit: value)),
          ),
        ],
      ),
      _SettingsSection(
        label: 'Giới hạn rủi ro',
        accent: AppColors.sell,
        children: [
          _SliderCard(
            title: 'Max allocation per provider',
            subtitle: 'Không copy quá X% tổng portfolio vào 1 provider',
            valueLabel:
                '${settings.maxPortfolioAllocation.toStringAsFixed(0)}%',
            value: settings.maxPortfolioAllocation,
            min: 5,
            max: 50,
            divisions: 9,
            color: _settingsPrimary,
            onChanged: (value) =>
                _update(settings.copyWith(maxPortfolioAllocation: value)),
          ),
          _SliderCard(
            title: 'Max số copy đồng thời',
            subtitle: 'Giới hạn số provider bạn có thể copy cùng lúc',
            valueLabel: '${settings.maxCopiesActive}',
            value: settings.maxCopiesActive.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            color: _settingsPrimary,
            onChanged: (value) =>
                _update(settings.copyWith(maxCopiesActive: value.round())),
          ),
          _CircuitBreakerCard(
            enabled: settings.enableCircuitBreaker,
            threshold: settings.circuitBreakerThreshold,
            onToggle: () => _update(
              settings.copyWith(
                enableCircuitBreaker: !settings.enableCircuitBreaker,
              ),
            ),
            onThresholdChanged: (value) =>
                _update(settings.copyWith(circuitBreakerThreshold: value)),
          ),
        ],
      ),
      _SettingsSection(
        label: 'Thông báo',
        accent: _settingsPrimary,
        children: [
          _NotificationRow(
            id: 'newTrades',
            label: 'Trades mới',
            description: 'Thông báo mỗi khi provider mở/đóng lệnh',
            value: settings.notifyNewTrades,
            onChanged: (value) =>
                _update(settings.copyWith(notifyNewTrades: value)),
          ),
          _NotificationRow(
            id: 'pnlChanges',
            label: 'Thay đổi P/L',
            description: 'Cảnh báo khi P/L thay đổi >5%',
            value: settings.notifyPnlChanges,
            onChanged: (value) =>
                _update(settings.copyWith(notifyPnlChanges: value)),
          ),
          _NotificationRow(
            id: 'riskAlerts',
            label: 'Cảnh báo rủi ro',
            description: 'Provider gần stop-loss hoặc có drawdown lớn',
            value: settings.notifyRiskAlerts,
            onChanged: (value) =>
                _update(settings.copyWith(notifyRiskAlerts: value)),
          ),
          _NotificationRow(
            id: 'providerUpdates',
            label: 'Cập nhật provider',
            description: 'Thông báo khi provider thay đổi chiến lược',
            value: settings.notifyProviderUpdates,
            onChanged: (value) =>
                _update(settings.copyWith(notifyProviderUpdates: value)),
          ),
          const _SectionDivider(),
          Row(
            children: [
              Expanded(
                child: _ChannelButton(
                  key: CopySettingsPage.emailChannelKey,
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  active: settings.emailNotifications,
                  onTap: () => _update(
                    settings.copyWith(
                      emailNotifications: !settings.emailNotifications,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _ChannelButton(
                  key: CopySettingsPage.pushChannelKey,
                  icon: Icons.notifications_none_rounded,
                  label: 'Push',
                  active: settings.pushNotifications,
                  onTap: () => _update(
                    settings.copyWith(
                      pushNotifications: !settings.pushNotifications,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      _SettingsSection(
        label: 'Liên hệ khẩn cấp',
        accent: AppColors.warn,
        children: [
          _EmergencyContactCard(
            email: settings.emergencyContact,
            phone: settings.emergencyPhone,
            onEmailChanged: (value) =>
                _update(settings.copyWith(emergencyContact: value)),
            onPhoneChanged: (value) =>
                _update(settings.copyWith(emergencyPhone: value)),
          ),
        ],
      ),
      _SettingsSection(
        label: 'Quyền riêng tư',
        accent: AppColors.text3,
        children: [
          _PrivacyCard(
            active: settings.showPortfolioPublic,
            onChanged: (value) =>
                _update(settings.copyWith(showPortfolioPublic: value)),
          ),
        ],
      ),
      VitTradeSection(
        title: 'Lưu cài đặt',
        child: _SaveButton(
          saved: _saved,
          onTap: () async {
            final result = await controller.save(settings);
            if (!mounted) return;
            _update(result.settings);
            setState(() => _saved = result.status == 'saved');
            _savedTimer?.cancel();
            _savedTimer = Timer(const Duration(seconds: 2), () {
              if (mounted) setState(() => _saved = false);
            });
          },
        ),
      ),
    ];
  }

  void _update(TradeCopySettings settings) {
    setState(() {
      _settings = settings;
      _saved = false;
    });
  }
}
