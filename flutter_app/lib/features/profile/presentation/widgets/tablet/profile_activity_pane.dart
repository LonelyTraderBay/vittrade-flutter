import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/profile_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_pane_scaffold.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Tablet activity-log detail pane (SC-161) for the Profile master-detail
/// shell — a public port of the phone `ActivityLogPage`'s content
/// (suspicious-activity banner, filter pills, per-entry cards with type
/// icon/status pill/location/device/IP detail block, footer note) into
/// [ProfilePaneScaffold], per R2: the phone page and its `part` family stay
/// untouched. Same [profileActivitySnapshotProvider] data as the phone page.
class ProfileActivityPane extends ConsumerStatefulWidget {
  const ProfileActivityPane({super.key});

  @override
  ConsumerState<ProfileActivityPane> createState() =>
      _ProfileActivityPaneState();
}

class _ProfileActivityPaneState extends ConsumerState<ProfileActivityPane> {
  String _activeFilter = 'all';

  Future<void> _refresh() async {
    ref.invalidate(profileActivitySnapshotProvider);
    await ref.read(profileActivitySnapshotProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(profileActivitySnapshotProvider);

    return ProfilePaneScaffold(
      title: 'Nhật ký hoạt động',
      subtitle: 'Hoạt động · đăng nhập · bảo mật',
      onBack: () => context.go(AppRoutePaths.profile),
      onRefresh: _refresh,
      scrollKey: ProfileTabletKeys.activityPane,
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList(rows: 5)],
        error: (error, stackTrace) => [
          VitErrorState(
            key: ProfileTabletKeys.activityPaneError,
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng thử lại.',
            actionLabel: 'Thử lại',
            onAction: _refresh,
          ),
        ],
        data: (snapshot) {
          final logs = _filteredLogs(snapshot.logs);
          final suspiciousCount = snapshot.logs
              .where((log) => log.status == 'suspicious')
              .length;
          return [
            const VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Rà soát hoạt động tài khoản',
              message:
                  'Kiểm tra đăng nhập, thiết bị, API và địa chỉ IP; nếu có hoạt động lạ, hãy đổi mật khẩu và thu hồi quyền truy cập ngay.',
              contractId: 'SC-161 activity review',
              density: VitDensity.compact,
            ),
            if (suspiciousCount > 0) _SuspiciousBanner(count: suspiciousCount),
            _ActivityFilterRow(
              filters: snapshot.filters,
              activeFilter: _activeFilter,
              onChanged: _setFilter,
            ),
            if (logs.isEmpty)
              const VitEmptyState(
                title: 'Không có hoạt động nào',
                message:
                    'Nhật ký đăng nhập, bảo mật và API sẽ hiển thị tại đây.',
                icon: Icons.shield_outlined,
              )
            else
              for (final log in logs) _ActivityEntryCard(log: log),
            const _ActivityFooter(),
          ];
        },
      ),
    );
  }

  List<ProfileActivityLog> _filteredLogs(List<ProfileActivityLog> logs) {
    return switch (_activeFilter) {
      'login' =>
        logs
            .where((log) => log.type == 'login' || log.type == 'logout')
            .toList(),
      'security' =>
        logs
            .where((log) => log.type != 'login' && log.type != 'logout')
            .toList(),
      _ => logs,
    };
  }

  void _setFilter(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() => _activeFilter = id);
  }
}

class _ActivityFilterRow extends StatelessWidget {
  const _ActivityFilterRow({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
  });

  final List<ProfileActivityFilter> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: TabletSpacingTokens.x3,
      runSpacing: TabletSpacingTokens.x3,
      children: [
        for (final filter in filters)
          VitChoicePill(
            key: ProfileTabletKeys.activityFilter(filter.id),
            label: filter.label,
            selected: filter.id == activeFilter,
            onTap: () => onChanged(filter.id),
            height: VitDensity.compact.controlHeight,
            padding: TabletSpacingTokens.vitFilterChipPadding,
            accentColor: AppColors.primary,
          ),
      ],
    );
  }
}

class _SuspiciousBanner extends StatelessWidget {
  const _SuspiciousBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ProfileTabletKeys.activityWarning,
      density: VitDensity.compact,
      borderColor: AppColors.warn.withValues(alpha: .34),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: ProfileSpacingTokens.profileActivityBannerIcon,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phát hiện $count hoạt động đáng ngờ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warn,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  'Vui lòng kiểm tra và đổi mật khẩu nếu không phải bạn',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.warn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityEntryCard extends StatelessWidget {
  const _ActivityEntryCard({required this.log});

  final ProfileActivityLog log;

  @override
  Widget build(BuildContext context) {
    final type = _typeConfig(log.type);
    final status = _statusConfig(log.status);
    final suspicious = log.status == 'suspicious';

    return VitCard(
      key: ProfileTabletKeys.activityLog(log.id),
      density: VitDensity.compact,
      borderColor: suspicious
          ? AppColors.warn.withValues(alpha: .34)
          : AppColors.cardBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ActivityIcon(config: type),
              const SizedBox(width: TabletSpacingTokens.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            type.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: TabletSpacingTokens.x4),
                        VitAccentPill(
                          label: status.label,
                          accentColor: status.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: TabletSpacingTokens.x4),
                    Text(
                      log.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              if (suspicious) ...[
                const SizedBox(width: TabletSpacingTokens.x4),
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warn,
                  size: ProfileSpacingTokens.profileActivityWarningIcon,
                ),
              ],
            ],
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          _ActivityDetails(log: log),
          const SizedBox(height: TabletSpacingTokens.x4),
          const Divider(
            height: TabletSpacingTokens.dividerHairline,
            color: AppColors.divider,
          ),
          const SizedBox(height: TabletSpacingTokens.x4),
          Text(
            log.timestamp,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon({required this.config});

  final _ActivityTypeConfig config;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ProfileSpacingTokens.profileActivityIconBox,
      height: ProfileSpacingTokens.profileActivityIconBox,
      child: Material(
        color: config.color.withValues(alpha: .16),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        child: Icon(
          config.icon,
          color: config.color,
          size: ProfileSpacingTokens.profileActivityIcon,
        ),
      ),
    );
  }
}

class _ActivityDetails extends StatelessWidget {
  const _ActivityDetails({required this.log});

  final ProfileActivityLog log;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2.withValues(alpha: .72),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      child: Padding(
        padding: TabletSpacingTokens.cardPaddingCompact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _ActivityDetailBlock(
                    icon: Icons.location_on_outlined,
                    label: 'VỊ TRÍ',
                    value: log.location,
                  ),
                ),
                const SizedBox(width: TabletSpacingTokens.x4),
                Expanded(
                  child: _ActivityDetailBlock(
                    icon: Icons.desktop_windows_outlined,
                    label: 'THIẾT BỊ',
                    value: log.device,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TabletSpacingTokens.x4),
            _ActivityDetailBlock(label: 'IP ADDRESS', value: log.ipAddress),
          ],
        ),
      ),
    );
  }
}

class _ActivityDetailBlock extends StatelessWidget {
  const _ActivityDetailBlock({
    required this.label,
    required this.value,
    this.icon,
  });

  final IconData? icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: AppColors.text3,
                size: ProfileSpacingTokens.profileActivityDetailIcon,
              ),
              const SizedBox(width: TabletSpacingTokens.x4),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: TabletSpacingTokens.x4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _ActivityFooter extends StatelessWidget {
  const _ActivityFooter();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      borderColor: AppColors.divider,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.primary,
            size: ProfileSpacingTokens.profileActivityFooterIcon,
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Text(
              'Nhật ký hoạt động giúp bạn theo dõi tất cả thao tác trên tài khoản. Nếu '
              'phát hiện hoạt động đáng ngờ, vui lòng đổi mật khẩu ngay lập tức.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ActivityTypeConfig {
  const _ActivityTypeConfig({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

final class _ActivityStatusConfig {
  const _ActivityStatusConfig({required this.label, required this.color});

  final String label;
  final Color color;
}

_ActivityTypeConfig _typeConfig(String type) {
  return switch (type) {
    'logout' => const _ActivityTypeConfig(
      label: 'Đăng xuất',
      icon: Icons.check_circle_outline_rounded,
      color: AppColors.text2,
    ),
    'password_change' => const _ActivityTypeConfig(
      label: 'Đổi mật khẩu',
      icon: Icons.shield_outlined,
      color: AppColors.primary,
    ),
    '2fa_enable' => const _ActivityTypeConfig(
      label: 'Bật 2FA',
      icon: Icons.shield_outlined,
      color: AppColors.buy,
    ),
    '2fa_disable' => const _ActivityTypeConfig(
      label: 'Tắt 2FA',
      icon: Icons.warning_amber_rounded,
      color: AppColors.sell,
    ),
    'kyc_submit' => const _ActivityTypeConfig(
      label: 'Nộp KYC',
      icon: Icons.check_circle_outline_rounded,
      color: AppColors.primary,
    ),
    'api_create' => const _ActivityTypeConfig(
      label: 'Tạo API Key',
      icon: Icons.check_circle_outline_rounded,
      color: AppColors.accent,
    ),
    'api_delete' => const _ActivityTypeConfig(
      label: 'Xóa API Key',
      icon: Icons.cancel_outlined,
      color: AppColors.sell,
    ),
    _ => const _ActivityTypeConfig(
      label: 'Đăng nhập',
      icon: Icons.check_circle_outline_rounded,
      color: AppColors.buy,
    ),
  };
}

_ActivityStatusConfig _statusConfig(String status) {
  return switch (status) {
    'failed' => const _ActivityStatusConfig(
      label: 'Thất bại',
      color: AppColors.sell,
    ),
    'suspicious' => const _ActivityStatusConfig(
      label: 'Đáng ngờ',
      color: AppColors.warn,
    ),
    _ => const _ActivityStatusConfig(label: 'Thành công', color: AppColors.buy),
  };
}
