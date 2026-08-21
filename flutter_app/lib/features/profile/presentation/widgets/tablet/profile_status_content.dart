import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Mirrors the loaded Profile dashboard — banner: account strip; primary:
/// the account menu sections; sidebar: Prediction/Arena summary and product
/// shortcuts — through the same shared scaffold, so resolving data never
/// reflows the page shape (including the single-column → two-column switch
/// at the dashboard's own threshold).
class ProfileLoadingContent extends StatelessWidget {
  const ProfileLoadingContent({super.key, this.onRefresh});

  final RefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return VitTwoColumnTabletDashboard(
      banner: const _AccountStripSkeleton(key: ProfileTabletKeys.loading),
      onRefresh: onRefresh,
      primaryChildren: const [
        VitSectionSkeleton(),
        SizedBox(height: AppSpacing.pageRhythmCompactSectionGap),
        VitSectionSkeleton(),
      ],
      secondaryChildren: const [
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

/// One wide card holding the identity row plus the trailing UID/referral/
/// KYC/VIP blocks.
class _AccountStripSkeleton extends StatelessWidget {
  const _AccountStripSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const VitCard(
      radius: VitCardRadius.standard,
      clip: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: _IdentitySkeleton()),
          SizedBox(width: AppSpacing.x3),
          Expanded(flex: 2, child: _StripValueSkeleton()),
          SizedBox(width: AppSpacing.x3),
          Expanded(flex: 2, child: _StripValueSkeleton()),
          SizedBox(width: AppSpacing.x3),
          Expanded(flex: 2, child: _StripValueSkeleton()),
          SizedBox(width: AppSpacing.x3),
          Expanded(flex: 3, child: _StripValueSkeleton()),
        ],
      ),
    );
  }
}

class _IdentitySkeleton extends StatelessWidget {
  const _IdentitySkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        VitSkeleton(width: 48, height: 48),
        SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitSkeleton(width: double.infinity, height: 14),
              SizedBox(height: AppSpacing.x1),
              VitSkeleton(width: double.infinity, height: 10),
            ],
          ),
        ),
      ],
    );
  }
}

class _StripValueSkeleton extends StatelessWidget {
  const _StripValueSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VitSkeleton(width: double.infinity, height: 12),
        SizedBox(height: AppSpacing.x1),
        VitSkeleton(width: double.infinity, height: 16),
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
