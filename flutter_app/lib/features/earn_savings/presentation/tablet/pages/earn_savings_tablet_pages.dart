import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part 'earn_savings_tablet_pages_tools.dart';
part 'earn_savings_tablet_pages_alerts.dart';
part 'earn_savings_tablet_pages_plans.dart';
part 'earn_savings_tablet_pages_more.dart';

Widget _esvFrame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required Widget child,
  Key? contentKey,
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
                  fallbackPath: AppRoutePaths.earnSavings,
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

Widget _esvError(String title, VoidCallback onRetry) {
  return VitErrorState(
    title: title,
    message: 'Vui lòng kiểm tra kết nối và thử lại.',
    actionLabel: 'Thử lại',
    onAction: onRetry,
  );
}

Widget _esvSection({required String title, required List<Widget> rows}) {
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

List<Widget> _esvRows(List<(String, String)> pairs) {
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

List<Widget> _esvBullets(List<String> notes) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: VitBulletRow(text: note),
      ),
  ];
}

Widget _esvBody(String text) {
  return Text(
    text,
    style: AppTextStyles.caption.copyWith(color: AppColors.text2, height: 1.3),
  );
}

/// SC-296: Hub tiết kiệm Earn.
class SavingsHubTabletPage extends ConsumerWidget {
  const SavingsHubTabletPage({super.key});

  static const contentKey = Key('sc296_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-296',
        semanticLabel: 'Tiết kiệm Earn',
        title: snapshotAsync.value?.title ?? 'Tiết kiệm',
        subtitle: 'Tích lũy linh hoạt',
        contentKey: SavingsHubTabletPage.contentKey,
        child: _esvError(
          'Không tải được tiết kiệm',
          () => ref.invalidate(savingsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-296',
        semanticLabel: 'Tiết kiệm Earn',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: SavingsHubTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _esvSection(
              title: 'Tổng quan',
              rows: _esvRows([
                ('Tổng đã gửi', snapshot.totalDepositedUsd),
                ('Lợi nhuận', snapshot.gainLabel),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            for (final insight in snapshot.insights) ...[
              _esvSection(
                title: insight.title,
                rows: [_esvBody(insight.subtitle)],
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
          ],
        ),
      ),
    );
  }
}

/// SC-297: Danh mục tiết kiệm.
class SavingsPortfolioTabletPage extends ConsumerWidget {
  const SavingsPortfolioTabletPage({super.key});

  static const contentKey = Key('sc297_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsPortfolioSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-297',
        semanticLabel: 'Danh mục tiết kiệm',
        title: 'Danh mục tiết kiệm',
        subtitle: 'Vị thế · Phân bổ',
        contentKey: SavingsPortfolioTabletPage.contentKey,
        child: _esvError(
          'Không tải được danh mục',
          () => ref.invalidate(savingsPortfolioSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-297',
        semanticLabel: 'Danh mục tiết kiệm',
        title: snapshot.title,
        subtitle: '${snapshot.activePositions} vị thế đang chạy',
        contentKey: SavingsPortfolioTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _esvSection(
              title: 'Tổng quan',
              rows: _esvRows([
                ('Tổng đã gửi', snapshot.totalDepositedUsd),
                ('Lợi nhuận', snapshot.gainLabel),
                ('APY bình quân', snapshot.weightedApy),
                ('Linh hoạt', snapshot.flexibleTotalUsd),
                ('Khoá kỳ hạn', snapshot.lockedTotalUsd),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-298: Lịch sử tiết kiệm.
class SavingsHistoryTabletPage extends ConsumerWidget {
  const SavingsHistoryTabletPage({super.key});

  static const contentKey = Key('sc298_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsHistorySnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-298',
        semanticLabel: 'Lịch sử tiết kiệm',
        title: 'Lịch sử tiết kiệm',
        subtitle: 'Gửi · Lãi · Rút',
        contentKey: SavingsHistoryTabletPage.contentKey,
        child: _esvError(
          'Không tải được lịch sử',
          () => ref.invalidate(savingsHistorySnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-298',
        semanticLabel: 'Lịch sử tiết kiệm',
        title: snapshot.title,
        subtitle: '${snapshot.transactions.length} giao dịch',
        contentKey: SavingsHistoryTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _esvSection(
              title: 'Tổng hợp',
              rows: _esvRows([
                ('Tổng đã gửi', snapshot.totalSubscribed),
                ('Tổng lãi', snapshot.totalInterest),
                ('Tổng đã rút', snapshot.totalRedeemed),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Giao dịch',
              rows: [
                for (final tx in snapshot.transactions.take(12))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${tx.type.name} · ${tx.product}',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${tx.asset} ${tx.amount} (${tx.usdValue}) · ${tx.date} ${tx.time}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          tx.status.name,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
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

/// SC-299: Hướng dẫn tiết kiệm.
class SavingsGuideTabletPage extends ConsumerWidget {
  const SavingsGuideTabletPage({super.key});

  static const contentKey = Key('sc299_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsGuideSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-299',
        semanticLabel: 'Hướng dẫn tiết kiệm',
        title: 'Hướng dẫn',
        subtitle: 'Bài học · Mẹo',
        contentKey: SavingsGuideTabletPage.contentKey,
        child: _esvError(
          'Không tải được hướng dẫn',
          () => ref.invalidate(savingsGuideSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-299',
        semanticLabel: 'Hướng dẫn tiết kiệm',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroSubtitle,
        contentKey: SavingsGuideTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final tutorial in snapshot.tutorials) ...[
              _esvSection(
                title: '${tutorial.title} (${tutorial.duration})',
                rows: [
                  _esvBody(tutorial.description),
                  ..._esvBullets([
                    for (final step in tutorial.steps) step.title,
                  ]),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
            _esvSection(
              title: 'Mẹo nhanh',
              rows: [
                for (final tip in snapshot.quickTips)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tip.title,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          tip.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Thuật ngữ',
              rows: _esvRows([
                for (final term in snapshot.terms) (term.term, term.definition),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-300: Hỏi đáp tiết kiệm.
class SavingsFaqTabletPage extends ConsumerWidget {
  const SavingsFaqTabletPage({super.key});

  static const contentKey = Key('sc300_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsFAQSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-300',
        semanticLabel: 'Hỏi đáp tiết kiệm',
        title: 'Hỏi đáp',
        subtitle: 'Theo chủ đề',
        contentKey: SavingsFaqTabletPage.contentKey,
        child: _esvError(
          'Không tải được hỏi đáp',
          () => ref.invalidate(savingsFAQSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-300',
        semanticLabel: 'Hỏi đáp tiết kiệm',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroSubtitle,
        contentKey: SavingsFaqTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final category in snapshot.categories) ...[
              _esvSection(
                title: category.label,
                rows: [
                  for (final item in snapshot.items.where(
                    (item) => item.category.name == category.id,
                  ))
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.question,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                            ),
                          ),
                          Text(
                            item.answer,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
            _esvSection(
              title: snapshot.supportTitle,
              rows: [_esvBody(snapshot.supportSubtitle)],
            ),
          ],
        ),
      ),
    );
  }
}
