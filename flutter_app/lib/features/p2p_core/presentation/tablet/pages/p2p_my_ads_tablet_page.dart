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

/// Bố cục tablet của Quảng cáo của tôi (SC-225): bảng quảng cáo độ dày tablet
/// (cặp · giá · khả dụng · thanh toán · trạng thái) + quick links.
class P2PMyAdsTabletPage extends ConsumerWidget {
  const P2PMyAdsTabletPage({super.key});

  static const contentKey = Key('sc225_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAdsAsync = ref.watch(p2pMyAdsProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Quảng cáo của tôi',
      semanticIdentifier: 'SC-225',
      child: Column(
        children: [
          VitHeader(
            title: 'Quảng cáo của tôi',
            subtitle: 'Sạp hàng · Trạng thái',
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
            child: myAdsAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được quảng cáo',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(p2pMyAdsProvider),
                ),
              ),
              data: (snapshot) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: SingleChildScrollView(
                    key: P2PMyAdsTabletPage.contentKey,
                    padding: const EdgeInsets.fromLTRB(
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x4,
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                snapshot.ads.isEmpty
                                    ? snapshot.emptyTitle
                                    : '${snapshot.ads.length} quảng cáo đang quản lý',
                                style: AppTextStyles.control.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                            ),
                            VitCtaButton(
                              fullWidth: false,
                              onPressed: () =>
                                  context.go(AppRoutePaths.p2pCreate),
                              child: const Text('Tạo quảng cáo'),
                            ),
                          ],
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        if (snapshot.ads.isEmpty)
                          VitEmptyState(
                            icon: Icons.storefront_outlined,
                            title: snapshot.emptyTitle,
                            message: snapshot.emptyActionLabel,
                            actionLabel: 'Tạo quảng cáo đầu tiên',
                            onAction: () => context.go(AppRoutePaths.p2pCreate),
                          )
                        else
                          VitCard(
                            radius: VitCardRadius.tight,
                            padding: TabletSpacingTokens.zeroInsets,
                            clip: true,
                            child: Column(
                              children: [
                                for (var i = 0; i < snapshot.ads.length; i++)
                                  _MyAdRow(ad: snapshot.ads[i]),
                              ],
                            ),
                          ),
                        if (snapshot.quickLinks.isNotEmpty) ...[
                          const SizedBox(height: TabletSpacingTokens.x3),
                          Wrap(
                            spacing: TabletSpacingTokens.x3,
                            runSpacing: TabletSpacingTokens.x2,
                            children: [
                              for (final link in snapshot.quickLinks)
                                VitFilterChip(
                                  label: link.title,
                                  onTap: () => context.go(link.route),
                                  active: false,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ],
                        const SizedBox(height: TabletSpacingTokens.x3),
                        Text(
                          snapshot.contractNotes,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyAdRow extends StatelessWidget {
  const _MyAdRow({required this.ad});

  final P2PMyAdDraft ad;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingTall,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text.rich(
              TextSpan(
                text: ad.type == P2PTradeType.buy ? 'MUA ' : 'BÁN ',
                style: AppTextStyles.caption.copyWith(
                  color: ad.type == P2PTradeType.buy
                      ? AppColors.buy
                      : AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
                children: [
                  TextSpan(
                    text: ad.asset,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatP2PVnd(ad.price),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Khả dụng ${ad.available}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              ad.paymentMethods.join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          SizedBox(
            width: TabletSpacingTokens.x7,
            child: VitStatusPill(
              label: switch (ad.status) {
                P2PMyAdStatus.active => 'Đang chạy',
                P2PMyAdStatus.paused => 'Tạm dừng',
                P2PMyAdStatus.expired => 'Hết hạn',
              },
              status: ad.status == P2PMyAdStatus.active
                  ? VitStatusPillStatus.success
                  : ad.status == P2PMyAdStatus.paused
                  ? VitStatusPillStatus.warning
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
            ),
          ),
        ],
      ),
    );
  }
}
