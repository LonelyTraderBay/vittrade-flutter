part of 'launchpad_tablet_pages.dart';

/// SC-370b: IDO Bridge.
class LaunchpadIdoBridgeTabletPage extends ConsumerWidget {
  const LaunchpadIdoBridgeTabletPage({super.key});

  static const contentKey = Key('sc370_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      launchpadIdoBridgeSnapshotProvider('sample'),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-370',
        semanticLabel: 'Cầu IDO',
        title: 'IDO Bridge',
        subtitle: 'Mạng · Tuyến',
        contentKey: LaunchpadIdoBridgeTabletPage.contentKey,
        children: [
          _lpdError(
            'Không tải được IDO bridge',
            () => ref.invalidate(launchpadIdoBridgeSnapshotProvider('sample')),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-370',
        semanticLabel: 'Cầu IDO',
        title: snapshot.title,
        subtitle: '${snapshot.sourceNetworks.length} mạng nguồn',
        contentKey: LaunchpadIdoBridgeTabletPage.contentKey,
        children: [
          _lpdSection(
            title: 'Tuyến cầu',
            rows: [
              for (final route in snapshot.routes.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    route.id,
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

/// SC-371: So sánh tuyến cầu.
class LaunchpadBridgeCompareTabletPage extends ConsumerWidget {
  const LaunchpadBridgeCompareTabletPage({super.key});

  static const contentKey = Key('sc371_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadBridgeCompareSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-371',
        semanticLabel: 'So sánh tuyến cầu',
        title: 'So sánh bridge',
        subtitle: 'Phí · Thời gian',
        contentKey: LaunchpadBridgeCompareTabletPage.contentKey,
        children: [
          _lpdError(
            'Không tải được so sánh',
            () => ref.invalidate(launchpadBridgeCompareSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-371',
        semanticLabel: 'So sánh tuyến cầu',
        title: snapshot.title,
        subtitle: '${snapshot.sortOptions.length} tuỳ chọn sắp xếp',
        contentKey: LaunchpadBridgeCompareTabletPage.contentKey,
        children: [
          _lpdSection(
            title: 'Sắp xếp',
            rows: _lpdRows([
              for (final option in snapshot.sortOptions)
                (option.value, option.label),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-372: Lệnh cầu — giao dịch mẫu.
class LaunchpadBridgeOrderTabletPage extends ConsumerWidget {
  const LaunchpadBridgeOrderTabletPage({super.key});

  static const contentKey = Key('sc372_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      launchpadBridgeOrderSnapshotProvider('tx001'),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-372',
        semanticLabel: 'Lệnh cầu',
        title: 'Lệnh bridge',
        subtitle: 'tx001',
        contentKey: LaunchpadBridgeOrderTabletPage.contentKey,
        children: [
          _lpdError(
            'Không tải được lệnh bridge',
            () => ref.invalidate(launchpadBridgeOrderSnapshotProvider('tx001')),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-372',
        semanticLabel: 'Lệnh cầu',
        title: snapshot.title,
        subtitle: snapshot.txId,
        contentKey: LaunchpadBridgeOrderTabletPage.contentKey,
        children: [
          _lpdSection(
            title: 'Sự kiện',
            rows: [
              for (final event in snapshot.events.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    event.id,
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

/// SC-373: Biên lai nhận thưởng.
class LaunchpadClaimReceiptTabletPage extends ConsumerWidget {
  const LaunchpadClaimReceiptTabletPage({super.key});

  static const contentKey = Key('sc373_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      launchpadClaimReceiptSnapshotProvider('pos001'),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-373',
        semanticLabel: 'Biên lai nhận thưởng',
        title: 'Biên lai nhận thưởng',
        subtitle: 'pos001',
        contentKey: LaunchpadClaimReceiptTabletPage.contentKey,
        children: [
          _lpdError(
            'Không tải được biên lai',
            () =>
                ref.invalidate(launchpadClaimReceiptSnapshotProvider('pos001')),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-373',
        semanticLabel: 'Biên lai nhận thưởng',
        title: snapshot.title,
        subtitle: 'Vị thế ${snapshot.positionId}',
        contentKey: LaunchpadClaimReceiptTabletPage.contentKey,
        children: [
          _lpdSection(
            title: 'Biên lai',
            rows: _lpdRows([('Vị thế', snapshot.receipt.positionId)]),
          ),
        ],
      ),
    );
  }
}

/// SC-374: Nhận thưởng hàng loạt.
class LaunchpadBatchClaimTabletPage extends ConsumerWidget {
  const LaunchpadBatchClaimTabletPage({super.key});

  static const contentKey = Key('sc374_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadBatchClaimSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-374',
        semanticLabel: 'Nhận thưởng hàng loạt',
        title: 'Nhận thưởng hàng loạt',
        subtitle: 'Xem trước · Xác nhận',
        contentKey: LaunchpadBatchClaimTabletPage.contentKey,
        children: [
          _lpdError(
            'Không tải được nhận thưởng',
            () => ref.invalidate(launchpadBatchClaimSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-374',
        semanticLabel: 'Nhận thưởng hàng loạt',
        title: snapshot.title,
        subtitle: '${snapshot.positions.length} vị thế',
        contentKey: LaunchpadBatchClaimTabletPage.contentKey,
        children: [
          _lpdSection(
            title: 'Tổng hợp',
            rows: _lpdRows([
              for (final position in snapshot.positions.take(8))
                (position.positionId, position.projectName),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-375: Âm thông báo launchpad.
class LaunchpadNotifSoundTabletPage extends ConsumerWidget {
  const LaunchpadNotifSoundTabletPage({super.key});

  static const contentKey = Key('sc375_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadNotifSoundSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-375',
        semanticLabel: 'Âm thông báo launchpad',
        title: 'Âm thông báo',
        subtitle: 'Âm lượng · Giờ tĩnh',
        contentKey: LaunchpadNotifSoundTabletPage.contentKey,
        children: [
          _lpdError(
            'Không tải được âm thông báo',
            () => ref.invalidate(launchpadNotifSoundSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-375',
        semanticLabel: 'Âm thông báo launchpad',
        title: snapshot.title,
        subtitle: snapshot.masterEnabled ? 'Đang bật' : 'Đang tắt',
        contentKey: LaunchpadNotifSoundTabletPage.contentKey,
        children: [
          _lpdSection(
            title: 'Cài đặt',
            rows: _lpdRows([
              ('Bật chung', snapshot.masterEnabled ? 'Bật' : 'Tắt'),
              ('Âm lượng', '${snapshot.masterVolume}%'),
              ('Rung', snapshot.vibrate ? 'Bật' : 'Tắt'),
              (
                'Giờ tĩnh',
                snapshot.doNotDisturb
                    ? '${snapshot.dndStartHour}h → ${snapshot.dndEndHour}h'
                    : 'Tắt',
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-376: Nhật ký sự kiện launchpad.
class LaunchpadEventLogTabletPage extends ConsumerWidget {
  const LaunchpadEventLogTabletPage({super.key});

  static const contentKey = Key('sc376_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadEventLogSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-376',
        semanticLabel: 'Nhật ký sự kiện launchpad',
        title: 'Nhật ký sự kiện',
        subtitle: 'Sự kiện · Xuất',
        contentKey: LaunchpadEventLogTabletPage.contentKey,
        children: [
          _lpdError(
            'Không tải được nhật ký',
            () => ref.invalidate(launchpadEventLogSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-376',
        semanticLabel: 'Nhật ký sự kiện launchpad',
        title: snapshot.title,
        subtitle: '${snapshot.events.length} sự kiện',
        contentKey: LaunchpadEventLogTabletPage.contentKey,
        children: [
          _lpdSection(
            title: 'Sự kiện',
            rows: [
              for (final event in snapshot.events.take(10))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    event.id,
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

/// SC-377: So sánh ABI.
class LaunchpadAbiDiffTabletPage extends ConsumerWidget {
  const LaunchpadAbiDiffTabletPage({super.key});

  static const contentKey = Key('sc377_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadAbiDiffSnapshotProvider('sample'));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-377',
        semanticLabel: 'So sánh ABI',
        title: 'So sánh ABI',
        subtitle: 'Trước · Sau',
        contentKey: LaunchpadAbiDiffTabletPage.contentKey,
        children: [
          _lpdError(
            'Không tải được so sánh ABI',
            () => ref.invalidate(launchpadAbiDiffSnapshotProvider('sample')),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-377',
        semanticLabel: 'So sánh ABI',
        title: snapshot.title,
        subtitle: 'Hợp đồng ${snapshot.contractId}',
        contentKey: LaunchpadAbiDiffTabletPage.contentKey,
        children: [
          _lpdSection(
            title: 'Kết quả',
            rows: [_lpdBody(snapshot.contractNotes)],
          ),
        ],
      ),
    );
  }
}
