import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for wallet transaction history SC-136.
class TransactionHistoryTabletPage extends ConsumerStatefulWidget {
  const TransactionHistoryTabletPage({super.key});

  static const contentKey = Key('sc136_transaction_history_tablet_content');
  static const exportKey = Key('sc136_transaction_history_export');
  static Key filterKey(String id) => Key('sc136_transaction_filter_$id');
  static Key transactionKey(String id) => Key('sc136_transaction_$id');

  @override
  ConsumerState<TransactionHistoryTabletPage> createState() =>
      _TransactionHistoryTabletPageState();
}

class _TransactionHistoryTabletPageState
    extends ConsumerState<TransactionHistoryTabletPage> {
  String _filter = 'all';
  String? _exportNotice;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletTransactionHistoryProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được lịch sử giao dịch',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletTransactionHistoryProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) {
        final transactions = _filteredTransactions(snapshot.transactions);
        return _frame(
          primary: _buildPrimary(snapshot, transactions),
          secondary: _buildSecondary(transactions.length),
        );
      },
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Lịch sử giao dịch trên tablet',
      semanticIdentifier: 'SC-136-TABLET',
      title: 'Lịch sử giao dịch',
      subtitle: 'Theo dõi nạp, rút và giao dịch · Ví',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(
    WalletTransactionHistorySnapshot snapshot,
    List<WalletTransaction> transactions,
  ) {
    return Column(
      key: TransactionHistoryTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Bộ lọc giao dịch',
          headerIcon: Icons.filter_alt_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitTabBar(
              tabs: [
                for (final filter in snapshot.filters)
                  VitTabItem(
                    key: filter.id,
                    label: filter.label,
                    widgetKey: TransactionHistoryTabletPage.filterKey(
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
          ],
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Giao dịch gần đây',
          headerIcon: Icons.receipt_long_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: transactions.isEmpty
              ? const [
                  VitEmptyState(
                    title: 'Không có giao dịch',
                    message:
                        'Thử chọn bộ lọc khác hoặc quay lại sau khi ví có hoạt động mới.',
                    icon: Icons.receipt_long_outlined,
                  ),
                ]
              : [
                  for (final tx in transactions)
                    _TransactionTabletCard(
                      key: TransactionHistoryTabletPage.transactionKey(tx.id),
                      transaction: tx,
                      onTap: () =>
                          context.go(AppRoutePaths.walletTransaction(tx.id)),
                    ),
                ],
        ),
      ],
    );
  }

  Widget _buildSecondary(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Đối soát an toàn',
          message:
              'Kiểm tra trạng thái, mạng lưới, phí và mã giao dịch trước khi xử lý khiếu nại.',
          contractId: 'Lịch sử giao dịch ví',
        ),
        const SizedBox(
          height: TabletSpacingTokens.pageRhythmStandardSectionGap,
        ),
        VitCard(
          variant: VitCardVariant.inner,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Phạm vi hiện tại'),
              const SizedBox(height: TabletSpacingTokens.x4),
              Text(
                '$count giao dịch đang hiển thị theo bộ lọc.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              const Text(
                'Dữ liệu giao dịch được giữ theo trạng thái từ ví và không tự động xác nhận hoàn tất.',
                style: AppTextStyles.micro,
              ),
            ],
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

class _TransactionTabletCard extends StatelessWidget {
  const _TransactionTabletCard({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  final WalletTransaction transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = _TransactionTabletMeta.from(transaction);
    final status = _statusLabel(transaction.status);
    return VitCard(
      onTap: onTap,
      variant: VitCardVariant.ghost,
      density: VitDensity.compact,
      borderColor: AppColors.transparent,
      child: Row(
        children: [
          VitCard(
            width: TabletSpacingTokens.buttonCompact,
            height: TabletSpacingTokens.buttonCompact,
            variant: VitCardVariant.inner,
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
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
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
