import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/phone/copy_trading_card_demo_primitives.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

final class CopyTradingCardDemoUiKeys {
  const CopyTradingCardDemoUiKeys._();

  static Key cardKey(String id) => Key('sc401_card_$id');
}

class CopyTradingVariantSection extends StatelessWidget {
  const CopyTradingVariantSection({
    super.key,
    required this.variant,
    required this.metrics,
  });

  final TradeCopyCardVariantDraft variant;
  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                variant.title,
                style: AppTextStyles.sectionTitleSm.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            if (variant.badge != null) ...[
              const SizedBox(width: AppSpacing.x3),
              CopyTradingBadge(label: variant.badge!),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _CopyCard(variantId: variant.id, metrics: metrics),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCard(
          variant: VitCardVariant.standard,
          padding: TradeSpacingTokens.tradeBotCopyDemoCardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                variant.notesTitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              for (final item in variant.notes)
                CopyTradingIconLine(
                  icon: Icons.check_circle_rounded,
                  text: item,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CopyCard extends StatelessWidget {
  const _CopyCard({required this.variantId, required this.metrics});

  final String variantId;
  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return switch (variantId) {
      'hero' => _HeroCopyCard(metrics: metrics),
      'tabular' => _TabularCopyCard(metrics: metrics),
      _ => _CompactCopyCard(metrics: metrics),
    };
  }
}

class _HeroCopyCard extends StatelessWidget {
  const _HeroCopyCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemoUiKeys.cardKey('hero'),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.large,
      padding: TradeSpacingTokens.tradeBotCopyDemoPanelPadding,
      borderColor: AppColors.borderSolid,
      child: Column(
        children: [
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.large,
            padding: TradeSpacingTokens.tradeBotCopyDemoPanelPadding,
            borderColor: AppColors.cardBorder,
            background: const ColoredBox(color: AppColors.surface),
            child: Column(
              children: [
                Text(
                  'ASSET UNDER MANAGEMENT',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  formatCopyTradingUsd(metrics.aumUsd),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.numericDisplayHeroSm,
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                CopyTradingTrendPill(value: metrics.aumTrendPercent),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _SecondaryMetric(
                  icon: Icons.people_alt_outlined,
                  label: 'TRADERS',
                  value: '${metrics.traders}',
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SecondaryMetric(
                  icon: Icons.group_add_outlined,
                  label: 'COPIERS',
                  value: formatCopyTradingCompact(metrics.copiers),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            'Updated ${metrics.lastUpdated}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabularCopyCard extends StatelessWidget {
  const _TabularCopyCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemoUiKeys.cardKey('tabular'),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.large,
      padding: TradeSpacingTokens.tradeBotCopyDemoPanelPadding,
      child: Column(
        children: [
          _CopyCardHeader(),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          _TableMetricRow(
            label: 'Total AUM',
            value: formatCopyTradingUsd(metrics.aumUsd),
            trailing: CopyTradingTrendSmall(value: metrics.aumTrendPercent),
          ),
          _TableMetricRow(
            label: 'Active Traders',
            value: '${metrics.traders}',
            icon: Icons.people_alt_outlined,
          ),
          _TableMetricRow(
            label: 'Total Copiers',
            value: formatCopyTradingCompact(metrics.copiers),
            icon: Icons.group_add_outlined,
            showDivider: false,
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Last updated: ${metrics.lastUpdated}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              CopyTradingSmallButton(label: 'View Details', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactCopyCard extends StatelessWidget {
  const _CompactCopyCard({required this.metrics});

  final TradeCopyCardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyTradingCardDemoUiKeys.cardKey('compact'),
      variant: VitCardVariant.standard,
      radius: VitCardRadius.large,
      padding: TradeSpacingTokens.tradeBotCopyDemoPanelPadding,
      child: Column(
        children: [
          _CopyCardHeader(),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _CompactMetric(
                  label: 'TRADERS',
                  value: '${metrics.traders}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _CompactMetric(
                  label: 'COPIERS',
                  value: formatCopyTradingCompact(metrics.copiers),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _CompactMetric(
                  label: 'AUM',
                  value: formatCopyTradingUsd(metrics.aumUsd),
                  emphasized: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CopyCardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const VitCard(
          variant: VitCardVariant.ghost,
          radius: VitCardRadius.standard,
          padding: TradeSpacingTokens.tradeBotCopyDemoCardPadding,
          background: ColoredBox(color: AppColors.primary),
          child: Icon(
            Icons.dashboard_customize_outlined,
            color: AppColors.navCenterIcon,
            size: TradeSpacingTokens.tradeBotClientMoneyProtectionGap,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Copy Trading',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                'Sao chép trader chuyên nghiệp',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SecondaryMetric extends StatelessWidget {
  const _SecondaryMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: TradeSpacingTokens.tradeBotCopyDemoCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 15),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(value, style: AppTextStyles.numericDisplayLg),
        ],
      ),
    );
  }
}

class _TableMetricRow extends StatelessWidget {
  const _TableMetricRow({
    required this.label,
    required this.value,
    this.icon,
    this.trailing,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Widget? trailing;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: TradeSpacingTokens.tradeBotCopyDemoDividerPadding,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.text2, size: 16),
                const SizedBox(width: AppSpacing.x2),
              ],
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.baseMedium.copyWith(
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(height: AppSpacing.x1),
                    trailing!,
                  ],
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class _CompactMetric extends StatelessWidget {
  const _CompactMetric({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: TradeSpacingTokens.tradeBotCopyDemoCompactPadding,
      borderColor: emphasized ? AppColors.primary40 : null,
      background: const ColoredBox(color: AppColors.bg),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: emphasized ? AppColors.primary : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
