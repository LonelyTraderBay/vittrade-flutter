import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/admin_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/admin_spacing_tokens.dart';

class AdminSettingsPage extends ConsumerWidget {
  const AdminSettingsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc410_admin_settings_content');
  static const routingKey = Key('sc410_admin_settings_routing');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerAsync = ref.watch(adminHomeControllerProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'Cài đặt quản trị',
      semanticIdentifier: 'SC-410',
      child: VitAutoHideHeaderScaffold(
        header: VitHeader(
          title: 'Admin Settings',
          subtitle: 'Operations controls',
          showBack: true,
          onBack: () => context.go(AppRoutePaths.admin),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                physics: const ClampingScrollPhysics(),
                padding: AdminSpacingTokens.adminScrollPadding(bottomInset),
                child: VitPageContent(
                  rhythm: VitPageRhythm.standard,
                  children: controllerAsync.when(
                    loading: () => const [VitSkeletonList()],
                    error: (error, stackTrace) => [
                      VitErrorState(
                        title: 'Không tải được dữ liệu',
                        message: 'Vui lòng thử lại.',
                        actionLabel: 'Thử lại',
                        onAction: () =>
                            ref.invalidate(adminHomeSnapshotProvider),
                      ),
                    ],
                    data: (controller) {
                      final snapshot = controller.state.snapshot;
                      return [
                        VitCard(
                          key: routingKey,
                          padding: AdminSpacingTokens.adminCardPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _SettingsSectionTitle(
                                icon: Icons.route_outlined,
                                title: 'Dashboard routing',
                              ),
                              for (final dashboard in snapshot.dashboards) ...[
                                _AdminSettingsRow(
                                  icon: _settingsMetricIcon(dashboard.icon),
                                  title: dashboard.title,
                                  subtitle: dashboard.description,
                                  trailing: dashboard.stat,
                                  onTap: () => context.go(dashboard.route),
                                ),
                                if (dashboard != snapshot.dashboards.last)
                                  const Divider(color: AppColors.divider),
                              ],
                            ],
                          ),
                        ),
                        VitCard(
                          padding: AdminSpacingTokens.adminCardPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _SettingsSectionTitle(
                                icon: Icons.health_and_safety_outlined,
                                title: 'Operational health',
                              ),
                              _AdminSettingsRow(
                                icon: Icons.bolt_rounded,
                                title: 'Event stream',
                                subtitle:
                                    snapshot.adminMetrics.liveEventWindowLabel,
                                trailing: snapshot.adminMetrics.eventsPerMinute,
                              ),
                            ],
                          ),
                        ),
                        VitCard(
                          padding: AdminSpacingTokens.adminCardPadding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const _SettingsSectionTitle(
                                icon: Icons.verified_outlined,
                                title: 'System health',
                              ),
                              _AdminSettingsRow(
                                icon: Icons.verified_outlined,
                                title: 'System health',
                                subtitle:
                                    snapshot.adminMetrics.footerUpdatedLabel,
                                trailing: snapshot.adminMetrics.healthLabel,
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminSettingsRow extends StatelessWidget {
  const _AdminSettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: AdminSpacingTokens.adminRowPadding,
      child: Row(
        children: [
          Icon(
            icon,
            color: AppModuleAccents.admin,
            size: AdminSpacingTokens.adminIconLg,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    height: AdminSpacingTokens.adminLineHeightCompact,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Flexible(
            child: Text(
              trailing,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppSpacing.x1),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AdminSpacingTokens.adminIconLg,
            ),
          ],
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: content,
    );
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.text1,
          size: AdminSpacingTokens.adminIconLg,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _settingsMetricIcon(AdminDashboardIcon icon) {
  switch (icon) {
    case AdminDashboardIcon.analytics:
      return Icons.bar_chart_rounded;
    case AdminDashboardIcon.experiment:
      return Icons.science_outlined;
    case AdminDashboardIcon.funnel:
      return Icons.filter_alt_outlined;
  }
}
