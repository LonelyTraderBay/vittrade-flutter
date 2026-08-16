part of '../../phone/pages/bridge/launchpad_swap_aggregator_page.dart';

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeTab, required this.onChanged});

  final _SwapTab activeTab;
  final ValueChanged<_SwapTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.tabsKey,
      child: VitTabBar(
        tabs: const [
          VitTabItem(key: 'compare', label: 'So s\u00E1nh'),
          VitTabItem(key: 'history', label: 'L\u1ECBch s\u1EED'),
          VitTabItem(key: 'settings', label: 'C\u00E0i \u0111\u1EB7t'),
        ],
        activeKey: activeTab.name,
        onChanged: (key) => onChanged(_SwapTab.values.byName(key)),
        variant: VitTabBarVariant.underline,
      ),
    );
  }
}

class _SwapInputCard extends StatelessWidget {
  const _SwapInputCard({
    required this.fromToken,
    required this.toToken,
    required this.amountController,
    required this.output,
    required this.bestPrice,
    required this.onFlip,
    required this.onAmountChanged,
  });

  final String fromToken;
  final String toToken;
  final TextEditingController amountController;
  final double output;
  final double bestPrice;
  final VoidCallback onFlip;
  final ValueChanged<String> onAmountChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadSwapAggregatorPage.inputKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      clip: true,
      padding: AppSpacing.cardPadding,
      background: const VitHeroGlow(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'T\u1EEB',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent.withValues(alpha: .72),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              _TokenButton(token: fromToken, color: AppColors.buy),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitInput(
                  controller: amountController,
                  onChanged: onAmountChanged,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.end,
                  semanticLabel: 'Số tiền hoán đổi Launchpad',
                  hintText: '0.00',
                  textStyle: AppTextStyles.amountSm.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Center(
            child: VitIconButton(
              key: LaunchpadSwapAggregatorPage.flipKey,
              onPressed: onFlip,
              icon: Icons.swap_vert_rounded,
              tooltip: '\u0110\u1EA3o chi\u1EC1u swap',
              variant: VitIconButtonVariant.primary,
              size: VitIconButtonSize.md,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'SANG',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent.withValues(alpha: .72),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              _TokenButton(token: toToken, color: AppColors.accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '~${output.toStringAsFixed(4)}',
                      style: AppTextStyles.amountSm.copyWith(
                        color: AppColors.onAccent,
                        fontWeight: AppTextStyles.bold,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      '@${bestPrice.toStringAsFixed(2)} $fromToken',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.onAccent.withValues(alpha: .55),
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokenButton extends StatelessWidget {
  const _TokenButton({required this.token, required this.color});

  final String token;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowGapRegular,
        right: AppSpacing.rowGapRegular,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VitAssetAvatar(
            label: token,
            accentColor: color,
            size: AppSpacing.buttonCompact - AppSpacing.x2,
            radius: AppRadii.smRadius,
            border: true,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            token,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.onAccent.withValues(alpha: .72),
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _BestRouteCard extends StatelessWidget {
  const _BestRouteCard({required this.bestDex, required this.savings});

  final LaunchpadSwapDexQuoteDraft bestDex;
  final num savings;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.bestRouteKey,
      child: VitNextActionCard(
        icon: Icons.bolt_rounded,
        title: 'T\u1EF7 gi\u00E1 t\u1ED1t: ${bestDex.name}',
        subtitle:
            'Ti\u1EBFt ki\u1EC7m ${savings.toStringAsFixed(2)}% so v\u1EDBi route k\u00E9m nh\u1EA5t \u00B7 Gas: \$${bestDex.gas.toStringAsFixed(0)}',
        statusLabel: 'T\u1ED1t nh\u1EA5t',
        ctaLabel: 'Xem',
        accentColor: AppColors.buy,
      ),
    );
  }
}
