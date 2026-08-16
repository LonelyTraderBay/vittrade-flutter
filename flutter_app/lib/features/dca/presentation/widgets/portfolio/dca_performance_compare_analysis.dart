part of '../../phone/pages/portfolio/dca_performance_compare_page.dart';

class _ProsConsCard extends StatelessWidget {
  const _ProsConsCard.dca()
    : title = 'DCA Strategy',
      color = AppColors.buy,
      pros = const [
        'Lower timing risk',
        'Easier emotionally',
        'Flexible budget',
      ],
      cons = const ['May miss rallies', 'Lower upside'];

  const _ProsConsCard.lumpSum()
    : title = 'Lump Sum',
      color = AppColors.primary,
      pros = const ['Max time in market', 'Higher upside'],
      cons = const ['High timing risk', 'Emotional stress', 'Large capital'];

  final String title;
  final Color color;
  final List<String> pros;
  final List<String> cons;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _ProsConsList(title: 'Pros', items: pros, icon: Icons.check_rounded),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _ProsConsList(
            title: 'Cons',
            items: cons,
            icon: Icons.warning_amber_rounded,
            warning: true,
          ),
        ],
      ),
    );
  }
}

class _ProsConsList extends StatelessWidget {
  const _ProsConsList({
    required this.title,
    required this.items,
    required this.icon,
    this.warning = false,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: warning ? AppColors.warn : AppColors.buy,
                size: DcaSpacingTokens.dcaPerformanceCompareSmallIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          if (item != items.last)
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitInfoCallout(
      message: text,
      title: title,
      icon: icon,
      accentColor: AppColors.primary,
      variant: VitCardVariant.standard,
      iconSize: DcaSpacingTokens.dcaPerformanceCompareInlineIcon,
      padding: DcaSpacingTokens.dcaPaddingX4,
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitInfoCallout(
      message: text,
      icon: Icons.info_outline_rounded,
      accentColor: AppColors.warn,
      variant: VitCardVariant.standard,
      iconSize: DcaSpacingTokens.dcaPerformanceCompareInlineIcon,
      padding: DcaSpacingTokens.dcaPaddingX4,
    );
  }
}
