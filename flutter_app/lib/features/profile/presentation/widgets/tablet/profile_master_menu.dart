import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/auth_controller_providers.dart';
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/profile/domain/entities/profile_entities.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_account_footer_actions.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_legal_accordion_panel.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_navigation.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_menu_panel.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Master (left) column of the Profile tablet master-detail shell: the
/// account menu groups plus the activity/logout/footer actions that used to
/// live in the dashboard's primary column. Navigating stays route-based —
/// rows open detail panes with iPad-Settings back semantics; the shell's
/// StatefulShellRoute is what makes the destination render into the detail
/// pane beside this menu instead of replacing the page. A compact identity line (no avatar — the
/// overview pane's hero already carries it) keeps tier context visible while
/// a sub-pane is open.
class ProfileMasterMenu extends ConsumerWidget {
  const ProfileMasterMenu({
    super.key,
    required this.snapshot,
    this.selectedRoute,
  });

  final ProfileSnapshot snapshot;

  /// The route currently rendered in the detail pane — the matching menu row
  /// is tinted as selected.
  final String? selectedRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = snapshot.user;

    return VitPageContent(
      rhythm: VitPageRhythm.compact,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                user.fullName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        Wrap(
          key: const Key('sc156_profile_master_pills'),
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x1,
          children: [
            VitAccentPill(
              label: user.vipLevel,
              accentColor: AppColors.medalGold,
            ),
            VitAccentPill(
              label: 'KYC ${user.kycLevel}',
              accentColor: user.kycNeedsAction
                  ? AppColors.riskWarning
                  : AppColors.buy,
            ),
          ],
        ),
        for (final section in snapshot.sections) ...[
          VitPageSection(
            label: section.label,
            accentColor: Color(section.accentHex),
            headerVariant: VitSectionHeaderVariant.accentBar,
            headerDensity: VitDensity.compact,
            innerGap: AppSpacing.pageRhythmCompactInnerGap,
            children: [
              if (section.id == 'legal')
                const ProfileLegalAccordionPanel()
              else
                ProfileMenuPanel(
                  section: section,
                  selectedRoute: selectedRoute,
                ),
            ],
          ),
        ],
        ProfileActivityButton(
          onTap: () =>
              openProfileDetailRoute(context, AppRoutePaths.profileActivity),
        ),
        ProfileLogoutButton(
          onTap: () async {
            final navContext = context;
            await ref.read(authSessionControllerProvider.notifier).logout();
            if (navContext.mounted) navContext.go(AppRoutePaths.authLogin);
          },
        ),
        Text(
          'VitTrade v2.4.1',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}
