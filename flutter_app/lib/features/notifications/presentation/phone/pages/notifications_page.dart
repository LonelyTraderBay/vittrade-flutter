import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/notifications_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/notifications_spacing_tokens.dart';

part '../../widgets/notifications_page_sections.dart';
part '../../widgets/notifications_page_common.dart';

enum _NotificationFilter { all, unread }

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc291_notifications_content');
  static const toolbarKey = Key('sc291_notifications_toolbar');
  static const filterKey = Key('sc291_notifications_filter');
  static const markAllReadKey = Key('sc291_notifications_mark_all_read');
  static const emptyKey = Key('sc291_notifications_empty');
  static const loadingKey = Key('sc291_notifications_loading');
  static const errorKey = Key('sc291_notifications_error');
  static const offlineKey = Key('sc291_notifications_offline');

  static Key notificationKey(String id) => Key('sc291_notification_$id');
  static Key deleteKey(String id) => Key('sc291_delete_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  _NotificationFilter _filter = _NotificationFilter.all;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationsStateProvider);
    final snapshot = state.snapshot;
    final notifications = state.notifications;
    final unreadCount = state.unreadCount;
    final filtered = _filter == _NotificationFilter.all
        ? notifications
        : notifications.where((item) => !item.isRead).toList();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final showOfflineBanner =
        snapshot.screenState == NotificationsScreenState.offline &&
        notifications.isNotEmpty;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Thông báo',
      semanticIdentifier: 'SC-291',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _NotificationFilterBand(filter: _filter, onChanged: _setFilter),
              if (showOfflineBanner)
                const Padding(
                  key: NotificationsPage.offlineKey,
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
                    key: NotificationsPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding:
                        NotificationsSpacingTokens.notificationsScrollPadding(
                          bottomInset,
                        ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      density: VitDensity.compact,
                      children: [
                        if (snapshot.screenState ==
                            NotificationsScreenState.ready)
                          _UnreadSummaryBar(
                            unreadCount: unreadCount,
                            onMarkAllRead: unreadCount > 0
                                ? _markAllRead
                                : null,
                          ),
                        ...switch (snapshot.screenState) {
                          NotificationsScreenState.loading => [
                            const VitSkeletonList(
                              key: NotificationsPage.loadingKey,
                              rows: 5,
                            ),
                          ],
                          NotificationsScreenState.error => [
                            VitErrorState(
                              key: NotificationsPage.errorKey,
                              title: 'Không tải được thông báo',
                              message: 'Kiểm tra kết nối và thử lại.',
                              actionLabel: 'Thử lại',
                              onAction: () => ref
                                  .read(notificationsStateProvider.notifier)
                                  .resetFromRepository(),
                            ),
                          ],
                          NotificationsScreenState.empty ||
                          NotificationsScreenState
                              .offline when notifications.isEmpty => [
                            _emptyState(
                              message:
                                  snapshot.screenState ==
                                      NotificationsScreenState.offline
                                  ? 'Kết nối lại để nhận cập nhật mới nhất.'
                                  : 'Thông báo giao dịch, bảo mật và hệ thống sẽ hiển thị tại đây',
                            ),
                          ],
                          _ when filtered.isEmpty => [
                            _emptyState(
                              message:
                                  'Thông báo giao dịch, bảo mật và hệ thống sẽ hiển thị tại đây',
                            ),
                          ],
                          _ => [
                            _NotificationFeed(
                              notifications: filtered,
                              onOpen: _openNotification,
                              onDelete: _deleteNotification,
                            ),
                          ],
                        },
                      ],
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

  VitEmptyState _emptyState({required String message}) {
    return VitEmptyState(
      key: NotificationsPage.emptyKey,
      title: _filter == _NotificationFilter.unread
          ? 'Không có thông báo chưa đọc'
          : 'Chưa có thông báo nào',
      message: message,
      icon: Icons.notifications_off_rounded,
      actionLabel: _filter == _NotificationFilter.unread ? 'Xem tất cả' : null,
      onAction: _filter == _NotificationFilter.unread ? _toggleFilter : null,
    );
  }

  void _setFilter(_NotificationFilter filter) {
    if (_filter == filter) return;
    unawaited(HapticFeedback.selectionClick());
    setState(() => _filter = filter);
  }

  void _toggleFilter() {
    _setFilter(
      _filter == _NotificationFilter.all
          ? _NotificationFilter.unread
          : _NotificationFilter.all,
    );
  }

  void _markAllRead() {
    unawaited(HapticFeedback.selectionClick());
    ref.read(notificationsStateProvider.notifier).markAllRead();
  }

  void _deleteNotification(String id) {
    unawaited(HapticFeedback.selectionClick());
    ref.read(notificationsStateProvider.notifier).deleteNotification(id);
  }

  void _openNotification(AppNotificationDraft notification) {
    unawaited(HapticFeedback.selectionClick());
    if (!notification.isRead) {
      ref.read(notificationsStateProvider.notifier).markRead(notification.id);
    }
    final path = _safeActionPath(notification.actionPath);
    if (path != null) context.go(path);
  }
}
