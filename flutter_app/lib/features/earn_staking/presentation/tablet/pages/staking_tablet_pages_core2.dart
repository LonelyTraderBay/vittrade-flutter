part of 'staking_tablet_pages.dart';

/// SC-258: Bảng điều khiển staking.
class StakingDashboardTabletPage extends ConsumerWidget {
  const StakingDashboardTabletPage({super.key});

  static const contentKey = Key('sc258_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingDashboardSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-258',
        semanticLabel: 'Bảng staking',
        title: 'Staking dashboard',
        subtitle: 'Tài sản · Phần thưởng',
        contentKey: StakingDashboardTabletPage.contentKey,
        child: _stkError(
          'Không tải được dashboard',
          () => ref.invalidate(stakingDashboardSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-258',
        semanticLabel: 'Bảng staking',
        title: snapshot.title,
        subtitle: _stkUsd(snapshot.totalStakedUsd),
        contentKey: StakingDashboardTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Tổng quan',
              rows: _stkRows([
                ('Đang stake', _stkUsd(snapshot.totalStakedUsd)),
                ('Đã kiếm', _stkUsdS(snapshot.totalEarnedUsd)),
                ('APY bình quân', _stkPct(snapshot.weightedApy)),
                ('Kiếm mỗi ngày', _stkUsd(snapshot.dailyEarningsUsd)),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Vị thế',
              rows: [
                for (final position in snapshot.positions)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${position.product} · ${position.asset} ${position.amount}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${_stkUsd(position.usdValue)} · đã kiếm ${_stkUsdS(position.earnedUsd)}',
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

/// SC-259: Phân tích staking.
class StakingAnalyticsTabletPage extends ConsumerWidget {
  const StakingAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc259_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingAnalyticsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-259',
        semanticLabel: 'Phân tích staking',
        title: 'Phân tích staking',
        subtitle: 'Lợi suất · ROI',
        contentKey: StakingAnalyticsTabletPage.contentKey,
        child: _stkError(
          'Không tải được phân tích',
          () => ref.invalidate(stakingAnalyticsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-259',
        semanticLabel: 'Phân tích staking',
        title: snapshot.title,
        subtitle: _stkUsdS(snapshot.summary.totalEarned),
        contentKey: StakingAnalyticsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Tổng hợp',
              rows: _stkRows([
                ('Đã kiếm', _stkUsdS(snapshot.summary.totalEarned)),
                ('APY bình quân', _stkPct(snapshot.summary.averageApy)),
                ('ROI tốt nhất', _stkPct(snapshot.summary.bestRoi)),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Hiệu suất theo sản phẩm',
              rows: [
                for (final product in snapshot.productPerformance)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${product.product} (${product.asset})',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          'Gửi ${_stkUsd(product.investedUsd)} · kiếm ${_stkUsdS(product.earnedUsd)} · ROI ${_stkPct(product.roi)}',
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
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: 'Staking vs giữ nguyên',
              rows: [
                for (final point in snapshot.roiComparison)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            point.month,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          'Staking ${_stkPct(point.staking)} · Holding ${_stkPct(point.holding)}',
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

/// SC-260: Lịch sử staking.
class StakingHistoryTabletPage extends ConsumerWidget {
  const StakingHistoryTabletPage({super.key});

  static const contentKey = Key('sc260_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingHistorySnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-260',
        semanticLabel: 'Lịch sử staking',
        title: 'Lịch sử staking',
        subtitle: 'Giao dịch',
        contentKey: StakingHistoryTabletPage.contentKey,
        child: _stkError(
          'Không tải được lịch sử',
          () => ref.invalidate(stakingHistorySnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-260',
        semanticLabel: 'Lịch sử staking',
        title: snapshot.title,
        subtitle: '${snapshot.transactions.length} giao dịch',
        contentKey: StakingHistoryTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _esv0Spacer(),
            _stkSection(
              title: 'Giao dịch',
              rows: [
                for (final tx in snapshot.transactions.take(12))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${tx.type.name} · ${tx.product}',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${tx.asset} ${tx.amountLabel} · ${tx.date} ${tx.time}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _stkUsd(tx.usdValue),
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

Widget _esv0Spacer() => const SizedBox(height: TabletSpacingTokens.x1);

/// SC-261: Lịch phần thưởng staking.
class StakingEarningsCalendarTabletPage extends ConsumerWidget {
  const StakingEarningsCalendarTabletPage({super.key});

  static const contentKey = Key('sc261_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingEarningsCalendarSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-261',
        semanticLabel: 'Lịch phần thưởng staking',
        title: 'Lịch phần thưởng',
        subtitle: 'Sự kiện sắp tới',
        contentKey: StakingEarningsCalendarTabletPage.contentKey,
        child: _stkError(
          'Không tải được lịch',
          () => ref.invalidate(stakingEarningsCalendarSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-261',
        semanticLabel: 'Lịch phần thưởng staking',
        title: snapshot.title,
        subtitle:
            '${snapshot.currentMonthLabel} · sắp tới ${_stkUsd(snapshot.totalUpcomingUsd)}',
        contentKey: StakingEarningsCalendarTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Sự kiện',
              rows: [
                for (final event in snapshot.events)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${event.product} · ${event.asset}',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${event.description} · ${event.dateIso}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (event.usdValue != null)
                          Text(
                            _stkUsd(event.usdValue!),
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
