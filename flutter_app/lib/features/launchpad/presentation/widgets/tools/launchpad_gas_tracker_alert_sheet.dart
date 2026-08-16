part of '../../phone/pages/tools/launchpad_gas_tracker_page.dart';

class _AddAlertSheet extends StatefulWidget {
  const _AddAlertSheet({
    required this.prices,
    required this.onClose,
    required this.onAdd,
  });

  final List<LaunchpadGasPriceDraft> prices;
  final VoidCallback onClose;
  final ValueChanged<LaunchpadGasAlertDraft> onAdd;

  @override
  State<_AddAlertSheet> createState() => _AddAlertSheetState();
}

class _AddAlertSheetState extends State<_AddAlertSheet> {
  final _thresholdController = TextEditingController();
  late String _chain;
  var _direction = LaunchpadGasAlertDirection.below;

  @override
  void initState() {
    super.initState();
    _chain = widget.prices.first.chain;
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return double.tryParse(_thresholdController.text.trim()) != null;
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.prices.firstWhere(
      (price) => price.chain == _chain,
      orElse: () => widget.prices.first,
    );

    return Material(
      key: LaunchpadGasTrackerPage.addSheetKey,
      color: AppColors.dynamicIslandBg.withValues(alpha: .72),
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DeviceMetrics.width),
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.sheetTopLargeRadius,
                ),
              ),
              child: Padding(
                padding: LaunchpadSpacingTokens.launchpadCreateSheetPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: SizedBox(
                        width: LaunchpadSpacingTokens.launchpadBox40,
                        height: AppSpacing.x1,
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            color: AppColors.borderSolid,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadii.xsRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Them canh bao gas',
                            style: AppTextStyles.base.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        VitIconButton(
                          key: LaunchpadGasTrackerPage.addCloseKey,
                          onPressed: widget.onClose,
                          icon: Icons.close_rounded,
                          tooltip: 'Dong them canh bao gas',
                          variant: VitIconButtonVariant.transparent,
                          size: VitIconButtonSize.md,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Text(
                      'Chain',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x2,
                      children: [
                        for (final price in widget.prices)
                          VitChoicePill(
                            key: LaunchpadGasTrackerPage.sheetChainKey(
                              price.chain,
                            ),
                            label: price.chain,
                            accentColor: price.accent.resolve(),
                            selected: _chain == price.chain,
                            onTap: () => setState(() => _chain = price.chain),
                            padding:
                                LaunchpadSpacingTokens.launchpadPillPadding,
                          ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Text(
                      'Dieu kien',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: VitChoicePill(
                            key: LaunchpadGasTrackerPage.sheetDirectionKey(
                              'below',
                            ),
                            label: 'Thap hon',
                            accentColor: AppColors.buy,
                            selected:
                                _direction == LaunchpadGasAlertDirection.below,
                            onTap: () => setState(
                              () =>
                                  _direction = LaunchpadGasAlertDirection.below,
                            ),
                            padding:
                                LaunchpadSpacingTokens.launchpadPillPadding,
                            fullWidth: true,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: VitChoicePill(
                            key: LaunchpadGasTrackerPage.sheetDirectionKey(
                              'above',
                            ),
                            label: 'Cao hon',
                            accentColor: AppColors.sell,
                            selected:
                                _direction == LaunchpadGasAlertDirection.above,
                            onTap: () => setState(
                              () =>
                                  _direction = LaunchpadGasAlertDirection.above,
                            ),
                            padding:
                                LaunchpadSpacingTokens.launchpadPillPadding,
                            fullWidth: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    Text(
                      'Nguong (${selected.unit})',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    VitInput(
                      controller: _thresholdController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (_) => setState(() {}),
                      semanticLabel: 'Ngưỡng cảnh báo gas',
                      hintText: 'VD: 15',
                      textStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmStandardSectionGap,
                    ),
                    VitCtaButton(
                      key: LaunchpadGasTrackerPage.addSubmitKey,
                      onPressed: _canSubmit ? () => _submit(selected) : null,
                      child: const Text('Them canh bao'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit(LaunchpadGasPriceDraft selected) {
    widget.onAdd(
      LaunchpadGasAlertDraft(
        id: 'ga_new_${DateTime.now().millisecondsSinceEpoch}',
        chain: selected.chain,
        accent: selected.accent,
        threshold: double.parse(_thresholdController.text.trim()),
        direction: _direction,
        unit: selected.unit,
        enabled: true,
        triggerCount: 0,
      ),
    );
  }
}
