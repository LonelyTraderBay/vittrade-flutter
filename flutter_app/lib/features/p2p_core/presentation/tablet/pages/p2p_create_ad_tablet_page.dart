import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Bố cục tablet của Tạo quảng cáo (SC-226): form wizard cột trái (loại ·
/// tài sản · giá · hạn mức · thanh toán · khung giờ), cột phải là escrow/
/// warning notes + CTA xem trước — financial safety: preview trước khi gửi.
class P2PCreateAdTabletPage extends ConsumerStatefulWidget {
  const P2PCreateAdTabletPage({super.key});

  static const contentKey = Key('sc226_tablet_content');
  static const submitKey = Key('sc226_tablet_submit');

  @override
  ConsumerState<P2PCreateAdTabletPage> createState() =>
      _P2PCreateAdTabletPageState();
}

class _P2PCreateAdTabletPageState extends ConsumerState<P2PCreateAdTabletPage> {
  final _priceController = TextEditingController();
  final _minLimitController = TextEditingController();
  final _maxLimitController = TextEditingController();
  P2PTradeType _tradeType = P2PTradeType.buy;
  String? _selectedAsset;
  String? _selectedPayment;
  String? _selectedHours;

  @override
  void dispose() {
    _priceController.dispose();
    _minLimitController.dispose();
    _maxLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final createAsync = ref.watch(p2pCreateAdProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tạo quảng cáo P2P',
      semanticIdentifier: 'SC-226',
      child: Column(
        children: [
          VitHeader(
            title: 'Tạo quảng cáo',
            subtitle: 'Sạp hàng · Thiết lập offer',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pMyAds,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: createAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: VitErrorState(
                  title: 'Không tải được biểu mẫu',
                  message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () => ref.invalidate(p2pCreateAdProvider),
                ),
              ),
              data: (snapshot) => Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1180),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: SingleChildScrollView(
                          key: P2PCreateAdTabletPage.contentKey,
                          padding: const EdgeInsets.fromLTRB(
                            TabletSpacingTokens.x6,
                            TabletSpacingTokens.x4,
                            TabletSpacingTokens.x3,
                            TabletSpacingTokens.x6,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              VitSegmentedTabBar(
                                tabs: const [
                                  VitTabItem(
                                    key: 'buy',
                                    label: 'Mua (Tôi mua)',
                                  ),
                                  VitTabItem(
                                    key: 'sell',
                                    label: 'Bán (Tôi bán)',
                                  ),
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
                              _FormSectionCard(
                                title: 'Tài sản & tiền tệ',
                                child: Wrap(
                                  spacing: TabletSpacingTokens.x3,
                                  runSpacing: TabletSpacingTokens.x2,
                                  children: [
                                    for (final asset in snapshot.assets)
                                      VitFilterChip(
                                        label: asset,
                                        active:
                                            asset ==
                                            (_selectedAsset ??
                                                snapshot.defaultAsset),
                                        onTap: () => setState(
                                          () => _selectedAsset = asset,
                                        ),
                                        color: AppColors.primary,
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: TabletSpacingTokens.x3),
                              _FormSectionCard(
                                title: 'Giá & hạn mức',
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    VitInput(
                                      controller: _priceController,
                                      keyboardType: TextInputType.number,
                                      semanticLabel: 'Giá VND',
                                      hintText:
                                          'Giá VND (thị trường ${snapshot.marketPrices[snapshot.defaultAsset]} VND)',
                                    ),
                                    const SizedBox(
                                      height: TabletSpacingTokens.x2,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: VitInput(
                                            controller: _minLimitController,
                                            keyboardType: TextInputType.number,
                                            semanticLabel: 'Hạn mức tối thiểu',
                                            hintText: 'Hạn mức tối thiểu',
                                          ),
                                        ),
                                        const SizedBox(
                                          width: TabletSpacingTokens.x3,
                                        ),
                                        Expanded(
                                          child: VitInput(
                                            controller: _maxLimitController,
                                            keyboardType: TextInputType.number,
                                            semanticLabel: 'Hạn mức tối đa',
                                            hintText: 'Hạn mức tối đa',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: TabletSpacingTokens.x3),
                              _FormSectionCard(
                                title: 'Phương thức thanh toán',
                                child: Wrap(
                                  spacing: TabletSpacingTokens.x3,
                                  runSpacing: TabletSpacingTokens.x2,
                                  children: [
                                    for (final option
                                        in snapshot.paymentOptions)
                                      VitFilterChip(
                                        label: option,
                                        onTap: () => setState(
                                          () => _selectedPayment = option,
                                        ),
                                        active: option == _selectedPayment,
                                        color: AppColors.primary,
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: TabletSpacingTokens.x3),
                              _FormSectionCard(
                                title: 'Khung giờ giao dịch',
                                child: Wrap(
                                  spacing: TabletSpacingTokens.x3,
                                  runSpacing: TabletSpacingTokens.x2,
                                  children: [
                                    for (final hours
                                        in snapshot.tradingHours.take(6))
                                      VitFilterChip(
                                        label: hours,
                                        onTap: () => setState(
                                          () => _selectedHours = hours,
                                        ),
                                        active:
                                            hours ==
                                            (_selectedHours ??
                                                snapshot.defaultTradingHours),
                                        color: AppColors.primary,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(
                            TabletSpacingTokens.x3,
                            TabletSpacingTokens.x4,
                            TabletSpacingTokens.x6,
                            TabletSpacingTokens.x6,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const VitHighRiskStatePanel(
                                state: VitHighRiskUiState.riskReview,
                                title: 'Xem trước khi đăng quảng cáo',
                                message:
                                    'Kiểm tra giá, hạn mức, phương thức thanh toán và khung giờ. Quảng cáo đăng lên sẽ nhận lệnh P2P thật.',
                                contractId: 'p2p-create-ad-tablet',
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
                                    const SizedBox(
                                      height: TabletSpacingTokens.x1,
                                    ),
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
                              VitCard(
                                radius: VitCardRadius.tight,
                                padding: TabletSpacingTokens.cardPaddingCompact,
                                child: Text(
                                  snapshot.warningNote,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text2,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(height: TabletSpacingTokens.x4),
                              VitCtaButton(
                                key: P2PCreateAdTabletPage.submitKey,
                                onPressed: () =>
                                    context.go(AppRoutePaths.p2pMyAds),
                                child: const Text('Xem trước & đăng'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _FormSectionCard extends StatelessWidget {
  const _FormSectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          child,
        ],
      ),
    );
  }
}
