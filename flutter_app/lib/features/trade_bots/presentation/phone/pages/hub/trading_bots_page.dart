import 'dart:async';

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
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_product_navigation.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_hub_hero.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/phone/trading_bots_page_my_bots_tab.dart';
part '../../../widgets/phone/trading_bots_page_bot_card.dart';
part '../../../widgets/phone/trading_bots_page_create_bot_sheet.dart';
part '../../../widgets/phone/trading_bots_page_tools.dart';
part '../../../widgets/phone/trading_bots_page_formatters.dart';

enum _TradingBotsTab { myBots, strategies }

enum _StrategyRiskFilter { all, low, medium, high }

class TradingBotsPage extends ConsumerStatefulWidget {
  const TradingBotsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc059_trading_bots_scroll_content');
  static const backKey = Key('sc059_back');
  static const addBotKey = Key('sc059_add_bot');
  static const sheetAgreeKey = Key('sc059_sheet_agree');
  static const sheetCreateKey = Key('sc059_sheet_create');
  static const sheetTermsKey = Key('sc059_sheet_terms');
  static const toolsKey = Key('sc059_quick_tools');
  static const emergencyStopKey = Key('sc059_emergency_stop');
  static const deleteConfirmKey = Key('sc059_delete_confirm');

  static Key tabKey(String id) => Key('sc059_tab_$id');
  static Key botCardKey(String botId) => Key('sc059_bot_card_$botId');
  static Key botToggleKey(String botId) => Key('sc059_bot_toggle_$botId');
  static Key botSettingsKey(String botId) => Key('sc059_bot_settings_$botId');
  static Key botDeleteKey(String botId) => Key('sc059_bot_delete_$botId');
  static Key strategyCreateKey(String strategyId) =>
      Key('sc059_strategy_create_$strategyId');
  static Key toolKey(String id) => Key('sc059_tool_$id');
  static Key riskFilterKey(String id) => Key('sc059_risk_filter_$id');
  static Key paramFieldKey(String key) => Key('sc059_param_$key');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradingBotsPage> createState() => _TradingBotsPageState();
}

class _TradingBotsPageState extends ConsumerState<TradingBotsPage> {
  _TradingBotsTab _tab = _TradingBotsTab.myBots;
  _StrategyRiskFilter _riskFilter = _StrategyRiskFilter.all;
  bool _creating = false;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradingBotsSnapshotProvider);

    return VitTradeHubScaffold(
      title: 'Bot giao dịch',
      subtitle: 'Tự động hóa giao dịch theo chiến lược',
      semanticLabel: 'Bot giao dịch tự động',
      semanticIdentifier: 'SC-059',
      contentKey: TradingBotsPage.contentKey,
      backKey: TradingBotsPage.backKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      showProductTabs: true,
      navigationBuilder: buildTradeProductNavigation,
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.trade,
        mode: BackNavigationMode.historyThenFallback,
      ),
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được danh sách bot',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradingBotsSnapshotProvider),
          ),
        ],
        data: (_) {
          final snapshot = ref.watch(tradeBotsControllerProvider).snapshot;
          final bots = snapshot.activeBots;
          final runningBots = snapshot.runningCount;
          final totalProfit = snapshot.totalProfit;
          final profitColor = totalProfit >= 0 ? AppColors.buy : AppColors.sell;
          final strategies = _filteredStrategies(snapshot.strategies);
          return [
            VitTradeHubHero(
              primaryLabel: 'Đang chạy',
              primaryValue: '$runningBots',
              primaryColor: AppColors.buy,
              secondaryLabel: 'Lãi/lỗ',
              secondaryValue: _formatSignedMoney(totalProfit),
              secondaryColor: profitColor,
            ),
            _HubMetricsStrip(
              investment: snapshot.totalInvestment,
              botCount: bots.length,
              tradeCount: bots.fold(0, (sum, bot) => sum + bot.trades),
            ),
            _QuickToolsStrip(
              showEmergency: runningBots > 0,
              onOpen: (path) => context.go(path),
              onExplore: () =>
                  setState(() => _tab = _TradingBotsTab.strategies),
            ),
            _BotsWorkspace(
              tab: _tab,
              botCount: bots.length,
              onTabChanged: (tab) => setState(() => _tab = tab),
              myBotsChild: _MyBotsTab(
                bots: bots,
                suggestedStrategies: snapshot.strategies.take(2).toList(),
                onToggle: _toggleBot,
                onDelete: _confirmDeleteBot,
                onSettings: _openBotSettings,
                onOpenBot: _openBotHistory,
                onAdd: () => setState(() => _tab = _TradingBotsTab.strategies),
                onCreateSuggested: _openCreateSheet,
              ),
              strategiesChild: _StrategiesTab(
                strategies: strategies,
                riskFilter: _riskFilter,
                onRiskFilterChanged: (filter) =>
                    setState(() => _riskFilter = filter),
                onCreate: _openCreateSheet,
              ),
            ),
            VitHighRiskStatePanel(
              state: VitHighRiskUiState.riskReview,
              density: VitDensity.tool,
              title: 'Rủi ro giao dịch tự động',
              message:
                  'Bot không đảm bảo lợi nhuận. Hiệu suất quá khứ không đại diện kết quả tương lai.',
              contractId: snapshot.highRiskContractId,
            ),
          ];
        },
      ),
    );
  }

  List<TradeBotStrategy> _filteredStrategies(List<TradeBotStrategy> all) {
    return switch (_riskFilter) {
      _StrategyRiskFilter.all => all,
      _StrategyRiskFilter.low =>
        all.where((s) => s.risk == TradeBotRisk.low).toList(),
      _StrategyRiskFilter.medium =>
        all.where((s) => s.risk == TradeBotRisk.medium).toList(),
      _StrategyRiskFilter.high =>
        all.where((s) => s.risk == TradeBotRisk.high).toList(),
    };
  }

  void _toggleBot(String botId) {
    unawaited(
      ref
          .read(tradeBotsControllerProvider.notifier)
          .submitAction(botId: botId, action: 'toggle'),
    );
  }

  void _deleteBot(String botId) {
    unawaited(
      ref
          .read(tradeBotsControllerProvider.notifier)
          .submitAction(botId: botId, action: 'delete'),
    );
  }

  void _openBotSettings(String botId) {
    context.go(AppRoutePaths.tradeBotSecuritySettings);
  }

  void _openBotHistory(String botId) {
    context.go(AppRoutePaths.tradeBotHistory);
  }

  Future<void> _confirmDeleteBot(String botId) async {
    final confirmed = await showVitConfirmDialog(
      context: context,
      title: 'Xóa bot?',
      message: 'Bot sẽ dừng hoạt động và bị xóa khỏi danh sách.',
      confirmLabel: 'Xóa',
      confirmVariant: VitCtaButtonVariant.destructive,
      confirmKey: TradingBotsPage.deleteConfirmKey,
    );
    if (!confirmed || !mounted) return;
    _deleteBot(botId);
    await showVitNoticeSheet(
      context: context,
      title: 'Đã xóa bot',
      message: 'Bot đã dừng hoạt động và được xóa khỏi danh sách.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  Future<void> _openCreateSheet(TradeBotStrategy strategy) async {
    if (_creating) return;
    final params = await showVitBottomSheet<Map<String, String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CreateBotSheet(strategy: strategy),
    );
    if (params == null || !mounted) return;

    setState(() => _creating = true);
    try {
      await ref
          .read(tradeBotsControllerProvider.notifier)
          .createBot(
            TradeBotCreateRequest(strategyId: strategy.id, params: params),
          );
      if (!mounted) return;
      setState(() => _tab = _TradingBotsTab.myBots);
      await showVitNoticeSheet(
        context: context,
        title: 'Bot đã được khởi chạy!',
        message: 'Bot đang hoạt động và giao dịch tự động',
        variant: VitBannerVariant.success,
        ctaVariant: VitCtaButtonVariant.success,
      );
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }
}
