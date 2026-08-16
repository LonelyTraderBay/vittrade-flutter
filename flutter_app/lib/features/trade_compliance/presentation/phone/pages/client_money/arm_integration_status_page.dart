import 'dart:async';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/client_money/arm_integration_providers.dart';
part '../../../widgets/client_money/arm_integration_sla_actions.dart';
part '../../../widgets/client_money/arm_integration_common_painter.dart';

const _armPanel2 = AppColors.surface2;
const _armBorder = AppColors.borderSolid;
const _armGreen = AppColors.buy;
const _armAmber = AppColors.caution;
const _armRed = AppColors.sell;
const _armPrimary = AppColors.primary;
const _armCompactChartHeight = AppSpacing.x7 + AppSpacing.x6 + AppSpacing.x6;

class ArmIntegrationStatusPage extends ConsumerStatefulWidget {
  const ArmIntegrationStatusPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc095_arm_integration_content');
  static Key connectionKey(String id) => Key('sc095_arm_connection_$id');
  static Key testKey(String id) => Key('sc095_arm_test_$id');
  static Key actionKey(String id) => Key('sc095_arm_action_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArmIntegrationStatusPage> createState() =>
      _ArmIntegrationStatusPageState();
}

class _ArmIntegrationStatusPageState
    extends ConsumerState<ArmIntegrationStatusPage> {
  String? _testingId;

  void _testConnection(String id) {
    setState(() => _testingId = id);
    Future<void>.delayed(const Duration(milliseconds: 650), () {
      if (mounted && _testingId == id) {
        setState(() => _testingId = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeArmIntegrationStatusProvider);
    return VitTradeHubScaffold(
      title: 'ARM Integration',
      subtitle: 'Connection Health · Monitoring',
      semanticLabel:
          'Trạng thái tích hợp ARM: theo dõi sức khỏe kết nối và độ trễ báo cáo giao dịch',
      semanticIdentifier: 'SC-095',
      contentKey: ArmIntegrationStatusPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeArmIntegrationStatusProvider),
          ),
        ],
        data: (snapshot) => [
          const VitTradeSection(
            title: 'Review',
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.tool,
              title: 'Review ARM integration health',
              message:
                  'Confirm provider failover, latency limits, reporting queue impact, and next steps before retrying submissions.',
            ),
          ),
          VitTradeComplianceSection(
            title: 'ARM status',
            statusPill: VitStatusPill(
              label: 'Uptime ${snapshot.sla.uptime.toStringAsFixed(1)}%',
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(
                label: 'Providers',
                value: '${snapshot.connections.length} connected',
              ),
              VitTradeComplianceItem(
                label: 'Avg latency',
                value: '${snapshot.sla.latencyAvg}ms',
              ),
            ],
          ),
          VitTradeSection(
            title: 'ARM Providers',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _OperationalAlert(),
                for (final connection in snapshot.connections)
                  _ArmProviderCard(
                    connection: connection,
                    isTesting: _testingId == connection.id,
                    onTest: () => _testConnection(connection.id),
                  ),
              ],
            ),
          ),
          VitTradeSection(
            title: 'Monitoring',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VitSectionHeader(
                  title: 'Latency Monitoring (Last 15 min)',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: _armPrimary,
                ),
                _LatencyCard(points: snapshot.latencyHistory),
                const VitSectionHeader(
                  title: 'SLA Compliance',
                  bottomGap: AppSpacing.pageRhythmStandardInnerGap,
                  variant: VitSectionHeaderVariant.accentBar,
                  accentColor: _armPrimary,
                ),
                _SlaCard(sla: snapshot.sla),
                _QuickActions(
                  onQueue: () =>
                      context.push(AppRoutePaths.tradeCopyTransactionReporting),
                  onDashboard: () => context.push(
                    AppRoutePaths.tradeCopyRegulatoryReportsDashboard,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
