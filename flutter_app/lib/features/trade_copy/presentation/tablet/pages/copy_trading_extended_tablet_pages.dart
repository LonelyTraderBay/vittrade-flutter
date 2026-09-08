import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
part 'copy_trading_extended_tablet_pages_extra.dart';

Widget _extError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _extFrame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required Widget child,
  Key? contentKey,
  String backFallback = AppRoutePaths.tradeCopyTrading,
}) {
  final showBack = context.canPop();
  return VitPageLayout(
    variant: VitPageVariant.flush,
    semanticLabel: semanticLabel,
    semanticIdentifier: semanticIdentifier,
    child: Column(
      children: [
        VitHeader(
          title: title,
          subtitle: subtitle,
          showBack: showBack,
          onBack: showBack
              ? () => goBackOrFallback(
                  context,
                  fallbackPath: backFallback,
                  mode: BackNavigationMode.historyThenFallback,
                )
              : null,
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1080),
              child: SingleChildScrollView(
                key: contentKey,
                padding: const EdgeInsets.fromLTRB(
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x4,
                  TabletSpacingTokens.x6,
                  TabletSpacingTokens.x6,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _extSection({required String title, required List<Widget> rows}) {
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

List<Widget> _extRows(List<(String, String)> pairs) {
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

/// SC-076: So sánh provider.
class ProviderComparisonTabletPage extends ConsumerWidget {
  const ProviderComparisonTabletPage({super.key});

  static const contentKey = Key('sc076_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeProviderComparisonProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _extFrame(
        context: context,
        semanticIdentifier: 'SC-076',
        semanticLabel: 'So sánh provider',
        title: 'So sánh provider',
        subtitle: 'Chỉ số cạnh nhau',
        contentKey: ProviderComparisonTabletPage.contentKey,
        child: _extError(
          'Không tải được so sánh',
          () => ref.invalidate(tradeProviderComparisonProvider),
        ),
      ),
      data: (snapshot) => _extFrame(
        context: context,
        semanticIdentifier: 'SC-076',
        semanticLabel: 'So sánh provider',
        title: 'So sánh provider',
        subtitle: '${snapshot.selectedCount}/${snapshot.maxProviders} đã chọn',
        contentKey: ProviderComparisonTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final metric in snapshot.metrics)
              Padding(
                padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
                child: _extSection(
                  title: metric.label,
                  rows: [
                    for (final provider in snapshot.providers)
                      Padding(
                        padding: TabletSpacingTokens.tableCellPaddingV,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                provider.name,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                            ),
                            Text(
                              metric.values[provider.id] ?? '—',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            Text(
              snapshot.disclaimer,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-078: Phân tích rủi ro danh mục.
class PortfolioRiskAnalysisTabletPage extends ConsumerWidget {
  const PortfolioRiskAnalysisTabletPage({super.key});

  static const contentKey = Key('sc078_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradePortfolioRiskAnalysisProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _extFrame(
        context: context,
        semanticIdentifier: 'SC-078',
        semanticLabel: 'Phân tích rủi ro danh mục',
        title: 'Phân tích rủi ro',
        subtitle: 'Exposure · VaR',
        contentKey: PortfolioRiskAnalysisTabletPage.contentKey,
        child: _extError(
          'Không tải được phân tích rủi ro',
          () => ref.invalidate(tradePortfolioRiskAnalysisProvider),
        ),
      ),
      data: (snapshot) => _extFrame(
        context: context,
        semanticIdentifier: 'SC-078',
        semanticLabel: 'Phân tích rủi ro danh mục',
        title: 'Phân tích rủi ro danh mục',
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        contentKey: PortfolioRiskAnalysisTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _extSection(
              title: 'Chỉ số rủi ro',
              rows: _extRows([
                ('Tổng exposure', formatTradeUsdWhole(snapshot.totalExposure)),
                ('VaR 95', formatTradeUsdWhole(snapshot.var95)),
                ('VaR 99', formatTradeUsdWhole(snapshot.var99)),
                ('Điểm đa dạng hóa', '${snapshot.diversificationScore}/100'),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _extSection(
              title: 'Exposure theo tài sản',
              rows: [
                for (final exposure in snapshot.assetExposures)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            exposure.asset,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                        Text(
                          formatTradeUsdWhole(exposure.value),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            if (snapshot.riskAlerts.isNotEmpty)
              _extSection(
                title: 'Cảnh báo',
                rows: [
                  for (final alert in snapshot.riskAlerts)
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.warning_amber_rounded,
                              size: TabletSpacingTokens.iconSm,
                              color: AppColors.caution,
                            ),
                          ),
                          const SizedBox(width: TabletSpacingTokens.x2),
                          Expanded(
                            child: Text(
                              alert,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// SC-081: Quản trị provider.
class ProviderGovernanceTabletPage extends ConsumerWidget {
  const ProviderGovernanceTabletPage({super.key});

  static const contentKey = Key('sc081_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeProviderGovernanceProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _extFrame(
        context: context,
        semanticIdentifier: 'SC-081',
        semanticLabel: 'Quản trị provider',
        title: 'Quản trị provider',
        subtitle: 'Sửa đổi · Tuân thủ',
        contentKey: ProviderGovernanceTabletPage.contentKey,
        child: _extError(
          'Không tải được quản trị',
          () => ref.invalidate(tradeProviderGovernanceProvider),
        ),
      ),
      data: (snapshot) => _extFrame(
        context: context,
        semanticIdentifier: 'SC-081',
        semanticLabel: 'Quản trị provider',
        title: 'Quản trị provider',
        subtitle: 'Sửa đổi chiến lược · Thông báo',
        contentKey: ProviderGovernanceTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _extSection(
              title: 'Sửa đổi chiến lược đã công bố',
              rows: [
                for (final modification in snapshot.modifications)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${modification.date} · ${modification.type}: ${modification.oldValue} → ${modification.newValue}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                        Icon(
                          modification.notificationSent
                              ? Icons.mark_email_read_outlined
                              : Icons.mark_email_unread_outlined,
                          size: TabletSpacingTokens.iconSm,
                          color: modification.notificationSent
                              ? AppColors.buy
                              : AppColors.text3,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _extSection(
              title: 'Tuân thủ',
              rows: [
                for (final item in snapshot.complianceItems)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.item,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                        Icon(
                          item.status
                              ? Icons.check_circle_outline_rounded
                              : Icons.cancel_outlined,
                          size: TabletSpacingTokens.iconSm,
                          color: item.status ? AppColors.buy : AppColors.sell,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            Text(
              snapshot.warning,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
