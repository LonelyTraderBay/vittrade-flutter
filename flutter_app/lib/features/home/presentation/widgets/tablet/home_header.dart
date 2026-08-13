import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.notifications,
    required this.onNavigate,
  });

  final int notifications;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return VitTopChrome(
      type: VitTopChromeType.rootBrand,
      title: 'VitTrade',
      actions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.search,
          tooltip: 'Tìm kiếm toàn cục',
          onPressed: () => onNavigate('/search'),
        ),
        VitHeaderActionItem(
          type: VitHeaderActionType.notifications,
          tooltip: 'Thông báo',
          badgeCount: notifications,
          onPressed: () => onNavigate('/notifications'),
        ),
        VitHeaderActionItem(
          type: VitHeaderActionType.news,
          tooltip: 'Tin tức',
          onPressed: () => onNavigate('/news'),
        ),
      ],
    );
  }
}
