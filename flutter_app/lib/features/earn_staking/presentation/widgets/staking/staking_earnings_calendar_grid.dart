part of '../../phone/pages/staking/staking_earnings_calendar_page.dart';

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.snapshot,
    required this.visibleMonth,
    required this.today,
    required this.onPrevious,
    required this.onNext,
  });

  final StakingEarningsCalendarSnapshot snapshot;
  final DateTime visibleMonth;
  final DateTime today;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(visibleMonth.year, visibleMonth.month);
    final daysInMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + 1,
      0,
    ).day;
    final blanks = firstDay.weekday == DateTime.sunday
        ? 6
        : firstDay.weekday - 1;

    return VitCard(
      key: StakingEarningsCalendarPage.calendarCardKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        children: [
          Row(
            children: [
              _MonthButton(
                key: StakingEarningsCalendarPage.previousMonthKey,
                icon: Icons.chevron_left_rounded,
                onTap: onPrevious,
              ),
              Expanded(
                child: Text(
                  _monthLabel(snapshot, visibleMonth),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _MonthButton(
                key: StakingEarningsCalendarPage.nextMonthKey,
                icon: Icons.chevron_right_rounded,
                onTap: onNext,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              for (final label in const [
                'T2',
                'T3',
                'T4',
                'T5',
                'T6',
                'T7',
                'CN',
              ])
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          GridView.count(
            crossAxisCount: EarnSpacingTokens.stakingEarningsCalendarColumns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x1,
            crossAxisSpacing: AppSpacing.x1,
            children: [
              for (var i = 0; i < blanks; i++) const SizedBox.shrink(),
              for (var day = 1; day <= daysInMonth; day++)
                _DayCell(
                  key: StakingEarningsCalendarPage.dayKey(day),
                  day: day,
                  events: _eventsForDay(snapshot.events, visibleMonth, day),
                  today:
                      day == today.day &&
                      visibleMonth.month == today.month &&
                      visibleMonth.year == today.year,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  const _MonthButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      icon: icon,
      tooltip: 'Đổi tháng',
      onPressed: onTap,
      variant: VitIconButtonVariant.defaultAction,
      size: VitIconButtonSize.sm,
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    super.key,
    required this.day,
    required this.events,
    required this.today,
  });

  final int day;
  final List<StakingCalendarEventDraft> events;
  final bool today;

  @override
  Widget build(BuildContext context) {
    final hasEvents = events.isNotEmpty;
    final borderColor = today
        ? AppColors.primary
        : hasEvents
        ? AppColors.cardBorder
        : AppColors.transparent;
    final bgColor = today
        ? AppColors.primary12
        : hasEvents
        ? AppColors.surface3
        : AppColors.transparent;

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: AppRadii.lgRadius,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$day',
              style: AppTextStyles.caption.copyWith(
                color: today ? AppColors.primarySoft : AppColors.text1,
                fontWeight: today ? AppTextStyles.bold : AppTextStyles.medium,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            if (hasEvents) ...[
              const SizedBox(height: AppSpacing.x1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final event in events.take(3)) ...[
                    _EventDot(color: _eventColor(event.type)),
                    const SizedBox(
                      width: EarnSpacingTokens.stakingEarningsEventDotGap,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LegendCard extends StatelessWidget {
  const _LegendCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingEarningsCalendarPage.legendKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loại sự kiện:',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Wrap(
            spacing: AppSpacing.x7,
            runSpacing: AppSpacing.x3,
            children: [
              VitLegendItem(
                color: _eventColor(StakingCalendarEventType.dailyReward),
                label: 'Nhận lãi',
              ),
              VitLegendItem(
                color: _eventColor(StakingCalendarEventType.maturity),
                label: 'Đến hạn',
              ),
              VitLegendItem(
                color: _eventColor(StakingCalendarEventType.autoCompound),
                label: 'Tái đầu tư',
              ),
              VitLegendItem(
                color: _eventColor(StakingCalendarEventType.rateChange),
                label: 'Thay đổi APY',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventDot extends StatelessWidget {
  const _EventDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.x2,
      height: AppSpacing.x2,
      child: DecoratedBox(
        decoration: ShapeDecoration(color: color, shape: const CircleBorder()),
      ),
    );
  }
}
