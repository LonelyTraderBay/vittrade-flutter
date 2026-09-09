/// UI state a Support screen snapshot supports rendering.
enum SupportScreenState { loading, empty, error, offline, ready }

/// Lifecycle status of a [SupportTicketDraft].
enum SupportTicketStatus { open, inProgress, resolved, closed }

/// Urgency level of a [SupportTicketDraft].
enum SupportTicketPriority { low, medium, high, urgent }

/// Topic category of a [SupportTicketDraft].
enum SupportTicketCategory { technical, trading, deposit, withdraw, kyc, other }

/// Data for the support hub screen: contact info, the user's [tickets],
/// and quick [faqItems].
final class SupportHubSnapshot {
  const SupportHubSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.helpRoute,
    required this.announcementsRoute,
    required this.email,
    required this.hotline,
    required this.tickets,
    required this.faqItems,
    required this.contractNotes,
    required this.screenState,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String helpRoute;
  final String announcementsRoute;
  final String email;
  final String hotline;
  final List<SupportTicketDraft> tickets;
  final List<SupportFaqDraft> faqItems;
  final String contractNotes;
  final SupportScreenState screenState;
  final Set<SupportScreenState> supportedStates;
}

/// One support ticket (category, status, priority) and its message thread.
final class SupportTicketDraft {
  const SupportTicketDraft({
    required this.id,
    required this.subject,
    required this.category,
    required this.status,
    required this.priority,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  final String id;
  final String subject;
  final SupportTicketCategory category;
  final SupportTicketStatus status;
  final SupportTicketPriority priority;
  final String description;
  final String createdAt;
  final String updatedAt;
  final List<SupportMessageDraft> messages;
}

/// One message in a [SupportTicketDraft]'s thread.
final class SupportMessageDraft {
  const SupportMessageDraft({
    required this.id,
    required this.sender,
    required this.text,
    required this.time,
  });

  final String id;
  final String sender;
  final String text;
  final String time;
}

/// One question/answer FAQ entry on the support hub screen.
final class SupportFaqDraft {
  const SupportFaqDraft({required this.question, required this.answer});

  final String question;
  final String answer;
}

/// Data for the help center screen: browsable [categories] and their
/// [articles].
final class HelpCenterSnapshot {
  const HelpCenterSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.searchHint,
    required this.heroTitle,
    required this.heroBody,
    required this.chatRoute,
    required this.ticketRoute,
    required this.categories,
    required this.articles,
    required this.contractNotes,
    required this.screenState,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final String searchHint;
  final String heroTitle;
  final String heroBody;
  final String chatRoute;
  final String ticketRoute;
  final List<HelpCategoryDraft> categories;
  final List<HelpArticleDraft> articles;
  final String contractNotes;
  final SupportScreenState screenState;
  final Set<SupportScreenState> supportedStates;
}

/// One help-article category with its article count.
final class HelpCategoryDraft {
  const HelpCategoryDraft({
    required this.id,
    required this.name,
    required this.count,
  });

  final String id;
  final String name;
  final int count;
}

/// One help center article (summary, view count) within a
/// [HelpCategoryDraft].
final class HelpArticleDraft {
  const HelpArticleDraft({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.summary,
    required this.views,
  });

  final String id;
  final String categoryId;
  final String title;
  final String summary;
  final int views;
}

/// Category of an [AnnouncementDraft].
enum AnnouncementType {
  promotion,
  newFeature,
  listing,
  maintenance,
  security,
  general,
}

/// Data for the announcements screen: filterable [announcements].
final class AnnouncementsSnapshot {
  const AnnouncementsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.subtitle,
    required this.backRoute,
    required this.filters,
    required this.announcements,
    required this.contractNotes,
    required this.screenState,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String subtitle;
  final String backRoute;
  final List<AnnouncementFilterDraft> filters;
  final List<AnnouncementDraft> announcements;
  final String contractNotes;
  final SupportScreenState screenState;
  final Set<SupportScreenState> supportedStates;
}

/// One selectable [AnnouncementType] filter on the announcements screen.
final class AnnouncementFilterDraft {
  const AnnouncementFilterDraft({
    required this.id,
    required this.label,
    this.type,
  });

  final String id;
  final String label;
  final AnnouncementType? type;
}

/// One announcement entry (title, content, publish date, pin state, tags)
/// on the announcements screen.
final class AnnouncementDraft {
  const AnnouncementDraft({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedDate,
    required this.isPinned,
    required this.tags,
  });

  final String id;
  final AnnouncementType type;
  final String title;
  final String summary;
  final String content;
  final String publishedDate;
  final bool isPinned;
  final List<String> tags;
}

/// Nhãn tiếng Việt user-facing (B2 composition 2026-09-09): presentation
/// render `viLabel` thay vì `.name` — identifier camelCase không lộ UI.
extension SupportTicketStatusViLabel on SupportTicketStatus {
  String get viLabel => switch (this) {
    SupportTicketStatus.open => 'Đang mở',
    SupportTicketStatus.inProgress => 'Đang xử lý',
    SupportTicketStatus.resolved => 'Đã xử lý',
    SupportTicketStatus.closed => 'Đã đóng',
  };
}

/// Nhãn tiếng Việt cho mức ưu tiên phiếu hỗ trợ.
extension SupportTicketPriorityViLabel on SupportTicketPriority {
  String get viLabel => switch (this) {
    SupportTicketPriority.low => 'Thấp',
    SupportTicketPriority.medium => 'Trung bình',
    SupportTicketPriority.high => 'Cao',
    SupportTicketPriority.urgent => 'Khẩn cấp',
  };
}

/// Nhãn tiếng Việt cho nhóm chủ đề phiếu hỗ trợ.
extension SupportTicketCategoryViLabel on SupportTicketCategory {
  String get viLabel => switch (this) {
    SupportTicketCategory.technical => 'Kỹ thuật',
    SupportTicketCategory.trading => 'Giao dịch',
    SupportTicketCategory.deposit => 'Nạp tiền',
    SupportTicketCategory.withdraw => 'Rút tiền',
    SupportTicketCategory.kyc => 'Định danh KYC',
    SupportTicketCategory.other => 'Khác',
  };
}

/// Nhãn tiếng Việt cho loại thông báo vận hành.
extension AnnouncementTypeViLabel on AnnouncementType {
  String get viLabel => switch (this) {
    AnnouncementType.promotion => 'Khuyến mãi',
    AnnouncementType.newFeature => 'Tính năng mới',
    AnnouncementType.listing => 'Niêm yết',
    AnnouncementType.maintenance => 'Bảo trì',
    AnnouncementType.security => 'Bảo mật',
    AnnouncementType.general => 'Chung',
  };
}
