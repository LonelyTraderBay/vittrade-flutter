part of '../../phone/pages/complaints/complaints_handling_page.dart';

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: VitMetricCard(
            label: 'Active',
            value: '${snapshot.activeCount}',
            density: VitDensity.tool,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: VitMetricCard(
            label: 'Resolved',
            value: '${snapshot.resolvedCount}',
            accentColor: _complaintsGreen,
            density: VitDensity.tool,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: VitMetricCard(
            label: 'Avg. Days',
            value: '${snapshot.averageResolutionDays}',
            density: VitDensity.tool,
          ),
        ),
      ],
    );
  }
}

class _SubmitComplaintButton extends StatelessWidget {
  const _SubmitComplaintButton();

  @override
  Widget build(BuildContext context) {
    return VitNextActionCard(
      key: ComplaintsHandlingPage.submitKey,
      icon: Icons.chat_bubble_outline_rounded,
      title: 'Submit a Complaint',
      subtitle: "We'll respond within 8 weeks",
      statusLabel: 'Regulated',
      ctaLabel: 'Start',
      accentColor: _complaintsPrimary,
      onTap: () => context.go(AppRoutePaths.tradeCopyComplaintSubmission),
    );
  }
}
