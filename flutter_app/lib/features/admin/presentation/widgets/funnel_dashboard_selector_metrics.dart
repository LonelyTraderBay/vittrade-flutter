part of '../phone/pages/funnel_dashboard_page.dart';

class _FunnelSelector extends StatelessWidget {
  const _FunnelSelector({
    required this.funnels,
    required this.selectedFunnelId,
    required this.onChanged,
  });

  final List<AdminConversionFunnel> funnels;
  final String selectedFunnelId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn funnel',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: funnels.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: AdminSpacingTokens.adminGridColumns,
            mainAxisExtent: AdminSpacingTokens.adminMetricTileExtent,
            crossAxisSpacing: AppSpacing.x3,
            mainAxisSpacing: AppSpacing.x3,
          ),
          itemBuilder: (context, index) {
            final funnel = funnels[index];
            final selected = funnel.id == selectedFunnelId;
            return Semantics(
              button: true,
              selected: selected,
              label: 'Chọn funnel ${funnel.name}',
              child: VitCard(
                key: FunnelDashboardPage.selectorKey(funnel.id),
                onTap: () => onChanged(funnel.id),
                padding: AdminSpacingTokens.adminCardPadding,
                borderColor: selected
                    ? AppColors.accent
                    : AppColors.transparent,
                background: ColoredBox(
                  color: selected ? AppColors.surface : AppColors.surface2,
                ),
                clip: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      funnel.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: AdminSpacingTokens.adminLineHeightShort,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      funnel.stepCountLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        height: AdminSpacingTokens.adminLineHeightShort,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.snapshot});

  final AdminFunnelsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AdminMetricCard(
            icon: Icons.filter_alt_outlined,
            title: 'Phiên',
            value: '${snapshot.totalSessions}',
            caption: '${snapshot.completedSessions} hoàn thành',
            delta: '0.0%',
            timeframe: 'Selected funnel',
            tint: AppColors.accent15,
            accent: AppColors.accent,
            semanticsLabel:
                'Chỉ số funnel quản trị Phiên: ${snapshot.totalSessions}. '
                '${snapshot.completedSessions} hoàn thành. 0,0% funnel đã chọn',
            valueStyle: AppTextStyles.amountXs.copyWith(
              color: AppColors.accent,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: AdminMetricCard(
            icon: Icons.check_circle_outline_rounded,
            title: 'Tỷ lệ hoàn thành',
            value: snapshot.completionRateLabel,
            caption: 'Trung bình ${snapshot.avgCompletionTimeLabel}',
            delta: '0.0%',
            timeframe: 'Selected funnel',
            tint: AppColors.buy15,
            accent: AppColors.buy,
            semanticsLabel:
                'Chỉ số funnel quản trị Tỷ lệ hoàn thành: ${snapshot.completionRateLabel}. '
                'Trung bình ${snapshot.avgCompletionTimeLabel}. 0,0% funnel đã chọn',
            valueStyle: AppTextStyles.amountXs.copyWith(color: AppColors.buy),
          ),
        ),
      ],
    );
  }
}
