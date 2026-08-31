import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/assets/wallet_buy_crypto_sections.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for the high-risk buy-crypto flow SC-145.
class BuyCryptoTabletPage extends ConsumerStatefulWidget {
  const BuyCryptoTabletPage({super.key});

  static const contentKey = Key('sc145_buy_crypto_tablet_content');
  static const amountFieldKey = Key('sc145_buy_crypto_amount_tablet');
  static const cryptoSelectorKey = Key('sc145_buy_crypto_selector_tablet');
  static const buyButtonKey = Key('sc145_buy_crypto_buy_tablet');
  static Key presetKey(int amount) =>
      Key('sc145_buy_crypto_preset_tablet_$amount');
  static Key paymentKey(String id) =>
      Key('sc145_buy_crypto_payment_tablet_$id');

  @override
  ConsumerState<BuyCryptoTabletPage> createState() =>
      _BuyCryptoTabletPageState();
}

class _BuyCryptoTabletPageState extends ConsumerState<BuyCryptoTabletPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCrypto = 'USDT';
  String _selectedPayment = 'momo';
  bool _confirming = false;
  bool _submitting = false;
  bool _success = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletBuyCryptoProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        title: 'Mua Crypto',
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        title: 'Mua Crypto',
        primary: VitErrorState(
          title: 'Không tải được dữ liệu mua crypto',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletBuyCryptoProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) {
        final crypto = _crypto(snapshot);
        final payment = _payment(snapshot);
        final amountVnd = _amountVnd;
        final receiveAmount = amountVnd / crypto.priceVnd;
        if (_success) {
          return _frame(
            title: 'Mua Crypto',
            primary: _successContent(crypto, amountVnd, receiveAmount),
            secondary: const SizedBox.shrink(),
          );
        }
        return _frame(
          title: _confirming ? 'Xác nhận mua' : 'Mua Crypto',
          primary: _confirming
              ? Column(
                  key: BuyCryptoTabletPage.contentKey,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VitHighRiskStatePanel(
                      state: VitHighRiskUiState.riskReview,
                      title: 'Xem lại lệnh mua',
                      message:
                          'Xác nhận số tiền, tài sản nhận, phương thức thanh toán, phí và bước tiếp theo trước khi gửi.',
                      contractId: 'Mua tiền mã hóa',
                    ),
                    BuyConfirmContent(
                      crypto: crypto,
                      payment: payment,
                      amountVnd: amountVnd,
                      receiveAmount: receiveAmount,
                      submitting: _submitting,
                      onConfirm: _submitBuyOrder,
                      onBack: () => setState(() => _confirming = false),
                    ),
                  ],
                )
              : Column(
                  key: BuyCryptoTabletPage.contentKey,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: BuyInputContent.sections(
                    snapshot: snapshot,
                    selectedCrypto: crypto,
                    selectedPaymentId: _selectedPayment,
                    amountController: _amountController,
                    amountVnd: amountVnd,
                    receiveAmount: receiveAmount,
                    onAmountChanged: () => setState(() {}),
                    onPreset: (amount) {
                      _amountController.text = amount.toString();
                      setState(() {});
                    },
                    onCryptoTap: () => _showCryptoPicker(snapshot),
                    onPaymentChanged: (id) =>
                        setState(() => _selectedPayment = id),
                    onBuy: _canBuy(crypto)
                        ? () => setState(() => _confirming = true)
                        : null,
                  ),
                ),
          secondary: _buildSecondary(crypto, payment, amountVnd),
        );
      },
    );
  }

  Widget _frame({
    required String title,
    required Widget primary,
    required Widget secondary,
  }) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Mua tiền mã hóa trên tablet',
      semanticIdentifier: 'SC-145-TABLET',
      title: title,
      subtitle: 'Giao dịch · Ví',
      onBack: () => _confirming
          ? setState(() => _confirming = false)
          : context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildSecondary(
    WalletBuyCryptoOption crypto,
    WalletPaymentMethod payment,
    int amountVnd,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Kiểm tra trước khi mua',
          message:
              'Xác nhận tỷ giá, phí, hạn mức và phương thức thanh toán trước bước gửi lệnh.',
          contractId: 'Mua tiền mã hóa',
        ),
        VitPageSection(
          label: 'Tóm tắt giao dịch',
          headerIcon: Icons.receipt_long_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  VitInfoRow(
                    label: 'Tài sản',
                    value: '${crypto.name} (${crypto.symbol})',
                    leading: const Icon(Icons.currency_bitcoin_rounded),
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Số tiền',
                    value: '${VitFormat.count(amountVnd)} VND',
                    leading: const Icon(Icons.payments_outlined),
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Thanh toán',
                    value: payment.name,
                    leading: const Icon(Icons.account_balance_outlined),
                    density: VitDensity.compact,
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _successContent(
    WalletBuyCryptoOption crypto,
    int amountVnd,
    double receiveAmount,
  ) {
    return Column(
      key: BuyCryptoTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          child: Column(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconLg,
              ),
              const SizedBox(height: AppSpacing.x4),
              const Text(
                'Đặt lệnh thành công!',
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Lệnh mua ${receiveAmount.toStringAsFixed(6)} ${crypto.symbol} từ ${VitFormat.count(amountVnd)} VND đã được ghi nhận.',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          variant: VitCtaButtonVariant.success,
          onPressed: () => context.go(AppRoutePaths.wallet),
          child: const Text('Về Ví'),
        ),
        VitCtaButton(
          variant: VitCtaButtonVariant.ghost,
          onPressed: () => setState(() {
            _success = false;
            _confirming = false;
            _submitting = false;
            _amountController.clear();
          }),
          child: const Text('Mua thêm'),
        ),
      ],
    );
  }

  WalletBuyCryptoOption _crypto(WalletBuyCryptoSnapshot snapshot) {
    return snapshot.cryptoOptions.firstWhere(
      (option) => option.symbol == _selectedCrypto,
      orElse: () => snapshot.cryptoOptions.first,
    );
  }

  WalletPaymentMethod _payment(WalletBuyCryptoSnapshot snapshot) {
    return snapshot.paymentMethods.firstWhere(
      (method) => method.id == _selectedPayment,
      orElse: () => snapshot.paymentMethods.first,
    );
  }

  int get _amountVnd =>
      int.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;

  bool _canBuy(WalletBuyCryptoOption crypto) {
    return _amountVnd >= crypto.minBuyVnd && _amountVnd <= 100000000;
  }

  void _submitBuyOrder() {
    if (_submitting) return;
    setState(() => _submitting = true);
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _success = true;
      });
    });
  }

  void _showCryptoPicker(WalletBuyCryptoSnapshot snapshot) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => VitSheetPanel(
          title: 'Chọn loại Crypto',
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.cryptoOptions.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x4),
            itemBuilder: (context, index) {
              final option = snapshot.cryptoOptions[index];
              return VitCard(
                onTap: () {
                  setState(() => _selectedCrypto = option.symbol);
                  Navigator.of(context).pop();
                },
                variant: VitCardVariant.inner,
                density: VitDensity.compact,
                child: Row(
                  children: [
                    VitAssetAvatar(
                      label: option.symbol,
                      accentColor: Color(option.colorHex),
                      size: AppSpacing.iconLg,
                    ),
                    const SizedBox(width: AppSpacing.x4),
                    Expanded(child: Text(option.name)),
                    Text(option.symbol),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
