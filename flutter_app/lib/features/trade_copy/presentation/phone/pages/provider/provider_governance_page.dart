import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_copy_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_analytics_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_copy/domain/entities/trade_copy_entities.dart';

part '../../../widgets/provider/provider_governance_page_overview.dart';
part '../../../widgets/provider/provider_governance_page_details.dart';
part '../../../widgets/provider/provider_governance_page_common.dart';

const _governancePrimary = AppColors.primary;
const _governanceWarningBorder = AppColors.warningBorderStrong;
const _governanceWarning = AppColors.caution;

class ProviderGovernancePage extends ConsumerStatefulWidget {
  const ProviderGovernancePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc081_provider_governance_content');
  static const requestActionKey = Key('sc081_request_strategy_modification');
  static Key tabKey(String id) => Key('sc081_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProviderGovernancePage> createState() =>
      _ProviderGovernancePageState();
}

class _ProviderGovernancePageState
    extends ConsumerState<ProviderGovernancePage> {
  late String _activeTabId;
  bool _showMessagePanel = false;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeProviderGovernanceProvider);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          VitTradeHubScaffold(
            title: 'Quản trị provider',
            semanticLabel: 'Quản trị provider',
            semanticIdentifier: 'SC-081',
            contentKey: ProviderGovernancePage.contentKey,
            shellRenderMode: widget.shellRenderMode,
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
                    title: 'Không tải được dữ liệu quản trị provider',
                    message: 'Vui lòng kiểm tra kết nối và thử lại.',
                    actionLabel: 'Thử lại',
                    onAction: () =>
                        ref.invalidate(tradeProviderGovernanceProvider),
                  ),
                ],
                data: (snapshot) {
                  if (!_initialized) {
                    _activeTabId = snapshot.defaultTabId;
                    _initialized = true;
                  }
                  return [
                    VitTradeSection(
                      title: 'Dashboard',
                      child: VitTradeAnalyticsHero(
                        icon: Icons.shield_outlined,
                        title: 'Provider Dashboard',
                        subtitle:
                            'Managing ${snapshot.stats.followers} followers',
                        stats: [
                          VitTradeAnalyticsStat(
                            label: 'AUM',
                            value:
                                '\$${formatTradeCompactNumber(snapshot.stats.aum.round())}',
                            color: _governancePrimary,
                          ),
                          VitTradeAnalyticsStat(
                            label: 'This Month',
                            value:
                                '\$${snapshot.stats.monthlyFeesEarned.toStringAsFixed(0)}',
                            color: _governancePrimary,
                          ),
                          VitTradeAnalyticsStat(
                            label: 'Compliance',
                            value: '${snapshot.stats.complianceScore}/100',
                            color: _governancePrimary,
                          ),
                        ],
                      ),
                    ),
                    const VitTradeSection(
                      title: 'Review',
                      child: VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Provider governance review',
                        message:
                            'Review strategy change notice, follower impact, fee waterfall, compliance score, limits, and next steps before broadcasting or modifying strategy.',
                        contractId: 'SC-081 provider governance review',
                        density: VitDensity.tool,
                      ),
                    ),
                    VitTradeComplianceSection(
                      title: 'Governance status',
                      density: VitDensity.tool,
                      statusPill: VitStatusPill(
                        label: 'Score ${snapshot.stats.complianceScore}',
                        status: VitStatusPillStatus.info,
                        size: VitStatusPillSize.sm,
                      ),
                      items: [
                        VitTradeComplianceItem(
                          label: 'Followers',
                          value: '${snapshot.stats.followers}',
                        ),
                        VitTradeComplianceItem(
                          label: 'Last updated',
                          value: snapshot.lastUpdatedLabel,
                        ),
                      ],
                    ),
                    VitTradeSection(
                      title: 'Details',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _GovernanceTabs(
                            tabs: snapshot.tabs,
                            activeId: _activeTabId,
                            onChanged: (id) =>
                                setState(() => _activeTabId = id),
                          ),
                          if (_activeTabId == 'modifications')
                            _ModificationsTab(
                              snapshot: snapshot,
                              onRequest: () =>
                                  setState(() => _showMessagePanel = true),
                            )
                          else if (_activeTabId == 'communication')
                            _CommunicationTab(
                              snapshot: snapshot,
                              onBroadcast: () =>
                                  setState(() => _showMessagePanel = true),
                            )
                          else if (_activeTabId == 'fees')
                            _FeesTab(snapshot: snapshot)
                          else
                            _ComplianceTab(snapshot: snapshot),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          if (_showMessagePanel)
            _MessagePanel(
              onClose: () => setState(() => _showMessagePanel = false),
            ),
        ],
      ),
    );
  }
}
