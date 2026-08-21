import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Mirrors the loaded Profile overview pane — identity hero, security score
/// block, Prediction/Arena summary and product shortcuts in one scrolling
/// column — through the same pane scaffold, so resolving data never reflows
/// the pane shape while the master menu stays framed beside it.
class ProfileLoadingContent extends StatelessWidget {
  const ProfileLoadingContent({super.key, this.onRefresh});

  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return ProfilePaneScaffold(
      scrollKey: ProfileTabletKeys.loading,
      onRefresh: onRefresh,
      rhythm: VitPageRhythm.standard,
      children: const [
        _AccountHeroSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        ProfileSecuritySummarySkeleton(),
        SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitSectionSkeleton(),
      ],
    );
  }
}

/// Mirrors [ProfileSecuritySummary] while the security snapshot resolves —
/// same block slot so the pane doesn't reflow when data lands.
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

/// Identity hero card skeleton — avatar + name/email lines + pill row + the
/// trailing UID/referral fact boxes and the VIP runway.
class _AccountHeroSkeleton extends StatelessWidget {
  const _AccountHeroSkeleton();

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

/// Mirrors a `VitPageSection`: heading bar + a card of menu rows. Also used
/// by the master-detail shell's menu column while the profile snapshot
/// resolves.
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
