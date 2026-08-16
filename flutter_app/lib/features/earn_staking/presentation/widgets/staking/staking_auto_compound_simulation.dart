part of '../../phone/pages/staking/staking_auto_compound_page.dart';

class _SimulationCard extends StatelessWidget {
  const _SimulationCard({
    required this.controllerPrincipal,
    required this.controllerApy,
    required this.controllerMonths,
    required this.simulation,
    required this.onChanged,
  });

  final TextEditingController controllerPrincipal;
  final TextEditingController controllerApy;
  final TextEditingController controllerMonths;
  final _CompoundSimulation simulation;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingAutoCompoundPage.simulationKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _MiniInput(
                  fieldKey: StakingAutoCompoundPage.principalKey,
                  label: 'Số lượng gốc',
                  controller: controllerPrincipal,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniInput(
                  fieldKey: StakingAutoCompoundPage.apyKey,
                  label: 'APY (%)',
                  controller: controllerApy,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _MiniInput(
                  fieldKey: StakingAutoCompoundPage.monthsKey,
                  label: 'Tháng',
                  controller: controllerMonths,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
          SizedBox(
            height: EarnSpacingTokens.stakingAutoCompoundChartHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CompoundChartPainter(points: simulation.points),
                  ),
                ),
                const Positioned(
                  left: AppSpacing.x6,
                  right: AppSpacing.x4,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AxisLabel('0'),
                      _AxisLabel('1'),
                      _AxisLabel('2'),
                      _AxisLabel('3'),
                      _AxisLabel('4'),
                      _AxisLabel('5'),
                      _AxisLabel('6'),
                      _AxisLabel('7'),
                      _AxisLabel('8'),
                      _AxisLabel('9'),
                      _AxisLabel('10'),
                      _AxisLabel('11'),
                      _AxisLabel('12'),
                    ],
                  ),
                ),
                Positioned(
                  left: AppSpacing.x6,
                  right: AppSpacing.x4,
                  bottom: AppSpacing.x5,
                  child: Center(
                    child: Text(
                      'Tháng',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _ResultCard(
                  label: 'Có compound',
                  value: _formatCurrency(simulation.withCompound),
                  color: AppColors.buy,
                  tone: AppColors.buy10,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _ResultCard(
                  label: 'Không compound',
                  value: _formatCurrency(simulation.withoutCompound),
                  color: AppColors.sell,
                  tone: AppColors.sell10,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.standard,
            padding: EarnSpacingTokens.earnPaddingX4,
            child: Column(
              children: [
                Text(
                  'Lợi thế compound',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                Text(
                  '+${_formatCurrency(simulation.difference)}',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.buy,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '(+${simulation.percentageGain.toStringAsFixed(2)}% cao hơn)',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInput extends StatelessWidget {
  const _MiniInput({
    required this.fieldKey,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.medium,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Material(
          color: AppColors.surface2,
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.inputRadius,
            side: BorderSide(color: AppColors.borderSolid),
          ),
          child: Padding(
            padding: EarnSpacingTokens.earnHorizontalPaddingX3,
            child: TextField(
              key: fieldKey,
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              cursorColor: AppColors.primary,
              onChanged: onChanged,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EarnSpacingTokens.earnVerticalPaddingX3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AxisLabel extends StatelessWidget {
  const _AxisLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.chartLabelXs.copyWith(color: AppColors.text3),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.label,
    required this.value,
    required this.color,
    required this.tone,
  });

  final String label;
  final String value;
  final Color color;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tone,
      borderRadius: AppRadii.cardRadius,
      child: Padding(
        padding: EarnSpacingTokens.earnPaddingX4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: AppSpacing.x4,
                  height:
                      EarnSpacingTokens.stakingAutoCompoundResultMarkerHeight,
                  child: Material(
                    color: color,
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTextStyles.baseMedium.copyWith(
                  color: color,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _CompoundSimulation {
  const _CompoundSimulation({
    required this.points,
    required this.withCompound,
    required this.withoutCompound,
    required this.difference,
    required this.percentageGain,
  });

  final List<StakingAutoCompoundPointDraft> points;
  final double withCompound;
  final double withoutCompound;
  final double difference;
  final double percentageGain;
}
