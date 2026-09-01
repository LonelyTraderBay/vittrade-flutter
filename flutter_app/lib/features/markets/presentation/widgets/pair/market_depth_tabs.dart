import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/app_surface_spacing.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/pair/market_depth_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketDepthTabs extends StatelessWidget {
  const MarketDepthTabs({
    required this.activeTab,
    required this.onChanged,
    super.key,
  });

  final String activeTab;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: SizedBox(
        height: MarketsSpacingTokens.marketDepthTabsHeight,
        child: Column(
          children: [
            Expanded(
              child: VitTabBar(
                activeKey: activeTab,
                variant: VitTabBarVariant.underline,
                onChanged: onChanged,
                tabs: const [
                  VitTabItem(
                    key: 'depth',
                    label: 'Biểu đồ độ sâu',
                    widgetKey: marketDepthChartTabKey,
                  ),
                  VitTabItem(
                    key: 'orderBook',
                    label: 'Sổ lệnh',
                    widgetKey: marketDepthOrderBookTabKey,
                  ),
                  VitTabItem(
                    key: 'whale',
                    label: 'Lệnh cá voi',
                    widgetKey: marketDepthWhaleAlertTabKey,
                  ),
                ],
              ),
            ),
            Divider(
              height: AppSurfaceSpacing.dividerHairline,
              color: AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }
}
