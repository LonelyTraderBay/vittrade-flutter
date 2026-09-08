part of 'p2p_dispute_tablet_pages.dart';

/// SC-219: Gửi bổ sung minh chứng cho tranh chấp.
class P2PDisputeEvidenceTabletPage extends ConsumerWidget {
  const P2PDisputeEvidenceTabletPage({super.key, required this.disputeId});

  static const contentKey = Key('sc219_tablet_content');

  final String disputeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pDisputeEvidenceProvider(disputeId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pDisputePageFrame(
        context: context,
        semanticIdentifier: 'SC-219',
        semanticLabel: 'Minh chứng tranh chấp P2P',
        title: 'Minh chứng',
        subtitle: disputeId,
        contentKey: P2PDisputeEvidenceTabletPage.contentKey,
        child: _disputeError(
          'Không tải được minh chứng',
          () => ref.invalidate(p2pDisputeEvidenceProvider(disputeId)),
        ),
      ),
      data: (snapshot) => p2pDisputePageFrame(
        context: context,
        semanticIdentifier: 'SC-219',
        semanticLabel: 'Minh chứng tranh chấp P2P',
        title: 'Minh chứng tranh chấp',
        subtitle: 'Bổ sung tài liệu · Ảnh chụp',
        contentKey: P2PDisputeEvidenceTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final doc in snapshot.documents)
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              doc.uploaded
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: TabletSpacingTokens.iconSm,
                              color: doc.uploaded
                                  ? AppColors.buy
                                  : AppColors.text3,
                            ),
                          ),
                          const SizedBox(width: TabletSpacingTokens.x2),
                          Expanded(
                            child: Text(
                              doc.label,
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
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _sectionCard(
              title: 'Tải lên bổ sung',
              rows: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Kéo thả ảnh chụp chuyển khoản, xác nhận ngân hàng hoặc chụp màn hình chat.',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                VitCtaButton(
                  fullWidth: false,
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: () {},
                  child: const Text('Chọn tệp'),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              onPressed: () =>
                  context.go(AppRoutePaths.p2pDisputeDetail(disputeId)),
              child: const Text('Gửi minh chứng'),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-220: Kết quả giải quyết tranh chấp.
class P2PDisputeResolutionTabletPage extends ConsumerWidget {
  const P2PDisputeResolutionTabletPage({super.key, required this.disputeId});

  static const contentKey = Key('sc220_tablet_content');

  final String disputeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pDisputeResolutionProvider(disputeId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pDisputePageFrame(
        context: context,
        semanticIdentifier: 'SC-220',
        semanticLabel: 'Giải quyết tranh chấp P2P',
        title: 'Kết quả giải quyết',
        subtitle: disputeId,
        contentKey: P2PDisputeResolutionTabletPage.contentKey,
        child: _disputeError(
          'Không tải được kết quả',
          () => ref.invalidate(p2pDisputeResolutionProvider(disputeId)),
        ),
      ),
      data: (snapshot) => p2pDisputePageFrame(
        context: context,
        semanticIdentifier: 'SC-220',
        semanticLabel: 'Giải quyết tranh chấp P2P',
        title: snapshot.resultTitle,
        subtitle: snapshot.disputeLabel,
        contentKey: P2PDisputeResolutionTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (label, value) in [
                    ('Số tiền hoàn', snapshot.refundAmountLabel),
                    ('Lý do', snapshot.reason),
                    ('Trọng tài', snapshot.mediator),
                    ('Thời gian chốt', snapshot.resolvedAt),
                    ('Hạn khiếu nại', snapshot.appealDeadline),
                  ])
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              value,
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
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Kết quả có hiệu lực',
              message:
                  'Số tiền hoàn về ví P2P sau khi chốt. Khiếu nại chỉ chấp nhận trước hạn ghi rõ.',
              contractId: 'p2p-dispute-resolution-tablet',
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              onPressed: () => context.go(AppRoutePaths.p2pDisputes),
              child: const Text('Về danh sách tranh chấp'),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-221: Mở tranh chấp cho một lệnh.
class P2PDisputeOpenTabletPage extends ConsumerStatefulWidget {
  const P2PDisputeOpenTabletPage({super.key, required this.orderId});

  static const contentKey = Key('sc221_tablet_content');

  final String orderId;

  @override
  ConsumerState<P2PDisputeOpenTabletPage> createState() =>
      _P2PDisputeOpenTabletPageState();
}

class _P2PDisputeOpenTabletPageState
    extends ConsumerState<P2PDisputeOpenTabletPage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pDisputeOpenProvider(widget.orderId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pDisputePageFrame(
        context: context,
        semanticIdentifier: 'SC-221',
        semanticLabel: 'Mở tranh chấp P2P',
        title: 'Mở tranh chấp',
        subtitle: widget.orderId,
        contentKey: P2PDisputeOpenTabletPage.contentKey,
        child: _disputeError(
          'Không tải được biểu mẫu tranh chấp',
          () => ref.invalidate(p2pDisputeOpenProvider(widget.orderId)),
        ),
      ),
      data: (snapshot) => p2pDisputePageFrame(
        context: context,
        semanticIdentifier: 'SC-221',
        semanticLabel: 'Mở tranh chấp P2P',
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        contentKey: P2PDisputeOpenTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sectionCard(
              title: 'Lý do mở tranh chấp',
              rows: [
                Wrap(
                  spacing: TabletSpacingTokens.x3,
                  runSpacing: TabletSpacingTokens.x2,
                  children: [
                    for (final reason in snapshot.reasons)
                      VitFilterChip(
                        label: reason,
                        onTap: () {},
                        active: false,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _sectionCard(
              title: snapshot.descriptionLabel,
              rows: [
                VitInput(
                  controller: _descriptionController,
                  semanticLabel: 'Mô tả tranh chấp',
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _sectionCard(
              title: snapshot.uploadTitle,
              rows: [
                Text(
                  snapshot.uploadSubtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x2),
                VitCtaButton(
                  fullWidth: false,
                  variant: VitCtaButtonVariant.secondary,
                  onPressed: () {},
                  child: const Text('Chọn tệp'),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              variant: VitCtaButtonVariant.danger,
              onPressed: () => context.go(AppRoutePaths.p2pDisputes),
              child: const Text('Gửi tranh chấp'),
            ),
          ],
        ),
      ),
    );
  }
}
