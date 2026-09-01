import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/widgets/trade_copy_header_body_card.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/shared_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/safety/copy_safety_overview.dart';
part '../../../widgets/safety/copy_safety_metrics_tools.dart';
part '../../../widgets/safety/copy_safety_enforcement_common.dart';

const _safetyPrimary = AppColors.primary;
const _safetyWarningBorder = AppColors.warningBorderStrong;
const _safetySpace = AppSpacing.x2;
const _safetyCardSpace = AppSpacing.x3;
const _safetyHeroLineHeight = 1.08;
const _safetyBodyLineHeight = 1.22;
const _safetyReadableLineHeight = 1.28;

class CopySafetyCenterPage extends ConsumerStatefulWidget {
  const CopySafetyCenterPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc083_copy_safety_center_content');
  static Key tabKey(String id) => Key('sc083_tab_$id');
  static Key metricKey(String name) => Key('sc083_metric_$name');
  static Key toolKey(String id) => Key('sc083_tool_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopySafetyCenterPage> createState() =>
      _CopySafetyCenterPageState();
}

class _CopySafetyCenterPageState extends ConsumerState<CopySafetyCenterPage> {
  String? _activeTabId;
  String? _expandedMetric;
  bool _showEmergencyPanel = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeCopySafetyCenterProvider);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          VitTradeHubScaffold(
            title: 'Trung tâm an toàn',
            semanticLabel: 'Trung tâm an toàn sao chép giao dịch',
            semanticIdentifier: 'SC-083',
            contentKey: CopySafetyCenterPage.contentKey,
            shellRenderMode: widget.shellRenderMode,
            useCopyTradingInset: true,
            onBack: () => goBackOrFallback(
              context,
              fallbackPath: AppRoutePaths.tradeCopyTrading,
              mode: BackNavigationMode.historyThenFallback,
            ),
            children: [
              ...snapshotAsync.when(
                loading: () => const [VitSkeletonList()],
                error: (error, stackTrace) => [
                  VitErrorState(
                    title: 'Không tải được trung tâm an toàn',
                    message: 'Vui lòng kiểm tra kết nối và thử lại.',
                    actionLabel: 'Thử lại',
                    onAction: () =>
                        ref.invalidate(tradeCopySafetyCenterProvider),
                  ),
                ],
                data: (snapshot) {
                  _activeTabId ??= snapshot.defaultTabId;
                  final activeTab = snapshot.tabs.firstWhere(
                    (tab) => tab.id == _activeTabId,
                    orElse: () => snapshot.tabs.first,
                  );
                  return [
                    VitTradeSection(
                      title: 'Overview',
                      child: VitTradeComplianceHero(
                        title: snapshot.heroTitle,
                        description: snapshot.heroDescription,
                        icon: Icons.shield_outlined,
                        accentColor: _safetyPrimary,
                      ),
                    ),
                    VitTradeSection(
                      title: 'Controls',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SafetyTabs(
                            tabs: snapshot.tabs,
                            activeId: _activeTabId!,
                            onChanged: (id) =>
                                setState(() => _activeTabId = id),
                          ),
                          _SafetyTabBody(
                            activeTabId: _activeTabId!,
                            snapshot: snapshot,
                            expandedMetric: _expandedMetric,
                            onMetricToggle: (name) => setState(() {
                              _expandedMetric = _expandedMetric == name
                                  ? null
                                  : name;
                            }),
                            onEmergency: () =>
                                setState(() => _showEmergencyPanel = true),
                          ),
                        ],
                      ),
                    ),
                    VitTradeComplianceSection(
                      title: 'Safety review',
                      density: VitDensity.tool,
                      statusPill: VitStatusPill(
                        label: 'Reviewing: ${activeTab.label}',
                        status: VitStatusPillStatus.warning,
                        size: VitStatusPillSize.sm,
                      ),
                      items: const [
                        VitTradeComplianceItem(
                          label: 'Scope',
                          value: 'Verification, trust metrics, reporting',
                        ),
                        VitTradeComplianceItem(
                          label: 'Action',
                          value: 'Review before allowing copied trades',
                        ),
                      ],
                    ),
                  ];
                },
              ),
            ],
          ),
          if (_showEmergencyPanel)
            _EmergencyPanel(
              onClose: () => setState(() => _showEmergencyPanel = false),
            ),
        ],
      ),
    );
  }
}
