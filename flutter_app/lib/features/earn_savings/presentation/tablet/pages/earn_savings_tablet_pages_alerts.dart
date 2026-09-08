part of 'earn_savings_tablet_pages.dart';

/// SC-313: Thông báo tiết kiệm.
class SavingsNotificationsTabletPage extends ConsumerWidget {
  const SavingsNotificationsTabletPage({super.key});

  static const contentKey = Key('sc313_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsNotificationsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-313',
        semanticLabel: 'Thông báo tiết kiệm',
        title: 'Thông báo',
        subtitle: 'Lịch sử · Cài đặt',
        contentKey: SavingsNotificationsTabletPage.contentKey,
        child: _esvError(
          'Không tải được thông báo',
          () => ref.invalidate(savingsNotificationsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-313',
        semanticLabel: 'Thông báo tiết kiệm',
        title: snapshot.title,
        subtitle: '${snapshot.history.length} thông báo',
        contentKey: SavingsNotificationsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _esvSection(
              title: 'Lịch sử',
              rows: [
                for (final notification in snapshot.history.take(10))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${notification.title} · ${notification.time}',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: notification.read
                                ? AppColors.text2
                                : AppColors.text1,
                          ),
                        ),
                        Text(
                          notification.message,
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
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: snapshot.settingsTitle,
              rows: [
                for (final setting in snapshot.settings)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                setting.title,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                setting.description,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                  height: 1.3,
                                ),
                              ),
                            ],
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
          ],
        ),
      ),
    );
  }
}

/// SC-314: Khuyến nghị tiết kiệm.
class SavingsRecommendationsTabletPage extends ConsumerWidget {
  const SavingsRecommendationsTabletPage({super.key});

  static const contentKey = Key('sc314_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsRecommendationsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-314',
        semanticLabel: 'Khuyến nghị tiết kiệm',
        title: 'Khuyến nghị',
        subtitle: 'Theo hồ sơ',
        contentKey: SavingsRecommendationsTabletPage.contentKey,
        child: _esvError(
          'Không tải được khuyến nghị',
          () => ref.invalidate(savingsRecommendationsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-314',
        semanticLabel: 'Khuyến nghị tiết kiệm',
        title: snapshot.heroTitle,
        subtitle: snapshot.heroSubtitle,
        contentKey: SavingsRecommendationsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _esvSection(
              title: 'Hồ sơ của bạn',
              rows: _esvRows([
                ('Thái độ rủi ro', snapshot.profile.riskTolerance.name),
                ('Khung thời gian', snapshot.profile.investmentHorizon.name),
                ('Nhu cầu thanh khoản', snapshot.profile.liquidityNeed.name),
                (
                  'Vốn khả dụng',
                  VitFormat.usd(snapshot.profile.totalAvailable),
                ),
                (
                  'Tài sản ưa thích',
                  snapshot.profile.preferredAssets.join(' · '),
                ),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            for (final strategy in snapshot.strategies) ...[
              _esvSection(
                title: strategy.title,
                rows: [
                  _esvBody(strategy.subtitle),
                  _esvBody(strategy.description),
                  ..._esvRows([
                    ('Điểm khớp', '${strategy.matchScore}/100'),
                    (
                      'APY kỳ vọng',
                      VitFormat.percent(
                        strategy.expectedApy,
                        fractionDigits: 2,
                      ),
                    ),
                    ('Mức rủi ro', strategy.riskLevel.name),
                    ('Thanh khoản', '${strategy.liquidityRatio}%'),
                  ]),
                ],
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
            _esvSection(
              title: 'Miễn trừ',
              rows: [_esvBody(snapshot.disclaimer)],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-315: Đánh giá mức độ rủi ro tiết kiệm.
class SavingsRiskAssessmentTabletPage extends ConsumerWidget {
  const SavingsRiskAssessmentTabletPage({super.key});

  static const contentKey = Key('sc315_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsRiskAssessmentSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-315',
        semanticLabel: 'Đánh giá rủi ro tiết kiệm',
        title: 'Đánh giá rủi ro',
        subtitle: 'Câu hỏi · Hồ sơ',
        contentKey: SavingsRiskAssessmentTabletPage.contentKey,
        child: _esvError(
          'Không tải được đánh giá rủi ro',
          () => ref.invalidate(savingsRiskAssessmentSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-315',
        semanticLabel: 'Đánh giá rủi ro tiết kiệm',
        title: snapshot.title,
        subtitle: snapshot.resultTitle,
        contentKey: SavingsRiskAssessmentTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final question in snapshot.questions) ...[
              _esvSection(
                title: question.question,
                rows: _esvBullets([
                  for (final option in question.options) option.label,
                ]),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
            _esvSection(
              title: 'Lưu ý',
              rows: [
                _esvBody(snapshot.infoText),
                _esvBody(snapshot.footerDisclaimer),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-316: So sánh sản phẩm tiết kiệm.
class SavingsComparisonTabletPage extends ConsumerWidget {
  const SavingsComparisonTabletPage({super.key});

  static const contentKey = Key('sc316_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(savingsComparisonSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-316',
        semanticLabel: 'So sánh sản phẩm tiết kiệm',
        title: 'So sánh sản phẩm',
        subtitle: 'APY · Điều khoản',
        contentKey: SavingsComparisonTabletPage.contentKey,
        child: _esvError(
          'Không tải được so sánh',
          () => ref.invalidate(savingsComparisonSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-316',
        semanticLabel: 'So sánh sản phẩm tiết kiệm',
        title: snapshot.title,
        subtitle: '${snapshot.products.length} sản phẩm',
        contentKey: SavingsComparisonTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final product in snapshot.products) ...[
              _esvSection(
                title: '${product.name} (${product.asset})',
                rows: _esvRows([
                  ('APY', product.apy),
                  (
                    'Kỳ hạn khoá',
                    product.lockDays != null
                        ? '${product.lockDays} ngày'
                        : 'Linh hoạt',
                  ),
                  ('Đã tham gia', product.totalSubscribed),
                  ('Hạn mức còn', product.remainingQuota),
                  (
                    'Tiến độ',
                    VitFormat.percent(product.progress, fractionDigits: 0),
                  ),
                ]),
              ),
              const SizedBox(height: TabletSpacingTokens.x3),
            ],
            _esvSection(
              title: 'Miễn trừ',
              rows: [_esvBody(snapshot.disclaimer)],
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-317: Cài đặt gộp lãi tiết kiệm.
class AutoCompoundSettingsTabletPage extends ConsumerWidget {
  const AutoCompoundSettingsTabletPage({super.key});

  static const contentKey = Key('sc317_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(autoCompoundSettingsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-317',
        semanticLabel: 'Cài đặt gộp lãi tiết kiệm',
        title: 'Gộp lãi',
        subtitle: 'Vị thế · Tần suất',
        contentKey: AutoCompoundSettingsTabletPage.contentKey,
        child: _esvError(
          'Không tải được gộp lãi',
          () => ref.invalidate(autoCompoundSettingsSnapshotProvider),
        ),
      ),
      data: (snapshot) => _esvFrame(
        context: context,
        semanticIdentifier: 'SC-317',
        semanticLabel: 'Cài đặt gộp lãi tiết kiệm',
        title: snapshot.title,
        subtitle: '${snapshot.positions.length} vị thế',
        contentKey: AutoCompoundSettingsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${position.product} (${position.asset})',
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                ),
                              ),
                              Text(
                                'Gộp ${position.autoCompound ? 'bật' : 'tắt'} · ${position.compoundFrequency}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${VitFormat.usd(position.amount)} · APY ${position.apy.toStringAsFixed(2)}%',
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
            _esvSection(
              title: 'Tần suất gộp',
              rows: [
                for (final frequency in snapshot.frequencies)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${frequency.label} — ${frequency.description}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _esvSection(
              title: 'Lưu ý',
              rows: [
                for (final info in snapshot.infoItems)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info.title,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                          ),
                        ),
                        Text(
                          info.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                _esvBody(snapshot.note),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
