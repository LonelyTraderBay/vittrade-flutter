import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_icon_registry.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet dashboard equivalent of Profile's private `_ProfileProductHub`
/// (`profile_home_menu_actions.dart`, phone-only — not importable outside
/// `profile_page.dart`'s `part` family). Same product/service shortcut
/// grid, built as its own public widget so a future `ProfileTabletPage`
/// (SC-156) can place it without touching the pinned phone reference.
class ProfileProductHubPanel extends StatelessWidget {
  const ProfileProductHubPanel({super.key, required this.shortcuts});

  final List<ProfileProductShortcut> shortcuts;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth =
            (constraints.maxWidth - TabletSpacingTokens.cardGap) / 2;
        return Wrap(
          key: ProfileTabletKeys.productHub,
          spacing: TabletSpacingTokens.cardGap,
          runSpacing: TabletSpacingTokens.cardGap,
          children: [
            for (final shortcut in shortcuts)
              SizedBox(
                width: tileWidth,
                child: _ProfileProductTile(shortcut: shortcut),
              ),
          ],
        );
      },
    );
  }
}

class _ProfileProductTile extends StatelessWidget {
  const _ProfileProductTile({required this.shortcut});

  final ProfileProductShortcut shortcut;

  @override
  Widget build(BuildContext context) {
    final accent = Color(shortcut.accentHex);
    return VitCard(
      key: ProfileTabletKeys.productShortcut(shortcut.id),
      onTap: () => context.push(shortcut.route),
      density: VitDensity.compact,
      borderColor: accent.withValues(alpha: .22),
      child: VitIconListRow(
        gap: TabletSpacingTokens.x3,
        leading: SizedBox(
          width: ProfileSpacingTokens.profileProductIconBox,
          height: ProfileSpacingTokens.profileProductIconBox,
          child: Material(
            color: accent.withValues(alpha: .12),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.cardRadius,
            ),
            child: Icon(
              profileIconFor(shortcut.iconKey),
              color: accent,
              size: ProfileSpacingTokens.profileProductIcon,
            ),
          ),
        ),
        title: Text(
          shortcut.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        subtitle: Text(
          shortcut.stateLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.badge.copyWith(color: accent),
        ),
      ),
    );
  }
}
