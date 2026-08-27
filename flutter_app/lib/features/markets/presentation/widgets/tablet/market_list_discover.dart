import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/markets/presentation/widgets/tablet/market_list_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/markets_spacing_tokens.dart';

class MarketListDiscoverMoreSection extends StatelessWidget {
  const MarketListDiscoverMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Section header do trang sở hữu (VitPageSection ở markets_tablet_page)
    // — mọi section của pane tổng quan dùng một idiom header duy nhất.
    return VitCard(
      clip: true,
      padding: AppSpacing.zeroInsets,
      child: Column(
        children: [
          _DiscoverRow(
            icon: Icons.gps_fixed_rounded,
            title: 'Dự đoán thị trường',
            subtitle: 'Lối tắt từ Markets · Xác suất · Vị thế',
            badge: 'Lối tắt',
            color: marketListPredictionAccent,
            onTap: () => context.go(AppRoutePaths.marketsPredictions),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            thickness: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          _DiscoverRow(
            icon: Icons.sports_esports_outlined,
            title: 'Open Arena',
            subtitle: 'Lối tắt từ Markets · ưu tiên Home · Điểm Arena',
            badge: 'Lối tắt',
            color: marketListArenaAccent,
            onTap: () => context.go(AppRoutePaths.arena),
          ),
        ],
      ),
    );
  }
}

class _DiscoverRow extends StatelessWidget {
  const _DiscoverRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: MarketsSpacingTokens.marketDiscoverRowPadding,
          child: Row(
            children: [
              Material(
                // Surface lồng trong card 16 — quy tắc khung lồng: radius con
                // = radius cha − 8 ⇒ smRadius (mdRadius còn deprecated).
                color: color.withValues(alpha: 0.12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
                child: SizedBox(
                  width: MarketsSpacingTokens.marketDiscoverIconBox,
                  height: MarketsSpacingTokens.marketDiscoverIconBox,
                  child: Icon(
                    icon,
                    color: color,
                    size: MarketsSpacingTokens.marketDiscoverIcon,
                  ),
                ),
              ),
              const SizedBox(width: MarketsSpacingTokens.marketDiscoverRowGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width:
                              MarketsSpacingTokens.marketDiscoverTitleBadgeGap,
                        ),
                        VitAccentPill(label: badge, accentColor: color),
                      ],
                    ),
                    const SizedBox(
                      height: MarketsSpacingTokens.marketDiscoverSubtitleGap,
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: MarketsSpacingTokens.marketDiscoverChevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
