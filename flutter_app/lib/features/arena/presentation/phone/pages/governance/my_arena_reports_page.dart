import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
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

part '../../../widgets/governance/my_arena_reports_page_sections.dart';
part '../../../widgets/governance/my_arena_reports_page_common.dart';

const _reportsBodyLineRatio = ArenaSpacingTokens.myArenaReportsBodyLineHeight;
const _reportsDividerExtent = ArenaSpacingTokens.myArenaReportsDividerHeight;
const _reportsFilterExtent = ArenaSpacingTokens.myArenaReportsFilterHeight;

class MyArenaReportsPage extends ConsumerStatefulWidget {
  const MyArenaReportsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc204_reports_content');
  static const emptyKey = Key('sc204_reports_empty');

  static Key filterKey(String id) => Key('sc204_filter_$id');

  static Key reportKey(String id) => Key('sc204_report_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<MyArenaReportsPage> createState() => _MyArenaReportsPageState();
}

class _MyArenaReportsPageState extends ConsumerState<MyArenaReportsPage> {
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(myArenaReportsSnapshotProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final footerPadding = arenaFooterPadding(
      context,
      mode,
      visualExtra: AppSpacing.x3,
      nativeExtra: AppSpacing.x2,
    );

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'Báo cáo của tôi trong Open Arena',
      semanticIdentifier: 'SC-204',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Báo cáo của tôi',
            subtitle: 'Báo cáo · Open Arena',
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
                    key: MyArenaReportsPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: ArenaSpacingTokens.arenaBottomScrollPadding(
                      footerPadding,
                    ),
                    child: VitPageContent(
                      rhythm: VitPageRhythm.compact,
                      padding: VitContentPadding.compact,
                      gap: VitContentGap.tight,
                      children: snapshotAsync.when(
                        loading: () => const [VitSkeletonList()],
                        error: (error, stackTrace) => [
                          VitErrorState(
                            title: 'Không tải được báo cáo của tôi',
                            message: 'Vui lòng kiểm tra kết nối và thử lại.',
                            actionLabel: 'Thử lại',
                            onAction: () =>
                                ref.invalidate(myArenaReportsSnapshotProvider),
                          ),
                        ],
                        data: (snapshot) {
                          final reports = _filteredReports(snapshot);
                          return [
                            _ReportsSummary(summary: snapshot.summary),
                            _ReportsFilterRow(
                              filters: snapshot.filters,
                              activeFilter: _activeFilter,
                              onChanged: (id) {
                                unawaited(HapticFeedback.selectionClick());
                                setState(() => _activeFilter = id);
                              },
                            ),
                            _ProcessBanner(snapshot: snapshot),
                            if (reports.isEmpty)
                              VitEmptyState(
                                key: MyArenaReportsPage.emptyKey,
                                icon: Icons.flag_outlined,
                                title: snapshot.emptyTitle,
                                message: _emptyMessage(snapshot),
                              )
                            else
                              _ReportsCard(reports: reports),
                            if (reports.isNotEmpty)
                              Text(
                                _countLabel(reports.length, snapshot.filters),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text3,
                                ),
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

  List<ArenaReportCaseDraft> _filteredReports(MyArenaReportsSnapshot snapshot) {
    final activeFilter = snapshot.filters.firstWhere(
      (filter) => filter.id == _activeFilter,
      orElse: () => snapshot.filters.first,
    );
    final status = activeFilter.status;
    if (status == null) return snapshot.reports;
    return snapshot.reports
        .where((report) => report.status == status)
        .toList(growable: false);
  }

  String _emptyMessage(MyArenaReportsSnapshot snapshot) {
    if (_activeFilter == 'all') return snapshot.emptySubtitle;
    final filter = snapshot.filters.firstWhere(
      (item) => item.id == _activeFilter,
      orElse: () => snapshot.filters.first,
    );
    return 'Không có báo cáo nào ở trạng thái "${filter.label}".';
  }

  String _countLabel(int count, List<MyArenaReportsFilterDraft> filters) {
    if (_activeFilter == 'all') return '$count báo cáo';
    final filter = filters.firstWhere(
      (item) => item.id == _activeFilter,
      orElse: () => filters.first,
    );
    return '$count báo cáo (${filter.label})';
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
