part of '../../phone/pages/staking/staking_institutional_page.dart';

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.snapshot});

  final StakingInstitutionalSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingInstitutionalPage.statsKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Row(
        children: [
          for (var i = 0; i < snapshot.stats.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.x3),
            Expanded(child: _StatTile(stat: snapshot.stats[i])),
          ],
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.stat});

  final StakingInstitutionalStatDraft stat;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(stat.tone);
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: _toneFillColor(stat.tone),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnCardPaddingX2X3,
        child: Column(
          children: [
            Icon(_infoIcon(stat.icon), color: color, size: AppSpacing.iconSm),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                stat.value,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: stat.tone == 'success'
                      ? AppModuleAccents.earn
                      : AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              stat.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _BatchTabs extends StatelessWidget {
  const _BatchTabs({required this.active, required this.onChanged});

  final _InstitutionalBatchTab active;
  final ValueChanged<_InstitutionalBatchTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      key: StakingInstitutionalPage.tabsKey,
      variant: VitTabBarVariant.segment,
      activeKey: active.name,
      onChanged: (key) => onChanged(_InstitutionalBatchTab.values.byName(key)),
      tabs: [
        for (final tab in _InstitutionalBatchTab.values)
          VitTabItem(
            key: tab.name,
            label: _tabLabel(tab),
            widgetKey: StakingInstitutionalPage.tabKey(tab.name),
          ),
      ],
    );
  }
}

class _BatchOperationCard extends StatelessWidget {
  const _BatchOperationCard({required this.batch});

  final StakingInstitutionalBatchDraft batch;

  @override
  Widget build(BuildContext context) {
    final progress = batch.approvals / batch.requiredApprovals;
    return VitCard(
      key: StakingInstitutionalPage.batchKey(batch.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Batch ${_batchTypeLabel(batch.type)}',
                      style: AppTextStyles.baseMedium,
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${batch.operations} operations - ${_formatAmount(batch.totalAmount)} ETH',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              VitStatusPill(
                label: _statusLabel(batch.status),
                status: switch (batch.status) {
                  StakingInstitutionalBatchStatus.pending =>
                    VitStatusPillStatus.warning,
                  StakingInstitutionalBatchStatus.approved =>
                    VitStatusPillStatus.info,
                  StakingInstitutionalBatchStatus.executed =>
                    VitStatusPillStatus.success,
                },
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          if (batch.status != StakingInstitutionalBatchStatus.executed) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Approvals',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                Text(
                  '${batch.approvals}/${batch.requiredApprovals}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
            ClipRRect(
              borderRadius: AppRadii.xsRadius,
              child: LinearProgressIndicator(
                minHeight: AppSpacing.x2,
                value: progress,
                backgroundColor: AppColors.surface3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  batch.status == StakingInstitutionalBatchStatus.approved
                      ? AppColors.buy
                      : AppColors.warn,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            height: EarnSpacingTokens.stakingProductDividerHeight,
            color: AppColors.borderSolid,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  batch.created,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              if (batch.status == StakingInstitutionalBatchStatus.pending)
                const _InlineAction(label: 'Approve', color: AppColors.primary)
              else if (batch.status == StakingInstitutionalBatchStatus.approved)
                const _InlineAction(label: 'Execute', color: AppColors.buy),
            ],
          ),
        ],
      ),
    );
  }
}

class _InlineAction extends StatelessWidget {
  const _InlineAction({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: HapticFeedback.selectionClick,
      variant: color == AppColors.buy
          ? VitCtaButtonVariant.success
          : VitCtaButtonVariant.primary,
      fullWidth: false,
      height: AppSpacing.buttonCompact,
      padding: EarnSpacingTokens.earnWidePillPadding,
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.onAccent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}
