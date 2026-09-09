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
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';
part 'p2p_merchant_tablet_pages_sections.dart';

/// Bố cục tablet của Hồ sơ merchant (SC-228): banner danh tính + thống kê,
/// cột chính là bảng quảng cáo + đánh giá, cột phụ là hành động (báo cáo /
/// blacklist) + chỉ số.
class P2PMerchantProfileTabletPage extends ConsumerWidget {
  const P2PMerchantProfileTabletPage({super.key, required this.merchantId});

  static const contentKey = Key('sc228_tablet_content');

  final String merchantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pMerchantProfileProvider(merchantId));
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hồ sơ merchant P2P',
      semanticIdentifier: 'SC-228',
      child: Column(
        children: [
          VitHeader(
            title: 'Hồ sơ merchant',
            subtitle: 'Uy tín · Quảng cáo · Đánh giá',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2p,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được hồ sơ merchant',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(p2pMerchantProfileProvider(merchantId)),
                ),
              ),
              data: (snapshot) {
                final merchant = snapshot.merchant;
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(p2pMerchantProfileProvider(merchantId));
                    await ref.read(
                      p2pMerchantProfileProvider(merchantId).future,
                    );
                  },
                  banner: VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: merchant.name,
                                  style: AppTextStyles.control.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                    color: AppColors.text1,
                                  ),
                                  children: [
                                    if (merchant.kycVerified)
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.verified_rounded,
                                          size: TabletSpacingTokens.iconSm,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Level ${merchant.level} · Tham gia ${merchant.joinDate}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _MerchantStatCell(
                            label: 'Giao dịch',
                            value: '${merchant.totalTrades}',
                          ),
                        ),
                        Expanded(
                          child: _MerchantStatCell(
                            label: 'Hoàn tất',
                            value:
                                '${merchant.completionRate.toStringAsFixed(1)}%',
                            color: AppColors.buy,
                          ),
                        ),
                        Expanded(
                          child: _MerchantStatCell(
                            label: 'Tích cực',
                            value:
                                '${merchant.positiveRate.toStringAsFixed(1)}%',
                          ),
                        ),
                      ],
                    ),
                  ),
                  primaryChildren: [
                    _AdsTable(
                      ads: snapshot.ads,
                      emptyTitle: snapshot.emptyAdsTitle,
                    ),
                    _ReviewsCard(
                      reviews: snapshot.reviews,
                      emptyTitle: snapshot.emptyReviewsTitle,
                    ),
                  ],
                  secondaryChildren: [
                    VitCard(
                      radius: VitCardRadius.tight,
                      padding: TabletSpacingTokens.cardPaddingCompact,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          VitCtaButton(
                            fullWidth: false,
                            variant: VitCtaButtonVariant.secondary,
                            onPressed: () => context.push(snapshot.reportRoute),
                            child: const Text('Báo cáo merchant'),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x2),
                          VitCtaButton(
                            fullWidth: false,
                            variant: VitCtaButtonVariant.danger,
                            onPressed: () =>
                                context.push(snapshot.blacklistAddRoute),
                            child: const Text('Chặn merchant'),
                          ),
                        ],
                      ),
                    ),
                    _MerchantMetricsCard(merchant: merchant),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MerchantStatCell extends StatelessWidget {
  const _MerchantStatCell({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
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
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _MerchantMetricsCard extends StatelessWidget {
  const _MerchantMetricsCard({required this.merchant});

  final P2PMerchantProfileDraft merchant;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (label, value) in [
            ('Giao dịch 30 ngày', '${merchant.totalTrades30d}'),
            ('Khối lượng 30 ngày', formatP2PVnd(merchant.totalVolume30dUsd)),
            ('Thời gian giải tỏa TB', merchant.avgReleaseTime),
            ('Thời gian thanh toán TB', merchant.avgPayTime),
            ('Phản hồi tiêu cực', '${merchant.negativeCount}'),
            ('Quảng cáo đang chạy', '${merchant.activeAds}'),
          ])
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
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

class _AdsTable extends StatelessWidget {
  const _AdsTable({required this.ads, required this.emptyTitle});

  final List<P2PMerchantProfileAdDraft> ads;
  final String emptyTitle;

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) {
      return VitEmptyState(
        icon: Icons.storefront_outlined,
        title: emptyTitle,
        message: 'Merchant chưa đăng quảng cáo nào đang chạy.',
      );
    }
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < ads.length; i++) ...[
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingTall,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      ads[i].type == P2PTradeType.buy
                          ? 'MUA ${ads[i].asset}'
                          : 'BÁN ${ads[i].asset}',
                      style: AppTextStyles.caption.copyWith(
                        color: ads[i].type == P2PTradeType.buy
                            ? AppColors.buy
                            : AppColors.sell,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      formatP2PVnd(ads[i].price),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '${formatP2PCrypto(ads[i].available)} khả dụng',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      ads[i].paymentMethods.join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < ads.length - 1)
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                thickness: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _ReviewsCard extends StatelessWidget {
  const _ReviewsCard({required this.reviews, required this.emptyTitle});

  final List<P2PMerchantProfileReviewDraft> reviews;
  final String emptyTitle;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return VitEmptyState(
        icon: Icons.rate_review_outlined,
        title: emptyTitle,
        message: 'Chưa có đánh giá nào cho merchant này.',
      );
    }
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Đánh giá gần đây',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final review in reviews.take(6))
            Padding(
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
                  const SizedBox(height: TabletSpacingTokens.x2),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Đăng ký làm merchant (SC-227): stats + điều kiện + hồ sơ tài liệu + CTA.
