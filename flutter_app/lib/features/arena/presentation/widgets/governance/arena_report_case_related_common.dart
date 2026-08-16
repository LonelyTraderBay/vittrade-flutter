part of '../../phone/pages/governance/arena_report_case_page.dart';

class _RelatedReports extends StatelessWidget {
  const _RelatedReports({required this.reports});

  final List<ArenaReportCaseDraft> reports;

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        for (final report in reports)
          Padding(
            padding: EdgeInsetsDirectional.only(
              bottom: report == reports.last ? 0 : AppSpacing.x3,
            ),
            child: VitCard(
              key: ArenaReportCasePage.relatedReportKey(report.id),
              onTap: () {
                unawaited(HapticFeedback.selectionClick());
                context.go(AppRoutePaths.arenaReportCase(report.id));
              },
              density: VitDensity.compact,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${report.targetName} - ${report.reason}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.medium,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          report.createdAt,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  _ReportStatusPill(
                    status: report.status,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  const _DisclaimerCard({required this.disclaimer});

  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      density: VitDensity.compact,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.accent,
            size: _reportInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              disclaimer,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: _reportNoticeLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    required this.accentColor,
    required this.child,
  });

  final String title;
  final Color accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              width: _reportMarkerWidth,
              height: _reportMarkerHeight,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: accentColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        child,
      ],
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _reportToneIconBox,
      height: _reportToneIconBox,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color.withValues(alpha: 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadii.smRadius,
            side: BorderSide(color: color.withValues(alpha: 0.22)),
          ),
        ),
        child: Center(
          child: Icon(icon, color: color, size: _reportToneIcon),
        ),
      ),
    );
  }
}

class _ReportStatusPill extends StatelessWidget {
  const _ReportStatusPill({
    required this.status,
    this.size = VitStatusPillSize.md,
  });

  final ArenaReportCaseStatus status;
  final VitStatusPillSize size;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: _statusLabel(status),
      status: _statusKind(status),
      icon: _statusIcon(status),
      size: size,
    );
  }
}

String _primaryCtaLabel(ArenaReportCaseDraft reportCase) {
  return switch (reportCase.status) {
    ArenaReportCaseStatus.submitted ||
    ArenaReportCaseStatus.underReview ||
    ArenaReportCaseStatus.closed => 'Đóng',
    ArenaReportCaseStatus.actionTaken =>
      reportCase.relatedChallengeId == null ? 'Đóng' : 'Xem challenge',
    ArenaReportCaseStatus.appealOpen => 'Mở khiếu nại',
  };
}

String _statusLabel(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => 'Đã gửi',
    ArenaReportCaseStatus.underReview => 'Đang xem xét',
    ArenaReportCaseStatus.actionTaken => 'Đã xử lý',
    ArenaReportCaseStatus.closed => 'Đã đóng',
    ArenaReportCaseStatus.appealOpen => 'Đang khiếu nại',
  };
}

VitStatusPillStatus _statusKind(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => VitStatusPillStatus.info,
    ArenaReportCaseStatus.underReview => VitStatusPillStatus.warning,
    ArenaReportCaseStatus.actionTaken => VitStatusPillStatus.success,
    ArenaReportCaseStatus.closed => VitStatusPillStatus.neutral,
    ArenaReportCaseStatus.appealOpen => VitStatusPillStatus.error,
  };
}

IconData _statusIcon(ArenaReportCaseStatus status) {
  return switch (status) {
    ArenaReportCaseStatus.submitted => Icons.description_outlined,
    ArenaReportCaseStatus.underReview => Icons.schedule_outlined,
    ArenaReportCaseStatus.actionTaken => Icons.check_circle_outline,
    ArenaReportCaseStatus.closed => Icons.lock_outline,
    ArenaReportCaseStatus.appealOpen => Icons.warning_amber_rounded,
  };
}

IconData _targetIcon(ArenaReportTargetType targetType) {
  return switch (targetType) {
    ArenaReportTargetType.challenge => Icons.emoji_events_outlined,
    ArenaReportTargetType.mode => Icons.description_outlined,
    ArenaReportTargetType.user => Icons.person_outline,
  };
}

Color _targetColor(ArenaReportTargetType targetType) {
  return switch (targetType) {
    ArenaReportTargetType.challenge => AppColors.warn,
    ArenaReportTargetType.mode => AppColors.accent,
    ArenaReportTargetType.user => AppColors.sell,
  };
}

String _targetLabel(ArenaReportTargetType targetType) {
  return switch (targetType) {
    ArenaReportTargetType.challenge => 'Challenge',
    ArenaReportTargetType.mode => 'Mode',
    ArenaReportTargetType.user => 'Người dùng',
  };
}
