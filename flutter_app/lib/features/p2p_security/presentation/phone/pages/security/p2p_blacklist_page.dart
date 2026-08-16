import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../../../widgets/security/p2p_blacklist_summary_filters.dart';
part '../../../widgets/security/p2p_blacklist_entries.dart';
part '../../../widgets/security/p2p_blacklist_common.dart';

const double _p2pBlacklistVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pBlacklistNativeNavClearance =
    _p2pBlacklistVisualNavClearance - AppSpacing.x4;
const double _p2pBlacklistVisualClearance = AppSpacing.x3;
const double _p2pBlacklistNativeClearance = AppSpacing.x2;
const _p2pBlacklistEntryGap = AppSpacing.x1;
const _p2pBlacklistSectionGap = AppSpacing.x2;
const _p2pBlacklistTightGap = AppSpacing.x1;
const _p2pBlacklistActionHeight = AppSpacing.searchBarCompactHeight;

class P2PBlacklistPage extends ConsumerStatefulWidget {
  const P2PBlacklistPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc277_p2p_blacklist_summary');
  static const searchKey = Key('sc277_p2p_blacklist_search');
  static const infoKey = Key('sc277_p2p_blacklist_info');
  static const addKey = Key('sc277_p2p_blacklist_add');
  static const emptyKey = Key('sc277_p2p_blacklist_empty');

  static Key filterKey(String id) => Key('sc277_p2p_blacklist_filter_$id');

  static Key entryKey(String id) => Key('sc277_p2p_blacklist_entry_$id');

  static Key unblockKey(String id) => Key('sc277_p2p_blacklist_unblock_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PBlacklistPage> createState() => _P2PBlacklistPageState();
}

class _P2PBlacklistPageState extends ConsumerState<P2PBlacklistPage> {
  final _searchController = TextEditingController();
  final _removedIds = <String>{};
  String _filterId = 'all';
  String? _expandedId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(p2pBlacklistProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pBlacklistVisualNavClearance + _p2pBlacklistVisualClearance
            : _p2pBlacklistNativeNavClearance + _p2pBlacklistNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Danh sách chặn P2P',
      semanticIdentifier: 'SC-277',
      child: Material(
        type: MaterialType.transparency,
        child: snapshotAsync.when(
          loading: () => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Đang tải…',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: const VitSkeletonList(),
          ),
          error: (error, stackTrace) => VitAutoHideHeaderScaffold(
            header: VitHeader(
              title: 'Không tải được',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.p2p),
            ),
            child: VitErrorState(
              title: 'Không tải được',
              message: 'Đã có lỗi xảy ra. Vui lòng thử lại.',
              actionLabel: 'Thử lại',
              onAction: () => ref.invalidate(p2pBlacklistProvider),
            ),
          ),
          data: (snapshot) {
            final entries = snapshot.entries
                .where((item) => !_removedIds.contains(item.id))
                .toList();
            final filtered = _filterEntries(entries);
            return VitAutoHideHeaderScaffold(
              header: VitHeader(
                title: snapshot.title,
                subtitle: snapshot.subtitle,
                showBack: true,
                onBack: () => context.go(snapshot.parentRoute),
                actions: [
                  VitHeaderActionItem(
                    key: P2PBlacklistPage.addKey,
                    type: VitHeaderActionType.add,
                    onPressed: () {
                      unawaited(HapticFeedback.selectionClick());
                      context.go(snapshot.addRoute);
                    },
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: AppModuleAccents.p2p,
                      backgroundColor: AppColors.surface2,
                      onRefresh: () async {
                        unawaited(HapticFeedback.selectionClick());
                        await Future<void>.delayed(
                          const Duration(milliseconds: 120),
                        );
                      },
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(
                          context,
                        ).copyWith(scrollbars: false),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: ClampingScrollPhysics(),
                          ),
                          padding: P2PSpacingTokens.p2pBlacklistScrollPadding(
                            scrollEndPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: P2PSpacingTokens
                                    .p2pBlacklistListSummaryPadding,
                                child: _BlacklistStats(
                                  snapshot: snapshot,
                                  entries: entries,
                                ),
                              ),
                              Padding(
                                padding: P2PSpacingTokens
                                    .p2pBlacklistHorizontalPadding,
                                child: VitSearchBar(
                                  key: P2PBlacklistPage.searchKey,
                                  controller: _searchController,
                                  placeholder: snapshot.searchHint,
                                  variant: VitSearchBarVariant.compact,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(
                                height: AppSpacing.pageRhythmCompactInnerGap,
                              ),
                              _BlacklistReasonFilters(
                                snapshot: snapshot,
                                entries: entries,
                                activeId: _filterId,
                                onChanged: (id) {
                                  unawaited(HapticFeedback.selectionClick());
                                  setState(() {
                                    _filterId = id;
                                    _expandedId = null;
                                  });
                                },
                              ),
                              Padding(
                                padding: P2PSpacingTokens
                                    .p2pBlacklistListResultPadding,
                                child: Text(
                                  '${filtered.length} kết quả',
                                  style: AppTextStyles.micro.copyWith(
                                    color: AppColors.text3,
                                    fontWeight: AppTextStyles.bold,
                                    fontFeatures: AppTextStyles.tabularFigures,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: P2PSpacingTokens
                                    .p2pBlacklistHorizontalPadding,
                                child: _EntryList(
                                  snapshot: snapshot,
                                  entries: filtered,
                                  expandedId: _expandedId,
                                  onToggle: (id) {
                                    unawaited(HapticFeedback.selectionClick());
                                    setState(() {
                                      _expandedId = _expandedId == id
                                          ? null
                                          : id;
                                    });
                                  },
                                  onUnblock: (id) {
                                    unawaited(HapticFeedback.mediumImpact());
                                    setState(() {
                                      _removedIds.add(id);
                                      if (_expandedId == id) _expandedId = null;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: AppSpacing.pageRhythmCompactInnerGap,
                              ),
                              Padding(
                                padding: P2PSpacingTokens
                                    .p2pBlacklistHorizontalPadding,
                                child: _InfoNote(snapshot: snapshot),
                              ),
                              const VitPageContent(
                                rhythm: VitPageRhythm.standard,
                                padding: VitContentPadding.compact,
                                children: [
                                  VitHighRiskStatePanel(
                                    state: VitHighRiskUiState.riskReview,
                                    title: 'Rà soát danh sách chặn',
                                    message:
                                        'Tìm kiếm, lọc theo lý do, chi tiết mở rộng, bỏ chặn và ghi chú an toàn vẫn hiển thị trước khi thao tác giao dịch P2P.',
                                    contractId: 'SC-277',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<P2PBlacklistEntryDraft> _filterEntries(
    List<P2PBlacklistEntryDraft> entries,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    return entries.where((entry) {
      final matchesSearch =
          query.isEmpty || entry.username.toLowerCase().contains(query);
      final matchesFilter = _filterId == 'all' || entry.reasonId == _filterId;
      return matchesSearch && matchesFilter;
    }).toList();
  }
}
