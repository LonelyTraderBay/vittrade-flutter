part of 'p2p_payment_method_tablet_pages.dart';

/// SC-234: Xác minh quyền sở hữu tài khoản.
class P2PPaymentMethodOwnershipTabletPage extends ConsumerWidget {
  const P2PPaymentMethodOwnershipTabletPage({
    super.key,
    required this.methodId,
  });

  static const contentKey = Key('sc234_tablet_content');

  final String methodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      p2pPaymentMethodOwnershipProvider(methodId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-234',
        semanticLabel: 'Xác minh sở hữu phương thức P2P',
        title: 'Xác minh sở hữu',
        subtitle: methodId,
        contentKey: P2PPaymentMethodOwnershipTabletPage.contentKey,
        children: [
          _paymentError(
            'Không tải được xác minh sở hữu',
            () => ref.invalidate(p2pPaymentMethodOwnershipProvider(methodId)),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-234',
        semanticLabel: 'Xác minh sở hữu phương thức P2P',
        title: 'Xác minh quyền sở hữu',
        subtitle: 'Hồ sơ chứng minh chủ tài khoản',
        contentKey: P2PPaymentMethodOwnershipTabletPage.contentKey,
        children: [
          _sectionCard(
            title: 'Hồ sơ cần tải lên',
            rows: [
              for (final doc in snapshot.documents)
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          doc.label,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      VitStatusPill(
                        label: doc.optional ? 'Tùy chọn' : 'Bắt buộc',
                        status: doc.optional
                            ? VitStatusPillStatus.neutral
                            : VitStatusPillStatus.warning,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Xem lại hồ sơ sở hữu',
            message:
                'Hồ sơ chỉ dùng cho xác minh sở hữu tài khoản và được lưu trữ an toàn.',
            contractId: 'p2p-payment-ownership-tablet',
          ),

          const SizedBox(height: TabletSpacingTokens.x4),

          VitCtaButton(
            onPressed: () => context.push(snapshot.saveRoute),
            child: const Text('Gửi hồ sơ'),
          ),
        ],
      ),
    );
  }
}

/// SC-235: Thời gian chờ phương thức mới.
class P2PPaymentMethodCoolingPeriodTabletPage extends ConsumerWidget {
  const P2PPaymentMethodCoolingPeriodTabletPage({super.key});

  static const contentKey = Key('sc235_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pPaymentMethodCoolingPeriodProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-235',
        semanticLabel: 'Thời gian chờ phương thức P2P',
        title: 'Thời gian chờ',
        subtitle: 'Bảo vệ giao dịch',
        contentKey: P2PPaymentMethodCoolingPeriodTabletPage.contentKey,
        children: [
          _paymentError(
            'Không tải được thời gian chờ',
            () => ref.invalidate(p2pPaymentMethodCoolingPeriodProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-235',
        semanticLabel: 'Thời gian chờ phương thức P2P',
        title: snapshot.waitTitle,
        subtitle: 'Bảo vệ lệnh P2P',
        contentKey: P2PPaymentMethodCoolingPeriodTabletPage.contentKey,
        children: [
          VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (label, value) in [
                  ('Thêm lúc', snapshot.addedAt),
                  ('Dùng được từ', snapshot.availableAt),
                  ('Còn lại', '${snapshot.hoursRemaining} giờ'),
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
                const SizedBox(height: TabletSpacingTokens.x2),
                VitProgressBar(
                  progress: (24 - snapshot.hoursRemaining).clamp(0, 24) / 24,
                  label: 'Tiến độ chờ',
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          _sectionCard(
            title: 'Vì sao phải chờ?',
            rows: [
              ..._bulletList(
                snapshot.reasons,
                Icons.info_outline_rounded,
                AppColors.primary,
              ),
            ],
          ),

          VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Text(
              snapshot.waitMessage,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// SC-236: Lịch sử giao dịch theo phương thức.
class P2PPaymentMethodHistoryTabletPage extends ConsumerWidget {
  const P2PPaymentMethodHistoryTabletPage({super.key});

  static const contentKey = Key('sc236_tablet_content');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pPaymentMethodHistoryProvider);

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-236',
        semanticLabel: 'Lịch sử phương thức P2P',
        title: 'Lịch sử phương thức',
        subtitle: 'Thống kê · Giao dịch',
        contentKey: P2PPaymentMethodHistoryTabletPage.contentKey,
        children: [
          _paymentError(
            'Không tải được lịch sử',
            () => ref.invalidate(p2pPaymentMethodHistoryProvider),
          ),
        ],
      ),
      data: (snapshot) => VitTabletSectionFrame(
        semanticIdentifier: 'SC-236',
        semanticLabel: 'Lịch sử phương thức P2P',
        title: 'Lịch sử phương thức',
        subtitle: '${snapshot.totalTransactions} giao dịch',
        contentKey: P2PPaymentMethodHistoryTabletPage.contentKey,
        children: [
          VitCard(
            radius: VitCardRadius.tight,
            padding: TabletSpacingTokens.cardPaddingCompact,
            child: Row(
              children: [
                Expanded(
                  child: _HistoryStat(
                    label: 'Tổng giao dịch',
                    value: '${snapshot.totalTransactions}',
                  ),
                ),
                Expanded(
                  child: _HistoryStat(
                    label: 'Tổng khối lượng',
                    value: formatP2PVnd(snapshot.totalVolume),
                  ),
                ),
                Expanded(
                  child: _HistoryStat(
                    label: 'Tỷ lệ thành công',
                    value: '${snapshot.successRate.toStringAsFixed(1)}%',
                    color: AppColors.buy,
                  ),
                ),
              ],
            ),
          ),

          if (snapshot.transactions.isEmpty)
            VitEmptyState(
              icon: Icons.receipt_long_outlined,
              title: snapshot.emptyTitle,
              message: 'Chưa có giao dịch nào qua phương thức này.',
            )
          else
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.zeroInsets,
              clip: true,
              child: Column(
                children: [
                  for (var i = 0; i < snapshot.transactions.length; i++) ...[
                    Padding(
                      padding: TabletSpacingTokens.tableCellPadding,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${snapshot.transactions[i].type == P2PTradeType.buy ? 'MUA' : 'BÁN'} · ${snapshot.transactions[i].orderId}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              formatP2PVnd(snapshot.transactions[i].amount),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: VitStatusPill(
                              label: snapshot.transactions[i].status,
                              status: VitStatusPillStatus.neutral,
                              size: VitStatusPillSize.sm,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              snapshot.transactions[i].timestamp,
                              textAlign: TextAlign.end,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                                fontFeatures: AppTextStyles.tabularFigures,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < snapshot.transactions.length - 1)
                      const Divider(
                        height: TabletSpacingTokens.dividerHairline,
                        thickness: TabletSpacingTokens.dividerHairline,
                        color: AppColors.divider,
                      ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryStat extends StatelessWidget {
  const _HistoryStat({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        Text(
          value,
          style: AppTextStyles.control.copyWith(
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              color: AppColors.text1,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x2),
          child,
        ],
      ),
    );
  }
}
