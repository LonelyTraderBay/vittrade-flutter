import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/providers/earn_savings_controller_providers.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import 'package:vit_trade_flutter/features/earn_savings/presentation/phone/pages/savings/savings_autopilot_page.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_common.dart';
import 'package:vit_trade_flutter/features/earn_savings/presentation/widgets/savings/savings_autopilot_formatters.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({
    super.key,
    required this.snapshot,
    required this.mode,
    required this.monthlyBudgetUsd,
    required this.approvalRequired,
    required this.notificationsEnabled,
    required this.moduleEnabled,
    required this.onModeChanged,
    required this.onBudgetChanged,
    required this.onModuleChanged,
    required this.onApprovalChanged,
    required this.onNotificationChanged,
  });

  final SavingsAutoPilotSnapshot snapshot;
  final SavingsAutoPilotMode mode;
  final int monthlyBudgetUsd;
  final bool approvalRequired;
  final bool notificationsEnabled;
  final bool Function(SavingsAutoPilotModuleDraft module) moduleEnabled;
  final ValueChanged<SavingsAutoPilotMode> onModeChanged;
  final ValueChanged<int> onBudgetChanged;
  final void Function(String id, bool enabled) onModuleChanged;
  final ValueChanged<bool> onApprovalChanged;
  final ValueChanged<bool> onNotificationChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: SavingsAutoPilotPage.settingsKey,
      children: [
        VitPageSection(
          label: 'Chế độ AutoPilot',
          children: [
            for (final item in snapshot.modes)
              _ModeCard(
                item: item,
                selected: item.id == mode,
                onTap: () => onModeChanged(item.id),
              ),
          ],
        ),
        VitPageSection(
          label: 'Ngân sách hằng tháng (USD)',
          children: [
            _BudgetCard(selected: monthlyBudgetUsd, onChanged: onBudgetChanged),
          ],
        ),
        VitPageSection(
          label: 'Modules tự động',
          children: [
            for (final module in snapshot.modules)
              _SwitchRow(
                icon: iconForKey(module.iconKey),
                color: toneColor(module.tone),
                title: module.label,
                subtitle: module.description,
                value: moduleEnabled(module),
                onChanged: (value) => onModuleChanged(module.id, value),
              ),
          ],
        ),
        VitPageSection(
          label: 'An toàn & Kiểm soát',
          children: [
            _SwitchRow(
              icon: Icons.security_rounded,
              color: AppColors.primary,
              title: 'Phê duyệt thủ công',
              subtitle: 'Yêu cầu xác nhận trước khi chuyển SP',
              value: approvalRequired,
              onChanged: onApprovalChanged,
            ),
            _SwitchRow(
              icon: Icons.notifications_active_outlined,
              color: AppColors.warn,
              title: 'Thông báo hành động',
              subtitle: 'Nhận thông báo khi AutoPilot hành động',
              value: notificationsEnabled,
              onChanged: onNotificationChanged,
            ),
          ],
        ),
        VitPageSection(
          label: 'Tham số rủi ro',
          children: [
            _RiskParameter(
              label: 'Ngưỡng rebalance',
              value: '${snapshot.config.rebalanceThresholdPct}%',
              minLabel: '3% (nhạy)',
              maxLabel: '25% (ổn định)',
              color: AppColors.primary,
            ),
            _RiskParameter(
              label: 'Min APY gain cho switch',
              value:
                  '${snapshot.config.switchMinApyGainPct.toStringAsFixed(1)}%',
              minLabel: '0.1% (nhạy)',
              maxLabel: '3.0% (thận trọng)',
              color: AppColors.accent,
            ),
            _RiskParameter(
              label: 'Max single-asset',
              value: '${snapshot.config.maxSingleAssetPct}%',
              minLabel: '20% (đa dạng)',
              maxLabel: '80% (tập trung)',
              color: AppColors.sell,
            ),
          ],
        ),
        InfoCallout(text: snapshot.disclaimer, tone: EarnRiskLevel.high),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final SavingsAutoPilotModeDraft item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = toneColor(item.tone);
    return VitCard(
      key: SavingsAutoPilotPage.modeKey(item.id),
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: selected ? color.withValues(alpha: .4) : null,
      padding: EarnSpacingTokens.earnPaddingX3,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconBadge(icon: iconForKey(item.iconKey), color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.label, style: captionBoldStyle),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  item.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(
                      'DCA: ${item.dcaFrequency}',
                      style: AppTextStyles.micro,
                    ),
                    Text(
                      'Rebalance: ${item.rebalanceThreshold}',
                      style: AppTextStyles.micro,
                    ),
                    Text(
                      'Switch: ${item.switchMinGain}',
                      style: AppTextStyles.micro,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_off_rounded,
            color: selected ? color : AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const options = [500, 1000, 2000, 5000];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.large,
          borderColor: AppColors.primary30,
          padding: EarnSpacingTokens.earnCardPaddingX3X2,
          child: Row(
            children: [
              const Icon(
                Icons.attach_money_rounded,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '$selected',
                  style: AppTextStyles.base.copyWith(
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              Text(
                'USD/tháng',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Row(
          children: [
            for (final amount in options) ...[
              Expanded(
                child: ChoicePill(
                  key: SavingsAutoPilotPage.budgetKey(amount),
                  label: formatAutoPilotMoney(amount),
                  selected: selected == amount,
                  onTap: () => onChanged(amount),
                ),
              ),
              if (amount != options.last) const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3X2,
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: captionBoldStyle.copyWith(color: AppColors.text1),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: AppColors.buy,
            activeTrackColor: AppColors.buy20,
            inactiveThumbColor: AppColors.text3,
            inactiveTrackColor: AppColors.toggleTrackOff,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _RiskParameter extends StatelessWidget {
  const _RiskParameter({
    required this.label,
    required this.value,
    required this.minLabel,
    required this.maxLabel,
    required this.color,
  });

  final String label;
  final String value;
  final String minLabel;
  final String maxLabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: captionBoldStyle)),
              Text(value, style: captionBoldStyle.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: LinearProgressIndicator(
              minHeight: EarnSpacingTokens.savingsAutoPilotRiskProgressHeight,
              value: .42,
              color: color,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(child: Text(minLabel, style: AppTextStyles.micro)),
              Text(maxLabel, style: AppTextStyles.micro),
            ],
          ),
        ],
      ),
    );
  }
}
