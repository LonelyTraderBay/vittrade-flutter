import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_portfolio_page.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_portfolio_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_portfolio_formatters.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class PortfolioHero extends StatelessWidget {
  const PortfolioHero({
    super.key,
    required this.snapshot,
    required this.hideBalance,
    required this.onToggleBalance,
  });

  final SavingsPortfolioSnapshot snapshot;
  final bool hideBalance;
  final VoidCallback onToggleBalance;

  @override
  Widget build(BuildContext context) {
    final balance = hideBalance ? '••••••' : snapshot.totalDepositedUsd;
    final gain = hideBalance ? '••••' : snapshot.gainLabel;

    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: savingsPortfolioCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tổng tiết kiệm (USD)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextDim,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _HeroIconButton(
                icon: hideBalance
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                onPressed: onToggleBalance,
              ),
              const SizedBox(width: AppSpacing.x2),
              _HeroIconButton(
                icon: Icons.refresh_rounded,
                onPressed: () => HapticFeedback.selectionClick(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            balance,
            style: AppTextStyles.numericDisplayLg.copyWith(
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x3,
            runSpacing: AppSpacing.x1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              DecoratedBox(
                decoration: const ShapeDecoration(
                  color: AppColors.buy15,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.mdRadius,
                  ),
                ),
                child: Padding(
                  padding: EarnSpacingTokens.earnPillPadding,
                  child: Text(
                    gain,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ),
              Text(
                'lãi tích lũy',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'Linh hoạt',
                  value: hideBalance ? '••••' : snapshot.flexibleTotalUsd,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'Cố định',
                  value: hideBalance ? '••••' : snapshot.lockedTotalUsd,
                  valueColor: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(child: _HeroPositionStat(snapshot: snapshot)),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroAction(
                  label: 'Gửi thêm',
                  icon: Icons.arrow_downward_rounded,
                  primary: true,
                  onTap: () => context.go(snapshot.savingsRoute),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  label: 'Rút',
                  icon: Icons.arrow_upward_rounded,
                  onTap: () => context.go(snapshot.savingsRoute),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  key: SavingsPortfolioPage.historyButtonKey,
                  label: 'Lịch sử',
                  icon: Icons.schedule_rounded,
                  onTap: () => context.go(snapshot.historyRoute),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroIconButton extends StatelessWidget {
  const _HeroIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      icon: icon,
      tooltip: 'Thao tác danh mục',
      onPressed: onPressed,
      variant: VitIconButtonVariant.ghost,
      size: VitIconButtonSize.sm,
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.portfolioBtnGhost,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.portfolioBtnGhostBorder),
        ),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPositionStat extends StatelessWidget {
  const _HeroPositionStat({required this.snapshot});

  final SavingsPortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.portfolioBtnGhost,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.portfolioBtnGhostBorder),
        ),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnPaddingX3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vị thế',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextMuted,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Row(
              children: [
                const TinyDot(color: AppColors.buy),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  '${snapshot.activePositions}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                const TinyDot(color: AppColors.warn),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  '${snapshot.maturingPositions}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      variant: primary
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.secondary,
      density: VitDensity.compact,
      padding: EarnSpacingTokens.earnHorizontalPaddingX2,
      onPressed: () {
        unawaited(HapticFeedback.selectionClick());
        onTap();
      },
      leading: Icon(icon),
      child: Text(label),
    );
  }
}
