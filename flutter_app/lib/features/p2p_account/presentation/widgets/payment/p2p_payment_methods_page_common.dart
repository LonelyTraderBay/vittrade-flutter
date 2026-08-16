part of '../../phone/pages/payment/p2p_payment_methods_page.dart';

class _EmptyPaymentMethods extends StatelessWidget {
  const _EmptyPaymentMethods({required this.snapshot});

  final P2PPaymentMethodsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pPaymentMethodsListEmptyPadding,
      child: VitEmptyState(
        icon: Icons.credit_card_off_rounded,
        title: snapshot.emptyTitle,
        message: 'Thêm tài khoản ngân hàng hoặc ví điện tử để giao dịch P2P.',
      ),
    );
  }
}
