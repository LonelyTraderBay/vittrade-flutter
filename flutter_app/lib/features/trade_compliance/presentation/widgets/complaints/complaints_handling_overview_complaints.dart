part of '../../phone/pages/complaints/complaints_handling_page.dart';

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.snapshot});

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
          title: 'Complaint Categories',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        _CategoryGrid(categories: snapshot.categories),
        const VitSectionHeader(
          title: 'Resolution Timeline',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        _TimelineCard(timeline: snapshot.timeline),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<TradeComplaintCategory> categories;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.x2;
        final columns = constraints.maxWidth >= 360 ? 2 : 1;
        final tileWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final category in categories)
              SizedBox(
                width: tileWidth,
                child: VitCard(
                  density: VitDensity.tool,
                  radius: VitCardRadius.tight,
                  borderColor: _complaintsBorder.withValues(alpha: .76),
                  child: Row(
                    children: [
                      Icon(
                        _iconForCategory(category.icon),
                        color: _complaintsPrimary,
                        size: TradeSpacingTokens.complaintCaseSmallIcon,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          category.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.timeline});

  final List<TradeComplaintTimelineStep> timeline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _complaintsBorder.withValues(alpha: .76),
      child: Column(
        children: [
          for (final item in timeline) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: AppSpacing.x3,
                  backgroundColor: AppColors.surface2,
                  child: Text(
                    '${item.step}',
                    style: AppTextStyles.caption.copyWith(
                      color: _complaintsPrimary,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        item.time,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (item != timeline.last)
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          ],
        ],
      ),
    );
  }
}

class _MyComplaintsContent extends StatelessWidget {
  const _MyComplaintsContent({required this.complaints});

  final List<TradeComplaint> complaints;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        const VitSectionHeader(
          title: 'Your Complaints',
          bottomGap: AppSpacing.pageRhythmStandardInnerGap,
          variant: VitSectionHeaderVariant.accentBar,
          accentColor: _complaintsPrimary,
        ),
        for (final complaint in complaints)
          _ComplaintCard(complaint: complaint),
      ],
    );
  }
}

class _ComplaintCard extends StatelessWidget {
  const _ComplaintCard({required this.complaint});

  final TradeComplaint complaint;

  @override
  Widget build(BuildContext context) {
    final status = _statusPresentation(complaint.status);
    return VitCard(
      key: ComplaintsHandlingPage.complaintKey(complaint.id),
      onTap: () =>
          context.go(AppRoutePaths.tradeCopyComplaintTracking(complaint.id)),
      density: VitDensity.tool,
      radius: VitCardRadius.tight,
      borderColor: _complaintsBorder.withValues(alpha: .76),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: WalletSpacingTokens.walletAddressIconSize,
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              color: status.color,
              size: TradeSpacingTokens.complaintCaseTrailingIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x3,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      complaint.id,
                      style: AppTextStyles.monoCode.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    VitAccentPill(
                      label: status.label,
                      accentColor: status.color,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  complaint.subject,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${complaint.category} - Submitted ${complaint.submittedDate}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: TradeSpacingTokens.complaintCaseSmallIcon,
          ),
        ],
      ),
    );
  }
}
