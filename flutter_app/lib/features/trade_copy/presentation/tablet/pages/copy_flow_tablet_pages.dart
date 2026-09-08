import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
part 'copy_flow_tablet_pages_extra.dart';

Widget _flowError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _flowFrame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required Widget child,
  Key? contentKey,
  required String providerId,
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
                  fallbackPath: AppRoutePaths.tradeCopyProvider(providerId),
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

/// SC-070: Hồ sơ provider chi tiết.
class CopyProviderDetailTabletPage extends ConsumerWidget {
  const CopyProviderDetailTabletPage({super.key, required this.providerId});

  static const contentKey = Key('sc070_tablet_content');

  final String providerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      tradeCopyProviderDetailProvider(providerId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _flowFrame(
        context: context,
        semanticIdentifier: 'SC-070',
        semanticLabel: 'Hồ sơ provider sao chép',
        title: 'Hồ sơ provider',
        subtitle: providerId,
        providerId: providerId,
        contentKey: CopyProviderDetailTabletPage.contentKey,
        child: _flowError(
          'Không tải được hồ sơ provider',
          () => ref.invalidate(tradeCopyProviderDetailProvider(providerId)),
        ),
      ),
      data: (snapshot) {
        final provider = snapshot.provider;
        if (provider == null) {
          return _flowFrame(
            context: context,
            semanticIdentifier: 'SC-070',
            semanticLabel: 'Hồ sơ provider sao chép',
            title: 'Hồ sơ provider',
            subtitle: providerId,
            providerId: providerId,
            contentKey: CopyProviderDetailTabletPage.contentKey,
            child: VitEmptyState(
              icon: Icons.person_search_outlined,
              title: 'Không tìm thấy provider',
              message: snapshot.notFoundMessage,
            ),
          );
        }
        return _flowFrame(
          context: context,
          semanticIdentifier: 'SC-070',
          semanticLabel: 'Hồ sơ provider sao chép',
          title: provider.name,
          subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
          providerId: providerId,
          contentKey: CopyProviderDetailTabletPage.contentKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Row(
                  children: [
                    Expanded(
                      child: _statCell(
                        'Win rate',
                        '${provider.winRate.toStringAsFixed(1)}%',
                        AppColors.buy,
                      ),
                    ),
                    Expanded(
                      child: _statCell(
                        'PnL',
                        formatTradeSignedUsdRounded(provider.totalPnl),
                        provider.totalPnl >= 0 ? AppColors.buy : AppColors.sell,
                      ),
                    ),
                    Expanded(
                      child: _statCell(
                        'AUM',
                        formatTradeUsdWhole(provider.aum),
                        AppColors.text1,
                      ),
                    ),
                    Expanded(
                      child: _statCell(
                        'Copiers',
                        '${provider.copiers}',
                        AppColors.text1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
              VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._rowsCopy([
                      ('Số lệnh', '${provider.totalTrades}'),
                      ('Sharpe', provider.sharpeRatio.toStringAsFixed(2)),
                      (
                        'Sụt giảm tối đa',
                        '${provider.maxDrawdown.toStringAsFixed(1)}%',
                      ),
                      ('Thời gian giữ TB', provider.avgHoldingTime),
                      (
                        'Rủi ro',
                        switch (provider.riskLevel) {
                          TradeCopyRiskLevel.low => 'Thấp',
                          TradeCopyRiskLevel.medium => 'Trung bình',
                          TradeCopyRiskLevel.high => 'Cao',
                        },
                      ),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              VitCtaButton(
                onPressed: () => context.go(
                  AppRoutePaths.tradeCopyProviderAssessment(providerId),
                ),
                child: const Text('Bắt đầu đánh giá trước khi sao chép'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCell(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: AppTextStyles.control.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

List<Widget> _rowsCopy(List<(String, String)> pairs) {
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

/// SC-071: Đánh giá trước khi sao chép.
class PreCopyAssessmentTabletPage extends ConsumerWidget {
  const PreCopyAssessmentTabletPage({super.key, required this.providerId});

  static const contentKey = Key('sc071_tablet_content');

  final String providerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradePreCopyAssessmentProvider(providerId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _flowFrame(
        context: context,
        semanticIdentifier: 'SC-071',
        semanticLabel: 'Đánh giá trước sao chép',
        title: 'Đánh giá trước khi sao chép',
        subtitle: providerId,
        providerId: providerId,
        contentKey: PreCopyAssessmentTabletPage.contentKey,
        child: _flowError(
          'Không tải được đánh giá',
          () => ref.invalidate(tradePreCopyAssessmentProvider(providerId)),
        ),
      ),
      data: (snapshot) => _flowFrame(
        context: context,
        semanticIdentifier: 'SC-071',
        semanticLabel: 'Đánh giá trước sao chép',
        title: 'Đánh giá trước khi sao chép',
        subtitle: '${snapshot.questions.length} câu hỏi',
        providerId: providerId,
        contentKey: PreCopyAssessmentTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final question in snapshot.questions)
              Padding(
                padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
                child: VitCard(
                  radius: VitCardRadius.tight,
                  padding: TabletSpacingTokens.cardPaddingCompact,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.question,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      const SizedBox(height: TabletSpacingTokens.x1),
                      Text(
                        question.description,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: TabletSpacingTokens.x2),
                      Wrap(
                        spacing: TabletSpacingTokens.x3,
                        runSpacing: TabletSpacingTokens.x2,
                        children: [
                          for (final option in question.options)
                            VitFilterChip(
                              label: option.label,
                              onTap: () {},
                              active: false,
                              color: AppColors.primary,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: TabletSpacingTokens.x1),
            VitCtaButton(
              onPressed: () => context.go(
                AppRoutePaths.tradeCopyProviderConfiguration(providerId),
              ),
              child: const Text('Tiếp tục cấu hình'),
            ),
          ],
        ),
      ),
    );
  }
}
