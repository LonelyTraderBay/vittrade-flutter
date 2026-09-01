import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_state_cards.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part '../../../widgets/governance/arena_report_case_summary_timeline.dart';
part '../../../widgets/governance/arena_report_case_system_appeal.dart';
part '../../../widgets/governance/arena_report_case_related_common.dart';

const double _reportVisualScrollClearance = 108;
const double _reportNativeScrollClearance = 72;
const double _reportBodyLineHeight = 1.28;
const double _reportNoticeLineHeight = 1.3;
const double _reportActionLineHeight = 1.35;
const double _reportSmallIcon = AppSpacing.iconSm + AppSpacing.hairlineStroke;
const double _reportInlineIcon = AppSpacing.iconSm + AppSpacing.x2;
const double _reportToneIconBox = AppSpacing.buttonCompact;
const double _reportToneIcon = AppSpacing.iconSm + AppSpacing.x2;
const double _reportMarkerWidth = AppSpacing.pageSectionAccentWidth;
const double _reportMarkerHeight = AppSpacing.rowPy + AppSpacing.x1;
const double _reportTimelineColumnWidth = AppSpacing.iconMd;
const double _reportTimelineDot = AppSpacing.x4 - AppSpacing.dividerHairline;
const double _reportTimelineBorderWidth = AppSpacing.hairlineStroke;
const double _reportTimelineLineWidth = AppSpacing.dividerHairline;
const double _reportTimelineLineHeight = AppSpacing.x5;
const double _reportTimelineDateGap = AppSpacing.x1 - 1;
const double _reportAppealCtaHeight =
    AppSpacing.buttonCompact + AppSpacing.hairlineStroke;
const EdgeInsetsDirectional _reportInnerPadding = EdgeInsetsDirectional.all(
  AppSpacing.x3,
);
const EdgeInsetsDirectional _reportTimelineDotMargin =
    EdgeInsetsDirectional.only(top: AppSpacing.x1);
const EdgeInsetsDirectional _reportTimelineBodyPadding =
    EdgeInsetsDirectional.only(bottom: AppSpacing.x3);

class ArenaReportCasePage extends ConsumerStatefulWidget {
  const ArenaReportCasePage({
    super.key,
    required this.caseId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc202_report_content');
  static const emptyKey = Key('sc202_report_empty');
  static const reviewStateKey = Key('sc202_review_state');
  static const relatedChallengeKey = Key('sc202_related_challenge');
  static const myReportsKey = Key('sc202_my_reports');
  static const primaryCtaKey = Key('sc202_primary_cta');

  static Key relatedReportKey(String id) => Key('sc202_related_report_$id');

  final String caseId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaReportCasePage> createState() =>
      _ArenaReportCasePageState();
}

class _ArenaReportCasePageState extends ConsumerState<ArenaReportCasePage> {
  bool _appealSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final controllerAsync = ref.watch(
      arenaReportCaseControllerProvider(widget.caseId),
    );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? _reportVisualScrollClearance
            : _reportNativeScrollClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết báo cáo an toàn trong Open Arena',
      semanticIdentifier: 'SC-202',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết báo cáo',
            subtitle: 'An toàn · Open Arena',
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
                    key: ArenaReportCasePage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      scrollEndClearance,
                    ),
                    child: controllerAsync.when(
                      loading: () => const VitSkeletonList(),
                      error: (error, stackTrace) => VitErrorState(
                        title: 'Không tải được báo cáo',
                        message: 'Vui lòng kiểm tra kết nối và thử lại.',
                        actionLabel: 'Thử lại',
                        onAction: () => ref.invalidate(
                          arenaReportCaseControllerProvider(widget.caseId),
                        ),
                      ),
                      data: (controller) {
                        final snapshot = controller.state.snapshot;
                        final reviewState = controller.reviewState(
                          appealSubmitted: _appealSubmitted,
                        );
                        final relatedReports = controller
                            .relatedReportsExcludingCurrent();
                        return snapshot.reportCase == null
                            ? VitPageContent(
                                rhythm: VitPageRhythm.standard,
                                key: ArenaReportCasePage.emptyKey,
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
                                density: VitDensity.compact,
                                gap: VitContentGap.tight,
                                children: [
                                  ArenaReportReviewStateCard(
                                    key: ArenaReportCasePage.reviewStateKey,
                                    state: reviewState,
                                  ),
                                  _CaseSummaryCard(
                                    reportCase: snapshot.reportCase!,
                                  ),
                                  _ReportReasonCard(
                                    reportCase: snapshot.reportCase!,
                                  ),
                                  _TimelineCard(
                                    reportCase: snapshot.reportCase!,
                                  ),
                                  if (snapshot.reportCase!.actionTaken != null)
                                    _ActionTakenCard(
                                      reportCase: snapshot.reportCase!,
                                    ),
                                  if (snapshot.reportCase!.actionTaken ==
                                          null &&
                                      snapshot.reportCase!.systemNote != null)
                                    _SystemNoteCard(
                                      note: snapshot.reportCase!.systemNote!,
                                    ),
                                  if (snapshot.reportCase!.relatedChallengeId !=
                                      null)
                                    _LinkedActionRow(
                                      key: ArenaReportCasePage
                                          .relatedChallengeKey,
                                      icon: Icons.emoji_events_outlined,
                                      title: 'Xem challenge liên quan',
                                      accentColor: AppColors.accent,
                                      onTap: () => _openChallenge(
                                        context,
                                        snapshot.reportCase!,
                                      ),
                                    ),
                                  if (snapshot.reportCase!.status ==
                                      ArenaReportCaseStatus.actionTaken)
                                    _AppealNotice(
                                      state: reviewState,
                                      onAppeal: _markAppealSubmitted,
                                    ),
                                  _LinkedActionRow(
                                    key: ArenaReportCasePage.myReportsKey,
                                    icon: Icons.flag_outlined,
                                    title: 'Xem tất cả báo cáo',
                                    accentColor: AppColors.text3,
                                    onTap: () {
                                      unawaited(
                                        HapticFeedback.selectionClick(),
                                      );
                                      context.go(AppRoutePaths.arenaMyReports);
                                    },
                                  ),
                                  _RelatedReports(reports: relatedReports),
                                  _DisclaimerCard(
                                    disclaimer: snapshot.disclaimer,
                                  ),
                                  VitCtaButton(
                                    key: ArenaReportCasePage.primaryCtaKey,
                                    onPressed: () => _handlePrimaryCta(
                                      context,
                                      snapshot.reportCase!,
                                    ),
                                    child: Text(
                                      _primaryCtaLabel(snapshot.reportCase!),
                                    ),
                                  ),
                                ],
                              );
                      },
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

  void _markAppealSubmitted() {
    unawaited(HapticFeedback.mediumImpact());
    setState(() => _appealSubmitted = true);
  }

  static void _openChallenge(
    BuildContext context,
    ArenaReportCaseDraft reportCase,
  ) {
    final challengeId = reportCase.relatedChallengeId;
    if (challengeId == null) return;
    unawaited(HapticFeedback.selectionClick());
    context.go(AppRoutePaths.arenaChallenge(challengeId));
  }

  void _handlePrimaryCta(
    BuildContext context,
    ArenaReportCaseDraft reportCase,
  ) {
    unawaited(HapticFeedback.mediumImpact());
    if (reportCase.status == ArenaReportCaseStatus.actionTaken &&
        reportCase.relatedChallengeId != null) {
      _openChallenge(context, reportCase);
      return;
    }
    if (reportCase.status == ArenaReportCaseStatus.appealOpen) {
      setState(() => _appealSubmitted = true);
      return;
    }
    _close(context);
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
