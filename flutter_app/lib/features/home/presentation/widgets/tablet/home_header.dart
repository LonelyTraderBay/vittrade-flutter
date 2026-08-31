import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet Home header as a command bar: brand on the left, a real search
/// field in the middle (tap opens the global search route — the tablet has
/// the width for a visible affordance instead of a collapsed icon), global
/// actions on the right.
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
      body: Row(
        children: [
          Text(
            'VitTrade',
            style: AppTextStyles.pageTitle.copyWith(color: AppColors.text1),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: GestureDetector(
                onTap: () => onNavigate('/search'),
                child: Semantics(
                  button: true,
                  label: 'Tìm kiếm toàn cục',
                  child: const IgnorePointer(
                    child: VitSearchBar(
                      placeholder: 'Tìm kiếm sản phẩm, cặp giao dịch...',
                      enabled: false,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
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
