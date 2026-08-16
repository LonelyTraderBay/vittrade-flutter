part of '../../phone/pages/staking/staking_social_feed_page.dart';

class _Composer extends StatelessWidget {
  const _Composer({required this.placeholder});

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSocialFeedPage.composerKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          const _Avatar(label: 'Me', icon: Icons.person_rounded),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedTabs extends StatelessWidget {
  const _FeedTabs({
    required this.tabs,
    required this.activeTabId,
    required this.onChanged,
  });

  final List<StakingSocialFeedTabDraft> tabs;
  final String activeTabId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSocialFeedPage.tabsKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnHorizontalPaddingX3,
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: activeTabId,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
        ],
      ),
    );
  }
}

class _PostsSection extends StatelessWidget {
  const _PostsSection({required this.title, required this.posts});

  final String title;
  final List<StakingSocialFeedPostDraft> posts;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingSocialFeedPage.feedKey,
      label: title,
      accentColor: AppModuleAccents.earn,
      children: [for (final post in posts) _PostCard(post: post)],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final StakingSocialFeedPostDraft post;

  @override
  Widget build(BuildContext context) {
    final typeMeta = _PostTypeMeta.fromType(post.type);
    return VitCard(
      key: StakingSocialFeedPage.postKey(post.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(label: post.avatarLabel, icon: typeMeta.avatarIcon),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(post.author, style: AppTextStyles.baseMedium),
                        if (post.badge != null)
                          _Pill(
                            label: post.badge!,
                            color: AppModuleAccents.earn,
                            emphasis: true,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          color: AppColors.text3,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Text(
                          post.timestamp,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _TypeChip(meta: typeMeta),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            post.content,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          if (post.asset != null || post.apy != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Wrap(
              spacing: AppSpacing.x2,
              runSpacing: AppSpacing.x2,
              children: [
                if (post.asset != null)
                  _Pill(label: post.asset!, color: AppColors.primary),
                if (post.apy != null)
                  _Pill(label: post.apy!, color: AppColors.buy, emphasis: true),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              _ActionMetric(
                icon: Icons.thumb_up_alt_outlined,
                value: post.likes,
              ),
              const SizedBox(width: AppSpacing.x4),
              _ActionMetric(
                icon: Icons.chat_bubble_outline_rounded,
                value: post.comments,
              ),
              const SizedBox(width: AppSpacing.x4),
              const Icon(
                Icons.share_outlined,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.primary12,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        ),
        child: Center(
          child: Semantics(
            label: label,
            child: Icon(
              icon,
              color: AppModuleAccents.earn,
              size: AppSpacing.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.meta});

  final _PostTypeMeta meta;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: meta.background,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: meta.border),
          borderRadius: AppRadii.smRadius,
        ),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(meta.icon, color: meta.color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Text(
              meta.label,
              style: AppTextStyles.micro.copyWith(
                color: meta.color,
                height: EarnSpacingTokens.stakingEarnHeroTabLabelLineHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionMetric extends StatelessWidget {
  const _ActionMetric({required this.icon, required this.value});

  final IconData icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: AppSpacing.iconMd),
        const SizedBox(width: AppSpacing.x2),
        Text(
          '$value',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _CommunityStats extends StatelessWidget {
  const _CommunityStats({required this.stats});

  final List<StakingSocialFeedStatDraft> stats;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingSocialFeedPage.statsKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Community Stats', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              for (var i = 0; i < stats.length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.x3),
                Expanded(child: _StatTile(stat: stats[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
