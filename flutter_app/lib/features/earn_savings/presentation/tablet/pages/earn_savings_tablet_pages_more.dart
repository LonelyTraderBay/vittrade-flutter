part of 'earn_savings_tablet_pages.dart';

/// SC-308: Xuất dữ liệu tiết kiệm.
class SavingsExportTabletPage extends ConsumerWidget {
  const SavingsExportTabletPage({super.key});

  static const contentKey = Key('sc308_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsExportSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-308',
        semanticLabel: 'Xuất dữ liệu tiết kiệm',
        title: 'Xuất dữ liệu',
        subtitle: 'Báo cáo · Định dạng',
        contentKey: SavingsExportTabletPage.contentKey,
        child: _esvError(
          'Không tải được xuất dữ liệu',
          () => ref.invalidate(savingsExportSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-308',
        semanticLabel: 'Xuất dữ liệu tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.heroLabel,
        contentKey: SavingsExportTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _esvSection(
              title: 'Tình trạng',
              rows: _esvRows([
                ('Báo cáo đã tạo', '${snapshot.createdReports}'),
                ('Loại báo cáo', snapshot.reportTypeCountLabel),
                ('Định dạng', snapshot.formatSummary),
                ('Lưu trữ', snapshot.retentionLabel),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Loại báo cáo',
              rows: [
                for (final reportType in snapshot.reportTypes)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reportType.title,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          '${reportType.description} · ${reportType.rowsLabel}',
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
      ),
    );
  }
}

/// SC-309: Kiểm thử lịch sử tiết kiệm.
class SavingsBacktestTabletPage extends ConsumerWidget {
  const SavingsBacktestTabletPage({super.key});

  static const contentKey = Key('sc309_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsBacktestSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-309',
        semanticLabel: 'Kiểm thử lịch sử tiết kiệm',
        title: 'Kiểm thử lịch sử',
        subtitle: 'Số vốn · Kỳ hạn',
        contentKey: SavingsBacktestTabletPage.contentKey,
        child: _esvError(
          'Không tải được kiểm thử',
          () => ref.invalidate(savingsBacktestSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-309',
        semanticLabel: 'Kiểm thử lịch sử tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.heroLabel,
        contentKey: SavingsBacktestTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _esvSection(
              title: 'Tham số mặc định',
              rows: _esvRows([
                (
                  'Số vốn mặc định',
                  VitFormat.usd(snapshot.defaultAmountUsd.toDouble()),
                ),
                (
                  'Số vốn nhanh',
                  snapshot.quickAmounts.map((a) => '\$$a').join(' · '),
                ),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Kỳ hạn',
              rows: [
                for (final period in snapshot.periods)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            period.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          '${period.months} tháng',
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

/// SC-310: Tự động hoá tiết kiệm (Auto Pilot).
class SavingsAutoPilotTabletPage extends ConsumerWidget {
  const SavingsAutoPilotTabletPage({super.key});

  static const contentKey = Key('sc310_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsAutoPilotSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-310',
        semanticLabel: 'Tự động hoá tiết kiệm',
        title: 'Auto Pilot',
        subtitle: 'Cấu hình · Mô-đun',
        contentKey: SavingsAutoPilotTabletPage.contentKey,
        child: _esvError(
          'Không tải được Auto Pilot',
          () => ref.invalidate(savingsAutoPilotSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-310',
        semanticLabel: 'Tự động hoá tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.heroLabel,
        contentKey: SavingsAutoPilotTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _esvSection(
              title: 'Cấu hình hiện tại',
              rows: _esvRows([
                ('Chế độ', snapshot.config.mode.name),
                ('Trạng thái', snapshot.config.status.name),
                (
                  'Ngân sách tháng',
                  VitFormat.usd(snapshot.config.monthlyBudgetUsd.toDouble()),
                ),
                (
                  'DCA',
                  snapshot.config.dcaEnabled
                      ? snapshot.config.dcaFrequencyLabel
                      : 'Tắt',
                ),
                (
                  'Tự cân đối',
                  snapshot.config.rebalanceEnabled
                      ? 'Bật (ngưỡng ${snapshot.config.rebalanceThresholdPct}%)'
                      : 'Tắt',
                ),
                (
                  'Chuyển đổi thông minh',
                  snapshot.config.smartSwitchEnabled ? 'Bật' : 'Tắt',
                ),
                ('Gộp lãi', snapshot.config.compoundEnabled ? 'Bật' : 'Tắt'),
                (
                  'Cảnh giác rủi ro',
                  snapshot.config.riskGuardEnabled ? 'Bật' : 'Tắt',
                ),
                ('Trần một tài sản', '${snapshot.config.maxSingleAssetPct}%'),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Chỉ số',
              rows: _esvRows([
                for (final metric in snapshot.metrics)
                  (metric.label, '${metric.value} (${metric.deltaLabel})'),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Mô-đun',
              rows: [
                for (final module in snapshot.modules)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                module.label,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                module.description,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          module.enabled ? 'Bật' : 'Tắt',
                          style: AppTextStyles.caption.copyWith(
                            color: module.enabled
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

/// SC-311: Thang kỳ hạn tiết kiệm.
class SavingsLadderTabletPage extends ConsumerWidget {
  const SavingsLadderTabletPage({super.key});

  static const contentKey = Key('sc311_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsLadderSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-311',
        semanticLabel: 'Thang kỳ hạn tiết kiệm',
        title: 'Thang kỳ hạn',
        subtitle: 'Mẫu · Bậc',
        contentKey: SavingsLadderTabletPage.contentKey,
        child: _esvError(
          'Không tải được thang kỳ hạn',
          () => ref.invalidate(savingsLadderSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-311',
        semanticLabel: 'Thang kỳ hạn tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.heroLabel,
        contentKey: SavingsLadderTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final template in snapshot.templates) ...[
              _esvSection(
                title: template.label,
                rows: [
                  _esvBody(template.description),
                  ..._esvRows([
                    for (final interval in template.intervals)
                      (
                        '${interval.lockDays} ngày',
                        '${interval.allocationPct}% · APY ${interval.apyPct.toStringAsFixed(2)}%',
                      ),
                  ]),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
          ],
        ),
      ),
    );
  }
}

/// SC-312: Kịch bản giả định tiết kiệm.
class SavingsWhatIfTabletPage extends ConsumerWidget {
  const SavingsWhatIfTabletPage({super.key});

  static const contentKey = Key('sc312_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsWhatIfSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-312',
        semanticLabel: 'Kịch bản giả định tiết kiệm',
        title: 'Kịch bản giả định',
        subtitle: 'APY · Biến động',
        contentKey: SavingsWhatIfTabletPage.contentKey,
        child: _esvError(
          'Không tải được kịch bản',
          () => ref.invalidate(savingsWhatIfSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-312',
        semanticLabel: 'Kịch bản giả định tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.heroLabel,
        contentKey: SavingsWhatIfTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final scenario in snapshot.scenarios) ...[
              _esvSection(
                title: scenario.label,
                rows: _esvRows([
                  ('Mô tả', scenario.description),
                  (
                    'Hệ số APY',
                    '${scenario.apyMultiplier.toStringAsFixed(2)}×',
                  ),
                  ('Biến động', scenario.volatility.toStringAsFixed(2)),
                  ('Thời lượng', '${scenario.durationMonths} tháng'),
                ]),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
            _esvSection(
              title: 'Danh mục hiện tại',
              rows: [
                for (final position in snapshot.portfolio)
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
                          '${VitFormat.usd(position.amountUsd)} · APY ${position.currentApyPct.toStringAsFixed(2)}%',
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
