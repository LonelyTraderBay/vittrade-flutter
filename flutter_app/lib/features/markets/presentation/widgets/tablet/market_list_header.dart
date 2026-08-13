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
      title: 'Th\u1ECB tr\u01B0\u1EDDng',
      subtitle:
          'Theo d\u00F5i th\u1ECB tr\u01B0\u1EDDng \u00B7 C\u1EADp nh\u1EADt $lastUpdatedLabel',
      // STEP-P2.2: keep HUB chrome only — «Ngành» is ẨN (deep link / overflow).
      actions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.overview,
          size: VitHeaderActionSize.sm,
          tooltip: 'T\u1ED5ng quan th\u1ECB tr\u01B0\u1EDDng',
          onPressed: () => onNavigate('/markets/overview'),
        ),
        VitHeaderActionItem(
          type: VitHeaderActionType.analytics,
          size: VitHeaderActionSize.sm,
          tooltip: 'Bi\u1EBFn \u0111\u1ED9ng',
          onPressed: () => onNavigate('/markets/movers'),
        ),
      ],
    );
  }
}
