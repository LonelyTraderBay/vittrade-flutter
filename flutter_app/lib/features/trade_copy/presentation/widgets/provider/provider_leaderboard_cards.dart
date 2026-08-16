part of '../../phone/pages/provider/provider_leaderboard_page.dart';

class _ProviderRankCard extends StatelessWidget {
  const _ProviderRankCard({
    required this.rank,
    required this.provider,
    required this.onOpen,
  });

  final int rank;
  final TradeCopyTrader provider;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final redFlags = _redFlags(provider);

    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: ProviderLeaderboardPage.providerKey(provider.id),
      height: redFlags.isEmpty
          ? AppSpacing.x7 + AppSpacing.x7 + AppSpacing.x4
          : AppSpacing.x7 + AppSpacing.x7 + AppSpacing.x6,
      radius: VitCardRadius.tight,
      padding: TradeSpacingTokens.providerLeaderboardCardPadding,
      density: VitDensity.tool,
      borderColor: AppColors.cardBorder,
      onTap: onOpen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RankBadge(rank: rank),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProviderTitle(provider: provider),
                const SizedBox(height: _leaderTinySpace),
                _MetricsRow(provider: provider),
                const SizedBox(height: _leaderTinySpace),
                _FollowersLabel(count: provider.copiers),
                if (redFlags.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  Wrap(
                    spacing: AppSpacing.x1 + AppSpacing.hairlineStroke,
                    runSpacing: AppSpacing.x1 + AppSpacing.hairlineStroke,
                    children: [
                      for (final flag in redFlags)
                        VitAccentPill(label: flag, accentColor: AppColors.sell),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Padding(
            padding: TradeSpacingTokens.providerLeaderboardTrailingIconPadding,
            child: Icon(
              Icons.visibility_outlined,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ),
        ],
      ),
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final podium = rank <= 3;
    return CircleAvatar(
      radius: AppSpacing.x5 - AppSpacing.hairlineStroke,
      backgroundColor: podium
          ? _leaderWarningText.withValues(alpha: .12)
          : _leaderChip,
      child: Text(
        '#$rank',
        style: AppTextStyles.caption.copyWith(
          color: podium ? _leaderWarningText : AppColors.text2,
          fontWeight: AppTextStyles.bold,
          height: _leaderLineFlat,
          fontFeatures: AppTextStyles.tabularFigures,
        ),
      ),
    );
  }
}

class _ProviderTitle extends StatelessWidget {
  const _ProviderTitle({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            provider.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: _leaderLineFlat,
            ),
          ),
        ),
        if (_isProviderVerified(provider)) ...[
          const SizedBox(
            width: TradeSpacingTokens.providerLeaderboardVerifiedIconGap,
          ),
          const Icon(
            Icons.check_circle_outline_rounded,
            color: _leaderPrimary,
            size: TradeSpacingTokens.providerLeaderboardVerifiedIcon,
          ),
        ],
        const SizedBox(
          width: TradeSpacingTokens.providerLeaderboardVerifiedIconGap,
        ),
        _RiskBadge(riskLevel: provider.riskLevel),
      ],
    );
  }
}

class _RiskBadge extends StatelessWidget {
  const _RiskBadge({required this.riskLevel});

  final TradeCopyRiskLevel riskLevel;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(riskLevel);
    return VitAccentPill(label: _riskLabel(riskLevel), accentColor: color);
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricValue(
            label: 'ROI',
            value: _formatSignedPercent(provider.totalPnlPct),
            color: provider.totalPnlPct >= 0 ? AppColors.buy : AppColors.sell,
          ),
        ),
        Expanded(
          child: _MetricValue(
            label: 'Sharpe',
            value: provider.sharpeRatio.toStringAsFixed(2),
          ),
        ),
        Expanded(
          child: _MetricValue(
            label: 'Max DD',
            value: '${provider.maxDrawdown.toStringAsFixed(1)}%',
            color: AppColors.sell,
          ),
        ),
      ],
    );
  }
}

class _MetricValue extends StatelessWidget {
  const _MetricValue({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _leaderLineFlat,
          ),
        ),
        const SizedBox(height: _leaderTinySpace),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: _leaderLineFlat,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _FollowersLabel extends StatelessWidget {
  const _FollowersLabel({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.group_outlined,
          color: AppColors.text3,
          size: TradeSpacingTokens.providerLeaderboardFollowersIcon,
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          '${_formatInteger(count)} followers',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: _leaderLineFlat,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}
