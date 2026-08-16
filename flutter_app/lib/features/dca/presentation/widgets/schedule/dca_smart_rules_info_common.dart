part of '../../phone/pages/schedule/dca_smart_rules_page.dart';

class _ImpactCard extends StatelessWidget {
  const _ImpactCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: DcaSpacingTokens.dcaPaddingX5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Impact',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const Row(
            children: [
              Expanded(
                child: _StatValue(
                  label: 'Avg Entry Price',
                  value: '-8.2%',
                  color: AppColors.buy,
                  caption: 'vs standard DCA',
                ),
              ),
              Expanded(
                child: _StatValue(
                  label: 'Total Saved',
                  value: r'$987',
                  color: AppColors.buy,
                  caption: 'from optimizations',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      borderColor: AppColors.primary20,
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: DcaSpacingTokens.dcaSmartInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      borderColor: AppColors.buy20,
      padding: DcaSpacingTokens.dcaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: DcaSpacingTokens.dcaSmartInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final DcaSmartRuleStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return VitAccentPill(
      label: status.name.toUpperCase(),
      accentColor: color,
      backgroundAlpha: 0.15,
      radiusOverride: AppRadii.smRadius,
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final DcaSmartRuleType type;

  @override
  Widget build(BuildContext context) {
    return _TinyBadge(
      label: type.name.toUpperCase(),
      color: AppColors.text2,
      background: AppColors.surface2,
    );
  }
}

class _ResultBadge extends StatelessWidget {
  const _ResultBadge({required this.result});

  final DcaSmartRuleResult result;

  @override
  Widget build(BuildContext context) {
    final color = _resultColor(result);
    return VitAccentPill(
      label: result.name.toUpperCase(),
      accentColor: color,
      backgroundAlpha: 0.15,
      radiusOverride: AppRadii.smRadius,
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: DcaSpacingTokens.dcaChipPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: DcaSpacingTokens.dcaSmartBadgeLineHeight,
          ),
        ),
      ),
    );
  }
}

class _RuleText extends StatelessWidget {
  const _RuleText({required this.label, required this.value});

  final String label;
  final String value;

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
          style: AppTextStyles.caption.copyWith(color: AppColors.text1),
        ),
      ],
    );
  }
}

class _CodeRow extends StatelessWidget {
  const _CodeRow({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: AppTextStyles.monoCode.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _typeIcon(DcaSmartRuleType type) {
  switch (type) {
    case DcaSmartRuleType.entry:
      return Icons.trending_down_rounded;
    case DcaSmartRuleType.exit:
      return Icons.adjust_rounded;
    case DcaSmartRuleType.adjust:
      return Icons.settings_outlined;
  }
}

Color _statusColor(DcaSmartRuleStatus status) {
  switch (status) {
    case DcaSmartRuleStatus.active:
      return AppColors.buy;
    case DcaSmartRuleStatus.paused:
      return AppColors.warn;
    case DcaSmartRuleStatus.triggered:
      return AppColors.primary;
  }
}

Color _resultColor(DcaSmartRuleResult result) {
  switch (result) {
    case DcaSmartRuleResult.executed:
      return AppColors.buy;
    case DcaSmartRuleResult.failed:
      return AppColors.sell;
    case DcaSmartRuleResult.pending:
      return AppColors.warn;
  }
}
