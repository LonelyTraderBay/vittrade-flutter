part of 'launchpad_tablet_pages.dart';

/// SC-378: Sổ địa chỉ launchpad.
class LaunchpadAddressBookTabletPage extends ConsumerWidget {
  const LaunchpadAddressBookTabletPage({super.key});

  static const contentKey = Key('sc378_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadAddressBookSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-378',
        semanticLabel: 'Sổ địa chỉ launchpad',
        title: 'Sổ địa chỉ',
        subtitle: 'Ví · Chuỗi',
        contentKey: LaunchpadAddressBookTabletPage.contentKey,
        child: _lpdError(
          'Không tải được sổ địa chỉ',
          () => ref.invalidate(launchpadAddressBookSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-378',
        semanticLabel: 'Sổ địa chỉ launchpad',
        title: snapshot.title,
        subtitle: '${snapshot.addresses.length} địa chỉ',
        contentKey: LaunchpadAddressBookTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Địa chỉ',
              rows: [
                for (final address in snapshot.addresses.take(10))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      address.id,
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

/// SC-379: Webhooks launchpad.
class LaunchpadWebhooksTabletPage extends ConsumerWidget {
  const LaunchpadWebhooksTabletPage({super.key});

  static const contentKey = Key('sc379_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadWebhooksSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-379',
        semanticLabel: 'Kênh webhooks',
        title: 'Webhooks',
        subtitle: 'Đăng ký · Giao nhận',
        contentKey: LaunchpadWebhooksTabletPage.contentKey,
        child: _lpdError(
          'Không tải được webhooks',
          () => ref.invalidate(launchpadWebhooksSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-379',
        semanticLabel: 'Kênh webhooks',
        title: snapshot.title,
        subtitle: '${snapshot.subscriptions.length} đăng ký',
        contentKey: LaunchpadWebhooksTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Loại sự kiện',
              rows: _lpdRows([
                for (final eventType in snapshot.eventTypes.take(8))
                  (eventType.type, eventType.label),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-380: Theo dõi gas.
class LaunchpadGasTrackerTabletPage extends ConsumerWidget {
  const LaunchpadGasTrackerTabletPage({super.key});

  static const contentKey = Key('sc380_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadGasTrackerSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-380',
        semanticLabel: 'Theo dõi gas',
        title: 'Gas tracker',
        subtitle: 'Giá gas · Ước tính',
        contentKey: LaunchpadGasTrackerTabletPage.contentKey,
        child: _lpdError(
          'Không tải được gas tracker',
          () => ref.invalidate(launchpadGasTrackerSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-380',
        semanticLabel: 'Theo dõi gas',
        title: snapshot.title,
        subtitle: '${snapshot.prices.length} mức giá',
        contentKey: LaunchpadGasTrackerTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Giá gas',
              rows: [
                for (final price in snapshot.prices.take(6))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      price.chain,
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

/// SC-381: Tự cân đối launchpad.
class LaunchpadRebalanceTabletPage extends ConsumerWidget {
  const LaunchpadRebalanceTabletPage({super.key});

  static const contentKey = Key('sc381_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadRebalanceSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-381',
        semanticLabel: 'Tự cân đối launchpad',
        title: 'Tự cân đối',
        subtitle: 'Tài sản · Chiến lược',
        contentKey: LaunchpadRebalanceTabletPage.contentKey,
        child: _lpdError(
          'Không tải được tự cân đối',
          () => ref.invalidate(launchpadRebalanceSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-381',
        semanticLabel: 'Tự cân đối launchpad',
        title: snapshot.title,
        subtitle: '${snapshot.assets.length} tài sản',
        contentKey: LaunchpadRebalanceTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Chiến lược',
              rows: [
                for (final strategy in snapshot.strategies)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      strategy.id,
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

/// SC-382: Multisig launchpad.
class LaunchpadMultisigTabletPage extends ConsumerWidget {
  const LaunchpadMultisigTabletPage({super.key});

  static const contentKey = Key('sc382_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadMultisigSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-382',
        semanticLabel: 'Chữ ký đa tầng',
        title: 'Multisig',
        subtitle: 'Safe · Giao dịch',
        contentKey: LaunchpadMultisigTabletPage.contentKey,
        child: _lpdError(
          'Không tải được multisig',
          () => ref.invalidate(launchpadMultisigSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-382',
        semanticLabel: 'Chữ ký đa tầng',
        title: snapshot.title,
        subtitle: '${snapshot.safes.length} safe',
        contentKey: LaunchpadMultisigTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Giao dịch',
              rows: [
                for (final tx in snapshot.transactions.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      tx.id,
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

/// SC-383: Tổng hợp swap.
class LaunchpadSwapAggregatorTabletPage extends ConsumerWidget {
  const LaunchpadSwapAggregatorTabletPage({super.key});

  static const contentKey = Key('sc383_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadSwapAggregatorSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-383',
        semanticLabel: 'Tổng hợp swap',
        title: 'Swap aggregator',
        subtitle: 'Tỷ giá · Trượt giá',
        contentKey: LaunchpadSwapAggregatorTabletPage.contentKey,
        child: _lpdError(
          'Không tải được swap',
          () => ref.invalidate(launchpadSwapAggregatorSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-383',
        semanticLabel: 'Tổng hợp swap',
        title: snapshot.title,
        subtitle: '${snapshot.fromToken} → ${snapshot.toToken}',
        contentKey: LaunchpadSwapAggregatorTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Cấu hình',
              rows: _lpdRows([
                ('Từ', snapshot.fromToken),
                ('Đến', snapshot.toToken),
                ('Số lượng', snapshot.amount),
                (
                  'Trượt giá',
                  '${snapshot.slippageTolerance.toStringAsFixed(1)}%',
                ),
                ('Tự làm mới', snapshot.autoRefresh ? 'Bật' : 'Tắt'),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-384: Lệnh chờ launchpad.
class LaunchpadLimitOrdersTabletPage extends ConsumerWidget {
  const LaunchpadLimitOrdersTabletPage({super.key});

  static const contentKey = Key('sc384_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadLimitOrdersSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-384',
        semanticLabel: 'Lệnh chờ launchpad',
        title: 'Lệnh chờ',
        subtitle: 'Đã khớp 24h',
        contentKey: LaunchpadLimitOrdersTabletPage.contentKey,
        child: _lpdError(
          'Không tải được lệnh chờ',
          () => ref.invalidate(launchpadLimitOrdersSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-384',
        semanticLabel: 'Lệnh chờ launchpad',
        title: snapshot.title,
        subtitle:
            '${snapshot.filled24h} khớp 24h · ${snapshot.totalValueLabel}',
        contentKey: LaunchpadLimitOrdersTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Lệnh',
              rows: [
                for (final order in snapshot.orders.take(8))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      order.id,
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

/// SC-385: DCA builder launchpad.
class LaunchpadDcaBuilderTabletPage extends ConsumerWidget {
  const LaunchpadDcaBuilderTabletPage({super.key});

  static const contentKey = Key('sc385_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadDcaBuilderSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-385',
        semanticLabel: 'Trình dựng DCA',
        title: 'DCA builder',
        subtitle: 'Chiến lược · Thực hiện',
        contentKey: LaunchpadDcaBuilderTabletPage.contentKey,
        child: _lpdError(
          'Không tải được DCA builder',
          () => ref.invalidate(launchpadDcaBuilderSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-385',
        semanticLabel: 'Trình dựng DCA',
        title: snapshot.title,
        subtitle: '${snapshot.strategies.length} chiến lược',
        contentKey: LaunchpadDcaBuilderTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Chiến lược',
              rows: [
                for (final strategy in snapshot.strategies)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      strategy.id,
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

/// SC-386: Phân tích rủi ro dự án launchpad.
class LaunchpadRiskAnalyticsTabletPage extends ConsumerWidget {
  const LaunchpadRiskAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc386_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(launchpadRiskAnalyticsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-386',
        semanticLabel: 'Phân tích rủi ro launchpad',
        title: 'Phân tích rủi ro',
        subtitle: 'Dự án · Kiểm toán',
        contentKey: LaunchpadRiskAnalyticsTabletPage.contentKey,
        child: _lpdError(
          'Không tải được phân tích rủi ro',
          () => ref.invalidate(launchpadRiskAnalyticsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _lpdFrame(
        context: context,
        semanticIdentifier: 'SC-386',
        semanticLabel: 'Phân tích rủi ro launchpad',
        title: snapshot.title,
        subtitle: snapshot.project.id,
        contentKey: LaunchpadRiskAnalyticsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _lpdSection(
              title: 'Báo cáo kiểm toán',
              rows: [
                for (final audit in snapshot.auditReports.take(6))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      '${audit.firm} · ${audit.date}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _lpdSection(
              title: 'Tài liệu',
              rows: [
                for (final resource in snapshot.resources.take(6))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Text(
                      resource.label,
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
