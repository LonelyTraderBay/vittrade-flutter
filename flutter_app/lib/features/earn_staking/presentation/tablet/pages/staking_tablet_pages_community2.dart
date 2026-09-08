part of 'staking_tablet_pages.dart';

/// SC-295: Bảng tin cộng đồng staking.
class StakingSocialFeedTabletPage extends ConsumerWidget {
  const StakingSocialFeedTabletPage({super.key});

  static const contentKey = Key('sc295_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingSocialFeedSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-295',
        semanticLabel: 'Bảng tin staking',
        title: snapshotAsync.value?.infoTitle ?? 'Bảng tin',
        subtitle: 'Thảo luận cộng đồng',
        contentKey: StakingSocialFeedTabletPage.contentKey,
        child: _stkError(
          'Không tải được bảng tin',
          () => ref.invalidate(stakingSocialFeedSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-295',
        semanticLabel: 'Bảng tin staking',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingSocialFeedTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Bài đăng',
              rows: [
                for (final post in snapshot.posts.take(10))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${post.author} · ${post.timestamp}',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          post.content,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-296b: Quản trị cộng đồng staking.
class StakingCommunityGovernanceTabletPage extends ConsumerWidget {
  const StakingCommunityGovernanceTabletPage({super.key});

  static const contentKey = Key('sc296g_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingCommunityGovernanceSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-297',
        semanticLabel: 'Quản trị cộng đồng staking',
        title: snapshotAsync.value?.infoTitle ?? 'Quản trị cộng đồng',
        subtitle: 'Đề xuất · Quyết định',
        contentKey: StakingCommunityGovernanceTabletPage.contentKey,
        child: _stkError(
          'Không tải được quản trị',
          () => ref.invalidate(stakingCommunityGovernanceSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-297',
        semanticLabel: 'Quản trị cộng đồng staking',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingCommunityGovernanceTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: snapshot.statsTitle,
              rows: _stkRows([
                for (final stat in snapshot.stats) (stat.label, stat.value),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Đề xuất đang diễn ra',
              rows: _stkTitleBody([
                (snapshot.activeProposal.title, snapshot.activeProposal.body),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Quyết định gần đây',
              rows: [
                for (final decision in snapshot.recentDecisions)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            decision.proposal,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${decision.status} · ${decision.votes} phiếu · ${decision.dateLabel}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-298: Đề xuất staking.
class StakingProposalsTabletPage extends ConsumerWidget {
  const StakingProposalsTabletPage({super.key});

  static const contentKey = Key('sc298_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingProposalsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-298',
        semanticLabel: 'Đề xuất staking',
        title: snapshotAsync.value?.title ?? 'Đề xuất',
        subtitle: 'Bỏ phiếu · Theo dõi',
        contentKey: StakingProposalsTabletPage.contentKey,
        child: _stkError(
          'Không tải được đề xuất',
          () => ref.invalidate(stakingProposalsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-298',
        semanticLabel: 'Đề xuất staking',
        title: snapshot.title,
        subtitle: '${snapshot.proposals.length} đề xuất',
        contentKey: StakingProposalsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Danh sách đề xuất',
              rows: [
                for (final proposal in snapshot.proposals)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        onTap: () => context.go(
                          AppRoutePaths.earnVotingProposal(proposal.id),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    proposal.title,
                                    style: AppTextStyles.caption.copyWith(
                                      fontWeight: AppTextStyles.bold,
                                      color: AppColors.text1,
                                    ),
                                  ),
                                  Text(
                                    '${proposal.category} · hết hạn ${proposal.endsIn}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              proposal.status,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-299b: Bỏ phiếu staking.
class StakingVotingTabletPage extends ConsumerWidget {
  const StakingVotingTabletPage({super.key, this.proposalId});

  static const contentKey = Key('sc299_tablet_content');

  final String? proposalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingVotingSnapshotProvider(proposalId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-299',
        semanticLabel: 'Bỏ phiếu staking',
        title: snapshotAsync.value?.title ?? 'Bỏ phiếu',
        subtitle: 'Kết quả · Tỷ trọng',
        contentKey: StakingVotingTabletPage.contentKey,
        child: _stkError(
          'Không tải được bỏ phiếu',
          () => ref.invalidate(stakingVotingSnapshotProvider(proposalId)),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-299',
        semanticLabel: 'Bỏ phiếu staking',
        title: snapshot.title,
        subtitle: snapshot.category,
        contentKey: StakingVotingTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: snapshot.proposalTitle,
              rows: [_stkBody(snapshot.proposalBody)],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: snapshot.resultsTitle,
              rows: [
                for (final result in snapshot.results)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            result.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${result.percent}% · ${result.votes} phiếu',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-300b: Diễn đàn staking.
class StakingForumTabletPage extends ConsumerWidget {
  const StakingForumTabletPage({super.key});

  static const contentKey = Key('sc300_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingForumSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-300',
        semanticLabel: 'Diễn đàn staking',
        title: snapshotAsync.value?.heroTitle ?? 'Diễn đàn',
        subtitle: 'Chủ đề · Thảo luận',
        contentKey: StakingForumTabletPage.contentKey,
        child: _stkError(
          'Không tải được diễn đàn',
          () => ref.invalidate(stakingForumSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-300',
        semanticLabel: 'Diễn đàn staking',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroBody,
        contentKey: StakingForumTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: snapshot.categoriesTitle,
              rows: [
                for (final category in snapshot.categories)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.name,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${category.threads} chủ đề · ${category.posts} bài',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: snapshot.threadsTitle,
              rows: [
                for (final thread in snapshot.threads.take(10))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            thread.title,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${thread.replies} trả lời · ${thread.views} xem',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
