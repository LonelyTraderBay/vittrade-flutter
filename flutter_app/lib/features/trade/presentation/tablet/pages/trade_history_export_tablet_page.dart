import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Xuất lịch sử giao dịch (SC-054, 2026-08-31) — cùng
/// [tradeHistoryExportStateControllerProvider] với trang phone: chọn định
/// dạng · khoảng thời gian · trường kèm theo (mọi control wired thật),
/// tạo báo cáo và xem kết quả — bản tóm tắt thống kê luôn thấy ở cột phụ
/// trước khi tạo (an toàn tài chính: preview trước khi tạo).
class TradeHistoryExportTabletPage extends ConsumerWidget {
  const TradeHistoryExportTabletPage({super.key});

  static const submitKey = Key('sc054_tablet_submit');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportAsync = ref.watch(tradeExportSnapshotProvider);
    return exportAsync.when(
      loading: () => TradeTabletDetailSurface(
        semanticLabel: 'Xuất lịch sử giao dịch',
        semanticIdentifier: 'SC-054',
        title: 'Xuất lịch sử giao dịch',
        subtitle: 'Chọn phạm vi · định dạng · trường kèm theo',
        onBack: () => context.go(AppRoutePaths.trade),
        primary: const Center(child: CircularProgressIndicator()),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => TradeTabletDetailSurface(
        semanticLabel: 'Xuất lịch sử giao dịch',
        semanticIdentifier: 'SC-054',
        title: 'Xuất lịch sử giao dịch',
        subtitle: 'Chọn phạm vi · định dạng · trường kèm theo',
        onBack: () => context.go(AppRoutePaths.trade),
        primary: VitErrorState(
          title: 'Không tải được dữ liệu xuất',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(tradeExportSnapshotProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) {
        final state = ref.watch(tradeHistoryExportStateControllerProvider);
        final notifier = ref.read(
          tradeHistoryExportStateControllerProvider.notifier,
        );

        return TradeTabletDetailSurface(
          semanticLabel: 'Xuất lịch sử giao dịch',
          semanticIdentifier: 'SC-054',
          title: 'Xuất lịch sử giao dịch',
          subtitle: 'Chọn phạm vi · định dạng · trường kèm theo',
          onBack: () => goBackOrFallback(
            context,
            fallbackPath: AppRoutePaths.trade,
            mode: BackNavigationMode.historyThenFallback,
          ),
          primary: VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _ExportGroupLabel('Định dạng'),
                Wrap(
                  spacing: TabletSpacingTokens.rowGap,
                  runSpacing: TabletSpacingTokens.rowGap,
                  children: [
                    for (final format in snapshot.formats)
                      VitFilterChip(
                        key: Key('sc054_tablet_format_${format.id}'),
                        label: format.label,
                        active: state.format == format.id,
                        onTap: () => notifier.setFormat(format.id),
                        color: AppColors.primary,
                      ),
                  ],
                ),
                const SizedBox(
                  height: TabletSpacingTokens.pageRhythmStandardSectionGap,
                ),
                const _ExportGroupLabel('Khoảng thời gian'),
                Wrap(
                  spacing: TabletSpacingTokens.rowGap,
                  runSpacing: TabletSpacingTokens.rowGap,
                  children: [
                    for (final period in snapshot.periods)
                      VitFilterChip(
                        key: Key('sc054_tablet_period_${period.id}'),
                        label: period.label,
                        active: state.period == period.id,
                        onTap: () => notifier.setPeriod(period.id),
                        color: AppColors.primary,
                      ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                const _ExportGroupLabel('Trường kèm theo'),
                for (final include in state.includes)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: TabletSpacingTokens.x2,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            include.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        VitTogglePill(
                          key: Key('sc054_tablet_include_${include.id}'),
                          enabled: include.checked,
                          onChanged: (_) => notifier.toggleInclude(include.id),
                          semanticLabel: 'Bao gồm ${include.label}',
                        ),
                      ],
                    ),
                  ),
                const SizedBox(
                  height: TabletSpacingTokens.pageRhythmStandardSectionGap,
                ),
                if (state.result != null) ...[
                  VitCard(
                    variant: VitCardVariant.inner,
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Báo cáo đã tạo',
                          style: AppTextStyles.control.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x4),
                        Text(
                          'Tải xuống: ${state.result!.downloadUrl}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: TabletSpacingTokens.pageRhythmStandardSectionGap,
                  ),
                  VitCtaButton(
                    onPressed: notifier.resetResult,
                    child: const Text('Tạo báo cáo khác'),
                  ),
                ] else
                  VitCtaButton(
                    key: TradeHistoryExportTabletPage.submitKey,
                    onPressed: state.isExporting
                        ? null
                        : () async {
                            await notifier.submitExport();
                            if (!context.mounted) return;
                            await showVitNoticeSheet(
                              context: context,
                              title: 'Đã tạo báo cáo',
                              message: 'Báo cáo đã sẵn sàng để tải xuống.',
                              variant: VitBannerVariant.success,
                              ctaVariant: VitCtaButtonVariant.success,
                            );
                          },
                    loading: state.isExporting,
                    child: Text(
                      state.isExporting ? 'Đang tạo báo cáo…' : 'Tạo báo cáo',
                    ),
                  ),
              ],
            ),
          ),
          secondary: VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tóm tắt dữ liệu',
                  style: AppTextStyles.control.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                for (final (label, value) in [
                  ('Tổng số lệnh', '${snapshot.stats.totalTrades}'),
                  (
                    'Tổng khối lượng',
                    formatTradeMoney(snapshot.stats.totalVolume),
                  ),
                  ('Tổng phí', formatTradeMoney(snapshot.stats.totalFees)),
                  ('P/L ròng', formatTradeSignedMoney(snapshot.stats.netPnl)),
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: TabletSpacingTokens.x1,
                    ),
                    child: VitKeyValueRow(
                      label: label,
                      value: value,
                      labelStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                      valueStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ExportGroupLabel extends StatelessWidget {
  const _ExportGroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: TabletSpacingTokens.pageRhythmCompactInnerGap,
      ),
      child: Text(
        label,
        style: AppTextStyles.control.copyWith(
          color: AppColors.text1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
