part of '../../phone/pages/safety/dispute_resolution_page.dart';

class _DisputeTabs extends StatelessWidget {
  const _DisputeTabs({
    required this.tabs,
    required this.activeId,
    required this.onChanged,
  });

  final List<TradeDisputeTab> tabs;
  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: VitCard(
                key: DisputeResolutionPage.tabKey(tab.id),
                onTap: () => onChanged(tab.id),
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.tight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(
                        vertical: AppSpacing.x2,
                        horizontal: AppSpacing.x1,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              tab.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: tab.id == activeId
                                    ? _disputePrimary
                                    : AppColors.text3,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                          if (tab.badgeCount != null) ...[
                            const SizedBox(width: AppSpacing.x1),
                            _TabBadge(tab.badgeCount!),
                          ],
                        ],
                      ),
                    ),
                    // card-tile: allow-start — fixed surface, not horizontal strip tile
                    VitCard(
                      width: tab.id == activeId
                          ? TradeSpacingTokens.tradeBotDisputeTabIndicatorWidth
                          : 0,
                      height: AppSpacing.dividerHairline,
                      variant: VitCardVariant.inner,
                      radius: VitCardRadius.tight,
                      borderColor: _disputePrimary,
                      background: const ColoredBox(color: _disputePrimary),
                      child: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TabBadge extends StatelessWidget {
  const _TabBadge(this.count);

  final int count;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: '$count',
      accentColor: _disputePrimary,
      size: VitStatusPillSize.sm,
    );
  }
}

class _CasesTab extends StatelessWidget {
  const _CasesTab({
    required this.activeTabId,
    required this.snapshot,
    required this.lastResult,
  });

  final String activeTabId;
  final TradeDisputeResolutionSnapshot snapshot;
  final TradeDisputeSubmissionResult? lastResult;

  @override
  Widget build(BuildContext context) {
    final cases = activeTabId == 'history'
        ? snapshot.resolvedCases
        : snapshot.activeCases;
    return VitPageContent(
      rhythm: VitPageRhythm.form,
      padding: VitContentPadding.none,
      fullBleed: true,
      density: VitDensity.tool,
      children: [
        if (lastResult != null && activeTabId == 'active')
          _ResultBanner(result: lastResult!),
        if (cases.isEmpty)
          _EmptyCases(history: activeTabId == 'history')
        else
          for (final disputeCase in cases)
            _DisputeCaseCard(disputeCase: disputeCase),
      ],
    );
  }
}

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({required this.result});

  final TradeDisputeSubmissionResult result;

  @override
  Widget build(BuildContext context) {
    return VitHighRiskStatePanel(
      state: VitHighRiskUiState.success,
      density: VitDensity.tool,
      title: '${result.message}: ${result.caseId}',
      message: 'Case is now available in Active Cases.',
      contractId: result.caseId,
    );
  }
}

class _DisputeCaseCard extends StatelessWidget {
  const _DisputeCaseCard({required this.disputeCase});

  final TradeDisputeCase disputeCase;

  @override
  Widget build(BuildContext context) {
    final resolved = disputeCase.status == 'resolved';
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      borderColor: AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (resolved)
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: 15,
                )
              else
                VitStatusPill(
                  label: _statusLabel(disputeCase.status).toUpperCase(),
                  status: _statusPillStatus(disputeCase.status),
                  size: VitStatusPillSize.sm,
                ),
              const SizedBox(width: TradeSpacingTokens.tradeBotSmallGap),
              Expanded(
                child: Text(
                  resolved
                      ? _outcomeLabel(disputeCase.outcome)
                      : 'Case #${disputeCase.id}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: resolved ? AppColors.buy : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            disputeCase.subject,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Provider: ${disputeCase.providerName}',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            disputeCase.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          if (!resolved)
            _CaseTimeline(disputeCase: disputeCase)
          else
            _RefundPanel(disputeCase: disputeCase),
          if (!resolved) ...[
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            VitCtaButton(
              onPressed: () => _escalate(context),
              variant: VitCtaButtonVariant.danger,
              density: VitDensity.tool,
              child: const Text('Escalate to Senior Support'),
            ),
          ],
        ],
      ),
    );
  }

  void _escalate(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(
        context: context,
        title: 'Escalate to Senior Support',
        message: 'Chuyển lên hỗ trợ cấp cao sẽ sớm ra mắt',
      ),
    );
  }
}
