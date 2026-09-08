import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của P2P Marketplace (SC-282): banner thống kê nền tảng +
/// bảng offer độ dày tablet (merchant · giá · hạn mức · thanh toán) ở cột
/// chính, quick actions + KYC/disclaimer ở cột phụ.
class P2PHomeTabletPage extends ConsumerStatefulWidget {
  const P2PHomeTabletPage({super.key});

  static const contentKey = Key('sc282_tablet_content');

  @override
  ConsumerState<P2PHomeTabletPage> createState() => _P2PHomeTabletPageState();
}

class _P2PHomeTabletPageState extends ConsumerState<P2PHomeTabletPage> {
  P2PTradeType _tradeType = P2PTradeType.buy;
  final String _fiat = 'VND';
  String? _asset;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tradeType = P2PTradeType.buy;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(
      p2pHomeProvider((
        tradeType: _tradeType,
        asset: _asset ?? '',
        fiat: _fiat,
      )),
    );
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chợ P2P',
      semanticIdentifier: 'SC-282',
      child: Column(
        children: [
          VitHeader(
            title: 'P2P Marketplace',
            subtitle: 'Mua bán · quảng cáo · an toàn',
            showBack: showBack,
            onBack: showBack ? () => context.go(AppRoutePaths.home) : null,
          ),
          Expanded(
            child: homeAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được P2P Marketplace',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(
                    p2pHomeProvider((
                      tradeType: _tradeType,
                      asset: _asset ?? '',
                      fiat: _fiat,
                    )),
                  ),
                ),
              ),
              data: (snapshot) {
                final asset = _asset ?? snapshot.selectedAsset;
                final visibleAds = [
                  for (final ad in snapshot.ads)
                    if (ad.type == _tradeType)
                      if (asset == 'Tất cả' || ad.asset == asset)
                        if (_searchController.text.isEmpty ||
                            ad.merchant.toLowerCase().contains(
                              _searchController.text.toLowerCase(),
                            ))
                          ad,
                ];
                return VitTwoColumnTabletDashboard(
                  onRefresh: () async {
                    ref.invalidate(
                      p2pHomeProvider((
                        tradeType: _tradeType,
                        asset: _asset ?? '',
                        fiat: _fiat,
                      )),
                    );
                    await ref.read(
                      p2pHomeProvider((
                        tradeType: _tradeType,
                        asset: _asset ?? '',
                        fiat: _fiat,
                      )).future,
                    );
                  },
                  banner: _PlatformStatsStrip(
                    stats: snapshot.platformStats,
                    expressRoute: snapshot.expressRoute,
                  ),
                  primaryChildren: [
                    VitCard(
                      key: P2PHomeTabletPage.contentKey,
                      variant: VitCardVariant.inner,
                      radius: VitCardRadius.tight,
                      padding: TabletSpacingTokens.cardPaddingCompact,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VitSegmentedTabBar(
                            tabs: const [
                              VitTabItem(key: 'buy', label: 'Mua'),
                              VitTabItem(key: 'sell', label: 'Bán'),
                            ],
                            activeKey: _tradeType == P2PTradeType.buy
                                ? 'buy'
                                : 'sell',
                            onChanged: (value) => setState(() {
                              _tradeType = value == 'buy'
                                  ? P2PTradeType.buy
                                  : P2PTradeType.sell;
                            }),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x3),
                          Wrap(
                            spacing: TabletSpacingTokens.x3,
                            runSpacing: TabletSpacingTokens.x2,
                            children: [
                              for (final item in ['Tất cả', ...snapshot.assets])
                                VitFilterChip(
                                  label: item,
                                  active: asset == item,
                                  onTap: () => setState(() {
                                    _asset = item == 'Tất cả' ? null : item;
                                  }),
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _OffersTable(ads: visibleAds, tradeType: _tradeType),
                  ],
                  secondaryChildren: [
                    for (final action in snapshot.quickActions)
                      VitCard(
                        radius: VitCardRadius.tight,
                        padding: TabletSpacingTokens.cardPaddingCompact,
                        child: _QuickActionRow(action: action),
                      ),
                    VitCard(
                      radius: VitCardRadius.tight,
                      padding: TabletSpacingTokens.cardPaddingCompact,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.title,
                            style: AppTextStyles.control.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x1),
                          Text(
                            snapshot.subtitle,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                          const SizedBox(height: TabletSpacingTokens.x2),
                          const VitStatusPill(
                            label: 'Giao dịch qua ký quỹ an toàn',
                            status: VitStatusPillStatus.info,
                            size: VitStatusPillSize.sm,
                          ),
                        ],
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

class _PlatformStatsStrip extends StatelessWidget {
  const _PlatformStatsStrip({required this.stats, required this.expressRoute});

  final P2PHomePlatformStatsDraft stats;
  final String expressRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khối lượng 24h',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  formatP2PVnd(stats.volume24h),
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          for (final action in [
            (AppRoutePaths.p2pExpress, 'P2P Express'),
            (AppRoutePaths.p2pCreate, 'Tạo quảng cáo'),
            (AppRoutePaths.p2pMyOrders, 'Đơn của tôi'),
          ]) ...[
            const SizedBox(width: TabletSpacingTokens.x3),
            VitCtaButton(
              fullWidth: false,
              variant: VitCtaButtonVariant.secondary,
              onPressed: () => context.go(action.$1),
              child: Text(action.$2),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({required this.action});

  final P2PHomeQuickActionDraft action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                action.title,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: AppTextStyles.bold,
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x1),
              Text(
                action.subtitle,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.chevron_right_rounded,
          size: TabletSpacingTokens.iconMd,
          color: AppColors.text3,
        ),
      ],
    );
  }
}

class _OffersTable extends StatelessWidget {
  const _OffersTable({required this.ads, required this.tradeType});

  final List<P2PAdDraft> ads;
  final P2PTradeType tradeType;

  @override
  Widget build(BuildContext context) {
    if (ads.isEmpty) {
      return const VitEmptyState(
        icon: Icons.storefront_outlined,
        title: 'Không có quảng cáo phù hợp',
        message: 'Thử đổi loại giao dịch hoặc tài sản.',
      );
    }
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < ads.length; i++) ...[
            _OfferRow(ad: ads[i], tradeType: tradeType),
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

class _OfferRow extends StatelessWidget {
  const _OfferRow({required this.ad, required this.tradeType});

  final P2PAdDraft ad;
  final P2PTradeType tradeType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingTall,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: ad.merchant,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                    children: [
                      if (ad.merchantVerified)
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
                  '${ad.completedOrders} đơn · '
                  '${ad.completionRate.toStringAsFixed(1)}% hoàn tất',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatP2PVnd(ad.price),
              style: AppTextStyles.control.copyWith(
                fontWeight: AppTextStyles.bold,
                color: AppColors.text1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${formatP2PVnd(ad.minLimit)} - '
              '${formatP2PVnd(ad.maxLimit)}',
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          VitCtaButton(
            fullWidth: false,
            variant: tradeType == P2PTradeType.buy
                ? VitCtaButtonVariant.success
                : VitCtaButtonVariant.danger,
            onPressed: () => context.go('${AppRoutePaths.p2p}/ad/${ad.id}'),
            child: Text(tradeType == P2PTradeType.buy ? 'Mua' : 'Bán'),
          ),
        ],
      ),
    );
  }
}
