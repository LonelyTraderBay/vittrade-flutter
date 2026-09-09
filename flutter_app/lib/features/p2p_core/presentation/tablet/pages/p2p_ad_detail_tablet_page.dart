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
import 'package:vit_trade_flutter/shared/layout/vit_tablet_section_frame.dart';

/// Bố cục tablet của Chi tiết quảng cáo (SC-224): thông tin offer + độ tin
/// cậy + bảng tham số giao dịch, CTA giao dịch theo hướng quảng cáo.
class P2PAdDetailTabletPage extends ConsumerWidget {
  const P2PAdDetailTabletPage({super.key, required this.adId});

  static const contentKey = Key('sc224_tablet_content');

  final String adId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(p2pAdDetailProvider(adId));
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết quảng cáo P2P',
      semanticIdentifier: 'SC-224',
      child: Column(
        children: [
          VitHeader(
            title: 'Chi tiết quảng cáo',
            subtitle: 'Offer · Độ tin cậy',
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
            child: detailAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được chi tiết quảng cáo',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(p2pAdDetailProvider(adId)),
                ),
              ),
              data: (snapshot) {
                final ad = snapshot.ad;
                return VitTabletSectionBody(
                  contentKey: P2PAdDetailTabletPage.contentKey,
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
                                  ad.type == P2PTradeType.buy
                                      ? 'BÁN ${ad.asset}'
                                      : 'MUA ${ad.asset}',
                                  style: AppTextStyles.control.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                    color: ad.type == P2PTradeType.buy
                                        ? AppColors.sell
                                        : AppColors.buy,
                                  ),
                                ),
                                const SizedBox(height: TabletSpacingTokens.x1),
                                Text(
                                  '${ad.merchant} · ${ad.completedOrders} đơn · '
                                  '${ad.completionRate.toStringAsFixed(1)}% hoàn tất',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatP2PVnd(ad.price),
                                style: AppTextStyles.control.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                              Text(
                                '${snapshot.priceDiffPct >= 0 ? '+' : ''}'
                                '${snapshot.priceDiffPct.toStringAsFixed(2)}% thị trường',
                                style: AppTextStyles.micro.copyWith(
                                  color: snapshot.priceDiffPct >= 0
                                      ? AppColors.sell
                                      : AppColors.buy,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ],
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
                          for (final (label, value) in [
                            (
                              'Hạn mức',
                              '${formatP2PVnd(ad.minLimit)} - ${formatP2PVnd(ad.maxLimit)}',
                            ),
                            ('Phương thức', ad.paymentMethods.join(' · ')),
                            (
                              'Độ tin cậy',
                              '${snapshot.trustScore} (${snapshot.trustLabel})',
                            ),
                            ('Đang xem', '${snapshot.viewerCount} người'),
                            (
                              'Khối lượng 30 ngày',
                              formatP2PVnd(snapshot.totalVolume30dUsd),
                            ),
                            ('Giờ giao dịch', snapshot.tradingHours),
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
                                      fontFeatures:
                                          AppTextStyles.tabularFigures,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),

                    if (snapshot.remarks.isNotEmpty)
                      VitCard(
                        radius: VitCardRadius.tight,
                        padding: TabletSpacingTokens.cardPaddingCompact,
                        child: Text(
                          snapshot.remarks,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ),

                    const SizedBox(height: TabletSpacingTokens.x4),

                    VitCtaButton(
                      variant: ad.type == P2PTradeType.buy
                          ? VitCtaButtonVariant.success
                          : VitCtaButtonVariant.danger,
                      onPressed: () => context.push(AppRoutePaths.p2pExpress),
                      child: Text(
                        ad.type == P2PTradeType.buy
                            ? 'Mua nhanh ${ad.asset}'
                            : 'Bán nhanh ${ad.asset}',
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
}
