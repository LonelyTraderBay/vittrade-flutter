import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_page_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_top_chrome.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/wallet_spacing_tokens.dart';

part '../../widgets/history/transaction_history_page_sections.dart';
part '../../widgets/history/transaction_history_page_common.dart';

const _historyBackground = AppColors.bg;
const _historyPrimary = AppColors.primary;
const _historyGreen = AppColors.buy;
const _historyRed = AppColors.sell;

double _historyScrollBottomInset(BuildContext context, ShellRenderMode mode) {
  return (mode.usesVisualQaFrame
          ? DeviceMetrics.bottomChrome
          : DeviceMetrics.nativeBottomChrome) +
      AppSpacing.x6 +
      MediaQuery.paddingOf(context).bottom;
}

class TransactionHistoryPage extends ConsumerStatefulWidget {
  const TransactionHistoryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc136_transaction_history_content');
  static const exportKey = Key('sc136_transaction_history_export');
  static Key filterKey(String id) => Key('sc136_transaction_filter_$id');
  static Key transactionKey(String id) => Key('sc136_transaction_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TransactionHistoryPage> createState() =>
      _TransactionHistoryPageState();
}

class _TransactionHistoryPageState
    extends ConsumerState<TransactionHistoryPage> {
  String _filter = 'all';
  String? _exportNotice;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletTransactionHistoryProvider);
    final transactionCount = _filteredTransactions(
      snapshotAsync.value?.transactions ?? const [],
    ).length;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset = _historyScrollBottomInset(context, mode);

    return VitAutoHidePageScaffold(
      semanticLabel: 'Lịch sử giao dịch - theo dõi nạp, rút an toàn',
      semanticIdentifier: 'SC-136',
      background: _historyBackground,
      header: VitTopChrome(
        type: VitTopChromeType.detail,
        title: 'Lịch sử giao dịch',
        subtitle: 'Theo dõi nạp, rút và giao dịch · an toàn',
        showBack: true,
        onBack: () => context.go(AppRoutePaths.wallet),
        actions: [
          VitHeaderActionItem(
            key: TransactionHistoryPage.exportKey,
            type: VitHeaderActionType.export,
            tooltip: 'Xuất lịch sử',
            onPressed: () => _showExportNotice(transactionCount),
          ),
        ],
      ),
      body: VitInsetScrollView(
        key: TransactionHistoryPage.contentKey,
        bottomInset: bottomInset,
        child: VitPageContent(
          rhythm: VitPageRhythm.standard,
          padding: VitContentPadding.compact,
          density: VitDensity.compact,
          gap: VitContentGap.tight,
          children: [
            ...snapshotAsync.when(
              loading: () => const [VitSkeletonList()],
              error: (error, stackTrace) => [
                VitErrorState(
                  title: 'Không tải được lịch sử giao dịch',
                  message: 'Vui lòng kiểm tra kết nối và thử lại.',
                  actionLabel: 'Thử lại',
                  onAction: () =>
                      ref.invalidate(walletTransactionHistoryProvider),
                ),
              ],
              data: (snapshot) {
                final transactions = _filteredTransactions(
                  snapshot.transactions,
                );
                final grouped = _groupByDate(transactions);
                return [
                  _HistorySummaryBar(
                    count: transactions.length,
                    exportNotice: _exportNotice,
                  ),
                  VitTabBar(
                    tabs: [
                      for (final filter in snapshot.filters)
                        VitTabItem(
                          key: filter.id,
                          label: filter.label,
                          widgetKey: TransactionHistoryPage.filterKey(
                            filter.id,
                          ),
                        ),
                    ],
                    activeKey: _filter,
                    onChanged: (id) => setState(() {
                      _filter = id;
                      _exportNotice = null;
                    }),
                    variant: VitTabBarVariant.pill,
                  ),
                  VitPageSection(
                    label: 'Giao dịch gần đây',
                    headerIcon: Icons.receipt_long_outlined,
                    headerIconColor: _historyPrimary,
                    headerVariant: VitSectionHeaderVariant.plain,
                    headerDensity: VitDensity.compact,
                    innerGap: AppSpacing.pageRhythmStandardInnerGap,
                    children: [
                      if (transactions.isEmpty)
                        const VitEmptyState(
                          title: 'Không có giao dịch',
                          message:
                              'Thử chọn bộ lọc khác hoặc quay lại sau khi ví có hoạt động mới.',
                          icon: Icons.receipt_long_outlined,
                        )
                      else ...[
                        for (final group in grouped)
                          _TransactionGroup(
                            group: group,
                            onTransactionTap: (tx) => context.go(
                              AppRoutePaths.walletTransaction(tx.id),
                            ),
                          ),
                        const _EndOfList(),
                      ],
                    ],
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }

  List<WalletTransaction> _filteredTransactions(
    List<WalletTransaction> transactions,
  ) {
    return transactions.where((tx) {
      return switch (_filter) {
        'deposit' => tx.type == WalletTransactionType.deposit,
        'withdraw' => tx.type == WalletTransactionType.withdraw,
        'trade' =>
          tx.type == WalletTransactionType.tradeBuy ||
              tx.type == WalletTransactionType.tradeSell,
        'p2p' =>
          tx.type == WalletTransactionType.p2pBuy ||
              tx.type == WalletTransactionType.p2pSell,
        _ => true,
      };
    }).toList();
  }

  List<_TransactionDateGroup> _groupByDate(
    List<WalletTransaction> transactions,
  ) {
    final groups = <String, List<WalletTransaction>>{};
    for (final tx in transactions) {
      final date = tx.createdAt.split(' ').first;
      groups.putIfAbsent(date, () => <WalletTransaction>[]).add(tx);
    }
    return [
      for (final entry in groups.entries)
        _TransactionDateGroup(date: entry.key, transactions: entry.value),
    ];
  }

  void _showExportNotice(int count) {
    setState(() {
      _exportNotice = 'Yêu cầu xuất CSV cho $count giao dịch đã được ghi nhận';
    });
  }
}
