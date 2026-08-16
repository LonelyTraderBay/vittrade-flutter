import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_autopilot_page.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_formatters.dart';

class ActionsTab extends StatelessWidget {
  const ActionsTab({
    super.key,
    required this.snapshot,
    required this.actionStatusFor,
    required this.onOpenAction,
    required this.onApprove,
    required this.onSkip,
  });

  final SavingsAutoPilotSnapshot snapshot;
  final SavingsAutoPilotActionStatus Function(SavingsAutoPilotActionDraft)
  actionStatusFor;
  final ValueChanged<SavingsAutoPilotActionDraft> onOpenAction;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onSkip;

  @override
  Widget build(BuildContext context) {
    final pending = snapshot.actions
        .where(
          (action) =>
              actionStatusFor(action) ==
              SavingsAutoPilotActionStatus.needsApproval,
        )
        .toList();

    return Column(
      key: SavingsAutoPilotPage.actionsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (pending.isNotEmpty) ...[
          SectionTitle(label: 'Cần phê duyệt (${pending.length})'),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final action in pending) ...[
            _ApprovalCard(
              action: action,
              onOpen: () => onOpenAction(action),
              onApprove: () => onApprove(action.id),
              onSkip: () => onSkip(action.id),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
        const SectionTitle(label: 'Lịch sử hành động'),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final action in snapshot.actions) ...[
          ActionTile(
            action: action,
            status: actionStatusFor(action),
            onTap: () => onOpenAction(action),
            showImpact: true,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({
    required this.action,
    required this.onOpen,
    required this.onApprove,
    required this.onSkip,
  });

  final SavingsAutoPilotActionDraft action;
  final VoidCallback onOpen;
  final VoidCallback onApprove;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final color = actionTypeColor(action.type);
    return VitCard(
      borderColor: AppColors.primary30,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconBadge(icon: actionTypeIcon(action.type), color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        SmallPill(
                          label: actionTypeLabel(action.type),
                          color: color,
                        ),
                        const SmallPill(
                          label: 'Cần duyệt',
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      action.title,
                      style: captionBoldStyle.copyWith(color: AppColors.text1),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      action.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: SavingsAutoPilotPage.skipActionKey,
                  onPressed: onSkip,
                  variant: VitCtaButtonVariant.ghost,
                  height: AppSpacing.buttonCompact,
                  leading: const Icon(Icons.close_rounded),
                  child: const Text('Bỏ qua'),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: VitCtaButton(
                  onPressed: onOpen,
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.buttonCompact,
                  leading: const Icon(Icons.visibility_outlined),
                  child: const Text('Xem'),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: VitCtaButton(
                  key: SavingsAutoPilotPage.approveActionKey,
                  onPressed: onApprove,
                  variant: VitCtaButtonVariant.success,
                  height: AppSpacing.buttonCompact,
                  leading: const Icon(Icons.check_circle_outline_rounded),
                  child: const Text('Duyệt'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.action,
    required this.status,
    required this.onTap,
    this.showImpact = false,
  });

  final SavingsAutoPilotActionDraft action;
  final SavingsAutoPilotActionStatus status;
  final VoidCallback onTap;
  final bool showImpact;

  @override
  Widget build(BuildContext context) {
    final typeColor = actionTypeColor(action.type);
    final statusColor = actionStatusColor(status);
    return VitCard(
      key: SavingsAutoPilotPage.actionKey(action.id),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      onTap: onTap,
      child: Row(
        children: [
          IconBadge(icon: actionTypeIcon(action.type), color: typeColor),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    SmallPill(
                      label: actionTypeLabel(action.type),
                      color: typeColor,
                    ),
                    SmallPill(
                      label: actionStatusLabel(status),
                      color: statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  action.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: captionBoldStyle.copyWith(color: AppColors.text1),
                ),
                Text(
                  action.timestamp,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          if (showImpact && action.impact.isNotEmpty)
            Flexible(
              child: Text(
                action.impact,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: microBoldStyle.copyWith(color: AppColors.buy),
              ),
            ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class ActionDetailSheet extends StatelessWidget {
  const ActionDetailSheet({
    super.key,
    required this.action,
    required this.status,
    required this.onApprove,
    required this.onSkip,
  });

  final SavingsAutoPilotActionDraft action;
  final SavingsAutoPilotActionStatus status;
  final VoidCallback? onApprove;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final typeColor = actionTypeColor(action.type);
    return SafeArea(
      top: false,
      child: VitSheetSurface(
        color: AppColors.surface,
        padding: EarnSpacingTokens.earnPaddingX5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                IconBadge(icon: actionTypeIcon(action.type), color: typeColor),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(action.title, style: captionBoldStyle),
                      Text(
                        action.timestamp,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                SmallPill(
                  label: actionStatusLabel(status),
                  color: actionStatusColor(status),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Text(
              action.description,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCard(
              variant: VitCardVariant.inner,
              padding: EarnSpacingTokens.earnPaddingX3,
              child: Column(
                children: [
                  for (final entry in action.details.entries)
                    Padding(
                      padding: EarnSpacingTokens.earnVerticalPaddingX1,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.key,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ),
                          Text(entry.value, style: captionBoldStyle),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (onApprove != null && onSkip != null) ...[
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
              Row(
                children: [
                  Expanded(
                    child: VitCtaButton(
                      onPressed: onSkip,
                      variant: VitCtaButtonVariant.secondary,
                      child: const Text('Bỏ qua'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: VitCtaButton(
                      onPressed: onApprove,
                      variant: VitCtaButtonVariant.success,
                      child: const Text('Phê duyệt'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
