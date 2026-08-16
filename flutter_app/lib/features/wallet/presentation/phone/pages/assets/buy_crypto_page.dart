import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/widgets/vit_wallet_detail_scaffold.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/widgets/assets/wallet_buy_crypto_sections.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_high_risk_state_panel.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';

class BuyCryptoPage extends ConsumerStatefulWidget {
  const BuyCryptoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc145_buy_crypto_content');
  static const amountFieldKey = Key('sc145_buy_crypto_amount');
  static const cryptoSelectorKey = Key('sc145_buy_crypto_selector');
  static const buyButtonKey = Key('sc145_buy_crypto_buy');
  static Key presetKey(int amount) => Key('sc145_buy_crypto_preset_$amount');
  static Key paymentKey(String id) => Key('sc145_buy_crypto_payment_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BuyCryptoPage> createState() => _BuyCryptoPageState();
}

class _BuyCryptoPageState extends ConsumerState<BuyCryptoPage> {
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

  int get _amountVnd {
    return int.tryParse(_amountController.text.replaceAll(',', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletBuyCryptoProvider);

    return snapshotAsync.when(
      loading: () => VitWalletDetailScaffold(
        title: 'Mua Crypto',
        subtitle: 'Giao dịch · Wallet',
        semanticLabel: 'Mua tiền mã hoá',
        semanticIdentifier: 'SC-145',
        contentKey: BuyCryptoPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        onBack: () => context.go(AppRoutePaths.wallet),
        children: const [VitSkeletonList()],
      ),
      error: (error, stackTrace) => VitWalletDetailScaffold(
        title: 'Mua Crypto',
        subtitle: 'Giao dịch · Wallet',
        semanticLabel: 'Mua tiền mã hoá',
        semanticIdentifier: 'SC-145',
        contentKey: BuyCryptoPage.contentKey,
        shellRenderMode: widget.shellRenderMode,
        onBack: () => context.go(AppRoutePaths.wallet),
        children: [
          VitErrorState(
            title: 'Không tải được dữ liệu mua crypto',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(walletBuyCryptoProvider),
          ),
        ],
      ),
      data: (snapshot) {
        final crypto = _crypto(snapshot);
        final payment = _payment(snapshot);
        final receiveAmount = _amountVnd / crypto.priceVnd;

        if (_success) {
          return BuySuccessState(
            crypto: crypto,
            amountVnd: _amountVnd,
            receiveAmount: receiveAmount,
            onWallet: () => context.go(AppRoutePaths.wallet),
            onBuyMore: () {
              setState(() {
                _success = false;
                _confirming = false;
                _submitting = false;
                _amountController.clear();
              });
            },
          );
        }

        return VitWalletDetailScaffold(
          title: _confirming ? 'Xác nhận mua' : 'Mua Crypto',
          subtitle: 'Giao dịch · Wallet',
          semanticLabel: 'Mua tiền mã hoá',
          semanticIdentifier: 'SC-145',
          contentKey: BuyCryptoPage.contentKey,
          shellRenderMode: widget.shellRenderMode,
          onBack: () => _confirming
              ? setState(() => _confirming = false)
              : context.go(AppRoutePaths.wallet),
          children: [
            if (_confirming) ...[
              VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                title: 'Xem lại lệnh mua',
                message:
                    'Xác nhận số tiền, tài sản nhận, phương thức thanh toán, phí và bước tiếp theo trước khi gửi.',
                contractId: '${crypto.symbol} / ${payment.name}',
              ),
              BuyConfirmContent(
                crypto: crypto,
                payment: payment,
                amountVnd: _amountVnd,
                receiveAmount: receiveAmount,
                submitting: _submitting,
                onConfirm: _submitBuyOrder,
                onBack: () => setState(() => _confirming = false),
              ),
            ] else
              ...BuyInputContent.sections(
                snapshot: snapshot,
                selectedCrypto: crypto,
                selectedPaymentId: _selectedPayment,
                amountController: _amountController,
                amountVnd: _amountVnd,
                receiveAmount: receiveAmount,
                onAmountChanged: () => setState(() {}),
                onPreset: (amount) {
                  _amountController.text = amount.toString();
                  setState(() {});
                },
                onCryptoTap: () => _showCryptoPicker(snapshot),
                onPaymentChanged: (id) => setState(() => _selectedPayment = id),
                onBuy: _canBuy(crypto)
                    ? () => setState(() => _confirming = true)
                    : null,
              ),
          ],
        );
      },
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
        builder: (context) {
          return VitSheetPanel(
            title: 'Chọn loại Crypto',
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: snapshot.cryptoOptions.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x1),
              itemBuilder: (context, index) {
                final option = snapshot.cryptoOptions[index];
                return BuyCryptoOptionRow(
                  option: option,
                  selected: option.symbol == _selectedCrypto,
                  onTap: () {
                    setState(() => _selectedCrypto = option.symbol);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
