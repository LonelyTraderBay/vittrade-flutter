part of 'arena_entities.dart';

/// UI loading/data state shared by Arena screen snapshots.
enum ArenaScreenState { loading, empty, error, offline }

/// Lifecycle state of an Arena challenge room.
enum ArenaChallengeState { open, full, live, pendingResult, resolved, canceled }

/// Game-format category of an Arena challenge template.
enum ArenaTemplateKind {
  prediction,
  closestGuess,
  teamBattle,
  bracket,
  vote,
  proof,
}

/// Data for the Open Arena home screen: templates, featured modes, and live rooms.
final class ArenaHomeSnapshot {
  const ArenaHomeSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.templates,
    required this.featuredModes,
    required this.liveRooms,
    required this.creators,
    required this.trustSignals,
    required this.pendingNotifications,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaTemplateDraft> templates;
  final List<ArenaModeDraft> featuredModes;
  final List<ArenaChallengeDraft> liveRooms;
  final List<ArenaCreatorDraft> creators;
  final List<ArenaTrustSignalDraft> trustSignals;
  final int pendingNotifications;
  final Set<ArenaScreenState> supportedStates;
}

/// A single selectable challenge template on the Arena home screen.
final class ArenaTemplateDraft {
  const ArenaTemplateDraft({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.tags,
  });

  final String id;
  final ArenaTemplateKind kind;
  final String title;
  final String description;
  final List<String> tags;
}

/// Steps and templates for creating a new challenge in the Arena studio.
final class ArenaStudioSnapshot {
  const ArenaStudioSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.steps,
    required this.templates,
    required this.platformFeePct,
    required this.secondaryActions,
    required this.trustSignals,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final List<ArenaStudioStepDraft> steps;
  final List<ArenaStudioTemplateDraft> templates;
  final int platformFeePct;
  final List<String> secondaryActions;
  final List<ArenaTrustSignalDraft> trustSignals;
  final Set<ArenaScreenState> supportedStates;
}

/// A single step in the Arena creation studio wizard.
final class ArenaStudioStepDraft {
  const ArenaStudioStepDraft({required this.index, required this.label});

  final int index;
  final String label;
}

/// A single challenge template selectable in the Arena studio.
final class ArenaStudioTemplateDraft {
  const ArenaStudioTemplateDraft({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    required this.formatTags,
    required this.complexity,
    this.verifiedOnly = false,
  });

  final String id;
  final ArenaTemplateKind kind;
  final String title;
  final String description;
  final List<String> formatTags;
  final String complexity;
  final bool verifiedOnly;
}

/// A single Arena challenge room as listed across home, studio, and profile screens.
final class ArenaChallengeDraft {
  const ArenaChallengeDraft({
    required this.id,
    required this.title,
    required this.format,
    required this.slotsFilled,
    required this.slotsTotal,
    required this.entryPoints,
    required this.prizePool,
    required this.state,
  });

  final String id;
  final String title;
  final String format;
  final int slotsFilled;
  final int slotsTotal;
  final int entryPoints;
  final int prizePool;
  final ArenaChallengeState state;
}

/// A single reusable challenge mode created by a creator.
final class ArenaModeDraft {
  const ArenaModeDraft({
    required this.id,
    required this.title,
    required this.creatorName,
    required this.cloneCount,
    required this.activeChallenges,
    required this.fairPlay,
    this.description = '',
    this.completionRate = 0,
    this.tags = const [],
    this.templateId = '',
  });

  final String id;
  final String title;
  final String creatorName;
  final int cloneCount;
  final int activeChallenges;
  final bool fairPlay;
  final String description;
  final int completionRate;
  final List<String> tags;
  final String templateId;
}

/// A single creator summary shown in Arena home listings.
final class ArenaCreatorDraft {
  const ArenaCreatorDraft({
    required this.id,
    required this.name,
    required this.modesCreated,
    required this.totalChallenges,
    required this.trustScore,
    required this.fairPlay,
  });

  final String id;
  final String name;
  final int modesCreated;
  final int totalChallenges;
  final int trustScore;
  final bool fairPlay;
}

/// A single trust signal metric shown on Arena home/studio screens.
final class ArenaTrustSignalDraft {
  const ArenaTrustSignalDraft({required this.label, required this.value});

  final String label;
  final String value;
}

/// Nhãn tiếng Việt user-facing cho trạng thái phòng đấu (pattern viLabel,
/// B2 composition 2026-09-09) — tablet home SC-184 dùng thay `.name`.
extension ArenaChallengeStateViLabel on ArenaChallengeState {
  String get viLabel => switch (this) {
    ArenaChallengeState.open => 'Đang mở',
    ArenaChallengeState.full => 'Đã đầy',
    ArenaChallengeState.live => 'Đang chạy',
    ArenaChallengeState.pendingResult => 'Chờ kết quả',
    ArenaChallengeState.resolved => 'Đã phân định',
    ArenaChallengeState.canceled => 'Đã huỷ',
  };
}
