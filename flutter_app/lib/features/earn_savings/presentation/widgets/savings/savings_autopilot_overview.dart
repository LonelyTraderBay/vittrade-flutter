import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_autopilot_page.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_actions.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_formatters.dart';

class AutoPilotTabs extends StatelessWidget {
  const AutoPilotTabs({
    super.key,
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: Column(
        children: [
          Padding(
            padding: EarnSpacingTokens.earnHorizontalPaddingX4,
            child: VitTabBar(
              variant: VitTabBarVariant.underline,
              activeKey: active,
              onChanged: onChanged,
              tabs: [
                for (final tab in tabs)
                  VitTabItem(key: tab.id, label: tab.label),
              ],
            ),
          ),
          const Divider(height: AppSpacing.dividerHairline),
        ],
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key,
    required this.snapshot,
    required this.moduleStates,
    required this.onOpenModule,
    required this.onShowActions,
    required this.actionStatusFor,
    required this.onOpenAction,
  });

  final SavingsAutoPilotSnapshot snapshot;
  final Map<String, bool> moduleStates;
  final ValueChanged<String> onOpenModule;
  final VoidCallback onShowActions;
  final SavingsAutoPilotActionStatus Function(SavingsAutoPilotActionDraft)
  actionStatusFor;
  final ValueChanged<SavingsAutoPilotActionDraft> onOpenAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsAutoPilotPage.modulesKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MetricGrid(metrics: snapshot.metrics),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        const SectionTitle(label: 'Modules đang hoạt động'),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final module in snapshot.modules) ...[
          _ModuleTile(
            module: module,
            enabled: moduleStates[module.id] ?? module.enabled,
            onTap: () => onOpenModule(module.route),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        const SectionTitle(label: 'Hành động gần đây'),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final action in snapshot.actions.take(3)) ...[
          ActionTile(
            action: action,
            status: actionStatusFor(action),
            onTap: () => onOpenAction(action),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        VitCtaButton(
          onPressed: onShowActions,
          variant: VitCtaButtonVariant.secondary,
          leading: const Icon(Icons.list_alt_rounded),
          trailing: const Icon(Icons.chevron_right_rounded),
          child: const Text('Xem tất cả'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        InfoCallout(text: snapshot.disclaimer, tone: EarnRiskLevel.medium),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<SavingsAutoPilotMetricDraft> metrics;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: metrics.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: EarnSpacingTokens.savingsAutoPilotMetricGridColumns,
        mainAxisSpacing: AppSpacing.x3,
        crossAxisSpacing: AppSpacing.x3,
        childAspectRatio: EarnSpacingTokens.savingsAutoPilotMetricGridAspect,
      ),
      itemBuilder: (context, index) {
        final metric = metrics[index];
        final color = toneColor(metric.tone);
        return VitCard(
          padding: EarnSpacingTokens.earnPaddingX3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(
                    iconForKey(metric.iconKey),
                    color: color,
                    size: AppSpacing.iconSm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      metric.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: microBoldStyle.copyWith(color: AppColors.text3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                metric.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.base.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({
    required this.module,
    required this.enabled,
    required this.onTap,
  });

  final SavingsAutoPilotModuleDraft module;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = enabled ? toneColor(module.tone) : AppColors.text3;
    return VitCard(
      key: SavingsAutoPilotPage.moduleKey(module.id),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: enabled ? null : AppColors.borderSolid,
      onTap: onTap,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Row(
        children: [
          IconBadge(icon: iconForKey(module.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: captionBoldStyle.copyWith(color: AppColors.text1),
                ),
                Text(
                  module.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          SmallPill(
            label: enabled ? 'BẬT' : 'TẮT',
            color: enabled ? AppColors.buy : AppColors.sell,
          ),
          const SizedBox(width: AppSpacing.x2),
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
