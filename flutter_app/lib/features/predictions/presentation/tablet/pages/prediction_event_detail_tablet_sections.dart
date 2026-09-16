part of 'prediction_event_detail_tablet_page.dart';

// ---------------------------------------------------------------------------
// Section đầu trang: badge + tiêu đề + meta + chọn kết quả.
// ---------------------------------------------------------------------------

class _Sc211EventHeader extends StatelessWidget {
  const _Sc211EventHeader({
    required this.event,
    required this.selectedOutcome,
    required this.onOutcomeSelected,
  });

  final PredictionEventDraft event;
  final String selectedOutcome;
  final ValueChanged<String> onOutcomeSelected;

  @override
  Widget build(BuildContext context) {
    final outcomes = event.outcomes.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: TabletSpacingTokens.x2,
          runSpacing: TabletSpacingTokens.x1,
          children: [
            _Sc211TinyBadge(
              label: event.category,
              color: AppColors.primary,
              background: AppColors.primary.withValues(alpha: .13),
            ),
            for (final tag in event.tags)
              _Sc211TinyBadge(
                label: tag,
                color: AppColors.text3,
                background: AppColors.surface2,
              ),
            if (event.status == PredictionEventStatus.resolved)
              const _Sc211TinyBadge(
                label: 'Đã chốt',
                color: AppColors.text3,
                background: AppColors.surface2,
              ),
          ],
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        Text(
          event.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.sectionTitle,
        ),
        const SizedBox(height: TabletSpacingTokens.x3),
        Wrap(
          spacing: TabletSpacingTokens.x2,
          runSpacing: TabletSpacingTokens.x1,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _Sc211MetaItem(
              icon: Icons.schedule_rounded,
              label: predictionsTimeRemaining(
                event.endDate,
                endedLabel: 'Đã kết thúc',
                activePrefix: '',
              ),
            ),
            _Sc211MetaItem(
              icon: Icons.group_outlined,
              label: VitFormat.count(event.participants),
            ),
            _Sc211MetaItem(
              icon: Icons.bar_chart_rounded,
              label: VitFormat.compactSuffix(event.totalVolume, prefix: r'$'),
            ),
            _Sc211ChangeLabel(value: event.change24h),
          ],
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        if (event.outcomes.length == 2)
          Row(
            children: [
              for (var index = 0; index < outcomes.length; index += 1) ...[
                Expanded(
                  child: _Sc211OutcomeCard(
                    outcome: outcomes[index],
                    selected: selectedOutcome == outcomes[index].label,
                    onTap: () => onOutcomeSelected(outcomes[index].label),
                  ),
                ),
                if (index == 0) const SizedBox(width: TabletSpacingTokens.x4),
              ],
            ],
          )
        else
          _Sc211MultiOutcomeList(
            event: event,
            selectedOutcome: selectedOutcome,
            onOutcomeSelected: onOutcomeSelected,
          ),
        if (event.outcomes.length == 2) ...[
          const SizedBox(height: TabletSpacingTokens.x3),
          _Sc211ProbabilityBar(outcomes: outcomes),
        ],
      ],
    );
  }
}

class _Sc211OutcomeCard extends StatelessWidget {
  const _Sc211OutcomeCard({
    required this.outcome,
    required this.selected,
    required this.onTap,
  });

  final PredictionOutcomeDraft outcome;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isYes = outcome.label == 'Yes';
    final color = outcome.tone.resolve();
    return VitCard(
      onTap: onTap,
      borderColor: color.withValues(alpha: selected ? .42 : .18),
      background: ColoredBox(color: color.withValues(alpha: isYes ? .08 : .07)),
      clip: true,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: TabletSpacingTokens.iconMd,
                child: Material(color: color, shape: const CircleBorder()),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Text(
                outcome.label,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Text(
            VitFormat.percent(outcome.chance, fractionDigits: 0),
            style: AppTextStyles.sectionTitle.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  isYes ? 'Giá mua tốt' : 'Giá bán tốt',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Flexible(
                child: Text(
                  VitFormat.usd(outcome.chance / 100),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Sc211MultiOutcomeList extends StatelessWidget {
  const _Sc211MultiOutcomeList({
    required this.event,
    required this.selectedOutcome,
    required this.onOutcomeSelected,
  });

  final PredictionEventDraft event;
  final String selectedOutcome;
  final ValueChanged<String> onOutcomeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < event.outcomes.length; index += 1) ...[
          _Sc211MultiOutcomeRow(
            outcome: event.outcomes[index],
            selected: selectedOutcome == event.outcomes[index].label,
            onTap: () => onOutcomeSelected(event.outcomes[index].label),
          ),
          if (index != event.outcomes.length - 1)
            const SizedBox(height: TabletSpacingTokens.x3),
        ],
      ],
    );
  }
}

class _Sc211MultiOutcomeRow extends StatelessWidget {
  const _Sc211MultiOutcomeRow({
    required this.outcome,
    required this.selected,
    required this.onTap,
  });

  final PredictionOutcomeDraft outcome;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = outcome.tone.resolve();
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      borderColor: selected
          ? color.withValues(alpha: .34)
          : AppColors.cardBorder,
      background: selected
          ? ColoredBox(color: color.withValues(alpha: .12))
          : null,
      clip: selected,
      padding: TabletSpacingTokens.cardPaddingCompact,
      child: Row(
        children: [
          SizedBox.square(
            dimension: TabletSpacingTokens.iconSm,
            child: Material(color: color, shape: const CircleBorder()),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Text(
              outcome.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            VitFormat.percent(outcome.chance, fractionDigits: 0),
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Sc211ProbabilityBar extends StatelessWidget {
  const _Sc211ProbabilityBar({required this.outcomes});

  final List<PredictionOutcomeDraft> outcomes;

  @override
  Widget build(BuildContext context) {
    final yes = outcomes.first;
    final no = outcomes.last;
    return ClipRRect(
      borderRadius: AppRadii.pillRadius,
      child: SizedBox(
        height: TabletSpacingTokens.x3,
        child: Row(
          children: [
            Expanded(
              flex: yes.chance,
              child: ColoredBox(color: yes.tone.resolve()),
            ),
            Expanded(
              flex: no.chance,
              child: ColoredBox(color: no.tone.resolve()),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lưới thống kê + banner vị thế.
// ---------------------------------------------------------------------------

class _Sc211StatsGrid extends StatelessWidget {
  const _Sc211StatsGrid({required this.event});

  final PredictionEventDraft event;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _Sc211StatItem(
        icon: Icons.bar_chart_rounded,
        label: 'Khối lượng 24h',
        value: VitFormat.compactSuffix(event.volume24h, prefix: r'$'),
        color: AppColors.primary,
      ),
      _Sc211StatItem(
        icon: Icons.group_outlined,
        label: 'Người tham gia',
        value: VitFormat.count(event.participants),
        color: AppColors.accent,
      ),
      _Sc211StatItem(
        icon: Icons.stacked_line_chart_rounded,
        label: 'Tổng khối lượng',
        value: VitFormat.compactSuffix(event.totalVolume, prefix: r'$'),
        color: AppColors.buy,
      ),
      _Sc211StatItem(
        icon: Icons.schedule_rounded,
        label: 'Còn lại',
        value: predictionsTimeRemaining(
          event.endDate,
          endedLabel: 'Đã kết thúc',
          activePrefix: '',
        ),
        color: AppColors.warn,
      ),
    ];

    return Row(
      children: [
        for (var index = 0; index < stats.length; index += 1) ...[
          Expanded(child: _Sc211StatCard(stat: stats[index])),
          if (index != stats.length - 1)
            const SizedBox(width: TabletSpacingTokens.x4),
        ],
      ],
    );
  }
}

class _Sc211StatCard extends StatelessWidget {
  const _Sc211StatCard({required this.stat});

  final _Sc211StatItem stat;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Row(
        children: [
          SizedBox.square(
            dimension: TabletSpacingTokens.accentIconBoxSize,
            child: Material(
              color: stat.color.withValues(alpha: .12),
              borderRadius: AppRadii.smRadius,
              child: Icon(
                stat.icon,
                color: stat.color,
                size: TabletSpacingTokens.iconMd,
              ),
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: TabletSpacingTokens.x1),
                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    );
  }
}

class _Sc211StatItem {
  const _Sc211StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
}

class _Sc211PositionBanner extends StatelessWidget {
  const _Sc211PositionBanner({required this.position});

  final PredictionDetailPositionDraft position;

  @override
  Widget build(BuildContext context) {
    final color = position.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return VitCard(
      borderColor: color.withValues(alpha: .22),
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox.square(
                dimension: TabletSpacingTokens.iconSm,
                child: Icon(
                  Icons.bolt_rounded,
                  color: AppColors.warn,
                  size: TabletSpacingTokens.iconSm,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Text(
                'Vị thế của bạn',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x3),
          Row(
            children: [
              _Sc211TinyBadge(
                label: position.outcome,
                color: position.outcome == 'Yes'
                    ? AppColors.buy
                    : AppColors.sell,
                background: position.outcome == 'Yes'
                    ? AppColors.buy10
                    : AppColors.sell10,
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Expanded(
                child: Text(
                  '${position.shares.toStringAsFixed(0)} cổ phần @ '
                  '${VitFormat.usd(position.avgPrice)}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    VitFormat.usdSigned(position.pnl),
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: TabletSpacingTokens.x1),
                  Text(
                    VitFormat.signedPercent(position.pnlPct),
                    style: AppTextStyles.micro.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Biểu đồ xác suất + khối lượng.
// ---------------------------------------------------------------------------

class _Sc211ChartSection extends StatelessWidget {
  const _Sc211ChartSection({required this.snapshot});

  final PredictionEventDetailSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Giá / Xác suất',
      innerGap: TabletSpacingTokens.x4,
      accentColor: AppColors.buy,
      density: VitDensity.compact,
      children: [
        VitCard(
          density: VitDensity.compact,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Sc211ChartPeriodTabs(),
              const SizedBox(height: TabletSpacingTokens.x3),
              SizedBox(
                height:
                    TabletSpacingTokens.x7 +
                    TabletSpacingTokens.x7 +
                    TabletSpacingTokens.x5,
                child: CustomPaint(
                  painter: _Sc211ProbabilityChartPainter(
                    values: snapshot.probabilityHistory,
                  ),
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x1),
              Text(
                'Khối lượng 24h',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: TabletSpacingTokens.x1),
              SizedBox(
                height: TabletSpacingTokens.x5,
                child: _Sc211VolumeBars(values: snapshot.volumeHistory),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Sc211ChartPeriodTabs extends StatelessWidget {
  const _Sc211ChartPeriodTabs();

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.pill,
      activeKey: '30D',
      // Mock chỉ có một chuỗi dữ liệu — khung thời gian là hiển thị tĩnh
      // như trang phone SC-030.
      onChanged: (_) {},
      tabs: const [
        VitTabItem(key: '1H', label: '1H'),
        VitTabItem(key: '1D', label: '1D'),
        VitTabItem(key: '7D', label: '7D'),
        VitTabItem(key: '30D', label: '30D'),
        VitTabItem(key: 'all', label: 'Tất cả'),
      ],
    );
  }
}

class _Sc211VolumeBars extends StatelessWidget {
  const _Sc211VolumeBars({required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();
    final maxValue = values.reduce(math.max).toDouble();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final value in values)
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: math.max(.06, value / maxValue),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TabletSpacingTokens.x1,
                  ),
                  child: Material(
                    color: AppColors.primary.withValues(alpha: .30),
                    borderRadius: AppRadii.predictionDetailChartVolumeBarRadius,
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Sc211ProbabilityChartPainter extends CustomPainter {
  const _Sc211ProbabilityChartPainter({required this.values});

  final List<int> values;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.borderSolid.withValues(alpha: .55)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i += 1) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (values.length < 2) return;

    final path = Path();
    for (var index = 0; index < values.length; index += 1) {
      final x = size.width * index / (values.length - 1);
      final y = size.height - (values[index] / 100) * size.height;
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.buy.withValues(alpha: .30),
          AppColors.buy.withValues(alpha: .02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = TabletSpacingTokens.hairlineStroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _Sc211ProbabilityChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

// ---------------------------------------------------------------------------
// Sổ lệnh mở/gập.
// ---------------------------------------------------------------------------

class _Sc211OrderBookSection extends StatelessWidget {
  const _Sc211OrderBookSection({
    required this.snapshot,
    required this.expanded,
    required this.onToggle,
  });

  final PredictionEventDetailSnapshot snapshot;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final chance = snapshot.event.outcomes.first.chance / 100;
    final bestBid = snapshot.orderBook.bids.first.price;
    final bestAsk = snapshot.orderBook.asks.first.price;
    return Column(
      children: [
        VitCard(
          key: PredictionEventDetailTabletPage.orderBookToggleKey,
          onTap: onToggle,
          variant: VitCardVariant.inner,
          padding: TabletSpacingTokens.cardPaddingCompact,
          child: Row(
            children: [
              const SizedBox.square(
                dimension: TabletSpacingTokens.iconSm,
                child: Icon(
                  Icons.layers_rounded,
                  color: AppColors.primary,
                  size: TabletSpacingTokens.iconSm,
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Expanded(
                child: Text(
                  'Sổ lệnh',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Flexible(
                child: Text(
                  'Chênh lệch ${VitFormat.usd(bestAsk - bestBid)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: TabletSpacingTokens.x3),
              Icon(
                expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
                size: TabletSpacingTokens.iconMd,
              ),
            ],
          ),
        ),
        if (expanded) ...[
          const SizedBox(height: TabletSpacingTokens.x4),
          VitCard(
            density: VitDensity.compact,
            child: Column(
              children: [
                const _Sc211OrderBookHeader(),
                const SizedBox(height: TabletSpacingTokens.x3),
                for (final ask in snapshot.orderBook.asks.reversed)
                  _Sc211OrderBookRow(entry: ask, isBid: false),
                Padding(
                  padding: TabletSpacingTokens.tableCellPaddingV,
                  child: Material(
                    color: AppColors.surface2,
                    borderRadius: AppRadii.smRadius,
                    child: Padding(
                      padding: TabletSpacingTokens.cardPaddingCompact,
                      child: Center(
                        child: Text(
                          '${VitFormat.usd(chance)} · giá giữa',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                for (final bid in snapshot.orderBook.bids)
                  _Sc211OrderBookRow(entry: bid, isBid: true),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Sc211OrderBookHeader extends StatelessWidget {
  const _Sc211OrderBookHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _Sc211OrderBookLabel('GIÁ')),
        Expanded(child: _Sc211OrderBookLabel('CỔ PHẦN', alignEnd: true)),
        Expanded(child: _Sc211OrderBookLabel('TỔNG', alignEnd: true)),
      ],
    );
  }
}

class _Sc211OrderBookLabel extends StatelessWidget {
  const _Sc211OrderBookLabel(this.label, {this.alignEnd = false});

  final String label;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: alignEnd ? TextAlign.end : TextAlign.start,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _Sc211OrderBookRow extends StatelessWidget {
  const _Sc211OrderBookRow({required this.entry, required this.isBid});

  final PredictionOrderBookEntryDraft entry;
  final bool isBid;

  @override
  Widget build(BuildContext context) {
    final color = isBid ? AppColors.buy : AppColors.sell;
    return Material(
      color: color.withValues(alpha: .04),
      borderRadius: AppRadii.predictionDetailOrderBookRowRadius,
      child: Padding(
        padding: TabletSpacingTokens.tableCellPaddingV,
        child: Row(
          children: [
            Expanded(
              child: Text(
                VitFormat.usd(entry.price),
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Expanded(
              child: Text(
                VitFormat.count(entry.shares),
                textAlign: TextAlign.end,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            Expanded(
              child: Text(
                VitFormat.count((entry.price * entry.shares).round()),
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
    );
  }
}

// ---------------------------------------------------------------------------
// Widget dùng chung nhỏ.
// ---------------------------------------------------------------------------

class _Sc211MetaItem extends StatelessWidget {
  const _Sc211MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: TabletSpacingTokens.iconSm,
          child: Icon(
            icon,
            color: AppColors.text3,
            size: TabletSpacingTokens.iconSm,
          ),
        ),
        const SizedBox(width: TabletSpacingTokens.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _Sc211ChangeLabel extends StatelessWidget {
  const _Sc211ChangeLabel({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final color = value >= 0 ? AppColors.buy : AppColors.sell;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: TabletSpacingTokens.iconSm,
          child: Icon(
            value >= 0 ? Icons.arrow_outward_rounded : Icons.south_east_rounded,
            color: color,
            size: TabletSpacingTokens.iconSm,
          ),
        ),
        Text(
          VitFormat.signedPercent(value),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _Sc211TinyBadge extends StatelessWidget {
  const _Sc211TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: AppRadii.badgeRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TabletSpacingTokens.x2,
          vertical: TabletSpacingTokens.x1,
        ),
        child: Text(label, style: AppTextStyles.badge.copyWith(color: color)),
      ),
    );
  }
}
