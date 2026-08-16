import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

class LaunchpadIdoBridgePage extends ConsumerWidget {
  const LaunchpadIdoBridgePage({
    super.key,
    this.projectId = 'sample',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc299_launchpad_ido_bridge_content');
  static const notFoundKey = Key('sc299_launchpad_ido_bridge_not_found');

  final String projectId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idoBridgeAsync = ref.watch(
      launchpadIdoBridgeSnapshotProvider(projectId),
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    // GD4-F4: subtitle phụ thuộc snapshot.project (nullable) nên bọc CẢ
    // scaffold — title/backRoute vẫn là literal hằng số.
    return idoBridgeAsync.when(
      loading: () => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Bridge token để tham gia IDO',
        semanticIdentifier: 'SC-299',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            bottomInset: bottomInset,
            semanticLabel: 'Bridge token IDO – vùng cuộn nội dung',
            semanticIdentifier: 'SC-299',
            header: VitHeader(
              title: 'IDO Bridge',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpad),
            ),
            child: const VitSkeletonList(),
          ),
        ),
      ),
      error: (error, stackTrace) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Bridge token để tham gia IDO',
        semanticIdentifier: 'SC-299',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            bottomInset: bottomInset,
            semanticLabel: 'Bridge token IDO – vùng cuộn nội dung',
            semanticIdentifier: 'SC-299',
            header: VitHeader(
              title: 'IDO Bridge',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.launchpad),
            ),
            child: VitErrorState(
              title: 'Không tải được dữ liệu',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(launchpadIdoBridgeSnapshotProvider(projectId)),
            ),
          ),
        ),
      ),
      data: (snapshot) => VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'Bridge token để tham gia IDO',
        semanticIdentifier: 'SC-299',
        child: Material(
          type: MaterialType.transparency,
          child: VitAutoHideHeaderScaffold(
            bottomInset: bottomInset,
            semanticLabel: 'Bridge token IDO – vùng cuộn nội dung',
            semanticIdentifier: 'SC-299',
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.project == null
                  ? null
                  : 'Bridge token · Tham gia IDO',
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            child: SingleChildScrollView(
              key: contentKey,
              physics: const ClampingScrollPhysics(),
              child: VitPageContent(
                rhythm: VitPageRhythm.standard,
                padding: VitContentPadding.compact,
                gap: VitContentGap.tight,
                children: [
                  if (snapshot.project == null)
                    const _BridgeProjectNotFound()
                  else
                    _BridgeParticipationFlow(snapshot: snapshot),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BridgeProjectNotFound extends StatelessWidget {
  const _BridgeProjectNotFound();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadIdoBridgePage.notFoundKey,
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadEmptyStatePadding,
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            'Dự án không tồn tại',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            'Kiểm tra lại liên kết hoặc quay về Launchpad để chọn dự án khác.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _BridgeParticipationFlow extends StatelessWidget {
  const _BridgeParticipationFlow({required this.snapshot});

  final LaunchpadIdoBridgeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final project = snapshot.project!;
    final recommendedRoute = snapshot.routes.firstWhere(
      (route) => route.recommended,
      orElse: () => snapshot.routes.first,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BridgeProjectHero(project: project),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _BridgeNetworksSection(networks: snapshot.sourceNetworks),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        _BridgeRouteCard(route: recommendedRoute),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        VitCtaButton(
          onPressed: () => context.go(snapshot.bridgeCompareRoute),
          leading: const Icon(Icons.compare_arrows_rounded),
          child: const Text('So sánh routes'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        VitCtaButton(
          variant: VitCtaButtonVariant.secondary,
          onPressed: () => context.go(snapshot.bridgeOrderRoute),
          leading: const Icon(Icons.receipt_long_outlined),
          child: const Text('Theo dõi đơn bridge'),
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
        const _BridgeRiskDisclosure(),
      ],
    );
  }
}

class _BridgeProjectHero extends StatelessWidget {
  const _BridgeProjectHero({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.large,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .22),
      padding: LaunchpadSpacingTokens.launchpadPaddingX5,
      child: Row(
        children: [
          SizedBox(
            width: AppSpacing.x7,
            height: AppSpacing.x7,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: project.accent.resolve().withValues(alpha: .12),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadii.smRadius,
                ),
              ),
              child: Center(
                child: Text(
                  project.logo,
                  style: AppTextStyles.caption.copyWith(
                    color: project.accent.resolve(),
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'IDO · ${project.chain} · ${project.symbol}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '\$${project.price}',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _BridgeNetworksSection extends StatelessWidget {
  const _BridgeNetworksSection({required this.networks});

  final List<LaunchpadBridgeNetworkDraft> networks;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mạng nguồn',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          for (final network in networks) ...[
            Row(
              children: [
                SizedBox(
                  width: AppSpacing.x6,
                  height: AppSpacing.x6,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      color: network.accent.resolve().withValues(alpha: .12),
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppRadii.smRadius,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        network.logo,
                        style: AppTextStyles.micro.copyWith(
                          color: network.accent.resolve(),
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        network.name,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        'Gas ~${network.gasEstimate} · ${network.averageTime}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (network != networks.last)
              const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ],
        ],
      ),
    );
  }
}

class _BridgeRouteCard extends StatelessWidget {
  const _BridgeRouteCard({required this.route});

  final LaunchpadSwapRouteDraft route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      borderColor: AppColors.buy20,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  route.provider,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (route.recommended)
                const VitStatusPill(
                  label: 'Đề xuất',
                  status: VitStatusPillStatus.success,
                  size: VitStatusPillSize.sm,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _RouteMetric(
                  label: 'Output ước tính',
                  value: _formatNumber(route.estimatedOutput),
                ),
              ),
              Expanded(
                child: _RouteMetric(label: 'Tổng phí', value: route.totalFee),
              ),
              Expanded(
                child: _RouteMetric(
                  label: 'Thời gian',
                  value: route.estimatedTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            'Price impact ${_formatPercent(route.priceImpact)} · ${route.hops.length} bước',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  const _RouteMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _BridgeRiskDisclosure extends StatelessWidget {
  const _BridgeRiskDisclosure();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.warn15,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Bridge IDO yêu cầu xác nhận số tiền, phí gas và thời gian khóa trước khi gửi. Không đảm bảo lợi nhuận.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatNumber(num value) {
  if (value >= 1000) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
  return value.toStringAsFixed(value is int ? 0 : 2);
}

String _formatPercent(double value) => '${value.toStringAsFixed(2)}%';
