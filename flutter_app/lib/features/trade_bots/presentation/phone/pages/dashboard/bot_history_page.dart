import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/utils/vit_format.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_bots_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/trade_module_layout.dart';
import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

part '../../../widgets/dashboard/bot_history_page_sections.dart';
part '../../../widgets/dashboard/bot_history_page_common.dart';

const _historyGreen = AppColors.buy;
const _historyRed = AppColors.sell;

enum _HistoryFilter { all, buy, sell }

class BotHistoryPage extends ConsumerStatefulWidget {
  const BotHistoryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc123_bot_history_content');
  static const exportHeaderKey = Key('sc123_bot_history_export_header');
  static const exportAllKey = Key('sc123_bot_history_export_all');

  static Key filterKey(String id) => Key('sc123_bot_history_filter_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotHistoryPage> createState() => _BotHistoryPageState();
}

class _BotHistoryPageState extends ConsumerState<BotHistoryPage> {
  _HistoryFilter _filter = _HistoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(tradeBotHistoryProvider);
    return VitTradeHubScaffold(
      title: 'Lịch sử giao dịch',
      subtitle: 'Lịch sử giao dịch và lãi/lỗ bot',
      semanticLabel: 'Lịch sử giao dịch của bot',
      semanticIdentifier: 'SC-123',
      contentKey: BotHistoryPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => goBackOrFallback(
        context,
        fallbackPath: AppRoutePaths.tradeBots,
        mode: BackNavigationMode.historyThenFallback,
      ),
      headerActions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.export,
          onPressed: _handleExport,
        ),
      ],
      children: snapshotAsync.when(
        loading: () => const [VitSkeletonList()],
        error: (error, stackTrace) => [
          VitErrorState(
            title: 'Không tải được lịch sử giao dịch',
            message: 'Vui lòng kiểm tra kết nối và thử lại.',
            actionLabel: 'Thử lại',
            onAction: () => ref.invalidate(tradeBotHistoryProvider),
          ),
        ],
        data: (snapshot) {
          final filteredTrades = _filtered(snapshot.trades);
          final totalPnL = filteredTrades.fold<double>(
            0,
            (sum, trade) => sum + trade.pnl,
          );
          final totalFees = filteredTrades.fold<double>(
            0,
            (sum, trade) => sum + trade.fee,
          );
          final buyCount = snapshot.trades
              .where((t) => t.side == TradeBotHistorySide.buy)
              .length;
          final sellCount = snapshot.trades
              .where((t) => t.side == TradeBotHistorySide.sell)
              .length;
          return [
            VitBotSubpageHero(
              primaryLabel: 'Giao dịch',
              primaryValue: '${filteredTrades.length}',
              secondaryLabel: 'Lãi/lỗ',
              secondaryValue: _formatSignedMoney(totalPnL),
              secondaryColor: totalPnL >= 0 ? _historyGreen : _historyRed,
            ),
            VitTradeSection(
              title: 'Tổng quan',
              child: _StatsCard(
                totalTrades: filteredTrades.length,
                totalPnL: totalPnL,
                totalFees: totalFees,
              ),
            ),
            VitTradeSection(
              title: 'Giao dịch (${filteredTrades.length})',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const VitSearchBar(
                    enabled: false,
                    placeholder: 'Tìm theo tên bot hoặc cặp...',
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  VitTabBar(
                    tabs: [
                      VitTabItem(
                        key: _HistoryFilter.all.name,
                        label: 'Tất cả (${snapshot.trades.length})',
                        widgetKey: BotHistoryPage.filterKey(
                          _HistoryFilter.all.name,
                        ),
                      ),
                      VitTabItem(
                        key: _HistoryFilter.buy.name,
                        label: 'Mua ($buyCount)',
                        widgetKey: BotHistoryPage.filterKey(
                          _HistoryFilter.buy.name,
                        ),
                      ),
                      VitTabItem(
                        key: _HistoryFilter.sell.name,
                        label: 'Bán ($sellCount)',
                        widgetKey: BotHistoryPage.filterKey(
                          _HistoryFilter.sell.name,
                        ),
                      ),
                    ],
                    activeKey: _filter.name,
                    onChanged: (key) => setState(
                      () => _filter = _HistoryFilter.values.firstWhere(
                        (filter) => filter.name == key,
                      ),
                    ),
                    variant: VitTabBarVariant.segment,
                  ),
                  const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
                  if (filteredTrades.isEmpty)
                    const _EmptyHistory()
                  else
                    for (final trade in filteredTrades) ...[
                      _TradeCard(trade: trade),
                      if (trade != filteredTrades.last)
                        const SizedBox(
                          height: TradeSpacingTokens.tradeBotCardGap,
                        ),
                    ],
                ],
              ),
            ),
            VitTradeSection(
              title: 'Xuất dữ liệu',
              child: _ExportNote(onTap: _handleExport),
            ),
            const VitBotRiskReviewFooter(
              title: 'Xem lại xuất lịch sử',
              message:
                  'Bộ lọc giao dịch, lãi/lỗ đã thực hiện, tổng phí, phạm vi xuất và bước nhận biên nhận tiếp theo được xem lại trước khi tạo hồ sơ.',
              contractId: 'bot-history-export-review',
            ),
          ];
        },
      ),
    );
  }

  List<TradeBotHistoryTrade> _filtered(List<TradeBotHistoryTrade> trades) {
    return switch (_filter) {
      _HistoryFilter.buy =>
        trades.where((trade) => trade.side == TradeBotHistorySide.buy).toList(),
      _HistoryFilter.sell =>
        trades
            .where((trade) => trade.side == TradeBotHistorySide.sell)
            .toList(),
      _HistoryFilter.all => trades,
    };
  }

  void _handleExport() {
    unawaited(
      ref
          .read(tradingBotsRepositoryProvider)
          .createBotHistoryExport(
            const TradeBotHistoryExportRequest(format: 'csv'),
          ),
    );
  }
}

String _formatSignedMoney(double value) => VitFormat.usdSigned(value);
