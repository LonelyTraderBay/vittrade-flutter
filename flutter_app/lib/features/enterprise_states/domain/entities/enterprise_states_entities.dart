/// UI states the enterprise states screen itself can render.
enum EnterpriseStatesScreenState { loading, empty, error, offline }

/// Tab section within the enterprise states screen (state kit gallery,
/// applied examples, or security notes).
enum EnterpriseStateSection { stateKit, applied, security }

/// A previewable screen state shown in the state-kit gallery (loading,
/// empty, error, offline, or access-gated).
enum EnterprisePreviewState { loading, empty, error, offline, gate }

/// Visual severity of an [EnterpriseBannerDraft].
enum EnterpriseBannerKind { info, warning, error }

/// Data contract for the enterprise states screen: its tabs, state-kit
/// previews, and banners.
final class EnterpriseStatesSnapshot {
  const EnterpriseStatesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.tabs,
    required this.previewStates,
    required this.banners,
    required this.marketRoute,
    required this.kycRoute,
    required this.securityRoute,
    required this.loginRoute,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<EnterpriseTabDraft> tabs;
  final List<EnterprisePreviewStateDraft> previewStates;
  final List<EnterpriseBannerDraft> banners;
  final String marketRoute;
  final String kycRoute;
  final String securityRoute;
  final String loginRoute;
  final String contractNotes;
  final Set<EnterpriseStatesScreenState> supportedStates;
}

/// A single tab entry in the enterprise states screen's tab bar.
final class EnterpriseTabDraft {
  const EnterpriseTabDraft({required this.section, required this.label});

  final EnterpriseStateSection section;
  final String label;
}

/// A single state-kit gallery entry pairing an [EnterprisePreviewState]
/// with its label and description.
final class EnterprisePreviewStateDraft {
  const EnterprisePreviewStateDraft({
    required this.state,
    required this.label,
    required this.description,
  });

  final EnterprisePreviewState state;
  final String label;
  final String description;
}

/// A single banner (info/warning/error) shown on the enterprise states
/// screen.
final class EnterpriseBannerDraft {
  const EnterpriseBannerDraft({
    required this.kind,
    required this.title,
    this.detail,
  });

  final EnterpriseBannerKind kind;
  final String title;
  final String? detail;
}

/// Nhãn tiếng Việt user-facing (B2 composition 2026-09-09).
extension EnterpriseStateSectionViLabel on EnterpriseStateSection {
  String get viLabel => switch (this) {
    EnterpriseStateSection.stateKit => 'Bộ trạng thái',
    EnterpriseStateSection.applied => 'Đã áp dụng',
    EnterpriseStateSection.security => 'Bảo mật',
  };
}
