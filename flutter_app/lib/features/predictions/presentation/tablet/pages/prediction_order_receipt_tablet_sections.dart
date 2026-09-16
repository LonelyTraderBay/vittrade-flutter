part of 'prediction_order_receipt_tablet_page.dart';

class _Sc225ReceiptHero extends StatelessWidget {
  const _Sc225ReceiptHero({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final isBuy = receipt.side == 'buy';
    final status = _sc225ReceiptStatusConfig(receipt.status);

    return VitCard(
      density: VitDensity.compact,
      radius: VitCardRadius.large,
      child: Column(
        children: [
          Wrap(
            spacing: TabletSpacingTokens.x2,
            runSpacing: TabletSpacingTokens.x2,
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
          const SizedBox(height: TabletSpacingTokens.x3),
          Text(
            receipt.outcome,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
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

class _Sc225OrderSummary extends StatelessWidget {
  const _Sc225OrderSummary({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final fillPct = receipt.shares <= 0
        ? 0
        : ((receipt.filledShares / receipt.shares) * 100).round();

    return VitPageSection(
      label: 'Tổng quan lệnh',
      innerGap: TabletSpacingTokens.x4,
      accentColor: AppColors.primary,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              _Sc225SummaryRow(
                label: 'Tổng giá trị',
                value: VitFormat.usd(receipt.total),
                mono: true,
              ),
              _Sc225SummaryRow(
                label: 'Phí (2%)',
                key: PredictionOrderReceiptTabletPage.feeSummaryKey,
                value: VitFormat.usd(receipt.fee),
                mono: true,
              ),
              _Sc225SummaryRow(
                label: 'Loại lệnh',
                value: receipt.orderType == 'market'
                    ? 'Thị trường'
                    : 'Giới hạn',
              ),
              _Sc225SummaryRow(label: 'Kết quả', value: receipt.outcome),
              _Sc225SummaryRow(
                label: 'Cổ phần',
                value:
                    '${_sc225FormatShares(receipt.filledShares)}'
                    '/${_sc225FormatShares(receipt.shares)}',
                mono: true,
              ),
              _Sc225SummaryRow(
                label: 'Giá đặt',
                value: VitFormat.usd(receipt.price),
                mono: true,
              ),
              if (receipt.avgPrice > 0)
                _Sc225SummaryRow(
                  label: 'Giá khớp TB',
                  value: VitFormat.usd(receipt.avgPrice),
                  mono: true,
                ),
              if (receipt.status != 'canceled' && receipt.status != 'rejected')
                _Sc225FillProgress(percent: fillPct),
            ],
          ),
        ),
      ],
    );
  }
}

class _Sc225TimelineCard extends StatelessWidget {
  const _Sc225TimelineCard({required this.receipt});

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
      innerGap: TabletSpacingTokens.x4,
      accentColor: AppColors.buy,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            children: [
              for (var i = 0; i < timeline.length; i++)
                _Sc225TimelineStep(
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

class _Sc225TimestampCard extends StatelessWidget {
  const _Sc225TimestampCard({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          _Sc225SummaryRow(label: 'Tạo lúc', value: receipt.createdAt),
          _Sc225SummaryRow(label: 'Cập nhật', value: receipt.updatedAt),
          _Sc225SummaryRow(
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

class _Sc225ShareReceiptButton extends StatelessWidget {
  const _Sc225ShareReceiptButton({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: PredictionOrderReceiptTabletPage.shareKey,
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
        color: AppColors.primary,
        size: TabletSpacingTokens.iconMd,
      ),
      child: const Text('Chia sẻ chi tiết lệnh'),
    );
  }
}

class _Sc225DisclosureCard extends StatelessWidget {
  const _Sc225DisclosureCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox.square(
            dimension: TabletSpacingTokens.iconSm,
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.accent,
              size: TabletSpacingTokens.iconSm,
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x2),
          Expanded(
            child: Text(
              'Xác suất không phải sự chắc chắn. Giá thị trường dự đoán phản '
              'ánh ước lượng cộng đồng và có thể thay đổi bất cứ lúc nào. Đây '
              'không phải lời khuyên đầu tư.',
              style: AppTextStyles.badge.copyWith(color: AppColors.text3),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc225ReceiptActions extends StatelessWidget {
  const _Sc225ReceiptActions({required this.receipt});

  final PredictionPortfolioReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VitCtaButton(
          key: PredictionOrderReceiptTabletPage.viewEventKey,
          onPressed: () => context.push(
            AppRoutePaths.marketsPredictionEvent(receipt.eventId),
          ),
          variant: VitCtaButtonVariant.auth,
          child: const Text('Xem sự kiện'),
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        VitCtaButton(
          key: PredictionOrderReceiptTabletPage.viewPortfolioKey,
          onPressed: () =>
              context.push(AppRoutePaths.marketsPredictionsPortfolio),
          variant: VitCtaButtonVariant.secondary,
          child: const Text('Xem danh mục'),
        ),
      ],
    );
  }
}

class _Sc225SummaryRow extends StatelessWidget {
  const _Sc225SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.mono = false,
    this.trailingIcon,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool mono;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: TabletSpacingTokens.tableCellPaddingV,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.badge.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: valueColor,
                      fontWeight: AppTextStyles.medium,
                      fontFeatures: mono ? AppTextStyles.tabularFigures : null,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  const SizedBox(width: TabletSpacingTokens.x1),
                  Icon(
                    trailingIcon,
                    color: valueColor,
                    size: TabletSpacingTokens.iconSm,
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

class _Sc225FillProgress extends StatelessWidget {
  const _Sc225FillProgress({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: TabletSpacingTokens.x3),
        const SizedBox(
          height: TabletSpacingTokens.hairlineStroke,
          child: ColoredBox(color: AppColors.divider),
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        Row(
          children: [
            Text(
              'Tiến trình khớp',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const Expanded(child: SizedBox.shrink()),
            Text(
              VitFormat.percent(percent, fractionDigits: 0),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
        const SizedBox(height: TabletSpacingTokens.x1),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: SizedBox(
            height: TabletSpacingTokens.x3,
            child: LinearProgressIndicator(
              value: percent / 100,
              color: percent == 100 ? AppColors.buy : AppColors.warn,
              backgroundColor: AppColors.surface2,
            ),
          ),
        ),
      ],
    );
  }
}

class _Sc225TimelineStep extends StatelessWidget {
  const _Sc225TimelineStep({required this.step, required this.isLast});

  final PredictionReceiptTimelineDraft step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = step.done ? AppColors.buy : AppColors.text3;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox.square(
                dimension: TabletSpacingTokens.iconMd,
                child: Material(
                  color: step.done ? AppColors.buy15 : AppColors.surface2,
                  shape: const CircleBorder(),
                  child: Icon(
                    step.done ? Icons.check_rounded : Icons.schedule_rounded,
                    size: TabletSpacingTokens.iconSm,
                    color: color,
                  ),
                ),
              ),
              if (!isLast)
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: TabletSpacingTokens.x1,
                    ),
                    child: SizedBox(
                      width: TabletSpacingTokens.dividerHairline,
                      child: ColoredBox(color: AppColors.borderSolid),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: TabletSpacingTokens.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: AppTextStyles.caption.copyWith(
                    color: step.done ? AppColors.text1 : AppColors.text3,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                if (step.date.isNotEmpty)
                  Text(
                    step.date,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                if (!isLast) const SizedBox(height: TabletSpacingTokens.x3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc225ReceiptStatus {
  const _Sc225ReceiptStatus({required this.label, required this.pillStatus});

  final String label;
  final VitStatusPillStatus pillStatus;
}

_Sc225ReceiptStatus _sc225ReceiptStatusConfig(String status) {
  switch (status) {
    case 'submitted':
      return const _Sc225ReceiptStatus(
        label: 'Đã gửi',
        pillStatus: VitStatusPillStatus.neutral,
      );
    case 'accepted':
      return const _Sc225ReceiptStatus(
        label: 'Đã tiếp nhận',
        pillStatus: VitStatusPillStatus.info,
      );
    case 'partially_filled':
      return const _Sc225ReceiptStatus(
        label: 'Khớp một phần',
        pillStatus: VitStatusPillStatus.warning,
      );
    case 'filled':
      return const _Sc225ReceiptStatus(
        label: 'Đã khớp',
        pillStatus: VitStatusPillStatus.success,
      );
    case 'canceled':
      return const _Sc225ReceiptStatus(
        label: 'Đã hủy',
        pillStatus: VitStatusPillStatus.neutral,
      );
    case 'rejected':
      return const _Sc225ReceiptStatus(
        label: 'Từ chối',
        pillStatus: VitStatusPillStatus.error,
      );
    default:
      return const _Sc225ReceiptStatus(
        label: 'Đang xử lý',
        pillStatus: VitStatusPillStatus.neutral,
      );
  }
}

String _sc225FormatShares(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2);
}
