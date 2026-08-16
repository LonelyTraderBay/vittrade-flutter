part of '../phone/pages/admin_home_page.dart';

class _DashboardsSection extends StatelessWidget {
  const _DashboardsSection({required this.dashboards});

  final List<AdminDashboardLink> dashboards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitSectionHeader(
          title: 'Dashboards',
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.text1,
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
        ),
        for (final dashboard in dashboards) ...[
          _DashboardCard(dashboard: dashboard),
          if (dashboard != dashboards.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        ],
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({required this.dashboard});

  final AdminDashboardLink dashboard;

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor(dashboard.accent);
    return VitCard(
      key: AdminHomePage.dashboardKey(dashboard.id),
      onTap: () => context.go(dashboard.route),
      padding: AdminSpacingTokens.adminCardPadding,
      child: Row(
        children: [
          SizedBox.square(
            dimension: AppSpacing.inputHeight,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: _accentTint(dashboard.accent),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.inputRadius,
                ),
              ),
              child: Icon(
                _metricIcon(dashboard.icon),
                color: accent,
                size: AdminSpacingTokens.adminIcon2xl,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboard.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  dashboard.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Text(
            dashboard.stat,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.numericCode.copyWith(
              color: accent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AdminSpacingTokens.adminIconXl,
          ),
        ],
      ),
    );
  }
}

class _FooterCard extends StatelessWidget {
  const _FooterCard({required this.snapshot});

  final AdminHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AdminSpacingTokens.adminCardPadding,
      child: Column(
        children: [
          Text(
            'Admin Dashboard v1.0 • Phase 2 Sprint 3',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Last updated: ${snapshot.adminMetrics.footerUpdatedLabel}',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

Color _accentColor(AdminMetricAccent accent) {
  switch (accent) {
    case AdminMetricAccent.accent:
      return AppColors.accent;
    case AdminMetricAccent.primary:
      return AppColors.primary;
    case AdminMetricAccent.success:
      return AppColors.buy;
  }
}

Color _accentTint(AdminMetricAccent accent) {
  switch (accent) {
    case AdminMetricAccent.accent:
      return AppColors.accent15;
    case AdminMetricAccent.primary:
      return AppColors.primary15;
    case AdminMetricAccent.success:
      return AppColors.buy15;
  }
}

IconData _metricIcon(AdminDashboardIcon icon) {
  switch (icon) {
    case AdminDashboardIcon.analytics:
      return Icons.bar_chart_rounded;
    case AdminDashboardIcon.experiment:
      return Icons.science_outlined;
    case AdminDashboardIcon.funnel:
      return Icons.filter_alt_outlined;
  }
}
