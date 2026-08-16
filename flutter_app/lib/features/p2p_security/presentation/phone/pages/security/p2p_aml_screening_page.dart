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
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

const double _p2pAmlVisualClearance = AppSpacing.x3;
const double _p2pAmlNativeClearance = AppSpacing.x2;
const double _p2pAmlIconBox = AppSpacing.buttonCompact;
const double _p2pAmlDividerExtent = AppSpacing.dividerHairline;
const double _p2pAmlInfoLineHeight = 1.35;

class P2PAmlScreeningPage extends ConsumerWidget {
  const P2PAmlScreeningPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc268_p2p_aml_hero');
  static const scheduleKey = Key('sc268_p2p_aml_schedule');
  static const checksKey = Key('sc268_p2p_aml_checks');
  static const infoKey = Key('sc268_p2p_aml_info');

  static Key checkKey(String id) => Key('sc268_p2p_aml_check_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pAmlScreeningProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + _p2pAmlVisualClearance
            : DeviceMetrics.nativeBottomChrome + _p2pAmlNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Sàng lọc chống rửa tiền P2P',
      semanticIdentifier: 'SC-268',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pComplianceOverview),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2pComplianceOverview),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pAmlScreeningProvider),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pAmlScreeningScrollPadding(
                        scrollEndPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _AmlHero(snapshot: snapshot),
                          _AmlSchedule(snapshot: snapshot),
                          Text(
                            'Chi tiết kiểm tra',
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          _AmlCheckList(checks: snapshot.checks),
                          _AmlInfoNotice(snapshot: snapshot),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AmlHero extends StatelessWidget {
  const _AmlHero({required this.snapshot});

  final P2PAmlScreeningSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PAmlScreeningPage.heroKey,
      color: AppModuleAccents.p2p,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadii.cardLargeRadius,
        side: BorderSide(color: AppModuleAccents.p2p),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pAmlScreeningCardPadding,
        child: Row(
          children: [
            Material(
              color: AppColors.onAccent.withValues(alpha: .20),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.lgRadius,
              ),
              child: const SizedBox(
                width: _p2pAmlIconBox,
                height: _p2pAmlIconBox,
                child: Icon(
                  Icons.shield_outlined,
                  color: AppColors.onAccent,
                  size: AppSpacing.iconSm,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.statusLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    snapshot.statusDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent.withValues(alpha: .90),
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmlSchedule extends StatelessWidget {
  const _AmlSchedule({required this.snapshot});

  final P2PAmlScreeningSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAmlScreeningPage.scheduleKey,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pAmlScreeningCardPadding,
      child: Row(
        children: [
          Expanded(
            child: _ScheduleMetric(
              label: snapshot.lastCheckLabel,
              value: snapshot.lastCheckAt,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _ScheduleMetric(
              label: snapshot.nextCheckLabel,
              value: snapshot.nextCheckAt,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleMetric extends StatelessWidget {
  const _ScheduleMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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

class _AmlCheckList extends StatelessWidget {
  const _AmlCheckList({required this.checks});

  final List<P2PAmlCheckDraft> checks;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAmlScreeningPage.checksKey,
      radius: VitCardRadius.large,
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          for (var index = 0; index < checks.length; index++) ...[
            _AmlCheckRow(check: checks[index]),
            if (index != checks.length - 1)
              const Divider(
                height: _p2pAmlDividerExtent,
                color: AppColors.borderSolid,
              ),
          ],
        ],
      ),
    );
  }
}

class _AmlCheckRow extends StatelessWidget {
  const _AmlCheckRow({required this.check});

  final P2PAmlCheckDraft check;

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(check.status);

    return Padding(
      key: P2PAmlScreeningPage.checkKey(check.id),
      padding: P2PSpacingTokens.p2pAmlScreeningCardPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: config.color.withValues(alpha: .14),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: _p2pAmlIconBox,
              height: _p2pAmlIconBox,
              child: Icon(
                config.icon,
                color: config.color,
                size: AppSpacing.iconSm,
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
                    Flexible(
                      child: Text(
                        check.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitStatusPill(
                      label: config.label,
                      status: config.pillStatus,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  check.detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmlInfoNotice extends StatelessWidget {
  const _AmlInfoNotice({required this.snapshot});

  final P2PAmlScreeningSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: P2PAmlScreeningPage.infoKey,
      color: AppModuleAccents.p2p.withValues(alpha: .10),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.lgRadius,
        side: BorderSide(color: AppModuleAccents.p2p.withValues(alpha: .24)),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pAmlScreeningCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.infoTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppModuleAccents.p2p,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    snapshot.infoBody,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      height: _p2pAmlInfoLineHeight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_AmlStatusConfig _statusConfig(String status) {
  return switch (status) {
    'review' => const _AmlStatusConfig(
      color: AppColors.warn,
      icon: Icons.schedule_rounded,
      label: 'Review',
      pillStatus: VitStatusPillStatus.warning,
    ),
    'fail' => const _AmlStatusConfig(
      color: AppColors.sell,
      icon: Icons.warning_amber_rounded,
      label: 'Fail',
      pillStatus: VitStatusPillStatus.error,
    ),
    'pass' => const _AmlStatusConfig(
      color: AppColors.buy,
      icon: Icons.check_circle_outline_rounded,
      label: 'Pass',
      pillStatus: VitStatusPillStatus.success,
    ),
    _ => const _AmlStatusConfig(
      color: AppColors.text3,
      icon: Icons.description_outlined,
      label: 'N/A',
      pillStatus: VitStatusPillStatus.neutral,
    ),
  };
}

final class _AmlStatusConfig {
  const _AmlStatusConfig({
    required this.color,
    required this.icon,
    required this.label,
    required this.pillStatus,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VitStatusPillStatus pillStatus;
}
