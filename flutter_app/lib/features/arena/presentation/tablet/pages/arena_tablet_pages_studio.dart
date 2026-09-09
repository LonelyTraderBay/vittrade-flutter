part of 'arena_tablet_pages.dart';

/// SC-186: Quy tắc thông minh Arena.
class ArenaSmartRulesTabletPage extends ConsumerWidget {
  const ArenaSmartRulesTabletPage({super.key});

  static const contentKey = Key('sc186_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaSmartRulesSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-186',
        semanticLabel: 'Quy tắc thông minh Arena',
        title: 'Quy tắc thông minh',
        subtitle: 'Lĩnh vực · Loại thách đấu',
        contentKey: ArenaSmartRulesTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được quy tắc',
            () => ref.invalidate(arenaSmartRulesSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-186',
        semanticLabel: 'Quy tắc thông minh Arena',
        title: 'Quy tắc thông minh',
        subtitle: '${snapshot.domains.length} lĩnh vực',
        contentKey: ArenaSmartRulesTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Lĩnh vực',
            rows: _ardBullets([
              for (final domain in snapshot.domains) domain.label,
            ]),
          ),

          _ardSection(
            title: 'Loại thách đấu',
            rows: _ardBullets([
              for (final kind in snapshot.challengeTypes) kind.label,
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-187: Thư viện mẫu Arena.
class ArenaPresetLibraryTabletPage extends ConsumerWidget {
  const ArenaPresetLibraryTabletPage({super.key});

  static const contentKey = Key('sc187_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaPresetLibrarySnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-187',
        semanticLabel: 'Thư viện mẫu Arena',
        title: 'Thư viện mẫu',
        subtitle: 'Gợi ý sẵn',
        contentKey: ArenaPresetLibraryTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được thư viện mẫu',
            () => ref.invalidate(arenaPresetLibrarySnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-187',
        semanticLabel: 'Thư viện mẫu Arena',
        title: 'Thư viện mẫu',
        subtitle: '${snapshot.sections.length} nhóm',
        contentKey: ArenaPresetLibraryTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Gói lĩnh vực',
            rows: [
              for (final pack in snapshot.domainPacks.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    pack.id,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-188: Cổng quản trị Arena.
class ArenaGovernanceGateTabletPage extends ConsumerWidget {
  const ArenaGovernanceGateTabletPage({super.key});

  static const contentKey = Key('sc188_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaGovernanceSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-188',
        semanticLabel: 'Cổng quản trị Arena',
        title: 'Cổng quản trị',
        subtitle: 'Riêng tư · Lĩnh vực',
        contentKey: ArenaGovernanceGateTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được cổng quản trị',
            () => ref.invalidate(arenaGovernanceSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-188',
        semanticLabel: 'Cổng quản trị Arena',
        title: 'Cổng quản trị',
        subtitle: '${snapshot.privacyOptions.length} tuỳ chọn riêng tư',
        contentKey: ArenaGovernanceGateTabletPage.contentKey,
        children: [
          _ardSection(
            title: 'Riêng tư',
            rows: _ardBullets([
              for (final option in snapshot.privacyOptions) option.label,
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-195: Thách đấu đã xác minh.
class VerifiedChallengesTabletPage extends ConsumerWidget {
  const VerifiedChallengesTabletPage({super.key});

  static const contentKey = Key('sc195_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(verifiedChallengesSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-195',
        semanticLabel: 'Thách đấu xác minh',
        title: snapshotAsync.value?.title ?? 'Đã xác minh',
        subtitle: 'Đặc quyền',
        contentKey: VerifiedChallengesTabletPage.contentKey,
        children: [
          _ardError(
            'Không tải được thách đấu',
            () => ref.invalidate(verifiedChallengesSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-195',
        semanticLabel: 'Thách đấu xác minh',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: VerifiedChallengesTabletPage.contentKey,
        children: [
          _ardSection(
            title: snapshot.infoTitle,
            rows: [
              for (final feature in snapshot.features)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    feature.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
