part of '../../phone/pages/staking/staking_liquid_staking_page.dart';

class _StakeTab extends StatelessWidget {
  const _StakeTab({
    required this.snapshot,
    required this.onDetail,
    required this.onStake,
  });

  final StakingLiquidStakingSnapshot snapshot;
  final ValueChanged<StakingLiquidTokenDraft> onDetail;
  final ValueChanged<StakingLiquidTokenDraft> onStake;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Chọn Liquid Token',
          accentColor: AppColors.primary,
          children: [
            for (final token in snapshot.tokens)
              _LiquidTokenCard(
                token: token,
                onDetail: () => onDetail(token),
                onStake: () => onStake(token),
              ),
          ],
        ),
        _RiskNote(snapshot: snapshot),
      ],
    );
  }
}

class _LiquidTokenCard extends StatelessWidget {
  const _LiquidTokenCard({
    required this.token,
    required this.onDetail,
    required this.onStake,
  });

  final StakingLiquidTokenDraft token;
  final VoidCallback onDetail;
  final VoidCallback onStake;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingLiquidStakingPage.tokenKey(token.id),
      radius: VitCardRadius.large,
      padding: AppSpacing.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Material(
                color: AppColors.primary12,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.xlRadius,
                  side: BorderSide(color: AppColors.primary30),
                ),
                child: SizedBox(
                  width: AppSpacing.ctaHeight,
                  height: AppSpacing.ctaHeight,
                  child: Icon(
                    Icons.water_drop_rounded,
                    color: AppColors.primarySoft,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            token.symbol,
                            style: AppTextStyles.baseMedium,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        _ProtocolPill(label: token.protocol),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '1 ${token.symbol} = ${token.exchangeRate.toStringAsFixed(3)} ${token.underlyingAsset}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${token.apy.toStringAsFixed(1)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _TokenMetric(
                  label: 'TVL',
                  value: _formatBillions(token.tvl),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TokenMetric(
                  label: 'Supply',
                  value: _formatMillions(token.totalSupply),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: StakingLiquidStakingPage.detailButtonKey(token.id),
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.buttonCompact,
                  onPressed: onDetail,
                  child: const Text('Chi tiết'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: StakingLiquidStakingPage.stakeButtonKey(token.id),
                  height: AppSpacing.buttonCompact,
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onPressed: onStake,
                  child: const Text('Stake'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProtocolPill extends StatelessWidget {
  const _ProtocolPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: AppColors.primarySoft);
  }
}

class _TokenMetric extends StatelessWidget {
  const _TokenMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(value, style: AppTextStyles.baseMedium),
        ],
      ),
    );
  }
}

class _RiskNote extends StatelessWidget {
  const _RiskNote({required this.snapshot});

  final StakingLiquidStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      padding: AppSpacing.cardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Lưu ý: ',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(
                    text: snapshot.riskNote,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
