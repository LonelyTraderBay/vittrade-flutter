import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'copy_trading_core_tablet_pages_extra.dart';

Widget _copyError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _copySection({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _copyRows(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

/// SC-066: Các bản sao đang chạy.
class ActiveCopiesTabletPage extends ConsumerWidget {
  const ActiveCopiesTabletPage({super.key});

  static const contentKey = Key('sc066_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerAsync = ref.watch(tradeActiveCopiesControllerProvider);

    return controllerAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-066',
        semanticLabel: 'Bản sao đang chạy',
        title: 'Bản sao đang chạy',
        subtitle: 'Danh mục sao chép',
        contentKey: ActiveCopiesTabletPage.contentKey,
        children: [
          _copyError(
            'Không tải được bản sao',
            () => ref.invalidate(tradeActiveCopiesControllerProvider),
          ),
        ],
      ),
      data: (controller) {
        final snapshot = controller.state.snapshot;
        final portfolio = snapshot.portfolio;
        return VitTabletSectionFrame(
          semanticIdentifier: 'SC-066',
          semanticLabel: 'Bản sao đang chạy',
          title: 'Bản sao đang chạy',
          subtitle:
              '${portfolio.activeCopies} bản sao · ${snapshot.lastUpdatedLabel}',
          contentKey: ActiveCopiesTabletPage.contentKey,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng giá trị',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        Text(
                          formatTradeUsdWhole(portfolio.totalValue),
                          style: AppTextStyles.control.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tổng PnL',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        Text(
                          formatTradeSignedUsdRounded(portfolio.totalPnl),
                          style: AppTextStyles.control.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: portfolio.totalPnl >= 0
                                ? AppColors.buy
                                : AppColors.sell,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (snapshot.copies.isEmpty)
              const VitEmptyState(
                icon: Icons.copy_all_outlined,
                title: 'Chưa có bản sao',
                message: 'Chọn provider để bắt đầu sao chép.',
              )
            else
              VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.zeroInsets,
                clip: true,
                child: Column(
                  children: [
                    for (var i = 0; i < snapshot.copies.length; i++) ...[
                      Padding(
                        padding: TabletSpacingTokens.tableCellPaddingTall,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.copies[i].providerName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: AppTextStyles.bold,
                                      color: AppColors.text1,
                                    ),
                                  ),
                                  Text(
                                    'Từ ${snapshot.copies[i].startDate} · ${snapshot.copies[i].trades} lệnh',
                                    style: AppTextStyles.micro.copyWith(
                                      color: AppColors.text3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                formatTradeUsdWhole(
                                  snapshot.copies[i].currentValue,
                                ),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                formatTradeSignedUsdRounded(
                                  snapshot.copies[i].pnl,
                                ),
                                style: AppTextStyles.caption.copyWith(
                                  color: snapshot.copies[i].pnl >= 0
                                      ? AppColors.buy
                                      : AppColors.sell,
                                  fontWeight: AppTextStyles.bold,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < snapshot.copies.length - 1)
                        const Divider(
                          height: TabletSpacingTokens.dividerHairline,
                          thickness: TabletSpacingTokens.dividerHairline,
                          color: AppColors.divider,
                        ),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// SC-067: Cài đặt sao chép.
class CopySettingsTabletPage extends ConsumerWidget {
  const CopySettingsTabletPage({super.key});

  static const contentKey = Key('sc067_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerAsync = ref.watch(tradeCopySettingsControllerProvider);

    return controllerAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-067',
        semanticLabel: 'Cài đặt sao chép',
        title: 'Cài đặt sao chép',
        subtitle: 'Tham số · Hạn mức',
        contentKey: CopySettingsTabletPage.contentKey,
        children: [
          _copyError(
            'Không tải được cài đặt',
            () => ref.invalidate(tradeCopySettingsControllerProvider),
          ),
        ],
      ),
      data: (controller) {
        final settings = controller.state.snapshot.settings;
        return VitTabletSectionFrame(
          semanticIdentifier: 'SC-067',
          semanticLabel: 'Cài đặt sao chép',
          title: 'Cài đặt sao chép',
          subtitle: 'Tham số · Hạn mức',
          contentKey: CopySettingsTabletPage.contentKey,
          children: [
            _copySection(
              title: 'Cấu hình hiện tại',
              rows: _copyRows([
                (
                  'Chế độ mặc định',
                  switch (settings.defaultCopyMode) {
                    TradeCopySettingsMode.mirror => 'Mirror',
                    TradeCopySettingsMode.fixed => 'Số lượng cố định',
                    TradeCopySettingsMode.smart => 'Thông minh',
                  },
                ),
                (
                  'Tỷ lệ mặc định',
                  '${settings.defaultCopyRatio.toStringAsFixed(2)}x',
                ),
                (
                  'Dừng lỗ mặc định',
                  '${settings.defaultStopLoss.toStringAsFixed(1)}%',
                ),
                (
                  'Chốt lời mặc định',
                  '${settings.defaultTakeProfit.toStringAsFixed(1)}%',
                ),
                (
                  'Phân bổ danh mục tối đa',
                  '${settings.maxPortfolioAllocation.toStringAsFixed(0)}%',
                ),
                ('Số bản sao hoạt động tối đa', '${settings.maxCopiesActive}'),
                (
                  'Circuit breaker',
                  settings.enableCircuitBreaker
                      ? 'Bật (${settings.circuitBreakerThreshold.toStringAsFixed(0)}%)'
                      : 'Tắt',
                ),
              ]),
            ),
          ],
        );
      },
    );
  }
}

/// SC-068: Thông báo sao chép.
