import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';

class MarketListHeader extends StatelessWidget {
  const MarketListHeader({
    super.key,
    required this.onNavigate,
    required this.lastUpdatedLabel,
  });

  final ValueChanged<String> onNavigate;
  final String lastUpdatedLabel;

  @override
  Widget build(BuildContext context) {
    return VitTopChrome(
      type: VitTopChromeType.rootModule,
      title: 'Thị trường',
      subtitle: 'Theo dõi thị trường · Cập nhật $lastUpdatedLabel',
      // STEP-P2.2: keep HUB chrome only — «Ngành» is ẨN (deep link / overflow).
      actions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.overview,
          size: VitHeaderActionSize.sm,
          tooltip: 'Tổng quan thị trường',
          onPressed: () => onNavigate('/markets/overview'),
        ),
        VitHeaderActionItem(
          type: VitHeaderActionType.analytics,
          size: VitHeaderActionSize.sm,
          tooltip: 'Biến động',
          onPressed: () => onNavigate('/markets/movers'),
        ),
      ],
    );
  }
}
