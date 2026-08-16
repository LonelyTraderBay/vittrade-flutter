part of '../../phone/pages/hub/launchpad_page.dart';

class _LaunchpadTabs extends StatelessWidget {
  const _LaunchpadTabs({required this.activeTab, required this.onChanged});

  final _LaunchpadTab activeTab;
  final ValueChanged<_LaunchpadTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: LaunchpadPage.tabsKey,
      variant: VitTabBarVariant.segment,
      activeKey: activeTab.id,
      onChanged: (id) {
        final tab = _LaunchpadTab.values.firstWhere((tab) => tab.id == id);
        onChanged(tab);
      },
      tabs: [
        for (final tab in _LaunchpadTab.values)
          VitTabItem(
            key: tab.id,
            label: tab.label,
            widgetKey: LaunchpadPage.tabKey(tab.id),
          ),
      ],
    );
  }
}

class _ProjectsEmptyState extends StatelessWidget {
  const _ProjectsEmptyState({required this.filtered, required this.onShowAll});

  final bool filtered;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      key: LaunchpadPage.emptyKey,
      icon: Icons.rocket_launch_outlined,
      title: filtered
          ? 'Không có dự án trong tab này'
          : 'Chưa có dự án Launchpad',
      message: filtered
          ? 'Thử xem tất cả dự án hoặc chọn tab khác.'
          : 'Quay lại sau khi có dự án mới được niêm yết.',
      actionLabel: filtered ? 'Xem tất cả' : null,
      actionKey: filtered ? LaunchpadPage.emptyActionKey : null,
      onAction: filtered ? onShowAll : null,
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final typeStyle = _typeStyle(project.type);
    final statusStyle = _statusStyle(project.status);
    return VitCard(
      key: LaunchpadPage.projectKey(project.id),
      radius: VitCardRadius.standard,
      padding: VitDensity.compact.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProjectAvatar(project: project),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: _launchpadLineHeightLabel,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        VitStatusPill(
                          label: statusStyle.label,
                          status: _statusPillStatus(project.status),
                          size: VitStatusPillSize.sm,
                        ),
                        _MiniPill(
                          label: typeStyle.label,
                          color: typeStyle.color,
                          background: typeStyle.background,
                        ),
                      ],
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
                child: _KpiColumn(label: 'Hard Cap', value: project.hardCap),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _KpiColumn(
                  label: 'Đã huy động',
                  value: project.totalRaise,
                ),
              ),
            ],
          ),
          if (project.status != LaunchpadProjectStatus.upcoming) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            _ProjectProgressBar(project: project),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _ProjectPrimaryAction(project: project),
        ],
      ),
    );
  }
}

class _ProjectAvatar extends StatelessWidget {
  const _ProjectAvatar({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.x7,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: project.accent.resolve().withValues(alpha: .12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.lgRadius,
            side: BorderSide(
              color: project.accent.resolve().withValues(alpha: .35),
            ),
          ),
        ),
        child: Center(
          child: Text(
            project.logo,
            style: AppTextStyles.baseMedium.copyWith(
              color: project.accent.resolve(),
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _KpiColumn extends StatelessWidget {
  const _KpiColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _ProjectProgressBar extends StatelessWidget {
  const _ProjectProgressBar({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final complete = project.progress >= 100;
    final color = complete ? AppColors.buy : project.accent.resolve();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tiến trình',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              '${project.progress}%',
              style: AppTextStyles.micro.copyWith(
                color: complete ? AppColors.buy : AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: AppSpacing.pageRhythmCompactInnerGap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (project.progress / 100).clamp(0.0, 1.0),
                  child: ColoredBox(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectPrimaryAction extends StatelessWidget {
  const _ProjectPrimaryAction({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final isActive = project.status == LaunchpadProjectStatus.active;
    return VitCtaButton(
      key: isActive ? LaunchpadPage.joinKey(project.id) : null,
      onPressed: isActive
          ? HapticFeedback.selectionClick
          : () => context.go(AppRoutePaths.launchpadSample),
      density: VitDensity.compact,
      variant: isActive
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.secondary,
      leading: Icon(
        isActive ? Icons.rocket_launch_outlined : Icons.chevron_right_rounded,
      ),
      child: Text(isActive ? 'Tham gia' : 'Xem chi tiết'),
    );
  }
}

VitStatusPillStatus _statusPillStatus(LaunchpadProjectStatus status) {
  return switch (status) {
    LaunchpadProjectStatus.upcoming => VitStatusPillStatus.warning,
    LaunchpadProjectStatus.active => VitStatusPillStatus.success,
    LaunchpadProjectStatus.ended => VitStatusPillStatus.neutral,
  };
}
