import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';

/// Khung chi tiết dành riêng cho tablet của Trade (các luồng L2: Futures,
/// Đòn bẩy, Margin, Chuyển đổi, Cài đặt, Xuất lịch sử — 2026-08-31).
///
/// Sở hữu quan hệ cột trên màn rộng (primary:flex7 | secondary:flex5, một
/// cuộn duy nhất, nhịp form) — cùng khuôn mà Wallet/Profile/P2P mỗi module
/// giữ một bản riêng của mình. Trang phone không import boundary này; dữ
/// liệu, controller và hợp đồng tài chính vẫn dùng chung.
class TradeTabletDetailSurface extends StatelessWidget {
  const TradeTabletDetailSurface({
    super.key,
    required this.semanticLabel,
    required this.semanticIdentifier,
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.secondary,
    required this.onBack,
    this.backKey,
    this.tabs,
  });

  final String semanticLabel;
  final String semanticIdentifier;
  final String title;
  final String subtitle;

  /// Cột chính: form/thao tác của luồng.
  final Widget primary;

  /// Cột phụ: ngữ cảnh, facts an toàn tài chính, bảng vị thế/lệnh.
  final Widget secondary;
  final VoidCallback onBack;
  final Key? backKey;

  /// Hàng product tabs (L1) nếu luồng nằm trong product-switch — đặt trên
  /// vùng cuộn như trang phone.
  final Widget? tabs;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: semanticLabel,
      semanticIdentifier: semanticIdentifier,
      child: Column(
        children: [
          VitHeader(
            title: title,
            subtitle: subtitle,
            showBack: true,
            onBack: onBack,
            backKey: backKey,
          ),
          if (tabs != null)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: TabletSpacingTokens.pageRhythmCompactInnerGap,
              ),
              child: tabs,
            ),
          Expanded(
            child: VitTwoColumnTabletDashboard(
              primaryChildren: [primary],
              secondaryChildren: [secondary],
            ),
          ),
        ],
      ),
    );
  }
}
