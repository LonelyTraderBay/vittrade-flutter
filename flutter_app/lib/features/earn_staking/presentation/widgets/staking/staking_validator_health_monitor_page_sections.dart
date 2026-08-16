part of '../../phone/pages/staking/staking_validator_health_monitor_page.dart';

class _SummaryStats extends StatelessWidget {
  const _SummaryStats({required this.snapshot});

  final StakingValidatorHealthMonitorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingValidatorHealthMonitorPage.statsKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          Expanded(
            child: _SummaryTile(
              icon: Icons.check_circle_outline_rounded,
              label: 'Healthy',
              value: snapshot.healthyCount.toString(),
              color: AppColors.buy,
              borderColor: AppColors.buy20,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              icon: Icons.error_outline_rounded,
              label: 'Warning',
              value: snapshot.warningCount.toString(),
              color: AppColors.warn,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryTile(
              icon: Icons.monitor_heart_outlined,
              label: 'Avg Uptime',
              value: '${snapshot.averageUptime.toStringAsFixed(2)}%',
              color: AppColors.text2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.borderColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: borderColor,
      padding: EarnSpacingTokens.earnCardPaddingX3X2,
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(
                color: color == AppColors.text2 ? AppColors.text1 : color,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ValidatorCard extends StatelessWidget {
  const _ValidatorCard({
    required this.validator,
    required this.selected,
    required this.onTap,
  });

  final StakingValidatorHealthDraft validator;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(validator.status);
    return VitCard(
      key: StakingValidatorHealthMonitorPage.validatorKey(validator.id),
      radius: VitCardRadius.large,
      onTap: onTap,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSpacing.x6,
                height: AppSpacing.x6,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppRadii.lgRadius,
                    ),
                  ),
                  child: Icon(
                    _statusIcon(validator.status),
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            validator.name,
                            style: AppTextStyles.baseMedium,
                          ),
                        ),
                        VitStatusPill(
                          label: _statusLabel(validator.status),
                          status: _validatorVitStatus(validator.status),
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      validator.address,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.show_chart_rounded,
                          color: statusColor,
                          size: AppSpacing.iconSm,
                        ),
                        Text(
                          '${_formatPercent(validator.uptime)} uptime',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                        const CircleAvatar(
                          radius: 2,
                          backgroundColor: AppColors.borderSolid,
                        ),
                        Text(
                          '${_formatPercent(validator.apr)} APR',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              Expanded(
                child: _ValidatorMetric(
                  label: 'Staked',
                  value: '${_formatEth(validator.totalStakedEth)} ETH',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ValidatorMetric(
                  label: 'Commission',
                  value: '${validator.commission}%',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: _ValidatorMetric(
                  label: 'Missed Blocks',
                  value: validator.missedBlocks.toString(),
                  color: validator.missedBlocks > 10
                      ? AppColors.warn
                      : AppColors.text1,
                ),
              ),
            ],
          ),
          if (selected) ...[
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            const Divider(
              color: AppColors.borderSolid,
              height: AppSpacing.dividerHairline,
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Last Block Produced',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  validator.lastBlock,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Row(
              children: [
                const Expanded(child: _SmallButton(label: 'View Details')),
                if (validator.status == 'warning') ...[
                  const SizedBox(width: AppSpacing.x2),
                  const Expanded(
                    child: _SmallButton(
                      label: 'Rebalance Stake',
                      color: AppColors.sell,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ValidatorMetric extends StatelessWidget {
  const _ValidatorMetric({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendSection extends StatelessWidget {
  const _TrendSection({required this.points});

  final List<StakingUptimeHistoryPointDraft> points;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingValidatorHealthMonitorPage.trendKey,
      label: '7-Day Uptime Trend',
      accentColor: AppColors.primarySoft,
      children: [
        VitCard(
          radius: VitCardRadius.large,
          padding: EarnSpacingTokens.earnCardPaddingX3,
          child: Column(
            children: [
              SizedBox(
                height: AppSpacing.x7 * 2 + AppSpacing.x4,
                child: CustomPaint(
                  painter: _UptimeTrendPainter(points),
                  child: const SizedBox.expand(),
                ),
              ),
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
              const Wrap(
                alignment: WrapAlignment.center,
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x2,
                children: [
                  _LegendEntry(label: 'Validator #1', color: AppColors.buy),
                  _LegendEntry(
                    label: 'Validator #2',
                    color: AppColors.primarySoft,
                  ),
                  _LegendEntry(label: 'Validator #3', color: AppColors.warn),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
