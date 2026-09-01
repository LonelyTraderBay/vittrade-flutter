import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/governance/regulatory_inspection_ready_page_sections.dart';
part '../../../widgets/governance/regulatory_inspection_ready_page_common.dart';

const _inspectionPanel2 = AppColors.surface2;
const _inspectionBorder = AppColors.borderSolid;
const _inspectionGreen = AppColors.buy;
const _inspectionPrimary = AppColors.primary;
const _inspectionAmber = AppColors.caution;

class RegulatoryInspectionReadyPage extends ConsumerWidget {
  const RegulatoryInspectionReadyPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc116_regulatory_inspection_content');
  static const reportKey = Key('sc116_regulatory_inspection_report');
  static const portalKey = Key('sc116_regulatory_inspection_portal');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tradeRegulatoryInspectionReadyProvider);
    return VitTradeHubScaffold(
      title: 'Regulatory Compliance',
      subtitle: 'Inspection Ready Dashboard',
      semanticLabel: 'Sẵn sàng thanh tra tuân thủ quy định',
      semanticIdentifier: 'SC-116',
      contentKey: contentKey,
      shellRenderMode: shellRenderMode,
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
            onAction: () =>
                ref.invalidate(tradeRegulatoryInspectionReadyProvider),
          ),
        ],
        data: (snapshot) => [
          const VitTradeSection(
            title: 'Review',
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.tool,
              title: 'Review inspection readiness evidence',
              message:
                  'Confirm report scope, access limits, retained records, and next steps before sharing compliance material.',
            ),
          ),
          VitTradeComplianceSection(
            title: 'Inspection status',
            statusPill: VitStatusPill(
              label: 'Score ${snapshot.complianceScore}',
              status: VitStatusPillStatus.success,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(
                label: 'Frameworks',
                value: '${snapshot.frameworks.length} covered',
              ),
              VitTradeComplianceItem(
                label: 'Documents',
                value: '${snapshot.documents.length} retained',
              ),
            ],
          ),
          VitTradeSection(
            title: 'Readiness',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ComplianceScoreCard(snapshot: snapshot),
                _QuickStats(stats: snapshot.stats),
                const VitSectionHeader(
                  title: 'Regulatory Framework Coverage',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: _inspectionPrimary,
                ),
                for (final framework in snapshot.frameworks)
                  _FrameworkCard(framework: framework),
                const VitSectionHeader(
                  title: 'Document Repository',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: _inspectionPrimary,
                ),
                for (final document in snapshot.documents)
                  _DocumentCard(document: document),
                const VitSectionHeader(
                  title: 'Regulatory Inspector Access',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: _inspectionPrimary,
                ),
                _InspectorPortalCard(snapshot: snapshot),
                _ReportButton(snapshot: snapshot),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
