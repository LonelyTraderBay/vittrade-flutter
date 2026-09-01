import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/client_money/cass_reconciliation_summary_tabs.dart';
part '../../../widgets/client_money/cass_reconciliation_records_common.dart';

const _cassPanel2 = AppColors.surface2;
const _cassBorder = AppColors.borderSolid;
const _cassPrimary = AppColors.primary;
const _cassGreen = AppColors.buy;
const _cassAmber = AppColors.caution;
const _cassRed = AppColors.sell;
const _cassSpace = AppSpacing.x2;
const _cassTinySpace = AppSpacing.x1;
const _recordIconTile = AppSpacing.iconLg;
const _exportButtonHeight = AppSpacing.searchBarCompactHeight;
const _cassLineTight = 1.2;

class CassReconciliationPage extends ConsumerStatefulWidget {
  const CassReconciliationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc103_cass_content');
  static const exportKey = Key('sc103_cass_export');
  static Key tabKey(String id) => Key('sc103_cass_tab_$id');
  static Key recordKey(String id) => Key('sc103_cass_record_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CassReconciliationPage> createState() =>
      _CassReconciliationPageState();
}

class _CassReconciliationPageState
    extends ConsumerState<CassReconciliationPage> {
  String _tab = 'recent';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeCassReconciliationProvider);
    return VitTradeHubScaffold(
      title: 'CASS Reconciliation',
      subtitle: 'Daily Client Money Matching',
      semanticLabel: 'Đối soát CASS: khớp tiền của khách hàng theo từng ngày',
      semanticIdentifier: 'SC-103',
      contentKey: CassReconciliationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyClientMoneyProtection,
        mode: BackNavigationMode.historyThenFallback,
      ),
      useCopyTradingInset: true,
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeCassReconciliationProvider),
          ),
        ],
        data: (snapshot) => [
          VitTradeComplianceSection(
            title: 'CASS status',
            statusPill: VitStatusPill(
              label: '${snapshot.outstandingCount} outstanding',
              status: snapshot.outstandingCount == 0
                  ? VitStatusPillStatus.success
                  : VitStatusPillStatus.warning,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(
                label: 'Reconciled',
                value: '${snapshot.reconciledCount}',
              ),
              VitTradeComplianceItem(
                label: 'Records',
                value: '${snapshot.records.length}',
              ),
            ],
          ),
          VitTradeSection(
            title: 'Reconciliation',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  title: 'Review CASS reconciliation evidence',
                  message:
                      'Confirm client-money balances, discrepancy status, limits, and next steps before export or escalation.',
                  density: VitDensity.tool,
                ),
                _SummaryGrid(snapshot: snapshot),
                VitSegmentedTabBar(
                  tabs: [
                    for (final tab in const [
                      ('recent', 'Recent (7 Days)'),
                      ('history', 'History'),
                    ])
                      VitTabItem(
                        key: tab.$1,
                        label: tab.$2,
                        widgetKey: CassReconciliationPage.tabKey(tab.$1),
                      ),
                  ],
                  activeKey: _tab,
                  onChanged: _setTab,
                ),
                const VitSectionHeader(
                  title: 'Reconciliation Records',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: _cassPrimary,
                ),
                for (final record in snapshot.records)
                  _RecordCard(record: record),
                const _ExportButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}
