import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

/// Panel phẳng dùng chung của terminal Trade tablet (SC-048, hướng Bybit
/// 2026-08-31): `VitCardRadius.tight` 8px, viền hairline, tiêu đề micro
/// nhãn + trailing tuỳ chọn — các miền dữ liệu tách nhau bằng VIỀN + NHÃN,
/// không tách bằng khoảng trống to (cùng ngôn ngữ với terminal Markets
/// SC-044 hướng C).
class TradeTerminalPanel extends StatelessWidget {
  const TradeTerminalPanel({
    super.key,
    required this.child,
    this.label,
    this.trailing,
    this.panelKey,
    this.fill = false,
  });

  final Widget child;

  /// Nhãn micro viết hoa đầu panel (vd 'SỔ LỆNH') — null = panel không
  /// tiêu đề (meta strip, chart).
  final String? label;

  final Widget? trailing;
  final Key? panelKey;

  /// true = chiếm hết chiều cao còn lại của cột (sổ lệnh/tape); false = co
  /// theo nội dung (meta strip, tab dưới chart — tránh Expanded vô hạn).
  final bool fill;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: panelKey,
      radius: VitCardRadius.tight,
      borderColor: AppColors.border,
      padding: TabletSpacingTokens.zeroInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label case final labelValue?)
            Padding(
              padding: TradeSpacingTokens.tradeTerminalPanelHeaderPadding,
              child: Row(
                children: [
                  Text(
                    labelValue,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const Spacer(),
                  ?trailing,
                ],
              ),
            ),
          if (fill) Expanded(child: child) else child,
        ],
      ),
    );
  }
}
