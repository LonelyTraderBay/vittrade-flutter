import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_high_risk_status_ui.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_detail_hero.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../../widgets/futures/leverage_header_hero_risk.dart';
part '../../../widgets/futures/leverage_controls_presets.dart';
part '../../../widgets/futures/leverage_impact_confirm.dart';

const _tradePrimary = AppColors.primary;
const _chipBackground = AppColors.surface2;
const _leverageSpace = AppSpacing.x2;
const _leverageCardSpace = AppSpacing.x3;
const _leverageImpactRowLineHeight = 1.12;

class LeveragePage extends ConsumerStatefulWidget {
  const LeveragePage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc058_leverage_scroll_content');
  static const backKey = Key('sc058_back');
  static const sliderKey = Key('sc058_slider');
  static const confirmKey = Key('sc058_confirm');

  static Key stopKey(int leverage) => Key('sc058_stop_$leverage');
  static Key presetKey(int leverage) => Key('sc058_preset_$leverage');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LeveragePage> createState() => _LeveragePageState();
}

class _LeveragePageState extends ConsumerState<LeveragePage> {
  @override
  Widget build(BuildContext context) {
    // GD4 Cụm F3: `getFuturesLeverage` giờ Future<T> — trang gate qua
    // `.when()` trước khi dựng TradeLeverageController (mục 6), đảm bảo
    // `.value` bên trong Notifier không bao giờ null trong luồng UI thật.
    final snapshotAsync = ref.watch(
      tradeFuturesLeverageSnapshotProvider(widget.pairId),
    );
    return snapshotAsync.when(
      loading: () => const VitSkeletonList(),
      error: (error, stackTrace) => VitErrorState(
        title: 'Không tải được màn hình đòn bẩy',
        message: 'Vui lòng kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: () =>
            ref.invalidate(tradeFuturesLeverageSnapshotProvider(widget.pairId)),
      ),
      data: (_) => _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    // STATE-S22: nấc đòn bẩy sống trong Notifier (family key = pairId) —
    // hết dual-source `late int _leverage` + setState của bản cũ.
    final leverageState = ref.watch(
      tradeLeverageControllerProvider(widget.pairId),
    );
    final notifier = ref.read(
      tradeLeverageControllerProvider(widget.pairId).notifier,
    );
    final snapshot = leverageState.snapshot;
    final preview = leverageState.preview;
    final leverage = leverageState.request.leverage;
    final riskColor = Color(preview.riskColorHex);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();

    return VitTradeHubScaffold(
      title: 'Điều chỉnh đòn bẩy',
      subtitle: 'Hiện tại: ${snapshot.currentLeverage}x',
      semanticLabel: 'Điều chỉnh đòn bẩy giao dịch Futures',
      semanticIdentifier: 'SC-058',
      contentKey: LeveragePage.contentKey,
      backKey: LeveragePage.backKey,
      onBack: _returnToFutures,
      shellRenderMode: mode,
      activeProductId: 'futures',
      productPair: snapshot.futures.pair,
      showProductTabs: true,
      navigationBuilder: buildTradeProductNavigation,
      children: [
        VitTradeDetailHero(
          primaryLabel: 'Đòn bẩy',
          primaryValue: '${preview.leverage}x',
          primaryColor: riskColor,
          leadingIcon: Icons.bolt_rounded,
          badgeLabel: 'Rủi ro: ${preview.riskLabel}',
          badgeColor: riskColor,
        ),
        _RiskMeter(preview: preview, riskColor: riskColor),
        _LeverageSlider(
          leverage: leverage,
          stops: snapshot.sliderStops,
          riskColor: riskColor,
          onChanged: notifier.setLeverage,
        ),
        _PresetGrid(
          presets: snapshot.presets,
          active: leverage,
          onChanged: notifier.setLeverage,
        ),
        _ImpactCard(margin: snapshot.exampleMargin, preview: preview),
        _WarningCard(
          preview: preview,
          status: leverageState.status,
          errorMessage: leverageState.errorMessage,
        ),
        if (preview.showRiskTips) const _RiskTipsCard(),
        _ConfirmButton(
          leverage: leverage,
          submitting: leverageState.status.isBusy,
          onPressed: _confirm,
        ),
      ],
    );
  }

  Future<void> _confirm() async {
    final provider = tradeLeverageControllerProvider(widget.pairId);
    await ref.read(provider.notifier).submit();
    if (!mounted) return;
    final state = ref.read(provider);
    if (state.status == TradeHighRiskFlowStatus.success) {
      _returnToFutures();
      return;
    }
    await showVitNoticeSheet(
      context: context,
      title: 'Điều chỉnh đòn bẩy thất bại',
      message:
          state.errorMessage ??
          'Không điều chỉnh được đòn bẩy. Vui lòng thử lại.',
      variant: VitBannerVariant.error,
    );
  }

  void _returnToFutures() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.tradeFutures(widget.pairId),
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}
