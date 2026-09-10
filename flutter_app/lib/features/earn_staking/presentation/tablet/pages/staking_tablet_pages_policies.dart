part of 'staking_tablet_pages.dart';

/// SC-262: Điều khoản staking.
class StakingTermsTabletPage extends ConsumerWidget {
  const StakingTermsTabletPage({super.key});

  static const contentKey = Key('sc262_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingTermsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-262',
        semanticLabel: 'Điều khoản staking',
        title: snapshotAsync.value?.documentTitle ?? 'Điều khoản staking',
        subtitle: 'Phiên bản ${snapshotAsync.value?.version ?? '-'}',
        contentKey: StakingTermsTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được điều khoản',
            () => ref.invalidate(stakingTermsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-262',
        semanticLabel: 'Điều khoản staking',
        title: snapshot.documentTitle,
        subtitle: 'Phiên bản ${snapshot.version} · ${snapshot.lastUpdated}',
        contentKey: StakingTermsTabletPage.contentKey,
        children: [
          for (final section in snapshot.sections) ...[
            _stkSection(
              title: section.title,
              rows: _stkBullets(section.content),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],

          _stkSection(
            title: 'Xác nhận',
            rows: [_stkBody(snapshot.acceptanceText)],
          ),
        ],
      ),
    );
  }
}

/// SC-263: Công bố rủi ro staking.
class StakingRiskDisclosureTabletPage extends ConsumerWidget {
  const StakingRiskDisclosureTabletPage({super.key});

  static const contentKey = Key('sc263_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingRiskDisclosureSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-263',
        semanticLabel: 'Công bố rủi ro staking',
        title: snapshotAsync.value?.warningTitle ?? 'Công bố rủi ro',
        subtitle: 'Rủi ro · Chi tiết',
        contentKey: StakingRiskDisclosureTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được công bố rủi ro',
            () => ref.invalidate(stakingRiskDisclosureSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-263',
        semanticLabel: 'Công bố rủi ro staking',
        title: snapshot.warningTitle,
        subtitle: snapshot.warningBody,
        contentKey: StakingRiskDisclosureTabletPage.contentKey,
        children: [
          _stkSection(
            title: snapshot.summaryTitle,
            rows: [_stkBody(snapshot.summaryBody)],
          ),

          for (final category in snapshot.categories) ...[
            _stkSection(
              title: category.title,
              rows: [
                _stkBody(category.description),
                ..._stkBullets(category.details),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}

/// SC-264: Thuế staking.
class StakingTaxGuideTabletPage extends ConsumerWidget {
  const StakingTaxGuideTabletPage({super.key});

  static const contentKey = Key('sc264_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingTaxGuideSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-264',
        semanticLabel: 'Thuế staking',
        title: 'Cẩm nang thuế',
        subtitle: 'Sự kiện chịu thuế',
        contentKey: StakingTaxGuideTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được cẩm nang thuế',
            () => ref.invalidate(stakingTaxGuideSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-264',
        semanticLabel: 'Thuế staking',
        title: snapshot.disclaimerTitle,
        subtitle: snapshot.disclaimerBody,
        contentKey: StakingTaxGuideTabletPage.contentKey,
        children: [
          _stkSection(
            title: snapshot.overviewTitle,
            rows: [_stkBody(snapshot.overviewBody)],
          ),

          _stkSection(
            title: 'Sự kiện chịu thuế',
            rows: _stkTitleBody([
              for (final event in snapshot.incomeEvents)
                (event.title, event.description),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-265: Đánh giá rủi ro staking.
class StakingRiskAssessmentTabletPage extends ConsumerWidget {
  const StakingRiskAssessmentTabletPage({super.key});

  static const contentKey = Key('sc265_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingRiskAssessmentSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-265',
        semanticLabel: 'Đánh giá rủi ro staking',
        title: 'Đánh giá rủi ro',
        subtitle: 'Câu hỏi · Hồ sơ',
        contentKey: StakingRiskAssessmentTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được đánh giá rủi ro',
            () => ref.invalidate(stakingRiskAssessmentSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-265',
        semanticLabel: 'Đánh giá rủi ro staking',
        title: snapshot.title,
        subtitle: snapshot.resultTitle,
        contentKey: StakingRiskAssessmentTabletPage.contentKey,
        children: [
          for (final question in snapshot.questions) ...[
            _stkSection(
              title: question.question,
              rows: _stkBullets([
                for (final option in question.options) option.label,
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],

          _stkSection(
            title: 'Lưu ý',
            rows: [
              _stkBody(snapshot.infoText),
              _stkBody(snapshot.footerDisclaimer),
            ],
          ),
        ],
      ),
    );
  }
}

/// SC-266: Đánh giá phù hợp staking.
class StakingSuitabilityAssessmentTabletPage extends ConsumerWidget {
  const StakingSuitabilityAssessmentTabletPage({super.key});

  static const contentKey = Key('sc266_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      stakingSuitabilityAssessmentSnapshotProvider,
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-266',
        semanticLabel: 'Đánh giá phù hợp staking',
        title: snapshotAsync.value?.infoTitle ?? 'Đánh giá phù hợp',
        subtitle: 'Câu hỏi · Hồ sơ',
        contentKey: StakingSuitabilityAssessmentTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được đánh giá phù hợp',
            () => ref.invalidate(stakingSuitabilityAssessmentSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-266',
        semanticLabel: 'Đánh giá phù hợp staking',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingSuitabilityAssessmentTabletPage.contentKey,
        children: [
          for (final question in snapshot.questions) ...[
            _stkSection(
              title: question.question,
              rows: _stkBullets([
                for (final option in question.options) option.label,
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}

/// SC-267: Hành động khẩn cấp staking.
class StakingEmergencyActionsTabletPage extends ConsumerWidget {
  const StakingEmergencyActionsTabletPage({super.key});

  static const contentKey = Key('sc267_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingEmergencyActionsSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-267',
        semanticLabel: 'Hành động khẩn staking',
        title: snapshotAsync.value?.warningTitle ?? 'Hành động khẩn cấp',
        subtitle: 'Rủi ro cao',
        contentKey: StakingEmergencyActionsTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được hành động khẩn cấp',
            () => ref.invalidate(stakingEmergencyActionsSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-267',
        semanticLabel: 'Hành động khẩn staking',
        title: snapshot.warningTitle,
        subtitle: snapshot.warningBody,
        contentKey: StakingEmergencyActionsTabletPage.contentKey,
        children: [
          _stkSection(
            title: 'Hành động',
            rows: _stkTitleBody([
              for (final action in snapshot.actions)
                ('${action.title} (${action.impact})', action.body),
            ]),
          ),

          _stkSection(
            title: 'Tình huống sử dụng',
            rows: _stkTitleBody([
              for (final useCase in snapshot.useCases)
                ('${useCase.title} — ${useCase.severity}', useCase.description),
            ]),
          ),
        ],
      ),
    );
  }
}

/// SC-268: Kế hoạch dự phòng staking.
class StakingContingencyPlanTabletPage extends ConsumerWidget {
  const StakingContingencyPlanTabletPage({super.key});

  static const contentKey = Key('sc268_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingContingencyPlanSnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-268',
        semanticLabel: 'Kế hoạch dự phòng staking',
        title: 'Kế hoạch dự phòng',
        subtitle: 'Kịch bản · Ứng phó',
        contentKey: StakingContingencyPlanTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được kế hoạch dự phòng',
            () => ref.invalidate(stakingContingencyPlanSnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-268',
        semanticLabel: 'Kế hoạch dự phòng staking',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingContingencyPlanTabletPage.contentKey,
        children: [
          _stkSection(
            title: 'Chỉ số sẵn sàng',
            rows: _stkRows([
              for (final metric in snapshot.metrics)
                (metric.label, metric.value),
            ]),
          ),

          for (final scenario in snapshot.scenarios) ...[
            _stkSection(
              title: scenario.scenario,
              rows: [
                _stkBody(
                  'Khả năng: ${scenario.likelihood} · Tác động: ${scenario.impact}',
                ),
                ..._stkBullets(scenario.response),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ],
      ),
    );
  }
}

/// SC-268b: Chính sách rút vốn staking.
class StakingWithdrawalPolicyTabletPage extends ConsumerWidget {
  const StakingWithdrawalPolicyTabletPage({super.key});

  static const contentKey = Key('sc268w_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(stakingWithdrawalPolicySnapshotProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-268',
        semanticLabel: 'Chính sách rút staking',
        title: snapshotAsync.value?.infoTitle ?? 'Chính sách rút',
        subtitle: 'Quy trình · Thời gian',
        contentKey: StakingWithdrawalPolicyTabletPage.contentKey,
        children: [
          _stkError(
            'Không tải được chính sách rút',
            () => ref.invalidate(stakingWithdrawalPolicySnapshotProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-268',
        semanticLabel: 'Chính sách rút staking',
        title: snapshot.infoTitle,
        subtitle: snapshot.infoBody,
        contentKey: StakingWithdrawalPolicyTabletPage.contentKey,
        children: [
          _stkSection(
            title: snapshot.processTitle,
            rows: [
              for (final step in snapshot.processSteps)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      SizedBox(
                        width: TabletSpacingTokens.x5,
                        child: Text(
                          '${step.step}',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          step.title,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _stkSection(
            title: snapshot.timelineTitle,
            rows: [
              for (final timeline in snapshot.timelines)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          timeline.product,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          'Khởi tạo ${timeline.initiate} · nhận ${timeline.receive}',
                          textAlign: TextAlign.right,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          _stkSection(
            title: 'Ghi chú',
            rows: [_stkBody(snapshot.timelineNote)],
          ),
        ],
      ),
    );
  }
}
