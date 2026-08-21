import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Mirrors the loaded Profile dashboard — banner: identity hero; primary:
/// the account menu sections; sidebar: security score, Prediction/Arena
/// summary and product shortcuts — through the same shared scaffold, so
/// resolving data never reflows the page shape (including the
/// single-column → two-column switch at the dashboard's own threshold).
class ProfileLoadingContent extends StatelessWidget {
  const ProfileLoadingContent({super.key, this.onRefresh});

  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return VitTwoColumnTabletDashboard(
      banner: const _AccountHeroSkeleton(key: ProfileTabletKeys.loading),
      onRefresh: onRefresh,
      primaryChildren: const [
        VitSectionSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        VitSectionSkeleton(),
      ],
      secondaryChildren: const [
        ProfileSecuritySummarySkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        _SidebarHeadingSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _SidebarCardSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        _SidebarHeadingSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        _SidebarCardSkeleton(),
      ],
      primaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
      secondaryContentGap: AppSpacing.pageRhythmCompactSectionGap,
    );
  }
}

/// Mirrors [ProfileSecuritySummary] while the security snapshot resolves —
/// same card slot so the sidebar doesn't reflow when data lands.
class ProfileSecuritySummarySkeleton extends StatelessWidget {
  const ProfileSecuritySummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: VitSkeleton(width: double.infinity, height: 14)),
              SizedBox(width: AppSpacing.x3),
              VitSkeleton(width: 72, height: 14),
            ],
          ),
          SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitSkeleton(width: double.infinity, height: 7),
          SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitSkeleton(width: double.infinity, height: AppSpacing.buttonCompact),
        ],
      ),
    );
  }
}

/// One wide hero card holding the identity block plus the trailing
/// UID/referral fact boxes and the VIP runway.
class _AccountHeroSkeleton extends StatelessWidget {
  const _AccountHeroSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const VitCard(
      radius: VitCardRadius.large,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        VitSkeleton(
                          width: ProfileSpacingTokens.profileHeroAvatar,
                          height: ProfileSpacingTokens.profileHeroAvatar,
                        ),
                        SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VitSkeleton(width: double.infinity, height: 20),
                              SizedBox(height: AppSpacing.x1),
                              VitSkeleton(width: 180, height: 10),
                              SizedBox(height: AppSpacing.x1),
                              VitSkeleton(width: 140, height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                    Row(
                      children: [
                        VitSkeleton(width: 64, height: 22),
                        SizedBox(width: AppSpacing.pageRhythmStandardInnerGap),
                        VitSkeleton(width: 88, height: 22),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.x4),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FactBoxSkeleton(),
                    SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                    _FactBoxSkeleton(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitSkeleton(width: double.infinity, height: AppSpacing.x3),
        ],
      ),
    );
  }
}

class _FactBoxSkeleton extends StatelessWidget {
  const _FactBoxSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitSkeleton(width: 80, height: 10),
        SizedBox(height: AppSpacing.x1),
        VitSkeleton(width: double.infinity, height: 14),
      ],
    );
  }
}

/// Mirrors a `VitPageSection`: heading bar + a card of menu rows.
class VitSectionSkeleton extends StatelessWidget {
  const VitSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSkeleton(width: 140, height: AppSpacing.x4),
        SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCard(child: VitSkeletonList(rows: 4)),
      ],
    );
  }
}

class _SidebarHeadingSkeleton extends StatelessWidget {
  const _SidebarHeadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return const VitSkeleton(width: 160, height: AppSpacing.x4);
  }
}

class _SidebarCardSkeleton extends StatelessWidget {
  const _SidebarCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const VitCard(child: VitSkeletonList(rows: 2));
  }
}
