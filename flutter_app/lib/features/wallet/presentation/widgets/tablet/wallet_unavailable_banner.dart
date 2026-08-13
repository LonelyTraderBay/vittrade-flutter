import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';

class WalletUnavailableBanner extends StatelessWidget {
  const WalletUnavailableBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final displayMessage = message == 'read-only or local navigation action'
        ? 'Một số thao tác ví đang ở chế độ xem trước'
        : message;

    return VitBanner(
      variant: VitBannerVariant.warning,
      icon: Icons.lock_outline_rounded,
      message: displayMessage,
    );
  }
}
