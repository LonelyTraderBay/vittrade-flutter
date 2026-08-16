part of '../../phone/pages/event/prediction_order_receipt_page.dart';

class _MissingReceipt extends StatelessWidget {
  const _MissingReceipt({required this.scrollEndPadding});

  final double scrollEndPadding;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        key: PredictionOrderReceiptPage.missingReceiptKey,
        padding: PredictionsSpacingTokens.predictionReceiptScrollPadding(
          scrollEndPadding,
        ),
        child: const VitEmptyState(
          title: 'Không tìm thấy',
          message: 'Lệnh không tồn tại hoặc đã bị xoá',
          icon: Icons.warning_amber_rounded,
        ),
      ),
    );
  }
}

class _ReceiptContent extends StatelessWidget {
  const _ReceiptContent({
    required this.snapshot,
    required this.scrollEndPadding,
  });

  final PredictionOrderReceiptSnapshot snapshot;
  final double scrollEndPadding;

  @override
  Widget build(BuildContext context) {
    final receipt = snapshot.receipt!;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: SingleChildScrollView(
        key: PredictionOrderReceiptPage.contentKey,
        padding: PredictionsSpacingTokens.predictionReceiptScrollPadding(
          scrollEndPadding,
        ),
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          density: VitDensity.compact,
          children: [
            _ReceiptHero(receipt: receipt),
            _OrderSummary(receipt: receipt),
            if (snapshot.highRiskContractId != null)
              VitHighRiskStatePanel(
                state: VitHighRiskUiState.success,
                title: 'Trạng thái biên lai lệnh',
                message:
                    'Trạng thái gửi, chi tiết biên lai, lịch sử danh mục và khôi phục hỗ trợ được gắn với hợp đồng prediction dùng chung.',
                contractId: snapshot.highRiskContractId,
                density: VitDensity.compact,
              ),
            _TimelineCard(receipt: receipt),
            _TimestampCard(receipt: receipt),
            _ShareReceiptButton(receipt: receipt),
            const _DisclosureCard(),
            _ReceiptActions(receipt: receipt),
          ],
        ),
      ),
    );
  }
}

class _ReceiptHero extends StatelessWidget {
  const _ReceiptHero({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final isBuy = receipt.side == 'buy';
    final status = _receiptStatusConfig(receipt.status);

    return VitCard(
      density: VitDensity.compact,
      radius: VitCardRadius.large,
      child: Column(
        children: [
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            alignment: WrapAlignment.center,
            children: [
              VitAccentPill(
                label: isBuy ? '↑ Mua' : '↓ Bán',
                accentColor: isBuy ? AppColors.buy : AppColors.sell,
              ),
              VitStatusPill(
                label: status.label,
                status: status.pillStatus,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            receipt.outcome,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            receipt.eventTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final fillPct = receipt.shares <= 0
        ? 0
        : ((receipt.filledShares / receipt.shares) * 100).round();

    return VitPageSection(
      label: 'Tổng quan lệnh',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              _SummaryRow(
                label: 'Tổng giá trị',
                value: _formatMoney(receipt.total),
                mono: true,
              ),
              _SummaryRow(
                label: 'Phí (2%)',
                key: PredictionOrderReceiptPage.feeSummaryKey,
                value: _formatMoney(receipt.fee),
                mono: true,
              ),
              _SummaryRow(
                label: 'Loại lệnh',
                value: receipt.orderType == 'market'
                    ? 'Thị trường'
                    : 'Giới hạn',
              ),
              _SummaryRow(label: 'Kết quả', value: receipt.outcome),
              _SummaryRow(
                label: 'Cổ phần',
                value:
                    '${_formatShares(receipt.filledShares)}/${_formatShares(receipt.shares)}',
                mono: true,
              ),
              _SummaryRow(
                label: 'Giá đặt',
                value: _formatPrice(receipt.price),
                mono: true,
              ),
              if (receipt.avgPrice > 0)
                _SummaryRow(
                  label: 'Giá khớp TB',
                  value: _formatPrice(receipt.avgPrice),
                  mono: true,
                ),
              if (receipt.status != 'canceled' && receipt.status != 'rejected')
                _FillProgress(percent: fillPct),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final timeline = receipt.timeline.isEmpty
        ? [
            PredictionReceiptTimelineDraft(
              label: 'Lệnh đã gửi',
              date: receipt.createdAt,
              done: true,
            ),
          ]
        : receipt.timeline;

    return VitPageSection(
      label: 'Tiến trình',
      accentColor: AppColors.buy,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              for (var i = 0; i < timeline.length; i++)
                _TimelineStep(
                  step: timeline[i],
                  isLast: i == timeline.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimestampCard extends StatelessWidget {
  const _TimestampCard({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          _SummaryRow(label: 'Tạo lúc', value: receipt.createdAt),
          _SummaryRow(label: 'Cập nhật', value: receipt.updatedAt),
          _SummaryRow(
            label: 'Mã lệnh',
            value: receipt.id.toUpperCase(),
            valueColor: AppColors.accent,
            mono: true,
            trailingIcon: Icons.copy_rounded,
          ),
        ],
      ),
    );
  }
}

class _ShareReceiptButton extends StatelessWidget {
  const _ShareReceiptButton({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: PredictionOrderReceiptPage.shareKey,
      onPressed: () {
        unawaited(HapticFeedback.selectionClick());
        unawaited(
          showVitNoticeSheet(
            context: context,
            title: 'Sắp ra mắt',
            message: 'Chia sẻ chi tiết lệnh sẽ sớm ra mắt.',
          ),
        );
      },
      variant: VitCtaButtonVariant.secondary,
      leading: const Icon(
        Icons.ios_share_rounded,
        color: _predictionPrimary,
        size: PredictionsSpacingTokens.predictionReceiptShareIcon,
      ),
      child: const Text('Chia sẻ chi tiết lệnh'),
    );
  }
}

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.accent,
            size: PredictionsSpacingTokens.predictionReceiptDisclosureIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Probability không phải certainty. Giá thị trường dự đoán phản ánh ước lượng cộng đồng và có thể thay đổi bất cứ lúc nào. Đây không phải lời khuyên đầu tư.',
              style: AppTextStyles.badge.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptActions extends StatelessWidget {
  const _ReceiptActions({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCtaButton(
          key: PredictionOrderReceiptPage.viewEventKey,
          onPressed: () =>
              context.go(AppRoutePaths.marketsPredictionEvent(receipt.eventId)),
          variant: VitCtaButtonVariant.auth,
          child: const Text('Xem sự kiện'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        VitCtaButton(
          key: PredictionOrderReceiptPage.viewPortfolioKey,
          onPressed: () =>
              context.go(AppRoutePaths.marketsPredictionsPortfolio),
          variant: VitCtaButtonVariant.secondary,
          child: const Text('Xem danh mục'),
        ),
      ],
    );
  }
}
