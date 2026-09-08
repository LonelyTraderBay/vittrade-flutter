part of 'compliance_tablet_pages.dart';

/// SC-104: Bồi thường nhà đầu tư.
class InvestorCompensationTabletPage extends ConsumerWidget {
  const InvestorCompensationTabletPage({super.key});

  static const contentKey = Key('sc104_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeInvestorCompensationProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _cmp2Frame(
        context: context,
        semanticIdentifier: 'SC-104',
        semanticLabel: 'Bồi thường nhà đầu tư',
        title: 'Bồi thường nhà đầu tư',
        subtitle: 'Giới hạn · Điều kiện',
        contentKey: InvestorCompensationTabletPage.contentKey,
        child: _cmp2Error(
          'Không tải được bồi thường',
          () => ref.invalidate(tradeInvestorCompensationProvider),
        ),
      ),
      data: (snapshot) => _cmp2Frame(
        context: context,
        semanticIdentifier: 'SC-104',
        semanticLabel: 'Bồi thường nhà đầu tư',
        title: 'Bồi thường nhà đầu tư',
        subtitle: 'Chương trình bảo vệ',
        contentKey: InvestorCompensationTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ..._cmp2Bullets(
              [snapshot.coverageLimit],
              Icons.verified_user_outlined,
              AppColors.buy,
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
          ],
        ),
      ),
    );
  }
}

/// SC-098: Giám sát trượt giá.
class SlippageMonitoringTabletPage extends ConsumerWidget {
  const SlippageMonitoringTabletPage({super.key});

  static const contentKey = Key('sc098_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeSlippageMonitoringProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _cmp2Frame(
        context: context,
        semanticIdentifier: 'SC-098',
        semanticLabel: 'Giám sát trượt giá',
        title: 'Giám sát trượt giá',
        subtitle: 'Sự kiện · Provider',
        contentKey: SlippageMonitoringTabletPage.contentKey,
        child: _cmp2Error(
          'Không tải được giám sát trượt giá',
          () => ref.invalidate(tradeSlippageMonitoringProvider),
        ),
      ),
      data: (snapshot) => _cmp2Frame(
        context: context,
        semanticIdentifier: 'SC-098',
        semanticLabel: 'Giám sát trượt giá',
        title: 'Giám sát trượt giá',
        subtitle: 'Thực thi · Sự kiện',
        contentKey: SlippageMonitoringTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cmp2Section(
              title: 'Sự kiện trượt giá',
              rows: [
                for (final event in snapshot.events.take(10))
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            event.instrument,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            event.slippageBps.toStringAsFixed(0),
                            textAlign: TextAlign.end,
                            style: AppTextStyles.caption.copyWith(
                              color: event.slippageBps >= 0
                                  ? AppColors.sell
                                  : AppColors.buy,
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
      ),
    );
  }
}

/// SC-111: Xử lý khiếu nại.
class ComplaintsHandlingTabletPage extends ConsumerWidget {
  const ComplaintsHandlingTabletPage({super.key});

  static const contentKey = Key('sc111_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeComplaintsHandlingProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _cmp2Frame(
        context: context,
        semanticIdentifier: 'SC-111',
        semanticLabel: 'Xử lý khiếu nại',
        title: 'Xử lý khiếu nại',
        subtitle: 'Quy trình · Thời hạn',
        contentKey: ComplaintsHandlingTabletPage.contentKey,
        child: _cmp2Error(
          'Không tải được xử lý khiếu nại',
          () => ref.invalidate(tradeComplaintsHandlingProvider),
        ),
      ),
      data: (snapshot) => _cmp2Frame(
        context: context,
        semanticIdentifier: 'SC-111',
        semanticLabel: 'Xử lý khiếu nại',
        title: 'Xử lý khiếu nại',
        subtitle: 'Quy trình · Thời hạn',
        contentKey: ComplaintsHandlingTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đang xử lý',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        Text(
                          '${snapshot.activeCount}',
                          style: AppTextStyles.control.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.caution,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đã giải quyết',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        Text(
                          '${snapshot.resolvedCount}',
                          style: AppTextStyles.control.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.buy,
                            fontFeatures: AppTextStyles.tabularFigures,
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
      ),
    );
  }
}

/// SC-112: Gửi khiếu nại.
class ComplaintSubmissionTabletPage extends ConsumerWidget {
  const ComplaintSubmissionTabletPage({super.key});

  static const contentKey = Key('sc112_tablet_content');
  static const submitKey = Key('sc112_tablet_submit');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeComplaintSubmissionProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _cmp2Frame(
        context: context,
        semanticIdentifier: 'SC-112',
        semanticLabel: 'Gửi khiếu nại',
        title: 'Gửi khiếu nại',
        subtitle: 'Biểu mẫu',
        contentKey: ComplaintSubmissionTabletPage.contentKey,
        child: _cmp2Error(
          'Không tải được biểu mẫu',
          () => ref.invalidate(tradeComplaintSubmissionProvider),
        ),
      ),
      data: (snapshot) => _cmp2Frame(
        context: context,
        semanticIdentifier: 'SC-112',
        semanticLabel: 'Gửi khiếu nại',
        title: 'Gửi khiếu nại',
        subtitle: 'Biểu mẫu chính thức',
        contentKey: ComplaintSubmissionTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Gửi khiếu nại chính thức',
              message:
                  'Khiếu nại sẽ được ghi nhận và xử lý theo SLA. Cung cấp thông tin chính xác để rút ngắn thời gian xử lý.',
              contractId: 'complaint-submission-tablet',
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              key: ComplaintSubmissionTabletPage.submitKey,
              onPressed: () => context.go(AppRoutePaths.trade),
              child: const Text('Gửi khiếu nại'),
            ),
          ],
        ),
      ),
    );
  }
}
