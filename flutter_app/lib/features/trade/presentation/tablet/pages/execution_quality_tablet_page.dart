import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_common.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_overview.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_sheets.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_tabs.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Chất lượng khớp lệnh (SC-061): cột chính là vùng làm
/// việc (tab Trượt giá | Khớp lệnh | Sửa lệnh — tái dùng widget public của
/// trang phone theo R2), cột phụ là thẻ tính năng + tiến độ + parity.
class ExecutionQualityTabletPage extends ConsumerStatefulWidget {
  const ExecutionQualityTabletPage({super.key});

  static const contentKey = Key('sc061_tablet_content');
  static const statsKey = Key('sc061_tablet_stats');

  @override
  ConsumerState<ExecutionQualityTabletPage> createState() =>
      _ExecutionQualityTabletPageState();
}

class _ExecutionQualityTabletPageState
    extends ConsumerState<ExecutionQualityTabletPage> {
  ExecutionQualityTab _tab = ExecutionQualityTab.slippage;

  /// Cài đặt trượt giá đang chỉnh — seed từ snapshot lần đầu có data
  /// (cùngidiom GD4 Cụm F3 của trang phone).
  TradeSlippageSettings? _settings;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeExecutionQualitySnapshotProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chất lượng khớp lệnh',
      semanticIdentifier: 'SC-061',
      child: Column(
        children: [
          VitHeader(
            title: 'Chất lượng khớp lệnh',
            subtitle: 'Trượt giá · Báo cáo · Sửa lệnh',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.trade,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
            backKey: TradeTabletKeys.back,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được chất lượng khớp lệnh',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(tradeExecutionQualitySnapshotProvider),
                ),
              ),
              data: (snapshot) {
                final settings = _settings ??= snapshot.slippageSettings;
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(tradeExecutionQualitySnapshotProvider);
                    await ref.read(
                      tradeExecutionQualitySnapshotProvider.future,
                    );
                  },
                  primaryChildren: [
                    const ExecutionQualityIntroCard(),
                    VitCard(
                      variant: VitCardVariant.inner,
                      radius: VitCardRadius.tight,
                      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Xem lại chất lượng khớp lệnh',
                            message:
                                'Ngưỡng trượt giá, báo cáo khớp lệnh và sửa lệnh được xem trước trước khi lưu hoặc gửi thay đổi.',
                            contractId: 'execution-quality-tablet-review',
                            density: VitDensity.tool,
                          ),
                          const SizedBox(height: TabletSpacingTokens.x4),
                          ExecutionQualityTabs(
                            active: _tab,
                            onChanged: (tab) => setState(() => _tab = tab),
                          ),
                        ],
                      ),
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
                  ],
                  secondaryChildren: [
                    for (final feature in snapshot.features)
                      ExecutionQualityFeatureCard(
                        feature: feature,
                        onTap: () => _onFeatureTap(feature),
                      ),
                    VitCard(
                      key: ExecutionQualityTabletPage.statsKey,
                      radius: VitCardRadius.tight,
                      borderColor: AppColors.border,
                      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final item in snapshot.statusItems)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: TabletSpacingTokens.x2,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.label,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.text2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: TabletSpacingTokens.x2),
                                  Icon(
                                    item.complete
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    size: TabletSpacingTokens.iconSm,
                                    color: item.complete
                                        ? AppColors.buy
                                        : AppColors.text3,
                                  ),
                                ],
                              ),
                            ),
                          const Divider(
                            height: TabletSpacingTokens.dividerHairline,
                            thickness: TabletSpacingTokens.dividerHairline,
                            color: AppColors.divider,
                          ),
                          const ExecutionQualityParityCard(),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onFeatureTap(TradeExecutionFeature feature) {
    if (feature.id == 'execution') {
      setState(() => _tab = ExecutionQualityTab.execution);
      return;
    }
    if (feature.id == 'amendment') {
      setState(() => _tab = ExecutionQualityTab.amendment);
      return;
    }
    setState(() => _tab = ExecutionQualityTab.slippage);
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
