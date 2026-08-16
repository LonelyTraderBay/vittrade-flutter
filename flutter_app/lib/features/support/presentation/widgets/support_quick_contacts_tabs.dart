part of '../phone/pages/support_page.dart';

List<Widget> _supportHubPageChildren({
  required SupportHubSnapshot snapshot,
  required ProductSupportContext? supportContext,
  required bool showFaq,
  required int? expandedFaqIndex,
  required List<SupportTicketDraft> activeTickets,
  required List<SupportTicketDraft> doneTickets,
  required VoidCallback onShowTickets,
  required VoidCallback onShowFaq,
  required ValueChanged<int> onToggleFaq,
  required VoidCallback onRetry,
}) {
  return switch (snapshot.screenState) {
    SupportScreenState.loading => [
      const VitSkeletonList(key: SupportPage.loadingKey, rows: 4),
    ],
    SupportScreenState.error => [
      VitErrorState(
        key: SupportPage.errorKey,
        title: 'Không tải được hub hỗ trợ',
        message: 'Kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: onRetry,
      ),
    ],
    SupportScreenState.empty || SupportScreenState.offline
        when snapshot.tickets.isEmpty && snapshot.faqItems.isEmpty =>
      [
        const VitEmptyState(
          title: 'Chưa có nội dung hỗ trợ',
          message: 'Ticket và FAQ sẽ hiển thị tại đây khi có dữ liệu.',
          icon: Icons.support_agent_rounded,
        ),
      ],
    _ => _supportHubReadySections(
      snapshot: snapshot,
      supportContext: supportContext,
      showFaq: showFaq,
      expandedFaqIndex: expandedFaqIndex,
      activeTickets: activeTickets,
      doneTickets: doneTickets,
      onShowTickets: onShowTickets,
      onShowFaq: onShowFaq,
      onToggleFaq: onToggleFaq,
    ),
  };
}

List<Widget> _supportHubReadySections({
  required SupportHubSnapshot snapshot,
  required ProductSupportContext? supportContext,
  required bool showFaq,
  required int? expandedFaqIndex,
  required List<SupportTicketDraft> activeTickets,
  required List<SupportTicketDraft> doneTickets,
  required VoidCallback onShowTickets,
  required VoidCallback onShowFaq,
  required ValueChanged<int> onToggleFaq,
}) {
  return [
    if (supportContext != null)
      _SupportContextCard(supportContext: supportContext),
    _QuickContactGrid(snapshot: snapshot),
    _SupportTabs(
      ticketCount: snapshot.tickets.length,
      showFaq: showFaq,
      onShowTickets: onShowTickets,
      onShowFaq: onShowFaq,
    ),
    showFaq
        ? _FaqPanel(
            items: snapshot.faqItems,
            expandedIndex: expandedFaqIndex,
            onToggle: onToggleFaq,
          )
        : _TicketsPanel(activeTickets: activeTickets, doneTickets: doneTickets),
  ];
}

class _QuickContactGrid extends StatelessWidget {
  const _QuickContactGrid({required this.snapshot});

  final SupportHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SupportPage.quickLinksKey,
      children: [
        Row(
          children: [
            Expanded(
              child: _QuickLinkCard(
                key: SupportPage.quickLinkKey('help'),
                icon: Icons.menu_book_outlined,
                eyebrow: 'Trung tâm',
                title: 'Trợ giúp',
                color: AppColors.accent,
                onTap: () => context.go(snapshot.helpRoute),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _QuickLinkCard(
                key: SupportPage.quickLinkKey('announcements'),
                icon: Icons.notifications_none_rounded,
                eyebrow: 'Thông báo',
                title: 'Hệ thống',
                color: AppColors.warn,
                onTap: () => context.go(snapshot.announcementsRoute),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        Row(
          children: [
            Expanded(
              child: _QuickLinkCard(
                key: SupportPage.quickLinkKey('email'),
                icon: Icons.mail_outline_rounded,
                eyebrow: 'Email',
                title: 'support@...',
                color: AppModuleAccents.support,
                onTap: HapticFeedback.selectionClick,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _QuickLinkCard(
                key: SupportPage.quickLinkKey('hotline'),
                icon: Icons.call_outlined,
                eyebrow: 'Hotline',
                title: snapshot.hotline,
                color: AppColors.buy,
                onTap: HapticFeedback.selectionClick,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    super.key,
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconLabelCard(
      icon: icon,
      label: title,
      eyebrow: eyebrow,
      accentColor: color,
      borderColor: color.withValues(alpha: .28),
      padding: SupportSpacingTokens.supportQuickCardPadding,
      labelHeight: SupportSpacingTokens.supportLineHeightTight,
      onTap: onTap,
    );
  }
}

class _SupportTabs extends StatelessWidget {
  const _SupportTabs({
    required this.ticketCount,
    required this.showFaq,
    required this.onShowTickets,
    required this.onShowFaq,
  });

  final int ticketCount;
  final bool showFaq;
  final VoidCallback onShowTickets;
  final VoidCallback onShowFaq;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      activeKey: showFaq ? 'faq' : 'tickets',
      variant: VitTabBarVariant.segment,
      tabs: [
        VitTabItem(
          key: 'tickets',
          label: 'Tickets ($ticketCount)',
          widgetKey: SupportPage.ticketsTabKey,
        ),
        const VitTabItem(
          key: 'faq',
          label: 'FAQ',
          widgetKey: SupportPage.faqTabKey,
        ),
      ],
      onChanged: (key) {
        if (key == 'faq') {
          onShowFaq();
          return;
        }
        onShowTickets();
      },
    );
  }
}
