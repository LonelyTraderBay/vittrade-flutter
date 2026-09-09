import 'dart:async';

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
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';

/// Bố cục tablet của P2P Express (SC-211): form mua/bán nhanh ở cột trái
/// (tài sản · số lượng · phương thức), offer tốt nhất + escrow ở cột phải.
/// CTA dẫn sang trang xác nhận qua query params (cùng contract với phone).
class P2PExpressTabletPage extends ConsumerStatefulWidget {
  const P2PExpressTabletPage({super.key});

  static const contentKey = Key('sc211_tablet_content');

  @override
  ConsumerState<P2PExpressTabletPage> createState() =>
      _P2PExpressTabletPageState();
}

class _P2PExpressTabletPageState extends ConsumerState<P2PExpressTabletPage> {
  final TextEditingController _amountController = TextEditingController();
  P2PTradeType _tradeType = P2PTradeType.buy;
  String _asset = 'USDT';
  String _paymentMethod = '';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int get _fiatAmount =>
      int.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;

  void _openConfirm(
    BuildContext context,
    P2PExpressSnapshot snapshot,
    String assetSymbol,
    P2PAdDraft bestAd,
    double cryptoAmount,
  ) {
    final query = Uri(
      queryParameters: {
        'type': _tradeType.name,
        'asset': assetSymbol,
        'fiat': '$_fiatAmount',
        'crypto': cryptoAmount.toStringAsFixed(4),
        'adId': bestAd.id,
        'payment': _paymentMethod,
      },
    ).query;
    unawaited(context.push('${AppRoutePaths.p2pExpressConfirm}?$query'));
  }

  @override
  Widget build(BuildContext context) {
    final expressAsync = ref.watch(p2pExpressProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Giao dịch nhanh P2P',
      semanticIdentifier: 'SC-211',
      child: Column(
        children: [
          VitHeader(
            title: 'P2P Express',
            subtitle: 'Mua bán nhanh · Khớp tự động',
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
            child: expressAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được P2P Express',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(p2pExpressProvider),
                ),
              ),
              data: (snapshot) {
                final selectedAsset = snapshot.assetBySymbol(_asset);
                final bestAd = snapshot.bestAd(
                  tradeType: _tradeType,
                  asset: selectedAsset.symbol,
                  fiatAmount: _fiatAmount,
                  paymentMethod: _paymentMethod,
                );
                final cryptoAmount = bestAd == null || _fiatAmount <= 0
                    ? 0.0
                    : _fiatAmount / bestAd.price;
                return VitTwoColumnTabletDashboard(
                  primaryChildren: [
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

                    _ExpressAssetCard(
                      assets: snapshot.assets,
                      selected: selectedAsset,
                      onSelected: (asset) => setState(() {
                        _asset = asset.symbol;
                      }),
                    ),

                    _ExpressAmountCard(
                      controller: _amountController,
                      quickAmounts: snapshot.quickAmountsVnd,
                      cryptoAmount: cryptoAmount,
                      onChanged: () => setState(() {}),
                      onQuickAmount: (amount) => setState(() {
                        _amountController.text = '$amount';
                      }),
                    ),

                    _PaymentCard(
                      paymentMethods: snapshot.paymentMethods,
                      selected: _paymentMethod,
                      onSelected: (id) => setState(() {
                        _paymentMethod = id;
                      }),
                    ),
                  ],
                  secondaryChildren: [
                    if (bestAd != null && _fiatAmount > 0)
                      _BestOfferCard(
                        tradeType: _tradeType,
                        ad: bestAd,
                        marketPrice: selectedAsset.marketPriceVnd,
                        cryptoAmount: cryptoAmount,
                      )
                    else
                      const VitEmptyState(
                        icon: Icons.bolt_outlined,
                        title: 'Chưa có offer phù hợp',
                        message: 'Nhập số lượng để khớp offer tốt nhất.',
                      ),

                    VitCtaButton(
                      onPressed: bestAd == null
                          ? null
                          : () => _openConfirm(
                              context,
                              snapshot,
                              selectedAsset.symbol,
                              bestAd,
                              cryptoAmount,
                            ),
                      variant: _tradeType == P2PTradeType.buy
                          ? VitCtaButtonVariant.success
                          : VitCtaButtonVariant.danger,
                      child: Text(
                        '${_tradeType == P2PTradeType.buy ? 'Mua nhanh' : 'Bán nhanh'} ${selectedAsset.symbol}',
                      ),
                    ),

                    _ExpressEscrowCard(
                      snapshot: snapshot,
                      tradeType: _tradeType,
                    ),

                    _StepsCard(steps: snapshot.steps),
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

class _ExpressAssetCard extends StatelessWidget {
  const _ExpressAssetCard({
    required this.assets,
    required this.selected,
    required this.onSelected,
  });

  final List<P2PAssetDraft> assets;
  final P2PAssetDraft selected;
  final ValueChanged<P2PAssetDraft> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tài sản',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final asset in assets)
                VitFilterChip(
                  label: asset.symbol,
                  active: selected.symbol == asset.symbol,
                  onTap: () => onSelected(asset),
                  color: AppColors.primary,
                ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Text(
            'Giá thị trường: ${formatP2PVnd(selected.marketPriceVnd)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpressAmountCard extends StatelessWidget {
  const _ExpressAmountCard({
    required this.controller,
    required this.quickAmounts,
    required this.cryptoAmount,
    required this.onChanged,
    required this.onQuickAmount,
  });

  final TextEditingController controller;
  final List<int> quickAmounts;
  final double cryptoAmount;
  final VoidCallback onChanged;
  final ValueChanged<int> onQuickAmount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Số tiền (VND)',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          VitInput(
            controller: controller,
            onChanged: (_) => onChanged(),
            keyboardType: TextInputType.number,
            semanticLabel: 'Số tiền giao dịch',
            hintText: 'Nhập số tiền VND',
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final amount in quickAmounts)
                VitFilterChip(
                  label: formatP2PVnd(amount),
                  onTap: () => onQuickAmount(amount),
                  active: false,
                  color: AppColors.primary,
                ),
            ],
          ),
          if (cryptoAmount > 0) ...[
            const SizedBox(height: TabletSpacingTokens.x2),
            Text(
              'Nhận ước tính: ${formatP2PCrypto(cryptoAmount)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({
    required this.paymentMethods,
    required this.selected,
    required this.onSelected,
  });

  final List<P2PPaymentMethodDraft> paymentMethods;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phương thức thanh toán',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              for (final method in paymentMethods)
                VitFilterChip(
                  label: method.bankName,
                  active: selected == method.id,
                  onTap: () => onSelected(method.id),
                  color: AppColors.primary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BestOfferCard extends StatelessWidget {
  const _BestOfferCard({
    required this.tradeType,
    required this.ad,
    required this.marketPrice,
    required this.cryptoAmount,
  });

  final P2PTradeType tradeType;
  final P2PAdDraft ad;
  final int marketPrice;
  final double cryptoAmount;

  @override
  Widget build(BuildContext context) {
    final isBuy = tradeType == P2PTradeType.buy;
    final deltaPct = marketPrice <= 0
        ? 0.0
        : (ad.price - marketPrice) / marketPrice * 100;
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Offer tốt nhất',
                  style: AppTextStyles.control.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text1,
                  ),
                ),
              ),
              VitStatusPill(
                label: isBuy ? 'Bán cho bạn' : 'Mua từ bạn',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (final (label, value) in [
            ('Merchant', ad.merchant),
            ('Giá', formatP2PVnd(ad.price)),
            (
              'Chênh lệch thị trường',
              '${deltaPct >= 0 ? '+' : ''}${deltaPct.toStringAsFixed(2)}%',
            ),
            (
              'Hạn mức',
              '${formatP2PVnd(ad.minLimit)} - ${formatP2PVnd(ad.maxLimit)}',
            ),
            ('Nhận ước tính', formatP2PCrypto(cryptoAmount)),
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

class _ExpressEscrowCard extends StatelessWidget {
  const _ExpressEscrowCard({required this.snapshot, required this.tradeType});

  final P2PExpressSnapshot snapshot;
  final P2PTradeType tradeType;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.escrowTitle,
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          Text(
            tradeType == P2PTradeType.buy
                ? snapshot.escrowBuyNote
                : snapshot.escrowSellNote,
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

class _StepsCard extends StatelessWidget {
  const _StepsCard({required this.steps});

  final List<P2PExpressStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quy trình',
            style: AppTextStyles.control.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          for (var i = 0; i < steps.length; i++)
            Padding(
              padding: TabletSpacingTokens.tableCellPaddingV,
              child: Row(
                children: [
                  SizedBox(
                    width: TabletSpacingTokens.x7,
                    child: Text(
                      '${i + 1}',
                      style: AppTextStyles.control.copyWith(
                        color: AppColors.primary,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      steps[i].title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
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
