import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/client_money/investor_compensation_page_sections.dart';
part '../../../widgets/client_money/investor_compensation_page_common.dart';

const _compBorder = AppColors.borderSolid;
const _compPrimary = AppColors.primary;
const _compGreen = AppColors.buy;
const _compAmber = AppColors.caution;
const _compRed = AppColors.sell;

class InvestorCompensationPage extends ConsumerStatefulWidget {
  const InvestorCompensationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc104_investor_compensation_content');
  static const overviewKey = Key('sc104_investor_compensation_overview');
  static const faqKey = Key('sc104_investor_compensation_faq');
  static Key tabKey(String id) => Key('sc104_investor_compensation_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<InvestorCompensationPage> createState() =>
      _InvestorCompensationPageState();
}

class _InvestorCompensationPageState
    extends ConsumerState<InvestorCompensationPage> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeInvestorCompensationProvider);
    return VitTradeHubScaffold(
      title: 'Investor Compensation',
      subtitle: 'FSCS Protection',
      semanticLabel: 'Bồi thường nhà đầu tư theo chương trình bảo vệ FSCS',
      semanticIdentifier: 'SC-104',
      contentKey: InvestorCompensationPage.contentKey,
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
            onAction: () => ref.invalidate(tradeInvestorCompensationProvider),
          ),
        ],
        data: (snapshot) => [
          VitTradeSection(
            title: 'Protection',
            child: _ProtectionCard(snapshot: snapshot),
          ),
          VitTradeSection(
            title: 'Details',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const VitHighRiskStatePanel(
                  state: VitHighRiskUiState.riskReview,
                  density: VitDensity.tool,
                  title: 'Compensation coverage review',
                  message:
                      'Eligibility, coverage limit, claim path, exclusions and next steps are reviewed before relying on protection.',
                  contractId: 'investor-compensation-review',
                ),
                _InfoNotice(snapshot: snapshot),
                VitCard(
                  variant: VitCardVariant.inner,
                  density: VitDensity.tool,
                  radius: VitCardRadius.tight,
                  child: VitTabBar(
                    variant: VitTabBarVariant.underline,
                    activeKey: _tab,
                    tabs: [
                      for (final tab in const [
                        ('overview', 'Overview'),
                        ('eligibility', 'Eligibility'),
                        ('claim', 'How to Claim'),
                      ])
                        VitTabItem(
                          key: tab.$1,
                          label: tab.$2,
                          widgetKey: InvestorCompensationPage.tabKey(tab.$1),
                        ),
                    ],
                    onChanged: _setTab,
                  ),
                ),
                if (_tab == 'overview')
                  _Overview(snapshot: snapshot)
                else if (_tab == 'eligibility')
                  _Eligibility(snapshot: snapshot)
                else
                  _ClaimGuide(snapshot: snapshot),
                const _FaqButton(),
              ],
            ),
          ),
          const VitTradeComplianceSection(
            title: 'Coverage review',
            statusPill: VitStatusPill(
              label: 'Coverage has limits',
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(label: 'Scheme', value: 'FSCS protection'),
              VitTradeComplianceItem(
                label: 'Action',
                value: 'Review eligibility before relying on coverage',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}
