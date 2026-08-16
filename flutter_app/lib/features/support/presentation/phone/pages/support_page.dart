import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/support_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/support_spacing_tokens.dart';

part '../../widgets/support_quick_contacts_tabs.dart';
part '../../widgets/support_context_card.dart';
part '../../widgets/support_tickets.dart';
part '../../widgets/support_faq_common.dart';

class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({super.key, this.shellRenderMode, this.supportContext});

  static const contentKey = Key('sc294_support_content');
  static const contextKey = Key('sc294_support_context');
  static const quickLinksKey = Key('sc294_support_quick_links');
  static const ticketsTabKey = Key('sc294_support_tickets_tab');
  static const faqTabKey = Key('sc294_support_faq_tab');
  static const createTicketKey = Key('sc294_support_create_ticket');
  static const activeTicketsKey = Key('sc294_support_active_tickets');
  static const doneTicketsKey = Key('sc294_support_done_tickets');
  static const loadingKey = Key('sc294_support_loading');
  static const errorKey = Key('sc294_support_error');
  static const offlineKey = Key('sc294_support_offline');

  static Key quickLinkKey(String id) => Key('sc294_support_quick_$id');
  static Key ticketKey(String id) => Key('sc294_support_ticket_$id');
  static Key faqKey(int index) => Key('sc294_support_faq_$index');

  final ShellRenderMode? shellRenderMode;
  final ProductSupportContext? supportContext;

  @override
  ConsumerState<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends ConsumerState<SupportPage> {
  bool _showFaq = false;
  int? _expandedFaqIndex;

  @override
  Widget build(BuildContext context) {
    final hubAsync = ref.watch(supportHubSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;
    final resolvedSnapshot = hubAsync.value;
    final showOfflineBanner =
        resolvedSnapshot?.screenState == SupportScreenState.offline &&
        ((resolvedSnapshot?.tickets.isNotEmpty ?? false) ||
            (resolvedSnapshot?.faqItems.isNotEmpty ?? false));

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Hỗ trợ',
      semanticIdentifier: 'SC-294',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Hỗ trợ',
            subtitle: 'Liên hệ · Hỗ trợ',
            showBack: true,
            onBack: () => context.go(
              widget.supportContext?.sourceRoute ??
                  hubAsync.value?.backRoute ??
                  AppRoutePaths.home,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showOfflineBanner)
                const Padding(
                  key: SupportPage.offlineKey,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    0,
                  ),
                  child: VitOfflineBanner(
                    message: 'Đang ngoại tuyến',
                    detail: 'Hiển thị ticket và FAQ đã lưu gần nhất.',
                  ),
                ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: SupportPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: SupportSpacingTokens.supportHubScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      gap: VitContentGap.tight,
                      density: VitDensity.compact,
                      children: hubAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được hub hỗ trợ',
                            message: 'Kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(supportHubSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) {
                          final activeTickets = snapshot.tickets
                              .where(
                                (ticket) =>
                                    ticket.status == SupportTicketStatus.open ||
                                    ticket.status ==
                                        SupportTicketStatus.inProgress,
                              )
                              .toList();
                          final doneTickets = snapshot.tickets
                              .where(
                                (ticket) =>
                                    ticket.status ==
                                        SupportTicketStatus.resolved ||
                                    ticket.status == SupportTicketStatus.closed,
                              )
                              .toList();
                          return _supportHubPageChildren(
                            snapshot: snapshot,
                            supportContext: widget.supportContext,
                            showFaq: _showFaq,
                            expandedFaqIndex: _expandedFaqIndex,
                            activeTickets: activeTickets,
                            doneTickets: doneTickets,
                            onShowTickets: () => _setFaq(false),
                            onShowFaq: () => _setFaq(true),
                            onToggleFaq: _toggleFaq,
                            onRetry: () => setState(() {}),
                          );
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

  void _setFaq(bool value) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _showFaq = value;
      _expandedFaqIndex = null;
    });
  }

  void _toggleFaq(int index) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _expandedFaqIndex = _expandedFaqIndex == index ? null : index;
    });
  }
}
