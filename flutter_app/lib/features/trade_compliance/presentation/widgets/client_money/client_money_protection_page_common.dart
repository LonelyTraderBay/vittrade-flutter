part of '../../phone/pages/client_money/client_money_protection_page.dart';

class _Reconciliation extends StatelessWidget {
  const _Reconciliation();

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Daily Reconciliation',
      density: VitDensity.tool,
      children: [
        VitCard(
          density: VitDensity.tool,
          radius: VitCardRadius.tight,
          borderColor: _moneyBorder.withValues(alpha: .72),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Latest Reconciliation',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ),
                  const _MatchedPill(),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              const _ReconciliationRow(
                label: 'Client Ledger Balance',
                value: '\$45,230.50',
              ),
              const SizedBox(height: AppSpacing.x1),
              const _ReconciliationRow(
                label: 'Bank Account Balance',
                value: '\$45,230.50',
              ),
              const SizedBox(height: AppSpacing.x1),
              const _ReconciliationRow(
                label: 'Difference',
                value: '\$0.00',
                success: true,
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                'Last reconciled: Today at 09:00 UTC - Next: Tomorrow at 09:00 UTC',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        VitCtaButton(
          key: ClientMoneyProtectionPage.cassHistoryKey,
          onPressed: () =>
              context.go(AppRoutePaths.tradeCopyCassReconciliation),
          variant: VitCtaButtonVariant.secondary,
          density: VitDensity.tool,
          leading: const Icon(
            Icons.visibility_outlined,
            size: TradeSpacingTokens.tradeBotCheckboxIcon,
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            size: TradeSpacingTokens.tradeBotCheckboxIcon,
          ),
          child: Text(
            'View Full Reconciliation History',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _Documents extends StatelessWidget {
  const _Documents();

  @override
  Widget build(BuildContext context) {
    const documents = [
      ('Client Money Letter', 'Your segregation agreement', _moneyPrimary),
      ('CASS Compliance Report', 'Annual auditor report', _moneyGreen),
      (
        'Insolvency Protection Guide',
        'What happens to your funds',
        AppColors.caution,
      ),
    ];
    return VitPageSection(
      label: 'CASS Documents',
      density: VitDensity.tool,
      children: [
        for (final document in documents)
          VitCard(
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            borderColor: _moneyBorder.withValues(alpha: .72),
            child: Row(
              children: [
                // card-tile: allow-start — fixed surface, not horizontal strip tile
                VitCard(
                  width: TradeSpacingTokens.tradeBotClientMoneyDocumentIcon,
                  height: TradeSpacingTokens.tradeBotClientMoneyDocumentIcon,
                  variant: VitCardVariant.inner,
                  radius: VitCardRadius.tight,
                  alignment: Alignment.center,
                  borderColor: document.$3.withValues(alpha: .35),
                  child: Icon(
                    document.$1 == 'Insolvency Protection Guide'
                        ? Icons.shield_outlined
                        : Icons.description_outlined,
                    color: document.$3,
                    size: TradeSpacingTokens.tradeBotClientMoneyDocumentGlyph,
                  ),
                ),
                const SizedBox(width: TradeSpacingTokens.tradeBotCardIconGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.$1,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        document.$2,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.download_rounded,
                  color: AppColors.text3,
                  size: TradeSpacingTokens.tradeBotClientMoneyDocumentGlyph,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitMetricBox(label: label, value: value, alignLeft: true);
  }
}

class _ReconciliationRow extends StatelessWidget {
  const _ReconciliationRow({
    required this.label,
    required this.value,
    this.success = false,
  });

  final String label;
  final String value;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final color = success ? _moneyGreen : AppColors.text1;
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      borderColor: success ? _moneyGreen.withValues(alpha: .35) : null,
      padding: TradeSpacingTokens.tradeBotClientMoneyRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: success ? _moneyGreen : AppColors.text3,
                fontWeight: success ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchedPill extends StatelessWidget {
  const _MatchedPill();

  @override
  Widget build(BuildContext context) {
    return const VitStatusPill(
      label: 'MATCHED',
      status: VitStatusPillStatus.success,
      size: VitStatusPillSize.sm,
    );
  }
}

String _formatUsd(double value) => formatTradeUsd(value);
