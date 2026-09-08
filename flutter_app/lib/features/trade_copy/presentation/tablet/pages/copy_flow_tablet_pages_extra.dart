part of 'copy_flow_tablet_pages.dart';

/// SC-072: Cấu hình sao chép.
class CopyConfigurationTabletPage extends ConsumerWidget {
  const CopyConfigurationTabletPage({super.key, required this.providerId});

  static const contentKey = Key('sc072_tablet_content');

  final String providerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeCopyConfigurationProvider(providerId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _flowFrame(
        context: context,
        semanticIdentifier: 'SC-072',
        semanticLabel: 'Cấu hình sao chép',
        title: 'Cấu hình sao chép',
        subtitle: providerId,
        providerId: providerId,
        contentKey: CopyConfigurationTabletPage.contentKey,
        child: _flowError(
          'Không tải được cấu hình',
          () => ref.invalidate(tradeCopyConfigurationProvider(providerId)),
        ),
      ),
      data: (snapshot) => _flowFrame(
        context: context,
        semanticIdentifier: 'SC-072',
        semanticLabel: 'Cấu hình sao chép',
        title: 'Cấu hình sao chép',
        subtitle: 'Số vốn · Phí · Xác nhận',
        providerId: providerId,
        contentKey: CopyConfigurationTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _cfgSection(
              title: 'Số vốn khả dụng',
              rows: _cfgRows([
                ('Tổng danh mục', formatTradeUsdWhole(snapshot.totalPortfolio)),
                (
                  'Đã phân bổ',
                  formatTradeUsdWhole(snapshot.currentCopyAllocation),
                ),
                ('Khả dụng', formatTradeUsdWhole(snapshot.availableCapital)),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            _cfgSection(
              title: 'Xem trước phí',
              rows: _cfgRows([
                (
                  'Phí nền tảng',
                  formatTradeUsdWhole(snapshot.feePreview.platformFee),
                ),
                (
                  'Phí giao dịch ước tính',
                  formatTradeUsdWhole(snapshot.feePreview.estimatedTradingFees),
                ),
                (
                  'Ghi chú phí hiệu suất',
                  snapshot.feePreview.performanceFeeNote,
                ),
              ]),
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              onPressed: () => context.go(
                AppRoutePaths.tradeCopyProviderConfirmation(providerId),
              ),
              child: const Text('Xem trước & xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _cfgSection({required String title, required List<Widget> rows}) {
  return VitCard(
    radius: VitCardRadius.tight,
    padding: TabletSpacingTokens.cardPaddingCompact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.control.copyWith(
            fontWeight: AppTextStyles.bold,
            color: AppColors.text1,
          ),
        ),
        const SizedBox(height: TabletSpacingTokens.x2),
        ...rows,
      ],
    ),
  );
}

List<Widget> _cfgRows(List<(String, String)> pairs) {
  return [
    for (final (label, value) in pairs)
      Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
          ],
        ),
      ),
  ];
}

/// SC-073: Xác nhận sao chép — consents + cooling-off (high-risk).
class CopyConfirmationTabletPage extends ConsumerWidget {
  const CopyConfirmationTabletPage({super.key, required this.providerId});

  static const contentKey = Key('sc073_tablet_content');
  static const confirmKey = Key('sc073_tablet_confirm');

  final String providerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      tradeCopyConfirmationSnapshotProvider(providerId),
    );

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _flowFrame(
        context: context,
        semanticIdentifier: 'SC-073',
        semanticLabel: 'Xác nhận sao chép',
        title: 'Xác nhận sao chép',
        subtitle: providerId,
        providerId: providerId,
        contentKey: CopyConfirmationTabletPage.contentKey,
        child: _flowError(
          'Không tải được xác nhận',
          () =>
              ref.invalidate(tradeCopyConfirmationSnapshotProvider(providerId)),
        ),
      ),
      data: (snapshot) => _flowFrame(
        context: context,
        semanticIdentifier: 'SC-073',
        semanticLabel: 'Xác nhận sao chép',
        title: 'Xác nhận sao chép',
        subtitle: 'Consent · Cooling-off ${snapshot.coolingOffHours}h',
        providerId: providerId,
        contentKey: CopyConfirmationTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._cfgRows([
                    (
                      'Vốn',
                      formatTradeUsdWhole(snapshot.configuration.copyCapital),
                    ),
                    ('Chế độ', snapshot.configuration.copyMode.name),
                    (
                      'Phí nền tảng',
                      formatTradeUsdWhole(snapshot.feePreview.platformFee),
                    ),
                    (
                      'Phí giao dịch ước tính',
                      formatTradeUsdWhole(
                        snapshot.feePreview.estimatedTradingFees,
                      ),
                    ),
                    (
                      'Tổn thất tối đa ước tính',
                      formatTradeUsdWhole(snapshot.maxLossAmount),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x3),
            for (final consent in snapshot.consentItems)
              Padding(
                padding: const EdgeInsets.only(bottom: TabletSpacingTokens.x3),
                child: VitCard(
                  radius: VitCardRadius.tight,
                  padding: TabletSpacingTokens.cardPaddingCompact,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.zero,
                        child: Icon(
                          Icons.fact_check_outlined,
                          size: TabletSpacingTokens.iconMd,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: TabletSpacingTokens.x3),
                      Expanded(
                        child: Text(
                          '${consent.label}${consent.required ? ' (bắt buộc)' : ''}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: TabletSpacingTokens.x1),
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Xác nhận trước khi sao chép',
              message:
                  'Bạn chấp nhận các điều khoản sao chép. Sau khi gửi, bản sao vào thời gian cooling-off và có thể bị mất vốn.',
              contractId: 'p2p-copy-confirmation-tablet',
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            VitCtaButton(
              key: CopyConfirmationTabletPage.confirmKey,
              variant: VitCtaButtonVariant.danger,
              onPressed: () => context.go(AppRoutePaths.tradeCopyActive),
              child: const Text('Xác nhận sao chép'),
            ),
          ],
        ),
      ),
    );
  }
}

/// SC-074: Hiệu suất bản sao.
class CopyPerformanceTabletPage extends ConsumerWidget {
  const CopyPerformanceTabletPage({super.key, required this.copyId});

  static const contentKey = Key('sc074_tablet_content');

  final String copyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(tradeCopyPerformanceProvider(copyId));

    return snapshotAsync.when(
      loading: () => const Center(child: VitSkeletonList(rows: 6)),
      error: (error, stackTrace) => _flowFrame(
        context: context,
        semanticIdentifier: 'SC-074',
        semanticLabel: 'Hiệu suất bản sao',
        title: 'Hiệu suất bản sao',
        subtitle: copyId,
        providerId: copyId,
        contentKey: CopyPerformanceTabletPage.contentKey,
        child: _flowError(
          'Không tải được hiệu suất',
          () => ref.invalidate(tradeCopyPerformanceProvider(copyId)),
        ),
      ),
      data: (snapshot) => _flowFrame(
        context: context,
        semanticIdentifier: 'SC-074',
        semanticLabel: 'Hiệu suất bản sao',
        title: 'Hiệu suất bản sao',
        subtitle: 'So sánh bạn vs provider',
        providerId: copyId,
        contentKey: CopyPerformanceTabletPage.contentKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitCard(
              radius: VitCardRadius.tight,
              padding: TabletSpacingTokens.cardPaddingCompact,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._cfgRows([
                    (
                      'Vốn ban đầu',
                      formatTradeUsdWhole(snapshot.initialCapital),
                    ),
                    (
                      'Giá trị hiện tại',
                      formatTradeUsdWhole(snapshot.yourCurrentValue),
                    ),
                    (
                      'Lợi nhuận của bạn',
                      '${snapshot.yourReturnPct >= 0 ? '+' : ''}${snapshot.yourReturnPct.toStringAsFixed(1)}%',
                    ),
                    (
                      'Lợi nhuận provider',
                      '${snapshot.providerReturnPct >= 0 ? '+' : ''}${snapshot.providerReturnPct.toStringAsFixed(1)}%',
                    ),
                    (
                      'Chênh lệch hiệu suất',
                      '${snapshot.performanceGapPct.toStringAsFixed(1)}%',
                    ),
                    ('Tổng chi phí', formatTradeUsdWhole(snapshot.totalCosts)),
                    (
                      'Trượt giá TB',
                      '${snapshot.avgSlippagePct.toStringAsFixed(2)}% (provider ${snapshot.providerAvgSlippagePct.toStringAsFixed(2)}%)',
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
