part of '../../phone/pages/settings/bot_emergency_stop_page.dart';

class _StickyActions extends StatelessWidget {
  const _StickyActions({
    required this.bottomPadding,
    required this.canSubmit,
    required this.stopping,
    required this.onCancel,
    required this.onSubmit,
  });

  final double bottomPadding;
  final bool canSubmit;
  final bool stopping;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: TradeSpacingTokens.tradeBotFooterPadding.copyWith(
        bottom: bottomPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: VitCtaButton(
              key: BotEmergencyStopPage.cancelKey,
              density: VitDensity.tool,
              height: TradeSpacingTokens.tradeBotFooterButtonHeight,
              variant: VitCtaButtonVariant.secondary,
              onPressed: onCancel,
              child: Text(
                'Hủy',
                style: AppTextStyles.body.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: TradeSpacingTokens.tradeBotCardGap),
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: canSubmit || stopping ? 1 : 0.55,
              child: VitCtaButton(
                key: BotEmergencyStopPage.submitKey,
                density: VitDensity.tool,
                height: TradeSpacingTokens.tradeBotFooterButtonHeight,
                variant: VitCtaButtonVariant.destructive,
                loading: stopping,
                onPressed: canSubmit ? onSubmit : null,
                leading: const Icon(Icons.stop_circle_outlined),
                child: Text(
                  stopping ? 'Đang dừng...' : 'Dừng tất cả Bot ngay',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
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

class _CheckboxMark extends StatelessWidget {
  const _CheckboxMark({required this.selected, required this.color});

  final bool selected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      selected
          ? Icons.check_box_rounded
          : Icons.check_box_outline_blank_rounded,
      color: selected ? color : _stopOptionBorder,
      size: TradeSpacingTokens.tradeBotCheckbox,
    );
  }
}

IconData _reasonIcon(String iconName) {
  return switch (iconName) {
    'crash' => Icons.show_chart_rounded,
    'bug' => Icons.settings_suggest_rounded,
    'unauthorized' => Icons.warning_amber_rounded,
    'drawdown' => Icons.error_outline_rounded,
    _ => Icons.help_outline_rounded,
  };
}

Color _reasonColor(TradeBotEmergencyReason reason) {
  return switch (reason.iconName) {
    'crash' => AppColors.crashAccent,
    'bug' => AppColors.statusBattery,
    'unauthorized' => AppColors.sell,
    'drawdown' => AppColors.caution,
    _ => AppColors.text2,
  };
}
