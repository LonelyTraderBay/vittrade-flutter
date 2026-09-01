import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/rewards_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part '../../widgets/rewards_hub_hero_section.dart';
part '../../widgets/rewards_hub_task_section.dart';
part '../../widgets/rewards_hub_components.dart';

class RewardsHubPage extends ConsumerStatefulWidget {
  const RewardsHubPage({super.key, this.shellRenderMode, this.initialFilter});

  static const contentKey = Key('sc319_rewards_content');
  static const claimAllKey = Key('sc319_claim_all');
  static const referralKey = Key('sc319_referral');
  static const leaderboardKey = Key('sc319_leaderboard_all');
  static const emptyKey = Key('sc319_rewards_empty');
  static const loadingKey = Key('sc319_rewards_loading');
  static const errorKey = Key('sc319_rewards_error');
  static const offlineKey = Key('sc319_rewards_offline');

  static Key filterKey(String label) => Key('sc319_filter_$label');
  static Key activeFilterKey(String label) => Key('sc319_active_filter_$label');
  static Key taskKey(String id) => Key('sc319_task_$id');

  final ShellRenderMode? shellRenderMode;
  final String? initialFilter;

  @override
  ConsumerState<RewardsHubPage> createState() => _RewardsHubPageState();
}

String _formatRewardPoints(int value) => VitFormat.compactSuffix(value);

class _RewardsHubPageState extends ConsumerState<RewardsHubPage> {
  String _activeFilter = 'Tất cả';
  bool _claimedAll = false;

  @override
  void initState() {
    super.initState();
    final initialFilter = widget.initialFilter;
    if (initialFilter != null) {
      _activeFilter = initialFilter;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rewardsAsync = ref.watch(rewardsHubSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final resolvedSnapshot = rewardsAsync.value;
    final showOfflineBanner =
        resolvedSnapshot?.screenState == RewardsScreenState.offline &&
        (resolvedSnapshot?.tasks.isNotEmpty ?? false);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Trung tâm Phần thưởng',
      semanticIdentifier: 'SC-319',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Trung tâm Phần thưởng',
            subtitle: 'Phần thưởng · Rewards',
            showBack: true,
            onBack: () => _close(
              context,
              rewardsAsync.value?.backRoute ?? AppRoutePaths.home,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showOfflineBanner)
                const Padding(
                  key: RewardsHubPage.offlineKey,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    0,
                  ),
                  child: VitOfflineBanner(
                    message: 'Đang ngoại tuyến',
                    detail: 'Hiển thị phần thưởng đã lưu gần nhất.',
                  ),
                ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: RewardsHubPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      children: rewardsAsync.when(
                        loading: () => const [
                          VitSkeletonList(
                            key: RewardsHubPage.loadingKey,
                            rows: 4,
                          ),
                        ],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            key: RewardsHubPage.errorKey,
                            title: 'Không tải được phần thưởng',
                            message: 'Thử lại sau hoặc quay lại trang chủ.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(rewardsHubSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) {
                          final visibleTasks = snapshot.tasks
                              .where(
                                (task) =>
                                    _activeFilter == 'Tất cả' ||
                                    task.filter == _activeFilter,
                              )
                              .toList(growable: false);
                          return switch (snapshot.screenState) {
                            RewardsScreenState.loading => [
                              const VitSkeletonList(
                                key: RewardsHubPage.loadingKey,
                                rows: 4,
                              ),
                            ],
                            RewardsScreenState.error => [
                              VitErrorState(
                                key: RewardsHubPage.errorKey,
                                title: 'Không tải được phần thưởng',
                                message: 'Thử lại sau hoặc quay lại trang chủ.',
                                actionLabel: 'Thử lại',
                                onAction: () => context.go(snapshot.backRoute),
                              ),
                            ],
                            RewardsScreenState.empty => [
                              VitEmptyState(
                                key: RewardsHubPage.emptyKey,
                                icon: Icons.redeem_outlined,
                                title: 'Chưa có phần thưởng',
                                message:
                                    'Hoàn thành nhiệm vụ để nhận Arena Points.',
                                actionLabel: 'Về trang chủ',
                                onAction: () => context.go(snapshot.backRoute),
                              ),
                            ],
                            RewardsScreenState.offline
                                when snapshot.tasks.isEmpty =>
                              [
                                const VitEmptyState(
                                  key: RewardsHubPage.offlineKey,
                                  icon: Icons.wifi_off_rounded,
                                  title: 'Đang ngoại tuyến',
                                  message:
                                      'Kết nối lại để xem phần thưởng mới nhất.',
                                ),
                              ],
                            _ => [
                              _RewardsHero(
                                summary: snapshot.summary,
                                claimedAll: _claimedAll,
                                onClaimAll: () {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _claimedAll = true);
                                },
                              ),
                              _CategoryProgress(
                                categories: snapshot.categories,
                                completionLabel:
                                    snapshot.summary.completionLabel,
                              ),
                              _CheckInSection(checkIns: snapshot.checkIns),
                              _ReferralBanner(
                                onTap: () {
                                  unawaited(HapticFeedback.selectionClick());
                                  context.go(snapshot.referralRoute);
                                },
                              ),
                              _TaskSection(
                                completionLabel:
                                    snapshot.summary.completionLabel,
                                filters: snapshot.filters,
                                activeFilter: _activeFilter,
                                tasks: visibleTasks,
                                onFilter: (filter) {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() => _activeFilter = filter);
                                },
                              ),
                              _BonusSection(rows: snapshot.bonusRows),
                              _ProgressSection(
                                summary: snapshot.summary,
                                leaderboard: snapshot.leaderboard,
                                onLeaderboardTap: () {
                                  unawaited(HapticFeedback.selectionClick());
                                  context.go(snapshot.leaderboardRoute);
                                },
                              ),
                              _RewardsDisclaimer(text: snapshot.disclaimer),
                            ],
                          };
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

  void _close(BuildContext context, String backRoute) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(backRoute);
  }
}
