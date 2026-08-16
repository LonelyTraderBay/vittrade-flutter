part of '../../phone/pages/bridge/launchpad_swap_aggregator_page.dart';

class _DexList extends StatelessWidget {
  const _DexList({
    required this.quotes,
    required this.amount,
    required this.expandedDexId,
    required this.onToggle,
  });

  final List<LaunchpadSwapDexQuoteDraft> quotes;
  final double amount;
  final String? expandedDexId;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.dexListKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'So s\u00E1nh DEX',
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
            density: VitDensity.compact,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            clip: true,
            padding: AppSpacing.zeroInsets,
            child: Column(
              children: [
                for (var i = 0; i < quotes.length; i++) ...[
                  _DexQuoteCard(
                    quote: quotes[i],
                    amount: amount,
                    expanded: expandedDexId == quotes[i].id,
                    onToggle: () => onToggle(quotes[i].id),
                  ),
                  if (i < quotes.length - 1)
                    const Divider(
                      height: AppSpacing.dividerHairline,
                      thickness: AppSpacing.dividerHairline,
                      color: AppColors.divider,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DexQuoteCard extends StatelessWidget {
  const _DexQuoteCard({
    required this.quote,
    required this.amount,
    required this.expanded,
    required this.onToggle,
  });

  final LaunchpadSwapDexQuoteDraft quote;
  final double amount;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final output = amount == 0 ? 0.0 : amount / quote.price;
    final impactColor = quote.priceImpact < .2
        ? AppColors.buy
        : quote.priceImpact < .3
        ? AppColors.primary
        : AppColors.sell;
    return Material(
      color: quote.recommended
          ? AppColors.buy.withValues(alpha: .04)
          : AppColors.transparent,
      child: InkWell(
        key: LaunchpadSwapAggregatorPage.dexToggleKey(quote.id),
        onTap: onToggle,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            children: [
              Row(
                children: [
                  _DexLogo(quote: quote),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.x2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              quote.name,
                              style: AppTextStyles.base.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            if (quote.recommended)
                              const VitStatusPill(
                                label: 'T\u1ED0T NH\u1EA4T',
                                status: VitStatusPillStatus.success,
                                size: VitStatusPillSize.sm,
                              ),
                          ],
                        ),
                        Text(
                          quote.estimatedTime,
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
                        output.toStringAsFixed(4),
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      Text(
                        '~\$${amount.toStringAsFixed(0)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              Row(
                children: [
                  _Metric(
                    label: 'Price Impact',
                    value: '${quote.priceImpact.toStringAsFixed(2)}%',
                    color: impactColor,
                    align: TextAlign.start,
                  ),
                  _Metric(
                    label: 'Gas Fee',
                    value: '\$${quote.gas.toStringAsFixed(0)}',
                    color: AppColors.text1,
                    align: TextAlign.center,
                  ),
                  _Metric(
                    label: 'Liquidity',
                    value:
                        '\$${(quote.liquidity / 1000000).toStringAsFixed(1)}M',
                    color: AppColors.text1,
                    align: TextAlign.end,
                  ),
                ],
              ),
              if (expanded) ...[
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                _RouteDetails(quote: quote),
              ],
              const SizedBox(height: AppSpacing.x1),
              Icon(
                expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DexLogo extends StatelessWidget {
  const _DexLogo({required this.quote});

  final LaunchpadSwapDexQuoteDraft quote;

  @override
  Widget build(BuildContext context) {
    return VitAssetAvatar(
      label: quote.symbol,
      accentColor: quote.accent.resolve(),
      size: AppSpacing.buttonCompact + AppSpacing.x1,
      radius: AppRadii.smRadius,
      border: true,
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.color,
    required this.align,
  });

  final String label;
  final String value;
  final Color color;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: switch (align) {
          TextAlign.end => CrossAxisAlignment.end,
          TextAlign.center => CrossAxisAlignment.center,
          _ => CrossAxisAlignment.start,
        },
        children: [
          Text(
            label,
            textAlign: align,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            textAlign: align,
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

class _RouteDetails extends StatelessWidget {
  const _RouteDetails({required this.quote});

  final LaunchpadSwapDexQuoteDraft quote;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route',
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (var i = 0; i < quote.route.length; i++) ...[
                VitAccentPill(
                  label: quote.route[i],
                  accentColor: AppColors.primary,
                ),
                if (i < quote.route.length - 1)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: AppSpacing.iconSm,
                  ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Icon(
                Icons.shield_outlined,
                color: quote.security == LaunchpadSwapSecurity.high
                    ? AppColors.buy
                    : AppColors.primary,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                'Security: ${quote.security == LaunchpadSwapSecurity.high ? 'High' : 'Medium'}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwapWarning extends StatelessWidget {
  const _SwapWarning({required this.slippage});

  final String slippage;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.warningKey,
      child: VitHighRiskStatePanel(
        state: VitHighRiskUiState.riskReview,
        title: 'Xem l\u1EA1i route tr\u01B0\u1EDBc khi swap',
        message:
            'Gi\u00E1 ch\u1EC9 mang t\u00EDnh tham kh\u1EA3o. Ki\u1EC3m tra l\u1EA1i tr\u01B0\u1EDBc khi swap. Slippage: $slippage%',
        contractId: 'Launchpad swap route',
      ),
    );
  }
}
