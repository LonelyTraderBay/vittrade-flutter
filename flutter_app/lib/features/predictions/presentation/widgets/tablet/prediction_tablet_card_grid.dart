import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';

/// Lưới thẻ 2 cột cho cột chính các trang predictions tablet (Cụm A redesign
/// 2026-09-17): cột chính ≥ [_twoColumnMinWidth] tách thẻ thành CẶP hàng —
/// `IntrinsicHeight` stretch đều chiều cao hai thẻ trong hàng (idiom đã kiểm
/// chứng của Arena hub), hẹp hơn giữ một cột phone-parity.
///
/// Gap khối 12dp dọc + ngang (LUẬT 12dp) — KHÔNG dùng `Wrap` vì R3 của audit
/// gap-role khóa `Wrap(spacing:)` = micro 4 (dành chip), còn gap thẻ là vai
/// sibling 12. Thẻ lẻ cuối hàng chiếm nửa cột, neo top-start.
class PredictionTabletCardGrid extends StatelessWidget {
  const PredictionTabletCardGrid({super.key, required this.children});

  /// Danh sách thẻ theo thứ tự dữ liệu.
  final List<Widget> children;

  /// Dưới ngưỡng này về một cột phone-parity. 700 chọn theo hình học
  /// workspace: tầng hẹp (portrait 704dp − margin = 680) PHẢI một cột;
  /// cột chính wide-tier chỉ tách 2 khi mỗi thẻ ≥ ~344dp (cap 800 →
  /// 2×394dp như mockup Cụm A).
  static const double _twoColumnMinWidth = 700;

  @override
  Widget build(BuildContext context) {
    if (children.length <= 1) {
      return Column(children: children);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < _twoColumnMinWidth) {
          // Một cột phone-parity: gap sibling 12dp giữa các thẻ — wrapper section
          // (rhythm chuẩn) chỉ chèn gap giữa SECTION, không thấy từng thẻ lưới.
          return Column(
            children: [
              for (var index = 0; index < children.length; index += 1) ...[
                if (index > 0) const SizedBox(height: TabletSpacingTokens.x4),
                children[index],
              ],
            ],
          );
        }
        final halfWidth = (constraints.maxWidth - TabletSpacingTokens.x4) / 2;
        final rows = <Widget>[];
        for (var index = 0; index < children.length; index += 2) {
          final hasPair = index + 1 < children.length;
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: halfWidth, child: children[index]),
                  if (hasPair) ...[
                    const SizedBox(width: TabletSpacingTokens.x4),
                    Expanded(child: children[index + 1]),
                  ] else
                    // Thẻ lẻ: nửa cột trái, phần còn lại thở — không stretch
                    // thẻ cuối full-width (phá nhịp grid).
                    const Spacer(),
                ],
              ),
            ),
          );
          if (index + 2 < children.length) {
            rows.add(const SizedBox(height: TabletSpacingTokens.x4));
          }
        }
        return Column(children: rows);
      },
    );
  }
}
