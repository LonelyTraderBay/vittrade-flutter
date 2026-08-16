part of 'referral_home_page.dart';

class _PendingCommissionCard extends StatelessWidget {
  const _PendingCommissionCard({required this.item});

  final ReferralPendingCommissionDraft item;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.warningBorder,
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _Avatar(initial: item.friendInitial, color: AppColors.warn),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.friendName,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    _InlineIconText(
                      icon: Icons.schedule_rounded,
                      text: item.reason,
                      color: AppColors.warn,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '~${_formatUsd(item.amount)}',
                    style: AppTextStyles.base.copyWith(
                      color: AppColors.warn,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    item.currency,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitProgressBar(
            progress: item.progress / 100,
            color: AppColors.warn,
            height: _progressExtent,
            borderRadius: AppRadii.xsRadius,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            item.reasonDetail,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Align(
            alignment: Alignment.centerLeft,
            child: _TinyPill(
              label: item.eta,
              color: AppColors.warn,
              background: AppColors.warn08,
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.chip,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final String? chip;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: color.withValues(alpha: .20),
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              VitAccentIconBox(icon: icon, color: color, iconSize: 18),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            subtitle,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          if (chip != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            _TinyPill(
              label: chip!,
              color: AppColors.primarySoft,
              background: AppColors.warn08,
            ),
          ],
        ],
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  const _LeaderboardRow({required this.item});

  final ReferralLeaderboardDraft item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: _rankSlot,
          child: Text(
            '#${item.rank}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        _Avatar(initial: item.name.characters.first, color: AppColors.primary),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '${item.friends} bạn mới · ${item.tier}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
        Text(
          _formatUsd(item.totalEarned),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _DetailLinkRow extends StatelessWidget {
  const _DetailLinkRow({
    required this.item,
    required this.showDivider,
    required this.onTap,
  });

  final ReferralDetailLinkDraft item;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = _detailStyle(item.id);
    return VitCard(
      key: switch (item.id) {
        'friends' => ReferralHomePage.detailHistoryKey,
        'rewards' => ReferralHomePage.detailRewardsKey,
        'rules' => ReferralHomePage.detailRulesKey,
        _ => null,
      },
      onTap: onTap,
      variant: VitCardVariant.ghost,
      borderColor: AppColors.transparent,
      padding: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: Border(
            bottom: showDivider
                ? const BorderSide(color: AppColors.divider)
                : BorderSide.none,
          ),
        ),
        child: Padding(
          padding: ReferralSpacingTokens.referralLedgerHeaderPadding,
          child: Row(
            children: [
              VitAccentIconBox(
                icon: style.icon,
                color: style.color,
                iconSize: 18,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
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

class _StepRow extends StatelessWidget {
  const _StepRow({required this.step});

  final ReferralStepDraft step;

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.warn,
      AppColors.buy,
    ];
    final color = colors[(step.step - 1).clamp(0, colors.length - 1)];
    return Padding(
      padding: ReferralSpacingTokens.referralStepRowPadding,
      child: Row(
        children: [
          VitAccentIconBox(
            icon: Icons.check_rounded,
            color: color,
            iconSize: 18,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  step.description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          SizedBox(
            width: _stepBadgeExtent,
            height: _stepBadgeExtent,
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.surface2,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
              ),
              child: Center(
                child: Text(
                  '${step.step}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignHistoryCard extends StatelessWidget {
  const _CampaignHistoryCard({required this.item});

  final ReferralCampaignHistoryDraft item;

  @override
  Widget build(BuildContext context) {
    final active = item.statusLabel == 'Đang diễn ra';
    final progress = active ? .28 : 1.0;
    final color = active ? AppColors.buy : AppColors.primary;
    return VitCard(
      key: ReferralHomePage.campaignHistoryKey(item.id),
      borderColor: active ? AppColors.buy20 : AppColors.cardBorder,
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _TinyPill(
                label: item.statusLabel,
                color: active ? AppColors.buy : AppColors.text2,
                background: active ? AppColors.buy10 : AppColors.surface2,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            item.dateRange,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            item.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            padding: ReferralSpacingTokens.referralInnerPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: _TinyPill(
                        label: item.bonusLabel,
                        color: AppColors.accent,
                        background: AppColors.accent10,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      '${_formatCompactInt(item.participants)} tham gia',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  item.result,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                VitProgressBar(
                  progress: progress,
                  color: color,
                  height: _progressExtent,
                  borderRadius: AppRadii.xsRadius,
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Row(
                  children: [
                    Expanded(
                      child: _HistoryDatum(
                        label: 'Kết quả của bạn',
                        value: item.result,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: _HistoryDatum(
                        label: 'Cộng đồng',
                        value:
                            '${_formatCompactInt(item.participants)} tham gia',
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                if (active) ...[
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  const _NoticeCard(
                    icon: Icons.campaign_rounded,
                    text: 'Đang diễn ra - mời thêm bạn bè để nhận x2.',
                    color: AppColors.buy,
                    background: AppColors.buy10,
                    border: AppColors.buy20,
                    dense: true,
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

class _HistoryDatum extends StatelessWidget {
  const _HistoryDatum({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: ReferralSpacingTokens.referralInnerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
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
