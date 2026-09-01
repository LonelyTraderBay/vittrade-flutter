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
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_formatters.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/client_money/client_money_protection_page_sections.dart';
part '../../../widgets/client_money/client_money_protection_page_common.dart';

const _moneyBorder = AppColors.borderSolid;
const _moneyPrimary = AppColors.primary;
const _moneyGreen = AppColors.buy;

class ClientMoneyProtectionPage extends ConsumerStatefulWidget {
  const ClientMoneyProtectionPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc102_client_money_content');
  static const overviewSectionKey = Key('sc102_client_money_overview_section');
  static Key tabKey(String id) => Key('sc102_client_money_tab_$id');
  static const cassHistoryKey = Key('sc102_cass_history');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ClientMoneyProtectionPage> createState() =>
      _ClientMoneyProtectionPageState();
}

class _ClientMoneyProtectionPageState
    extends ConsumerState<ClientMoneyProtectionPage> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeClientMoneyProtectionProvider);

    return VitTradeHubScaffold(
      title: 'Client Money Protection',
      subtitle: 'CASS 7 Compliance',
      semanticLabel: 'Bảo vệ tiền của khách hàng theo quy định CASS 7',
      semanticIdentifier: 'SC-102',
      contentKey: ClientMoneyProtectionPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
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
            onAction: () => ref.invalidate(tradeClientMoneyProtectionProvider),
          ),
        ],
        data: (snapshot) => [
          const VitTradeSection(
            title: 'Protection notice',
            child: VitTradeComplianceHero(
              title: 'Your Funds Are Protected',
              description:
                  'All client money is held in segregated bank accounts and '
                  'reconciled daily per FCA CASS 7 rules.',
              icon: Icons.shield_outlined,
              accentColor: AppColors.text1,
            ),
          ),
          VitTradeSection(
            title: 'Segregated balance',
            child: _BalanceCard(snapshot: snapshot),
          ),
          VitTradeSection(
            title: 'Details',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VitSegmentedTabBar(
                  tabs: [
                    for (final tab in const [
                      ('overview', 'Overview'),
                      ('reconciliation', 'Reconciliation'),
                      ('documents', 'Documents'),
                    ])
                      VitTabItem(
                        key: tab.$1,
                        label: tab.$2,
                        widgetKey: ClientMoneyProtectionPage.tabKey(tab.$1),
                      ),
                  ],
                  activeKey: _tab,
                  onChanged: _setTab,
                ),
                if (_tab == 'overview')
                  _Overview(snapshot: snapshot)
                else if (_tab == 'reconciliation')
                  const _Reconciliation()
                else
                  const _Documents(),
              ],
            ),
          ),
          VitTradeComplianceSection(
            title: 'CASS status',
            statusPill: const VitStatusPill(
              label: 'CASS review',
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(
                label: 'Trust account',
                value: snapshot.trustAccount,
              ),
              const VitTradeComplianceItem(
                label: 'Framework',
                value: 'FCA CASS 7',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}
