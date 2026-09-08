part of 'staking_tablet_pages.dart';

/// SC-290: Webhooks staking.
class StakingWebhooksTabletPage extends ConsumerWidget {
  const StakingWebhooksTabletPage({super.key});

  static const contentKey = Key('sc290_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingWebhooksSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-290',
        semanticLabel: 'Kênh webhooks',
        title: snapshotAsync.value?.heroTitle ?? 'Webhooks',
        subtitle: 'Kênh sự kiện',
        contentKey: StakingWebhooksTabletPage.contentKey,
        child: _stkError(
          'Không tải được webhooks',
          () => ref.invalidate(stakingWebhooksSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-290',
        semanticLabel: 'Kênh webhooks',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroBody,
        contentKey: StakingWebhooksTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: snapshot.activeTitle,
              rows: [
                for (final webhook in snapshot.webhooks)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                webhook.url,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${webhook.events.length} sự kiện · lần cuối ${webhook.lastTriggered}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          webhook.active ? 'Bật' : 'Tắt',
                          style: AppTextStyles.caption.copyWith(
                            color: webhook.active
                                ? AppColors.buy
                                : AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: snapshot.eventsTitle,
              rows: _stkBullets(snapshot.availableEvents),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-291: Xuất dữ liệu staking.
class StakingDataExportTabletPage extends ConsumerWidget {
  const StakingDataExportTabletPage({super.key});

  static const contentKey = Key('sc291_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingDataExportSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-291',
        semanticLabel: 'Xuất dữ liệu staking',
        title: snapshotAsync.value?.heroTitle ?? 'Xuất dữ liệu',
        subtitle: 'Báo cáo nhanh',
        contentKey: StakingDataExportTabletPage.contentKey,
        child: _stkError(
          'Không tải được xuất dữ liệu',
          () => ref.invalidate(stakingDataExportSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-291',
        semanticLabel: 'Xuất dữ liệu staking',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroBody,
        contentKey: StakingDataExportTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: snapshot.quickTitle,
              rows: _stkTitleBody([
                for (final quick in snapshot.quickExports)
                  (quick.name, quick.description),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-292: Tích hợp bên thứ ba.
class StakingThirdPartyIntegrationsTabletPage extends ConsumerWidget {
  const StakingThirdPartyIntegrationsTabletPage({super.key});

  static const contentKey = Key('sc292_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      stakingThirdPartyIntegrationsSnapshotProvider,
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-292',
        semanticLabel: 'Tích hợp bên thứ ba',
        title: snapshotAsync.value?.heroTitle ?? 'Tích hợp',
        subtitle: 'Kết nối · API',
        contentKey: StakingThirdPartyIntegrationsTabletPage.contentKey,
        child: _stkError(
          'Không tải được tích hợp',
          () => ref.invalidate(stakingThirdPartyIntegrationsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-292',
        semanticLabel: 'Tích hợp bên thứ ba',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroBody,
        contentKey: StakingThirdPartyIntegrationsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: snapshot.sectionTitle,
              rows: [
                for (final integration in snapshot.integrations)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                integration.name,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                integration.description,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          integration.connected ? 'Đã nối' : 'Chưa nối',
                          style: AppTextStyles.caption.copyWith(
                            color: integration.connected
                                ? AppColors.buy
                                : AppColors.text3,
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

/// SC-293: Console nhà phát triển.
class StakingDeveloperConsoleTabletPage extends ConsumerWidget {
  const StakingDeveloperConsoleTabletPage({super.key});

  static const contentKey = Key('sc293_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingDeveloperConsoleSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-293',
        semanticLabel: 'Console nhà phát triển',
        title: snapshotAsync.value?.heroTitle ?? 'Console',
        subtitle: 'Khoá · Thống kê',
        contentKey: StakingDeveloperConsoleTabletPage.contentKey,
        child: _stkError(
          'Không tải được console',
          () => ref.invalidate(stakingDeveloperConsoleSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-293',
        semanticLabel: 'Console nhà phát triển',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroBody,
        contentKey: StakingDeveloperConsoleTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Thống kê',
              rows: _stkRows([
                for (final stat in snapshot.stats) (stat.label, stat.value),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: snapshot.keysTitle,
              rows: [
                for (final key in snapshot.apiKeys)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                key.name,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${key.keyPreview} · tạo ${key.created}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${key.requests} yêu cầu',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
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

/// SC-294: Tài liệu API staking.
class StakingApiDocumentationTabletPage extends ConsumerWidget {
  const StakingApiDocumentationTabletPage({super.key});

  static const contentKey = Key('sc294_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingApiDocumentationSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-294',
        semanticLabel: 'Tài liệu API staking',
        title: snapshotAsync.value?.infoTitle ?? 'Tài liệu API',
        subtitle: 'Endpoint · Mã lỗi',
        contentKey: StakingApiDocumentationTabletPage.contentKey,
        child: _stkError(
          'Không tải được tài liệu API',
          () => ref.invalidate(stakingApiDocumentationSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-294',
        semanticLabel: 'Tài liệu API staking',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingApiDocumentationTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Endpoint',
              rows: [
                for (final endpoint in snapshot.endpoints)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${endpoint.method} ${endpoint.path}',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          endpoint.description,
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
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Giới hạn tần suất',
              rows: _stkRows([
                for (final limit in snapshot.rateLimits)
                  (limit.tier, '${limit.requests} yêu cầu/${limit.window}'),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
