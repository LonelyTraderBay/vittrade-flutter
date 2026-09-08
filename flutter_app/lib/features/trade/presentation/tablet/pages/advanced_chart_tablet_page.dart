import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/trade_terminal_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/tablet/trade_terminal_chart_panel.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_terminal_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục terminal của Biểu đồ nâng cao (SC-055): chiếm trọn chiều cao
/// viewport, KHÔNG cuộn trang (chỉ chart có tương tác nội bộ) — header giá
/// + dải OHLCV + panel chart dùng chung của terminal tablet + thanh hành
/// động MUA/BÁN ghim dưới.
class AdvancedChartTabletPage extends ConsumerStatefulWidget {
  const AdvancedChartTabletPage({super.key, required this.pairId});

  final String pairId;

  static const buyKey = Key('sc055_tablet_buy');
  static const sellKey = Key('sc055_tablet_sell');
  static const alertKey = Key('sc055_tablet_alert');

  @override
  ConsumerState<AdvancedChartTabletPage> createState() =>
      _AdvancedChartTabletPageState();
}

class _AdvancedChartTabletPageState
    extends ConsumerState<AdvancedChartTabletPage> {
  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      tradeAdvancedChartSnapshotProvider(widget.pairId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => Center(
        child: VitErrorState(
          title: 'Không tải được biểu đồ giao dịch nâng cao',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () =>
              ref.invalidate(tradeAdvancedChartSnapshotProvider(widget.pairId)),
        ),
      ),
      data: (snapshot) {
        final pair = snapshot.pair;
        final ohlcv = snapshot.ohlcv;
        final positive = pair.changePct >= 0;
        return VitPageLayout(
          variant: VitPageVariant.flush,
          semanticLabel: 'Biểu đồ giao dịch nâng cao',
          semanticIdentifier: 'SC-055',
          child: Column(
            children: [
              VitTradeTerminalHeader(
                symbol: pair.symbol,
                showBack: true,
                onBack: () => goBackOrFallback(
                  context,
                  fallbackPath: AppRoutePaths.tradePair(pair.id),
                  mode: BackNavigationMode.historyThenFallback,
                ),
                pairTapKey: const Key('sc055_tablet_pair_selector'),
                onPairTap: () => context.go(AppRoutePaths.markets),
                priceLabel: formatTradePrice(pair.price),
                changePct: pair.changePct,
              ),
              Padding(
                key: const Key('sc055_tablet_ohlcv'),
                padding: const EdgeInsets.symmetric(
                  horizontal: TabletSpacingTokens.x5,
                  vertical: TabletSpacingTokens.x3,
                ),
                child: Wrap(
                  spacing: TabletSpacingTokens.x5,
                  runSpacing: TabletSpacingTokens.x1,
                  children: [
                    for (final (label, value) in [
                      ('O', ohlcv.open),
                      ('C', ohlcv.close),
                      ('Cao', ohlcv.high),
                      ('Thấp', ohlcv.low),
                      ('KL', null),
                    ])
                      Text.rich(
                        TextSpan(
                          text: '$label ',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                          children: [
                            TextSpan(
                              text: value == null
                                  ? ohlcv.volumeLabel
                                  : formatTradePrice(value),
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text2,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TabletSpacingTokens.x5,
                  ),
                  child: TradeTerminalChartPanel(
                    pairId: pair.id,
                    anchorPrice: pair.price,
                    positive: positive,
                  ),
                ),
              ),
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                thickness: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TabletSpacingTokens.x5,
                    vertical: TabletSpacingTokens.x3,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: VitCtaButton(
                          key: AdvancedChartTabletPage.buyKey,
                          fullWidth: false,
                          variant: VitCtaButtonVariant.success,
                          onPressed: () =>
                              context.go(AppRoutePaths.tradePair(pair.id)),
                          child: const Text('MUA'),
                        ),
                      ),
                      const SizedBox(width: TabletSpacingTokens.x4),
                      Expanded(
                        child: VitCtaButton(
                          key: AdvancedChartTabletPage.sellKey,
                          fullWidth: false,
                          variant: VitCtaButtonVariant.danger,
                          onPressed: () =>
                              context.go(AppRoutePaths.tradePair(pair.id)),
                          child: const Text('BÁN'),
                        ),
                      ),
                      const SizedBox(width: TabletSpacingTokens.x4),
                      VitCtaButton(
                        key: AdvancedChartTabletPage.alertKey,
                        fullWidth: false,
                        variant: VitCtaButtonVariant.secondary,
                        onPressed: () => goBackOrFallback(
                          context,
                          fallbackPath: AppRoutePaths.tradePair(pair.id),
                          mode: BackNavigationMode.historyThenFallback,
                        ),
                        child: const Text('Đặt cảnh báo'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
