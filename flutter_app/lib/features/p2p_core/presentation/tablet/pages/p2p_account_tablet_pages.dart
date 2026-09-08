import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
part 'p2p_account_tablet_pages_extra.dart';

Widget _accFrame({
  required BuildContext context,
  required String semanticIdentifier,
  required String semanticLabel,
  required String title,
  required String subtitle,
  required Widget child,
  Key? contentKey,
  String backFallback = AppRoutePaths.p2p,
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

Widget _accSection({required String title, required List<Widget> rows}) {
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

List<Widget> _accRows(List<(String, String)> pairs) {
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

List<Widget> _accBullets(List<String> notes, IconData icon, Color color) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: Icon(icon, size: TabletSpacingTokens.iconSm, color: color),
            ),
            const SizedBox(width: TabletSpacingTokens.x2),
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
  ];
}

/// SC-231: Đánh giá P2P (nhận + đã gửi).
class P2PReviewsTabletPage extends ConsumerWidget {
  const P2PReviewsTabletPage({super.key});

  static const contentKey = Key('sc231_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pReviewsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-231',
        semanticLabel: 'Đánh giá P2P',
        title: 'Đánh giá',
        subtitle: 'Nhận · Đã gửi',
        contentKey: P2PReviewsTabletPage.contentKey,
        child: VitErrorState(
          title: 'Không tải được đánh giá',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(p2pReviewsProvider),
        ),
      ),
      data: (snapshot) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-231',
        semanticLabel: 'Đánh giá P2P',
        title: 'Đánh giá',
        subtitle: 'Nhận · Đã gửi',
        contentKey: P2PReviewsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _accSection(
              title: 'Đánh giá nhận được',
              rows: [
                if (snapshot.receivedReviews.isEmpty)
                  Text(
                    snapshot.emptyTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  )
                else
                  for (final review in snapshot.receivedReviews.take(8))
                    _ReviewTile(review: review),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _accSection(
              title: 'Đánh giá đã gửi',
              rows: [
                if (snapshot.givenReviews.isEmpty)
                  Text(
                    snapshot.emptyTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  )
                else
                  for (final review in snapshot.givenReviews.take(8))
                    _ReviewTile(review: review),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final P2PReviewDraft review;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.fromUser,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              for (var i = 0; i < 5; i++)
                Icon(
                  i < review.rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: TabletSpacingTokens.iconSm,
                  color: AppColors.caution,
                ),
            ],
          ),
          Text(
            review.comment,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// SC-242: Lịch sử đóng góp quỹ bảo hiểm.
class P2PContributionHistoryTabletPage extends ConsumerWidget {
  const P2PContributionHistoryTabletPage({super.key});

  static const contentKey = Key('sc242_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pContributionHistoryProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-242',
        semanticLabel: 'Lịch sử đóng góp P2P',
        title: 'Lịch sử đóng góp',
        subtitle: 'Quỹ bảo hiểm',
        contentKey: P2PContributionHistoryTabletPage.contentKey,
        child: VitErrorState(
          title: 'Không tải được lịch sử đóng góp',
          message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(p2pContributionHistoryProvider),
        ),
      ),
      data: (snapshot) => _accFrame(
        context: context,
        semanticIdentifier: 'SC-242',
        semanticLabel: 'Lịch sử đóng góp P2P',
        title: 'Lịch sử đóng góp',
        subtitle: snapshot.contributionRateLabel,
        contentKey: P2PContributionHistoryTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.contributions.isEmpty)
              VitEmptyState(
                icon: Icons.savings_outlined,
                title: snapshot.emptyTitle,
                message: snapshot.contributionRateLabel,
              )
            else
              VitCard(
                radius: VitCardRadius.tight,
                padding: TabletSpacingTokens.zeroInsets,
                clip: true,
                child: Column(
                  children: [
                    for (var i = 0; i < snapshot.contributions.length; i++) ...[
                      Padding(
                        padding: TabletSpacingTokens.tableCellPadding,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                snapshot.contributions[i].date,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text3,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                snapshot.contributions[i].orderId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                formatP2PVnd(
                                  snapshot.contributions[i].orderAmount,
                                ),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                formatP2PVnd(
                                  snapshot.contributions[i].contributionAmount,
                                ),
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
                      if (i < snapshot.contributions.length - 1)
                        const Divider(
                          height: TabletSpacingTokens.dividerHairline,
                          thickness: TabletSpacingTokens.dividerHairline,
                          color: AppColors.divider,
                        ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: TabletSpacingTokens.x3),
            Text(
              snapshot.contractNotes,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-277: Blacklist P2P.
