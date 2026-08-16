import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/safety/copy_audit_log_controls.dart';
part '../../../widgets/safety/copy_audit_log_events.dart';
part '../../../widgets/safety/copy_audit_log_summary.dart';

const _auditPrimary = AppColors.primary;
const _auditAmber = AppColors.caution;
const _auditPurple = AppColors.accent;
const _auditGreen = AppColors.buy;
const double _auditSpace = AppSpacing.x2;
const double _auditTinySpace = AppSpacing.x1;
const double _auditTitleLineHeight = 1.12;
const double _auditBodyLineHeight = 1.22;
const double _auditMetaLineHeight = 1.05;
const double _auditSheetTitleLineHeight = 1.15;

class CopyAuditLogPage extends ConsumerStatefulWidget {
  const CopyAuditLogPage({
    super.key,
    required this.copyId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc077_copy_audit_log_content');
  static const searchFieldKey = Key('sc077_copy_audit_search');
  static const exportActionKey = Key('sc077_export_action');
  static const emptyStateKey = Key('sc077_empty_state');

  static Key tabKey(String id) => Key('sc077_tab_$id');
  static Key eventKey(String id) => Key('sc077_event_$id');
  static Key exportFormatKey(String id) => Key('sc077_export_$id');

  final String copyId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyAuditLogPage> createState() => _CopyAuditLogPageState();
}

class _CopyAuditLogPageState extends ConsumerState<CopyAuditLogPage> {
  final TextEditingController _searchController = TextEditingController();
  String _activeFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeCopyAuditLogProvider(widget.copyId));

    return VitTradeDetailScaffold(
      title: 'Nhật ký kiểm toán',
      semanticLabel: 'Nhật ký kiểm toán sao chép giao dịch',
      semanticIdentifier: 'SC-077',
      contentKey: CopyAuditLogPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      headerActions: [
        VitHeaderActionItem(
          key: CopyAuditLogPage.exportActionKey,
          type: VitHeaderActionType.export,
          onPressed: () {
            final snapshot = snapshotAsync.value;
            if (snapshot != null) _showExportSheet(snapshot);
          },
        ),
      ],
      children: [
        ...snapshotAsync.when(
          loading: () => const [VitSkeletonList()],
          error: (error, stackTrace) => [
            VitErrorState(
              title: 'Không tải được nhật ký kiểm toán',
              message: 'Vui lòng kiểm tra kết nối và thử lại.',
              actionLabel: 'Thử lại',
              onAction: () =>
                  ref.invalidate(tradeCopyAuditLogProvider(widget.copyId)),
            ),
          ],
          data: (snapshot) {
            final events = _filteredEvents(snapshot);
            return [
              VitTradeSection(
                title: 'Tuân thủ',
                child: VitTradeComplianceHero(
                  title: snapshot.complianceTitle,
                  description: snapshot.complianceDescription,
                  icon: Icons.shield_outlined,
                  accentColor: _auditPrimary,
                ),
              ),
              VitTradeSection(
                title: 'Đánh giá rủi ro',
                child: VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Review copy audit evidence',
                  message:
                      'Search, filter, and export audit evidence with retention, risk, and config-change context preserved.',
                  contractId: 'Copy ID: ${snapshot.copyId}',
                  density: VitDensity.tool,
                ),
              ),
              VitTradeSection(
                title: 'Tìm kiếm',
                child: _AuditSearchField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              VitTradeSection(
                title: 'Bộ lọc',
                child: VitTabBar(
                  variant: VitTabBarVariant.segment,
                  activeKey: _activeFilter,
                  onChanged: (id) => setState(() => _activeFilter = id),
                  tabs: [
                    for (final tab in snapshot.tabs)
                      VitTabItem(
                        key: tab.id,
                        label: tab.label,
                        widgetKey: CopyAuditLogPage.tabKey(tab.id),
                      ),
                  ],
                ),
              ),
              VitTradeSection(
                title: 'Sự kiện',
                child: events.isEmpty
                    ? _EmptyAuditState(
                        searching: _searchController.text.isNotEmpty,
                      )
                    : Column(
                        children: [
                          for (final event in events) ...[
                            _AuditEventCard(
                              key: CopyAuditLogPage.eventKey(event.id),
                              event: event,
                            ),
                            if (event != events.last)
                              const SizedBox(height: _auditSpace),
                          ],
                        ],
                      ),
              ),
              VitTradeSection(
                title: 'Tóm tắt',
                child: _SummarySection(events: snapshot.events),
              ),
            ];
          },
        ),
      ],
    );
  }

  List<TradeCopyAuditEvent> _filteredEvents(
    TradeCopyAuditLogSnapshot snapshot,
  ) {
    final query = _searchController.text.trim().toLowerCase();
    final activeTab = snapshot.tabs.firstWhere(
      (tab) => tab.id == _activeFilter,
      orElse: () => snapshot.tabs.first,
    );

    return snapshot.events.where((event) {
      if (activeTab.type != null && event.type != activeTab.type) {
        return false;
      }
      if (query.isEmpty) return true;
      final metadata = event.metadata;
      return event.title.toLowerCase().contains(query) ||
          event.description.toLowerCase().contains(query) ||
          event.id.toLowerCase().contains(query) ||
          (metadata?.pair?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  void _showExportSheet(TradeCopyAuditLogSnapshot snapshot) {
    unawaited(
      showVitBottomSheet<void>(
        context: context,
        backgroundColor: AppColors.bg,
        barrierColor: AppColors.dynamicIslandBg.withValues(alpha: .5),
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.sheetTopLargeRadius,
        ),
        builder: (sheetContext) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: TradeSpacingTokens.copyAuditSheetPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VitSheetHandle(),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  Text(
                    'Export Audit Log',
                    style: AppTextStyles.baseMedium.copyWith(
                      fontWeight: AppTextStyles.bold,
                      height: _auditSheetTitleLineHeight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    'Chọn định dạng export',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                  const SizedBox(
                    height: AppSpacing.pageRhythmStandardSectionGap,
                  ),
                  for (final format in snapshot.exportFormats) ...[
                    _ExportFormatButton(
                      key: CopyAuditLogPage.exportFormatKey(format.id),
                      format: format,
                      onTap: () async {
                        await ref
                            .read(tradeCopyTradingRepositoryProvider)
                            .createCopyAuditExport(
                              TradeCopyAuditExportRequest(
                                copyId: snapshot.copyId,
                                format: format.id,
                                filterId: _activeFilter,
                                searchQuery: _searchController.text,
                              ),
                            );
                        if (!sheetContext.mounted) return;
                        Navigator.of(sheetContext).pop();
                      },
                    ),
                    if (format != snapshot.exportFormats.last)
                      const SizedBox(
                        height: AppSpacing.pageRhythmStandardInnerGap,
                      ),
                  ],
                  const SizedBox(height: AppSpacing.rowPy),
                  VitCtaButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    variant: VitCtaButtonVariant.secondary,
                    density: VitDensity.tool,
                    height: AppSpacing.searchBarCompactHeight,
                    child: const Text('Hủy'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
