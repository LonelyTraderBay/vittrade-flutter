part of 'p2p_entities.dart';

/// Full detail of a single dispute: escalation levels, evidence, timeline, and support messages.
final class P2PDisputeDetailSnapshot {
  const P2PDisputeDetailSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.dispute,
    required this.levels,
    required this.evidence,
    required this.timeline,
    required this.supportMessages,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final P2PDisputeDraft dispute;
  final List<P2PDisputeLevelDraft> levels;
  final List<P2PDisputeEvidenceDraft> evidence;
  final List<P2PDisputeTimelineDraft> timeline;
  final List<P2PDisputeSupportMessageDraft> supportMessages;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  P2PDisputeLevelDraft levelByNumber(int level) {
    return levels.firstWhere(
      (item) => item.level == level,
      orElse: () => levels.first,
    );
  }
}

/// Lifecycle status of a P2P dispute.
enum P2PDisputeStatus { submitted, underReview, resolved, rejected }

/// Who sent a message in a dispute's support chat.
enum P2PDisputeMessageSender { user, support }

/// A P2P dispute as shown on dispute screens.
final class P2PDisputeDraft {
  const P2PDisputeDraft({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.reason,
    required this.description,
    required this.currentLevel,
  });

  final String id;
  final String orderId;
  final String orderNumber;
  final P2PDisputeStatus status;
  final String statusLabel;
  final String reason;
  final String description;
  final int currentLevel;
}

/// One escalation level in a dispute's resolution process.
final class P2PDisputeLevelDraft {
  const P2PDisputeLevelDraft({
    required this.level,
    required this.shortLabel,
    required this.label,
    required this.description,
    required this.avgTime,
    required this.iconKey,
  });

  final int level;
  final String shortLabel;
  final String label;
  final String description;
  final String avgTime;
  final String iconKey;
}

/// A single uploaded evidence file attached to a dispute.
final class P2PDisputeEvidenceDraft {
  const P2PDisputeEvidenceDraft({required this.id, required this.fileName});

  final String id;
  final String fileName;
}

/// A single event in a dispute's timeline.
final class P2PDisputeTimelineDraft {
  const P2PDisputeTimelineDraft({
    required this.id,
    required this.event,
    required this.time,
    this.detail,
    this.active = false,
  });

  final String id;
  final String event;
  final String time;
  final String? detail;
  final bool active;
}

/// A single message in a dispute's support chat.
final class P2PDisputeSupportMessageDraft {
  const P2PDisputeSupportMessageDraft({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });

  final String id;
  final P2PDisputeMessageSender sender;
  final String text;
  final String time;
}

/// Evidence documents submitted for a dispute.
final class P2PDisputeEvidenceSnapshot {
  const P2PDisputeEvidenceSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.disputeId,
    required this.title,
    required this.subtitle,
    required this.documents,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String disputeId;
  final String title;
  final String subtitle;
  final List<P2PDisputeEvidenceDocumentDraft> documents;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

/// A single evidence document slot for a dispute.
final class P2PDisputeEvidenceDocumentDraft {
  const P2PDisputeEvidenceDocumentDraft({
    required this.id,
    required this.label,
    required this.iconKey,
    required this.uploaded,
  });

  final String id;
  final String label;
  final String iconKey;
  final bool uploaded;
}

/// Outcome of a resolved dispute, including refund and mediator details.
final class P2PDisputeResolutionSnapshot {
  const P2PDisputeResolutionSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.disputeId,
    required this.resultTitle,
    required this.disputeLabel,
    required this.refundAmountLabel,
    required this.reason,
    required this.mediator,
    required this.resolvedAt,
    required this.appealDeadline,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
    this.highRiskContractId,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String disputeId;
  final String resultTitle;
  final String disputeLabel;
  final String refundAmountLabel;
  final String reason;
  final String mediator;
  final String resolvedAt;
  final String appealDeadline;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
  final String? highRiskContractId;
}

/// Form data for opening a new dispute on an order.
final class P2PDisputeOpenSnapshot {
  const P2PDisputeOpenSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.orderId,
    required this.title,
    required this.subtitle,
    required this.reasons,
    required this.descriptionLabel,
    required this.descriptionPlaceholder,
    required this.uploadTitle,
    required this.uploadSubtitle,
    required this.targetDisputeId,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final String orderId;
  final String title;
  final String subtitle;
  final List<String> reasons;
  final String descriptionLabel;
  final String descriptionPlaceholder;
  final String uploadTitle;
  final String uploadSubtitle;
  final String targetDisputeId;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;
}

/// A user's disputes plus guidance for the disputes overview screen.
final class P2PDisputesSnapshot {
  const P2PDisputesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.disputes,
    required this.noticeTitle,
    required this.notice,
    required this.guideTitle,
    required this.guideSteps,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.contractNotes,
  });

  final String endpoint;
  final String actionDraft;
  final List<P2PScreenState> supportedStates;
  final List<P2PDisputeListItemDraft> disputes;
  final String noticeTitle;
  final String notice;
  final String guideTitle;
  final List<String> guideSteps;
  final String emptyTitle;
  final String emptySubtitle;
  final String contractNotes;

  int get totalCount => disputes.length;

  int get activeCount =>
      disputes.where((item) => item.status != P2PDisputeStatus.resolved).length;

  int get resolvedCount =>
      disputes.where((item) => item.status == P2PDisputeStatus.resolved).length;
}

/// A single dispute row on the disputes list screen.
final class P2PDisputeListItemDraft {
  const P2PDisputeListItemDraft({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.statusLabel,
    required this.reason,
    required this.createdAt,
    required this.evidenceCount,
    required this.timelineCount,
  });

  final String id;
  final String orderId;
  final String orderNumber;
  final P2PDisputeStatus status;
  final String statusLabel;
  final String reason;
  final String createdAt;
  final int evidenceCount;
  final int timelineCount;

  String get shortOrderNumber {
    if (orderNumber.length <= 6) return orderNumber;
    return orderNumber.substring(orderNumber.length - 6);
  }
}
