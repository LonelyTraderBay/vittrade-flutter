part of '../../phone/pages/flow/copy_configuration_page.dart';

class _RiskSection extends StatelessWidget {
  const _RiskSection({required this.draft, required this.onDraftChanged});

  final TradeCopyConfigurationDraft draft;
  final ValueChanged<TradeCopyConfigurationDraft> onDraftChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Giới hạn rủi ro',
      accentColor: _configurationRed,
      density: VitDensity.tool,
      children: [
        _RiskToggle(
          title: 'Stop-Loss riêng',
          value: draft.useCustomStopLoss,
          onChanged: (value) =>
              onDraftChanged(draft.copyWith(useCustomStopLoss: value)),
        ),
        _RiskToggle(
          title: 'Take-Profit riêng',
          value: draft.useCustomTakeProfit,
          onChanged: (value) =>
              onDraftChanged(draft.copyWith(useCustomTakeProfit: value)),
        ),
        _RiskToggle(
          title: 'Trailing Stop',
          value: draft.useTrailingStop,
          onChanged: (value) =>
              onDraftChanged(draft.copyWith(useTrailingStop: value)),
        ),
      ],
    );
  }
}

class _FeeSection extends StatelessWidget {
  const _FeeSection({required this.preview});

  final TradeCopyConfigurationPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Dự kiến chi phí',
      accentColor: AppColors.warn,
      density: VitDensity.tool,
      children: [
        VitFinancialSafetySummary(
          title: 'Copy fee preview',
          contractId: 'SC-072 Copy configuration',
          density: VitDensity.tool,
          footer:
              'Review platform fee, trading fee estimate, performance fee, and copy risk before confirmation.',
          items: [
            VitFinancialSafetyItem(
              label: 'Platform fee',
              value: '\$${preview.feePreview.platformFee.toStringAsFixed(2)}',
              leading: const Icon(Icons.account_balance_outlined),
              valueColor: AppColors.text2,
            ),
            VitFinancialSafetyItem(
              label: 'Estimated trading fees',
              value:
                  '\$${preview.feePreview.estimatedTradingFees.toStringAsFixed(2)}',
              leading: const Icon(Icons.receipt_long_outlined),
              valueColor: AppColors.text2,
            ),
            VitFinancialSafetyItem(
              label: 'Performance fee',
              value: preview.feePreview.performanceFeeNote,
              leading: const Icon(Icons.percent_rounded),
              valueColor: AppColors.text2,
            ),
            VitFinancialSafetyItem(
              label: 'Fixed fees total',
              value:
                  '\$${preview.feePreview.totalFixedFees.toStringAsFixed(2)}',
              leading: const Icon(Icons.payments_outlined),
              valueColor: _configurationRed,
            ),
            const VitFinancialSafetyItem(
              label: 'Risk check',
              value: 'Confirm copier limits before submit',
              leading: Icon(Icons.verified_user_outlined),
              valueColor: AppColors.warn,
            ),
          ],
        ),
      ],
    );
  }
}

class _ValidationList extends StatelessWidget {
  const _ValidationList({required this.items});

  final List<TradeCopyConfigurationValidation> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) ...[
          _ValidationCard(item: item),
          if (item != items.last) const SizedBox(height: _configurationSpace),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.draft});

  final TradeCopyConfigurationDraft draft;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tóm tắt cấu hình',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: _configurationSpace),
          VitKeyValueRow(
            label: 'Số vốn copy',
            value: '\$${draft.copyCapital.toStringAsFixed(0)}',
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: AppSpacing.x1,
            ),
            labelStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
            valueStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: FontWeight.w700,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          VitKeyValueRow(
            label: 'Chế độ',
            value: _modeLabel(draft.copyMode),
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: AppSpacing.x1,
            ),
            labelStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
            valueStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: FontWeight.w700,
            ),
          ),
          VitKeyValueRow(
            label: 'Stop-Loss',
            value: draft.useCustomStopLoss
                ? '-${draft.customStopLoss.toStringAsFixed(0)}%'
                : 'Theo provider',
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: AppSpacing.x1,
            ),
            labelStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
            valueStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: FontWeight.w700,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          VitKeyValueRow(
            label: 'Take-Profit',
            value: draft.useCustomTakeProfit
                ? '+${draft.customTakeProfit.toStringAsFixed(0)}%'
                : 'Theo provider',
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: AppSpacing.x1,
            ),
            labelStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
            valueStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: FontWeight.w700,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          VitKeyValueRow(
            label: 'Trailing Stop',
            value: draft.useTrailingStop
                ? '${draft.trailingStopPercent.toStringAsFixed(0)}%'
                : 'Không',
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: AppSpacing.x1,
            ),
            labelStyle: AppTextStyles.micro.copyWith(color: AppColors.text3),
            valueStyle: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: FontWeight.w700,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final TradeCopyConfigurationMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyConfigurationPage.modeKey(mode),
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: selected ? _configurationPrimary : null,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      padding: AppSpacing.cardPaddingCompact,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? _configurationPrimary : AppColors.text3,
            size: TradeSpacingTokens.copyConfigurationModeIcon,
          ),
          const SizedBox(width: _configurationCardSpace),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _modeLabel(mode),
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? _configurationPrimary : AppColors.text1,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  _modeDescription(mode),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: _configurationDescriptionLineHeight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
