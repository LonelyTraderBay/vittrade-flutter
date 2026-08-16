import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/governance/audit_trail_page_sections.dart';
part '../../../widgets/governance/audit_trail_page_common.dart';

const _auditBorder = AppColors.borderSolid;
const _auditPrimary = AppColors.primary;
const _auditGreen = AppColors.buy;
const _auditAmber = AppColors.caution;

class AuditTrailPage extends ConsumerStatefulWidget {
  const AuditTrailPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc115_audit_trail_content');
  static const searchKey = Key('sc115_audit_trail_search');
  static Key tabKey(String id) => Key('sc115_audit_trail_tab_$id');
  static Key exportKey(String format) =>
      Key('sc115_audit_trail_export_$format');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AuditTrailPage> createState() => _AuditTrailPageState();
}

class _AuditTrailPageState extends ConsumerState<AuditTrailPage> {
  String _activeTab = 'all';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeAuditTrailProvider);

    return VitTradeHubScaffold(
      title: 'Audit Trail',
      subtitle: 'MiFID II Record-Keeping',
      semanticLabel: 'Nhật ký kiểm toán lưu trữ hồ sơ theo MiFID II',
      semanticIdentifier: 'SC-115',
      contentKey: AuditTrailPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      headerActions: const [
        VitHeaderActionItem(type: VitHeaderActionType.export, onPressed: null),
      ],
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeAuditTrailProvider),
          ),
        ],
        data: (snapshot) {
          final entries = _filteredEntries(snapshot.entries);
          return [
            const VitTradeSection(
              title: 'Review',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                density: VitDensity.tool,
                title: 'Review audit trail export',
                message:
                    'Confirm record scope, retention limits, client identifiers, and next steps before exporting audit evidence.',
              ),
            ),
            VitTradeComplianceSection(
              title: 'Record status',
              statusPill: VitStatusPill(
                label: '${entries.length} shown',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
              items: const [
                VitTradeComplianceItem(
                  label: 'Framework',
                  value: 'MiFID II record-keeping',
                ),
                VitTradeComplianceItem(
                  label: 'Export',
                  value: 'Review scope before export',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Audit Log',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VitTradeComplianceHero(
                    key: const Key('sc115_audit_trail_notice'),
                    title: snapshot.noticeTitle,
                    description: snapshot.noticeDescription,
                    icon: Icons.description_outlined,
                    accentColor: AppColors.text1,
                  ),
                  _StatsRow(stats: snapshot.stats),
                  _SearchAndFilter(
                    placeholder: snapshot.searchPlaceholder,
                    onChanged: (value) => setState(() => _query = value),
                  ),
                  _AuditTabs(
                    tabs: snapshot.tabs,
                    activeId: _activeTab,
                    onChanged: (id) => setState(() => _activeTab = id),
                  ),
                  for (final entry in entries) _AuditEntryCard(entry: entry),
                  _ExportActions(formats: snapshot.exportFormats),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }

  List<TradeAuditEntry> _filteredEntries(List<TradeAuditEntry> entries) {
    return entries.where((entry) {
      final matchesTab = switch (_activeTab) {
        'trades' => entry.category == TradeAuditCategory.trade,
        'compliance' => entry.category == TradeAuditCategory.compliance,
        'client' => entry.category == TradeAuditCategory.clientAction,
        _ => true,
      };
      if (!matchesTab) return false;
      final query = _query.trim().toLowerCase();
      if (query.isEmpty) return true;
      return entry.action.toLowerCase().contains(query) ||
          entry.details.toLowerCase().contains(query) ||
          entry.id.toLowerCase().contains(query);
    }).toList();
  }
}
