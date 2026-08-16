import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/earn_staking_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/earn_spacing_tokens.dart';

class StakingThirdPartyIntegrationsPage extends ConsumerStatefulWidget {
  const StakingThirdPartyIntegrationsPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc395_integrations_hero');
  static const integrationsKey = Key('sc395_integrations_list');
  static const apiKey = Key('sc395_api_access');
  static const apiDocsKey = Key('sc395_api_docs');

  static Key integrationKey(String id) => Key('sc395_integration_$id');

  static Key connectKey(String id) => Key('sc395_connect_$id');

  static Key connectedKey(String id) => Key('sc395_connected_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingThirdPartyIntegrationsPage> createState() =>
      _StakingThirdPartyIntegrationsPageState();
}

class _StakingThirdPartyIntegrationsPageState
    extends ConsumerState<StakingThirdPartyIntegrationsPage> {
  // Bẫy 14 (GD4 playbook): repo giờ đã async — seed 1 lần trong nhánh
  // data: bên dưới thay vì initState.
  Set<String>? _connectedIds;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      stakingThirdPartyIntegrationsSnapshotProvider,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tích hợp bên thứ ba cho dữ liệu staking',
      semanticIdentifier: 'SC-395',
      child: Material(
        color: AppColors.bg,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitTopChrome(
              type: VitTopChromeType.detail,
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.earnStaking),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(stakingThirdPartyIntegrationsSnapshotProvider),
            ),
          ),
          data: (snapshot) {
            _connectedIds ??= {
              for (final integration in snapshot.integrations)
                if (integration.connected) integration.id,
            };
            final mode = widget.shellRenderMode ?? defaultShellRenderMode();
            final bottomInset =
                (mode.usesVisualQaFrame
                    ? DeviceMetrics.bottomChrome + AppSpacing.x7
                    : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
                MediaQuery.paddingOf(context).bottom;

            return VitAutoHideHeaderScaffold(
              header: VitTopChrome(
                type: VitTopChromeType.detail,
                title: snapshot.title,
                subtitle: 'Tích hợp bên thứ ba — rủi ro tự đánh giá',
                showBack: true,
                onBack: () => context.go(snapshot.backRoute),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EarnSpacingTokens.earnBottomInsetPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.defaultPadding,
                        gap: VitContentGap.defaultGap,
                        children: [
                          _IntegrationsHero(snapshot: snapshot),
                          _IntegrationsList(
                            snapshot: snapshot,
                            connectedIds: _connectedIds!,
                            onConnect: (id) {
                              setState(() => _connectedIds!.add(id));
                            },
                          ),
                          _ApiAccess(snapshot: snapshot),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _IntegrationsHero extends StatelessWidget {
  const _IntegrationsHero({required this.snapshot});

  final StakingThirdPartyIntegrationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingThirdPartyIntegrationsPage.heroKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      borderColor: AppColors.accent30,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            snapshot.heroTitle,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: EarnSpacingTokens.stakingIntegrationBodyLineHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntegrationsList extends StatelessWidget {
  const _IntegrationsList({
    required this.snapshot,
    required this.connectedIds,
    required this.onConnect,
  });

  final StakingThirdPartyIntegrationsSnapshot snapshot;
  final Set<String> connectedIds;
  final ValueChanged<String> onConnect;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingThirdPartyIntegrationsPage.integrationsKey,
      label: snapshot.sectionTitle,
      children: [
        for (final integration in snapshot.integrations)
          _IntegrationCard(
            integration: integration,
            connected: connectedIds.contains(integration.id),
            onConnect: () => onConnect(integration.id),
          ),
      ],
    );
  }
}

class _IntegrationCard extends StatelessWidget {
  const _IntegrationCard({
    required this.integration,
    required this.connected,
    required this.onConnect,
  });

  final StakingIntegrationDraft integration;
  final bool connected;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingThirdPartyIntegrationsPage.integrationKey(integration.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          _IntegrationIcon(iconKey: integration.iconKey),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  integration.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  integration.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          if (connected)
            Icon(
              key: StakingThirdPartyIntegrationsPage.connectedKey(
                integration.id,
              ),
              Icons.check_circle_outline_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconMd,
            )
          else
            VitCtaButton(
              key: StakingThirdPartyIntegrationsPage.connectKey(integration.id),
              onPressed: onConnect,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: EarnSpacingTokens.earnHorizontalPaddingX4,
              child: const Text('Connect'),
            ),
        ],
      ),
    );
  }
}

class _IntegrationIcon extends StatelessWidget {
  const _IntegrationIcon({required this.iconKey});

  final String iconKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.inputHeight,
      height: AppSpacing.inputHeight,
      child: DecoratedBox(
        decoration: const ShapeDecoration(
          color: AppColors.primary12,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.lgRadius),
        ),
        child: Icon(
          _integrationIcon(iconKey),
          color: AppModuleAccents.earn,
          size: AppSpacing.iconMd,
        ),
      ),
    );
  }
}

class _ApiAccess extends StatelessWidget {
  const _ApiAccess({required this.snapshot});

  final StakingThirdPartyIntegrationsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingThirdPartyIntegrationsPage.apiKey,
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.link_rounded,
            color: AppModuleAccents.earn,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.apiTitle,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                Text(
                  snapshot.apiBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: EarnSpacingTokens.stakingIntegrationBodyLineHeight,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                VitIconButton(
                  key: StakingThirdPartyIntegrationsPage.apiDocsKey,
                  icon: Icons.open_in_new_rounded,
                  tooltip: snapshot.apiActionLabel,
                  label: snapshot.apiActionLabel,
                  variant: VitIconButtonVariant.primary,
                  size: VitIconButtonSize.md,
                  onPressed: () => context.go(snapshot.apiDocsRoute),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _integrationIcon(String key) {
  return switch (key) {
    'briefcase' => Icons.business_center_outlined,
    'chart' => Icons.bar_chart_rounded,
    'lock' => Icons.lock_outline_rounded,
    'wallet' => Icons.account_balance_wallet_outlined,
    'bolt' => Icons.bolt_rounded,
    'bot' => Icons.smart_toy_outlined,
    _ => Icons.extension_outlined,
  };
}
