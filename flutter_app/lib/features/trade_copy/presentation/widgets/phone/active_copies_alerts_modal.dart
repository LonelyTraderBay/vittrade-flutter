part of '../../phone/pages/hub/active_copies_page.dart';

class _RiskAlert extends StatelessWidget {
  const _RiskAlert({required this.onViewDetails});

  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return const VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      density: VitDensity.tool,
      title: 'Cảnh báo rủi ro',
      message:
          'Một copy đang lỗ >5%. Xem xét dừng copy hoặc điều chỉnh stop-loss.',
      contractId: 'Active copy risk alert',
    );
  }
}

class _ActionStatusBanner extends StatelessWidget {
  const _ActionStatusBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      density: VitDensity.tool,
      title: 'Copy action recorded',
      message: text,
      contractId: 'Active copy action',
    );
  }
}

class _StopCopyModal extends StatefulWidget {
  const _StopCopyModal({
    required this.copy,
    required this.confirmText,
    required this.onTextChanged,
    required this.onCancel,
    required this.onConfirm,
  });

  final TradeActiveCopy copy;
  final String confirmText;
  final ValueChanged<String> onTextChanged;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  State<_StopCopyModal> createState() => _StopCopyModalState();
}

class _StopCopyModalState extends State<_StopCopyModal> {
  late final TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();
    _confirmController = TextEditingController(text: widget.confirmText);
  }

  @override
  void didUpdateWidget(covariant _StopCopyModal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.confirmText != oldWidget.confirmText &&
        widget.confirmText != _confirmController.text) {
      _confirmController.text = widget.confirmText;
    }
  }

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = widget.confirmText.toLowerCase() == 'stop';

    return Positioned.fill(
      child: Material(
        color: AppColors.dynamicIslandBg.withValues(alpha: .54),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: VitSheetSurface(
            padding: TradeSpacingTokens.activeCopiesStopSheetPadding(
              MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VitSheetHandle(),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Row(
                  children: [
                    const SizedBox.square(
                      dimension: AppSpacing.searchBarCompactHeight,
                      child: VitCard(
                        variant: VitCardVariant.inner,
                        radius: VitCardRadius.tight,
                        borderColor: AppColors.sell20,
                        alignment: Alignment.center,
                        child: Icon(Icons.stop_rounded, color: AppColors.sell),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.cardGap),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dừng copy?',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            widget.copy.providerName,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.rowPy),
                VitCard(
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.tight,
                  padding: AppSpacing.cardPaddingCompact,
                  borderColor: AppColors.sell20,
                  child: Text(
                    'Cảnh báo: khi dừng copy, các vị thế đang mở có thể được đóng. Hành động này cần xác nhận rõ ràng.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.sell,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  'Nhập STOP để xác nhận',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                VitInput(
                  controller: _confirmController,
                  fieldKey: ActiveCopiesPage.stopConfirmInputKey,
                  hintText: 'STOP',
                  textInputAction: TextInputAction.done,
                  onChanged: widget.onTextChanged,
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: _SheetButton(label: 'Hủy', onTap: widget.onCancel),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _SheetButton(
                        key: ActiveCopiesPage.stopConfirmButtonKey,
                        label: 'Dừng copy',
                        onTap: canConfirm ? widget.onConfirm : null,
                        danger: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetButton extends StatelessWidget {
  const _SheetButton({
    super.key,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      density: VitDensity.tool,
      variant: danger
          ? VitCtaButtonVariant.danger
          : VitCtaButtonVariant.secondary,
      child: Text(label),
    );
  }
}
