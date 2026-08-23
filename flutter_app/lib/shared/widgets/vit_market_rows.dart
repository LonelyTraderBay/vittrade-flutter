import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_input_states.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sparkline.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';

/// Price/metric movement direction used to color trend indicators.
enum VitTrendDirection { positive, negative, neutral }

/// Foreground/background colors for a [VitTrendDirection].
extension VitTrendDirectionColors on VitTrendDirection {
  Color get foreground {
    return switch (this) {
      VitTrendDirection.positive => AppColors.buy,
      VitTrendDirection.negative => AppColors.sell,
      VitTrendDirection.neutral => AppColors.text3,
    };
  }

  Color get background {
    return switch (this) {
      VitTrendDirection.positive => AppColors.buy10,
      VitTrendDirection.negative => AppColors.sell10,
      VitTrendDirection.neutral => AppColors.surface2,
    };
  }
}

/// A market list row: leading icon, title/subtitle, optional sparkline, and
/// trailing price + trend-colored change label.
class VitMarketPairRow extends StatelessWidget {
  const VitMarketPairRow({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.changeLabel,
    required this.trend,
    this.sparkline,
    this.onTap,
    this.showSparkline = true,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final String price;
  final String changeLabel;
  final VitTrendDirection trend;
  final List<double>? sparkline;
  final VoidCallback? onTap;
  final bool showSparkline;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: SharedSpacingTokens.homeSectionHorizontalPadding,
        vertical: SharedSpacingTokens.homeSectionVerticalPadding,
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: SharedSpacingTokens.homeMarketIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          if (showSparkline && sparkline != null) ...[
            SizedBox(
              width: SharedSpacingTokens.homeSparklineWidth,
              height: SharedSpacingTokens.homeSparklineHeight,
              child: VitSparkline(values: sparkline!, color: trend.foreground),
            ),
            const SizedBox(width: SharedSpacingTokens.homeMarketIconGap),
          ],
          SizedBox(
            width: SharedSpacingTokens.homeRankedValueColumnWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.medium,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  changeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: trend.foreground,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      hoverColor: AppInputStates.hoverOverlay,
      focusColor: AppInputStates.focusOverlay,
      child: content,
    );
  }
}
