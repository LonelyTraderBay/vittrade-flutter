import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';

/// Tablet-only detail frame for Wallet money-movement flows.
///
/// It owns the wide-screen column relationship. The Phone pages do not import
/// this boundary; data, controllers and financial contracts remain shared.
///
/// [footer] là dải ghim dưới khối hai cột (không cuộn — idiom
/// `MarketsPaneScaffold.footer`): dùng cho CTA hoàn tất flow luôn nhìn thấy.
/// Null = không có dải ghim.
class WalletTabletDetailSurface extends StatelessWidget {
  const WalletTabletDetailSurface({
    super.key,
    required this.semanticLabel,
    required this.semanticIdentifier,
    required this.title,
    required this.subtitle,
    required this.primary,
    required this.secondary,
    required this.onBack,
    this.footer,
  });

  final String semanticLabel;
  final String semanticIdentifier;
  final String title;
  final String subtitle;
  final Widget primary;
  final Widget secondary;
  final VoidCallback onBack;
  final Widget? footer;

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
          ),
          Expanded(
            child: VitTwoColumnTabletDashboard(
              primaryChildren: [primary],
              secondaryChildren: [secondary],
            ),
          ),
          if (footer != null) ...[
            const Divider(
              height: TabletSpacingTokens.dividerHairline,
              color: AppColors.divider,
            ),
            footer!,
          ],
        ],
      ),
    );
  }
}
