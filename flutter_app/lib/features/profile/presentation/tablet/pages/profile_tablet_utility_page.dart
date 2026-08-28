import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/profile/presentation/tablet/widgets/profile_tablet_utility_surface.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Placeholder pane for Profile sub-flows that still await their real tablet
/// port. A single hero card carries the route's topic icon and business
/// description plus a completion note — no static facts, fake CTA flows, or
/// duplicate confirmation scaffolding; those arrive with each pane's real
/// port (see ProfileKycPane for the reference composition).
class ProfileTabletUtilityPage extends StatelessWidget {
  const ProfileTabletUtilityPage({
    super.key,
    required this.semanticIdentifier,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
  });

  final String semanticIdentifier;
  final String title;
  final String subtitle;
  final String description;

  /// Topic icon for this route — mirrors the icon the account menu row uses
  /// for the same destination.
  final IconData icon;

  Key get contentKey => Key('$semanticIdentifier-tablet-content');

  @override
  Widget build(BuildContext context) {
    return ProfileTabletUtilitySurface(
      title: title,
      subtitle: subtitle,
      semanticIdentifier: '$semanticIdentifier-TABLET',
      semanticLabel: '$title trên tablet',
      contentKey: contentKey,
      onBack: () => context.go(AppRoutePaths.profile),
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          child: Row(
            // AIB-R6: khối mô tả căn giữa dọc theo ô icon.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // AIB-R6: icon leading cạnh mô tả nhiều dòng phải nằm trong
              // VitAccentIconBox — icon trần trông nhỏ so với khối chữ.
              VitAccentIconBox(icon: icon, color: AppColors.primary),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      'Trình quản lý đầy đủ cho mục này đang được hoàn thiện.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
