part of '../../phone/pages/challenge/arena_join_page.dart';

class _ChallengeSummaryCard extends StatelessWidget {
  const _ChallengeSummaryCard({required this.challenge});

  final ArenaChallengeDetailDraft challenge;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            challenge.title,
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.heavy,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                challenge.modeName,
                style: AppTextStyles.caption.copyWith(
                  color: _arenaAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '·',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              Text(
                challenge.layoutLabel,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JoinContextCard extends StatelessWidget {
  const _JoinContextCard({required this.challenge, required this.creator});

  final ArenaChallengeDetailDraft challenge;
  final ArenaChallengeCreatorDraft creator;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaJoinCardPadding,
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox.square(
                dimension: ArenaSpacingTokens.arenaJoinCreatorAvatar,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: AppColors.surface2,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                      side: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.workspace_premium_rounded,
                      color: _arenaAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creator.name,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      creator.role,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.divider, height: AppSpacing.x5),
          _InfoRow(
            label: 'Quyền riêng tư',
            value: challenge.privacyLabel,
            icon: Icons.public_rounded,
          ),
          _InfoRow(
            label: 'Người tham gia',
            value: '${challenge.slotsFilled}/${challenge.slotsTotal}',
          ),
          _InfoRow(label: 'Kết thúc', value: challenge.countdownLabel),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.icon});

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ArenaSpacingTokens.arenaJoinInfoRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          if (icon != null) ...[
            Icon(
              icon,
              size: ArenaSpacingTokens.arenaJoinInlineIcon,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.x1),
          ],
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RulesCard extends StatelessWidget {
  const _RulesCard({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    final visibleRules = rules.take(4).toList();
    return VitCard(
      padding: ArenaSpacingTokens.arenaJoinCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tóm tắt luật',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (var i = 0; i < visibleRules.length; i++) ...[
            _RuleLine(index: i + 1, text: visibleRules[i]),
            if (i != visibleRules.length - 1)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
          if (rules.length > visibleRules.length) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            Text(
              '+${rules.length - visibleRules.length} luật khác',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ],
      ),
    );
  }
}

class _RuleLine extends StatelessWidget {
  const _RuleLine({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: ArenaSpacingTokens.arenaJoinRuleNumberWidth,
          child: Text(
            '$index.',
            style: AppTextStyles.caption.copyWith(
              color: _arenaAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: _joinBodyLineRatio,
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.currentBalance,
    required this.entryPoints,
    required this.remainingBalance,
    required this.hasEnough,
  });

  final int currentBalance;
  final int entryPoints;
  final int remainingBalance;
  final bool hasEnough;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaJoinCardPadding,
      child: Column(
        children: [
          _BalanceRow(
            label: 'Số dư Arena Points',
            value: '${_formatPoints(currentBalance)} pts',
            color: hasEnough ? AppColors.buy : AppColors.sell,
          ),
          const Divider(color: AppColors.divider, height: AppSpacing.x5),
          _BalanceRow(
            label: 'Điểm vào',
            value: '-${_formatPoints(entryPoints)} pts',
            color: _arenaAccent,
          ),
          const Divider(color: AppColors.divider, height: AppSpacing.x5),
          _BalanceRow(
            label: 'Sau khi tham gia',
            value: '${_formatPoints(remainingBalance)} pts',
            color: AppColors.text1,
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({
    required this.label,
    required this.value,
    required this.color,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: (emphasized ? AppTextStyles.body : AppTextStyles.caption)
                .copyWith(
                  color: emphasized ? AppColors.text1 : AppColors.text2,
                  fontWeight: emphasized ? AppTextStyles.bold : null,
                ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: ArenaSpacingTokens.arenaJoinCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: ArenaSpacingTokens.arenaJoinInlineIcon,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: _joinNoticeLineRatio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyPolicyLink extends StatelessWidget {
  const _SafetyPolicyLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: VitCtaButton(
        key: ArenaJoinPage.safetyPolicyKey,
        onPressed: onTap,
        variant: VitCtaButtonVariant.ghost,
        fullWidth: false,
        density: VitDensity.compact,
        leading: const Icon(
          Icons.shield_outlined,
          size: ArenaSpacingTokens.arenaJoinInlineIcon,
        ),
        child: Text(
          'Xem chính sách hủy/void',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
