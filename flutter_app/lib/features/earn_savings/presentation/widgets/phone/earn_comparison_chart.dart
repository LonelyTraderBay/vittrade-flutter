part of '../../phone/pages/savings/savings_comparison_page.dart';

class _ApyValue extends StatelessWidget {
  const _ApyValue({required this.product, required this.bestApy});

  final SavingsProductDraft product;
  final double bestApy;

  @override
  Widget build(BuildContext context) {
    final apy = _apyNumber(product.apy);
    final best = apy == bestApy;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.apy,
          style: AppTextStyles.baseMedium.copyWith(
            color: best ? AppColors.buy : AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        if (best) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Cao nhất',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
        if (product.maxApy != null) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            product.maxApy!,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.warn,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ],
    );
  }
}

class _TypeValue extends StatelessWidget {
  const _TypeValue({required this.type});

  final SavingsProductType type;

  @override
  Widget build(BuildContext context) {
    final flexible = type == SavingsProductType.flexible;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            flexible ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
            color: flexible ? AppColors.buy : AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(flexible ? 'Linh hoạt' : 'Cố định', style: _cellStyle()),
        ],
      ),
    );
  }
}

class _MinAmountValue extends StatelessWidget {
  const _MinAmountValue({required this.detail, required this.lowestMin});

  final SavingsComparisonDetailDraft? detail;
  final double lowestMin;

  @override
  Widget build(BuildContext context) {
    final isLowest = detail != null && detail!.minAmountValue == lowestMin;
    return Text(
      detail?.minAmount ?? '—',
      textAlign: TextAlign.center,
      style: _cellStyle(
        color: isLowest ? AppColors.buy : AppColors.text1,
        fontWeight: isLowest ? AppTextStyles.bold : AppTextStyles.medium,
      ),
    );
  }
}

class _RiskValue extends StatelessWidget {
  const _RiskValue({required this.risk});

  final EarnRiskLevel risk;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(risk);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x1),
          Text(
            _riskLabel(risk),
            style: _cellStyle(color: color, fontWeight: AppTextStyles.bold),
          ),
        ],
      ),
    );
  }
}

class _CapacityValue extends StatelessWidget {
  const _CapacityValue({required this.capacity});

  final int capacity;

  @override
  Widget build(BuildContext context) {
    final color = capacity > 85
        ? AppColors.sell
        : capacity > 60
        ? AppColors.warn
        : AppColors.buy;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: AppRadii.xlRadius,
          child: SizedBox(
            height: AppSpacing.pageRhythmCompactInnerGap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (capacity / 100).clamp(0, 1),
                  child: ColoredBox(color: color),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '$capacity% đã đăng ký',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _IconTextValue extends StatelessWidget {
  const _IconTextValue({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _cellStyle(),
          ),
        ),
      ],
    );
  }
}

class _TextMetricValue extends StatelessWidget {
  const _TextMetricValue({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: _cellStyle(color: color, fontWeight: AppTextStyles.bold),
    );
  }
}

class _BooleanValue extends StatelessWidget {
  const _BooleanValue({required this.value, this.icon});

  final bool value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      value ? (icon ?? Icons.check_rounded) : Icons.close_rounded,
      color: value ? AppColors.buy : AppColors.text3,
      size: AppSpacing.iconSm,
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.product, required this.detail});

  final SavingsProductDraft product;
  final SavingsComparisonDetailDraft? detail;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _EarnAssetBadge(
                asset: product.asset,
                color: _assetColor(product.asset),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  product.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final feature in detail?.features ?? const <String>[])
                VitAccentPill(label: feature, accentColor: AppColors.buy),
            ],
          ),
        ],
      ),
    );
  }
}
