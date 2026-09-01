import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/complaints/complaints_handling_overview_header_tabs.dart';
part '../../../widgets/complaints/complaints_handling_overview_complaints.dart';
part '../../../widgets/complaints/complaints_handling_process_common.dart';

const _complaintsBorder = AppColors.borderSolid;
const _complaintsPrimary = AppColors.primary;
const _complaintsGreen = AppColors.buy;
const _complaintsAmber = AppColors.caution;
const _complaintsRed = AppColors.sell;

enum _ComplaintsTab { overview, myComplaints, process }

class ComplaintsHandlingPage extends ConsumerStatefulWidget {
  const ComplaintsHandlingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc111_complaints_content');
  static const submitKey = Key('sc111_submit_complaint');
  static Key tabKey(String tab) => Key('sc111_tab_$tab');
  static Key complaintKey(String id) => Key('sc111_complaint_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ComplaintsHandlingPage> createState() =>
      _ComplaintsHandlingPageState();
}

class _ComplaintsHandlingPageState
    extends ConsumerState<ComplaintsHandlingPage> {
  _ComplaintsTab _tab = _ComplaintsTab.overview;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeComplaintsHandlingProvider);
    return VitTradeHubScaffold(
      title: 'Complaints Handling',
      subtitle: 'FCA Regulated Process',
      semanticLabel: 'Xử lý khiếu nại theo quy trình được FCA quản lý',
      semanticIdentifier: 'SC-111',
      contentKey: ComplaintsHandlingPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: async.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được dữ liệu',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeComplaintsHandlingProvider),
          ),
        ],
        data: (snapshot) => [
          const VitTradeSection(
            title: 'Review',
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.tool,
              title: 'Complaint process review',
              message:
                  'Complaint status, evidence, escalation, response deadline and next steps are reviewed before submission.',
              contractId: 'complaints-handling-review',
            ),
          ),
          VitTradeComplianceSection(
            title: 'Complaint process',
            statusPill: const VitStatusPill(
              label: 'Regulated process',
              status: VitStatusPillStatus.warning,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(
                label: 'Open cases',
                value: '${snapshot.complaints.length}',
              ),
              VitTradeComplianceItem(
                label: 'Response SLA',
                value: '${snapshot.averageResolutionDays} days avg',
              ),
            ],
          ),
          const VitTradeSection(
            title: 'Rights',
            child: VitTradeComplianceHero(
              title: 'Your Rights',
              description:
                  'You have the right to complain. We will investigate fairly '
                  'and respond within 8 weeks. If dissatisfied, you can refer '
                  'to the Financial Ombudsman Service.',
              icon: Icons.shield_outlined,
              accentColor: _complaintsPrimary,
            ),
          ),
          VitTradeSection(
            title: 'Complaints',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatsRow(snapshot: snapshot),
                const _SubmitComplaintButton(),
                VitCard(
                  variant: VitCardVariant.inner,
                  density: VitDensity.tool,
                  radius: VitCardRadius.tight,
                  child: VitTabBar(
                    variant: VitTabBarVariant.underline,
                    activeKey: _tab.name,
                    tabs: [
                      VitTabItem(
                        key: _ComplaintsTab.overview.name,
                        label: 'Overview',
                        widgetKey: ComplaintsHandlingPage.tabKey(
                          _ComplaintsTab.overview.name,
                        ),
                      ),
                      VitTabItem(
                        key: _ComplaintsTab.myComplaints.name,
                        label: 'My Complaints',
                        widgetKey: ComplaintsHandlingPage.tabKey(
                          _ComplaintsTab.myComplaints.name,
                        ),
                      ),
                      VitTabItem(
                        key: _ComplaintsTab.process.name,
                        label: 'Process',
                        widgetKey: ComplaintsHandlingPage.tabKey(
                          _ComplaintsTab.process.name,
                        ),
                      ),
                    ],
                    onChanged: (key) => setState(
                      () => _tab = _ComplaintsTab.values.byName(key),
                    ),
                  ),
                ),
                VitPageSection(
                  density: VitDensity.tool,
                  children: [
                    if (_tab == _ComplaintsTab.overview)
                      _OverviewContent(snapshot: snapshot),
                    if (_tab == _ComplaintsTab.myComplaints)
                      _MyComplaintsContent(complaints: snapshot.complaints),
                    if (_tab == _ComplaintsTab.process)
                      _ProcessContent(snapshot: snapshot),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
