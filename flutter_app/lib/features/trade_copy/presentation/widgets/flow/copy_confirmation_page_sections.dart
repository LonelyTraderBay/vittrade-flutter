part of '../../phone/pages/flow/copy_confirmation_page.dart';

class _ProviderSummary extends StatelessWidget {
  const _ProviderSummary({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Row(
        children: [
          CircleAvatar(
            radius: AppSpacing.x5,
            backgroundColor: _confirmationPrimary.withValues(alpha: .16),
            child: Text(
              provider.avatar,
              style: AppTextStyles.baseMedium.copyWith(
                color: _confirmationPrimary,
                fontWeight: AppTextStyles.extraBold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bạn sắp copy',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  provider.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'ROI +${provider.totalPnlPct.toStringAsFixed(1)}% · Max DD ${provider.maxDrawdown.toStringAsFixed(1)}%',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
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

class _ConfigurationSummary extends StatelessWidget {
  const _ConfigurationSummary({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final config = snapshot.configuration;
    return VitPageSection(
      label: 'Cấu hình',
      accentColor: _confirmationPrimary,
      density: VitDensity.tool,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.tight,
          density: VitDensity.tool,
          child: Column(
            children: [
              VitKeyValueRow(
                label: 'Số vốn copy',
                value: '\$${config.copyCapital.toStringAsFixed(0)}',
              ),
              VitKeyValueRow(
                label: 'Chế độ copy',
                value: _copyModeLabel(config.copyMode),
              ),
              VitKeyValueRow(
                label: 'Stop-Loss',
                value: config.useCustomStopLoss
                    ? '-${config.customStopLoss.toStringAsFixed(0)}%'
                    : 'Theo provider',
              ),
              VitKeyValueRow(
                label: 'Take-Profit',
                value: config.useCustomTakeProfit
                    ? '+${config.customTakeProfit.toStringAsFixed(0)}%'
                    : 'Theo provider',
              ),
              VitKeyValueRow(
                label: 'Trailing Stop',
                value: config.useTrailingStop
                    ? '${config.trailingStopPercent.toStringAsFixed(0)}%'
                    : 'Không',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuitabilityReviewCard extends StatelessWidget {
  const _SuitabilityReviewCard({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final provider = snapshot.provider!;
    final config = snapshot.configuration;
    return VitPageSection(
      key: CopyConfirmationPage.suitabilityKey,
      label: 'Suitability & limits review',
      accentColor: AppColors.warn,
      density: VitDensity.tool,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.tight,
          density: VitDensity.tool,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitKeyValueRow(
                label: 'Risk suitability',
                value:
                    '${_riskLabel(provider.riskLevel)} risk · DD ${provider.maxDrawdown.toStringAsFixed(1)}%',
                valueColor: AppColors.warn,
              ),
              VitKeyValueRow(
                label: 'Copy amount review',
                value: '\$${config.copyCapital.toStringAsFixed(0)} at risk',
                valueColor: _confirmationRed,
              ),
              const VitKeyValueRow(
                label: 'Provider limit',
                value: 'Max 20% portfolio per provider',
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Confirm this amount fits your risk tolerance, provider drawdown, and portfolio limit before cooling-off starts.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeeBreakdown extends StatelessWidget {
  const _FeeBreakdown({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final fee = snapshot.feePreview;
    return VitPageSection(
      label: 'Chi phí & Phí',
      accentColor: AppColors.warn,
      density: VitDensity.tool,
      children: [
        VitCard(
          radius: VitCardRadius.tight,
          density: VitDensity.tool,
          child: Column(
            children: [
              VitKeyValueRow(
                label: 'Platform fee (0.1%)',
                value: '\$${fee.platformFee.toStringAsFixed(2)}',
              ),
              VitKeyValueRow(
                label: 'Trading fees ước tính',
                value: '\$${fee.estimatedTradingFees.toStringAsFixed(2)}',
              ),
              VitKeyValueRow(
                label: 'Performance fee',
                value: fee.performanceFeeNote,
              ),
              const Divider(
                color: AppColors.divider,
                thickness: AppSpacing.hairlineStroke,
              ),
              VitKeyValueRow(
                label: 'Tổng phí cố định tháng đầu',
                value: '\$${fee.totalFixedFees.toStringAsFixed(2)}',
                valueColor: _confirmationRed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScenarioSection extends StatelessWidget {
  const _ScenarioSection({required this.scenarios});

  final List<TradeCopyScenarioProjection> scenarios;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Kịch bản dự kiến (30 ngày)',
      accentColor: _confirmationGreen,
      density: VitDensity.tool,
      children: [
        for (final scenario in scenarios) _ScenarioCard(scenario: scenario),
      ],
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final TradeCopyScenarioProjection scenario;

  @override
  Widget build(BuildContext context) {
    final color = switch (scenario.id) {
      'optimistic' => _confirmationGreen,
      'realistic' => AppColors.warn,
      _ => _confirmationRed,
    };
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        children: [
          VitKeyValueRow(
            label:
                '${scenario.title} (${scenario.returnPct.toStringAsFixed(0)}%)',
            value:
                '${scenario.netPnl >= 0 ? '+' : ''}\$${scenario.netPnl.toStringAsFixed(0)}',
            valueColor: color,
          ),
          VitKeyValueRow(
            label: 'Net return',
            value:
                '${scenario.netReturnPct >= 0 ? '+' : ''}${scenario.netReturnPct.toStringAsFixed(1)}%',
            valueColor: color,
          ),
        ],
      ),
    );
  }
}

class _MaxLossCard extends StatelessWidget {
  const _MaxLossCard({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: _confirmationRed,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kịch bản mất vốn tối đa',
            style: AppTextStyles.caption.copyWith(
              color: _confirmationRed,
              fontWeight: AppTextStyles.extraBold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Bạn có thể mất tối đa \$${snapshot.maxLossAmount.toStringAsFixed(0)} nếu provider gặp drawdown nghiêm trọng.',
            style: AppTextStyles.caption.copyWith(color: AppColors.sellSoft),
          ),
        ],
      ),
    );
  }
}

class _ConsentSection extends StatelessWidget {
  const _ConsentSection({
    required this.items,
    required this.acceptedIds,
    required this.onToggle,
  });

  final List<TradeCopyConsentItem> items;
  final Set<String> acceptedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Xác nhận & Đồng ý',
      accentColor: _confirmationRed,
      density: VitDensity.tool,
      children: [
        for (final item in items)
          TradeCopyConsentCard(
            cardKey: CopyConfirmationPage.consentKey(item.id),
            checked: acceptedIds.contains(item.id),
            text: item.label,
            accentColor: _confirmationPrimary,
            onTap: () => onToggle(item.id),
          ),
      ],
    );
  }
}
