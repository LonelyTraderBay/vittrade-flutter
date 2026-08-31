import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
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
      // Flat children: the scaffold's rhythm already inserts the section
      // gap between blocks — a manual SizedBox separator here stacks onto
      // it (13+13+13=39dp) and is flagged by tablet_spacing_audit S4.
      children: const [
        _AccountHeroSkeleton(),
        ProfileSecuritySummarySkeleton(),
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
              SizedBox(width: TabletSpacingTokens.x4),
              VitSkeleton(width: 72, height: 14),
            ],
          ),
          SizedBox(height: TabletSpacingTokens.x4),
          VitSkeleton(width: double.infinity, height: 7),
          SizedBox(height: TabletSpacingTokens.x4),
          VitSkeleton(
            width: double.infinity,
            height: TabletSpacingTokens.buttonCompact,
          ),
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
                        SizedBox(width: TabletSpacingTokens.x4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VitSkeleton(width: double.infinity, height: 20),
                              SizedBox(height: TabletSpacingTokens.x4),
                              VitSkeleton(width: 180, height: 10),
                              SizedBox(height: TabletSpacingTokens.x4),
                              VitSkeleton(width: 140, height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: TabletSpacingTokens.x4),
                    Row(
                      children: [
                        VitSkeleton(width: 64, height: 22),
                        SizedBox(width: TabletSpacingTokens.x4),
                        VitSkeleton(width: 88, height: 22),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _FactBoxSkeleton(),
                    SizedBox(height: TabletSpacingTokens.x4),
                    _FactBoxSkeleton(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: TabletSpacingTokens.pageRhythmStandardSectionGap),
          VitSkeleton(width: double.infinity, height: TabletSpacingTokens.x3),
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
        SizedBox(height: TabletSpacingTokens.x4),
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
        VitSkeleton(width: 140, height: TabletSpacingTokens.x4),
        SizedBox(height: TabletSpacingTokens.x4),
        VitCard(child: VitSkeletonList(rows: 4)),
      ],
    );
  }
}
