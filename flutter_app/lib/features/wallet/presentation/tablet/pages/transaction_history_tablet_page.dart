import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Pane hub của shell lịch sử giao dịch SC-136 (tablet): hiển thị khi chưa
/// chọn giao dịch nào — empty state thật theo shell pattern rule 6, không
/// bao giờ để trống pane. Danh sách làm việc nằm ở master column của
/// `WalletTabletHistoryShell`.
class TransactionHistoryTabletPage extends StatelessWidget {
  const TransactionHistoryTabletPage({super.key});

  static const contentKey = Key('sc136_transaction_history_tablet_content');
  static const exportKey = Key('sc136_transaction_history_export');
  static Key filterKey(String id) => Key('sc136_transaction_filter_$id');
  static Key transactionKey(String id) => Key('sc136_transaction_$id');

  @override
  Widget build(BuildContext context) {
    return const VitPageContent(
      key: contentKey,
      rhythm: VitPageRhythm.standard,
      children: [
        VitEmptyState(
          title: 'Chọn một giao dịch',
          message:
              'Nhấn vào một giao dịch trong danh sách bên trái để xem chi tiết ngay tại đây.',
          icon: Icons.receipt_long_outlined,
        ),
      ],
    );
  }
}
