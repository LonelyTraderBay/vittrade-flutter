part of 'arena_tablet_pages.dart';

/// SC-200/201/197/196/198/206/207/208: điểm + sơ đồ + an toàn + production.
class ArenaPointsTabletPage extends ConsumerWidget {
  const ArenaPointsTabletPage({super.key});

  static const contentKey = Key('sc200_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaPointsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-200',
        semanticLabel: 'Điểm thưởng đấu trường',
        title: 'Điểm Arena',
        subtitle: 'Tổng hợp · Nhiệm vụ',
        contentKey: ArenaPointsTabletPage.contentKey,
        child: _ardError(
          'Không tải được điểm Arena',
          () => ref.invalidate(arenaPointsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-200',
        semanticLabel: 'Điểm thưởng đấu trường',
        title: 'Điểm Arena',
        subtitle: '${snapshot.tasks.length} nhiệm vụ',
        contentKey: ArenaPointsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Danh mục điểm',
              rows: [
                for (final category in snapshot.categories.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      category.id,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _ardSection(
              title: 'Thưởng thêm',
              rows: [
                for (final bonus in snapshot.bonusRows.take(6))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      bonus.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
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

class ArenaPointsLedgerTabletPage extends ConsumerWidget {
  const ArenaPointsLedgerTabletPage({super.key});

  static const contentKey = Key('sc201_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaPointsLedgerSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-201',
        semanticLabel: 'Sổ điểm thưởng',
        title: 'Sổ điểm',
        subtitle: 'Ghi nhận',
        contentKey: ArenaPointsLedgerTabletPage.contentKey,
        child: _ardError(
          'Không tải được sổ điểm',
          () => ref.invalidate(arenaPointsLedgerSnapshotProvider),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-201',
        semanticLabel: 'Sổ điểm thưởng',
        title: 'Sổ điểm',
        subtitle: '${snapshot.entries.length} bút toán',
        contentKey: ArenaPointsLedgerTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Bút toán',
              rows: [
                for (final entry in snapshot.entries.take(12))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      entry.id,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
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

class ArenaPointsEntryDetailTabletPage extends ConsumerWidget {
  const ArenaPointsEntryDetailTabletPage({super.key, required this.entryId});

  static const contentKey = Key('sc200d_tablet_content');

  final String entryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      arenaPointsEntryDetailSnapshotProvider(entryId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-200',
        semanticLabel: 'Chi tiết ghi điểm',
        title: 'Chi tiết bút toán',
        subtitle: entryId,
        contentKey: ArenaPointsEntryDetailTabletPage.contentKey,
        child: _ardError(
          'Không tải được bút toán',
          () => ref.invalidate(arenaPointsEntryDetailSnapshotProvider(entryId)),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-200',
        semanticLabel: 'Chi tiết ghi điểm',
        title: 'Chi tiết bút toán',
        subtitle: snapshot.entryId,
        contentKey: ArenaPointsEntryDetailTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Miễn trừ',
              rows: [_ardBody(snapshot.disclaimer)],
            ),
          ],
        ),
      ),
    );
  }
}

class ArenaFlowMapTabletPage extends ConsumerWidget {
  const ArenaFlowMapTabletPage({super.key});

  static const contentKey = Key('sc197_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaFlowMapSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-197',
        semanticLabel: 'Sơ đồ luồng đấu',
        title: 'Sơ đồ luồng',
        subtitle: 'Thống kê · Tuyến',
        contentKey: ArenaFlowMapTabletPage.contentKey,
        child: _ardError(
          'Không tải được sơ đồ',
          () => ref.invalidate(arenaFlowMapSnapshotProvider),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-197',
        semanticLabel: 'Sơ đồ luồng đấu',
        title: 'Sơ đồ luồng',
        subtitle: '${snapshot.stats.length} chỉ số',
        contentKey: ArenaFlowMapTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Tuyến',
              rows: [
                for (final route in snapshot.routes.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      route.path,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
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

class ArenaSafetyCenterTabletPage extends ConsumerWidget {
  const ArenaSafetyCenterTabletPage({super.key});

  static const contentKey = Key('sc198_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaSafetyCenterSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-198',
        semanticLabel: 'An toàn đấu trường',
        title: snapshotAsync.value?.bannerTitle ?? 'An toàn',
        subtitle: 'Quy tắc cộng đồng',
        contentKey: ArenaSafetyCenterTabletPage.contentKey,
        child: _ardError(
          'Không tải được an toàn',
          () => ref.invalidate(arenaSafetyCenterSnapshotProvider),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-198',
        semanticLabel: 'An toàn đấu trường',
        title: snapshot.bannerTitle,
        subtitle: snapshot.bannerDescription,
        contentKey: ArenaSafetyCenterTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Quy tắc cộng đồng',
              rows: [
                for (final rule in snapshot.communityRules)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      rule.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _ardSection(
              title: 'Nội dung cấm',
              rows: _ardBullets(snapshot.bannedContent),
            ),
          ],
        ),
      ),
    );
  }
}

class ArenaProductionReadyTabletPage extends ConsumerWidget {
  const ArenaProductionReadyTabletPage({super.key});

  static const contentKey = Key('sc206_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaProductionReadySnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-206',
        semanticLabel: 'Bản dựng sản xuất',
        title: 'Sẵn sàng sản xuất',
        subtitle: 'Màn hình · Luồng',
        contentKey: ArenaProductionReadyTabletPage.contentKey,
        child: _ardError(
          'Không tải được trạng thái',
          () => ref.invalidate(arenaProductionReadySnapshotProvider),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-206',
        semanticLabel: 'Bản dựng sản xuất',
        title: 'Sẵn sàng sản xuất',
        subtitle: '${snapshot.canonicalScreens.length} màn hình chính',
        contentKey: ArenaProductionReadyTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Kiểm tra chất lượng',
              rows: _ardBullets(snapshot.qaItems),
            ),
          ],
        ),
      ),
    );
  }
}

class ArenaPredictionBridgeTabletPage extends ConsumerWidget {
  const ArenaPredictionBridgeTabletPage({super.key});

  static const contentKey = Key('sc207_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(arenaPredictionBridgeSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-207',
        semanticLabel: 'Cầu nối dự đoán',
        title: 'Cầu nối dự đoán',
        subtitle: 'Nguyên tắc · Ranh giới',
        contentKey: ArenaPredictionBridgeTabletPage.contentKey,
        child: _ardError(
          'Không tải được cầu nối',
          () => ref.invalidate(arenaPredictionBridgeSnapshotProvider),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-207',
        semanticLabel: 'Cầu nối dự đoán',
        title: 'Cầu nối dự đoán',
        subtitle: '${snapshot.principles.length} nguyên tắc',
        contentKey: ArenaPredictionBridgeTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Nguyên tắc',
              rows: [
                for (final principle in snapshot.principles)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      principle.title,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
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

class ArenaEcosystemTabletPage extends ConsumerWidget {
  const ArenaEcosystemTabletPage({super.key});

  static const contentKey = Key('sc208_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      connectedEcosystemProductionSnapshotProvider,
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-208',
        semanticLabel: 'Hệ sinh thái liên kết',
        title: 'Hệ sinh thái kết nối',
        subtitle: 'Danh mục · Ranh giới',
        contentKey: ArenaEcosystemTabletPage.contentKey,
        child: _ardError(
          'Không tải được hệ sinh thái',
          () => ref.invalidate(connectedEcosystemProductionSnapshotProvider),
        ),
      ),
      data: (snapshot) => _ardFrame(
        context: context,
        semanticIdentifier: 'SC-208',
        semanticLabel: 'Hệ sinh thái liên kết',
        title: 'Hệ sinh thái kết nối',
        subtitle: '${snapshot.canonicalScreens.length} màn hình chuẩn',
        contentKey: ArenaEcosystemTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ardSection(
              title: 'Dùng chung',
              rows: [
                for (final item in snapshot.sharedItems.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      item.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _ardSection(
              title: 'Bắt buộc tách',
              rows: [
                for (final item in snapshot.separateItems.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      item.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
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
