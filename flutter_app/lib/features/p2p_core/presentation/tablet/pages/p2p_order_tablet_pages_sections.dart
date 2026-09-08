part of 'p2p_order_tablet_pages.dart';

/// Đánh giá đối tác sau giao dịch (SC-213).
class P2POrderRateTabletPage extends ConsumerStatefulWidget {
  const P2POrderRateTabletPage({super.key, required this.orderId});

  static const contentKey = Key('sc213_tablet_content');
  static const submitKey = Key('sc213_tablet_submit');

  final String orderId;

  @override
  ConsumerState<P2POrderRateTabletPage> createState() =>
      _P2POrderRateTabletPageState();
}

class _P2POrderRateTabletPageState
    extends ConsumerState<P2POrderRateTabletPage> {
  final TextEditingController _commentController = TextEditingController();
  String? _selectedTag;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final snapshotAsync = ref.watch(p2pOrderRateProvider(widget.orderId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-213',
        semanticLabel: 'Đánh giá giao dịch P2P',
        title: 'Đánh giá',
        subtitle: widget.orderId,
        contractNotes: '',
        body: p2pErrorBody(
          title: 'Không tải được đánh giá',
          onRetry: () => ref.invalidate(p2pOrderRateProvider(widget.orderId)),
        ),
      ),
      data: (snapshot) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-213',
        semanticLabel: 'Đánh giá giao dịch P2P',
        title: 'Đánh giá ${snapshot.order.merchant}',
        subtitle:
            '${snapshot.order.typeLabel} · ${formatP2PVnd(snapshot.order.totalVnd)}',
        contractNotes: snapshot.contractNotes,
        bodyKey: P2POrderRateTabletPage.contentKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhãn nhanh',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x2),
                  Wrap(
                    spacing: TabletSpacingTokens.x3,
                    runSpacing: TabletSpacingTokens.x2,
                    children: [
                      for (final tag in snapshot.quickTags)
                        VitFilterChip(
                          label: tag.label,
                          onTap: () => setState(() => _selectedTag = tag.label),
                          active: tag.label == _selectedTag,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: TabletSpacingTokens.x3),
                  VitInput(
                    controller: _commentController,
                    semanticLabel: 'Nhận xét chi tiết',
                    hintText: 'Chia sẻ trải nghiệm giao dịch',
                  ),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              key: P2POrderRateTabletPage.submitKey,
              onPressed: () => context.go(AppRoutePaths.p2pMyOrders),
              child: const Text('Gửi đánh giá'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Hủy lệnh P2P (SC-214) — financial safety: lý do + cảnh báo + xác nhận.
class P2POrderCancelTabletPage extends ConsumerStatefulWidget {
  const P2POrderCancelTabletPage({super.key, required this.orderId});

  static const contentKey = Key('sc214_tablet_content');
  static const confirmKey = Key('sc214_tablet_confirm');

  final String orderId;

  @override
  ConsumerState<P2POrderCancelTabletPage> createState() =>
      _P2POrderCancelTabletPageState();
}

class _P2POrderCancelTabletPageState
    extends ConsumerState<P2POrderCancelTabletPage> {
  String? _selectedReason;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pOrderCancelProvider(widget.orderId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-214',
        semanticLabel: 'Hủy lệnh P2P',
        title: 'Hủy lệnh',
        subtitle: widget.orderId,
        contractNotes: '',
        body: p2pErrorBody(
          title: 'Không tải được lệnh',
          onRetry: () => ref.invalidate(p2pOrderCancelProvider(widget.orderId)),
        ),
      ),
      data: (snapshot) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-214',
        semanticLabel: 'Hủy lệnh P2P',
        title: 'Hủy lệnh ${snapshot.order.orderNumber}',
        subtitle: '${snapshot.order.typeLabel} · ${snapshot.order.asset}',
        contractNotes: snapshot.contractNotes,
        bodyKey: P2POrderCancelTabletPage.contentKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (label, value) in [
                    ('Số lượng', formatP2PCrypto(snapshot.order.amount)),
                    ('Tổng', formatP2PVnd(snapshot.order.totalVnd)),
                    ('Merchant', snapshot.order.merchant),
                    ('Escrow giữ', formatP2PVnd(snapshot.order.escrowAmount)),
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
                          Text(
                            value,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.warningTitle,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.sell,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    snapshot.warningMessage,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lý do hủy',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x2),
                  Wrap(
                    spacing: TabletSpacingTokens.x3,
                    runSpacing: TabletSpacingTokens.x2,
                    children: [
                      for (final reason in snapshot.reasons)
                        VitFilterChip(
                          label: reason,
                          onTap: () => setState(() => _selectedReason = reason),
                          active: reason == _selectedReason,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              key: P2POrderCancelTabletPage.confirmKey,
              variant: VitCtaButtonVariant.danger,
              onPressed: () => context.go(AppRoutePaths.p2pMyOrders),
              child: const Text('Xác nhận hủy lệnh'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bằng chứng thanh toán (SC-215).
class P2POrderProofTabletPage extends ConsumerWidget {
  const P2POrderProofTabletPage({super.key, required this.orderId});

  static const contentKey = Key('sc215_tablet_content');
  static const uploadKey = Key('sc215_tablet_upload');

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pOrderProofProvider(orderId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-215',
        semanticLabel: 'Bằng chứng thanh toán P2P',
        title: 'Bằng chứng thanh toán',
        subtitle: orderId,
        contractNotes: '',
        body: p2pErrorBody(
          title: 'Không tải được bằng chứng',
          onRetry: () => ref.invalidate(p2pOrderProofProvider(orderId)),
        ),
      ),
      data: (snapshot) => p2pOrderPageFrame(
        context: context,
        semanticIdentifier: 'SC-215',
        semanticLabel: 'Bằng chứng thanh toán P2P',
        title: snapshot.uploadTitle,
        subtitle:
            '${snapshot.order.orderNumber} · ${formatP2PVnd(snapshot.order.totalVnd)}',
        contractNotes: snapshot.contractNotes,
        bodyKey: P2POrderProofTabletPage.contentKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              snapshot.uploadSubtitle,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.3,
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            const VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: SizedBox(
                height: TabletSpacingTokens.x7 * 3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file_outlined,
                        size: TabletSpacingTokens.x7,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: TabletSpacingTokens.x2),
                      VitCtaButton(
                        key: P2POrderProofTabletPage.uploadKey,
                        fullWidth: false,
                        variant: VitCtaButtonVariant.secondary,
                        onPressed: null,
                        child: Text('Tải lên bằng chứng'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.tipsTitle,
                    style: AppTextStyles.control.copyWith(
                      fontWeight: AppTextStyles.bold,
                      color: AppColors.text1,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x2),
                  for (final tip in snapshot.tips)
                    Padding(
                      padding: TabletSpacingTokens.tableCellPaddingV,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.lightbulb_outline_rounded,
                              size: TabletSpacingTokens.iconSm,
                              color: AppColors.caution,
                            ),
                          ),
                          const SizedBox(width: TabletSpacingTokens.x2),
                          Expanded(
                            child: Text(
                              tip,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                height: 1.3,
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
              density: VitDensity.tool,
              title: 'Xác nhận sau khi tải lên',
              message:
                  'Bằng chứng chỉ xác nhận khi escrow ghi nhận. Kiểm tra kỹ số tài khoản và nội dung chuyển khoản trước khi gửi.',
              contractId: 'p2p-order-proof-tablet',
            ),
          ],
        ),
      ),
    );
  }
}
