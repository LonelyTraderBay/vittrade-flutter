part of 'staking_tablet_pages.dart';

/// SC-275: Staking tổ chức.
class StakingInstitutionalTabletPage extends ConsumerWidget {
  const StakingInstitutionalTabletPage({super.key});

  static const contentKey = Key('sc275_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingInstitutionalSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-275',
        semanticLabel: 'Staking tổ chức',
        title: snapshotAsync.value?.infoTitle ?? 'Staking tổ chức',
        subtitle: 'Lô · Phê duyệt',
        contentKey: StakingInstitutionalTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được staking tổ chức',
            () => ref.invalidate(stakingInstitutionalSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-275',
        semanticLabel: 'Staking tổ chức',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingInstitutionalTabletPage.contentKey,
        children: [
          _stkSection(
            title: 'Chỉ số',
            rows: _stkRows([
              for (final stat in snapshot.stats) (stat.label, stat.value),
            ]),
          ),

          _stkSection(
            title: 'Lô đang chờ',
            rows: [
              for (final batch in snapshot.pendingBatches)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${batch.type.name} · ${batch.operations} thao tác',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${_stkUsd(batch.totalAmount)} · ${batch.approvals}/${batch.requiredApprovals} duyệt',
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
    );
  }
}

/// SC-276: Bảo hiểm staking.
class StakingInsuranceTabletPage extends ConsumerWidget {
  const StakingInsuranceTabletPage({super.key});

  static const contentKey = Key('sc276_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingInsuranceSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-276',
        semanticLabel: 'Bảo hiểm staking',
        title: snapshotAsync.value?.infoTitle ?? 'Bảo hiểm staking',
        subtitle: 'Gói · Yêu cầu',
        contentKey: StakingInsuranceTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được bảo hiểm',
            () => ref.invalidate(stakingInsuranceSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-276',
        semanticLabel: 'Bảo hiểm staking',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingInsuranceTabletPage.contentKey,
        children: [
          _stkSection(
            title: 'Gói bảo hiểm',
            rows: [
              for (final plan in snapshot.plans)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.name,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              'Phí ${_stkPct(plan.premium)} · chờ ${plan.cooldownDays} ngày',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Bồi thường tối đa ${_stkUsd(plan.maxClaim)}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _stkSection(
            title: 'Yêu cầu bồi thường',
            rows: [
              for (final claim in snapshot.claims)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${claim.date} · ${claim.position}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${claim.status} · ${_stkUsd(claim.payout)}',
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
    );
  }
}

/// SC-277: Minh bạch quỹ bảo hiểm.
class StakingInsuranceFundTransparencyTabletPage extends ConsumerWidget {
  const StakingInsuranceFundTransparencyTabletPage({super.key});

  static const contentKey = Key('sc277_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      stakingInsuranceFundTransparencySnapshotProvider,
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-277',
        semanticLabel: 'Minh bạch quỹ bảo hiểm',
        title: 'Quỹ bảo hiểm',
        subtitle: 'Số dư · Tỷ lệ',
        contentKey: StakingInsuranceFundTransparencyTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được quỹ bảo hiểm',
            () => ref.invalidate(
              stakingInsuranceFundTransparencySnapshotProvider,
            ),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-277',
        semanticLabel: 'Minh bạch quỹ bảo hiểm',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingInsuranceFundTransparencyTabletPage.contentKey,
        children: [
          _stkSection(
            title: 'Sức khoẻ quỹ',
            rows: _stkRows([
              ('Tổng số dư', _stkUsd(snapshot.totalBalance)),
              ('Tỷ lệ mục tiêu', '${snapshot.targetRatio}%'),
              ('Tỷ lệ hiện tại', '${snapshot.currentRatio}%'),
              ('Nghĩa vụ', _stkUsd(snapshot.liabilities)),
              ('Thặng dư', _stkUsd(snapshot.surplus)),
              ('Cập nhật', snapshot.lastUpdated),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-278: Bảng rủi ro staking.
class StakingRiskDashboardTabletPage extends ConsumerWidget {
  const StakingRiskDashboardTabletPage({super.key});

  static const contentKey = Key('sc278_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingRiskDashboardSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-278',
        semanticLabel: 'Bảng rủi ro staking',
        title: 'Rủi ro staking',
        subtitle: 'Điểm · Tiếp xúc',
        contentKey: StakingRiskDashboardTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được rủi ro',
            () => ref.invalidate(stakingRiskDashboardSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-278',
        semanticLabel: 'Bảng rủi ro staking',
        title: snapshot.title,
        subtitle:
            'Điểm ${snapshot.overallScore}/100 · bảo vệ ${snapshot.protectedPercent}%',
        contentKey: StakingRiskDashboardTabletPage.contentKey,
        children: [
          _stkSection(
            title: 'Tổng quan',
            rows: _stkRows([
              ('Đang stake', _stkUsd(snapshot.totalStakedUsd)),
              ('Có rủi ro', _stkUsd(snapshot.atRiskUsd)),
            ]),
          ),

          _stkSection(
            title: 'Chỉ số rủi ro',
            rows: [
              for (final metric in snapshot.riskMetrics)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${metric.category} — ${metric.score}/100',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              metric.description,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        metric.status,
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
    );
  }
}

/// SC-279: Máy tính điểm rủi ro.
class StakingRiskScoreCalculatorTabletPage extends ConsumerWidget {
  const StakingRiskScoreCalculatorTabletPage({super.key});

  static const contentKey = Key('sc279_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingRiskScoreCalculatorSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-279',
        semanticLabel: 'Tính điểm rủi ro staking',
        title: 'Tính điểm rủi ro',
        subtitle: 'Vốn · Tài sản · Thời gian',
        contentKey: StakingRiskScoreCalculatorTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được máy tính điểm rủi ro',
            () => ref.invalidate(stakingRiskScoreCalculatorSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-279',
        semanticLabel: 'Tính điểm rủi ro staking',
        title: snapshot.title,
        subtitle:
            'Mặc định ${_stkUsd(snapshot.defaultAmountUsd)} ${snapshot.defaultAsset}',
        contentKey: StakingRiskScoreCalculatorTabletPage.contentKey,
        children: [
          _stkSection(
            title: 'Tham số mặc định',
            rows: _stkRows([
              ('Số vốn', _stkUsd(snapshot.defaultAmountUsd)),
              ('Tài sản', snapshot.defaultAsset),
              ('Thời gian', snapshot.defaultDuration),
              ('Số validator', '${snapshot.defaultValidators}'),
            ]),
          ),

          _stkSection(
            title: 'Tuỳ chọn tài sản',
            rows: _stkBullets([
              for (final option in snapshot.assetOptions) option.label,
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-280: Lịch sử slashing.
class StakingSlashingHistoryTabletPage extends ConsumerWidget {
  const StakingSlashingHistoryTabletPage({super.key});

  static const contentKey = Key('sc280_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingSlashingHistorySnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-280',
        semanticLabel: 'Lịch sử slashing',
        title: 'Lịch sử slashing',
        subtitle: 'Sự kiện · Phủ sóng',
        contentKey: StakingSlashingHistoryTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được slashing',
            () => ref.invalidate(stakingSlashingHistorySnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-280',
        semanticLabel: 'Lịch sử slashing',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingSlashingHistoryTabletPage.contentKey,
        children: [
          _stkSection(
            title: 'Thống kê',
            rows: _stkRows([
              ('Sự kiện', '${snapshot.stats.totalEvents}'),
              ('Tổng bị slash', '${snapshot.stats.totalSlashedEth} ETH'),
              ('Được phủ', '${snapshot.stats.totalCoveredEth} ETH'),
              ('Tỷ lệ phủ', _stkPct(snapshot.stats.coverageRate, 1)),
              ('Phục hồi TB', snapshot.stats.avgRecoveryTime),
            ]),
          ),

          _stkSection(
            title: 'Sự kiện gần đây',
            rows: [
              for (final event in snapshot.events.take(8))
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${event.validator} · ${event.network}',
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              '${event.reason} · ${event.dateLabel}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${event.slashedAmount} ETH',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.sell,
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
    );
  }
}
