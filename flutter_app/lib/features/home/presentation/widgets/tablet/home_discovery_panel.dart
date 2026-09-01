import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet discovery block: Prediction Markets and Open Arena as two rows of
/// ONE framed card, matching the sidebar's row idiom (one card surface, one
/// divider, one disclaimer) instead of two separately-styled gradient
/// cards. Product boundaries stay intact — Ví/PnL badge vs points-only
/// Arena badge and their separated copy.
class HomeDiscoveryPanel extends StatelessWidget {
  const HomeDiscoveryPanel({super.key, required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Dự đoán & Thách đấu',
          bottomGap: TabletSpacingTokens.x4,
        ),

        VitCard(
          padding: TabletSpacingTokens.zeroInsets,
          clip: true,
          child: Column(
            children: [
              _DiscoveryRow(
                icon: Icons.adjust_rounded,
                accentColor: AppColors.accent,
                title: 'Thị trường dự đoán',
                subtitle: 'Thị trường xác suất, vị thế và danh mục',
                badgeLabel: 'Ví / PnL',
                actionLabel: 'Khám phá',
                onTap: () => onNavigate('/markets/predictions'),
              ),
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                thickness: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
              _DiscoveryRow(
                icon: Icons.sports_esports_outlined,
                accentColor: AppColors.riskWarning,
                title: 'Arena',
                subtitle: 'Tạo chế độ chơi, mở phòng, dùng điểm Arena',
                badgeLabel: 'Chỉ điểm Arena',
                badgeStatus: VitStatusPillStatus.warning,
                actionLabel: 'Vào Arena',
                onTap: () => onNavigate('/arena'),
              ),
              const Divider(
                height: TabletSpacingTokens.dividerHairline,
                thickness: TabletSpacingTokens.dividerHairline,
                color: AppColors.divider,
              ),
              const Padding(
                padding: EdgeInsetsDirectional.all(TabletSpacingTokens.x4),
                child: VitRiskDisclaimerNote(
                  message:
                      'Dự đoán dùng vị thế thật. Arena chỉ dùng điểm (không phải tiền thật).',
                  semanticsLabel:
                      'Lưu ý rủi ro: Dự đoán dùng vị thế thật. Arena chỉ dùng điểm '
                      '(không phải tiền thật).',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DiscoveryRow extends StatelessWidget {
  const _DiscoveryRow({
    required this.icon,
    required this.accentColor,
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
    required this.actionLabel,
    required this.onTap,
    this.badgeStatus = VitStatusPillStatus.neutral,
  });

  final IconData icon;
  final Color accentColor;
  final String title;
  final String subtitle;
  final String badgeLabel;
  final VitStatusPillStatus badgeStatus;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconListRow(
      onTap: onTap,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: TabletSpacingTokens.x4,
        vertical: TabletSpacingTokens.x4,
      ),
      leading: VitAccentIconBox(icon: icon, color: accentColor),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(color: AppColors.text1),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VitStatusPill(
            label: badgeLabel,
            status: badgeStatus,
            size: VitStatusPillSize.sm,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Text(
            actionLabel,
            style: AppTextStyles.micro.copyWith(
              color: accentColor,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Icon(
            Icons.chevron_right_rounded,
            size: SharedSpacingTokens.homeSectionActionChevronSize,
            color: accentColor,
          ),
        ],
      ),
    );
  }
}
