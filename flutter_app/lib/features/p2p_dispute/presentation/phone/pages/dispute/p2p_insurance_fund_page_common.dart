part of 'p2p_insurance_fund_page.dart';

class _TwoColumnInfo extends StatelessWidget {
  const _TwoColumnInfo({required this.label, required this.value, this.tone});

  final String label;
  final String value;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pTrustProgressInfoRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: tone ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({required this.label, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      borderColor: active ? AppColors.primary20 : AppColors.cardBorder,
      background: ColoredBox(
        color: active ? AppColors.primary12 : AppColors.surface2,
      ),
      padding: P2PSpacingTokens.p2pTrustProgressChipPadding,
      clip: true,
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: active ? AppModuleAccents.p2p : AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: P2PSpacingTokens.p2pTrustProgressDotSize,
          child: Material(color: color, shape: const CircleBorder()),
        ),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier});

  final P2PInsuranceCoverageTierDraft tier;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      background: ColoredBox(
        color: tier.highlight ? AppColors.primary12 : AppColors.transparent,
      ),
      padding: P2PSpacingTokens.p2pTrustProgressChipPadding,
      clip: true,
      child: Row(
        children: [
          Expanded(
            child: Text(
              tier.name,
              style: AppTextStyles.caption.copyWith(
                color: tier.highlight ? AppModuleAccents.p2p : AppColors.text2,
                fontWeight: tier.highlight
                    ? AppTextStyles.bold
                    : AppTextStyles.normal,
              ),
            ),
          ),
          Text(
            '${tier.coveragePct}${tier.bonus == null ? '' : ' · ${tier.bonus}'}',
            style: AppTextStyles.caption.copyWith(
              color: tier.bonus == null ? AppColors.text1 : AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.pref});

  final P2PInsuranceNotificationPrefDraft pref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pTrustProgressNotificationRowPadding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pref.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  pref.description,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: pref.enabled,
            activeThumbColor: AppModuleAccents.p2p,
            activeTrackColor: AppColors.primary20,
            onChanged: (_) => HapticFeedback.selectionClick(),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.index,
    required this.title,
    required this.subtitle,
  });

  final String index;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: P2PSpacingTokens.p2pTrustProgressStepPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: P2PSpacingTokens.p2pTrustProgressStepRadius,
            backgroundColor: AppColors.surface3,
            child: Text(
              index,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pTrustProgressCompactPadding,
      child: Row(
        children: [
          Icon(icon, color: AppModuleAccents.p2p, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  value,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FundTrendPainter extends CustomPainter {
  const _FundTrendPainter(this.points);

  final List<P2PInsuranceChartPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final gridPaint = Paint()
      ..color = AppColors.divider
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final minBalance = points.map((item) => item.balance).reduce(math.min);
    final maxBalance = points.map((item) => item.balance).reduce(math.max);
    final range = (maxBalance - minBalance).clamp(1, 1000);
    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final normalized = (points[i].balance - minBalance) / range;
      final y =
          size.height - normalized * size.height * .78 - size.height * .08;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = AppColors.buy10);
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.buy
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant _FundTrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

final class _ClaimStatusView {
  const _ClaimStatusView(this.label, this.status, this.color);

  final String label;
  final VitStatusPillStatus status;
  final Color color;
}

_ClaimStatusView _claimStatusConfig(P2PInsuranceClaimStatus status) {
  return switch (status) {
    P2PInsuranceClaimStatus.pending => const _ClaimStatusView(
      'Chờ xử lý',
      VitStatusPillStatus.warning,
      AppColors.warn,
    ),
    P2PInsuranceClaimStatus.reviewing => const _ClaimStatusView(
      'Đang xem xét',
      VitStatusPillStatus.orange,
      AppModuleAccents.p2p,
    ),
    P2PInsuranceClaimStatus.approved => const _ClaimStatusView(
      'Đã duyệt',
      VitStatusPillStatus.success,
      AppColors.buy,
    ),
    P2PInsuranceClaimStatus.rejected => const _ClaimStatusView(
      'Từ chối',
      VitStatusPillStatus.error,
      AppColors.sell,
    ),
    P2PInsuranceClaimStatus.paid => const _ClaimStatusView(
      'Đã chi trả',
      VitStatusPillStatus.success,
      AppColors.buy,
    ),
  };
}

String _formatVnd(int value) => formatP2PVnd(value);

String _formatCompactVnd(int value) {
  if (value >= 1000000000) {
    return '${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(0)}M';
  }
  return _formatVnd(value);
}
