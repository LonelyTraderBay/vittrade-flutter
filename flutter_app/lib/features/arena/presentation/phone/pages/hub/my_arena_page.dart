import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/challenge/arena_navigation_actions.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part 'my_arena_page_hero_and_tabs.dart';
part 'my_arena_page_tab_content.dart';
part 'my_arena_page_rewards_and_safety.dart';
part 'my_arena_page_shared_widgets.dart';

const _arenaAccent = AppModuleAccents.arena;

enum _MyArenaTab { myRooms, joined, savedModes, drafts, history }

enum MyArenaContractScope { profile, arena }

class MyArenaPage extends ConsumerStatefulWidget {
  const MyArenaPage({
    super.key,
    this.shellRenderMode,
    this.contractScope = MyArenaContractScope.profile,
  });

  static const contentKey = Key('sc168_my_arena_content');
  static const createChallengeKey = Key('sc168_create_challenge');
  static const pointsDetailKey = Key('sc168_points_detail');
  static const leaderboardKey = Key('sc168_leaderboard');
  static const discoverKey = Key('sc168_discover');
  static const reportsKey = Key('sc168_reports');
  static const blockedKey = Key('sc168_blocked');
  static const safetyKey = Key('sc168_safety');
  static const tabsScrollKey = Key('sc168_tabs_scroll');

  static Key tabKey(String id) => Key('sc168_tab_$id');
  static Key challengeKey(String id) => Key('sc168_challenge_$id');
  static Key modeKey(String id) => Key('sc168_mode_$id');

  final ShellRenderMode? shellRenderMode;
  final MyArenaContractScope contractScope;

  @override
  ConsumerState<MyArenaPage> createState() => _MyArenaPageState();
}

class _MyArenaPageState extends ConsumerState<MyArenaPage> {
  _MyArenaTab _activeTab = _MyArenaTab.myRooms;

  @override
  Widget build(BuildContext context) {
    final baseSnapshotAsync = switch (widget.contractScope) {
      MyArenaContractScope.profile => ref.watch(myArenaSnapshotProvider),
      MyArenaContractScope.arena => ref.watch(arenaMySnapshotProvider),
    };
    final creationState = ref.watch(arenaCreationProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x6) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel:
          'Sân chơi của tôi - quản lý phòng, thử thách đã tham gia và lịch sử trong Open Arena',
      semanticIdentifier: widget.contractScope == MyArenaContractScope.arena
          ? 'SC-205'
          : 'SC-168',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Sân chơi của tôi',
            subtitle: 'Quản lý · Open Arena',
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
                    key: MyArenaPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.myArenaScrollPadding(
                      scrollClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      density: VitDensity.compact,
                      children: baseSnapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được Sân chơi của tôi',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => switch (widget.contractScope) {
                              MyArenaContractScope.profile => ref.invalidate(
                                myArenaSnapshotProvider,
                              ),
                              MyArenaContractScope.arena => ref.invalidate(
                                arenaMySnapshotProvider,
                              ),
                            },
                          ),
                        ],
                        data: (baseSnapshot) {
                          final snapshot = _mergeArenaCreationSnapshot(
                            baseSnapshot,
                            creationState,
                          );
                          return [
                            _PointsHero(
                              stats: snapshot.stats,
                              onDetails: () =>
                                  context.goHaptic(AppRoutePaths.arenaPoints),
                              onLedger: () =>
                                  context.goHaptic(AppRoutePaths.arenaLedger),
                              onEarn: () => context.goHaptic('/rewards'),
                            ),
                            _StatsGrid(stats: snapshot.stats),
                            VitCtaButton(
                              key: MyArenaPage.createChallengeKey,
                              onPressed: () =>
                                  context.goHaptic(AppRoutePaths.arenaStudio),
                              density: VitDensity.compact,
                              leading: const Icon(Icons.auto_awesome_rounded),
                              child: const Text('Tạo thách đấu mới'),
                            ),
                            _QuickLinks(
                              onLeaderboard: () => context.goHaptic(
                                AppRoutePaths.arenaLeaderboard,
                              ),
                              onDiscover: () =>
                                  context.goHaptic(AppRoutePaths.arena),
                            ),
                            _ArenaTabs(
                              activeTab: _activeTab,
                              onChanged: (tab) =>
                                  setState(() => _activeTab = tab),
                            ),
                            _TabContent(
                              tab: _activeTab,
                              snapshot: snapshot,
                              onChallenge: (id) => context.goHaptic(
                                AppRoutePaths.arenaChallenge(id),
                              ),
                              onMode: (id) =>
                                  context.goHaptic(AppRoutePaths.arenaMode(id)),
                              onStudio: () =>
                                  context.goHaptic(AppRoutePaths.arenaStudio),
                              onDiscover: () =>
                                  context.goHaptic(AppRoutePaths.arena),
                            ),
                            _CreatedModesSection(
                              snapshot: snapshot,
                              onTap: () =>
                                  context.goHaptic(AppRoutePaths.arenaStudio),
                            ),
                            _RewardAnalyticsSection(
                              history: snapshot.rewardHistory,
                              onViewChallenge: () => context.goHaptic(
                                AppRoutePaths.arenaChallenge('sample'),
                              ),
                            ),
                            _SafetySection(
                              onReports: () => context.goHaptic(
                                AppRoutePaths.arenaMyReports,
                              ),
                              onBlocked: () =>
                                  context.goHaptic(AppRoutePaths.arenaBlocked),
                              onSafety: () =>
                                  context.goHaptic(AppRoutePaths.arenaSafety),
                            ),
                            _ArenaFooter(
                              onRules: () =>
                                  context.goHaptic(AppRoutePaths.arenaSafety),
                            ),
                          ];
                        },
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

  void _close() {
    goBackOrFallback(
      context,
      fallbackPath: widget.contractScope == MyArenaContractScope.arena
          ? AppRoutePaths.arena
          : AppRoutePaths.profile,
      mode: BackNavigationMode.historyThenFallback,
    );
  }
}

MyArenaSnapshot _mergeArenaCreationSnapshot(
  MyArenaSnapshot snapshot,
  ArenaCreationViewState creationState,
) {
  if (!creationState.hasLocalWork) return snapshot;

  final localChallengeIds = creationState.createdChallenges
      .map((challenge) => challenge.id)
      .toSet();
  final localDraftIds = creationState.savedDrafts
      .map((draft) => draft.id)
      .toSet();
  final createdChallenges = [
    ...creationState.createdChallenges,
    ...snapshot.myRooms.where(
      (challenge) => !localChallengeIds.contains(challenge.id),
    ),
  ];
  final savedDrafts = [
    ...creationState.savedDrafts,
    ...snapshot.drafts.where((draft) => !localDraftIds.contains(draft.id)),
  ];

  return MyArenaSnapshot(
    endpoint: snapshot.endpoint,
    actionDraft: snapshot.actionDraft,
    stats: MyArenaStats(
      currentBalance: snapshot.stats.currentBalance,
      pointsEarned: snapshot.stats.pointsEarned,
      pointsSpent: snapshot.stats.pointsSpent,
      activeChallenges:
          snapshot.stats.activeChallenges +
          creationState.createdChallenges.length,
      modesCreated: snapshot.stats.modesCreated,
      creatorScore: snapshot.stats.creatorScore,
      rank: snapshot.stats.rank,
      pendingNotifications:
          snapshot.stats.pendingNotifications +
          creationState.createdChallenges.length +
          creationState.savedDrafts.length,
    ),
    myRooms: createdChallenges,
    joinedChallenges: snapshot.joinedChallenges,
    savedModes: snapshot.savedModes,
    drafts: savedDrafts,
    history: snapshot.history,
    rewardHistory: snapshot.rewardHistory,
    supportedStates: snapshot.supportedStates,
  );
}
