part of '../../phone/pages/event/prediction_order_receipt_page.dart';

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
      padding: PredictionsSpacingTokens.predictionReceiptSummaryRowPadding,
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
                  const SizedBox(width: AppSpacing.x1),
                  Icon(
                    trailingIcon,
                    color: valueColor,
                    size: PredictionsSpacingTokens
                        .predictionReceiptSummaryTrailingIcon,
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

class _FillProgress extends StatelessWidget {
  const _FillProgress({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        const SizedBox(
          height: PredictionsSpacingTokens.predictionReceiptTimelineLineWidth,
          child: ColoredBox(color: AppColors.divider),
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        Row(
          children: [
            Text(
              'Tiến trình khớp',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const Expanded(child: SizedBox.shrink()),
            Text(
              '$percent%',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: LinearProgressIndicator(
            value: percent / 100,
            minHeight: AppSpacing.x3,
            color: percent == 100 ? AppColors.buy : AppColors.warn,
            backgroundColor: AppColors.surface2,
          ),
        ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({required this.step, required this.isLast});

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
                dimension:
                    PredictionsSpacingTokens.predictionReceiptTimelineDot,
                child: Material(
                  color: step.done ? AppColors.buy15 : AppColors.surface2,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: step.done ? AppColors.buy : AppColors.borderSolid,
                    ),
                  ),
                  child: Icon(
                    step.done ? Icons.check_rounded : Icons.schedule_rounded,
                    size:
                        PredictionsSpacingTokens.predictionReceiptTimelineIcon,
                    color: color,
                  ),
                ),
              ),
              if (!isLast)
                const Expanded(
                  child: Padding(
                    padding: PredictionsSpacingTokens
                        .predictionReceiptTimelineLineMargin,
                    child: SizedBox(
                      width: PredictionsSpacingTokens
                          .predictionReceiptTimelineLineWidth,
                      child: ColoredBox(color: AppColors.borderSolid),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.x2),
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
                if (!isLast)
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

_ReceiptStatus _receiptStatusConfig(String status) {
  switch (status) {
    case 'submitted':
      return const _ReceiptStatus(
        label: 'Đã gửi',
        pillStatus: VitStatusPillStatus.neutral,
      );
    case 'accepted':
      return const _ReceiptStatus(
        label: 'Đã tiếp nhận',
        pillStatus: VitStatusPillStatus.info,
      );
    case 'partially_filled':
      return const _ReceiptStatus(
        label: 'Khớp một phần',
        pillStatus: VitStatusPillStatus.warning,
      );
    case 'filled':
      return const _ReceiptStatus(
        label: 'Đã khớp',
        pillStatus: VitStatusPillStatus.success,
      );
    case 'canceled':
      return const _ReceiptStatus(
        label: 'Đã hủy',
        pillStatus: VitStatusPillStatus.neutral,
      );
    case 'rejected':
      return const _ReceiptStatus(
        label: 'Từ chối',
        pillStatus: VitStatusPillStatus.error,
      );
    default:
      return const _ReceiptStatus(
        label: 'Đang xử lý',
        pillStatus: VitStatusPillStatus.neutral,
      );
  }
}

class _ReceiptStatus {
  const _ReceiptStatus({required this.label, required this.pillStatus});

  final String label;
  final VitStatusPillStatus pillStatus;
}

String _formatMoney(double value) => VitFormat.usd(value);

String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';

String _formatShares(double value) {
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(2);
}
