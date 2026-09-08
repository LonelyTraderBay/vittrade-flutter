import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/p2p_core/presentation/widgets/p2p_formatters.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Xác nhận P2P Express (SC-210): tổng quan lệnh dạng bảng
/// preview + escrow/warning note, CTA xác nhận sticky dưới cùng — financial
/// safety: mọi tham số hiển thị rõ trước khi gửi.
class P2PExpressConfirmTabletPage extends ConsumerWidget {
  const P2PExpressConfirmTabletPage({
    super.key,
    this.tradeType = P2PTradeType.buy,
    this.asset = 'USDT',
    this.fiatAmount = 0,
    this.cryptoAmount = 0,
    this.adId,
    this.paymentMethod,
  });

  static const contentKey = Key('sc210_tablet_content');
  static const confirmCtaKey = Key('sc210_tablet_confirm');

  final P2PTradeType tradeType;
  final String asset;
  final double fiatAmount;
  final double cryptoAmount;
  final String? adId;
  final String? paymentMethod;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmAsync = ref.watch(
      p2pExpressConfirmProvider((
        tradeType: tradeType,
        asset: asset,
        fiatAmount: fiatAmount,
        cryptoAmount: cryptoAmount,
        adId: adId,
        paymentMethod: paymentMethod,
      )),
    );
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Xác nhận P2P Express',
      semanticIdentifier: 'SC-210',
      child: Column(
        children: [
          VitHeader(
            title: 'Xác nhận giao dịch',
            subtitle: 'P2P Express · Preview',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pExpress,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: confirmAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được xác nhận',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(
                    p2pExpressConfirmProvider((
                      tradeType: tradeType,
                      asset: asset,
                      fiatAmount: fiatAmount,
                      cryptoAmount: cryptoAmount,
                      adId: adId,
                      paymentMethod: paymentMethod,
                    )),
                  ),
                ),
              ),
              data: (snapshot) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: SingleChildScrollView(
                    key: P2PExpressConfirmTabletPage.contentKey,
                    padding: const EdgeInsets.fromLTRB(
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x4,
                      TabletSpacingTokens.x6,
                      TabletSpacingTokens.x6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        VitCard(
                          radius: VitCardRadius.tight,
                          padding: TabletSpacingTokens.cardPaddingCompact,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      tradeType == P2PTradeType.buy
                                          ? 'Mua ${snapshot.asset}'
                                          : 'Bán ${snapshot.asset}',
                                      style: AppTextStyles.control.copyWith(
                                        fontWeight: AppTextStyles.bold,
                                        color: AppColors.text1,
                                      ),
                                    ),
                                  ),
                                  const VitStatusPill(
                                    label: 'Xem trước khi gửi',
                                    status: VitStatusPillStatus.warning,
                                    size: VitStatusPillSize.sm,
                                  ),
                                ],
                              ),
                              const SizedBox(height: TabletSpacingTokens.x3),
                              for (final (label, value) in [
                                (
                                  'Số tiền VND',
                                  formatP2PVnd(snapshot.fiatAmount),
                                ),
                                (
                                  'Số lượng ${snapshot.asset}',
                                  formatP2PCrypto(snapshot.cryptoAmount),
                                ),
                                ('Giá khớp', formatP2PVnd(snapshot.ad.price)),
                                ('Merchant', snapshot.ad.merchant),
                                (
                                  'Phương thức',
                                  snapshot.paymentMethod.isEmpty
                                      ? 'Không chọn'
                                      : snapshot.paymentMethod,
                                ),
                                (
                                  'Phí escrow',
                                  formatP2PVnd(snapshot.order.fee.toDouble()),
                                ),
                                (
                                  'Escrow giữ',
                                  formatP2PVnd(snapshot.order.escrowAmount),
                                ),
                                (
                                  'Thời gian escrow',
                                  '${snapshot.order.escrowMinutes} phút',
                                ),
                              ])
                                Padding(
                                  padding:
                                      TabletSpacingTokens.tableCellPaddingV,
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
                        const SizedBox(height: TabletSpacingTokens.x3),
                        VitCard(
                          radius: VitCardRadius.tight,
                          padding: TabletSpacingTokens.cardPaddingCompact,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ký quỹ an toàn',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              const SizedBox(height: TabletSpacingTokens.x1),
                              Text(
                                snapshot.escrowNote,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        const VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          density: VitDensity.tool,
                          title: 'Xác nhận trước khi gửi lệnh',
                          message:
                              'Kiểm tra số tiền, giá khớp và phương thức thanh toán. Lệnh gửi đi sẽ giữ tài sản trong escrow.',
                          contractId: 'p2p-express-confirm-tablet',
                        ),
                        const SizedBox(height: TabletSpacingTokens.x3),
                        Text(
                          snapshot.warningNote,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: TabletSpacingTokens.x4),
                        VitCtaButton(
                          key: P2PExpressConfirmTabletPage.confirmCtaKey,
                          variant: tradeType == P2PTradeType.buy
                              ? VitCtaButtonVariant.success
                              : VitCtaButtonVariant.danger,
                          onPressed: () =>
                              context.go(AppRoutePaths.p2pMyOrders),
                          child: Text(
                            tradeType == P2PTradeType.buy
                                ? 'Gửi lệnh mua'
                                : 'Gửi lệnh bán',
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
