part of '../../phone/pages/social/prediction_social_page.dart';

class _SentimentCard extends StatelessWidget {
  const _SentimentCard({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Sentiment',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          SizedBox(
            height: AppSpacing.x7 * 4,
            child: CustomPaint(
              painter: PredictionSocialSentimentPiePainter(snapshot.sentiment),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              for (final item in snapshot.sentiment)
                Expanded(child: PredictionSocialSentimentLegend(item: item)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContributorsSection extends StatelessWidget {
  const _ContributorsSection({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Nguoi dong gop hang dau',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        for (var i = 0; i < snapshot.contributors.length; i += 1)
          _ContributorCard(rank: i, contributor: snapshot.contributors[i]),
      ],
    );
  }
}

class _SocialShareButtons extends StatelessWidget {
  const _SocialShareButtons({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return const VitPageSection(
      label: 'Chia se qua mang xa hoi',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        Row(
          children: [
            Expanded(
              child: PredictionSocialShareButton(
                label: 'Twitter',
                color: AppColors.brandTwitter,
              ),
            ),
            SizedBox(
              width: PredictionsSpacingTokens.predictionSocialShareButtonGap,
            ),
            Expanded(
              child: PredictionSocialShareButton(
                label: 'Facebook',
                color: AppColors.brandFacebook,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CopyLinkCard extends StatelessWidget {
  const _CopyLinkCard({
    required this.snapshot,
    required this.copied,
    required this.onCopy,
  });

  final PredictionSocialSnapshot snapshot;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sao chep lien ket',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: VitDensity.compact.controlHeight,
                  child: Material(
                    color: AppColors.bg,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.border),
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: Padding(
                      padding: PredictionsSpacingTokens
                          .predictionSocialCopyBoxPadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          snapshot.shareUrl,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionSocialCopyButtonGap,
              ),
              VitCtaButton(
                key: PredictionSocialPage.copyLinkKey,
                onPressed: onCopy,
                variant: copied
                    ? VitCtaButtonVariant.success
                    : VitCtaButtonVariant.primary,
                fullWidth: false,
                height: VitDensity.compact.controlHeight,
                leading: Icon(
                  copied ? Icons.check_rounded : Icons.copy_rounded,
                  size: PredictionsSpacingTokens.predictionSocialCopyIcon,
                ),
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.x3,
                ),
                child: Text(copied ? 'Copied' : 'Copy'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShareStatsCard extends StatelessWidget {
  const _ShareStatsCard();

  @override
  Widget build(BuildContext context) {
    return const VitCard(
      density: VitDensity.compact,
      child: Row(
        children: [
          Expanded(
            child: PredictionSocialMetric(
              label: 'Total Shares',
              value: '1,247',
            ),
          ),
          Expanded(
            child: PredictionSocialMetric(
              label: 'Views from Shares',
              value: '4,892',
              valueColor: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _SharePreviewCard extends StatelessWidget {
  const _SharePreviewCard({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Preview',
      accentColor: _predictionPrimary,
      density: VitDensity.compact,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Material(
                color: _predictionPrimary,
                borderRadius: AppRadii.mdRadius,
                child: SizedBox.square(
                  dimension:
                      PredictionsSpacingTokens.predictionSocialPreviewImage,
                  child: Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.onAccent,
                    size: PredictionsSpacingTokens.predictionSocialPreviewIcon,
                  ),
                ),
              ),
              const SizedBox(
                width: PredictionsSpacingTokens.predictionSocialPreviewGap,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.eventTitle,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Join the prediction market and share your insights with the community.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'app.example.com',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContributorCard extends StatelessWidget {
  const _ContributorCard({required this.rank, required this.contributor});

  final int rank;
  final PredictionContributorDraft contributor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: _rankColor(rank),
            size: PredictionsSpacingTokens.predictionSocialContributorIcon,
          ),
          const SizedBox(
            width: PredictionsSpacingTokens.predictionSocialContributorGap,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      contributor.name,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(
                      width: PredictionsSpacingTokens
                          .predictionSocialContributorBadgeGap,
                    ),
                    _SmallBadge(
                      label: _tierLabel(contributor.tier),
                      color: _tierColor(contributor.tier),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${contributor.comments} comments - ${contributor.upvotes} upvotes',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SentimentTrendCard extends StatelessWidget {
  const _SentimentTrendCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sentiment Trend',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Bullish sentiment tang 12% trong 24h qua. Cho thay su lac quan tang len.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

Color _stanceColor(PredictionSocialStance stance) {
  return switch (stance) {
    PredictionSocialStance.bullish => AppColors.buy,
    PredictionSocialStance.bearish => AppColors.sell,
    PredictionSocialStance.neutral => AppColors.text3,
  };
}

String _stanceLabel(PredictionSocialStance stance) {
  return switch (stance) {
    PredictionSocialStance.bullish => 'Bullish',
    PredictionSocialStance.bearish => 'Bearish',
    PredictionSocialStance.neutral => 'Neutral',
  };
}

Color _tierColor(PredictionSocialTier tier) {
  return switch (tier) {
    PredictionSocialTier.platinum => AppColors.tierPlatinum,
    PredictionSocialTier.gold => AppColors.warn,
    PredictionSocialTier.silver => AppColors.medalSilverMuted,
    PredictionSocialTier.bronze => AppColors.medalBronzeMuted,
  };
}

String _tierLabel(PredictionSocialTier tier) {
  return switch (tier) {
    PredictionSocialTier.platinum => 'PLATINUM',
    PredictionSocialTier.gold => 'GOLD',
    PredictionSocialTier.silver => 'SILVER',
    PredictionSocialTier.bronze => 'BRONZE',
  };
}

Color _rankColor(int rank) {
  return switch (rank) {
    0 => AppColors.warn,
    1 => AppColors.medalSilverMuted,
    _ => AppColors.medalBronzeMuted,
  };
}
