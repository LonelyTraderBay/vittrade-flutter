part of '../../phone/pages/hub/p2p_dashboard_page.dart';

class _CenteredStat extends StatelessWidget {
  const _CenteredStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pDashboardCompactCardPadding,
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _BreakdownConfig {
  const _BreakdownConfig({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  final String label;
  final int count;
  final Color color;
  final IconData icon;
}

class _BreakdownLine extends StatelessWidget {
  const _BreakdownLine({required this.row, required this.total});

  final _BreakdownConfig row;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = row.count / total * 100;
    return Row(
      children: [
        Icon(row.icon, color: row.color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      row.label,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ),
                  Text(
                    '${row.count} (+${pct.toStringAsFixed(2)}%)',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ClipRRect(
                borderRadius: AppRadii.xsRadius,
                child: LinearProgressIndicator(
                  value: pct / 100,
                  minHeight: AppSpacing.x2,
                  backgroundColor: AppColors.surface2,
                  valueColor: AlwaysStoppedAnimation<Color>(row.color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MerchantRow extends StatelessWidget {
  const _MerchantRow({
    required this.rank,
    required this.merchant,
    required this.onTap,
  });

  final int rank;
  final P2PDashboardMerchantDraft merchant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final rankColor = rank <= 3 ? AppModuleAccents.p2p : AppColors.text3;
    return VitCard(
      key: P2PDashboardPage.merchantKey(merchant.id),
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      padding: P2PSpacingTokens.p2pDashboardMerchantPadding,
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.buttonCompact,
            child: Text(
              '#$rank',
              style: AppTextStyles.caption.copyWith(
                color: rankColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          _Avatar(label: merchant.name.characters.first),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  merchant.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${merchant.trades} đơn · ${_formatMoneyCompact(merchant.volume)}',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.star_rounded,
            color: AppColors.warn,
            size: P2PSpacingTokens.p2pDashboardMerchantStar,
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(
            merchant.rating.toStringAsFixed(1),
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppModuleAccents.p2p,
      shape: const CircleBorder(),
      child: SizedBox(
        width: AppSpacing.buttonCompact,
        height: AppSpacing.buttonCompact,
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.onAccent,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity, required this.last});

  final P2PDashboardActivityDraft activity;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final buy = activity.type == 'buy';
    final color = buy ? AppColors.buy : AppColors.sell;
    final status = _statusInfo(activity.status);
    return Column(
      children: [
        Padding(
          padding: P2PSpacingTokens.p2pDashboardActivityPadding,
          child: Row(
            children: [
              VitAccentIconBox(
                icon: buy ? Icons.south_west_rounded : Icons.north_east_rounded,
                color: color,
                iconSize: P2PSpacingTokens.p2pDashboardIconBubbleSmallIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${buy ? 'Mua' : 'Bán'} ${_formatAmount(activity.amount)} ${activity.asset}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${activity.merchant} · ${activity.date}',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatMoneyCompact(activity.total),
                    style: AppTextStyles.micro.copyWith(
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  _SmallPill(label: status.label, color: status.color),
                ],
              ),
            ],
          ),
        ),
        if (!last)
          const Divider(
            height: _p2pDashboardDividerHeight,
            color: AppColors.divider,
          ),
      ],
    );
  }
}

class _TextLinkButton extends StatelessWidget {
  const _TextLinkButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      variant: VitCtaButtonVariant.ghost,
      fullWidth: false,
      height: AppSpacing.buttonCompact,
      padding: P2PSpacingTokens.p2pDashboardTextLinkPadding,
      trailing: const Icon(Icons.chevron_right_rounded),
      child: Text(label),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter(this.points);

  final List<P2PDashboardSeriesPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;
    const left = 14.0;
    const top = 8.0;
    const bottom = 22.0;
    final width = size.width - left - AppSpacing.x2;
    final height = size.height - top - bottom;
    final maxValue = points.map((item) => item.value).reduce(math.max);
    final path = Path();
    final fillPath = Path();
    final offsets = <Offset>[];

    for (var i = 0; i < points.length; i++) {
      final x = left + width * (i / (points.length - 1));
      final y = top + height - (points[i].value / maxValue) * height;
      offsets.add(Offset(x, y));
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, top + height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(left + width, top + height);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()..color = AppModuleAccents.p2p.withValues(alpha: .10),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppModuleAccents.p2p
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );

    for (var i = 0; i < offsets.length; i++) {
      canvas.drawCircle(offsets[i], 3, Paint()..color = AppColors.bg);
      canvas.drawCircle(
        offsets[i],
        3,
        Paint()
          ..color = AppColors.onAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4,
      );
      _paintTinyText(
        canvas,
        points[i].label,
        Offset(offsets[i].dx - 8, top + height + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

class _MonthlyBarPainter extends CustomPainter {
  const _MonthlyBarPainter(this.rows);

  final List<P2PDashboardMonthlyOrdersDraft> rows;

  @override
  void paint(Canvas canvas, Size size) {
    if (rows.isEmpty) return;
    const top = 8.0;
    const bottom = 22.0;
    final height = size.height - top - bottom;
    final groupWidth = size.width / rows.length;
    final maxValue = rows
        .expand((item) => [item.buy, item.sell])
        .reduce(math.max)
        .toDouble();

    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final centerX = groupWidth * i + groupWidth / 2;
      _drawBar(
        canvas,
        centerX - 9,
        top,
        height,
        row.buy / maxValue,
        AppColors.buy,
      );
      _drawBar(
        canvas,
        centerX + 7,
        top,
        height,
        row.sell / maxValue,
        AppColors.sell,
      );
      _paintTinyText(canvas, row.month, Offset(centerX - 10, top + height + 8));
    }
  }

  void _drawBar(
    Canvas canvas,
    double x,
    double top,
    double height,
    double factor,
    Color color,
  ) {
    final barHeight = math.max(
      P2PSpacingTokens.p2pDashboardMonthlyBarMinHeight,
      height * factor,
    );
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        x,
        top + height - barHeight,
        P2PSpacingTokens.p2pDashboardMonthlyBarWidth,
        barHeight,
      ),
      AppRadii.swatchCorner,
    );
    canvas.drawRRect(rect, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MonthlyBarPainter oldDelegate) {
    return oldDelegate.rows != rows;
  }
}
