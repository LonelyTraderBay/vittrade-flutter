import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
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
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_state_cards.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part 'arena_challenge_detail_page_overview_section.dart';
part 'arena_challenge_detail_page_tabs_and_panels.dart';
part 'arena_challenge_detail_page_actions_and_shared_widgets.dart';

const _arenaAccent = AppModuleAccents.arena;
const _challengeGap = AppSpacing.x2;
const _challengeTinyGap = AppSpacing.x1;
const EdgeInsetsGeometry _challengeCardPadding =
    EdgeInsetsDirectional.symmetric(
      horizontal: _challengeGap + _challengeTinyGap,
      vertical: _challengeGap + _challengeTinyGap,
    );
const _challengeSmallIcon = 16.0;
const _challengeMdIcon = 20.0;
const _challengeLgIcon = 22.0;
const _challengeProgressHeight = 5.0;
const _challengeShareSize = 42.0;
const _challengeSummaryLabelWidth = 110.0;
const _challengeIconBubbleIcon = 18.0;
const _challengeInitialBadge = 22.0;
const _challengeTeamDot = 8.0;
const _challengeRuleNumberWidth = 24.0;

double _challengeScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return arenaFooterPadding(
    context,
    mode,
    visualExtra: AppSpacing.x3,
    nativeExtra: AppSpacing.x2,
  );
}

enum _ChallengeTab { rules, evidence, participants, activity }

class ArenaChallengeDetailPage extends ConsumerStatefulWidget {
  const ArenaChallengeDetailPage({
    super.key,
    required this.challengeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc190_challenge_detail_content');
  static const modeLinkKey = Key('sc190_mode_link');
  static const creatorKey = Key('sc190_creator');
  static const safetyKey = Key('sc190_safety');
  static const predictionKey = Key('sc190_prediction');
  static const evidenceCtaKey = Key('sc190_evidence_cta');
  static const reportKey = Key('sc190_report');
  static const blockKey = Key('sc190_block');

  static Key tabKey(String id) => Key('sc190_tab_$id');

  final String challengeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaChallengeDetailPage> createState() =>
      _ArenaChallengeDetailPageState();
}

class _ArenaChallengeDetailPageState
    extends ConsumerState<ArenaChallengeDetailPage> {
  _ChallengeTab _activeTab = _ChallengeTab.rules;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(
      arenaChallengeDetailControllerProvider(widget.challengeId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _challengeScrollBottomInset(context, mode);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết thử thách trong Open Arena',
      semanticIdentifier: 'SC-190',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết challenge',
            subtitle: 'Thử thách · Open Arena',
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
                    key: ArenaChallengeDetailPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      bottomInset,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      density: VitDensity.compact,
                      children: controllerAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được chi tiết challenge',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              arenaChallengeDetailControllerProvider(
                                widget.challengeId,
                              ),
                            ),
                          ),
                        ],
                        data: (controller) {
                          final snapshot = controller.state.snapshot;
                          final pointsReview = controller.pointsReview();
                          return [
                            _ChallengeIntro(
                              snapshot: snapshot,
                              onMode: () => context.goHaptic(
                                AppRoutePaths.arenaMode(
                                  snapshot.challenge.modeId,
                                ),
                              ),
                            ),
                            _LiveStatusCard(challenge: snapshot.challenge),
                            ArenaChallengePointsReviewCard(
                              review: pointsReview,
                            ),
                            const _PoolFeeCard(),
                            _RewardCard(tiers: snapshot.rewardTiers),
                            _RefundCard(text: snapshot.challenge.refundPolicy),
                            _TeamsSection(teams: snapshot.teams),
                            _RuleSummaryCard(rows: snapshot.ruleRows),
                            _GovernanceCard(
                              challenge: snapshot.challenge,
                              rows: snapshot.governanceRows,
                            ),
                            _ClarityCard(
                              score: snapshot.challenge.clarityScore,
                            ),
                            _CreatorCard(
                              creator: snapshot.creator,
                              onTap: () => context.goHaptic(
                                AppRoutePaths.arenaCreator(snapshot.creator.id),
                              ),
                            ),
                            _SafetyLinkCard(
                              onTap: () =>
                                  context.goHaptic(AppRoutePaths.arenaSafety),
                            ),
                            _Tabs(
                              active: _activeTab,
                              onChanged: (tab) =>
                                  setState(() => _activeTab = tab),
                            ),
                            _TabContent(snapshot: snapshot, active: _activeTab),
                            const _WarningStack(
                              warnings: [
                                'Arena Points chỉ dùng trong Open Arena, không phải tài sản tài chính.',
                                'Không thỏa thuận giao dịch ngoài nền tảng.',
                              ],
                            ),
                            _PredictionBridgeCard(
                              contextDraft: snapshot.predictionContext,
                              onTap: () => context.goHaptic(
                                AppRoutePaths.marketsPredictionEvent(
                                  snapshot.predictionContext.eventId,
                                ),
                              ),
                            ),
                            _SafetySnapshotCard(
                              rows: snapshot.safetyRows,
                              onSafety: () =>
                                  context.goHaptic(AppRoutePaths.arenaSafety),
                            ),
                            _ActionStack(
                              onEvidence: _showEvidenceSheet,
                              onReport: _showReportSheet,
                              onBlock: _showBlockSheet,
                              onLeave: _showLeaveSheet,
                            ),
                            VitCommunityRulesLink(
                              onTap: () =>
                                  context.goHaptic(AppRoutePaths.arenaSafety),
                            ),
                            const _ArenaFooterNotice(),
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
      fallbackPath: AppRoutePaths.arena,
      mode: BackNavigationMode.historyThenFallback,
    );
  }

  void _showActionSheet({required String title, required String body}) {
    unawaited(HapticFeedback.selectionClick());
    unawaited(
      showVitNoticeSheet(context: context, title: title, message: body),
    );
  }

  void _showEvidenceSheet() => _showActionSheet(
    title: 'Gửi bằng chứng',
    body:
        'Challenge này đang dùng API CoinGecko để chốt kết quả. Bạn vẫn có thể gửi ghi chú hoặc bằng chứng bổ sung nếu phát hiện sai lệch.',
  );

  void _showReportSheet() => _showActionSheet(
    title: 'Báo cáo challenge',
    body:
        'Báo cáo chỉ dùng cho nội dung, hành vi hoặc rule không rõ ràng. Không dùng để thay đổi kết quả nếu không có bằng chứng.',
  );

  void _showBlockSheet() => _showActionSheet(
    title: 'Chặn creator',
    body:
        'Bạn sẽ không thấy lời mời hoặc room mới từ creator này trên bề mặt Open Arena.',
  );

  void _showLeaveSheet() => _showActionSheet(
    title: 'Rời challenge',
    body:
        'Challenge đã bắt đầu nên entry points không được hoàn lại, trừ khi room bị void theo rule đã công bố.',
  );
}
