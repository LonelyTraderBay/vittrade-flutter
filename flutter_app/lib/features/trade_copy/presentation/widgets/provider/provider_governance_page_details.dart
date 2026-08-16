part of '../../phone/pages/provider/provider_governance_page.dart';

class _ModificationCard extends StatelessWidget {
  const _ModificationCard({required this.modification});

  final TradeStrategyModification modification;

  @override
  Widget build(BuildContext context) {
    final typeColor = _modificationColor(modification.type);
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitAccentPill(
                label: modification.type.replaceAll('_', ' ').toUpperCase(),
                accentColor: typeColor,
              ),
              const SizedBox(width: AppSpacing.x3),
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: TradeSpacingTokens.providerGovernanceModificationIcon,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Change:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              Text(
                modification.oldValue,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: TradeSpacingTokens.providerGovernanceModificationIcon,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  modification.newValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: TradeSpacingTokens.providerGovernanceMetaIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                modification.date,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(
                width: TradeSpacingTokens.providerGovernanceMetaGap,
              ),
              const Icon(
                Icons.group_outlined,
                color: AppColors.text3,
                size: TradeSpacingTokens.providerGovernanceMetaIcon,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  '${modification.followerImpact} followers impacted',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          const VitAccentPill(
            label: 'Notification sent 24h before implementation',
            accentColor: AppColors.buy,
            size: VitStatusPillSize.md,
          ),
        ],
      ),
    );
  }
}

class _RequestButton extends StatelessWidget {
  const _RequestButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: ProviderGovernancePage.requestActionKey,
      onPressed: onPressed,
      density: VitDensity.tool,
      leading: const Icon(Icons.edit_outlined),
      child: const Text('Request Strategy Modification'),
    );
  }
}

class _CommunicationTab extends StatelessWidget {
  const _CommunicationTab({required this.snapshot, required this.onBroadcast});

  final TradeProviderGovernanceSnapshot snapshot;
  final VoidCallback onBroadcast;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      fullBleed: true,
      children: [
        _RequestButton(onPressed: onBroadcast),
        for (final message in snapshot.messages)
          _SimplePanel(
            title: message.subject,
            body:
                '${message.recipients} recipients · ${message.openRate}% open rate · ${message.date}',
          ),
      ],
    );
  }
}

class _FeesTab extends StatelessWidget {
  const _FeesTab({required this.snapshot});

  final TradeProviderGovernanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      fullBleed: true,
      children: [
        _SimplePanel(
          title: 'Performance Fee Waterfall',
          body:
              'This Month \$${snapshot.stats.monthlyFeesEarned.toStringAsFixed(0)} · All-Time \$${snapshot.stats.allTimeFeesEarned.toStringAsFixed(0)}',
        ),
        for (final contributor in snapshot.feeContributors)
          _SimplePanel(
            title: contributor.name,
            body:
                'Profit \$${contributor.profit.toStringAsFixed(0)} · Fee \$${contributor.fee.toStringAsFixed(0)}',
          ),
      ],
    );
  }
}

class _ComplianceTab extends StatelessWidget {
  const _ComplianceTab({required this.snapshot});

  final TradeProviderGovernanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      density: VitDensity.tool,
      fullBleed: true,
      children: [
        for (final item in snapshot.complianceItems)
          _SimplePanel(
            title: item.item,
            body: 'Last check: ${item.lastCheck}',
            leading: Icons.check_circle_outline_rounded,
          ),
        _SimplePanel(
          title: 'Compliance Score: ${snapshot.stats.complianceScore}/100',
          body: 'Excellent standing — All requirements met',
        ),
      ],
    );
  }
}

class _SimplePanel extends StatelessWidget {
  const _SimplePanel({required this.title, required this.body, this.leading});

  final String title;
  final String body;
  final IconData? leading;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Row(
        children: [
          if (leading != null) ...[
            Icon(leading, color: AppColors.buy, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x2),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  body,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
