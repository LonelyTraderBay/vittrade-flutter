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
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/support_spacing_tokens.dart';

part '../../widgets/announcements_filters_widgets.dart';
part '../../widgets/announcements_list_widgets.dart';

class AnnouncementsPage extends ConsumerStatefulWidget {
  const AnnouncementsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc293_announcements_content');
  static const filtersKey = Key('sc293_announcements_filters');
  static const pinnedKey = Key('sc293_announcements_pinned');
  static const listKey = Key('sc293_announcements_list');
  static const emptyKey = Key('sc293_announcements_empty');
  static const loadingKey = Key('sc293_announcements_loading');
  static const errorKey = Key('sc293_announcements_error');
  static const offlineKey = Key('sc293_announcements_offline');

  static Key filterKey(String id) => Key('sc293_announcement_filter_$id');
  static Key announcementKey(String id) => Key('sc293_announcement_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends ConsumerState<AnnouncementsPage> {
  String _activeFilterId = 'all';
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final announcementsAsync = ref.watch(announcementsSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;
    final resolvedSnapshot = announcementsAsync.value;
    final showOfflineBanner =
        resolvedSnapshot?.screenState == SupportScreenState.offline &&
        (resolvedSnapshot?.announcements.isNotEmpty ?? false);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thông báo',
      semanticIdentifier: 'SC-293',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Thông báo',
            subtitle: 'Thông báo · Hỗ trợ',
            showBack: true,
            onBack: () => context.go(
              announcementsAsync.value?.backRoute ?? AppRoutePaths.support,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showOfflineBanner)
                const Padding(
                  key: AnnouncementsPage.offlineKey,
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    0,
                  ),
                  child: VitOfflineBanner(
                    message: 'Đang ngoại tuyến',
                    detail: 'Hiển thị thông báo đã lưu gần nhất.',
                  ),
                ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: AnnouncementsPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: SupportSpacingTokens.supportHubScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      density: VitDensity.compact,
                      children: announcementsAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được thông báo',
                            message: 'Kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(announcementsSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) {
                          final filter = snapshot.filters.firstWhere(
                            (item) => item.id == _activeFilterId,
                          );
                          final filtered = filter.type == null
                              ? snapshot.announcements
                              : snapshot.announcements
                                    .where((item) => item.type == filter.type)
                                    .toList();
                          final pinned = filtered
                              .where((item) => item.isPinned)
                              .toList();
                          final regular = filtered
                              .where((item) => !item.isPinned)
                              .toList();
                          return [
                            _AnnouncementTypeFilters(
                              filters: snapshot.filters,
                              activeFilterId: _activeFilterId,
                              onChanged: _setFilter,
                            ),
                            ...switch (snapshot.screenState) {
                              SupportScreenState.loading => [
                                const VitSkeletonList(
                                  key: AnnouncementsPage.loadingKey,
                                  rows: 4,
                                ),
                              ],
                              SupportScreenState.error => [
                                VitErrorState(
                                  key: AnnouncementsPage.errorKey,
                                  title: 'Không tải được thông báo',
                                  message: 'Kiểm tra kết nối và thử lại.',
                                  actionLabel: 'Thử lại',
                                  onAction: () => setState(() {}),
                                ),
                              ],
                              SupportScreenState.empty ||
                              SupportScreenState.offline
                                  when pinned.isEmpty && regular.isEmpty =>
                                [
                                  const VitEmptyState(
                                    key: AnnouncementsPage.emptyKey,
                                    title: 'Không có thông báo nào',
                                    message:
                                        'Các cập nhật mới từ VitTrade sẽ hiển thị tại đây.',
                                    icon: Icons.notifications_none_rounded,
                                  ),
                                ],
                              _ => [
                                if (pinned.isNotEmpty)
                                  _PinnedSection(
                                    announcements: pinned,
                                    expandedId: _expandedId,
                                    onToggle: _toggleExpanded,
                                  ),
                                _AnnouncementList(
                                  announcements: regular,
                                  showEmpty: pinned.isEmpty && regular.isEmpty,
                                  expandedId: _expandedId,
                                  onToggle: _toggleExpanded,
                                ),
                              ],
                            },
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

  void _setFilter(String filterId) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _activeFilterId = filterId;
      _expandedId = null;
    });
  }

  void _toggleExpanded(String id) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _expandedId = _expandedId == id ? null : id;
    });
  }
}
