part of 'arena_challenge_detail_page.dart';

class _ClarityCard extends StatelessWidget {
  const _ClarityCard({required this.score});

  final int score;

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
                Icons.fact_check_outlined,
                color: AppColors.buy,
                size: _challengeLgIcon,
              ),
              const SizedBox(width: _challengeTinyGap),
              Expanded(
                child: Text(
                  'Rule Clarity Score',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: _challengeGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: _challengeProgressHeight,
              value: score / 100,
              color: AppColors.buy,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: _challengeTinyGap),
          Row(
            children: [
              Text(
                '$score/100 - Rõ ràng',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: _challengeTinyGap),
              Expanded(
                child: Text(
                  'Luật càng rõ, room càng tin tưởng',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreatorCard extends StatelessWidget {
  const _CreatorCard({required this.creator, required this.onTap});

  final ArenaChallengeCreatorDraft creator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaChallengeDetailPage.creatorKey,
      onTap: onTap,
      padding: _challengeCardPadding,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.workspace_premium_outlined,
            color: AppColors.primary,
            iconSize: _challengeIconBubbleIcon,
          ),
          const SizedBox(width: _challengeGap),
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
                const SizedBox(height: _challengeTinyGap),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        creator.role,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ),
                    if (creator.fairPlayBadge) ...[
                      const SizedBox(width: _challengeTinyGap),
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.buy,
                        size: _challengeSmallIcon,
                      ),
                      const SizedBox(width: _challengeTinyGap),
                      Text(
                        'Fair Play',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.buy,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _SafetyLinkCard extends StatelessWidget {
  const _SafetyLinkCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaChallengeDetailPage.safetyKey,
      onTap: onTap,
      padding: _challengeCardPadding,
      child: Row(
        children: [
          const VitAccentIconBox(
            icon: Icons.health_and_safety_outlined,
            color: AppColors.buy,
            iconSize: _challengeIconBubbleIcon,
          ),
          const SizedBox(width: _challengeGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'An toàn & báo cáo',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _challengeTinyGap),
                Text(
                  'Quy tắc, report vi phạm',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.active, required this.onChanged});

  final _ChallengeTab active;
  final ValueChanged<_ChallengeTab> onChanged;

  static const _entries = [
    (_ChallengeTab.rules, 'Luật chơi', Icons.menu_book_outlined),
    (_ChallengeTab.evidence, 'Bằng chứng', Icons.camera_alt_outlined),
    (_ChallengeTab.participants, 'Thành viên', Icons.groups_2_outlined),
    (_ChallengeTab.activity, 'Hoạt động', Icons.timeline_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return VitSegmentedTabBar(
      tabs: [
        for (final entry in _entries)
          VitTabItem(
            key: entry.$1.name,
            label: entry.$2,
            icon: entry.$3,
            widgetKey: ArenaChallengeDetailPage.tabKey(entry.$1.name),
          ),
      ],
      activeKey: active.name,
      onChanged: (key) {
        unawaited(HapticFeedback.selectionClick());
        onChanged(_ChallengeTab.values.byName(key));
      },
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.snapshot, required this.active});

  final ArenaChallengeDetailSnapshot snapshot;
  final _ChallengeTab active;

  @override
  Widget build(BuildContext context) {
    return switch (active) {
      _ChallengeTab.rules => _RulesList(rules: snapshot.rules),
      _ChallengeTab.evidence => const _EvidencePanel(),
      _ChallengeTab.participants => _ParticipantsPanel(teams: snapshot.teams),
      _ChallengeTab.activity => _ActivityPanel(activity: snapshot.activity),
    };
  }
}

class _RulesList extends StatelessWidget {
  const _RulesList({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _challengeCardPadding,
      child: Column(
        children: [
          for (var index = 0; index < rules.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: _challengeRuleNumberWidth,
                  child: Text(
                    '${index + 1}.',
                    style: AppTextStyles.caption.copyWith(
                      color: _arenaAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rules[index],
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      height: AppTextStyles.numericMicro.height,
                    ),
                  ),
                ),
              ],
            ),
            if (index != rules.length - 1)
              const SizedBox(height: _challengeGap),
          ],
        ],
      ),
    );
  }
}

class _EvidencePanel extends StatelessWidget {
  const _EvidencePanel();

  @override
  Widget build(BuildContext context) {
    return const _InfoCard(
      icon: Icons.camera_alt_outlined,
      title: 'Bằng chứng',
      text:
          'Chưa có bằng chứng gửi từ app này. Kết quả chính dùng API CoinGecko và tự động đối soát.',
      color: _arenaAccent,
    );
  }
}

class _ParticipantsPanel extends StatelessWidget {
  const _ParticipantsPanel({required this.teams});

  final List<ArenaTeamDraft> teams;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _challengeCardPadding,
      child: Column(
        children: [
          for (final team in teams) ...[
            Row(
              children: [
                _InitialBadge(
                  name: team.name,
                  color: team.accent == VitArenaTeamAccent.sol
                      ? _arenaAccent
                      : AppColors.sell,
                ),
                const SizedBox(width: _challengeGap),
                Expanded(
                  child: Text(
                    team.name,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  '${team.members.length} người',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            if (team != teams.last) const Divider(color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel({required this.activity});

  final List<String> activity;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: _challengeCardPadding,
      child: Column(
        children: [
          for (final item in activity) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.circle, size: 7, color: AppColors.buy),
                const SizedBox(width: _challengeGap),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text2,
                      height: AppTextStyles.numericMicro.height,
                    ),
                  ),
                ),
              ],
            ),
            if (item != activity.last) const SizedBox(height: _challengeGap),
          ],
        ],
      ),
    );
  }
}

class _WarningStack extends StatelessWidget {
  const _WarningStack({required this.warnings});

  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < warnings.length; index++) ...[
          VitBanner(
            variant: _bannerVariantForColor(
              index == 0 ? AppColors.primary : AppColors.warn,
            ),
            icon: index == 0
                ? Icons.info_outline_rounded
                : Icons.warning_amber_rounded,
            message: warnings[index],
          ),
          if (index != warnings.length - 1)
            const SizedBox(height: _challengeTinyGap),
        ],
      ],
    );
  }
}

class _PredictionBridgeCard extends StatelessWidget {
  const _PredictionBridgeCard({
    required this.contextDraft,
    required this.onTap,
  });

  final ArenaPredictionContextDraft contextDraft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaChallengeDetailPage.predictionKey,
      onTap: onTap,
      borderColor: _arenaAccent.withValues(alpha: .25),
      padding: _challengeCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: _challengeMdIcon,
                color: _arenaAccent,
              ),
              const SizedBox(width: _challengeTinyGap),
              Expanded(
                child: Text(
                  'MARKET CONTEXT ONLY',
                  style: AppTextStyles.micro.copyWith(
                    color: _arenaAccent,
                    fontWeight: AppTextStyles.bold,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              const VitStatusPill(
                label: 'Prediction Markets',
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: _challengeGap),
          Text(
            'Bối cảnh thị trường',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: _challengeTinyGap),
          Text(
            contextDraft.title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
          const SizedBox(height: _challengeGap),
          Row(
            children: [
              Text(
                'Xác suất "${contextDraft.outcomeName}":',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: _challengeTinyGap),
              Text(
                '${contextDraft.probability}%',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: _challengeTinyGap),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: _challengeProgressHeight,
              value: contextDraft.probability / 100,
              color: AppColors.sell,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: _challengeGap),
          _InlineAction(
            label: 'Xem thị trường dự đoán',
            icon: Icons.open_in_new_rounded,
            color: _arenaAccent,
            onTap: onTap,
          ),
          const SizedBox(height: _challengeGap),
          Text(
            'Thông tin chỉ mang tính tham khảo. Arena Points và Prediction Markets là 2 hệ thống hoàn toàn riêng biệt.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: AppTextStyles.numericMicro.height,
            ),
          ),
        ],
      ),
    );
  }
}
