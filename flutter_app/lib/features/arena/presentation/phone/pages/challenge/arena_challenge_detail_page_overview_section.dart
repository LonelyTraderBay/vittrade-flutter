part of 'arena_challenge_detail_page.dart';

class _ChallengeIntro extends StatelessWidget {
  const _ChallengeIntro({required this.snapshot, required this.onMode});

  final ArenaChallengeDetailSnapshot snapshot;
  final VoidCallback onMode;

  @override
  Widget build(BuildContext context) {
    final challenge = snapshot.challenge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: _challengeTinyGap,
          runSpacing: _challengeTinyGap,
          children: [
            VitStatusPill(
              label: challenge.statusLabel,
              status: VitStatusPillStatus.success,
              icon: Icons.monitor_heart_outlined,
              size: VitStatusPillSize.sm,
              pulse: true,
            ),
            VitStatusPill(
              label: challenge.layoutLabel,
              status: VitStatusPillStatus.info,
              icon: Icons.groups_2_outlined,
              size: VitStatusPillSize.sm,
            ),
            VitStatusPill(
              label: challenge.privacyLabel,
              status: VitStatusPillStatus.neutral,
              icon: Icons.public_outlined,
              size: VitStatusPillSize.sm,
            ),
            const VitStatusPill(
              label: 'Points Only',
              status: VitStatusPillStatus.orange,
              icon: Icons.star_border_rounded,
              size: VitStatusPillSize.sm,
            ),
          ],
        ),
        const SizedBox(height: _challengeGap),
        Text(
          challenge.title,
          style: AppTextStyles.sectionTitle.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.heavy,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
        const SizedBox(height: _challengeTinyGap),
        _InlineAction(
          key: ArenaChallengeDetailPage.modeLinkKey,
          label: challenge.modeName,
          icon: Icons.chevron_right_rounded,
          color: _arenaAccent,
          onTap: onMode,
        ),
        const SizedBox(height: _challengeTinyGap),
        Text(
          challenge.description,
          style: AppTextStyles.body.copyWith(
            color: AppColors.text2,
            height: AppTextStyles.numericMicro.height,
          ),
        ),
      ],
    );
  }
}

class _LiveStatusCard extends StatelessWidget {
  const _LiveStatusCard({required this.challenge});

  final ArenaChallengeDetailDraft challenge;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _ChallengeHeroKpi(
                  label: 'Entry Points',
                  value: '${challenge.entryPoints}',
                  valueColor: AppColors.primary,
                ),
              ),
              const SizedBox(
                width: 1,
                height: AppSpacing.x6,
                child: ColoredBox(color: AppColors.border),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.x3,
                  ),
                  child: _ChallengeHeroKpi(
                    label: 'Prize Pool',
                    value: _formatCompact(challenge.prizePool),
                    valueColor: AppColors.buy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                size: AppSpacing.iconSm,
                color: AppColors.text3,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                challenge.countdownLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Người tham gia',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                '${challenge.slotsFilled} / ${challenge.slotsTotal}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x1),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: _challengeProgressHeight,
              value: challenge.fillPercent / 100,
              color: _arenaAccent,
              backgroundColor: AppColors.surface3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeHeroKpi extends StatelessWidget {
  const _ChallengeHeroKpi({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.heroNumber.copyWith(
            color: valueColor,
            letterSpacing: 0,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _PoolFeeCard extends StatelessWidget {
  const _PoolFeeCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _challengeCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              const _SmallIcon(
                icon: Icons.receipt_long_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: _challengeGap),
              Expanded(
                child: Text(
                  'Chi tiết Pool & Phí',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'MINH BẠCH',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
              const SizedBox(width: _challengeTinyGap),
              const Icon(Icons.expand_more_rounded, color: AppColors.text3),
            ],
          ),
        ],
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.tiers});

  final List<ArenaRewardTierDraft> tiers;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _challengeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SmallIcon(
                icon: Icons.workspace_premium_outlined,
                color: AppColors.primary,
              ),
              const SizedBox(width: _challengeGap),
              Expanded(
                child: Text(
                  'Cách chia thưởng',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'Winner Takes All',
                status: VitStatusPillStatus.orange,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: _challengeGap),
          for (final tier in tiers)
            Material(
              color: AppColors.warningBg,
              borderRadius: AppRadii.cardRadius,
              child: Padding(
                padding: _challengeCardPadding,
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events_outlined,
                      color: AppColors.primary,
                      size: _challengeMdIcon,
                    ),
                    const SizedBox(width: _challengeGap),
                    Expanded(
                      child: Text(
                        tier.label,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      tier.value,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.buy,
                        fontFeatures: AppTextStyles.tabularFigures,
                        fontWeight: AppTextStyles.bold,
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

class _RefundCard extends StatelessWidget {
  const _RefundCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.sync_outlined,
      title: 'Chính sách hoàn điểm',
      text: text,
      color: AppColors.primary,
    );
  }
}

class _TeamsSection extends StatelessWidget {
  const _TeamsSection({required this.teams});

  final List<ArenaTeamDraft> teams;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Thành viên',
      accentColor: _arenaAccent,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < teams.length; index++) ...[
              Expanded(child: _TeamCard(team: teams[index])),
              if (index != teams.length - 1)
                const SizedBox(width: _challengeGap),
            ],
          ],
        ),
      ],
    );
  }
}

class _TeamCard extends StatelessWidget {
  const _TeamCard({required this.team});

  final ArenaTeamDraft team;

  Color get _color =>
      team.accent == VitArenaTeamAccent.sol ? _arenaAccent : AppColors.sell;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _color.withValues(alpha: .34),
      padding: _challengeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: _challengeTeamDot,
                height: _challengeTeamDot,
                child: Material(color: _color, shape: const CircleBorder()),
              ),
              const SizedBox(width: _challengeTinyGap),
              Expanded(
                child: Text(
                  team.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _challengeGap),
          Wrap(
            spacing: _challengeTinyGap,
            runSpacing: _challengeTinyGap,
            children: [
              for (final member in team.members)
                _MemberChip(member: member, color: _color),
            ],
          ),
        ],
      ),
    );
  }
}

class _MemberChip extends StatelessWidget {
  const _MemberChip({required this.member, required this.color});

  final ArenaTeamMemberDraft member;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: ArenaSpacingTokens.arenaPresetPillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InitialBadge(name: member.name, color: color),
            const SizedBox(width: _challengeTinyGap),
            Flexible(
              child: Text(
                member.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.medium,
                  height: AppTextStyles.numericMicro.height,
                ),
              ),
            ),
            if (member.role.isNotEmpty) ...[
              const SizedBox(width: _challengeTinyGap),
              Flexible(
                child: Text(
                  member.role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    height: AppTextStyles.numericMicro.height,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RuleSummaryCard extends StatelessWidget {
  const _RuleSummaryCard({required this.rows});

  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return _RowsSection(
      title: 'Tóm tắt luật chơi',
      accentColor: AppColors.buy,
      rows: rows,
    );
  }
}

class _GovernanceCard extends StatelessWidget {
  const _GovernanceCard({required this.challenge, required this.rows});

  final ArenaChallengeDetailDraft challenge;
  final List<ArenaRuleSummaryRow> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _challengeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.buy,
                size: _challengeLgIcon,
              ),
              const SizedBox(width: _challengeTinyGap),
              Expanded(
                child: Text(
                  'Governance & Trust',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: _challengeTinyGap,
                    runSpacing: _challengeTinyGap,
                    children: [
                      VitStatusPill(
                        label: challenge.trustRiskLabel,
                        status: VitStatusPillStatus.orange,
                        size: VitStatusPillSize.sm,
                      ),
                      VitStatusPill(
                        label: challenge.policyVersion,
                        status: VitStatusPillStatus.neutral,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _challengeGap),
          for (final row in rows)
            _SummaryRow(label: row.label, value: row.value),
        ],
      ),
    );
  }
}
