part of '../../phone/pages/staking/staking_proof_of_reserves_page.dart';

class _AssetsTab extends StatelessWidget {
  const _AssetsTab({required this.snapshot});

  final StakingProofOfReservesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingProofOfReservesPage.assetsKey,
      label: 'Reserve Ratio by Asset',
      accentColor: AppColors.primarySoft,
      children: [
        for (final asset in snapshot.assets) _AssetReserveCard(asset: asset),
      ],
    );
  }
}

class _AssetReserveCard extends StatelessWidget {
  const _AssetReserveCard({required this.asset});

  final StakingAssetReserveDraft asset;

  @override
  Widget build(BuildContext context) {
    final progress = math.min(asset.reserveRatio / 150, 1.0);
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(asset.asset, style: AppTextStyles.baseMedium),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Updated: ${asset.lastUpdated}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${asset.reserveRatio.toStringAsFixed(1)}%',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.buy,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: AppSpacing.x2,
              value: progress,
              backgroundColor: AppColors.surface3,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.buy),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _InnerMetric(
                  label: 'On-Chain Balance',
                  value:
                      '${_formatAmount(asset.onChainBalance)} ${asset.asset}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InnerMetric(
                  label: 'User Liabilities',
                  value:
                      '${_formatAmount(asset.userLiabilities)} ${asset.asset}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            padding: EarnSpacingTokens.earnPaddingX3,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Address',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      const Padding(
                        padding: EarnSpacingTokens.earnTopPaddingX1,
                      ),
                      Text(
                        asset.walletAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                const VitAccentPill(
                  label: 'Verify',
                  accentColor: AppColors.primarySoft,
                  semanticStatus: VitStatusPillStatus.info,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatAmount(double value) {
  final text = value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  final parts = text.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  if (parts.length == 1) return buffer.toString();
  return '${buffer.toString()}.${parts.last}';
}
