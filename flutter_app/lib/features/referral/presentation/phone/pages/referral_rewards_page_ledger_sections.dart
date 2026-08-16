part of 'referral_rewards_page.dart';

const double _rewardChartExtent =
    AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x5 + AppSpacing.x4;

class _RewardChart extends StatelessWidget {
  const _RewardChart({required this.snapshot});

  final ReferralRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.chartKey,
      padding: ReferralSpacingTokens.referralChartPadding,
      child: SizedBox(
        height: _rewardChartExtent,
        child: CustomPaint(
          painter: _ReferralRewardChartPainter(snapshot.chartPoints),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final point in snapshot.chartPoints)
                  Text(
                    point.month,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardTabs extends StatelessWidget {
  const _RewardTabs({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralRewardFilterDraft> filters;
  final ReferralRewardFilter active;
  final ValueChanged<ReferralRewardFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSegmentedChoice<ReferralRewardFilter>(
      key: ReferralRewardsPage.tabsKey,
      selected: active,
      onChanged: onChanged,
      options: [
        for (final filter in filters)
          VitSegmentedChoiceOption(
            key: ReferralRewardsPage.tabKey(filter.filter),
            value: filter.filter,
            label: filter.label,
            accentColor: AppColors.primary,
          ),
      ],
    );
  }
}

class _SortRail extends StatelessWidget {
  const _SortRail({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralRewardSortDraft> options;
  final ReferralRewardSort active;
  final ValueChanged<ReferralRewardSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitSortRail<ReferralRewardSort>(
      key: ReferralRewardsPage.sortKey,
      selected: active,
      onChanged: onChanged,
      optionHeight: AppSpacing.buttonCompact - AppSpacing.x1,
      optionPadding: ReferralSpacingTokens.referralSortChipPadding,
      iconSize: ReferralSpacingTokens.referralSortIcon,
      options: [
        for (final option in options)
          VitSortRailOption(
            key: ReferralRewardsPage.sortOptionKey(option.sort),
            value: option.sort,
            label: option.label,
          ),
      ],
    );
  }
}

class _RewardLedger extends StatelessWidget {
  const _RewardLedger({required this.snapshot, required this.onReport});

  final ReferralRewardsSnapshot snapshot;
  final ValueChanged<ReferralRewardRecordDraft> onReport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.ledgerKey,
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: ReferralSpacingTokens.referralLedgerHeaderPadding,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Lịch sử thưởng',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
                if (snapshot.pendingCount > 0) ...[
                  VitStatusPill(
                    label: '${snapshot.pendingCount} đang chờ',
                    icon: Icons.schedule_rounded,
                    status: VitStatusPillStatus.warning,
                    size: VitStatusPillSize.sm,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(
                  '${snapshot.completedCount} hoàn tất',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.divider,
          ),
          if (snapshot.records.isEmpty)
            const Padding(
              padding: ReferralSpacingTokens.referralEmptyPadding,
              child: VitEmptyState(
                key: ReferralRewardsPage.emptyKey,
                title: 'Chưa có giao dịch',
                message: 'Thử thay đổi bộ lọc phần thưởng',
                icon: Icons.card_giftcard_rounded,
              ),
            )
          else
            for (var i = 0; i < snapshot.records.length; i++) ...[
              _RewardRecordRow(
                record: snapshot.records[i],
                onReport: () => onReport(snapshot.records[i]),
              ),
              if (i < snapshot.records.length - 1)
                const Divider(
                  height: AppSpacing.dividerHairline,
                  color: AppColors.divider,
                ),
            ],
        ],
      ),
    );
  }
}

class _RewardRecordRow extends StatelessWidget {
  const _RewardRecordRow({required this.record, required this.onReport});

  final ReferralRewardRecordDraft record;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final pending = record.status == ReferralRewardStatus.pending;
    final typeColor = switch (record.type) {
      ReferralRewardType.kycBonus => AppModuleAccents.neutral,
      ReferralRewardType.tradeCommission => AppColors.buy,
    };
    final amountColor = pending ? AppColors.warn : typeColor;

    return Opacity(
      opacity: pending ? 0.74 : 1,
      child: Padding(
        key: ReferralRewardsPage.recordKey(record.id),
        padding: ReferralSpacingTokens.referralLedgerHeaderPadding,
        child: Row(
          children: [
            _RecordIcon(type: record.type),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          record.friendName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (pending) ...[
                        const SizedBox(width: AppSpacing.x2),
                        const VitStatusPill(
                          label: 'Đang chờ',
                          status: VitStatusPillStatus.warning,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '${record.action} ${record.date}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${pending ? '~' : '+'}${_formatUsd(record.amount)}',
                  style: AppTextStyles.body.copyWith(
                    color: amountColor,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  record.currency,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            if (!pending) ...[
              const SizedBox(width: AppSpacing.x2),
              VitInlineIconAction(
                key: ReferralRewardsPage.reportKey(record.id),
                onPressed: onReport,
                icon: Icons.warning_amber_rounded,
                tooltip: 'Báo cáo phần thưởng',
                color: AppColors.warn,
                size: AppSpacing.iconMd,
                padding: AppSpacing.x2,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecordIcon extends StatelessWidget {
  const _RecordIcon({required this.type});

  final ReferralRewardType type;

  @override
  Widget build(BuildContext context) {
    final isKyc = type == ReferralRewardType.kycBonus;
    return SizedBox.square(
      dimension: AppSpacing.iconLg + AppSpacing.x3,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: isKyc ? AppColors.primary12 : AppColors.buy10,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
        ),
        child: Center(
          child: Icon(
            isKyc ? Icons.workspace_premium_rounded : Icons.trending_up_rounded,
            color: isKyc ? AppColors.primary : AppColors.buy,
            size: AppSpacing.iconMd,
          ),
        ),
      ),
    );
  }
}
