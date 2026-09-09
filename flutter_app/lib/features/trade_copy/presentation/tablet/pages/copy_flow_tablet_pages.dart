import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'copy_flow_tablet_pages_extra.dart';

Widget _flowError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
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
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-070',
        semanticLabel: 'Hồ sơ provider sao chép',
        title: 'Hồ sơ provider',
        subtitle: providerId,
        backFallback: AppRoutePaths.tradeCopyProvider(providerId),
        contentKey: CopyProviderDetailTabletPage.contentKey,
        children: [
          _flowError(
            'Không tải được hồ sơ provider',
            () => ref.invalidate(tradeCopyProviderDetailProvider(providerId)),
          ),
        ],
      ),
      data: (snapshot) {
        final provider = snapshot.provider;
        if (provider == null) {
          return VitTabletSectionFrame(
            semanticIdentifier: 'SC-070',
            semanticLabel: 'Hồ sơ provider sao chép',
            title: 'Hồ sơ provider',
            subtitle: providerId,
            backFallback: AppRoutePaths.tradeCopyProvider(providerId),
            contentKey: CopyProviderDetailTabletPage.contentKey,
            children: [
              VitEmptyState(
                icon: Icons.person_search_outlined,
                title: 'Không tìm thấy provider',
                message: snapshot.notFoundMessage,
              ),
            ],
          );
        }
        return VitTabletSectionFrame(
          semanticIdentifier: 'SC-070',
          semanticLabel: 'Hồ sơ provider sao chép',
          title: provider.name,
          subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
          backFallback: AppRoutePaths.tradeCopyProvider(providerId),
          contentKey: CopyProviderDetailTabletPage.contentKey,
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
              onPressed: () => context.push(
                AppRoutePaths.tradeCopyProviderAssessment(providerId),
              ),
              child: const Text('Bắt đầu đánh giá trước khi sao chép'),
            ),
          ],
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
class PreCopyAssessmentTabletPage extends ConsumerStatefulWidget {
  const PreCopyAssessmentTabletPage({super.key, required this.providerId});

  static const contentKey = Key('sc071_tablet_content');

  final String providerId;

  @override
  ConsumerState<PreCopyAssessmentTabletPage> createState() =>
      _PreCopyAssessmentTabletPageState();
}

class _PreCopyAssessmentTabletPageState
    extends ConsumerState<PreCopyAssessmentTabletPage> {
  final Map<int, String> _answers = {};

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      tradePreCopyAssessmentProvider(widget.providerId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-071',
        semanticLabel: 'Đánh giá trước sao chép',
        title: 'Đánh giá trước khi sao chép',
        subtitle: widget.providerId,
        backFallback: AppRoutePaths.tradeCopyProvider(widget.providerId),
        contentKey: PreCopyAssessmentTabletPage.contentKey,
        children: [
          _flowError(
            'Không tải được đánh giá',
            () => ref.invalidate(
              tradePreCopyAssessmentProvider(widget.providerId),
            ),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-071',
        semanticLabel: 'Đánh giá trước sao chép',
        title: 'Đánh giá trước khi sao chép',
        subtitle: '${snapshot.questions.length} câu hỏi',
        backFallback: AppRoutePaths.tradeCopyProvider(widget.providerId),
        contentKey: PreCopyAssessmentTabletPage.contentKey,
        children: [
          for (
            var questionIndex = 0;
            questionIndex < snapshot.questions.length;
            questionIndex++
          )
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.cardPaddingCompact,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.questions[questionIndex].question,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(height: TabletSpacingTokens.x1),
                    Text(
                      snapshot.questions[questionIndex].description,
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
                        for (final option
                            in snapshot.questions[questionIndex].options)
                          VitFilterChip(
                            label: option.label,
                            onTap: () => setState(
                              () => _answers[questionIndex] = option.label,
                            ),
                            active: _answers[questionIndex] == option.label,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          VitCtaButton(
            onPressed: () => context.push(
              AppRoutePaths.tradeCopyProviderConfiguration(widget.providerId),
            ),
            child: const Text('Tiếp tục cấu hình'),
          ),
        ],
      ),
    );
  }
}
