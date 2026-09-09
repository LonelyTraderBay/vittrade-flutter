part of 'p2p_settings_tablet_pages.dart';

/// SC-278: Cài đặt thông báo P2P.
class P2PNotificationsSettingsTabletPage extends ConsumerWidget {
  const P2PNotificationsSettingsTabletPage({super.key});

  static const contentKey = Key('sc278_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pNotificationSettingsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-278',
        semanticLabel: 'Cài đặt thông báo P2P',
        title: 'Thông báo',
        subtitle: 'Kênh · Sự kiện',
        contentKey: P2PNotificationsSettingsTabletPage.contentKey,
        children: [
          VitErrorState(
            title: 'Không tải được thông báo',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pNotificationSettingsProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-278',
        semanticLabel: 'Cài đặt thông báo P2P',
        title: snapshot.heroTitle,
        subtitle: snapshot.subtitle,
        contentKey: P2PNotificationsSettingsTabletPage.contentKey,
        children: [
          for (final setting in snapshot.settings)
            Padding(
              padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
              child: _stSection(
                title: setting.label,
                rows: [
                  Text(
                    setting.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x2),
                  Wrap(
                    spacing: TabletSpacingTokens.x3,
                    runSpacing: TabletSpacingTokens.x2,
                    children: [
                      for (final entry in setting.channels.entries)
                        VitStatusPill(
                          label: '${entry.key}: ${entry.value ? 'Bật' : 'Tắt'}',
                          status: entry.value
                              ? VitStatusPillStatus.success
                              : VitStatusPillStatus.neutral,
                          size: VitStatusPillSize.sm,
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// SC-280: Hướng dẫn P2P.
class P2PGuideTabletPage extends ConsumerWidget {
  const P2PGuideTabletPage({super.key});

  static const contentKey = Key('sc280_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pGuideProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-280',
        semanticLabel: 'Hướng dẫn P2P',
        title: 'Hướng dẫn',
        subtitle: 'Các bước · FAQ',
        contentKey: P2PGuideTabletPage.contentKey,
        children: [
          VitErrorState(
            title: 'Không tải được hướng dẫn',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pGuideProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-280',
        semanticLabel: 'Hướng dẫn P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PGuideTabletPage.contentKey,
        children: [
          _stSection(
            title: 'Các bước mua',
            rows: [
              for (var i = 0; i < snapshot.buySteps.length; i++)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      SizedBox(
                        width: TabletSpacingTokens.x7,
                        child: Text(
                          '${i + 1}',
                          style: AppTextStyles.control.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          snapshot.buySteps[i].title,
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

          _stSection(
            title: 'Các bước bán',
            rows: [
              for (var i = 0; i < snapshot.sellSteps.length; i++)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      SizedBox(
                        width: TabletSpacingTokens.x7,
                        child: Text(
                          '${i + 1}',
                          style: AppTextStyles.control.copyWith(
                            color: AppColors.sell,
                            fontWeight: AppTextStyles.bold,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          snapshot.sellSteps[i].title,
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

          _stSection(
            title: 'An toàn',
            rows: [
              for (final tip in snapshot.safetyTips)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    '• ${tip.title}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: TabletSpacingTokens.x4),

          Wrap(
            spacing: TabletSpacingTokens.x3,
            runSpacing: TabletSpacingTokens.x2,
            children: [
              VitCtaButton(
                fullWidth: false,
                variant: VitCtaButtonVariant.secondary,
                onPressed: () => context.push(snapshot.marketRoute),
                child: const Text('Về chợ P2P'),
              ),
              VitCtaButton(
                fullWidth: false,
                variant: VitCtaButtonVariant.ghost,
                onPressed: () => context.push(snapshot.supportRoute),
                child: const Text('Hỗ trợ'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-272: Báo cáo thuế P2P (dùng chung cho /p2p/tax-report/detailed/:year).
class P2PTaxReportingTabletPage extends ConsumerWidget {
  const P2PTaxReportingTabletPage({
    super.key,
    this.initialYear = 2025,
    this.jurisdiction = 'US',
  });

  static const contentKey = Key('sc272_tablet_content');

  final int initialYear;
  final String jurisdiction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = (
      selectedYear: initialYear,
      selectedJurisdiction: jurisdiction,
    );
    final snapshotAsync = ref.watch(p2pTaxReportingProvider(request));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-272',
        semanticLabel: 'Báo cáo thuế P2P',
        title: 'Báo cáo thuế',
        subtitle: 'Tổng hợp · Tài liệu',
        contentKey: P2PTaxReportingTabletPage.contentKey,
        children: [
          VitErrorState(
            title: 'Không tải được báo cáo thuế',
            message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(p2pTaxReportingProvider(request)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-272',
        semanticLabel: 'Báo cáo thuế P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PTaxReportingTabletPage.contentKey,
        children: [
          _stSection(
            title:
                'Năm ${snapshot.selectedYear} · ${snapshot.selectedJurisdiction.name} (${snapshot.selectedJurisdiction.form})',
            rows: _stRows([
              ('Số giao dịch', '${snapshot.summary.totalTransactions}'),
              ('Tổng khối lượng', snapshot.summary.totalVolumeLabel),
              ('Lãi vốn', snapshot.summary.capitalGainsLabel),
            ]),
          ),

          _stSection(
            title: 'Tài liệu tải về',
            rows: [
              for (final doc in snapshot.documents)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.title,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              doc.subtitle,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VitStatusPill(
                        label: doc.format,
                        status: VitStatusPillStatus.info,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                ),
            ],
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
