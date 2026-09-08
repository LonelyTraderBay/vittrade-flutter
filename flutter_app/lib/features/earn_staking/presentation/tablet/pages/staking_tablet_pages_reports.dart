part of 'staking_tablet_pages.dart';

/// SC-281: Hướng dẫn staking.
class StakingGuideTabletPage extends ConsumerWidget {
  const StakingGuideTabletPage({super.key});

  static const contentKey = Key('sc281_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingGuideSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-281',
        semanticLabel: 'Hướng dẫn staking',
        title: snapshotAsync.value?.heroTitle ?? 'Hướng dẫn staking',
        subtitle: 'Bài học · Lỗi thường gặp',
        contentKey: StakingGuideTabletPage.contentKey,
        child: _stkError(
          'Không tải được hướng dẫn',
          () => ref.invalidate(stakingGuideSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-281',
        semanticLabel: 'Hướng dẫn staking',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroBody,
        contentKey: StakingGuideTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final tutorial in snapshot.tutorials) ...[
              _stkSection(
                title: '${tutorial.title} (${tutorial.duration})',
                rows: _stkBullets([
                  for (final step in tutorial.steps) step.title,
                ]),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
            _stkSection(
              title: 'Lỗi thường gặp',
              rows: _stkTitleBody([
                for (final mistake in snapshot.mistakes)
                  (mistake.title, mistake.correction),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-282: Hỏi đáp staking.
class StakingFaqTabletPage extends ConsumerWidget {
  const StakingFaqTabletPage({super.key});

  static const contentKey = Key('sc282_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingFAQSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-282',
        semanticLabel: 'Hỏi đáp staking',
        title: 'Hỏi đáp staking',
        subtitle: 'Câu hỏi thường gặp',
        contentKey: StakingFaqTabletPage.contentKey,
        child: _stkError(
          'Không tải được hỏi đáp',
          () => ref.invalidate(stakingFAQSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-282',
        semanticLabel: 'Hỏi đáp staking',
        title: snapshot.title,
        subtitle: '${snapshot.items.length} câu hỏi',
        contentKey: StakingFaqTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Câu hỏi',
              rows: _stkTitleBody([
                for (final item in snapshot.items.take(12))
                  (item.question, item.answer),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _stkSection(
              title: snapshot.supportTitle,
              rows: [_stkBody(snapshot.supportBody)],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-283: Thông báo staking.
class StakingNotificationsTabletPage extends ConsumerWidget {
  const StakingNotificationsTabletPage({super.key});

  static const contentKey = Key('sc283_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingNotificationsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-283',
        semanticLabel: 'Thông báo staking',
        title: snapshotAsync.value?.title ?? 'Thông báo',
        subtitle: 'Cài đặt · Lịch sử',
        contentKey: StakingNotificationsTabletPage.contentKey,
        child: _stkError(
          'Không tải được thông báo',
          () => ref.invalidate(stakingNotificationsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-283',
        semanticLabel: 'Thông báo staking',
        title: snapshot.title,
        subtitle: snapshot.infoTitle,
        contentKey: StakingNotificationsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Cài đặt',
              rows: [
                for (final setting in snapshot.settings)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            setting.title,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          setting.enabled ? 'Bật' : 'Tắt',
                          style: AppTextStyles.caption.copyWith(
                            color: setting.enabled
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
              title: 'Kênh nhận',
              rows: _stkRows([
                for (final channel in snapshot.channels)
                  (channel.label, channel.enabled ? 'Bật' : 'Tắt'),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-284: Khuyến nghị staking.
class StakingRecommendationsTabletPage extends ConsumerWidget {
  const StakingRecommendationsTabletPage({super.key});

  static const contentKey = Key('sc284_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingRecommendationsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-284',
        semanticLabel: 'Khuyến nghị staking',
        title: snapshotAsync.value?.heroTitle ?? 'Khuyến nghị',
        subtitle: 'Theo hồ sơ',
        contentKey: StakingRecommendationsTabletPage.contentKey,
        child: _stkError(
          'Không tải được khuyến nghị',
          () => ref.invalidate(stakingRecommendationsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-284',
        semanticLabel: 'Khuyến nghị staking',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroSubtitle,
        contentKey: StakingRecommendationsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Hồ sơ',
              rows: _stkRows([
                ('Thái độ rủi ro', snapshot.profile.riskTolerance.name),
                ('Khung thời gian', snapshot.profile.investmentHorizon.name),
                ('Thanh khoản', snapshot.profile.liquidityNeed.name),
                ('Danh mục', _stkUsd(snapshot.profile.totalPortfolio)),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            for (final strategy in snapshot.strategies) ...[
              _stkSection(
                title: strategy.title,
                rows: [
                  _stkBody(strategy.description),
                  ..._stkRows([
                    ('APY kỳ vọng', _stkPct(strategy.expectedApy)),
                    ('Mức rủi ro', strategy.riskLevel.name),
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

/// SC-285: Khung pháp lý staking.
class StakingRegulatoryFrameworkTabletPage extends ConsumerWidget {
  const StakingRegulatoryFrameworkTabletPage({super.key});

  static const contentKey = Key('sc285_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingRegulatoryFrameworkSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-285',
        semanticLabel: 'Khung pháp lý staking',
        title: snapshotAsync.value?.heroTitle ?? 'Khung pháp lý',
        subtitle: 'Giấy phép · Bảo vệ',
        contentKey: StakingRegulatoryFrameworkTabletPage.contentKey,
        child: _stkError(
          'Không tải được khung pháp lý',
          () => ref.invalidate(stakingRegulatoryFrameworkSnapshotProvider),
        ),
      ),
      data: (snapshot) => _stkFrame(
        context: context,
        semanticIdentifier: 'SC-285',
        semanticLabel: 'Khung pháp lý staking',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroBody,
        contentKey: StakingRegulatoryFrameworkTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _stkSection(
              title: 'Giấy phép',
              rows: [
                for (final license in snapshot.licenses)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${license.jurisdiction} — ${license.regulator}',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                '${license.licenseNumber} · ${license.issuedDate}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          license.status.name,
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
            _stkSection(
              title: 'Chế độ bảo vệ',
              rows: _stkTitleBody([
                for (final scheme in snapshot.protectionSchemes)
                  (
                    '${scheme.jurisdiction} — ${scheme.scheme}',
                    scheme.coverage,
                  ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
