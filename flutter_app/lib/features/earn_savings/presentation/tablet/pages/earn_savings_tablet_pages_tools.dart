part of 'earn_savings_tablet_pages.dart';

/// SC-302: Mục tiêu tiết kiệm.
class SavingsGoalsTabletPage extends ConsumerWidget {
  const SavingsGoalsTabletPage({super.key});

  static const contentKey = Key('sc302_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsGoalsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-302',
        semanticLabel: 'Mục tiêu tiết kiệm',
        title: snapshotAsync.value?.title ?? 'Mục tiêu',
        subtitle: 'Mục tiêu · Gợi ý',
        contentKey: SavingsGoalsTabletPage.contentKey,
        children: [
          _esvError(
            'Không tải được mục tiêu',
            () => ref.invalidate(savingsGoalsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-302',
        semanticLabel: 'Mục tiêu tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: SavingsGoalsTabletPage.contentKey,
        children: [
          for (final goal in snapshot.goals) ...[
            _esvSection(
              title: goal.name,
              rows: _esvRows([
                (
                  'Mục tiêu',
                  '${goal.targetAmount.toStringAsFixed(0)} ${goal.currency}',
                ),
                (
                  'Hiện tại',
                  '${goal.currentAmount.toStringAsFixed(0)} ${goal.currency}',
                ),
                ('Đóng góp/tháng', goal.monthlyContribution.toStringAsFixed(0)),
                ('Tự động', goal.autoContribute ? 'Bật' : 'Tắt'),
                ('Sản phẩm liên kết', goal.linkedProduct),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],

          _esvSection(
            title: 'Mẫu mục tiêu',
            rows: [
              for (final template in snapshot.templates)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template.name,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              template.description,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${template.suggestedTarget.toStringAsFixed(0)} · ${template.suggestedMonths} tháng',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _esvSection(
            title: 'Mẹo',
            rows: [
              for (final tip in snapshot.tips)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      Text(
                        tip.description,
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
        ],
      ),
    );
  }
}

/// SC-303: Phân tích tiết kiệm.
class SavingsAnalyticsTabletPage extends ConsumerWidget {
  const SavingsAnalyticsTabletPage({super.key});

  static const contentKey = Key('sc303_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsAnalyticsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-303',
        semanticLabel: 'Phân tích tiết kiệm',
        title: 'Phân tích',
        subtitle: 'Lợi suất · Thu nhập',
        contentKey: SavingsAnalyticsTabletPage.contentKey,
        children: [
          _esvError(
            'Không tải được phân tích',
            () => ref.invalidate(savingsAnalyticsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-303',
        semanticLabel: 'Phân tích tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: SavingsAnalyticsTabletPage.contentKey,
        children: [
          _esvSection(
            title: 'Tổng hợp',
            rows: _esvRows([
              ('Đã đầu tư', VitFormat.usd(snapshot.summary.totalInvested)),
              ('Đã kiếm', VitFormat.usd(snapshot.summary.totalEarned)),
              (
                'APY bình quân',
                VitFormat.percent(
                  snapshot.summary.weightedApy,
                  fractionDigits: 2,
                ),
              ),
              ('Kiếm mỗi ngày', VitFormat.usd(snapshot.summary.dailyEarnings)),
              (
                'Kiếm mỗi tháng',
                VitFormat.usd(snapshot.summary.monthlyEarnings),
              ),
              ('Dự báo năm', VitFormat.usd(snapshot.summary.annualProjection)),
              (
                'Biến động lợi suất',
                VitFormat.percent(
                  snapshot.summary.yieldChange,
                  fractionDigits: 2,
                ),
              ),
            ]),
          ),

          _esvSection(
            title: 'Thu nhập theo tháng',
            rows: [
              for (final point in snapshot.monthlyEarnings)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      SizedBox(
                        width: TabletSpacingTokens.x7,
                        child: Text(
                          point.month,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Kiếm ${VitFormat.usd(point.earned)} · Gửi ${VitFormat.usd(point.deposited)} · Rút ${VitFormat.usd(point.withdrawn)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
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

/// SC-304: Tự cân đối danh mục tiết kiệm.
class SavingsRebalanceTabletPage extends ConsumerWidget {
  const SavingsRebalanceTabletPage({super.key});

  static const contentKey = Key('sc304_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsAutoRebalanceSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-304',
        semanticLabel: 'Tự cân đối tiết kiệm',
        title: 'Tự cân đối',
        subtitle: 'Vị thế · Chiến lược',
        contentKey: SavingsRebalanceTabletPage.contentKey,
        children: [
          _esvError(
            'Không tải được tự cân đối',
            () => ref.invalidate(savingsAutoRebalanceSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-304',
        semanticLabel: 'Tự cân đối tiết kiệm',
        title: snapshot.title,
        subtitle: 'Danh mục ${VitFormat.usd(snapshot.totalPortfolio)}',
        contentKey: SavingsRebalanceTabletPage.contentKey,
        children: [
          _esvSection(
            title: 'Vị thế',
            rows: [
              for (final position in snapshot.positions)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${position.asset} · ${position.product}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Text(
                        '${VitFormat.usd(position.currentValue)} · hiện tại ${position.currentPct.toStringAsFixed(1)}% → mục tiêu ${position.targetPct.toStringAsFixed(1)}%',
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

          _esvSection(
            title: 'Chiến lược',
            rows: [
              for (final strategy in snapshot.strategies)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${strategy.name} · APY ${VitFormat.percent(strategy.expectedApy, fractionDigits: 2)}',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                          color: AppColors.text1,
                        ),
                      ),
                      Text(
                        strategy.description,
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

          _esvSection(
            title: 'Lịch sử lệch mục tiêu',
            rows: _esvRows([
              for (final drift in snapshot.driftHistory.take(6))
                (drift.date, VitFormat.percent(drift.drift, fractionDigits: 2)),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-305: Tuỳ chọn thông báo tiết kiệm.
class SavingsNotificationPreferencesTabletPage extends ConsumerWidget {
  const SavingsNotificationPreferencesTabletPage({super.key});

  static const contentKey = Key('sc305_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      savingsNotificationPreferencesSnapshotProvider,
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-305',
        semanticLabel: 'Tuỳ chọn thông báo tiết kiệm',
        title: 'Tuỳ chọn thông báo',
        subtitle: 'Cảnh báo · Kênh nhận',
        contentKey: SavingsNotificationPreferencesTabletPage.contentKey,
        children: [
          _esvError(
            'Không tải được tuỳ chọn thông báo',
            () =>
                ref.invalidate(savingsNotificationPreferencesSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-305',
        semanticLabel: 'Tuỳ chọn thông báo tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.masterEnabled
            ? 'Đang bật toàn cục'
            : 'Đang tắt toàn cục',
        contentKey: SavingsNotificationPreferencesTabletPage.contentKey,
        children: [
          _esvSection(
            title: 'Cảnh báo',
            rows: [
              for (final alert in snapshot.alerts)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              alert.title,
                              style: AppTextStyles.caption.copyWith(
                                fontWeight: AppTextStyles.bold,
                                color: AppColors.text1,
                              ),
                            ),
                            Text(
                              alert.description,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        alert.enabled ? 'Bật' : 'Tắt',
                        style: AppTextStyles.caption.copyWith(
                          color: alert.enabled
                              ? AppColors.buy
                              : AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _esvSection(
            title: 'Kênh nhận',
            rows: _esvRows([
              for (final channel in snapshot.channels)
                (channel.label, channel.enabled ? 'Bật' : 'Tắt'),
            ]),
          ),

          _esvSection(
            title: 'Giờ tĩnh',
            rows: _esvRows([
              ('Bật', snapshot.quietHours.enabled ? 'Có' : 'Không'),
              (
                'Khung giờ',
                '${snapshot.quietHours.startHour}h → ${snapshot.quietHours.endHour}h',
              ),
              (
                'Thông báo khẩn',
                snapshot.quietHours.allowCritical ? 'Vẫn nhận' : 'Cắt hết',
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-306: DCA tiết kiệm.
class SavingsDcaTabletPage extends ConsumerWidget {
  const SavingsDcaTabletPage({super.key});

  static const contentKey = Key('sc306_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsDcaSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-306',
        semanticLabel: 'DCA tiết kiệm',
        title: 'DCA tiết kiệm',
        subtitle: 'Kế hoạch · Thực hiện',
        contentKey: SavingsDcaTabletPage.contentKey,
        children: [
          _esvError(
            'Không tải được DCA tiết kiệm',
            () => ref.invalidate(savingsDcaSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-306',
        semanticLabel: 'DCA tiết kiệm',
        title: snapshot.title,
        subtitle: '${snapshot.activePlanCount} kế hoạch đang chạy',
        contentKey: SavingsDcaTabletPage.contentKey,
        children: [
          _esvSection(
            title: snapshot.heroLabel,
            rows: _esvRows([
              ('Đã đầu tư', snapshot.totalInvestedUsd),
              ('Giá trị hiện tại', snapshot.totalCurrentUsd),
              ('Lợi nhuận', '${snapshot.gainUsd} (${snapshot.gainLabel})'),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-307: Gợi ý thông minh tiết kiệm.
class SavingsSmartSuggestionsTabletPage extends ConsumerWidget {
  const SavingsSmartSuggestionsTabletPage({super.key});

  static const contentKey = Key('sc307_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsSmartSuggestionsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-307',
        semanticLabel: 'Gợi ý thông minh tiết kiệm',
        title: 'Gợi ý thông minh',
        subtitle: 'Đề xuất · Ưu tiên',
        contentKey: SavingsSmartSuggestionsTabletPage.contentKey,
        children: [
          _esvError(
            'Không tải được gợi ý',
            () => ref.invalidate(savingsSmartSuggestionsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-307',
        semanticLabel: 'Gợi ý thông minh tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.heroLabel,
        contentKey: SavingsSmartSuggestionsTabletPage.contentKey,
        children: [
          _esvSection(
            title: 'Tình trạng gợi ý',
            rows: _esvRows([
              ('Chờ xử lý', '${snapshot.pendingCount}'),
              ('Ưu tiên cao', '${snapshot.highPriorityCount}'),
              ('Xu hướng APY tăng', '${snapshot.upTrendCount}'),
              ('Tiềm năng APY', snapshot.potentialApyGainLabel),
            ]),
          ),
        ],
      ),
    );
  }
}
