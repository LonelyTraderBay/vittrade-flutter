part of '../../phone/pages/schedule/dca_smart_rules_page.dart';

class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.activeTab, required this.onChanged});

  final _RulesTab activeTab;
  final ValueChanged<_RulesTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitScrollableTabHeader.surfaceDivider(
      tabBar: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_RulesTab.values.byName(key)),
        tabs: [
          VitTabItem(
            key: _RulesTab.mine.name,
            label: 'Luat cua toi',
            widgetKey: DCASmartRulesPage.tabKey(_RulesTab.mine.name),
          ),
          VitTabItem(
            key: _RulesTab.templates.name,
            label: 'Mau',
            widgetKey: DCASmartRulesPage.tabKey(_RulesTab.templates.name),
          ),
          VitTabItem(
            key: _RulesTab.history.name,
            label: 'Lich su',
            widgetKey: DCASmartRulesPage.tabKey(_RulesTab.history.name),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final DcaSmartRulesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: DcaSpacingTokens.dcaSmartStatsIconBox,
                height: DcaSpacingTokens.dcaSmartStatsIconBox,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.accent10,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.inputRadius,
                    ),
                  ),
                  child: Icon(
                    Icons.bolt_rounded,
                    color: AppColors.accent,
                    size: DcaSpacingTokens.dcaSmartStatsIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Smart Rules',
                      style: AppTextStyles.sectionTitleXs,
                    ),
                    Text(
                      'Tối ưu mua theo điều kiện thị trường',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _StatValue(
                  label: 'Active',
                  value: '${snapshot.activeRules}',
                  color: AppColors.buy,
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Triggered',
                  value: '${snapshot.totalTriggers}',
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Success',
                  value: '${snapshot.successPercent}%',
                  color: AppColors.buy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatValue extends StatelessWidget {
  const _StatValue({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.caption,
  });

  final String label;
  final String value;
  final Color color;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        if (caption != null)
          Text(
            caption!,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
      ],
    );
  }
}
