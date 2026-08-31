import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for network monitoring SC-155.
class NetworkStatusTabletPage extends ConsumerStatefulWidget {
  const NetworkStatusTabletPage({super.key});

  static const contentKey = Key('sc155_network_status_tablet_content');
  static const refreshKey = Key('sc155_network_status_refresh_tablet');
  static const refreshFeedbackKey = Key(
    'sc155_network_status_refresh_feedback_tablet',
  );
  static Key filterKey(String id) =>
      Key('sc155_network_status_filter_tablet_$id');
  static Key networkKey(String id) => Key('sc155_network_status_tablet_$id');

  @override
  ConsumerState<NetworkStatusTabletPage> createState() =>
      _NetworkStatusTabletPageState();
}

enum _NetworkStatusFilter { all, issues, maintenance }

extension on _NetworkStatusFilter {
  String get key => switch (this) {
    _NetworkStatusFilter.all => 'all',
    _NetworkStatusFilter.issues => 'issues',
    _NetworkStatusFilter.maintenance => 'maintenance',
  };

  String get label => switch (this) {
    _NetworkStatusFilter.all => 'Tất cả',
    _NetworkStatusFilter.issues => 'Cần chú ý',
    _NetworkStatusFilter.maintenance => 'Bảo trì',
  };

  IconData get icon => switch (this) {
    _NetworkStatusFilter.all => Icons.hub_outlined,
    _NetworkStatusFilter.issues => Icons.warning_amber_rounded,
    _NetworkStatusFilter.maintenance => Icons.wifi_off_rounded,
  };

  bool includes(WalletNetworkInfo network) => switch (this) {
    _NetworkStatusFilter.all => true,
    _NetworkStatusFilter.issues => network.health != 'operational',
    _NetworkStatusFilter.maintenance => network.health == 'down',
  };
}

class _NetworkStatusTabletPageState
    extends ConsumerState<NetworkStatusTabletPage> {
  _NetworkStatusFilter _filter = _NetworkStatusFilter.all;
  String? _refreshFeedback;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletNetworkStatusProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được trạng thái mạng',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletNetworkStatusProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) => _frame(
        primary: _buildPrimary(snapshot),
        secondary: _buildSecondary(snapshot),
      ),
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Trạng thái mạng trên tablet',
      semanticIdentifier: 'SC-155-TABLET',
      title: 'Trạng thái mạng',
      subtitle: 'Phí · độ trễ · tắc nghẽn · khả dụng',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(WalletNetworkStatusSnapshot snapshot) {
    final networks = _visibleNetworks(snapshot.networks);
    return Column(
      key: NetworkStatusTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Xem lại trạng thái mạng',
          message:
              'Kiểm tra phí, độ trễ, tắc nghẽn và trạng thái nạp/rút trước khi giao dịch.',
          density: VitDensity.compact,
        ),
        _buildSummary(snapshot),
        VitPageSection(
          label: 'Bộ lọc mạng',
          headerIcon: Icons.filter_alt_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitTabBar(
              variant: VitTabBarVariant.segment,
              activeKey: _filter.key,
              onChanged: (key) => setState(() {
                _filter = _filterFromKey(key);
              }),
              tabs: [
                for (final filter in _NetworkStatusFilter.values)
                  VitTabItem(
                    key: filter.key,
                    label: _filterLabel(filter, snapshot),
                    icon: filter.icon,
                    widgetKey: NetworkStatusTabletPage.filterKey(filter.key),
                  ),
              ],
            ),
          ],
        ),
        VitPageSection(
          label: _filter == _NetworkStatusFilter.all
              ? 'Mạng theo mức ưu tiên'
              : '${_filter.label} (${networks.length})',
          headerIcon: Icons.route_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            if (networks.isEmpty)
              const VitEmptyState(
                title: 'Không có mạng phù hợp',
                message:
                    'Thử bộ lọc khác hoặc làm mới trạng thái mạng để cập nhật dữ liệu.',
                icon: Icons.wifi_find_rounded,
              )
            else
              for (final network in networks)
                _NetworkStatusCard(network: network),
          ],
        ),
      ],
    );
  }

  Widget _buildSummary(WalletNetworkStatusSnapshot snapshot) {
    final summaryColor = snapshot.downCount > 0
        ? AppColors.sell
        : snapshot.issueCount > 0
        ? AppColors.caution
        : AppColors.buy;
    final summaryMessage = snapshot.downCount > 0
        ? '${snapshot.downCount} mạng đang bảo trì'
        : snapshot.issueCount > 0
        ? '${snapshot.issueCount} mạng cần chú ý'
        : 'Tất cả mạng hoạt động tốt';

    return VitCard(
      variant: VitCardVariant.hero,
      borderColor: summaryColor.withValues(alpha: .34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitCard(
                width: AppSpacing.iconLg,
                height: AppSpacing.iconLg,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.standard,
                borderColor: summaryColor.withValues(alpha: .34),
                background: ColoredBox(
                  color: summaryColor.withValues(alpha: .08),
                ),
                clip: true,
                alignment: Alignment.center,
                child: Icon(
                  snapshot.downCount > 0
                      ? Icons.wifi_off_rounded
                      : Icons.wifi_rounded,
                  color: summaryColor,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summaryMessage,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      'Tự động cập nhật mỗi ${snapshot.refreshIntervalSeconds} giây',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              VitIconButton(
                key: NetworkStatusTabletPage.refreshKey,
                icon: Icons.refresh_rounded,
                tooltip: 'Làm mới trạng thái mạng',
                onPressed: _refreshNetworkStatus,
                size: VitIconButtonSize.sm,
              ),
            ],
          ),
          if (_refreshFeedback != null) ...[
            const SizedBox(height: AppSpacing.x4),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: VitStatusPill(
                key: NetworkStatusTabletPage.refreshFeedbackKey,
                label: _refreshFeedback!,
                status: VitStatusPillStatus.info,
                icon: Icons.check_circle_outline_rounded,
                size: VitStatusPillSize.sm,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _SummaryStat(
                value: '${snapshot.operationalCount}',
                label: 'Hoạt động',
                color: AppColors.buy,
              ),
              const SizedBox(width: AppSpacing.x4),
              _SummaryStat(
                value: '${snapshot.issueCount}',
                label: 'Chậm / tắc',
                color: AppColors.caution,
              ),
              const SizedBox(width: AppSpacing.x4),
              _SummaryStat(
                value: '${snapshot.downCount}',
                label: 'Bảo trì',
                color: AppColors.sell,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecondary(WalletNetworkStatusSnapshot snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Tổng quan hệ thống',
          headerIcon: Icons.monitor_heart_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  VitInfoRow(
                    label: 'Tổng số mạng',
                    value: '${snapshot.networks.length}',
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Đang hoạt động',
                    value: '${snapshot.operationalCount}',
                    valueColor: AppColors.buy,
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Đang cần chú ý',
                    value: '${snapshot.issueCount}',
                    valueColor: AppColors.caution,
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Đang bảo trì',
                    value: '${snapshot.downCount}',
                    valueColor: AppColors.sell,
                    density: VitDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
        const _NetworkLegendCard(),
        const VitCard(
          variant: VitCardVariant.ghost,
          child: Text(
            'Dữ liệu được cập nhật tự động. Thời gian xác nhận thực tế có thể khác tùy phí gas và mức tải mạng tại thời điểm giao dịch.',
          ),
        ),
      ],
    );
  }

  List<WalletNetworkInfo> _visibleNetworks(List<WalletNetworkInfo> networks) {
    return [...networks.where(_filter.includes)]..sort((a, b) {
      final priority = _networkPriority(a).compareTo(_networkPriority(b));
      if (priority != 0) return priority;
      return b.congestionPct.compareTo(a.congestionPct);
    });
  }

  void _refreshNetworkStatus() {
    ref.invalidate(walletNetworkStatusProvider);
    setState(() {
      _refreshFeedback = 'Đã làm mới trạng thái mạng';
    });
  }
}

_NetworkStatusFilter _filterFromKey(String key) =>
    _NetworkStatusFilter.values.firstWhere(
      (filter) => filter.key == key,
      orElse: () => _NetworkStatusFilter.all,
    );

String _filterLabel(
  _NetworkStatusFilter filter,
  WalletNetworkStatusSnapshot snapshot,
) => switch (filter) {
  _NetworkStatusFilter.all => '${filter.label} ${snapshot.networks.length}',
  _NetworkStatusFilter.issues =>
    '${filter.label} ${snapshot.issueCount + snapshot.downCount}',
  _NetworkStatusFilter.maintenance => '${filter.label} ${snapshot.downCount}',
};

int _networkPriority(WalletNetworkInfo network) => switch (network.health) {
  'down' => 0,
  'congested' => 1,
  'degraded' => 2,
  _ => 3,
};

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        variant: VitCardVariant.inner,
        height: AppSpacing.buttonStandard,
        alignment: Alignment.center,
        borderColor: color.withValues(alpha: .34),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTextStyles.baseMedium.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

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
        key: NetworkStatusTabletPage.networkKey(network.id),
        variant: VitCardVariant.inner,
        borderColor: healthColor.withValues(alpha: .34),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                VitCard(
                  width: AppSpacing.buttonCompact,
                  height: AppSpacing.buttonCompact,
                  variant: VitCardVariant.ghost,
                  radius: VitCardRadius.standard,
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
                const SizedBox(width: AppSpacing.x4),
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
                      const SizedBox(height: AppSpacing.x4),
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
            const SizedBox(height: AppSpacing.x4),
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
            const SizedBox(height: AppSpacing.x4),
            Semantics(
              label:
                  'Tắc nghẽn mạng ${network.congestionPct}%, ${_congestionLabel(network.congestionPct)}',
              child: ClipRRect(
                borderRadius: AppRadii.pillRadius,
                child: LinearProgressIndicator(
                  minHeight: AppSpacing.x1,
                  value: (network.congestionPct / 100).clamp(0, 1).toDouble(),
                  color: congestionColor.withValues(alpha: .55),
                  backgroundColor: congestionColor.withValues(alpha: .08),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            _NetworkStatsGrid(network: network),
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: _AvailabilityChip(
                    label: 'Nạp',
                    enabled: network.depositEnabled,
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: _AvailabilityChip(
                    label: 'Rút',
                    enabled: network.withdrawEnabled,
                  ),
                ),
              ],
            ),
            if (network.notes case final note?) ...[
              const SizedBox(height: AppSpacing.x4),
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
                if (col == 0) const SizedBox(width: AppSpacing.x4),
              ],
            ],
          ),
          if (row == 0) const SizedBox(height: AppSpacing.x4),
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
      variant: VitCardVariant.ghost,
      height: AppSpacing.buttonStandard,
      child: Row(
        children: [
          Icon(stat.icon, color: AppColors.text3, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x4),
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
                const SizedBox(height: AppSpacing.x4),
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
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x4),
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
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x1,
            runSpacing: AppSpacing.x1,
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
