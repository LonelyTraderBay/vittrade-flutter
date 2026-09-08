part of 'staking_tablet_pages.dart';

/// SC-286: Báo cáo kiểm toán staking.
class StakingAuditReportsTabletPage extends ConsumerWidget {
  const StakingAuditReportsTabletPage({super.key});

  static const contentKey = Key('sc286_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingAuditReportsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-286',
        semanticLabel: 'Báo cáo kiểm toán staking',
        title: snapshotAsync.value?.heroTitle ?? 'Kiểm toán',
        subtitle: 'Báo cáo · Bug bounty',
        contentKey: StakingAuditReportsTabletPage.contentKey,
        child: _stkError(
          'Không tải được kiểm toán',
          () => ref.invalidate(stakingAuditReportsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-286',
        semanticLabel: 'Báo cáo kiểm toán staking',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroBody,
        contentKey: StakingAuditReportsTabletPage.contentKey,
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
              title: 'Báo cáo',
              rows: [
                for (final report in snapshot.reports)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${report.title} — ${report.auditor}',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${report.dateLabel} · nghiêm trọng ${report.findings.critical}, cao ${report.findings.high}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          report.status.name,
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

/// SC-287: Lưu ký staking.
class StakingCustodyTabletPage extends ConsumerWidget {
  const StakingCustodyTabletPage({super.key});

  static const contentKey = Key('sc287_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingCustodySnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-287',
        semanticLabel: 'Lưu ký staking',
        title: snapshotAsync.value?.heroTitle ?? 'Lưu ký',
        subtitle: 'Thủ quỹ · Tách biệt',
        contentKey: StakingCustodyTabletPage.contentKey,
        child: _stkError(
          'Không tải được lưu ký',
          () => ref.invalidate(stakingCustodySnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-287',
        semanticLabel: 'Lưu ký staking',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroBody,
        contentKey: StakingCustodyTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Đối tác lưu ký',
              rows: _stkRows([
                ('Tên', snapshot.custodian.name),
                ('Loại', snapshot.custodian.type),
                ('Trụ sở', snapshot.custodian.headquarters),
                ('Bảo hiểm', snapshot.custodian.insurance),
                ('AUM', snapshot.custodian.aum),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Tách biệt tài sản',
              rows: [
                for (final allocation in snapshot.segregation)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            allocation.name,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${allocation.value}%',
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

/// SC-288: Bằng chứng dự trữ.
class StakingProofOfReservesTabletPage extends ConsumerWidget {
  const StakingProofOfReservesTabletPage({super.key});

  static const contentKey = Key('sc288_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingProofOfReservesSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-288',
        semanticLabel: 'Bằng chứng dự trữ',
        title: snapshotAsync.value?.infoTitle ?? 'Bằng chứng dự trữ',
        subtitle: 'Tài sản · Nghĩa vụ',
        contentKey: StakingProofOfReservesTabletPage.contentKey,
        child: _stkError(
          'Không tải được dự trữ',
          () => ref.invalidate(stakingProofOfReservesSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-288',
        semanticLabel: 'Bằng chứng dự trữ',
        title: snapshot.title,
        subtitle: snapshot.infoBody,
        contentKey: StakingProofOfReservesTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Tổng thể',
              rows: _stkRows([
                ('Tài sản', _stkUsd(snapshot.overall.totalAssetsUsd)),
                ('Nghĩa vụ', _stkUsd(snapshot.overall.totalLiabilitiesUsd)),
                ('Tỷ lệ dự trữ', _stkPct(snapshot.overall.reserveRatio)),
                ('Kiểm toán', snapshot.overall.lastAudit),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Theo tài sản',
              rows: [
                for (final asset in snapshot.assets)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            asset.asset,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          'On-chain ${_stkUsd(asset.onChainBalance)} · tỷ lệ ${_stkPct(asset.reserveRatio)}',
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

/// SC-289: Báo cáo giao dịch staking.
class StakingTransactionReportingTabletPage extends ConsumerWidget {
  const StakingTransactionReportingTabletPage({super.key});

  static const contentKey = Key('sc289_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      stakingTransactionReportingSnapshotProvider,
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-289',
        semanticLabel: 'Báo cáo giao dịch staking',
        title: snapshotAsync.value?.infoTitle ?? 'Báo cáo giao dịch',
        subtitle: 'Thuế · Năm',
        contentKey: StakingTransactionReportingTabletPage.contentKey,
        child: _stkError(
          'Không tải được báo cáo',
          () => ref.invalidate(stakingTransactionReportingSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-289',
        semanticLabel: 'Báo cáo giao dịch staking',
        title: snapshot.title,
        subtitle: 'Năm ${snapshot.defaultYear} · ${snapshot.defaultCostBasis}',
        contentKey: StakingTransactionReportingTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Tổng hợp thuế',
              rows: _stkRows([
                (
                  'Thu nhập staking',
                  _stkUsd(snapshot.summary.totalStakingIncome),
                ),
                ('Lãi vốn', _stkUsd(snapshot.summary.totalCapitalGains)),
                ('Ngắn hạn', _stkUsd(snapshot.summary.shortTermGains)),
                ('Dài hạn', _stkUsd(snapshot.summary.longTermGains)),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Giao dịch',
              rows: [
                for (final tx in snapshot.transactions.take(10))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${tx.type} · ${tx.asset} ${tx.amount.toStringAsFixed(4)} · ${tx.date}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          tx.taxable ? 'chịu thuế' : 'không',
                          style: AppTextStyles.caption.copyWith(
                            color: tx.taxable
                                ? AppColors.caution
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
