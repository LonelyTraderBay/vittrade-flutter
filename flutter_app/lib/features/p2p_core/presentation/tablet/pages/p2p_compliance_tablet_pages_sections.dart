part of 'p2p_compliance_tablet_pages.dart';

class P2PAmlScreeningTabletPage extends ConsumerWidget {
  const P2PAmlScreeningTabletPage({super.key});

  static const contentKey = Key('sc268_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pAmlScreeningProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _cmpFrame(
        context: context,
        semanticIdentifier: 'SC-268',
        semanticLabel: 'Sàng lọc AML P2P',
        title: 'AML Screening',
        subtitle: 'Kiểm tra · Trạng thái',
        contentKey: P2PAmlScreeningTabletPage.contentKey,
        child: _cmpError(
          'Không tải được AML screening',
          () => ref.invalidate(p2pAmlScreeningProvider),
        ),
      ),
      data: (snapshot) => _cmpFrame(
        context: context,
        semanticIdentifier: 'SC-268',
        semanticLabel: 'Sàng lọc AML P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PAmlScreeningTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cmpSection(
              title: 'Trạng thái',
              rows: [
                ..._cmpRows([
                  (snapshot.statusLabel, ''),
                  (snapshot.lastCheckLabel, snapshot.lastCheckAt),
                  (snapshot.nextCheckLabel, snapshot.nextCheckAt),
                ]),
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Text(
                    snapshot.statusDescription,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _cmpSection(
              title: 'Các bước kiểm tra',
              rows: [
                for (final check in snapshot.checks)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            check.name,
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: AppTextStyles.bold,
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            check.status,
                            style: AppTextStyles.caption.copyWith(
                              color: check.status.contains('Đạt')
                                  ? AppColors.buy
                                  : AppColors.caution,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _cmpSection(
              title: snapshot.infoTitle,
              rows: [
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
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

/// SC-269: Nguồn tiền.
class P2PSourceOfFundsTabletPage extends ConsumerStatefulWidget {
  const P2PSourceOfFundsTabletPage({super.key});

  static const contentKey = Key('sc269_tablet_content');

  @override
  ConsumerState<P2PSourceOfFundsTabletPage> createState() =>
      _P2PSourceOfFundsTabletPageState();
}

class _P2PSourceOfFundsTabletPageState
    extends ConsumerState<P2PSourceOfFundsTabletPage> {
  final TextEditingController _detailController = TextEditingController();

  @override
  void dispose() {
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pSourceOfFundsProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _cmpFrame(
        context: context,
        semanticIdentifier: 'SC-269',
        semanticLabel: 'Nguồn tiền P2P',
        title: 'Nguồn tiền',
        subtitle: 'Khai báo',
        contentKey: P2PSourceOfFundsTabletPage.contentKey,
        child: _cmpError(
          'Không tải được nguồn tiền',
          () => ref.invalidate(p2pSourceOfFundsProvider),
        ),
      ),
      data: (snapshot) => _cmpFrame(
        context: context,
        semanticIdentifier: 'SC-269',
        semanticLabel: 'Nguồn tiền P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PSourceOfFundsTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.heroTitle,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    snapshot.heroSubtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _cmpSection(
              title: snapshot.sourceTitle,
              rows: [
                Wrap(
                  spacing: TabletSpacingTokens.x3,
                  runSpacing: TabletSpacingTokens.x2,
                  children: [
                    for (final source in snapshot.sources)
                      VitFilterChip(
                        label: source.label,
                        onTap: () {},
                        active: false,
                        color: AppColors.primary,
                      ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                VitInput(
                  controller: _detailController,
                  semanticLabel: 'Chi tiết nguồn tiền',
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại khai báo',
              message:
                  'Khai báo nguồn tiền sai có thể khiến giao dịch bị đình chỉ và tài khoản bị xem xét lại.',
              contractId: 'p2p-source-of-funds-tablet',
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              onPressed: () => context.go(snapshot.successRoute),
              child: Text(snapshot.ctaLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-270: Giải trình giao dịch lớn.
class P2PLargeTransactionJustificationTabletPage
    extends ConsumerStatefulWidget {
  const P2PLargeTransactionJustificationTabletPage({
    super.key,
    this.amount = 200000000,
  });

  static const contentKey = Key('sc270_tablet_content');

  final double amount;

  @override
  ConsumerState<P2PLargeTransactionJustificationTabletPage> createState() =>
      _P2PLargeTransactionJustificationTabletPageState();
}

class _P2PLargeTransactionJustificationTabletPageState
    extends ConsumerState<P2PLargeTransactionJustificationTabletPage> {
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  @override
  void dispose() {
    _purposeController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      p2pLargeTransactionJustificationProvider(widget.amount),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _cmpFrame(
        context: context,
        semanticIdentifier: 'SC-270',
        semanticLabel: 'Giải trình giao dịch lớn P2P',
        title: 'Giải trình giao dịch lớn',
        subtitle: 'Khai báo mục đích',
        contentKey: P2PLargeTransactionJustificationTabletPage.contentKey,
        child: _cmpError(
          'Không tải được giải trình',
          () => ref.invalidate(
            p2pLargeTransactionJustificationProvider(widget.amount),
          ),
        ),
      ),
      data: (snapshot) => _cmpFrame(
        context: context,
        semanticIdentifier: 'SC-270',
        semanticLabel: 'Giải trình giao dịch lớn P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PLargeTransactionJustificationTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.heroTitle,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    '${snapshot.heroSubtitle} · ${formatP2PVnd(snapshot.amount)}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _cmpSection(
              title: snapshot.purposeTitle,
              rows: [
                Wrap(
                  spacing: TabletSpacingTokens.x3,
                  runSpacing: TabletSpacingTokens.x2,
                  children: [
                    for (final purpose in snapshot.purposes)
                      VitFilterChip(
                        label: purpose,
                        onTap: () {},
                        active: false,
                        color: AppColors.primary,
                      ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                VitInput(
                  controller: _purposeController,
                  semanticLabel: 'Mục đích khác',
                  hintText: snapshot.customPurposePlaceholder,
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                VitInput(
                  controller: _detailsController,
                  semanticLabel: 'Chi tiết',
                  hintText: snapshot.detailsPlaceholder,
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xem lại giải trình',
              message:
                  'Giao dịch lớn yêu cầu giải trình theo quy định. Thông tin sai có thể khiến lệnh bị đóng băng.',
              contractId: 'p2p-large-tx-tablet',
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              onPressed: () => context.go(snapshot.successRoute),
              child: Text(snapshot.ctaLabel),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-271: Đánh giá rủi ro cá nhân.
class P2PRiskAssessmentTabletPage extends ConsumerWidget {
  const P2PRiskAssessmentTabletPage({super.key});

  static const contentKey = Key('sc271_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pRiskAssessmentProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _cmpFrame(
        context: context,
        semanticIdentifier: 'SC-271',
        semanticLabel: 'Đánh giá rủi ro P2P',
        title: 'Đánh giá rủi ro',
        subtitle: 'Điểm · Yếu tố',
        contentKey: P2PRiskAssessmentTabletPage.contentKey,
        child: _cmpError(
          'Không tải được đánh giá rủi ro',
          () => ref.invalidate(p2pRiskAssessmentProvider),
        ),
      ),
      data: (snapshot) => _cmpFrame(
        context: context,
        semanticIdentifier: 'SC-271',
        semanticLabel: 'Đánh giá rủi ro P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PRiskAssessmentTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          '${snapshot.overallRisk} · ${snapshot.score} điểm',
                          style: AppTextStyles.control.copyWith(
                            fontWeight: AppTextStyles.bold,
                            color: AppColors.text1,
                            fontFeatures: AppTextStyles.tabularFigures,
                          ),
                        ),
                      ),
                      VitStatusPill(
                        label: snapshot.scoreLabel,
                        status: snapshot.score >= 70
                            ? VitStatusPillStatus.success
                            : snapshot.score >= 40
                            ? VitStatusPillStatus.warning
                            : VitStatusPillStatus.error,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    snapshot.scoreSubtitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _cmpSection(
              title: snapshot.factorTitle,
              rows: [
                for (final factor in snapshot.factors)
                  Padding(
                    padding: TabletSpacingTokens.tableCellPaddingV,
                    child: Row(
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
                          factor.value,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                        const SizedBox(width: TabletSpacingTokens.x2),
                        SizedBox(
                          width: TabletSpacingTokens.x7,
                          child: Text(
                            factor.risk,
                            textAlign: TextAlign.end,
                            style: AppTextStyles.caption.copyWith(
                              color: factor.risk.contains('Thấp')
                                  ? AppColors.buy
                                  : factor.risk.contains('Cao')
                                  ? AppColors.sell
                                  : AppColors.caution,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _cmpSection(
              title: 'Thông tin',
              rows: [
                Text(
                  snapshot.infoText,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
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
