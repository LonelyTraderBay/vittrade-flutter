import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_compliance/presentation/widgets/governance/transaction_reporting_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

class TransactionReportingStatsGrid extends StatelessWidget {
  const TransactionReportingStatsGrid({required this.stats, super.key});

  final TradeTransactionReportingStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Total Today',
            value: '${stats.total}',
            caption: '${stats.confirmed} confirmed',
            color: AppColors.primary,
            icon: Icons.description_outlined,
          ),
        ),
        const SizedBox(width: AppSpacing.rowGapRegular),
        Expanded(
          child: _StatCard(
            label: 'Avg Latency',
            value: '${stats.avgLatencySeconds}s',
            caption: 'Under 60s SLA',
            color: transactionReportGreen,
            icon: Icons.bolt_rounded,
          ),
        ),
        const SizedBox(width: AppSpacing.rowGapRegular),
        Expanded(
          child: _StatCard(
            label: 'SLA Compliance',
            value: '${(stats.onTime / stats.total * 100).toStringAsFixed(0)}%',
            caption: '${stats.onTime}/${stats.total} on-time',
            color: transactionReportGreen,
            icon: Icons.trending_up_rounded,
          ),
        ),
      ],
    );
  }
}

class TransactionReportingStatsTab extends StatelessWidget {
  const TransactionReportingStatsTab({required this.stats, super.key});

  final TradeTransactionReportingStats stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Reporting Statistics',
          style: AppTextStyles.badge.copyWith(
            color: AppColors.text3,
            height: TradeSpacingTokens.transactionReportingLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCard(
          variant: VitCardVariant.inner,
          radius: VitCardRadius.tight,
          padding: TradeSpacingTokens.transactionReportingStatsPanelPadding,
          borderColor: transactionReportBorder.withValues(alpha: .7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatColumn(
                  title: "Today's Volume",
                  rows: [
                    ('MiFID II Reports', '${stats.mifidReports}'),
                    ('EMIR Reports', '${stats.emirReports}'),
                    (
                      'Total Value',
                      formatTransactionReportUsd(stats.totalValue),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.ctaLoadingIcon),
              Expanded(
                child: _StatColumn(
                  title: 'ARM Providers',
                  rows: stats.providerCounts.entries
                      .map((entry) => (entry.key, '${entry.value}'))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          key: transactionReportingActionKey('dashboard-primary'),
          onPressed: () =>
              context.go(AppRoutePaths.tradeCopyRegulatoryReportsDashboard),
          height: AppSpacing.searchBarCompactHeight,
          leading: const Icon(Icons.bar_chart_rounded),
          child: const Text('View Full Dashboard'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final String caption;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      height: AppSpacing.buttonHero + AppSpacing.x2,
      padding: TradeSpacingTokens.transactionReportingStatCardPadding,
      borderColor: transactionReportBorder.withValues(alpha: .65),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height:
                        TradeSpacingTokens.transactionReportingLineHeightTight,
                  ),
                ),
                const SizedBox(
                  height: AppSpacing.rowGapRegular + AppSpacing.x1,
                ),
                Text(
                  value,
                  style: AppTextStyles.amountSm.copyWith(
                    color: AppColors.text1,
                    height:
                        TradeSpacingTokens.transactionReportingLineHeightTight,
                  ),
                ),
                const Spacer(),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    height:
                        TradeSpacingTokens.transactionReportingLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            width: AppSpacing.iconLg,
            height: AppSpacing.iconLg,
            borderColor: color.withValues(alpha: .24),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: color,
              size: TradeSpacingTokens.transactionReportingStatIcon,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.badge.copyWith(
            color: AppColors.text3,
            height: TradeSpacingTokens.transactionReportingLineHeightTight,
          ),
        ),
        const SizedBox(height: AppSpacing.rowGapRegular + AppSpacing.x1),
        for (final row in rows) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  row.$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height:
                        TradeSpacingTokens.transactionReportingLineHeightTight,
                  ),
                ),
              ),
              Text(
                row.$2,
                style: AppTextStyles.numericCode.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height:
                      TradeSpacingTokens.transactionReportingLineHeightTight,
                ),
              ),
            ],
          ),
          if (row != rows.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        ],
      ],
    );
  }
}
