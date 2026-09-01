import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_mode_detail_actions.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_navigation_actions.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_mode_detail_hero.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_mode_detail_prediction.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_mode_detail_quality.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_mode_detail_related.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_mode_detail_rules.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_bottom_sheet.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_error_state.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_skeleton.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

class ArenaModeDetailPage extends ConsumerStatefulWidget {
  const ArenaModeDetailPage({
    super.key,
    required this.modeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc189_mode_detail_content');
  static const creatorKey = Key('sc189_creator');
  static const trustKey = Key('sc189_trust');
  static const infoKey = Key('sc189_info');
  static const useModeKey = Key('sc189_use_mode');
  static const createRoomKey = Key('sc189_create_room');
  static const predictionKey = Key('sc189_prediction_context');

  static Key roomKey(String id) => Key('sc189_room_$id');
  static Key relatedModeKey(String id) => Key('sc189_related_mode_$id');

  final String modeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaModeDetailPage> createState() =>
      _ArenaModeDetailPageState();
}

class _ArenaModeDetailPageState extends ConsumerState<ArenaModeDetailPage> {
  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      arenaModeDetailSnapshotProvider(widget.modeId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Chi tiết chế độ chơi trong Open Arena - luật, người tạo và chỉ số chất lượng',
      semanticIdentifier: 'SC-189',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Chế độ chơi',
              subtitle: 'Chế độ chơi · Open Arena',
              showBack: true,
              onBack: _close,
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Chế độ chơi',
              subtitle: 'Chế độ chơi · Open Arena',
              showBack: true,
              onBack: _close,
            ),
            child: VitErrorState(
              title: 'Không tải được chế độ chơi',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(
                arenaModeDetailSnapshotProvider(widget.modeId),
              ),
            ),
          ),
          data: (snapshot) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: snapshot.mode.title,
              subtitle: 'Chế độ chơi · Open Arena',
              showBack: true,
              onBack: _close,
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
                      key: ArenaModeDetailPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                        footerPadding,
                      ),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          ArenaModeHero(
                            creatorKey: ArenaModeDetailPage.creatorKey,
                            trustKey: ArenaModeDetailPage.trustKey,
                            snapshot: snapshot,
                            onCreator: () => context.goHaptic(
                              AppRoutePaths.arenaCreator(snapshot.creator.id),
                            ),
                            onTrust: () => context.goHaptic(
                              AppRoutePaths.arenaTrust(snapshot.creator.id),
                            ),
                          ),
                          ArenaModeActions(
                            useModeKey: ArenaModeDetailPage.useModeKey,
                            createRoomKey: ArenaModeDetailPage.createRoomKey,
                            onUseMode: () =>
                                context.goHaptic(AppRoutePaths.arenaStudio),
                            onCreateRoom: () =>
                                context.goHaptic(AppRoutePaths.arenaStudio),
                          ),
                          VitCard(
                            padding: AppSpacing.zeroInsets,
                            child: ArenaModeDescriptionCard(
                              description: snapshot.mode.description,
                            ),
                          ),
                          VitCard(
                            padding: AppSpacing.zeroInsets,
                            child: ArenaModeRulesSummary(
                              rows: snapshot.ruleRows,
                            ),
                          ),
                          ArenaModeQualitySection(
                            infoKey: ArenaModeDetailPage.infoKey,
                            metrics: snapshot.qualityMetrics,
                            onInfo: () => _showTrustSheet(snapshot),
                          ),
                          if (snapshot.relatedRooms.isNotEmpty)
                            ArenaModeRelatedRooms(
                              roomKey: ArenaModeDetailPage.roomKey,
                              rooms: snapshot.relatedRooms,
                              onRoom: (id) => context.goHaptic(
                                AppRoutePaths.arenaChallenge(id),
                              ),
                            ),
                          if (snapshot.relatedModes.isNotEmpty)
                            ArenaModeRelatedModes(
                              relatedModeKey:
                                  ArenaModeDetailPage.relatedModeKey,
                              modes: snapshot.relatedModes,
                              onMode: (id) =>
                                  context.goHaptic(AppRoutePaths.arenaMode(id)),
                            ),
                          ArenaModePredictionContext(
                            predictionKey: ArenaModeDetailPage.predictionKey,
                            contextDraft: snapshot.predictionContext,
                            onTap: () => context.goHaptic(
                              AppRoutePaths.marketsPredictionEvent(
                                snapshot.predictionContext.eventId,
                              ),
                            ),
                          ),
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

  void _close() {
    goBackOrFallback(
      context,
      fallbackPath: AppRoutePaths.arena,
      mode: BackNavigationMode.historyThenFallback,
    );
  }

  void _showTrustSheet(ArenaModeDetailSnapshot snapshot) {
    unawaited(HapticFeedback.selectionClick());

    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.surface,
        barrierColor: AppColors.dynamicIslandBg.withValues(alpha: .55),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopRadius,
        ),
        builder: (context) => ArenaModeTrustSheet(snapshot: snapshot),
      ),
    );
  }
}
