part of '../../phone/pages/staking/staking_liquid_staking_page.dart';

class _SwapRow extends StatelessWidget {
  const _SwapRow({
    required this.label,
    required this.selected,
    required this.options,
    required this.amountController,
    required this.amountKey,
    required this.onSelected,
    required this.onAmountChanged,
  });

  final String label;
  final String selected;
  final List<String> options;
  final TextEditingController amountController;
  final Key amountKey;
  final ValueChanged<String> onSelected;
  final ValueChanged<String> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldGroup(
      label: label,
      child: Row(
        children: [
          Expanded(
            child: _AssetSelector(
              selected: selected,
              options: options,
              onSelected: onSelected,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _AmountInput(
              fieldKey: amountKey,
              controller: amountController,
              onChanged: onAmountChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiveRow extends StatelessWidget {
  const _ReceiveRow({
    required this.label,
    required this.selected,
    required this.options,
    required this.receive,
    required this.onSelected,
  });

  final String label;
  final String selected;
  final List<String> options;
  final double receive;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldGroup(
      label: label,
      child: Row(
        children: [
          Expanded(
            child: _AssetSelector(
              selected: selected,
              options: options,
              onSelected: onSelected,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.standard,
              padding: AppSpacing.cardPadding,
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    receive > 0 ? receive.toStringAsFixed(6) : '0.0',
                    style: AppTextStyles.baseMedium.copyWith(
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldGroup extends StatelessWidget {
  const _FieldGroup({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        child,
      ],
    );
  }
}

class _AssetSelector extends StatelessWidget {
  const _AssetSelector({
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  final String selected;
  final List<String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x3,
        right: AppSpacing.x3,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: options.contains(selected) ? selected : options.first,
          dropdownColor: AppColors.surface2,
          iconEnabledColor: AppColors.text2,
          style: AppTextStyles.body,
          isExpanded: true,
          items: [
            for (final option in options)
              DropdownMenuItem(value: option, child: Text(option)),
          ],
          onChanged: (value) {
            if (value != null) onSelected(value);
          },
        ),
      ),
    );
  }
}

class _AmountInput extends StatelessWidget {
  const _AmountInput({
    required this.fieldKey,
    required this.controller,
    required this.onChanged,
  });

  final Key fieldKey;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitInput(
      fieldKey: fieldKey,
      controller: controller,
      textAlign: TextAlign.right,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      hintText: '0.0',
      semanticLabel: 'Số tiền hoán đổi Liquid Staking',
      onChanged: onChanged,
      textStyle: AppTextStyles.baseMedium.copyWith(
        fontFeatures: AppTextStyles.tabularFigures,
      ),
    );
  }
}
