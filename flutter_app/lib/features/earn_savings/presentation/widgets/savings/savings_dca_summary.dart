part of '../../phone/pages/savings/savings_dca_page.dart';

class _DcaSummaryCard extends StatelessWidget {
  const _DcaSummaryCard({
    required this.snapshot,
    required this.onCreate,
    required this.onPlans,
    required this.onHistory,
  });

  final SavingsDcaSnapshot snapshot;
  final VoidCallback onCreate;
  final VoidCallback onPlans;
  final VoidCallback onHistory;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsDCAPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.repeat_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.heroLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Tổng đã gửi (USD)',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          Text(
            snapshot.totalInvestedUsd,
            style: AppTextStyles.numericDisplay3xl.copyWith(
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              VitStatusPill(
                label: snapshot.gainUsd,
                status: VitStatusPillStatus.success,
                icon: Icons.trending_up_rounded,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  snapshot.gainLabel,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Kế hoạch đang chạy',
                  value: '${snapshot.activePlanCount}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Giá trị hiện tại',
                  value: snapshot.totalCurrentUsd,
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Chiến lược',
                  value: snapshot.strategyLabel,
                  icon: Icons.shield_outlined,
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: SavingsDCAPage.createPlanKey,
                  fullWidth: true,
                  height: AppSpacing.buttonStandard,
                  variant: VitCtaButtonVariant.success,
                  leading: const Icon(Icons.add_rounded),
                  onPressed: onCreate,
                  child: const Text('Tạo DCA'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  label: 'Danh mục',
                  icon: Icons.bar_chart_rounded,
                  onTap: onPlans,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroAction(
                  label: 'Lịch sử',
                  icon: Icons.schedule_rounded,
                  onTap: onHistory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: valueColor, size: AppSpacing.iconSm),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _captionBold.copyWith(
                    color: valueColor,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      height: AppSpacing.buttonStandard,
      fullWidth: true,
      variant: VitCtaButtonVariant.secondary,
      leading: Icon(icon),
      onPressed: onTap,
      child: Text(label),
    );
  }
}

class _DcaTabs extends StatelessWidget {
  const _DcaTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: active,
      onChanged: onChanged,
      tabs: [
        for (final tab in tabs)
          VitTabItem(key: tab.id, label: tab.label, icon: _tabIcon(tab.id)),
      ],
    );
  }

  IconData _tabIcon(String id) {
    return id == 'history'
        ? Icons.history_rounded
        : Icons.account_tree_outlined;
  }
}
