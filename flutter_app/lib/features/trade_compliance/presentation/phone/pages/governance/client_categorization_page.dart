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
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part 'client_categorization_opt_up_page.dart';
part '../../../widgets/governance/client_categorization_page_chrome.dart';
part '../../../widgets/governance/client_categorization_overview_tab.dart';
part '../../../widgets/governance/client_categorization_protections_requirements_tab.dart';
part '../../../widgets/governance/client_categorization_history_tab.dart';

const _clientBorder = AppColors.borderSolid;
const _clientGreen = AppColors.buy;
const _clientPrimary = AppColors.primary;
const _clientAmber = AppColors.caution;

class ClientCategorizationPage extends ConsumerStatefulWidget {
  const ClientCategorizationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc099_client_categorization_content');
  static const optUpKey = Key('sc099_client_opt_up');
  static const disclosuresKey = Key('sc099_client_disclosures');
  static const settingsKey = Key('sc099_client_settings');
  static Key tabKey(String id) => Key('sc099_client_tab_$id');
  static Key categoryKey(String id) => Key('sc099_client_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ClientCategorizationPage> createState() =>
      _ClientCategorizationPageState();
}

class _ClientCategorizationPageState
    extends ConsumerState<ClientCategorizationPage> {
  String? _tab;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeClientCategorizationProvider);
    return VitTradeHubScaffold(
      title: 'Phân loại khách hàng',
      subtitle: 'Phân loại MiFID II',
      semanticLabel: 'Phân loại khách hàng theo quy định MiFID II',
      semanticIdentifier: 'SC-099',
      contentKey: ClientCategorizationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeCopyTrading,
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
            onAction: () => ref.invalidate(tradeClientCategorizationProvider),
          ),
        ],
        data: (snapshot) {
          _tab ??= snapshot.defaultTab;
          final current = snapshot.categories.firstWhere(
            (item) => item.id == snapshot.currentCategoryId,
          );
          return [
            const VitTradeSection(
              title: 'Rà soát',
              child: VitHighRiskStatePanel(
                state: VitHighRiskUiState.riskReview,
                density: VitDensity.tool,
                title: 'Rà soát phân loại khách hàng',
                message:
                    'Hạng hiện tại, thay đổi bảo vệ, bằng chứng đủ điều kiện, liên kết công bố và bước tuân thủ tiếp theo được rà soát trước khi đổi hạng.',
                contractId: 'client-categorization-review',
              ),
            ),
            VitTradeSection(
              title: 'Hạng hiện tại',
              child: _CurrentCategoryCard(category: current),
            ),
            VitTradeComplianceSection(
              title: 'Rà soát phân loại',
              statusPill: const VitStatusPill(
                label: 'Có cổng tuân thủ',
                status: VitStatusPillStatus.info,
                size: VitStatusPillSize.sm,
              ),
              items: [
                VitTradeComplianceItem(label: 'Hạng', value: current.label),
                VitTradeComplianceItem(
                  label: 'Lựa chọn',
                  value: '${snapshot.categories.length} bậc',
                ),
              ],
            ),
            VitTradeSection(
              title: 'Chi tiết',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _InfoNotice(),
                  VitSegmentedTabBar(
                    tabs: [
                      for (final tab in const [
                        ('overview', 'Tổng quan'),
                        ('protections', 'Bảo vệ'),
                        ('requirements', 'Yêu cầu'),
                        ('history', 'Lịch sử'),
                      ])
                        VitTabItem(
                          key: tab.$1,
                          label: tab.$2,
                          widgetKey: ClientCategorizationPage.tabKey(tab.$1),
                        ),
                    ],
                    activeKey: _tab!,
                    onChanged: (id) => setState(() => _tab = id),
                  ),
                  if (_tab == 'overview')
                    _OverviewTab(
                      categories: snapshot.categories,
                      currentCategoryId: snapshot.currentCategoryId,
                    )
                  else if (_tab == 'protections')
                    _ProtectionsTab(categories: snapshot.categories)
                  else if (_tab == 'requirements')
                    _RequirementsTab(categories: snapshot.categories)
                  else
                    _HistoryTab(
                      categories: snapshot.categories,
                      history: snapshot.history,
                    ),
                  const _QuickLinks(),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}
