part of 'network_status_tablet_page.dart';

class _NetworkStatusCard extends StatelessWidget {
  const _NetworkStatusCard({required this.network});

  final WalletNetworkInfo network;

  @override
  Widget build(BuildContext context) {
    final networkColor = Color(network.colorHex);
    final healthColor = _healthColor(network.health);
    final congestionColor = _congestionColor(network.congestionPct);
    return Semantics(
      label:
          '${network.name}: ${_healthLabel(network.health)}, tắc nghẽn ${network.congestionPct}%, phí ${network.gasFee}, xác nhận ${network.avgConfirmTime}',
      child: VitCard(
        padding: TabletSpacingTokens.zeroInsets,
        key: NetworkStatusTabletPage.networkKey(network.id),
        variant: VitCardVariant.inner,
        borderColor: healthColor.withValues(alpha: .34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                VitCard(
                  padding: TabletSpacingTokens.zeroInsets,
                  width: TabletSpacingTokens.buttonCompact,
                  height: TabletSpacingTokens.buttonCompact,
                  variant: VitCardVariant.ghost,
                  radius: VitCardRadius.tight,
                  background: ColoredBox(
                    color: networkColor.withValues(alpha: .1),
                  ),
                  clip: true,
                  alignment: Alignment.center,
                  child: Text(
                    network.symbol,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: AppTextStyles.micro.copyWith(
                      color: networkColor,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: TabletSpacingTokens.x4),
                      Text(
                        'Block #${network.blockHeight}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
                _HealthStatusIndicator(health: network.health),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Mức tải mạng',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                Text(
                  '${network.congestionPct}% · ${_congestionLabel(network.congestionPct)}',
                  style: AppTextStyles.micro.copyWith(
                    color: congestionColor,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            Semantics(
              label:
                  'Tắc nghẽn mạng ${network.congestionPct}%, ${_congestionLabel(network.congestionPct)}',
              child: ClipRRect(
                borderRadius: AppRadii.pillRadius,
                child: LinearProgressIndicator(
                  minHeight: TabletSpacingTokens.x1,
                  value: (network.congestionPct / 100).clamp(0, 1).toDouble(),
                  color: congestionColor.withValues(alpha: .55),
                  backgroundColor: congestionColor.withValues(alpha: .08),
                ),
              ),
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            _NetworkStatsGrid(network: network),
            const SizedBox(height: TabletSpacingTokens.x4),
            Row(
              children: [
                Expanded(
                  child: _AvailabilityChip(
                    label: 'Nạp',
                    enabled: network.depositEnabled,
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x4),
                Expanded(
                  child: _AvailabilityChip(
                    label: 'Rút',
                    enabled: network.withdrawEnabled,
                  ),
                ),
              ],
            ),
            if (network.notes case final note?) ...[
              const SizedBox(height: TabletSpacingTokens.x4),
              _NetworkNote(note: note),
            ],
          ],
        ),
      ),
    );
  }
}

class _NetworkStatsGrid extends StatelessWidget {
  const _NetworkStatsGrid({required this.network});

  final WalletNetworkInfo network;

  @override
  Widget build(BuildContext context) {
    final stats = <({IconData icon, String label, String value})>[
      (
        icon: Icons.schedule_rounded,
        label: 'Xác nhận',
        value: network.avgConfirmTime,
      ),
      (
        icon: Icons.monitor_heart_outlined,
        label: 'TX đang chờ',
        value: VitFormat.count(network.txPending),
      ),
      (icon: Icons.bolt_rounded, label: 'Gas / phí', value: network.gasFee),
      (
        icon: Icons.trending_up_rounded,
        label: 'Block mới',
        value: network.lastBlock,
      ),
    ];
    return Column(
      children: [
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              for (var col = 0; col < 2; col++) ...[
                Expanded(child: _NetworkStatTile(stat: stats[row * 2 + col])),
                if (col == 0) const SizedBox(width: TabletSpacingTokens.x4),
              ],
            ],
          ),
          if (row == 0) const SizedBox(height: TabletSpacingTokens.x4),
        ],
      ],
    );
  }
}

class _NetworkStatTile extends StatelessWidget {
  const _NetworkStatTile({required this.stat});

  final ({IconData icon, String label, String value}) stat;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TabletSpacingTokens.zeroInsets,
      variant: VitCardVariant.ghost,
      height: TabletSpacingTokens.buttonStandard,
      radius: VitCardRadius.tight,
      child: Row(
        children: [
          Icon(
            stat.icon,
            color: AppColors.text3,
            size: TabletSpacingTokens.iconSm,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthStatusIndicator extends StatelessWidget {
  const _HealthStatusIndicator({required this.health});

  final String health;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: _healthLabel(health),
      status: _healthStatus(health),
      icon: _healthIcon(health),
      size: VitStatusPillSize.sm,
    );
  }
}

class _AvailabilityChip extends StatelessWidget {
  const _AvailabilityChip({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TabletSpacingTokens.zeroInsets,
      variant: VitCardVariant.ghost,
      alignment: Alignment.center,
      child: VitStatusPill(
        label: '$label ${enabled ? 'Sẵn sàng' : 'Tạm dừng'}',
        status: enabled
            ? VitStatusPillStatus.success
            : VitStatusPillStatus.error,
        icon: enabled ? Icons.check_circle_outline : Icons.wifi_off_rounded,
        size: VitStatusPillSize.sm,
      ),
    );
  }
}

class _NetworkNote extends StatelessWidget {
  const _NetworkNote({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TabletSpacingTokens.zeroInsets,
      variant: VitCardVariant.ghost,
      radius: VitCardRadius.standard,
      background: ColoredBox(color: AppColors.caution.withValues(alpha: .06)),
      clip: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.caution,
            size: TabletSpacingTokens.iconSm,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Text(
              note,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkLegendCard extends StatelessWidget {
  const _NetworkLegendCard();

  @override
  Widget build(BuildContext context) {
    const states = <({String label, String health})>[
      (label: 'Hoạt động tốt', health: 'operational'),
      (label: 'Chậm', health: 'degraded'),
      (label: 'Tắc nghẽn', health: 'congested'),
      (label: 'Bảo trì', health: 'down'),
    ];
    return VitCard(
      padding: TabletSpacingTokens.zeroInsets,
      variant: VitCardVariant.inner,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chú thích trạng thái',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Wrap(
            spacing: TabletSpacingTokens.x1,
            runSpacing: TabletSpacingTokens.x1,
            children: [
              for (final state in states)
                VitStatusPill(
                  label: state.label,
                  status: _healthStatus(state.health),
                  icon: _healthIcon(state.health),
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

String _healthLabel(String health) => switch (health) {
  'operational' => 'Hoạt động tốt',
  'degraded' => 'Chậm',
  'congested' => 'Tắc nghẽn',
  'down' => 'Bảo trì',
  _ => 'Chưa xác định',
};

Color _healthColor(String health) => switch (health) {
  'operational' => AppColors.buy,
  'degraded' => AppColors.caution,
  'congested' => AppColors.riskHigh,
  'down' => AppColors.sell,
  _ => AppColors.text3,
};

VitStatusPillStatus _healthStatus(String health) => switch (health) {
  'operational' => VitStatusPillStatus.success,
  'degraded' => VitStatusPillStatus.warning,
  'congested' => VitStatusPillStatus.orange,
  'down' => VitStatusPillStatus.error,
  _ => VitStatusPillStatus.neutral,
};

IconData _healthIcon(String health) => switch (health) {
  'operational' => Icons.check_circle_outline_rounded,
  'degraded' => Icons.access_time_rounded,
  'congested' => Icons.warning_amber_rounded,
  'down' => Icons.wifi_off_rounded,
  _ => Icons.info_outline_rounded,
};

Color _congestionColor(int percentage) {
  if (percentage > 70) return AppColors.riskHigh;
  if (percentage > 40) return AppColors.caution;
  return AppColors.buy;
}

String _congestionLabel(int percentage) {
  if (percentage > 70) return 'Tắc nghẽn';
  if (percentage > 40) return 'Cao';
  if (percentage > 15) return 'Bình thường';
  return 'Thấp';
}
