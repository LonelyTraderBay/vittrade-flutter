import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_input_states.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_navigation.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_icon_registry.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet-dashboard public port of Profile's private `_MenuSection`
/// (`profile_home_menu_actions.dart`, phone-only — not importable outside
/// `profile_page.dart`'s `part` family). Same grouped, navigable menu rows
/// (already built on the shared [VitIconListRow] primitive); in the
/// master-detail shell, [selectedRoute] tints the row whose route currently
/// renders in the detail pane.
class ProfileMenuPanel extends StatelessWidget {
  const ProfileMenuPanel({
    super.key,
    required this.section,
    this.selectedRoute,
  });

  final ProfileMenuSection section;
  final String? selectedRoute;

  @override
  Widget build(BuildContext context) {
    final accent = Color(section.accentHex);
    return VitCard(
      borderColor: AppColors.cardBorder,
      clip: true,
      child: Column(
        children: [
          for (final item in section.items) ...[
            _MenuRow(
              item: item,
              accent: accent,
              selected: item.route == selectedRoute,
            ),
            if (item != section.items.last)
              const Divider(
                height: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.item,
    required this.accent,
    this.selected = false,
  });

  final ProfileMenuItem item;
  final Color accent;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? accent.withValues(alpha: .08) : AppColors.transparent,
      child: InkWell(
        key: ProfileTabletKeys.menu(item.id),
        onTap: () => openProfileDetailRoute(context, item.route),
        hoverColor: AppInputStates.hoverOverlay,
        focusColor: AppInputStates.focusOverlay,
        child: VitIconListRow(
          minHeight: VitDensity.standard.controlHeight,
          padding: ProfileSpacingTokens.profileMenuRowPadding,
          gap: ProfileSpacingTokens.profileMenuGap,
          subtitleGap: AppSpacing.pageRhythmCompactInnerGap,
          leading: SizedBox(
            width: ProfileSpacingTokens.profileMenuIconBox,
            height: ProfileSpacingTokens.profileMenuIconBox,
            child: Material(
              color: accent.withValues(alpha: .12),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.cardRadius,
              ),
              child: Icon(
                profileIconFor(item.iconKey),
                color: accent,
                size: ProfileSpacingTokens.profileMenuIcon,
              ),
            ),
          ),
          title: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          subtitle: item.subtitle == null
              ? null
              : Text(
                  item.subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: item.subtitleHex == null
                        ? AppColors.text3
                        : Color(item.subtitleHex!),
                  ),
                ),
          // No trailing chevron — iPad-Settings sidebar semantics: the
          // menu list itself is the affordance, and dropping the chevron
          // hands its 34dp (icon + gap) back to the labels so the slim
          // 300dp master keeps every label un-ellipsized.
        ),
      ),
    );
  }
}
