part of 'referral_rewards_page.dart';

class _DisputeInfo extends StatelessWidget {
  const _DisputeInfo();

  @override
  Widget build(BuildContext context) {
    return const VitBanner(
      variant: VitBannerVariant.info,
      icon: Icons.chat_bubble_outline_rounded,
      message: 'Hoa hồng không chính xác?',
      detail:
          'Bấm vào biểu tượng cảnh báo bên cạnh mỗi giao dịch để báo lỗi. Đội ngũ hỗ trợ sẽ xử lý trong 24-48 giờ.',
    );
  }
}

class _SheetRecord extends StatelessWidget {
  const _SheetRecord({required this.record});

  final ReferralRewardRecordDraft record;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: ReferralSpacingTokens.referralInnerPadding,
      child: Row(
        children: [
          _RecordIcon(type: record.type),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.friendName,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${record.action} · ${record.date}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '+${_formatUsd(record.amount)}',
            style: AppTextStyles.body.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisputeTypeRow extends StatelessWidget {
  const _DisputeTypeRow({required this.type});

  final ReferralDisputeTypeDraft type;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: ReferralSpacingTokens.referralInnerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            type.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DisputeHistoryCard extends StatelessWidget {
  const _DisputeHistoryCard({required this.dispute});

  final ReferralDisputeDraft dispute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: ReferralSpacingTokens.referralCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                dispute.id,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: VitStatusPill(
                  label: dispute.statusLabel,
                  status: VitStatusPillStatus.warning,
                  size: VitStatusPillSize.sm,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                dispute.createdDate,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            dispute.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          if (dispute.resolution != null) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              dispute.resolution!,
              style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReferralRewardChartPainter extends CustomPainter {
  const _ReferralRewardChartPainter(this.points);

  final List<ReferralChartPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final chartHeight = size.height - 30;
    final chart = Rect.fromLTWH(0, 0, size.width, chartHeight);
    final maxValue = points.map((point) => point.commission).reduce(math.max);
    final minValue = points.map((point) => point.commission).reduce(math.min);
    final valueRange = math.max(1, maxValue - minValue);
    final step = chart.width / (points.length - 1);
    final offsets = <Offset>[];

    for (var i = 0; i < points.length; i++) {
      final normalized = (points[i].commission - minValue) / valueRange;
      offsets.add(
        Offset(
          chart.left + step * i,
          chart.bottom - normalized * (chart.height * .54) - chart.height * .18,
        ),
      );
    }

    final line = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (var i = 1; i < offsets.length; i++) {
      final previous = offsets[i - 1];
      final current = offsets[i];
      final controlX = (previous.dx + current.dx) / 2;
      line.cubicTo(
        controlX,
        previous.dy,
        controlX,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final fill = Path.from(line)
      ..lineTo(offsets.last.dx, chart.bottom)
      ..lineTo(offsets.first.dx, chart.bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.buy20, AppColors.buy10.withValues(alpha: 0)],
      ).createShader(chart);
    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(line, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ReferralRewardChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _formatUsd(double value) => VitFormat.usd(value);
