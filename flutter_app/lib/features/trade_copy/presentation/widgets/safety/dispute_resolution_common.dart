part of '../../phone/pages/safety/dispute_resolution_page.dart';

class _CaseTimeline extends StatelessWidget {
  const _CaseTimeline({required this.disputeCase});

  final TradeDisputeCase disputeCase;

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('submitted', 'Complaint submitted'),
      ('under_review', 'Under review by support team'),
      ('provider_response', 'Awaiting provider response'),
      ('resolved', 'Resolution'),
    ];
    return Column(
      children: [
        for (final step in steps) ...[
          _TimelineRow(
            done: _stepDone(step.$1, disputeCase.status),
            label: step.$2,
            date: step.$1 == 'submitted'
                ? disputeCase.submittedDate
                : step.$1 == disputeCase.status
                ? disputeCase.updatedDate
                : '',
          ),
          if (step != steps.last) const SizedBox(height: AppSpacing.x1),
        ],
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.done,
    required this.label,
    required this.date,
  });

  final bool done;
  final String label;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          done ? Icons.check_circle_outline_rounded : Icons.schedule_rounded,
          color: done ? AppColors.buy : AppColors.text3,
          size: TradeSpacingTokens.tradeBotSmallIcon,
        ),
        const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: done ? AppColors.text1 : AppColors.text3,
                  fontWeight: done ? AppTextStyles.bold : AppTextStyles.normal,
                ),
              ),
              if (date.isNotEmpty)
                Text(
                  date,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RefundPanel extends StatelessWidget {
  const _RefundPanel({required this.disputeCase});

  final TradeDisputeCase disputeCase;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Text(
        '\$5 refund issued to your account',
        style: AppTextStyles.micro.copyWith(color: AppColors.buy),
      ),
    );
  }
}

class _EmptyCases extends StatelessWidget {
  const _EmptyCases({required this.history});

  final bool history;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      title: history ? 'No resolved cases yet' : 'No active cases',
      icon: history
          ? Icons.description_outlined
          : Icons.check_circle_outline_rounded,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.micro.copyWith(color: AppColors.text2),
    );
  }
}

VitStatusPillStatus _statusPillStatus(String status) {
  switch (status) {
    case 'under_review':
      return VitStatusPillStatus.info;
    case 'provider_response':
      return VitStatusPillStatus.warning;
    case 'resolved':
      return VitStatusPillStatus.success;
    case 'escalated':
      return VitStatusPillStatus.error;
    default:
      return VitStatusPillStatus.neutral;
  }
}

String _statusLabel(String status) {
  switch (status) {
    case 'under_review':
      return 'Under Review';
    case 'provider_response':
      return 'Provider Responded';
    case 'resolved':
      return 'Resolved';
    case 'escalated':
      return 'Escalated';
    default:
      return 'Submitted';
  }
}

String _outcomeLabel(String? outcome) {
  switch (outcome) {
    case 'refund':
      return 'Refund Issued';
    case 'warning':
      return 'Provider Warned';
    case 'suspension':
      return 'Provider Suspended';
    case 'no_action':
      return 'No Action Required';
    default:
      return 'Pending';
  }
}

bool _stepDone(String step, String status) {
  const order = ['submitted', 'under_review', 'provider_response', 'resolved'];
  return order.indexOf(step) <= order.indexOf(status);
}
