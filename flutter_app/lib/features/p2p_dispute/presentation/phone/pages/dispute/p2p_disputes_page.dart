import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class P2PDisputesPage extends ConsumerWidget {
  const P2PDisputesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc222_p2p_disputes_content');

  static Key disputeKey(String disputeId) =>
      Key('sc222_p2p_disputes_$disputeId');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(p2pDisputesProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome +
                  P2PSpacingTokens.p2pDisputeBottomInsetVisual
            : DeviceMetrics.nativeBottomChrome +
                  P2PSpacingTokens.p2pDisputeBottomInsetNative) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Tranh chấp P2P',
      semanticIdentifier: 'SC-222',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Tranh chấp P2P',
            subtitle: 'Tranh chấp · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pDisputesProvider),
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: P2PDisputesPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding: P2PSpacingTokens.p2pDisputesScrollPadding(
                        bottomInset,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.form,
                        padding: VitContentPadding.none,
                        fullBleed: true,
                        gap: VitContentGap.tight,
                        children: [
                          _StatsRow(snapshot: snapshot),
                          _SafetyNotice(snapshot: snapshot),
                          _ListHeader(activeCount: snapshot.activeCount),
                          if (snapshot.disputes.isEmpty)
                            _EmptyDisputes(snapshot: snapshot)
                          else
                            for (final dispute in snapshot.disputes) ...[
                              _DisputeListTile(dispute: dispute),
                              if (dispute != snapshot.disputes.last)
                                const SizedBox(
                                  height: AppSpacing.pageRhythmFormInnerGap,
                                ),
                            ],
                          _GuideCard(snapshot: snapshot),
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

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.snapshot});

  final P2PDisputesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.balance_rounded,
            value: snapshot.totalCount.toString(),
            label: 'Tổng cộng',
            color: AppColors.sell,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _StatCard(
            icon: Icons.schedule_rounded,
            value: snapshot.activeCount.toString(),
            label: 'Đang xử lý',
            color: AppColors.warn,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_outline_rounded,
            value: snapshot.resolvedCount.toString(),
            label: 'Đã giải quyết',
            color: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.large,
      padding: P2PSpacingTokens.p2pDisputeCompactCardPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: color.withValues(alpha: .12),
            shape: const CircleBorder(),
            child: SizedBox(
              width: AppSpacing.buttonCompact,
              height: AppSpacing.buttonCompact,
              child: Icon(icon, color: color, size: AppSpacing.iconSm),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color == AppColors.sell ? AppColors.text1 : color,
              fontFeatures: AppTextStyles.tabularFigures,
              fontWeight: AppTextStyles.bold,
            ),
          ),
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

class _SafetyNotice extends StatelessWidget {
  const _SafetyNotice({required this.snapshot});

  final P2PDisputesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppModuleAccents.p2p.withValues(alpha: .08),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.cardRadius,
        side: BorderSide(color: AppModuleAccents.p2p.withValues(alpha: .18)),
      ),
      child: Padding(
        padding: P2PSpacingTokens.p2pDisputeCompactCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.verified_user_outlined,
              color: AppModuleAccents.p2p,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.noticeTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
                  Text(
                    snapshot.notice,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
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

class _ListHeader extends StatelessWidget {
  const _ListHeader({required this.activeCount});

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Danh sách tranh chấp',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (activeCount > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Material(
                color: AppColors.warn,
                shape: CircleBorder(),
                child: SizedBox(width: AppSpacing.x2, height: AppSpacing.x2),
              ),
              const SizedBox(width: AppSpacing.pageRhythmFormInnerGap),
              Text(
                '$activeCount đang xử lý',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _EmptyDisputes extends StatelessWidget {
  const _EmptyDisputes({required this.snapshot});

  final P2PDisputesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: P2PSpacingTokens.p2pDisputeEmptyPadding,
      child: Column(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
          Text(
            snapshot.emptyTitle,
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          Text(
            snapshot.emptySubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DisputeListTile extends StatelessWidget {
  const _DisputeListTile({required this.dispute});

  final P2PDisputeListItemDraft dispute;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(dispute.status);
    return VitCard(
      key: P2PDisputesPage.disputeKey(dispute.id),
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        context.go(AppRoutePaths.p2pDisputeDetail(dispute.id));
      },
      padding: P2PSpacingTokens.p2pDisputeCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: color.withValues(alpha: .12),
                shape: const CircleBorder(),
                child: SizedBox(
                  width: AppSpacing.buttonCompact,
                  height: AppSpacing.buttonCompact,
                  child: Icon(
                    _statusIcon(dispute.status),
                    color: color,
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
                      '#${dispute.shortOrderNumber}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
                    Text(
                      dispute.createdAt,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              VitAccentPill(label: dispute.statusLabel, accentColor: color),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
          Text(
            dispute.reason,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
          Row(
            children: [
              _MetaItem(
                icon: Icons.description_outlined,
                label: '${dispute.evidenceCount} bằng chứng',
              ),
              const SizedBox(width: AppSpacing.x3),
              _MetaItem(
                icon: Icons.schedule_rounded,
                label: '${dispute.timelineCount} sự kiện',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppColors.text3,
          size: P2PSpacingTokens.p2pDisputeMetaIcon,
        ),
        const SizedBox(width: AppSpacing.pageRhythmFormInnerGap),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.snapshot});

  final P2PDisputesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: P2PSpacingTokens.p2pDisputeCompactCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppModuleAccents.p2p,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                snapshot.guideTitle,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
          for (var index = 0; index < snapshot.guideSteps.length; index++) ...[
            Text(
              '${index + 1}. ${snapshot.guideSteps[index]}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            if (index < snapshot.guideSteps.length - 1)
              const SizedBox(height: AppSpacing.pageRhythmFormInnerGap),
          ],
        ],
      ),
    );
  }
}

Color _statusColor(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => AppColors.warn,
    P2PDisputeStatus.underReview => AppModuleAccents.p2p,
    P2PDisputeStatus.resolved => AppColors.buy,
    P2PDisputeStatus.rejected => AppColors.sell,
  };
}

IconData _statusIcon(P2PDisputeStatus status) {
  return switch (status) {
    P2PDisputeStatus.submitted => Icons.schedule_rounded,
    P2PDisputeStatus.underReview => Icons.description_outlined,
    P2PDisputeStatus.resolved => Icons.check_circle_outline_rounded,
    P2PDisputeStatus.rejected => Icons.warning_amber_rounded,
  };
}
