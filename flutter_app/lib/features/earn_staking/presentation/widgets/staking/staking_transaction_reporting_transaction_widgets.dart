part of '../../phone/pages/staking/staking_transaction_reporting_page.dart';

class _RewardAssetRow extends StatelessWidget {
  const _RewardAssetRow({required this.reward});

  final StakingTaxRewardAssetDraft reward;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: _transactionReportingCardPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward.asset, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${_formatAmount(reward.amount)} ${reward.asset}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                EarnFormatters.usd(reward.usdValue),
                style: AppTextStyles.baseMedium.copyWith(
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Taxable income',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab({required this.snapshot});

  final StakingTransactionReportingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingTransactionReportingPage.transactionsKey,
      label: 'All Transactions ${snapshot.defaultYear}',
      accentColor: AppColors.primarySoft,
      density: VitDensity.compact,
      children: [
        for (final tx in snapshot.transactions) _TransactionCard(tx: tx),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.tx});

  final StakingTaxTransactionDraft tx;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _transactionReportingCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_typeLabel(tx.type)} ${_formatAmount(tx.amount)} ${tx.asset}',
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      tx.date,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    EarnFormatters.usd(tx.usdValue),
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  if (tx.taxable) ...[
                    const SizedBox(height: AppSpacing.x1),
                    const VitStatusPill(
                      label: 'Taxable',
                      status: VitStatusPillStatus.warning,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ],
              ),
            ],
          ),
          if (tx.costBasis != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            const Divider(
              color: AppColors.borderSolid,
              height: _transactionReportingDividerExtent,
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Cost Basis:',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                Text(
                  EarnFormatters.usd(tx.costBasis!),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ExportTab extends StatelessWidget {
  const _ExportTab({required this.snapshot, required this.onOpenExport});

  final StakingTransactionReportingSnapshot snapshot;
  final VoidCallback onOpenExport;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingTransactionReportingPage.exportKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Generate Tax Forms',
          accentColor: AppColors.primarySoft,
          density: VitDensity.compact,
          children: [
            _ExportCategoryCard(
              title: 'IRS Tax Forms (PDF)',
              subtitle: 'Form 1099-MISC, 8949, Schedule D',
              icon: Icons.description_outlined,
              color: AppColors.sell,
              onTap: onOpenExport,
            ),
            _ExportCategoryCard(
              title: 'Third-Party Integrations',
              subtitle: 'TurboTax, CoinTracker, Koinly',
              icon: Icons.open_in_new_rounded,
              color: AppColors.primarySoft,
              onTap: onOpenExport,
            ),
            _ExportCategoryCard(
              title: 'Raw Data Export',
              subtitle: 'CSV, JSON formats',
              icon: Icons.data_object_rounded,
              color: AppColors.buy,
              onTap: onOpenExport,
            ),
          ],
        ),
        VitCard(
          variant: VitCardVariant.inner,
          borderColor: AppColors.warningBorder,
          padding: _transactionReportingCardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Important Tax Notice',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      snapshot.taxNotice,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        height: _transactionReportingBodyLineHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        VitPageSection(
          label: 'Helpful Resources',
          accentColor: AppColors.primarySoft,
          density: VitDensity.compact,
          children: [
            for (final resource in snapshot.resources)
              _ResourceRow(resource: resource),
          ],
        ),
      ],
    );
  }
}

class _ExportCategoryCard extends StatelessWidget {
  const _ExportCategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      onTap: onTap,
      padding: _transactionReportingCardPadding,
      child: Row(
        children: [
          Material(
            color: color.withValues(alpha: 0.12),
            borderRadius: AppRadii.lgRadius,
            child: SizedBox(
              width: _transactionReportingIconBox,
              height: _transactionReportingIconBox,
              child: Icon(icon, color: color, size: AppSpacing.iconMd),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.baseMedium),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.download_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({required this.resource});

  final StakingTaxResourceDraft resource;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: _transactionReportingCardPadding,
      child: Row(
        children: [
          Expanded(child: Text(resource.label, style: AppTextStyles.caption)),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.primarySoft,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}
