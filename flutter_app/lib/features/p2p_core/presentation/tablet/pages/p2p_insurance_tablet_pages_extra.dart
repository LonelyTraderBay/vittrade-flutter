part of 'p2p_insurance_tablet_pages.dart';

/// SC-240: Điểm bảo hiểm.
class P2PInsuranceScoreTabletPage extends ConsumerWidget {
  const P2PInsuranceScoreTabletPage({super.key});

  static const contentKey = Key('sc240_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pInsuranceScoreProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Điểm bảo hiểm P2P',
      semanticIdentifier: 'SC-240',
      child: Column(
        children: [
          VitHeader(
            title: 'Điểm bảo hiểm',
            subtitle: snapshotAsync.value?.gradeLabel ?? 'Đánh giá',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pInsurance,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: _insError(
                  'Không tải được điểm bảo hiểm',
                  () => ref.invalidate(p2pInsuranceScoreProvider),
                ),
              ),
              data: (snapshot) => VitTabletSectionBody(
                contentKey: P2PInsuranceScoreTabletPage.contentKey,
                children: [
                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${snapshot.overallScore}/${snapshot.maxScore} · Hạng ${snapshot.grade}',
                                style: AppTextStyles.control.copyWith(
                                  fontWeight: AppTextStyles.bold,
                                  color: AppColors.text1,
                                  fontFeatures: AppTextStyles.tabularFigures,
                                ),
                              ),
                            ),
                            VitStatusPill(
                              label: snapshot.gradeLabel,
                              status: VitStatusPillStatus.info,
                              size: VitStatusPillSize.sm,
                            ),
                          ],
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        VitProgressBar(
                          progress: snapshot.overallScore / snapshot.maxScore,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: TabletSpacingTokens.x2),
                        Text(
                          snapshot.gradeDescription,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _insSection(
                    title: 'Các yếu tố điểm',
                    rows: [
                      for (final factor in snapshot.factors)
                        Padding(
                          padding: TabletSpacingTokens.tableCellPaddingV,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      factor.label,
                                      style: AppTextStyles.caption.copyWith(
                                        fontWeight: AppTextStyles.bold,
                                        color: AppColors.text1,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${factor.score}/${factor.maxScore} · ${factor.statusLabel}',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.text2,
                                      fontFeatures:
                                          AppTextStyles.tabularFigures,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                factor.description,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  _insSection(
                    title: 'Yêu cầu hạng',
                    rows: [
                      for (final tier in snapshot.tierRequirements)
                        Padding(
                          padding: TabletSpacingTokens.tableCellPaddingV,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${tier.name} · cần ${tier.requiredScore} điểm',
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: tier.isCurrent
                                        ? AppTextStyles.bold
                                        : AppTextStyles.normal,
                                    color: tier.isCurrent
                                        ? AppColors.primary
                                        : AppColors.text2,
                                  ),
                                ),
                              ),
                              Text(
                                '${tier.coveragePct} bao phủ',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  Text(
                    snapshot.disclosure,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// SC-241: Chính sách bảo hiểm.
class P2PInsurancePolicyTabletPage extends ConsumerWidget {
  const P2PInsurancePolicyTabletPage({super.key});

  static const contentKey = Key('sc241_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pInsurancePolicyProvider);
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chính sách bảo hiểm P2P',
      semanticIdentifier: 'SC-241',
      child: Column(
        children: [
          VitHeader(
            title: snapshotAsync.value?.title ?? 'Chính sách bảo hiểm',
            subtitle: 'Điều khoản · Phiên bản',
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pInsurance,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: _insError(
                  'Không tải được chính sách',
                  () => ref.invalidate(p2pInsurancePolicyProvider),
                ),
              ),
              data: (snapshot) => VitTabletSectionBody(
                contentKey: P2PInsurancePolicyTabletPage.contentKey,
                children: [
                  Text(
                    '${snapshot.subtitle} · v${snapshot.version} · cập nhật ${snapshot.lastUpdated}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),

                  VitCard(
                    radius: VitCardRadius.tight,
                    padding: TabletSpacingTokens.cardPaddingCompact,
                    child: Text(
                      snapshot.notice,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.3,
                      ),
                    ),
                  ),

                  for (final section in snapshot.sections) ...[
                    _insSection(
                      title: section.title,
                      rows: [
                        for (final paragraph in section.content)
                          Padding(
                            padding: TabletSpacingTokens.tableCellPaddingV,
                            child: Text(
                              paragraph,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: TabletSpacingTokens.x3),
                  ],

                  Text(
                    snapshot.privacyNotice,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// SC-243: Chi tiết claim bảo hiểm.
class P2PClaimDetailTabletPage extends ConsumerWidget {
  const P2PClaimDetailTabletPage({super.key, required this.claimId});

  static const contentKey = Key('sc243_tablet_content');

  final String claimId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pClaimDetailProvider(claimId));
    final showBack = context.canPop();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết claim bảo hiểm P2P',
      semanticIdentifier: 'SC-243',
      child: Column(
        children: [
          VitHeader(
            title: 'Chi tiết claim',
            subtitle: claimId,
            showBack: showBack,
            onBack: showBack
                ? () => goBackOrFallback(
                    context,
                    fallbackPath: AppRoutePaths.p2pInsurance,
                    mode: BackNavigationMode.historyThenFallback,
                  )
                : null,
          ),
          Expanded(
            child: snapshotAsync.when(
              loading: () => const Center(child: VitSkeletonList(rows: 6)),
              error: (error, stackTrace) => SingleChildScrollView(
                child: _insError(
                  'Không tải được chi tiết claim',
                  () => ref.invalidate(p2pClaimDetailProvider(claimId)),
                ),
              ),
              data: (snapshot) => VitTabletSectionBody(
                contentKey: P2PClaimDetailTabletPage.contentKey,
                children: [
                  _insSection(
                    title:
                        'Claim ${snapshot.claim.claimCode} · ${snapshot.claim.orderNumber}',
                    rows: _insRows([
                      ('Lý do', snapshot.claim.reason),
                      ('Mô tả', snapshot.claim.description),
                      ('Số tiền', formatP2PVnd(snapshot.claim.amount)),
                      (
                        'Đã chi trả',
                        snapshot.claim.paidAmount == null
                            ? '—'
                            : formatP2PVnd(snapshot.claim.paidAmount!),
                      ),
                    ]),
                  ),

                  _insSection(
                    title: 'Tham chiếu',
                    rows: [
                      for (final benchmark in snapshot.benchmarks)
                        Padding(
                          padding: TabletSpacingTokens.tableCellPaddingV,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  benchmark.title,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text2,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  benchmark.value,
                                  textAlign: TextAlign.end,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.text1,
                                    fontWeight: AppTextStyles.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  _insSection(
                    title: 'Phân bổ lý do',
                    rows: [
                      for (final share in snapshot.reasonShares)
                        Padding(
                          padding: TabletSpacingTokens.tableCellPaddingV,
                          child: VitProgressBar(
                            progress: share.percent / 100,
                            label: share.label,
                            trailingLabel: '${share.percent}%',
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: TabletSpacingTokens.x4),

                  VitCtaButton(
                    onPressed: () => context.push(snapshot.orderRoute),
                    child: const Text('Xem lệnh gốc'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
