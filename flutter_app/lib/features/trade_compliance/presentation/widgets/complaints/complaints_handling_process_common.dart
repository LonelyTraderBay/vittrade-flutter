part of '../../phone/pages/complaints/complaints_handling_page.dart';

class _ProcessContent extends StatelessWidget {
  const _ProcessContent({required this.snapshot});

  final TradeComplaintsHandlingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'How We Handle Complaints',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        VitCard(
          density: VitDensity.tool,
          radius: VitCardRadius.tight,
          borderColor: _complaintsBorder.withValues(alpha: .76),
          child: Column(
            children: [
              for (final step in snapshot.processSteps) ...[
                _ProcessStep(step: step),
                if (step != snapshot.processSteps.last)
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              ],
            ],
          ),
        ),
        const VitSectionHeader(
          title: 'Financial Ombudsman Service',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        _OmbudsmanCard(ombudsman: snapshot.ombudsman),
      ],
    );
  }
}

class _ProcessStep extends StatelessWidget {
  const _ProcessStep({required this.step});

  final TradeComplaintProcessStep step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: _complaintsGreen,
          size: TradeSpacingTokens.complaintCaseActionIcon,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                step.description,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OmbudsmanCard extends StatelessWidget {
  const _OmbudsmanCard({required this.ombudsman});

  final TradeOmbudsmanInfo ombudsman;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _complaintsBorder.withValues(alpha: .76),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ombudsman.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCard(
            variant: VitCardVariant.inner,
            density: VitDensity.tool,
            radius: VitCardRadius.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact:',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Phone: ${ombudsman.phone}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Web: ${ombudsman.website}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text1),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          VitCtaButton(
            onPressed: () =>
                context.go(AppRoutePaths.tradeCopyOmbudsmanReferral),
            variant: VitCtaButtonVariant.secondary,
            density: VitDensity.tool,
            leading: const Icon(Icons.info_outline_rounded),
            child: const Text('Learn About Ombudsman Referral'),
          ),
        ],
      ),
    );
  }
}

IconData _iconForCategory(TradeComplaintCategoryIcon icon) {
  return switch (icon) {
    TradeComplaintCategoryIcon.trade => Icons.trending_up_rounded,
    TradeComplaintCategoryIcon.account => Icons.group_outlined,
    TradeComplaintCategoryIcon.payment => Icons.description_outlined,
    TradeComplaintCategoryIcon.service => Icons.chat_bubble_outline_rounded,
    TradeComplaintCategoryIcon.fees => Icons.bar_chart_rounded,
    TradeComplaintCategoryIcon.other => Icons.error_outline_rounded,
  };
}

({String label, Color color}) _statusPresentation(TradeComplaintStatus status) {
  return switch (status) {
    TradeComplaintStatus.submitted => (
      label: 'Submitted',
      color: _complaintsPrimary,
    ),
    TradeComplaintStatus.underReview => (
      label: 'Under Review',
      color: _complaintsAmber,
    ),
    TradeComplaintStatus.resolved => (
      label: 'Resolved',
      color: _complaintsGreen,
    ),
    TradeComplaintStatus.escalated => (
      label: 'Escalated',
      color: _complaintsRed,
    ),
  };
}
