part of 'predictions_tablet_pages.dart';

// ---------------------------------------------------------------------------
// SC-220: Cộng đồng prediction — sentiment + bình luận (ghim, phản hồi,
// bình chọn) + đóng góp viên + chia sẻ, như phone SC-040.
// ---------------------------------------------------------------------------

class PredictionSocialTabletPage extends ConsumerWidget {
  const PredictionSocialTabletPage({super.key});

  static const contentKey = Key('sc220_tablet_content');
  static const shareKey = Key('sc220_share');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socialAsync = ref.watch(predictionsSocialSnapshotProvider);

    return socialAsync.when(
      loading: () => _frame(children: const [VitSkeletonList(rows: 6)]),
      error: (error, stackTrace) => _frame(
        children: [
          _pdmError(
            'Không tải được cộng đồng',
            () => ref.invalidate(predictionsSocialSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => _frame(
        subtitle: snapshot.eventTitle,
        children: [
          VitPageSection(
            label: 'Sentiment cộng đồng',
            accentColor: AppColors.primary,
            innerGap: TabletSpacingTokens.x4,
            children: [
              VitCard(
                density: VitDensity.compact,
                child: Column(
                  children: [
                    for (final item in snapshot.sentiment)
                      Padding(
                        padding: TabletSpacingTokens.tableCellPaddingV,
                        child: Row(
                          children: [
                            SizedBox(
                              width:
                                  TabletSpacingTokens.x7 -
                                  TabletSpacingTokens.x3,
                              child: Text(
                                item.name,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: AppRadii.badgeRadius,
                                child: SizedBox(
                                  height: TabletSpacingTokens.x3,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: item.value,
                                        child: ColoredBox(
                                          color: item.tone.resolve().withValues(
                                            alpha: .30,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 100,
                                        child: ColoredBox(
                                          color: AppColors.surface2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: TabletSpacingTokens.x5,
                              child: Text(
                                VitFormat.percent(
                                  item.value,
                                  fractionDigits: 0,
                                ),
                                textAlign: TextAlign.end,
                                style: AppTextStyles.caption.copyWith(
                                  color: item.tone.resolve(),
                                  fontWeight: AppTextStyles.bold,
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
          VitPageSection(
            label: 'Bình luận',
            accentColor: AppColors.accent,
            innerGap: TabletSpacingTokens.x4,
            children: [
              for (final comment in snapshot.comments)
                _Sc220CommentCard(comment: comment),
            ],
          ),
          VitPageSection(
            label: 'Đóng góp nổi bật',
            accentColor: AppColors.warn,
            innerGap: TabletSpacingTokens.x4,
            children: [
              VitCard(
                density: VitDensity.compact,
                child: Column(
                  children: [
                    for (final contributor in snapshot.contributors)
                      Padding(
                        padding: TabletSpacingTokens.tableCellPaddingV,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: TabletSpacingTokens.iconSm,
                              backgroundColor: AppColors.surface2,
                              child: Text(
                                contributor.name[0],
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: TabletSpacingTokens.x2),
                            Expanded(
                              child: Text(
                                contributor.name,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: TabletSpacingTokens.x1),
                            Text(
                              '${VitFormat.count(contributor.comments)} bình '
                              'luận · ${VitFormat.count(contributor.upvotes)} '
                              'bình chọn',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
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
          VitCtaButton(
            key: PredictionSocialTabletPage.shareKey,
            onPressed: () {
              unawaited(
                showVitNoticeSheet(
                  context: context,
                  title: 'Sắp ra mắt',
                  message: 'Chia sẻ phân tích sẽ sớm ra mắt.',
                ),
              );
            },
            variant: VitCtaButtonVariant.secondary,
            leading: const Icon(Icons.ios_share_rounded),
            child: const Text('Chia sẻ phân tích'),
          ),
        ],
      ),
    );
  }

  Widget _frame({required List<Widget> children, String? subtitle}) {
    return VitTabletSectionFrame(
      gutterFlush: true,
      semanticIdentifier: 'SC-220',
      semanticLabel: 'Cộng đồng prediction',
      title: 'Cộng đồng',
      subtitle: subtitle ?? 'Bình luận · Sentiment',
      contentKey: PredictionSocialTabletPage.contentKey,
      backFallback: AppRoutePaths.marketsPredictions,
      children: children,
    );
  }
}

class _Sc220CommentCard extends StatelessWidget {
  const _Sc220CommentCard({required this.comment});

  final PredictionSocialCommentDraft comment;

  @override
  Widget build(BuildContext context) {
    final stanceColor = switch (comment.stance) {
      PredictionSocialStance.bullish => AppColors.buy,
      PredictionSocialStance.bearish => AppColors.sell,
      PredictionSocialStance.neutral => AppColors.text3,
    };
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: TabletSpacingTokens.x2,
            runSpacing: TabletSpacingTokens.x1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                comment.userName,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              _pdmTinyBadge(
                label: switch (comment.stance) {
                  PredictionSocialStance.bullish => 'Lạc quan',
                  PredictionSocialStance.bearish => 'Bi quan',
                  PredictionSocialStance.neutral => 'Trung lập',
                },
                color: stanceColor,
                background: stanceColor.withValues(alpha: .12),
              ),
              Text(
                comment.createdAtLabel,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              if (comment.isPinned)
                const Icon(
                  Icons.push_pin_rounded,
                  color: AppColors.warn,
                  size: TabletSpacingTokens.iconSm,
                ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            comment.content,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Row(
            children: [
              const SizedBox.square(
                dimension: TabletSpacingTokens.iconSm,
                child: Icon(
                  Icons.thumb_up_alt_outlined,
                  color: AppColors.text3,
                  size: TabletSpacingTokens.iconSm,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x1),
              Text(
                VitFormat.count(comment.upvotes),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              const SizedBox.square(
                dimension: TabletSpacingTokens.iconSm,
                child: Icon(
                  Icons.thumb_down_alt_outlined,
                  color: AppColors.text3,
                  size: TabletSpacingTokens.iconSm,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x1),
              Text(
                VitFormat.count(comment.downvotes),
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              const SizedBox(height: TabletSpacingTokens.x1),
              Text(
                '${VitFormat.count(comment.replies.length)} phản hồi',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          for (final reply in comment.replies) ...[
            const SizedBox(height: TabletSpacingTokens.x3),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: TabletSpacingTokens.x4,
              ),
              child: _Sc220CommentCard(comment: reply),
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SC-224: Tích hợp dữ liệu prediction — nguồn dữ liệu + khóa API + webhook,
// như phone SC-043.
// ---------------------------------------------------------------------------

class PredictionDataIntegrationTabletPage extends ConsumerWidget {
  const PredictionDataIntegrationTabletPage({super.key});

  static const contentKey = Key('sc224_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final integrationAsync = ref.watch(
      predictionsDataIntegrationSnapshotProvider,
    );

    return integrationAsync.when(
      loading: () => _frame(children: const [VitSkeletonList(rows: 6)]),
      error: (error, stackTrace) => _frame(
        children: [
          _pdmError(
            'Không tải được tích hợp dữ liệu',
            () => ref.invalidate(predictionsDataIntegrationSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => _frame(
        subtitle: '${snapshot.sources.length} nguồn dữ liệu',
        children: [
          VitPageSection(
            label: 'Nguồn dữ liệu',
            accentColor: AppColors.primary,
            innerGap: TabletSpacingTokens.x4,
            children: [
              for (final source in snapshot.sources)
                VitCard(
                  density: VitDensity.compact,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              source.name,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: TabletSpacingTokens.x1),
                            Text(
                              '${source.provider} · ${source.category} · '
                              'đã chốt ${VitFormat.count(source.eventsResolved)} sự kiện',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _pdmTinyBadge(
                            label: switch (source.status) {
                              PredictionDataSourceStatus.active => 'Hoạt động',
                              PredictionDataSourceStatus.inactive => 'Tắt',
                              PredictionDataSourceStatus.error => 'Lỗi',
                            },
                            color: switch (source.status) {
                              PredictionDataSourceStatus.active =>
                                AppColors.buy,
                              PredictionDataSourceStatus.inactive =>
                                AppColors.text3,
                              PredictionDataSourceStatus.error =>
                                AppColors.sell,
                            },
                            background: switch (source.status) {
                              PredictionDataSourceStatus.active =>
                                AppColors.buy10,
                              PredictionDataSourceStatus.inactive =>
                                AppColors.surface2,
                              PredictionDataSourceStatus.error =>
                                AppColors.sell10,
                            },
                          ),
                          Text(
                            'Độ tin cậy '
                            '${VitFormat.percent(source.reliability, fractionDigits: 0)}',
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
          VitPageSection(
            label: 'Khóa API',
            accentColor: AppColors.accent,
            innerGap: TabletSpacingTokens.x4,
            children: [
              for (final apiKey in snapshot.apiKeys)
                VitCard(
                  density: VitDensity.compact,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              apiKey.name,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: TabletSpacingTokens.x1),
                            Text(
                              '${apiKey.key} · ${apiKey.permissions.join(', ')}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _pdmTinyBadge(
                        label: switch (apiKey.status) {
                          PredictionApiKeyStatus.active => 'Đang dùng',
                          PredictionApiKeyStatus.revoked => 'Đã thu hồi',
                        },
                        color: switch (apiKey.status) {
                          PredictionApiKeyStatus.active => AppColors.buy,
                          PredictionApiKeyStatus.revoked => AppColors.sell,
                        },
                        background: switch (apiKey.status) {
                          PredictionApiKeyStatus.active => AppColors.buy10,
                          PredictionApiKeyStatus.revoked => AppColors.sell10,
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
          VitPageSection(
            label: 'Webhook',
            accentColor: AppColors.warn,
            innerGap: TabletSpacingTokens.x4,
            children: [
              for (final webhook in snapshot.webhooks)
                VitCard(
                  density: VitDensity.compact,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              webhook.url,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: TabletSpacingTokens.x1),
                            Text(
                              webhook.events.join(', '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Thành công '
                        '${VitFormat.percent(webhook.successRate, fractionDigits: 1)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          _pdmBody('Cập nhật ${snapshot.lastUpdatedLabel}'),
        ],
      ),
    );
  }

  Widget _frame({required List<Widget> children, String? subtitle}) {
    return VitTabletSectionFrame(
      gutterFlush: true,
      semanticIdentifier: 'SC-224',
      semanticLabel: 'Tích hợp dữ liệu prediction',
      title: 'Tích hợp dữ liệu',
      subtitle: subtitle ?? 'Nguồn · API · Webhook',
      contentKey: PredictionDataIntegrationTabletPage.contentKey,
      backFallback: AppRoutePaths.marketsPredictions,
      children: children,
    );
  }
}
