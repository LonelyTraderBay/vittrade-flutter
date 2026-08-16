import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

class ArenaGovernanceStateBanner extends StatelessWidget {
  const ArenaGovernanceStateBanner({super.key, required this.state});

  final ArenaGovernanceActionState state;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppModuleAccents.arena.withValues(alpha: .24),
      padding: ArenaSpacingTokens.arenaStateCardPaddingCompact,
      child: _StateRow(
        icon: Icons.rule_folder_outlined,
        title: 'Governance state',
        description: state.boundaryNote,
        trailing: state.canContinue ? 'Ready' : 'Needs rules',
        color: AppModuleAccents.arena,
      ),
    );
  }
}

class ArenaReportReviewStateCard extends StatelessWidget {
  const ArenaReportReviewStateCard({super.key, required this.state});

  final ArenaReportReviewState state;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: state.canAppeal
          ? AppColors.warningBorder
          : AppColors.borderSolid,
      padding: ArenaSpacingTokens.arenaStateCardPaddingCompact,
      child: _StateRow(
        icon: Icons.gavel_outlined,
        title: state.title,
        description: state.description,
        trailing: state.statusLabel,
        color: state.canAppeal ? AppColors.warn : AppColors.buy,
      ),
    );
  }
}

class ArenaChallengePointsReviewCard extends StatelessWidget {
  const ArenaChallengePointsReviewCard({super.key, required this.review});

  final ArenaChallengePointsReview review;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppModuleAccents.arena.withValues(alpha: .26),
      padding: ArenaSpacingTokens.arenaStateCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StateRow(
            icon: Icons.stars_outlined,
            title: 'Points-only review',
            description: review.boundaryNote,
            trailing: 'Arena',
            color: AppModuleAccents.arena,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _MetricRow(label: 'Entry point cost', value: review.entryPointsLabel),
          _MetricRow(label: 'Points pool', value: review.poolLabel),
          _MetricRow(label: 'Net Points pool', value: review.netPoolLabel),
          _MetricRow(label: 'Rule fees', value: review.feeLabel),
        ],
      ),
    );
  }
}

class _StateRow extends StatelessWidget {
  const _StateRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.trailing,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String description;
  final String trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: ShapeDecoration(
            color: color.withValues(alpha: .12),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.mdRadius,
            ),
          ),
          child: Padding(
            padding: ArenaSpacingTokens.arenaStateCardIconPadding,
            child: Icon(
              icon,
              color: color,
              size: ArenaSpacingTokens.arenaStateCardIcon,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: ArenaSpacingTokens.arenaStateCardBodyLineHeight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        _StatePill(label: trailing, color: color),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaStateCardMetricPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatePill extends StatelessWidget {
  const _StatePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: Padding(
        padding: ArenaSpacingTokens.arenaStateCardPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
