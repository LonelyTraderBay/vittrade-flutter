import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_body_review_widgets.dart';

part '../../../widgets/phone/trade_settings_page_sections.dart';
part '../../../widgets/phone/trade_settings_page_common.dart';

const _tradePrimary = AppColors.primary;
const _settingsSpace = AppSpacing.x2;
const _settingsTinySpace = AppSpacing.x1;
const _settingsLineTight = 1.2;
const _settingsLineBody = 1.24;
const _settingsChipHeight = TradeSpacingTokens.tradeSettingsChipHeight;
const _settingsChipHeightSm = TradeSpacingTokens.tradeSettingsChipHeightSm;
const _settingsToggleWidth = TradeSpacingTokens.tradeSettingsToggleWidth;
const _settingsToggleHeight = TradeSpacingTokens.tradeSettingsToggleHeight;
const _settingsToggleKnob = TradeSpacingTokens.tradeSettingsToggleKnob;
const _settingsToggleKnobMargin = ProfileSpacingTokens.settingsSwitchKnobMargin;
const _settingsButtonHeight = TradeSpacingTokens.tradeSettingsButtonHeight;

class TradeSettingsPage extends ConsumerStatefulWidget {
  const TradeSettingsPage({super.key, this.shellRenderMode});

  static const resetKey = Key('sc052_reset');
  static const confirmOrdersKey = Key('sc052_confirm_orders');
  static const skipConfirmSmallKey = Key('sc052_skip_confirm_small');
  static const soundOnFillKey = Key('sc052_sound_on_fill');
  static const hapticOnFillKey = Key('sc052_haptic_on_fill');
  static const showTpslKey = Key('sc052_show_tpsl');
  static const showOrderBookKey = Key('sc052_show_order_book');
  static const showRecentTradesKey = Key('sc052_show_recent_trades');
  static const defaultPctButtonsKey = Key('sc052_default_pct_buttons');

  static Key orderTypeKey(String id) => Key('sc052_order_type_$id');
  static Key slippageKey(double value) => Key('sc052_slippage_$value');
  static Key timeframeKey(String value) => Key('sc052_timeframe_$value');
  static Key decimalsKey(String value) => Key('sc052_decimals_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradeSettingsPage> createState() => _TradeSettingsPageState();
}

class _TradeSettingsPageState extends ConsumerState<TradeSettingsPage> {
  // GD4 Cụm F3: `getTradeSettings`/`patchTradeSettings` giờ Future<T> —
  // `initState()` không thể await, nên seed lười trong nhánh `data:` của
  // `.when()` (chỉ seed lần đầu, `??=`); `_settings` vẫn là bản nháp cục bộ
  // (mutation local qua `_updateSettings`, không re-seed lại từ snapshot).
  TradeSettings? _settings;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(tradeSettingsSnapshotProvider);
    return VitTradeHubScaffold(
      title: 'Cài đặt giao dịch',
      semanticLabel: 'Cài đặt giao dịch',
      semanticIdentifier: 'SC-052',
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      showProductTabs: true,
      navigationBuilder: buildTradeProductNavigation,
      children: settingsAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được cài đặt giao dịch',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeSettingsSnapshotProvider),
          ),
        ],
        data: (snapshot) {
          _settings ??= snapshot.settings;
          return _buildSettingsChildren(_settings!);
        },
      ),
    );
  }

  List<Widget> _buildSettingsChildren(TradeSettings settings) {
    return [
      const VitTradeSection(
        title: 'An toàn giao dịch',
        child: VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.tight,
          padding: AppSpacing.cardPaddingCompact,
          child: VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Trade settings safety review',
            message:
                'Confirm order preview, small-order confirmation limits, slippage, chart defaults, and next steps before using these settings for live trading.',
            contractId: 'SC-052 settings review',
            density: VitDensity.tool,
          ),
        ),
      ),
      VitTradeSection(
        title: 'Mặc định lệnh',
        child: _OrderDefaultsCard(
          settings: settings,
          onChanged: _updateSettings,
        ),
      ),
      VitTradeSection(
        title: 'Xác nhận lệnh',
        child: _ConfirmationCard(
          settings: settings,
          onChanged: _updateSettings,
        ),
      ),
      VitTradeSection(
        title: 'Phản hồi',
        child: _FeedbackCard(settings: settings, onChanged: _updateSettings),
      ),
      VitTradeSection(
        title: 'Hiển thị',
        child: _DisplayCard(settings: settings, onChanged: _updateSettings),
      ),
      VitTradeSection(
        title: 'Khôi phục',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ResetButton(onReset: _resetSettings),
            const SizedBox(height: _settingsSpace),
            const _InfoNote(),
          ],
        ),
      ),
      const TradeBodyReviewSection(
        title: 'Settings body review',
        message: 'Trade settings body reviewed',
        detail:
            'Order defaults, confirmations, feedback, display, reset, and result states stay visible.',
        primary: 'Safety review remains above settings mutations.',
        secondary:
            'Confirmation and slippage settings stay grouped by risk intent.',
        tertiary: 'Reset remains separated from informational guidance.',
      ),
    ];
  }

  Future<void> _updateSettings(TradeSettings settings) async {
    final updated = await ref
        .read(tradeReadModelControllerProvider)
        .patchTradeSettings(settings);
    if (!mounted) return;
    setState(() => _settings = updated);
  }

  Future<void> _resetSettings() async {
    final snapshot = await ref
        .read(tradeReadModelControllerProvider)
        .getTradeSettings();
    if (!mounted) return;
    await _updateSettings(snapshot.settings);
  }
}
