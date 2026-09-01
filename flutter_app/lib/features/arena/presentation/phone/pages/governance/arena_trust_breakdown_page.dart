import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

const _trustDisclaimerLineRatio =
    ArenaSpacingTokens.arenaTrustDisclaimerLineHeight;
const _trustHeroLineRatio = ArenaSpacingTokens.arenaTrustHeroLineHeight;

class ArenaTrustBreakdownPage extends ConsumerWidget {
  const ArenaTrustBreakdownPage({
    super.key,
    required this.entityId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc199_trust_content');
  static const creatorLinkKey = Key('sc199_creator_link');
  static const safetyLinkKey = Key('sc199_safety_link');
  static const closeKey = Key('sc199_close');

  final String entityId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(
      arenaTrustBreakdownSnapshotProvider(entityId),
    );
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết độ tin cậy (Trust Score) trong Open Arena',
      semanticIdentifier: 'SC-199',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Trust Score',
            subtitle: 'Độ tin cậy · Open Arena',
            showBack: true,
            onBack: () => _close(context),
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
                    key: contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      footerPadding,
                    ),
                    child: snapshotAsync.when(
                      loading: () => const VitSkeletonList(),
                      error: (error, stackTrace) => VitErrorState(
                        title: 'Không tải được Trust Score',
                        message: 'Vui lòng kiểm tra kết nối và thử lại.',
                        actionLabel: 'Thử lại',
                        onAction: () => ref.invalidate(
                          arenaTrustBreakdownSnapshotProvider(entityId),
                        ),
                      ),
                      data: (snapshot) => snapshot.creator == null
                          ? VitPageContent(
                              rhythm: VitPageRhythm.standard,
                              padding: VitContentPadding.none,
                              children: [
                                VitEmptyState(
                                  icon: Icons.warning_amber_rounded,
                                  title: snapshot.emptyTitle,
                                  message: snapshot.emptySubtitle,
                                ),
                              ],
                            )
                          : VitPageContent(
                              padding: VitContentPadding.compact,
                              gap: VitContentGap.tight,
                              children: [
                                _TrustBreakdownCard(snapshot: snapshot),
                                _CreatorProfileLink(snapshot: snapshot),
                                _SafetyLink(snapshot: snapshot),
                                VitCtaButton(
                                  key: closeKey,
                                  onPressed: () => _close(context),
                                  child: const Text('Đóng'),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _TrustBreakdownCard extends StatelessWidget {
  const _TrustBreakdownCard({required this.snapshot});

  final ArenaTrustBreakdownSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final creator = snapshot.creator!;
    return VitModuleHeroCard(
      accentColor: AppColors.buy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: ArenaSpacingTokens.arenaTrustScoreBox,
                child: DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: AppColors.buy10,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.cardRadius,
                      side: BorderSide(color: AppColors.buy20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${creator.trustScore}',
                      style: AppTextStyles.pageTitle.copyWith(
                        color: AppColors.buy,
                        fontFeatures: AppTextStyles.tabularFigures,
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
                      '${creator.name} Trust Score',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Community metrics: Fair Play, completion, report rate và dispute rate.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: _trustHeroLineRatio,
                      ),
                    ),
                    if (creator.fairPlayBadge) ...[
                      const SizedBox(
                        height: AppSpacing.pageRhythmCompactInnerGap,
                      ),
                      const VitStatusPill(
                        label: 'Fair Play',
                        status: VitStatusPillStatus.success,
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Column(
            children: [
              for (final metric in snapshot.metrics) ...[
                _TrustMetricRow(metric: metric),
                if (metric != snapshot.metrics.last)
                  const Divider(
                    height: AppSpacing.x4,
                    color: AppColors.divider,
                  ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text(
            snapshot.disclaimer,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _trustDisclaimerLineRatio,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustMetricRow extends StatelessWidget {
  const _TrustMetricRow({required this.metric});

  final ArenaCreatorTrustMetricDraft metric;

  @override
  Widget build(BuildContext context) {
    final color = _metricColor(metric.kind);
    return Row(
      children: [
        SizedBox.square(
          dimension: ArenaSpacingTokens.arenaTrustMetricIconBox,
          child: DecoratedBox(
            decoration: ShapeDecoration(
              color: color.withValues(alpha: .14),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.smRadius,
              ),
            ),
            child: Center(
              child: Icon(
                _metricIcon(metric.kind),
                color: color,
                size: ArenaSpacingTokens.arenaTrustMetricGlyph,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            metric.label,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        Text(
          metric.value,
          style: AppTextStyles.baseMedium.copyWith(
            color: color,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _CreatorProfileLink extends StatelessWidget {
  const _CreatorProfileLink({required this.snapshot});

  final ArenaTrustBreakdownSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final creator = snapshot.creator!;
    return VitCard(
      key: ArenaTrustBreakdownPage.creatorLinkKey,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        context.go(AppRoutePaths.arenaCreator(creator.id));
      },
      padding: ArenaSpacingTokens.arenaTrustCardPadding,
      child: Row(
        children: [
          SizedBox.square(
            dimension: ArenaSpacingTokens.arenaTrustCreatorAvatar,
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.surface2,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
              ),
              child: Center(
                child: Text(
                  'CM',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: AppTextStyles.bold,
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
                  creator.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Xem profile đầy đủ',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _SafetyLink extends StatelessWidget {
  const _SafetyLink({required this.snapshot});

  final ArenaTrustBreakdownSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaTrustBreakdownPage.safetyLinkKey,
      onTap: () {
        unawaited(HapticFeedback.selectionClick());
        context.go(AppRoutePaths.arenaSafety);
      },
      padding: ArenaSpacingTokens.arenaTrustCardPadding,
      child: Row(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: ArenaSpacingTokens.arenaTrustSafetyIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.safetyTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.safetyDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: _trustHeroLineRatio,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

Color _metricColor(ArenaCreatorTrustMetricKind kind) {
  switch (kind) {
    case ArenaCreatorTrustMetricKind.fairPlay:
    case ArenaCreatorTrustMetricKind.disputeRate:
      return AppColors.buy;
    case ArenaCreatorTrustMetricKind.completion:
      return AppColors.primary;
    case ArenaCreatorTrustMetricKind.communityRating:
      return AppColors.warn;
  }
}

IconData _metricIcon(ArenaCreatorTrustMetricKind kind) {
  switch (kind) {
    case ArenaCreatorTrustMetricKind.fairPlay:
      return Icons.shield_outlined;
    case ArenaCreatorTrustMetricKind.disputeRate:
      return Icons.outlined_flag_rounded;
    case ArenaCreatorTrustMetricKind.completion:
      return Icons.verified_outlined;
    case ArenaCreatorTrustMetricKind.communityRating:
      return Icons.star_outline_rounded;
  }
}
