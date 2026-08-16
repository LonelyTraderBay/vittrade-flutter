part of '../../phone/pages/governance/my_arena_reports_page.dart';

class _ReportStatusPill extends StatelessWidget {
  const _ReportStatusPill({required this.status});

  final ArenaReportCaseStatus status;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: _statusLabel(status),
      status: _statusKind(status),
      icon: _statusIcon(status),
      size: VitStatusPillSize.sm,
    );
  }
}

Color _filterColor(MyArenaReportsFilterDraft filter) {
  return switch (filter.status) {
    ArenaReportCaseStatus.submitted => AppColors.primary,
    ArenaReportCaseStatus.underReview => AppColors.warn,
    ArenaReportCaseStatus.actionTaken => AppColors.buy,
    ArenaReportCaseStatus.closed => AppColors.text3,
    ArenaReportCaseStatus.appealOpen => AppColors.sell,
    null => AppColors.text3,
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
    ArenaReportTargetType.challenge => Icons.flag_outlined,
    ArenaReportTargetType.mode => Icons.description_outlined,
    ArenaReportTargetType.user => Icons.block,
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
