part of '../../phone/pages/governance/arena_report_case_page.dart';

class _CaseSummaryCard extends StatelessWidget {
  const _CaseSummaryCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    final accentColor = _targetColor(reportCase.targetType);
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '#${reportCase.id.toUpperCase()}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ),
              _ReportStatusPill(status: reportCase.status),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              _ToneIcon(
                icon: _targetIcon(reportCase.targetType),
                color: accentColor,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportCase.targetName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${_targetLabel(reportCase.targetType)} · Báo cáo lúc ${reportCase.createdAt}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReportReasonCard extends StatelessWidget {
  const _ReportReasonCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Lý do báo cáo',
      accentColor: AppColors.sell,
      child: VitCard(
        density: VitDensity.compact,
        borderColor: AppColors.sell20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.flag_outlined,
              color: AppColors.sell,
              size: _reportInlineIcon,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                reportCase.reason,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: _reportBodyLineHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Tiến trình xử lý',
      accentColor: AppColors.buy,
      child: VitCard(
        density: VitDensity.compact,
        child: Column(
          children: [
            for (var index = 0; index < reportCase.timeline.length; index++)
              _TimelineRow(
                step: reportCase.timeline[index],
                isLast: index == reportCase.timeline.length - 1,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.step, required this.isLast});

  final ArenaReportTimelineStepDraft step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = step.done ? AppColors.buy : AppColors.surface2;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: _reportTimelineColumnWidth,
          child: Column(
            children: [
              Padding(
                padding: _reportTimelineDotMargin,
                child: SizedBox(
                  width: _reportTimelineDot,
                  height: _reportTimelineDot,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: dotColor,
                      shape: CircleBorder(
                        side: step.done
                            ? BorderSide.none
                            : const BorderSide(
                                color: AppColors.borderSolid,
                                width: _reportTimelineBorderWidth,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              if (!isLast)
                SizedBox(
                  width: _reportTimelineLineWidth,
                  height: _reportTimelineLineHeight,
                  child: ColoredBox(
                    color: step.done ? AppColors.buy20 : AppColors.divider,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Padding(
            padding: isLast
                ? AppSpacing.zeroInsets
                : _reportTimelineBodyPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.label,
                  style: AppTextStyles.body.copyWith(
                    color: step.done ? AppColors.text1 : AppColors.text3,
                    fontWeight: step.done
                        ? AppTextStyles.medium
                        : AppTextStyles.normal,
                    height: _reportBodyLineHeight,
                  ),
                ),
                if (step.date.isNotEmpty) ...[
                  const SizedBox(height: _reportTimelineDateGap),
                  Text(
                    step.date,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTakenCard extends StatelessWidget {
  const _ActionTakenCard({required this.reportCase});

  final ArenaReportCaseDraft reportCase;

  @override
  Widget build(BuildContext context) {
    return _SectionBlock(
      title: 'Hành động đã thực hiện',
      accentColor: AppColors.warn,
      child: VitCard(
        density: VitDensity.compact,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ToneIcon(
                  icon: Icons.shield_outlined,
                  color: AppColors.buy,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hành động đã thực hiện',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        reportCase.actionTaken!,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.text1,
                          height: _reportActionLineHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (reportCase.systemNote != null) ...[
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              _SystemNotePanel(note: reportCase.systemNote!),
            ],
          ],
        ),
      ),
    );
  }
}
