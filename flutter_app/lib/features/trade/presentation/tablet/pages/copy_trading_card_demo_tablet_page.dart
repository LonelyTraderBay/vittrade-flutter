import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của bản demo thẻ sao chép (SC-401, màn review nội bộ):
/// cột chính là các biến thể thẻ + ma trận so sánh compliance, cột phụ là
/// metrics + khuyến nghị + guidelines.
class CopyTradingCardDemoTabletPage extends ConsumerStatefulWidget {
  const CopyTradingCardDemoTabletPage({super.key});

  static const contentKey = Key('sc401_tablet_content');
  static const matrixKey = Key('sc401_tablet_matrix');

  static Key variantKey(String id) => Key('sc401_tablet_variant_$id');

  @override
  ConsumerState<CopyTradingCardDemoTabletPage> createState() =>
      _CopyTradingCardDemoTabletPageState();
}

class _CopyTradingCardDemoTabletPageState
    extends ConsumerState<CopyTradingCardDemoTabletPage> {
  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeCopyCardDemoProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Phân tích thẻ sao chép giao dịch (bản demo nội bộ)',
      semanticIdentifier: 'SC-401',
      child: Column(
        children: [
          VitHeader(
            title: 'Phân tích thẻ sao chép',
            subtitle: 'Demo nội bộ · compliance',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.tradeCopyTrading,
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
                  title: 'Không tải được dữ liệu demo',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(tradeCopyCardDemoProvider),
                ),
              ),
              data: (snapshot) => VitTwoColumnTabletDashboard(
                onRefresh: () async {
                  ref.invalidate(tradeCopyCardDemoProvider);
                  await ref.read(tradeCopyCardDemoProvider.future);
                },
                primaryChildren: [
                  for (final variant in snapshot.variants)
                    _VariantCard(
                      key: CopyTradingCardDemoTabletPage.variantKey(variant.id),
                      variant: variant,
                    ),
                  _ComparisonMatrixCard(
                    key: CopyTradingCardDemoTabletPage.matrixKey,
                    issues: snapshot.issues,
                  ),
                ],
                secondaryChildren: [
                  _MetricsCard(metrics: snapshot.metrics),
                  _TextBlocksCard(
                    title: 'Vấn đề bản gốc',
                    blocks: snapshot.originalIssues,
                  ),
                  _CopyDemoRecommendationCard(
                    recommendation: snapshot.recommendation,
                    reasons: snapshot.recommendationReasons,
                  ),
                  _TextBlocksCard(
                    title: 'Guidelines',
                    blocks: snapshot.guidelines,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantCard extends StatelessWidget {
  const _VariantCard({super.key, required this.variant});

  final TradeCopyCardVariantDraft variant;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  variant.title,
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              if (variant.badge != null)
                VitStatusPill(
                  label: variant.badge!,
                  status: VitStatusPillStatus.purple,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Text(
            variant.notesTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          for (final note in variant.notes)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x1,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '· ',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  Expanded(
                    child: Text(
                      note,
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
    );
  }
}

class _ComparisonMatrixCard extends StatelessWidget {
  const _ComparisonMatrixCard({super.key, required this.issues});

  final List<TradeCopyCardIssue> issues;

  static VitStatusPillStatus _status(TradeCopyCardCompliance compliance) =>
      switch (compliance) {
        TradeCopyCardCompliance.pass => VitStatusPillStatus.success,
        TradeCopyCardCompliance.warn => VitStatusPillStatus.warning,
        TradeCopyCardCompliance.fail => VitStatusPillStatus.error,
      };

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(TabletSpacingTokens.x4),
            child: Text(
              'Ma trận so sánh compliance',
              style: AppTextStyles.control.copyWith(
                fontWeight: AppTextStyles.bold,
                color: AppColors.text1,
              ),
            ),
          ),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TabletSpacingTokens.x4,
              vertical: TabletSpacingTokens.x2,
            ),
            child: Row(
              children: [
                const Expanded(flex: 3, child: SizedBox.shrink()),
                for (final header in ['Gốc', 'A', 'B', 'C'])
                  Expanded(
                    flex: 2,
                    child: Text(
                      header,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          for (final issue in issues)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TabletSpacingTokens.x4,
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      issue.category,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  for (final compliance in [
                    issue.original,
                    issue.variantA,
                    issue.variantB,
                    issue.variantC,
                  ])
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: VitStatusPill(
                          label: compliance.name.toUpperCase(),
                          status: _ComparisonMatrixCard._status(compliance),
                          size: VitStatusPillSize.sm,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _MetricsCard extends StatelessWidget {
  const _MetricsCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, value) in [
            ('Trader', formatTradeInt(metrics.traders)),
            ('Copier', formatTradeInt(metrics.copiers)),
            ('AUM', formatTradeUsdWhole(metrics.aumUsd.toDouble())),
            (
              'Xu hướng AUM',
              '${metrics.aumTrendPercent >= 0 ? '+' : ''}${metrics.aumTrendPercent.toStringAsFixed(1)}%',
            ),
            ('Cập nhật', metrics.lastUpdated),
          ])
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: TabletSpacingTokens.x2,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TextBlocksCard extends StatelessWidget {
  const _TextBlocksCard({required this.title, required this.blocks});

  final String title;
  final List<TradeCopyCardTextBlock> blocks;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
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
          for (final block in blocks) ...[
            Text(
              block.title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x1),
            Text(
              block.body,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.3,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x2),
          ],
        ],
      ),
    );
  }
}

class _CopyDemoRecommendationCard extends StatelessWidget {
  const _CopyDemoRecommendationCard({
    required this.recommendation,
    required this.reasons,
  });

  final String recommendation;
  final List<String> reasons;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsets.all(TabletSpacingTokens.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Khuyến nghị',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Text(
            recommendation,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.3,
            ),
          ),
          if (reasons.isNotEmpty) ...[
            const SizedBox(height: TabletSpacingTokens.x2),
            for (final reason in reasons)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: TabletSpacingTokens.x1,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '· ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        reason,
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
        ],
      ),
    );
  }
}
