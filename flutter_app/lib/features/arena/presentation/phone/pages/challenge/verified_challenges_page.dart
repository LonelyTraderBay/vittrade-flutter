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

const _arenaAccent = AppModuleAccents.arena;
const _verifiedFeatureLineRatio =
    ArenaSpacingTokens.arenaVerifiedFeatureLineHeight;
const _verifiedHeroLineRatio = ArenaSpacingTokens.arenaVerifiedHeroLineHeight;

class VerifiedChallengesPage extends ConsumerWidget {
  const VerifiedChallengesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc195_verified_content');
  static const infoCardKey = Key('sc195_verified_info');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshotAsync = ref.watch(verifiedChallengesSnapshotProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Xem trước tính năng Thử thách đã xác minh - đang chờ duyệt tuân thủ và KYC',
      semanticIdentifier: 'SC-195',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Verified Challenges',
            subtitle: 'Release-gated preview - Open Arena',
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
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Verified Challenges',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              verifiedChallengesSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) => [
                          _VerifiedHero(snapshot: snapshot),
                          _VerifiedInfoCard(snapshot: snapshot),
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

  void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _VerifiedHero extends StatelessWidget {
  const _VerifiedHero({required this.snapshot});

  final VerifiedChallengesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: _arenaAccent,
      child: Column(
        children: [
          const SizedBox.square(
            dimension: ArenaSpacingTokens.arenaVerifiedHeroIconBox,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: AppColors.accent12,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.cardLargeRadius,
                  side: BorderSide(color: AppColors.accent20),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.accent,
                  size: AppSpacing.iconLg,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Text(
            snapshot.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.sectionTitle.copyWith(color: AppColors.text1),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ArenaSpacingTokens.arenaVerifiedHeroTextMaxWidth,
            ),
            child: Text(
              snapshot.subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: _verifiedHeroLineRatio,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitStatusPill(
            label: snapshot.statusLabel,
            status: VitStatusPillStatus.purple,
            size: VitStatusPillSize.lg,
          ),
        ],
      ),
    );
  }
}

class _VerifiedInfoCard extends StatelessWidget {
  const _VerifiedInfoCard({required this.snapshot});

  final VerifiedChallengesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: VerifiedChallengesPage.infoCardKey,
      padding: ArenaSpacingTokens.arenaVerifiedInfoPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: ArenaSpacingTokens.arenaVerifiedInfoIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                for (final feature in snapshot.features) ...[
                  _FeatureRow(feature: feature),
                  if (feature != snapshot.features.last)
                    const SizedBox(height: AppSpacing.x1),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.feature});

  final VerifiedChallengeFeatureDraft feature;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: ArenaSpacingTokens.arenaVerifiedFeatureIconPadding,
          child: Icon(
            _featureIcon(feature.kind),
            color: AppColors.accent,
            size: ArenaSpacingTokens.arenaVerifiedFeatureIcon,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            feature.label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: _verifiedFeatureLineRatio,
            ),
          ),
        ),
      ],
    );
  }
}

IconData _featureIcon(VerifiedChallengeFeatureKind kind) {
  return switch (kind) {
    VerifiedChallengeFeatureKind.oracle => Icons.shield_outlined,
    VerifiedChallengeFeatureKind.escrow => Icons.lock_clock_outlined,
    VerifiedChallengeFeatureKind.leaderboard => Icons.leaderboard_outlined,
    VerifiedChallengeFeatureKind.trust => Icons.verified_user_outlined,
  };
}
