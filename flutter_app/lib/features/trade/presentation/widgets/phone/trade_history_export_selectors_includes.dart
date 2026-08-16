part of '../../phone/pages/hub/trade_history_export_page.dart';

class _FormatSelector extends StatelessWidget {
  const _FormatSelector({
    required this.formats,
    required this.activeFormat,
    required this.onChanged,
  });

  final List<TradeExportFormat> formats;
  final String activeFormat;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < formats.length; i++) ...[
          Expanded(
            child: _FormatCard(
              key: TradeHistoryExportPage.formatKey(formats[i].id),
              format: formats[i],
              active: activeFormat == formats[i].id,
              onTap: () => onChanged(formats[i].id),
            ),
          ),
          if (i < formats.length - 1) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _FormatCard extends StatelessWidget {
  const _FormatCard({
    super.key,
    required this.format,
    required this.active,
    required this.onTap,
  });

  final TradeExportFormat format;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? _tradePrimary : AppColors.textSoftLight;
    final icon = format.id == 'csv'
        ? Icons.table_chart_outlined
        : Icons.description_outlined;

    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      onTap: onTap,
      radius: VitCardRadius.tight,
      height: _exportFormatExtent,
      padding: VitDensity.tool.cardPadding,
      borderColor: active
          ? _tradePrimary.withValues(alpha: .7)
          : AppColors.cardBorder,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.x1),
          Text(
            format.label,
            style: AppTextStyles.body.copyWith(
              color: active ? _tradePrimary : AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            format.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.navLabel.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.periods,
    required this.activePeriod,
    required this.onChanged,
  });

  final List<TradeExportPeriod> periods;
  final String activePeriod;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        for (final period in periods)
          _PeriodChip(
            key: TradeHistoryExportPage.periodKey(period.id),
            period: period,
            active: activePeriod == period.id,
            onTap: () => onChanged(period.id),
          ),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    super.key,
    required this.period,
    required this.active,
    required this.onTap,
  });

  final TradeExportPeriod period;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      label: period.label,
      selected: active,
      onTap: onTap,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: AppSpacing.x3),
      accentColor: _tradePrimary,
    );
  }
}

class _IncludeList extends StatelessWidget {
  const _IncludeList({required this.includes, required this.onToggle});

  final List<TradeExportInclude> includes;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      child: Column(
        children: [
          for (var i = 0; i < includes.length; i++) ...[
            _IncludeRow(
              key: TradeHistoryExportPage.includeKey(includes[i].id),
              include: includes[i],
              onTap: () => onToggle(includes[i].id),
            ),
            if (i < includes.length - 1)
              const Divider(height: AppSpacing.dividerHairline),
          ],
        ],
      ),
    );
  }
}

class _IncludeRow extends StatelessWidget {
  const _IncludeRow({super.key, required this.include, required this.onTap});

  final TradeExportInclude include;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.tight,
      height: VitDensity.tool.controlHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              include.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
          _CheckBox(checked: include.checked),
        ],
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Icon(
      checked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
      color: checked ? AppColors.buy : AppColors.borderSolid,
      size: AppSpacing.iconMd,
    );
  }
}
