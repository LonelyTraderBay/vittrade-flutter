import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/features/p2p_dispute/presentation/widgets/dispute/p2p_dispute_widgets.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

const double _p2pDisputeDetailVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pDisputeDetailNativeNavClearance =
    _p2pDisputeDetailVisualNavClearance - AppSpacing.x4;
const double _p2pDisputeDetailVisualClearance = AppSpacing.x3;
const double _p2pDisputeDetailNativeClearance = AppSpacing.x2;

class P2PDisputeDetailPage extends ConsumerStatefulWidget {
  const P2PDisputeDetailPage({
    super.key,
    required this.disputeId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc218_p2p_dispute_detail_content');
  static const escalateKey = Key('sc218_p2p_dispute_detail_escalate');
  static const addEvidenceKey = Key('sc218_p2p_dispute_detail_add_evidence');
  static const manageEvidenceKey = Key(
    'sc218_p2p_dispute_detail_manage_evidence',
  );
  static const disputesKey = Key('sc218_p2p_dispute_detail_disputes');
  static const inputKey = Key('sc218_p2p_dispute_detail_input');
  static const sendKey = Key('sc218_p2p_dispute_detail_send');

  final String disputeId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PDisputeDetailPage> createState() =>
      _P2PDisputeDetailPageState();
}

class _P2PDisputeDetailPageState extends ConsumerState<P2PDisputeDetailPage> {
  late final TextEditingController _controller;
  final List<P2PDisputeEvidenceDraft> _localEvidence = [];
  final List<P2PDisputeSupportMessageDraft> _localMessages = [];
  int? _currentLevel;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pDisputeDetailProvider(widget.disputeId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pDisputeDetailVisualNavClearance +
                  _p2pDisputeDetailVisualClearance
            : _p2pDisputeDetailNativeNavClearance +
                  _p2pDisputeDetailNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Chi tiết khiếu nại P2P',
      semanticIdentifier: 'SC-218',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết khiếu nại',
            subtitle: 'Tranh chấp · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2pDisputes),
          ),
          child: snapshotAsync.when(
            loading: () => const VitSkeletonList(),
            error: (error, stackTrace) => VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(p2pDisputeDetailProvider(widget.disputeId)),
            ),
            data: (snapshot) {
              final level = _currentLevel ?? snapshot.dispute.currentLevel;
              final currentLevel = snapshot.levelByNumber(level);
              final nextLevel = level < snapshot.levels.length
                  ? snapshot.levelByNumber(level + 1)
                  : null;
              final evidence = [...snapshot.evidence, ..._localEvidence];
              final messages = [...snapshot.supportMessages, ..._localMessages];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(
                        context,
                      ).copyWith(scrollbars: false),
                      child: SingleChildScrollView(
                        key: P2PDisputeDetailPage.contentKey,
                        physics: const ClampingScrollPhysics(),
                        padding: P2PSpacingTokens.p2pDisputeDetailScrollPadding(
                          scrollEndPadding,
                        ),
                        child: VitPageContent(
                          rhythm: VitPageRhythm.form,
                          padding: VitContentPadding.none,
                          fullBleed: true,
                          gap: VitContentGap.tight,
                          children: [
                            P2PDisputeStatusBanner(dispute: snapshot.dispute),
                            P2PDisputeEscalationCard(
                              escalateKey: P2PDisputeDetailPage.escalateKey,
                              levels: snapshot.levels,
                              currentLevel: level,
                              currentLevelData: currentLevel,
                              nextLevelData: nextLevel,
                              onEscalate: nextLevel == null
                                  ? null
                                  : () => _escalate(nextLevel),
                            ),
                            P2PDisputeReasonCard(dispute: snapshot.dispute),
                            P2PDisputeEvidenceCard(
                              addEvidenceKey:
                                  P2PDisputeDetailPage.addEvidenceKey,
                              evidence: evidence,
                              onAdd: () => context.go(
                                AppRoutePaths.p2pDisputeEvidence(
                                  snapshot.dispute.id,
                                ),
                              ),
                            ),
                            P2PDisputeTimelineCard(timeline: snapshot.timeline),
                            P2PDisputeSupportChatCard(
                              inputKey: P2PDisputeDetailPage.inputKey,
                              sendKey: P2PDisputeDetailPage.sendKey,
                              currentLevel: level,
                              messages: messages,
                              controller: _controller,
                              onChanged: () => setState(() {}),
                              onSend: _sendMessage,
                            ),
                            P2PDisputeActionsCard(
                              manageEvidenceKey:
                                  P2PDisputeDetailPage.manageEvidenceKey,
                              disputesKey: P2PDisputeDetailPage.disputesKey,
                              onManageEvidence: () => context.go(
                                AppRoutePaths.p2pDisputeEvidence(
                                  snapshot.dispute.id,
                                ),
                              ),
                              onOpenDisputes: () =>
                                  context.go(AppRoutePaths.p2pDisputes),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _escalate(P2PDisputeLevelDraft nextLevel) {
    unawaited(HapticFeedback.mediumImpact());
    setState(() {
      _currentLevel = nextLevel.level;
      _localMessages.add(
        P2PDisputeSupportMessageDraft(
          id: 'local-escalate-${nextLevel.level}',
          sender: P2PDisputeMessageSender.support,
          text:
              'Khiếu nại đã được chuyển lên Cấp ${nextLevel.level} (${nextLevel.shortLabel}). Thời gian xử lý dự kiến: ${nextLevel.avgTime}.',
          time: '09:15',
        ),
      );
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _localMessages.add(
        P2PDisputeSupportMessageDraft(
          id: 'local-message-${_localMessages.length}',
          sender: P2PDisputeMessageSender.user,
          text: text,
          time: '09:20',
        ),
      );
      _controller.clear();
    });
  }
}
