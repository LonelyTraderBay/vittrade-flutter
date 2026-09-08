part of 'predictions_tablet_pages.dart';

/// SC-220: Sentiment cộng đồng prediction.
class PredictionSocialTabletPage extends ConsumerWidget {
  const PredictionSocialTabletPage({super.key});

  static const contentKey = Key('sc220_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(predictionsSocialSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-220',
        semanticLabel: 'Cộng đồng prediction',
        title: 'Cộng đồng',
        subtitle: snapshotAsync.value?.eventTitle ?? 'Sentiment',
        contentKey: PredictionSocialTabletPage.contentKey,
        child: _pdmError(
          'Không tải được cộng đồng',
          () => ref.invalidate(predictionsSocialSnapshotProvider),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-220',
        semanticLabel: 'Cộng đồng prediction',
        title: snapshot.eventTitle,
        subtitle: '${snapshot.comments.length} bình luận',
        contentKey: PredictionSocialTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Sentiment',
              rows: _pdmRows([
                for (final sentiment in snapshot.sentiment)
                  (sentiment.name, '${sentiment.value}%'),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _pdmSection(
              title: 'Bình luận',
              rows: [
                for (final comment in snapshot.comments.take(10))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${comment.userName} · ${comment.createdAtLabel}',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          comment.content,
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

/// SC-221: Biểu đồ nâng cao prediction.
class PredictionAdvancedChartTabletPage extends ConsumerWidget {
  const PredictionAdvancedChartTabletPage({super.key, required this.eventId});

  static const contentKey = Key('sc221_tablet_content');

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      predictionsAdvancedChartSnapshotProvider(eventId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-221',
        semanticLabel: 'Biểu đồ prediction',
        title: 'Biểu đồ nâng cao',
        subtitle: eventId,
        contentKey: PredictionAdvancedChartTabletPage.contentKey,
        child: _pdmError(
          'Không tải được biểu đồ',
          () =>
              ref.invalidate(predictionsAdvancedChartSnapshotProvider(eventId)),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-221',
        semanticLabel: 'Biểu đồ prediction',
        title: 'Biểu đồ nâng cao',
        subtitle: 'Cập nhật ${snapshot.lastUpdatedLabel}',
        contentKey: PredictionAdvancedChartTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Giá gần đây',
              rows: _pdmRows([
                for (final point in snapshot.priceHistory.take(8))
                  (point.time, _pdmDec(point.price)),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkLikeSignals(snapshot.indicators),
          ],
        ),
      ),
    );
  }

  Widget _stkLikeSignals(List<PredictionIndicatorSignalDraft> indicators) {
    return _pdmSection(
      title: 'Tín hiệu chỉ báo',
      rows: [
        for (final indicator in indicators)
          Padding(
            padding: TabletSpacingTokens.tableCellPaddingV,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    indicator.name,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
                Text(
                  '${indicator.signal} (${indicator.strength})',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                    color: AppColors.text2,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// SC-222: Giải đấu prediction.
class PredictionTournamentsTabletPage extends ConsumerWidget {
  const PredictionTournamentsTabletPage({super.key});

  static const contentKey = Key('sc222_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(predictionsTournamentsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-222',
        semanticLabel: 'Giải đấu prediction',
        title: 'Giải đấu',
        subtitle: 'Cập nhật ${snapshotAsync.value?.lastUpdatedLabel ?? '-'}',
        contentKey: PredictionTournamentsTabletPage.contentKey,
        child: _pdmError(
          'Không tải được giải đấu',
          () => ref.invalidate(predictionsTournamentsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-222',
        semanticLabel: 'Giải đấu prediction',
        title: 'Giải đấu',
        subtitle: '${snapshot.tournaments.length} giải',
        contentKey: PredictionTournamentsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final tournament in snapshot.tournaments) ...[
              _pdmSection(
                title: tournament.name,
                rows: _pdmRows([
                  ('Mô tả', tournament.description),
                  ('Giá thưởng', '\$${tournament.prizePool}'),
                  (
                    'Tham gia',
                    '${tournament.participants}/${tournament.maxParticipants}',
                  ),
                  ('Phí vào', '\$${tournament.entryFee}'),
                  ('Trạng thái', tournament.status.name),
                ]),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
          ],
        ),
      ),
    );
  }
}

/// SC-223: Chi tiết giải đấu prediction.
class PredictionTournamentDetailTabletPage extends ConsumerWidget {
  const PredictionTournamentDetailTabletPage({super.key, this.tournamentId});

  static const contentKey = Key('sc223_tablet_content');

  final String? tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(predictionsTournamentsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-223',
        semanticLabel: 'Chi tiết giải đấu',
        title: 'Chi tiết giải đấu',
        subtitle: tournamentId ?? '-',
        contentKey: PredictionTournamentDetailTabletPage.contentKey,
        child: _pdmError(
          'Không tải được giải đấu',
          () => ref.invalidate(predictionsTournamentsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-223',
        semanticLabel: 'Chi tiết giải đấu',
        title: 'Bảng xếp hạng giải',
        subtitle: '${snapshot.leaderboard.length} người',
        contentKey: PredictionTournamentDetailTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Xếp hạng',
              rows: [
                for (final entry in snapshot.leaderboard.take(10))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        SizedBox(
                          width: TabletSpacingTokens.x5,
                          child: Text(
                            '#${entry.rank}',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.name,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          'Điểm ${entry.score} · thưởng \$${entry.prize}',
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

/// SC-224: Tích hợp dữ liệu prediction.
class PredictionDataIntegrationTabletPage extends ConsumerWidget {
  const PredictionDataIntegrationTabletPage({super.key});

  static const contentKey = Key('sc224_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(predictionsDataIntegrationSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-224',
        semanticLabel: 'Tích hợp dữ liệu prediction',
        title: 'Tích hợp dữ liệu',
        subtitle: 'Nguồn · Khoá · Webhook',
        contentKey: PredictionDataIntegrationTabletPage.contentKey,
        child: _pdmError(
          'Không tải được tích hợp',
          () => ref.invalidate(predictionsDataIntegrationSnapshotProvider),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-224',
        semanticLabel: 'Tích hợp dữ liệu prediction',
        title: 'Tích hợp dữ liệu',
        subtitle: '${snapshot.sources.length} nguồn',
        contentKey: PredictionDataIntegrationTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pdmSection(
              title: 'Nguồn dữ liệu',
              rows: [
                for (final source in snapshot.sources)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${source.name} (${source.provider})',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${source.category} · đồng bộ ${source.lastSyncLabel} · tin cậy ${_pdmPct(source.reliability)}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          source.status.name,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _pdmSection(
              title: 'Khoá API',
              rows: [
                for (final apiKey in snapshot.apiKeys)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${apiKey.name} · ${apiKey.createdAtLabel}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          apiKey.status.name,
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

/// SC-225: Biên lai lệnh prediction.
class PredictionOrderReceiptTabletPage extends ConsumerWidget {
  const PredictionOrderReceiptTabletPage({super.key, required this.receiptId});

  static const contentKey = Key('sc225_tablet_content');

  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      predictionsOrderReceiptSnapshotProvider(receiptId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-225',
        semanticLabel: 'Biên lai lệnh prediction',
        title: 'Biên lai lệnh',
        subtitle: receiptId,
        contentKey: PredictionOrderReceiptTabletPage.contentKey,
        child: _pdmError(
          'Không tải được biên lai',
          () => ref.invalidate(
            predictionsOrderReceiptSnapshotProvider(receiptId),
          ),
        ),
      ),
      data: (snapshot) => _pdmFrame(
        context: context,
        semanticIdentifier: 'SC-225',
        semanticLabel: 'Biên lai lệnh prediction',
        title: 'Biên lai lệnh',
        subtitle: snapshot.receiptId,
        contentKey: PredictionOrderReceiptTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (snapshot.receipt != null)
              _pdmSection(
                title: 'Chi tiết',
                rows: _pdmRows([
                  ('Sự kiện', snapshot.receipt!.eventTitle),
                  ('Kết quả', snapshot.receipt!.outcome),
                  ('Giá', _pdmDec(snapshot.receipt!.price)),
                  ('Số lượng', _pdmDec(snapshot.receipt!.shares, 1)),
                  ('Tổng', _pdmUsd(snapshot.receipt!.total)),
                  ('Loại lệnh', snapshot.receipt!.orderType),
                  ('Thời điểm', snapshot.receipt!.createdAt),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
