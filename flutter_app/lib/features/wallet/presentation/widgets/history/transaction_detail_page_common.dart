part of '../../phone/pages/transaction_detail_page.dart';

class _SupportButton extends StatelessWidget {
  const _SupportButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: TransactionDetailPage.supportKey,
      onPressed: onTap,
      variant: VitCtaButtonVariant.warning,
      height: WalletSpacingTokens.walletTransactionMissingActionHeight,
      leading: const Icon(Icons.chat_bubble_outline_rounded),
      child: const Text('Liên hệ hỗ trợ'),
    );
  }
}

class _MissingTransaction extends StatelessWidget {
  const _MissingTransaction({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      title: 'Không tìm thấy giao dịch',
      message: 'Kiểm tra lại lịch sử ví hoặc quay lại danh sách giao dịch.',
      icon: Icons.error_outline_rounded,
      actionLabel: 'Quay lại lịch sử',
      onAction: onBack,
    );
  }
}

final class _DetailTypeMeta {
  const _DetailTypeMeta({
    required this.label,
    required this.color,
    required this.icon,
    required this.isDebit,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isDebit;

  factory _DetailTypeMeta.from(WalletTransaction tx) {
    return switch (tx.type) {
      WalletTransactionType.deposit => const _DetailTypeMeta(
        label: 'Nạp tiền',
        color: _detailGreen,
        icon: Icons.arrow_downward_rounded,
        isDebit: false,
      ),
      WalletTransactionType.withdraw => const _DetailTypeMeta(
        label: 'Rút tiền',
        color: _detailRed,
        icon: Icons.arrow_upward_rounded,
        isDebit: true,
      ),
      WalletTransactionType.tradeBuy => const _DetailTypeMeta(
        label: 'Mua giao dịch',
        color: _detailGreen,
        icon: Icons.currency_exchange_rounded,
        isDebit: false,
      ),
      WalletTransactionType.tradeSell => const _DetailTypeMeta(
        label: 'Bán giao dịch',
        color: _detailRed,
        icon: Icons.currency_exchange_rounded,
        isDebit: true,
      ),
      WalletTransactionType.p2pBuy => const _DetailTypeMeta(
        label: 'P2P Mua',
        color: _detailGreen,
        icon: Icons.handshake_rounded,
        isDebit: false,
      ),
      WalletTransactionType.p2pSell => const _DetailTypeMeta(
        label: 'P2P Bán',
        color: _detailRed,
        icon: Icons.handshake_rounded,
        isDebit: true,
      ),
    };
  }
}

final class _DetailStatusMeta {
  const _DetailStatusMeta({required this.label, required this.icon});

  final String label;
  final IconData icon;

  factory _DetailStatusMeta.from(WalletTransactionStatus status) {
    return switch (status) {
      WalletTransactionStatus.completed => const _DetailStatusMeta(
        label: 'Hoàn thành',
        icon: Icons.check_circle_outline_rounded,
      ),
      WalletTransactionStatus.pending => const _DetailStatusMeta(
        label: 'Đang xử lý',
        icon: Icons.access_time_rounded,
      ),
      WalletTransactionStatus.failed => const _DetailStatusMeta(
        label: 'Thất bại',
        icon: Icons.cancel_outlined,
      ),
    };
  }
}

VitStatusPillStatus _detailPillStatus(WalletTransactionStatus status) {
  return switch (status) {
    WalletTransactionStatus.completed => VitStatusPillStatus.success,
    WalletTransactionStatus.pending => VitStatusPillStatus.warning,
    WalletTransactionStatus.failed => VitStatusPillStatus.error,
  };
}

final class _ProgressStep {
  const _ProgressStep(
    this.label,
    this.time, {
    required this.done,
    this.failed = false,
  });

  final String label;
  final String? time;
  final bool done;
  final bool failed;
}

final class _DetailRowData {
  const _DetailRowData({
    required this.label,
    required this.value,
    this.copyValue,
    this.copyable = false,
  });

  final String label;
  final String value;
  final String? copyValue;
  final bool copyable;
}

List<_DetailRowData> _detailsFor(WalletTransaction tx, bool isDebit) {
  final rows = <_DetailRowData>[];
  if (tx.txHash != null) {
    rows.add(
      _DetailRowData(
        label: 'Mã giao dịch (TxID)',
        value: tx.txHash!,
        copyable: true,
      ),
    );
  }
  if (tx.network != null) {
    rows.add(_DetailRowData(label: 'Mạng', value: tx.network!));
  }
  if (tx.address != null) {
    rows.add(
      _DetailRowData(
        label: isDebit ? 'Địa chỉ nhận' : 'Địa chỉ gửi',
        value: _maskSensitiveValue(tx.address!),
        copyValue: tx.address!,
        copyable: true,
      ),
    );
  }
  if (tx.fee != null && tx.fee! > 0) {
    rows.add(
      _DetailRowData(label: 'Phí giao dịch', value: _formatFee(tx.fee!)),
    );
  }
  rows.add(_DetailRowData(label: 'Thời gian', value: tx.createdAt));
  return rows;
}

String _maskSensitiveValue(String value) => maskAddress(value);

String _formatAmount(WalletTransaction tx) {
  if (tx.asset == 'BTC') return tx.amount.toStringAsFixed(6);
  if (tx.asset == 'ETH') return tx.amount.toStringAsFixed(4);
  return _formatNumber(tx.amount, fractionDigits: 2);
}

String _formatFee(double value) => '\$${value.toStringAsFixed(2)}';

String _formatNumber(double value, {required int fractionDigits}) {
  final fixed = value.toStringAsFixed(fractionDigits);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (fractionDigits == 0) return buffer.toString();
  return '${buffer.toString()}.${parts[1]}';
}
