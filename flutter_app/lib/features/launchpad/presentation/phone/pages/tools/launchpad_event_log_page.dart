import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

part '../../../widgets/tools/launchpad_event_log_filter_widgets.dart';
part '../../../widgets/tools/launchpad_event_log_list_widgets.dart';
part '../../../widgets/tools/launchpad_event_log_export_widgets.dart';
part '../../../widgets/tools/launchpad_event_log_misc_widgets.dart';

class LaunchpadEventLogPage extends ConsumerStatefulWidget {
  const LaunchpadEventLogPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc307_launchpad_event_log_content');
  static const searchKey = Key('sc307_launchpad_event_log_search');
  static const levelsKey = Key('sc307_launchpad_event_log_levels');
  static const actionsKey = Key('sc307_launchpad_event_log_actions');
  static const sourcesKey = Key('sc307_launchpad_event_log_sources');
  static const eventListKey = Key('sc307_launchpad_event_log_list');
  static const emptyKey = Key('sc307_launchpad_event_log_empty');
  static const selectAllKey = Key('sc307_launchpad_event_log_select_all');
  static const exportButtonKey = Key('sc307_launchpad_event_log_export');
  static const exportSheetKey = Key('sc307_launchpad_event_log_export_sheet');
  static const copyButtonKey = Key('sc307_launchpad_event_log_copy');

  static Key levelKey(String value) =>
      Key('sc307_launchpad_event_log_level_$value');
  static Key sourceKey(String value) =>
      Key('sc307_launchpad_event_log_source_$value');
  static Key eventKey(String id) => Key('sc307_launchpad_event_log_event_$id');
  static Key eventSelectKey(String id) =>
      Key('sc307_launchpad_event_log_select_$id');
  static Key eventExpandKey(String id) =>
      Key('sc307_launchpad_event_log_expand_$id');
  static Key formatKey(String value) =>
      Key('sc307_launchpad_event_log_format_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadEventLogPage> createState() =>
      _LaunchpadEventLogPageState();
}

class _LaunchpadEventLogPageState extends ConsumerState<LaunchpadEventLogPage> {
  final _searchController = TextEditingController();
  var _searchQuery = '';
  var _levelFilter = 'all';
  var _sourceFilter = 'all';
  var _showSourceFilters = false;
  var _showExportSheet = false;
  var _exportFormat = 'text';
  var _copied = false;
  String? _expandedEventId;
  final Set<String> _selectedEventIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventLogAsync = ref.watch(launchpadEventLogSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollTailReserve =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.x3;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Nhật ký sự kiện trên chuỗi của Launchpad',
      semanticIdentifier: 'SC-307',
      child: Material(
        type: MaterialType.transparency,
        child: eventLogAsync.when(
          loading: () => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: scrollTailReserve,
                semanticLabel: 'Nhật ký sự kiện trên chuỗi của Launchpad',
                semanticIdentifier: 'SC-307',
                header: VitHeader(
                  title: 'Event Log',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: const VitSkeletonList(),
              ),
            ],
          ),
          error: (error, stackTrace) => Stack(
            children: [
              VitAutoHideHeaderScaffold(
                bottomInset: scrollTailReserve,
                semanticLabel: 'Nhật ký sự kiện trên chuỗi của Launchpad',
                semanticIdentifier: 'SC-307',
                header: VitHeader(
                  title: 'Event Log',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.launchpad),
                ),
                child: VitErrorState(
                  title: 'Không tải được dữ liệu',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(launchpadEventLogSnapshotProvider),
                ),
              ),
            ],
          ),
          data: (snapshot) {
            final filteredEvents = _filteredEvents(snapshot.events);
            final exportEvents = _selectedEventIds.isEmpty
                ? filteredEvents
                : filteredEvents
                      .where((event) => _selectedEventIds.contains(event.id))
                      .toList();
            final sources = _sources(snapshot.events);

            return Stack(
              children: [
                VitAutoHideHeaderScaffold(
                  bottomInset: scrollTailReserve,
                  semanticLabel: 'Nhật ký sự kiện trên chuỗi của Launchpad',
                  semanticIdentifier: 'SC-307',
                  header: VitHeader(
                    title: snapshot.title,
                    subtitle: 'Nhật ký sự kiện on-chain · Tham khảo rủi ro',
                    showBack: true,
                    onBack: () => context.go(snapshot.backRoute),
                  ),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      key: LaunchpadEventLogPage.contentKey,
                      physics: const ClampingScrollPhysics(),
                      child: VitPageContent(
                        rhythm: VitPageRhythm.standard,
                        padding: VitContentPadding.compact,
                        gap: VitContentGap.tight,
                        children: [
                          _SearchField(
                            controller: _searchController,
                            query: _searchQuery,
                            onChanged: (value) => setState(() {
                              _searchQuery = value;
                              _selectedEventIds.clear();
                            }),
                            onClear: () => setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                              _selectedEventIds.clear();
                            }),
                          ),
                          _LevelFilterBar(
                            events: snapshot.events,
                            activeValue: _levelFilter,
                            onChanged: (value) => setState(() {
                              _levelFilter = value;
                              _selectedEventIds.clear();
                            }),
                          ),
                          _ActionBar(
                            sourceLabel: _sourceFilter == 'all'
                                ? 'Nguon'
                                : _sourceFilter,
                            sourceOpen: _showSourceFilters,
                            selectedAll:
                                filteredEvents.isNotEmpty &&
                                _selectedEventIds.length ==
                                    filteredEvents.length,
                            exportCount: exportEvents.length,
                            onToggleSources: () => setState(
                              () => _showSourceFilters = !_showSourceFilters,
                            ),
                            onToggleSelectAll: () =>
                                _toggleSelectAll(filteredEvents),
                            onExport: () =>
                                setState(() => _showExportSheet = true),
                          ),
                          if (_showSourceFilters)
                            _SourceFilterCard(
                              sources: sources,
                              activeValue: _sourceFilter,
                              onChanged: (value) => setState(() {
                                _sourceFilter = value;
                                _showSourceFilters = false;
                                _selectedEventIds.clear();
                              }),
                            ),
                          if (filteredEvents.isEmpty)
                            const _EmptyEvents()
                          else
                            _EventList(
                              events: filteredEvents,
                              selectedIds: _selectedEventIds,
                              expandedId: _expandedEventId,
                              onSelect: _toggleEventSelection,
                              onExpand: (id) => setState(() {
                                _expandedEventId = _expandedEventId == id
                                    ? null
                                    : id;
                              }),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_showExportSheet)
                  Positioned.fill(
                    child: _ExportSheet(
                      formats: snapshot.exportFormats,
                      activeFormat: _exportFormat,
                      count: exportEvents.length,
                      copied: _copied,
                      onFormatChanged: (value) =>
                          setState(() => _exportFormat = value),
                      onClose: () => setState(() {
                        _showExportSheet = false;
                        _copied = false;
                      }),
                      onCopy: () => _copyEvents(exportEvents),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<LaunchpadEventLogEntryDraft> _filteredEvents(
    List<LaunchpadEventLogEntryDraft> events,
  ) {
    final query = _searchQuery.trim().toLowerCase();
    return events.where((event) {
      if (_levelFilter != 'all' && event.level.value != _levelFilter) {
        return false;
      }
      if (_sourceFilter != 'all' && event.source != _sourceFilter) {
        return false;
      }
      if (query.isEmpty) {
        return true;
      }
      return event.message.toLowerCase().contains(query) ||
          event.source.toLowerCase().contains(query) ||
          (event.details ?? '').toLowerCase().contains(query) ||
          event.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  List<String> _sources(List<LaunchpadEventLogEntryDraft> events) {
    return ['all', ...events.map((event) => event.source).toSet()];
  }

  void _toggleSelectAll(List<LaunchpadEventLogEntryDraft> filteredEvents) {
    setState(() {
      if (_selectedEventIds.length == filteredEvents.length) {
        _selectedEventIds.clear();
      } else {
        _selectedEventIds
          ..clear()
          ..addAll(filteredEvents.map((event) => event.id));
      }
    });
  }

  void _toggleEventSelection(String id) {
    setState(() {
      if (_selectedEventIds.contains(id)) {
        _selectedEventIds.remove(id);
      } else {
        _selectedEventIds.add(id);
      }
    });
  }

  Future<void> _copyEvents(List<LaunchpadEventLogEntryDraft> events) async {
    setState(() => _copied = true);
    try {
      await Clipboard.setData(
        ClipboardData(text: _formatEvents(events, _exportFormat)),
      );
    } catch (_) {
      // Widget tests and webview shells may not expose a platform clipboard.
    }
  }

  String _formatEvents(
    List<LaunchpadEventLogEntryDraft> events,
    String format,
  ) {
    switch (format) {
      case 'json':
        return '{"count":${events.length},"entries":[${events.map((event) => '{"id":"${event.id}","level":"${event.level.value}","source":"${event.source}","message":"${event.message}"}').join(',')}]}';
      case 'csv':
        return [
          'timestamp,level,source,message,tags',
          for (final event in events)
            '${event.timestamp},${event.level.value},${event.source},"${event.message}","${event.tags.join(';')}"',
        ].join('\n');
      default:
        return [
          '=== Launchpad Event Log ===',
          'Entries: ${events.length}',
          for (final event in events)
            '[${event.timestamp}] [${event.level.value.toUpperCase()}] ${event.source}\n  ${event.message}',
        ].join('\n\n');
    }
  }
}
