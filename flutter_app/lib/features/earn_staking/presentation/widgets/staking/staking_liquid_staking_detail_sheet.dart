part of '../../phone/pages/staking/staking_liquid_staking_page.dart';

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: AppSpacing.zeroInsets.copyWith(
          left: AppSpacing.contentPad,
          top: AppSpacing.contentPad,
          right: AppSpacing.contentPad,
          bottom: AppSpacing.contentPad,
        ),
        child: VitSheetSurface(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
          padding: AppSpacing.cardPaddingHero,
          child: child,
        ),
      ),
    );
  }
}

class _TokenDetailSheet extends StatelessWidget {
  const _TokenDetailSheet({required this.token});

  final StakingLiquidTokenDraft token;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: StakingLiquidStakingPage.detailSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(token.name, style: AppTextStyles.sectionTitle),
              ),
              VitIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Close',
                onPressed: () => Navigator.of(context).pop(),
                variant: VitIconButtonVariant.transparent,
                size: VitIconButtonSize.md,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            padding: AppSpacing.cardPadding,
            child: Column(
              children: [
                _SheetRow(
                  label: 'Exchange Rate',
                  value:
                      '1 ${token.symbol} = ${token.exchangeRate} ${token.underlyingAsset}',
                ),
                _SheetRow(
                  label: 'APY',
                  value: '${token.apy}%',
                  valueColor: AppColors.buy,
                ),
                _SheetRow(
                  label: 'Total Supply',
                  value: '${_formatAmount(token.totalSupply)} ${token.symbol}',
                ),
                _SheetRow(label: 'TVL', value: _formatUsd(token.tvl)),
                _SheetRow(label: 'Protocol', value: token.protocol),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _BulletSection(
            title: 'Lợi ích',
            items: token.benefits,
            success: true,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _BulletSection(title: 'Rủi ro', items: token.risks, success: false),
        ],
      ),
    );
  }
}

class _BulletSection extends StatelessWidget {
  const _BulletSection({
    required this.title,
    required this.items,
    required this.success,
  });

  final String title;
  final List<String> items;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final color = success ? AppColors.buy : AppColors.sell;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        for (final item in items)
          Padding(
            padding: AppSpacing.zeroInsets.copyWith(bottom: AppSpacing.x2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.zeroInsets.copyWith(top: AppSpacing.x3),
                  child: Material(
                    color: color,
                    shape: const CircleBorder(),
                    child: const SizedBox(
                      width: AppSpacing.x1,
                      height: AppSpacing.x1,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
