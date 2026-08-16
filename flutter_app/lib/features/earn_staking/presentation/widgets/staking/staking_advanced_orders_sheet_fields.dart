part of '../../phone/pages/staking/staking_advanced_orders_page.dart';

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EarnSpacingTokens.earnContentMargin,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.88,
          ),
          child: DecoratedBox(
            decoration: const ShapeDecoration(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadii.cardLargeRadius,
              ),
            ),
            child: Padding(
              padding: EarnSpacingTokens.earnPaddingX5,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateOrderSheet extends StatefulWidget {
  const _CreateOrderSheet({required this.snapshot});

  final StakingAdvancedOrdersSnapshot snapshot;

  @override
  State<_CreateOrderSheet> createState() => _CreateOrderSheetState();
}

class _CreateOrderSheetState extends State<_CreateOrderSheet> {
  StakingAdvancedOrderType _selected = StakingAdvancedOrderType.takeProfit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingAdvancedOrdersPage.createSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text('Create Order', style: AppTextStyles.sectionTitle),
              ),
              VitIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.md,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _FieldGroup(
            label: 'Order Type',
            child: Row(
              children: [
                for (
                  var i = 0;
                  i < widget.snapshot.orderTypeOptions.length;
                  i++
                )
                  Expanded(
                    child: Padding(
                      padding: EarnSpacingTokens.earnLeftPaddingX2(i > 0),
                      child: _TypeButton(
                        type: widget.snapshot.orderTypeOptions[i],
                        selected:
                            _selected == widget.snapshot.orderTypeOptions[i],
                        onTap: () => setState(
                          () => _selected = widget.snapshot.orderTypeOptions[i],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _FieldGroup(
            label: 'Liquid Staking Token',
            child: _StaticField(
              value: widget.snapshot.assetOptions.first,
              trailing: Icons.expand_more_rounded,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _FieldGroup(
            label: _triggerLabel(_selected),
            child: _InputPreview(
              hint: _selected == StakingAdvancedOrderType.trailingStop
                  ? '5'
                  : '1.10',
              suffix: _selected == StakingAdvancedOrderType.trailingStop
                  ? '%'
                  : 'ETH',
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            widget.snapshot.currentPriceLabel,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const _FieldGroup(
            label: 'Amount',
            child: _InputPreview(hint: '0.00', suffix: 'Max'),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            widget.snapshot.availableLabel,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: EarnSpacingTokens.earnPaddingX3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    widget.snapshot.orderTypeWarnings[_selected] ?? '',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Create ${_orderTypeLabel(_selected)}'),
          ),
        ],
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final StakingAdvancedOrderType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitChoicePill(
      key: StakingAdvancedOrdersPage.typeKey(type),
      label: _orderTypeLabel(type),
      selected: selected,
      onTap: onTap,
      fullWidth: true,
      height: AppSpacing.inputHeight,
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

class _StaticField extends StatelessWidget {
  const _StaticField({required this.value, required this.trailing});

  final String value;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnStaticSelectPadding,
      child: Row(
        children: [
          Expanded(child: Text(value, style: AppTextStyles.body)),
          Icon(trailing, color: AppColors.text2, size: AppSpacing.iconSm),
        ],
      ),
    );
  }
}

class _InputPreview extends StatelessWidget {
  const _InputPreview({required this.hint, required this.suffix});

  final String hint;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    final isMax = suffix == 'Max';
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnCardPaddingX4X3,
      child: Row(
        children: [
          Expanded(
            child: Text(
              hint,
              style: AppTextStyles.body.copyWith(color: AppColors.text3),
            ),
          ),
          if (isMax)
            DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
              ),
              child: Padding(
                padding: EarnSpacingTokens.earnPillPadding,
                child: Text(
                  suffix,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            )
          else
            Text(
              suffix,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
        ],
      ),
    );
  }
}

String _tabLabel(_AdvancedOrderTab tab) {
  return switch (tab) {
    _AdvancedOrderTab.active => 'Active',
    _AdvancedOrderTab.history => 'History',
  };
}

String _orderTypeLabel(StakingAdvancedOrderType type) {
  return switch (type) {
    StakingAdvancedOrderType.takeProfit => 'Take Profit',
    StakingAdvancedOrderType.stopLoss => 'Stop Loss',
    StakingAdvancedOrderType.trailingStop => 'Trailing Stop',
  };
}

String _statusLabel(StakingAdvancedOrderStatus status) {
  return switch (status) {
    StakingAdvancedOrderStatus.active => 'Active',
    StakingAdvancedOrderStatus.triggered => 'Triggered',
    StakingAdvancedOrderStatus.cancelled => 'Cancelled',
  };
}

String _triggerLabel(StakingAdvancedOrderType type) {
  return switch (type) {
    StakingAdvancedOrderType.takeProfit => 'Trigger Price (Take Profit At)',
    StakingAdvancedOrderType.stopLoss => 'Stop Price (Exit If Below)',
    StakingAdvancedOrderType.trailingStop => 'Trailing Distance (%)',
  };
}

IconData _orderIcon(StakingAdvancedOrderType type) {
  return switch (type) {
    StakingAdvancedOrderType.takeProfit => Icons.trending_up_rounded,
    StakingAdvancedOrderType.stopLoss => Icons.trending_down_rounded,
    StakingAdvancedOrderType.trailingStop => Icons.track_changes_rounded,
  };
}

Color _orderTone(StakingAdvancedOrderType type) {
  return switch (type) {
    StakingAdvancedOrderType.takeProfit => AppColors.buy,
    StakingAdvancedOrderType.stopLoss => AppColors.sell,
    StakingAdvancedOrderType.trailingStop => AppColors.warn,
  };
}

String _formatDate(String value) {
  final parts = value.split('-');
  if (parts.length != 3) return value;
  return '${parts[2]}/${parts[1]}/${parts[0]}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2);
}
