import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_compliance_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_hero.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_compliance_section.dart';
import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';

part '../../../widgets/disclosures/ex_ante_costs_overview.dart';
part '../../../widgets/disclosures/ex_ante_costs_summary_breakdown.dart';
part '../../../widgets/disclosures/ex_ante_costs_scenarios_actions.dart';
part '../../../widgets/disclosures/ex_ante_costs_common.dart';

const _costBorder = AppColors.borderSolid;
const _costPrimary = AppColors.primary;
const _costGreen = AppColors.buy;
const _costAmber = AppColors.caution;
const _costRed = AppColors.sell;
const _costSpace = AppSpacing.x2;
const _costTinySpace = AppSpacing.x1;
const _costIconTile = AppSpacing.iconLg;
const _costButtonExtent = AppSpacing.searchBarCompactHeight;
const _costTabExtent = AppSpacing.searchBarCompactHeight;
const _costSwatchExtent = AppSpacing.statusPillIconSizeLg;
const _costLineTight = 1.2;

class ExAnteCostsPage extends ConsumerStatefulWidget {
  const ExAnteCostsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc105_ex_ante_content');
  static const riyKey = Key('sc105_ex_ante_riy');
  static const exPostKey = Key('sc105_ex_ante_ex_post');
  static const kidKey = Key('sc105_ex_ante_kid');
  static Key tabKey(String id) => Key('sc105_ex_ante_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ExAnteCostsPage> createState() => _ExAnteCostsPageState();
}

class _ExAnteCostsPageState extends ConsumerState<ExAnteCostsPage> {
  String _tab = 'summary';
  int _holdingPeriod = 3;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(tradeExAnteCostsProvider);
    return VitTradeHubScaffold(
      title: 'Cost Disclosure (Ex-Ante)',
      subtitle: 'Before You Invest',
      semanticLabel: 'Công bố chi phí dự kiến trước khi đầu tư',
      semanticIdentifier: 'SC-105',
      contentKey: ExAnteCostsPage.contentKey,
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
            onAction: () => ref.invalidate(tradeExAnteCostsProvider),
          ),
        ],
        data: (snapshot) => [
          const VitTradeSection(
            title: 'Review',
            child: VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              title: 'Ex-ante cost preview',
              message:
                  'Review fees, RIY impact, limits, and next-step documents before investing.',
              contractId: 'SC-105 ex-ante costs review',
              density: VitDensity.tool,
            ),
          ),
          VitTradeComplianceSection(
            title: 'Cost preview',
            statusPill: const VitStatusPill(
              label: 'Review required',
              status: VitStatusPillStatus.info,
              size: VitStatusPillSize.sm,
            ),
            items: [
              VitTradeComplianceItem(
                label: 'Investment',
                value: '€${snapshot.investmentAmount.toStringAsFixed(0)}',
              ),
              VitTradeComplianceItem(
                label: 'Holding period',
                value: '$_holdingPeriod years',
              ),
            ],
          ),
          const VitTradeSection(
            title: 'Notice',
            child: VitTradeComplianceHero(
              title: 'PRIIPs Cost Disclosure',
              description:
                  'This document shows all costs you will pay before investing. '
                  'Required by EU regulation for retail clients.',
              icon: Icons.shield_outlined,
              accentColor: _costPrimary,
            ),
          ),
          VitTradeSection(
            title: 'Costs',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InvestmentCard(snapshot: snapshot),
                // card-tile: allow-start — fixed surface, not horizontal strip tile
                VitCard(
                  height: _costTabExtent,
                  radius: VitCardRadius.tight,
                  density: VitDensity.tool,
                  padding: AppSpacing.zeroInsets,
                  child: VitTabBar(
                    activeKey: _tab,
                    onChanged: _setTab,
                    variant: VitTabBarVariant.underline,
                    tabs: [
                      for (final tab in const [
                        ('summary', 'Summary'),
                        ('breakdown', 'Breakdown'),
                        ('scenarios', 'Scenarios'),
                      ])
                        VitTabItem(
                          key: tab.$1,
                          label: tab.$2,
                          widgetKey: ExAnteCostsPage.tabKey(tab.$1),
                        ),
                    ],
                  ),
                ),
                if (_tab == 'summary')
                  _Summary(snapshot: snapshot)
                else if (_tab == 'breakdown')
                  _Breakdown(snapshot: snapshot)
                else
                  _Scenarios(
                    snapshot: snapshot,
                    holdingPeriod: _holdingPeriod,
                    onChanged: (period) =>
                        setState(() => _holdingPeriod = period),
                  ),
                const _QuickLinks(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}
