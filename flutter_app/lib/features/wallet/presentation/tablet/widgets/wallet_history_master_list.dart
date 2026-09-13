import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/domain/entities/wallet_entities.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/pages/transaction_history_tablet_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Mở chi tiết giao dịch trong pane của shell lịch sử với đúng ngữ nghĩa
/// back-stack (idiom `openProfileDetailRoute`): lần đầu mở từ danh sách là
/// *push*, chuyển sang giao dịch khác là *pushReplacement* — nút back hệ
/// thống luôn về danh sách thay vì đi hết lịch sử hoặc thoát tab.
void openWalletHistoryDetailPane(BuildContext context, String route) {
  final currentPath = GoRouterState.of(context).uri.path;
  if (currentPath == route) return;
  if (currentPath == AppRoutePaths.walletHistory) {
    unawaited(context.push(route));
  } else {
    context.pushReplacement(route);
  }
}

/// Danh sách làm việc của shell lịch sử giao dịch (master column): bộ lọc
/// pill + thẻ giao dịch compact, dòng đang mở ở pane được tô đậm theo
/// route (selection là route-derived — shell pattern rule 6).
class WalletHistoryMasterList extends StatefulWidget {
  const WalletHistoryMasterList({
    super.key,
    required this.snapshot,
    required this.currentPath,
  });

  final WalletTransactionHistorySnapshot snapshot;
  final String currentPath;

  @override
  State<WalletHistoryMasterList> createState() =>
      _WalletHistoryMasterListState();
}

class _WalletHistoryMasterListState extends State<WalletHistoryMasterList> {
  String _filter = 'all';
  String? _exportNotice;

  @override
  Widget build(BuildContext context) {
    final transactions = _filteredTransactions(widget.snapshot.transactions);
    return VitPageContent(
      rhythm: VitPageRhythm.standard,
      padding: VitContentPadding.none,
      fullBleed: true,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${transactions.length} giao dịch',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            VitCtaButton(
              key: TransactionHistoryTabletPage.exportKey,
              fullWidth: false,
              variant: VitCtaButtonVariant.ghost,
              leading: const Icon(Icons.file_download_outlined),
              onPressed: () => setState(() {
                _exportNotice =
                    'Yêu cầu xuất CSV cho ${transactions.length} giao dịch đã được ghi nhận.';
              }),
              child: const Text('Xuất lịch sử'),
            ),
          ],
        ),
        if (_exportNotice != null)
          VitBanner(
            variant: VitBannerVariant.info,
            message: _exportNotice!,
            icon: Icons.info_outline_rounded,
          ),
        VitTabBar(
          tabs: [
            for (final filter in widget.snapshot.filters)
              VitTabItem(
                key: filter.id,
                label: filter.label,
                widgetKey: TransactionHistoryTabletPage.filterKey(filter.id),
              ),
          ],
          activeKey: _filter,
          onChanged: (id) => setState(() {
            _filter = id;
            _exportNotice = null;
          }),
          variant: VitTabBarVariant.pill,
        ),
        if (transactions.isEmpty)
          const VitEmptyState(
            title: 'Không có giao dịch',
            message:
                'Thử chọn bộ lọc khác hoặc quay lại sau khi ví có hoạt động mới.',
            icon: Icons.receipt_long_outlined,
          )
        else
          for (final tx in transactions)
            _TransactionMasterCard(
              key: TransactionHistoryTabletPage.transactionKey(tx.id),
              transaction: tx,
              selected:
                  widget.currentPath == AppRoutePaths.walletTransaction(tx.id),
              onTap: () => openWalletHistoryDetailPane(
                context,
                AppRoutePaths.walletTransaction(tx.id),
              ),
            ),
      ],
    );
  }

  List<WalletTransaction> _filteredTransactions(
    List<WalletTransaction> transactions,
  ) {
    return transactions
        .where((tx) {
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
        })
        .toList(growable: false);
  }
}

class _TransactionMasterCard extends StatelessWidget {
  const _TransactionMasterCard({
    super.key,
    required this.transaction,
    required this.selected,
    required this.onTap,
  });

  final WalletTransaction transaction;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = _TransactionTabletMeta.from(transaction);
    final status = _statusLabel(transaction.status);
    return VitCard(
      onTap: onTap,
      variant: selected ? VitCardVariant.hero : VitCardVariant.ghost,
      density: VitDensity.compact,
      borderColor: selected ? AppColors.primary30 : null,
      child: Row(
        children: [
          VitCard(
            padding: TabletSpacingTokens.zeroInsets,
            width: TabletSpacingTokens.buttonCompact,
            height: TabletSpacingTokens.buttonCompact,
            variant: VitCardVariant.inner,
            radius: VitCardRadius.tight,
            alignment: Alignment.center,
            borderColor: meta.color.withValues(alpha: .22),
            child: Icon(
              meta.icon,
              color: meta.color,
              size: TabletSpacingTokens.iconSm,
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${meta.label} ${transaction.asset}',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: TabletSpacingTokens.x4),
                Text(
                  transaction.createdAt,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meta.isDebit ? '-' : '+'}${transaction.amount} ${transaction.asset}',
                style: AppTextStyles.caption.copyWith(
                  color: meta.color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              VitStatusPill(
                label: status,
                status: _statusPill(transaction.status),
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(width: TabletSpacingTokens.x4),
          Icon(
            selected
                ? Icons.chevron_right_rounded
                : Icons.chevron_right_outlined,
            color: selected ? AppColors.primary : AppColors.text3,
          ),
        ],
      ),
    );
  }
}

final class _TransactionTabletMeta {
  const _TransactionTabletMeta({
    required this.label,
    required this.color,
    required this.icon,
    required this.isDebit,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isDebit;

  factory _TransactionTabletMeta.from(WalletTransaction tx) {
    return switch (tx.type) {
      WalletTransactionType.deposit => const _TransactionTabletMeta(
        label: 'Nạp',
        color: AppColors.buy,
        icon: Icons.arrow_downward_rounded,
        isDebit: false,
      ),
      WalletTransactionType.withdraw => const _TransactionTabletMeta(
        label: 'Rút',
        color: AppColors.sell,
        icon: Icons.arrow_upward_rounded,
        isDebit: true,
      ),
      WalletTransactionType.tradeBuy => const _TransactionTabletMeta(
        label: 'Mua',
        color: AppColors.buy,
        icon: Icons.currency_exchange_rounded,
        isDebit: false,
      ),
      WalletTransactionType.tradeSell => const _TransactionTabletMeta(
        label: 'Bán',
        color: AppColors.sell,
        icon: Icons.currency_exchange_rounded,
        isDebit: true,
      ),
      WalletTransactionType.p2pBuy => const _TransactionTabletMeta(
        label: 'P2P Mua',
        color: AppColors.buy,
        icon: Icons.handshake_rounded,
        isDebit: false,
      ),
      WalletTransactionType.p2pSell => const _TransactionTabletMeta(
        label: 'P2P Bán',
        color: AppColors.sell,
        icon: Icons.handshake_rounded,
        isDebit: true,
      ),
    };
  }
}

String _statusLabel(WalletTransactionStatus status) => switch (status) {
  WalletTransactionStatus.completed => 'Hoàn thành',
  WalletTransactionStatus.pending => 'Đang xử lý',
  WalletTransactionStatus.failed => 'Thất bại',
};

VitStatusPillStatus _statusPill(WalletTransactionStatus status) =>
    switch (status) {
      WalletTransactionStatus.completed => VitStatusPillStatus.success,
      WalletTransactionStatus.pending => VitStatusPillStatus.warning,
      WalletTransactionStatus.failed => VitStatusPillStatus.error,
    };
