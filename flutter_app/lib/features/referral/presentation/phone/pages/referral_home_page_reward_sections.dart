part of 'referral_home_page.dart';

class _EarningCalculator extends StatelessWidget {
  const _EarningCalculator({
    required this.friends,
    required this.currentTier,
    required this.onChanged,
  });

  final double friends;
  final ReferralTierRuleDraft currentTier;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final friendCount = friends.round();
    final monthly = friendCount * 42.0 * currentTier.commissionPercent / 100;
    final yearly = monthly * 12;

    return VitCard(
      key: ReferralHomePage.calculatorKey,
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Thu nhập nháp ước tính',
            variant: VitSectionHeaderVariant.accentBar,
            accentColor: AppColors.primary,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          Text(
            'Kéo để ước tính thêm bạn mới trong tháng',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Slider(
            value: friends,
            min: 0,
            max: 20,
            divisions: 20,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.surface3,
            onChanged: onChanged,
          ),
          Row(
            children: [
              Expanded(
                child: VitMetricCard(
                  label: 'Bạn mới',
                  value: '+$friendCount',
                  accentColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitMetricCard(
                  label: 'Hoa hồng/tháng',
                  value: _formatUsd(monthly),
                  accentColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitMetricCard(
                  label: 'Hoa hồng/năm',
                  value: _formatUsd(yearly),
                  accentColor: AppColors.primarySoft,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PendingCommissionSection extends StatelessWidget {
  const _PendingCommissionSection({required this.items});

  final List<ReferralPendingCommissionDraft> items;

  @override
  Widget build(BuildContext context) {
    final total = items.fold(0.0, (sum, item) => sum + item.amount);
    return VitPageSection(
      label: 'Hoa hồng đang chờ',
      accentColor: AppColors.warn,
      density: VitDensity.compact,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: VitAccentPill(
            label: '~${_formatUsd(total)}',
            accentColor: AppColors.warn,
            size: VitStatusPillSize.sm,
            semanticStatus: VitStatusPillStatus.warning,
          ),
        ),
        for (final item in items) _PendingCommissionCard(item: item),
      ],
    );
  }
}

class _RewardHighlights extends StatelessWidget {
  const _RewardHighlights({required this.currentTier, required this.campaign});

  final ReferralTierRuleDraft currentTier;
  final ReferralCampaignDraft campaign;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Thưởng của bạn',
      accentColor: AppColors.buy,
      children: [
        Row(
          children: [
            Expanded(
              child: _RewardCard(
                icon: Icons.card_giftcard_rounded,
                title: 'Thưởng KYC',
                value: _formatUsd(currentTier.kycBonus),
                subtitle: 'Mỗi bạn hoàn tất KYC',
                color: AppColors.buy,
                chip: 'x${campaign.bonusMultiplier} đang áp dụng',
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _RewardCard(
                icon: Icons.trending_up_rounded,
                title: 'Hoa hồng',
                value: '${currentTier.commissionPercent}%',
                subtitle: 'Phí GD của bạn bè, vĩnh viễn',
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LeaderboardSection extends StatelessWidget {
  const _LeaderboardSection({required this.items});

  final List<ReferralLeaderboardDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ReferralSpacingTokens.referralCardPadding,
      child: VitPageSection(
        label: 'Bảng xếp hạng',
        accentColor: AppColors.accent,
        density: VitDensity.compact,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: VitAccentPill(
              label: 'Tháng 3/2026',
              accentColor: AppColors.accent,
              size: VitStatusPillSize.sm,
              semanticStatus: VitStatusPillStatus.purple,
            ),
          ),
          for (final item in items) _LeaderboardRow(item: item),
          const _NoticeCard(
            icon: Icons.info_outline_rounded,
            text:
                'Bảng xếp hạng tính theo số bạn mới đủ KYC. Công khai minh bạch để tránh spam.',
            color: AppColors.text3,
            background: AppColors.surface2,
            border: AppColors.cardBorder,
            dense: true,
          ),
        ],
      ),
    );
  }
}

class _TransparencyNote extends StatelessWidget {
  const _TransparencyNote({required this.commissionPercent});

  final int commissionPercent;

  @override
  Widget build(BuildContext context) {
    return _NoticeCard(
      icon: Icons.warning_amber_rounded,
      text:
          'Hoa hồng = Phí GD thực tế của bạn bè x $commissionPercent%. Cộng real-time vào ví USDT, không giới hạn thời gian.',
      color: AppColors.text3,
      background: AppColors.surface2,
      border: AppColors.cardBorder,
    );
  }
}

class _DetailLinks extends StatelessWidget {
  const _DetailLinks({required this.links, required this.onOpen});

  final List<ReferralDetailLinkDraft> links;
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < links.length; i++)
            _DetailLinkRow(
              item: links[i],
              showDivider: i < links.length - 1,
              onTap: () => onOpen(links[i].route),
            ),
        ],
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection({required this.steps});

  final List<ReferralStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VitSectionHeader(
            title: 'Cách thức hoạt động',
            variant: VitSectionHeaderVariant.accentBar,
            accentColor: AppColors.primary,
            bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          ),
          for (final step in steps) ...[
            _StepRow(step: step),
            if (step != steps.last) const Divider(color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _MonthStats extends StatelessWidget {
  const _MonthStats({required this.stats});

  final ReferralHomeStatsDraft stats;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Tháng này',
      accentColor: AppColors.warn,
      children: [
        Row(
          children: [
            Expanded(
              child: VitMetricCard(
                label: 'Hoa hồng tháng này',
                value: '+${_formatUsd(stats.thisMonthCommission)}',
                accentColor: AppColors.buy,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitMetricCard(
                label: 'Bạn mới tháng này',
                value: '+${stats.thisMonthFriends}',
                accentColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CampaignHistorySection extends StatelessWidget {
  const _CampaignHistorySection({required this.items});

  final List<ReferralCampaignHistoryDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Lịch sử sự kiện',
      accentColor: AppColors.accent,
      density: VitDensity.compact,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: VitAccentPill(
            label: '${items.length} sự kiện',
            accentColor: AppColors.accent,
            size: VitStatusPillSize.sm,
            semanticStatus: VitStatusPillStatus.purple,
          ),
        ),
        for (final item in items) _CampaignHistoryCard(item: item),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  final String label;
  final String value;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      child: Column(
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextDim,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SplitReward extends StatelessWidget {
  const _SplitReward({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.portfolioTextMuted,
          ),
        ),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _SocialProofMetric extends StatelessWidget {
  const _SocialProofMetric({required this.item, required this.color});

  final ReferralSocialProofDraft item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .08),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color.withValues(alpha: .15)),
          borderRadius: AppRadii.inputRadius,
        ),
      ),
      child: Padding(
        padding: ReferralSpacingTokens.referralCompactPillPadding,
        child: Row(
          children: [
            Icon(Icons.insights_rounded, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.value,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  item.label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({required this.item, required this.totalFriends});

  final ReferralMilestoneDraft item;
  final int totalFriends;

  @override
  Widget build(BuildContext context) {
    final claimable = !item.claimed && totalFriends >= item.friends;
    final next = !item.claimed && totalFriends < item.friends;
    final color = item.claimed
        ? AppColors.buy
        : claimable
        ? AppColors.primary
        : next
        ? AppColors.warn
        : AppColors.text3;
    return SizedBox(
      key: ReferralHomePage.milestoneKey(item.id),
      width: _milestoneCardWidth,
      child: VitCard(
        borderColor: color.withValues(alpha: .24),
        padding: ReferralSpacingTokens.referralInnerPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  item.claimed
                      ? Icons.check_circle_rounded
                      : Icons.flag_rounded,
                  color: color,
                  size: AppSpacing.iconMd,
                ),
                const Expanded(child: SizedBox.shrink()),
                Text(
                  '${item.friends}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              '${item.friends} bạn bè',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              item.reward,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            Text(
              item.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}
