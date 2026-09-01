import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/arena/presentation/widgets/phone/arena_viewport_padding.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';
import 'package:vit_trade_flutter/app/theme/spacing/arena_spacing_tokens.dart';

part '../../../widgets/points/arena_points_ledger_page_sections.dart';
part '../../../widgets/points/arena_points_ledger_page_common.dart';

const _arenaAccent = AppModuleAccents.arena;
const _ledgerCompactLineRatio = ArenaSpacingTokens.arenaPointsCompactLineHeight;
const _ledgerDividerExtent = ArenaSpacingTokens.arenaPointsDividerHeight;
const _ledgerNoticeLineRatio = ArenaSpacingTokens.arenaPointsNoticeLineHeight;

class ArenaPointsLedgerPage extends ConsumerStatefulWidget {
  const ArenaPointsLedgerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc201_ledger_content');
  static const searchKey = Key('sc201_ledger_search');
  static const communityRulesKey = Key('sc201_community_rules');

  static Key filterKey(String id) => Key('sc201_filter_$id');

  static Key entryKey(String id) => Key('sc201_entry_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaPointsLedgerPage> createState() =>
      _ArenaPointsLedgerPageState();
}

class _ArenaPointsLedgerPageState extends ConsumerState<ArenaPointsLedgerPage> {
  String _activeFilter = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(arenaPointsLedgerSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Lịch sử sổ điểm Arena Points trong Open Arena',
      semanticIdentifier: 'SC-201',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Lịch sử Arena Points',
            subtitle: 'Sổ điểm · Open Arena',
            showBack: true,
            onBack: () => _close(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: ArenaPointsLedgerPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      footerPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.standard,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được sổ điểm Arena',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () => ref.invalidate(
                              arenaPointsLedgerSnapshotProvider,
                            ),
                          ),
                        ],
                        data: (snapshot) {
                          final entries = _filteredEntries(snapshot.entries);
                          return [
                            _BalanceSummary(summary: snapshot.summary),
                            VitSearchBar(
                              key: ArenaPointsLedgerPage.searchKey,
                              placeholder: 'Tìm theo tên challenge, lý do...',
                              onChanged: (value) {
                                setState(() => _searchQuery = value);
                              },
                            ),
                            _LedgerFilterRow(
                              filters: snapshot.filters,
                              activeFilter: _activeFilter,
                              onChanged: (id) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _activeFilter = id);
                              },
                            ),
                            Text(
                              '${entries.length} bản ghi',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                            if (entries.isEmpty)
                              VitEmptyState(
                                icon: Icons.receipt_long_outlined,
                                title: snapshot.emptyTitle,
                                message: snapshot.emptySubtitle,
                              )
                            else
                              _LedgerList(entries: entries),
                            _AuditNotice(disclaimer: snapshot.disclaimer),
                            VitCommunityRulesLink(
                              key: ArenaPointsLedgerPage.communityRulesKey,
                              onTap: () {
                                unawaited(HapticFeedback.selectionClick());
                                context.go(AppRoutePaths.arenaSafety);
                              },
                            ),
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

  List<ArenaPointsLedgerEntryDraft> _filteredEntries(
    List<ArenaPointsLedgerEntryDraft> entries,
  ) {
    final query = _searchQuery.trim().toLowerCase();
    return entries
        .where((entry) {
          if (_activeFilter != 'all' && entry.typeId != _activeFilter) {
            return false;
          }
          if (query.isEmpty) return true;
          final haystack = [
            entry.title,
            entry.reasonCode,
            entry.linkedChallengeName,
            entry.linkedModeName,
          ].whereType<String>().join(' ').toLowerCase();
          return haystack.contains(query);
        })
        .toList(growable: false);
  }

  static void _close(BuildContext context) {
    unawaited(HapticFeedback.selectionClick());
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}
