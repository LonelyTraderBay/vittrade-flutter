part of 'copy_trading_core_tablet_pages.dart';

class CopyNotificationsTabletPage extends ConsumerWidget {
  const CopyNotificationsTabletPage({super.key});

  static const contentKey = Key('sc068_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeCopyNotificationsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-068',
        semanticLabel: 'Thông báo sao chép',
        title: 'Thông báo',
        subtitle: 'Sự kiện sao chép',
        contentKey: CopyNotificationsTabletPage.contentKey,
        children: [
          _copyError(
            'Không tải được thông báo',
            () => ref.invalidate(tradeCopyNotificationsProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-068',
        semanticLabel: 'Thông báo sao chép',
        title: 'Thông báo',
        subtitle: 'Sự kiện sao chép',
        contentKey: CopyNotificationsTabletPage.contentKey,
        children: [
          if (snapshot.notifications.isEmpty)
            const VitEmptyState(
              icon: Icons.notifications_none_rounded,
              title: 'Chưa có thông báo',
              message: 'Sự kiện sao chép sẽ hiện tại đây.',
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.zeroInsets,
              clip: true,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.notifications.length; i++) ...[
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingTall,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.notifications[i].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                    color: AppColors.text1,
                                  ),
                                ),
                                Text(
                                  snapshot.notifications[i].message,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            snapshot.notifications[i].timestamp,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < snapshot.notifications.length - 1)
                      const Divider(
                        height: TabletSpacingTokens.dividerHairline,
                        thickness: TabletSpacingTokens.dividerHairline,
                        color: AppColors.divider,
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

/// SC-079: Bảng xếp hạng provider.
class ProviderLeaderboardTabletPage extends ConsumerWidget {
  const ProviderLeaderboardTabletPage({super.key});

  static const contentKey = Key('sc079_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeProviderLeaderboardProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-079',
        semanticLabel: 'Bảng xếp hạng provider',
        title: 'Bảng xếp hạng',
        subtitle: 'Provider · Hiệu suất',
        contentKey: ProviderLeaderboardTabletPage.contentKey,
        children: [
          _copyError(
            'Không tải được bảng xếp hạng',
            () => ref.invalidate(tradeProviderLeaderboardProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-079',
        semanticLabel: 'Bảng xếp hạng provider',
        title: 'Bảng xếp hạng provider',
        subtitle: '${snapshot.providers.length} provider',
        contentKey: ProviderLeaderboardTabletPage.contentKey,
        children: [
          VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.zeroInsets,
            clip: true,
            child: Column(
              children: [
                for (var i = 0; i < snapshot.providers.length; i++) ...[
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingTall,
                    child: Row(
                      children: [
                        SizedBox(
                          width: TabletSpacingTokens.x7,
                          child: Text(
                            '${i + 1}',
                            style: AppTextStyles.control.copyWith(
                              color: AppColors.primary,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            snapshot.providers[i].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Win ${snapshot.providers[i].winRate.toStringAsFixed(1)}%',
                            style: AppTextStyles.caption.copyWith(
                              color: snapshot.providers[i].winRate >= 50
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            formatTradeSignedUsdRounded(
                              snapshot.providers[i].totalPnl,
                            ),
                            style: AppTextStyles.caption.copyWith(
                              color: snapshot.providers[i].totalPnl >= 0
                                  ? AppColors.buy
                                  : AppColors.sell,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (i < snapshot.providers.length - 1)
                    const Divider(
                      height: TabletSpacingTokens.dividerHairline,
                      thickness: TabletSpacingTokens.dividerHairline,
                      color: AppColors.divider,
                    ),
                ],
              ],
            ),
          ),

          Text(
            snapshot.disclaimer,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// SC-065: Giáo dục sao chép.
class CopyEducationTabletPage extends ConsumerWidget {
  const CopyEducationTabletPage({super.key});

  static const contentKey = Key('sc065_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeCopyEducationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-065',
        semanticLabel: 'Giáo dục sao chép',
        title: 'Giáo dục sao chép',
        subtitle: 'Bài học · Nội dung',
        contentKey: CopyEducationTabletPage.contentKey,
        children: [
          _copyError(
            'Không tải được giáo dục',
            () => ref.invalidate(tradeCopyEducationProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-065',
        semanticLabel: 'Giáo dục sao chép',
        title: 'Giáo dục sao chép',
        subtitle: 'Bài học theo chủ đề',
        contentKey: CopyEducationTabletPage.contentKey,
        children: [
          for (final tab in snapshot.tabs)
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: _copySection(
                title: tab.label,
                rows: [
                  for (final step in snapshot.steps)
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Row(
                        children: [
                          SizedBox(
                            width: TabletSpacingTokens.x7,
                            child: Text(
                              '${step.number}',
                              style: AppTextStyles.control.copyWith(
                                color: AppColors.primary,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              step.title,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// SC-083: Trung tâm an toàn sao chép.
class CopySafetyCenterTabletPage extends ConsumerWidget {
  const CopySafetyCenterTabletPage({super.key});

  static const contentKey = Key('sc083_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeCopySafetyCenterProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-083',
        semanticLabel: 'Trung tâm an toàn sao chép',
        title: 'Trung tâm an toàn',
        subtitle: 'Chuẩn mực · Công cụ',
        contentKey: CopySafetyCenterTabletPage.contentKey,
        children: [
          _copyError(
            'Không tải được trung tâm an toàn',
            () => ref.invalidate(tradeCopySafetyCenterProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-083',
        semanticLabel: 'Trung tâm an toàn sao chép',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroDescription,
        contentKey: CopySafetyCenterTabletPage.contentKey,
        children: [
          _copySection(
            title: 'Hạng xác minh provider',
            rows: [
              for (final tier in snapshot.verificationTiers)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          tier.tier,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          tier.requirements.join(', '),
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _copySection(
            title: 'Hành vi bị cấm',
            rows: [
              ..._bulletCopy(snapshot.prohibitedBehaviors, AppColors.sell),
            ],
          ),

          _copySection(
            title: 'Trách nhiệm người sao chép',
            rows: [
              ..._bulletCopy(snapshot.followerResponsibilities, AppColors.buy),
            ],
          ),

          Text(
            snapshot.warningText,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _bulletCopy(List<String> notes, Color color) {
  return [
    for (final note in notes)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.zero,
              child: Icon(
                Icons.close_rounded,
                size: TabletSpacingTokens.iconSm,
                color: color,
              ),
            ),
            const SizedBox(width: TabletSpacingTokens.x2),
            Expanded(
              child: Text(
                note,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}
