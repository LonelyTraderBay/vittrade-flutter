import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/widgets/vit_notice_sheet.dart';

/// [VitBanner] preconfigured for the offline/reconnecting state, swapping
/// icon and message automatically based on [reconnecting].
class VitOfflineBanner extends StatelessWidget {
  const VitOfflineBanner({
    super.key,
    this.variant = VitBannerVariant.warning,
    this.message = 'Ngoại tuyến. Đang hiển thị dữ liệu đã lưu gần nhất.',
    this.detail,
    this.reconnecting = false,
  });

  final VitBannerVariant variant;
  final String message;
  final String? detail;
  final bool reconnecting;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      child: VitBanner(
        variant: reconnecting ? VitBannerVariant.info : variant,
        icon: reconnecting ? Icons.wifi_rounded : Icons.wifi_off_rounded,
        message: reconnecting ? 'Đang kết nối lại...' : message,
        detail: reconnecting ? 'Đang tự động thử lại.' : detail,
      ),
    );
  }
}
