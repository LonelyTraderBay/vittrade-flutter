import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_common.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_overview.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_sheets.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_tabs.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

class ExecutionQualityDemoPage extends ConsumerStatefulWidget {
  const ExecutionQualityDemoPage({super.key, this.shellRenderMode});

  static const contentKey = executionQualityContentKey;
  static const slippageButtonKey = executionQualitySlippageButtonKey;
  static const executionButtonKey = executionQualityExecutionButtonKey;
  static const amendmentButtonKey = executionQualityAmendmentButtonKey;
  static const slippageSaveKey = executionQualitySlippageSaveKey;
  static const amendmentSaveKey = executionQualityAmendmentSaveKey;

  static Key tabKey(String id) => executionQualityTabKey(id);
  static Key featureKey(String id) => executionQualityFeatureKey(id);
  static Key toleranceKey(double value) => executionQualityToleranceKey(value);

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExecutionQualityDemoPage> createState() =>
      _ExecutionQualityDemoPageState();
}

class _ExecutionQualityDemoPageState
    extends ConsumerState<ExecutionQualityDemoPage> {
  ExecutionQualityTab _tab = ExecutionQualityTab.slippage;

  /// GD4 Cụm F3: seed từ snapshot async lần đầu build() có `data:` (mục 5) —
  /// null trước đó (loading/error), lazily gán trong `data:` branch bên dưới
  /// thay vì initState() (getExecutionQuality() giờ là `Future<T>`).
  TradeSlippageSettings? _settings;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeExecutionQualitySnapshotProvider);

    return VitTradeHubScaffold(
      title: 'Chất lượng khớp lệnh',
      subtitle: 'Trượt giá · Báo cáo · Sửa lệnh',
      semanticLabel: 'Chất lượng khớp lệnh',
      semanticIdentifier: 'SC-061',
      contentKey: ExecutionQualityDemoPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      showProductTabs: true,
      navigationBuilder: buildTradeProductNavigation,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được chất lượng khớp lệnh',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () =>
                ref.invalidate(tradeExecutionQualitySnapshotProvider),
          ),
        ],
        data: (snapshot) {
          final settings = _settings ??= snapshot.slippageSettings;
          return [
            const ExecutionQualityIntroCard(),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại chất lượng khớp lệnh',
              message:
                  'Ngưỡng trượt giá, báo cáo khớp lệnh và sửa lệnh được xem trước trước khi lưu hoặc gửi thay đổi.',
              contractId: 'execution-quality-demo-review',
              density: VitDensity.tool,
            ),
            for (final feature in snapshot.features)
              ExecutionQualityFeatureCard(
                feature: feature,
                onTap: () => _onFeatureTap(feature),
              ),
            const ExecutionQualityBenefitsCard(),
            ExecutionQualityProgressCard(items: snapshot.statusItems),
            const ExecutionQualityParityCard(),
            ExecutionQualityTabs(
              active: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            if (_tab == ExecutionQualityTab.slippage)
              ExecutionQualitySlippageTab(
                settings: settings,
                onOpen: _openSlippageSheet,
              )
            else if (_tab == ExecutionQualityTab.execution)
              ExecutionQualityExecutionTab(onOpen: _openExecutionSheet)
            else
              ExecutionQualityAmendmentTab(onOpen: _openAmendmentSheet),
          ];
        },
      ),
    );
  }

  void _onFeatureTap(TradeExecutionFeature feature) {
    if (feature.id == 'execution') {
      setState(() => _tab = ExecutionQualityTab.execution);
      unawaited(_openExecutionSheet());
      return;
    }
    if (feature.id == 'amendment') {
      setState(() => _tab = ExecutionQualityTab.amendment);
      unawaited(_openAmendmentSheet());
      return;
    }
    setState(() => _tab = ExecutionQualityTab.slippage);
    unawaited(_openSlippageSheet());
  }

  Future<void> _openSlippageSheet() async {
    final current = _settings;
    if (current == null) return;
    final updated = await showVitBottomSheet<TradeSlippageSettings>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => ExecutionQualitySlippageSheet(settings: current),
    );
    if (updated == null || !mounted) return;
    final saved = await ref
        .read(tradeReadModelControllerProvider)
        .updateSlippageSettings(updated);
    if (!mounted) return;
    setState(() => _settings = saved);
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Đã lưu cài đặt',
        message: 'Ngưỡng trượt giá: ${saved.tolerancePct.toStringAsFixed(1)}%',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }

  Future<void> _openExecutionSheet() async {
    final snapshot = await ref
        .read(tradeReadModelControllerProvider)
        .getExecutionQuality();
    if (!mounted) return;
    await showVitBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) =>
          ExecutionQualityExecutionSheet(report: snapshot.report),
    );
  }

  Future<void> _openAmendmentSheet() async {
    final snapshot = await ref
        .read(tradeReadModelControllerProvider)
        .getExecutionQuality();
    if (!mounted) return;
    final order = snapshot.openOrder;
    final amended = await showVitBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => ExecutionQualityAmendmentSheet(order: order),
    );
    if (amended != true || !mounted) return;
    final result = await ref
        .read(tradeReadModelControllerProvider)
        .amendOrder(
          TradeOrderAmendmentRequest(
            orderId: order.id,
            newPrice: 68600,
            newAmount: order.amount,
          ),
        );
    if (!mounted) return;
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Sửa lệnh thành công',
        message: 'Đã sửa lệnh ${result.orderId}',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      ),
    );
  }
}
