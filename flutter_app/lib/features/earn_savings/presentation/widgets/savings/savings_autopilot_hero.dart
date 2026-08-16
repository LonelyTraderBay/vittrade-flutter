import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_autopilot_page.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_formatters.dart';

class AutoPilotHero extends StatelessWidget {
  const AutoPilotHero({
    super.key,
    required this.snapshot,
    required this.mode,
    required this.status,
    required this.monthlyBudgetUsd,
    required this.executedCount,
    required this.pendingCount,
    required this.onToggleStatus,
  });

  final SavingsAutoPilotSnapshot snapshot;
  final SavingsAutoPilotModeDraft mode;
  final SavingsAutoPilotStatus status;
  final int monthlyBudgetUsd;
  final int executedCount;
  final int pendingCount;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    final statusColor = autoPilotStatusColor(status);
    return VitCard(
      key: SavingsAutoPilotPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology_alt_rounded,
                color: statusColor,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                  ),
                ),
              ),
              _StatusButton(status: status, onPressed: onToggleStatus),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chế độ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      mode.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: toneColor(mode.tone),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Ngân sách/tháng',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.portfolioTextMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    formatAutoPilotMoney(monthlyBudgetUsd),
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroStat(label: 'Hành động', value: '$executedCount'),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  label: 'Cần duyệt',
                  value: '$pendingCount',
                  valueColor: pendingCount > 0 ? AppColors.primary : null,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroStat(
                  label: 'APY tăng',
                  value: '+10.1%',
                  valueColor: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({required this.status, required this.onPressed});

  final SavingsAutoPilotStatus status;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      key: SavingsAutoPilotPage.statusButtonKey,
      label: autoPilotStatusLabel(status),
      icon: autoPilotStatusIcon(status),
      status: autoPilotStatusPillStatus(status),
      size: VitStatusPillSize.md,
      onTap: onPressed,
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.base.copyWith(
              color: valueColor ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}
