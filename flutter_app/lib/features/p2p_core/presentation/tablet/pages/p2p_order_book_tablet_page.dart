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

/// Bố cục tablet của Sổ lệnh P2P (SC-273): chips tài sản + ticker + giá tốt
/// nhất + hai cột bid/ask cạnh nhau (khác phone xếp chồng), panel rủi ro.
class P2POrderBookTabletPage extends ConsumerStatefulWidget {
  const P2POrderBookTabletPage({super.key, this.initialAsset = 'USDT'});

  static const contentKey = Key('sc273_tablet_content');

  final String initialAsset;

  @override
  ConsumerState<P2POrderBookTabletPage> createState() =>
      _P2POrderBookTabletPageState();
}

class _P2POrderBookTabletPageState
    extends ConsumerState<P2POrderBookTabletPage> {
  late String _selectedAsset = widget.initialAsset;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pOrderBookProvider(_selectedAsset));
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Sổ lệnh P2P',
      semanticIdentifier: 'SC-273',
      child: Column(
        children: [
          VitHeader(
            title: 'Sổ lệnh P2P',
            subtitle: 'Thanh khoản · Bid/Ask',
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
                  title: 'Không tải được sổ lệnh',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(p2pOrderBookProvider(_selectedAsset)),
                ),
              ),
              data: (snapshot) => VitTabletSectionBody(
                children: [
                  Wrap(
                    spacing: TabletSpacingTokens.x3,
                    runSpacing: TabletSpacingTokens.x2,
                    children: [
                      for (final market in snapshot.markets)
                        VitFilterChip(
                          label: market.asset,
                          active: _selectedAsset == market.asset,
                          onTap: () => setState(() {
                            _selectedAsset = market.asset;
                          }),
                          color: AppColors.primary,
                        ),
                    ],
                  ),

                  _MarketTicker(market: snapshot.selectedAsset),

                  _BestPriceRow(snapshot: snapshot),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _BookSide(
                          title: 'Lệnh mua (Bid)',
                          entries: snapshot.bids,
                          color: AppColors.buy,
                        ),
                      ),
                      const SizedBox(width: TabletSpacingTokens.x4),
                      Expanded(
                        child: _BookSide(
                          title: 'Lệnh bán (Ask)',
                          entries: snapshot.asks,
                          color: AppColors.sell,
                        ),
                      ),
                    ],
                  ),

                  const VitHighRiskStatePanel(
                    state: VitHighRiskUiState.riskReview,
                    title: 'Xem lại thanh khoản sổ lệnh',
                    message:
                        'Tài sản, làm mới dữ liệu, biểu đồ độ sâu, giá bid/ask tốt nhất và rủi ro thanh khoản được xem lại trước khi khớp lệnh P2P.',
                    contractId: 'p2p-order-book-tablet-review',
                  ),

                  Text(
                    snapshot.contractNotes,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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

class _MarketTicker extends StatelessWidget {
  const _MarketTicker({required this.market});

  final P2POrderBookMarketDraft market;

  @override
  Widget build(BuildContext context) {
    final positive = market.changePct >= 0;
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
                  '${market.asset}/VND',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
                Text(
                  formatP2PVnd(market.lastPriceVnd),
                  style: AppTextStyles.control.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${positive ? '+' : ''}${market.changePct.toStringAsFixed(2)}%',
                style: AppTextStyles.caption.copyWith(
                  color: positive ? AppColors.buy : AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              Text(
                'KL ${market.volume24hLabel} · ${market.trades24h} lệnh',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestPriceRow extends StatelessWidget {
  const _BestPriceRow({required this.snapshot});

  final P2POrderBookSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BestPriceCell(
            label: 'Bid tốt nhất',
            value: formatP2PVnd(snapshot.bestBid.priceVnd),
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x3),
        Expanded(
          child: _BestPriceCell(
            label: 'Ask tốt nhất',
            value: formatP2PVnd(snapshot.bestAsk.priceVnd),
            color: AppColors.sell,
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x3),
        Expanded(
          child: _BestPriceCell(
            label: 'Spread',
            value: '${snapshot.spreadPercent.toStringAsFixed(2)}%',
            color: AppColors.text2,
          ),
        ),
      ],
    );
  }
}

class _BestPriceCell extends StatelessWidget {
  const _BestPriceCell({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
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
      ),
    );
  }
}

class _BookSide extends StatelessWidget {
  const _BookSide({
    required this.title,
    required this.entries,
    required this.color,
  });

  final String title;
  final List<P2POrderBookEntryDraft> entries;
  final Color color;

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
            padding: TabletSpacingTokens.tableCellPadding,
            child: Text(
              title,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                color: color,
              ),
            ),
          ),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            thickness: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          for (final entry in entries.take(10))
            Padding(
              padding: TabletSpacingTokens.tableCellPadding,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      formatP2PVnd(entry.priceVnd),
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      formatP2PCrypto(entry.volume),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${entry.orders} lệnh',
                      textAlign: TextAlign.end,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
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
