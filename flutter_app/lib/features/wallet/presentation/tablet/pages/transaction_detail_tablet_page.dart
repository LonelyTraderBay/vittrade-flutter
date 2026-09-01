import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_route_contracts.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/spacing/tablet_spacing_tokens.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for wallet transaction detail SC-141.
class TransactionDetailTabletPage extends ConsumerStatefulWidget {
  const TransactionDetailTabletPage({super.key, required this.transactionId});

  static const contentKey = Key('sc141_transaction_detail_tablet_content');
  static const explorerKey = Key('sc141_transaction_detail_explorer');
  static const supportKey = Key('sc141_transaction_detail_support');
  static const copyTxIdKey = Key('sc141_transaction_detail_copy_txid');

  final String transactionId;

  @override
  ConsumerState<TransactionDetailTabletPage> createState() =>
      _TransactionDetailTabletPageState();
}

class _TransactionDetailTabletPageState
    extends ConsumerState<TransactionDetailTabletPage> {
  String? _copiedValue;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(
      walletTransactionDetailProvider(widget.transactionId),
    );
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được chi tiết giao dịch',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(
            walletTransactionDetailProvider(widget.transactionId),
          ),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) {
        final transaction = snapshot.transaction;
        if (transaction == null) {
          return _frame(
            primary: VitEmptyState(
              title: 'Không tìm thấy giao dịch',
              message: 'Kiểm tra lại lịch sử ví hoặc quay lại danh sách.',
              icon: Icons.error_outline_rounded,
              actionLabel: 'Quay lại lịch sử',
              onAction: () => context.go(AppRoutePaths.walletHistory),
            ),
            secondary: const SizedBox.shrink(),
          );
        }
        return _frame(
          primary: _buildPrimary(transaction),
          secondary: _buildSecondary(transaction),
        );
      },
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Chi tiết giao dịch trên tablet',
      semanticIdentifier: 'SC-141-TABLET',
      title: 'Chi tiết giao dịch',
      subtitle: 'Lịch sử giao dịch · Ví',
      onBack: () => context.go(AppRoutePaths.walletHistory),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(WalletTransaction transaction) {
    final meta = _DetailTabletMeta.from(transaction);
    return Column(
      key: TransactionDetailTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          variant: VitCardVariant.hero,
          density: VitDensity.compact,
          borderColor: meta.color.withValues(alpha: .22),
          child: Column(
            children: [
              Icon(
                meta.icon,
                color: meta.color,
                size: TabletSpacingTokens.iconLg,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              VitStatusPill(
                label: _statusLabel(transaction.status),
                status: _statusPill(transaction.status),
                size: VitStatusPillSize.md,
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              Text(
                meta.label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const SizedBox(height: TabletSpacingTokens.x4),
              Text(
                '${meta.isDebit ? '-' : '+'}${_formatAmount(transaction)} ${transaction.asset}',
                style: AppTextStyles.heroNumber.copyWith(
                  color: meta.color,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ),
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Tiến trình',
          headerIcon: Icons.timeline_rounded,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [_ProgressTabletCard(transaction: transaction)],
        ),
      ],
    );
  }

  Widget _buildSecondary(WalletTransaction transaction) {
    final rows = <(String, String, String?)>[
      if (transaction.txHash != null)
        ('Mã giao dịch (TxID)', transaction.txHash!, transaction.txHash),
      if (transaction.network != null) ('Mạng', transaction.network!, null),
      if (transaction.address != null)
        (
          transaction.type == WalletTransactionType.withdraw
              ? 'Địa chỉ nhận'
              : 'Địa chỉ gửi',
          maskAddress(transaction.address!),
          transaction.address,
        ),
      if (transaction.fee != null && transaction.fee! > 0)
        ('Phí giao dịch', '\$${transaction.fee!.toStringAsFixed(2)}', null),
      ('Thời gian', transaction.createdAt, null),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          innerGap: TabletSpacingTokens.x4,
          label: 'Thông tin chi tiết',
          headerIcon: Icons.article_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.standard,
          children: [
            VitCard(
              density: VitDensity.compact,
              child: Column(
                children: [
                  for (final row in rows)
                    VitInfoRow(
                      label: row.$1,
                      value: row.$2,
                      density: VitDensity.compact,
                      showDivider: true,
                      trailing: row.$3 == null
                          ? null
                          : VitIconButton(
                              key: TransactionDetailTabletPage.copyTxIdKey,
                              icon: Icons.copy_rounded,
                              tooltip: 'Sao chép thông tin giao dịch',
                              size: VitIconButtonSize.sm,
                              onPressed: () => _copyValue(row.$3!),
                            ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (transaction.txHash != null)
          VitCard(
            padding: TabletSpacingTokens.zeroInsets,
            key: TransactionDetailTabletPage.explorerKey,
            variant: VitCardVariant.inner,
            onTap: () => showVitNoticeSheet(
              context: context,
              title: 'Explorer',
              message: 'Liên kết Explorer sẽ mở khi môi trường mạng sẵn sàng.',
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.open_in_new_rounded, color: AppColors.primary),
                SizedBox(width: TabletSpacingTokens.x4),
                Text('Xem trên Explorer'),
              ],
            ),
          ),
        VitCtaButton(
          key: TransactionDetailTabletPage.supportKey,
          variant: VitCtaButtonVariant.warning,
          leading: const Icon(Icons.chat_bubble_outline_rounded),
          onPressed: () => context.go(
            ContextualSupportContracts.supportRouteFor(
              ContextualSupportFlow.withdrawal,
              referenceId: transaction.id,
              sourceRoute: AppRoutePaths.walletTransaction(transaction.id),
              issueLabel: 'Hỗ trợ giao dịch ví',
            ),
          ),
          child: const Text('Liên hệ hỗ trợ'),
        ),
        if (_copiedValue != null)
          const VitBanner(
            variant: VitBannerVariant.success,
            message: 'Đã sao chép thông tin nhạy cảm ở dạng nguyên bản.',
            icon: Icons.check_circle_outline_rounded,
          ),
      ],
    );
  }

  void _copyValue(String value) {
    setState(() => _copiedValue = value);
    unawaited(Clipboard.setData(ClipboardData(text: value)));
  }
}

class _ProgressTabletCard extends StatelessWidget {
  const _ProgressTabletCard({required this.transaction});

  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final failed = transaction.status == WalletTransactionStatus.failed;
    final complete = transaction.status == WalletTransactionStatus.completed;
    final steps = [
      ('Tạo yêu cầu', transaction.createdAt, true),
      ('Đang xử lý', failed ? null : transaction.createdAt, !failed),
      (
        complete
            ? 'Hoàn tất'
            : failed
            ? 'Thất bại'
            : 'Đang chờ...',
        complete ? transaction.createdAt : null,
        complete,
      ),
    ];
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        children: [
          for (var i = 0; i < steps.length; i++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(
                steps[i].$3
                    ? Icons.check_circle_rounded
                    : failed && i == steps.length - 1
                    ? Icons.cancel_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: steps[i].$3
                    ? AppColors.buy
                    : failed && i == steps.length - 1
                    ? AppColors.sell
                    : AppColors.text3,
              ),
              title: Text(steps[i].$1),
              subtitle: steps[i].$2 == null ? null : Text(steps[i].$2!),
            ),
        ],
      ),
    );
  }
}

final class _DetailTabletMeta {
  const _DetailTabletMeta({
    required this.label,
    required this.color,
    required this.icon,
    required this.isDebit,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool isDebit;

  factory _DetailTabletMeta.from(WalletTransaction tx) {
    return switch (tx.type) {
      WalletTransactionType.deposit => const _DetailTabletMeta(
        label: 'Nạp tiền',
        color: AppColors.buy,
        icon: Icons.arrow_downward_rounded,
        isDebit: false,
      ),
      WalletTransactionType.withdraw => const _DetailTabletMeta(
        label: 'Rút tiền',
        color: AppColors.sell,
        icon: Icons.arrow_upward_rounded,
        isDebit: true,
      ),
      WalletTransactionType.tradeBuy => const _DetailTabletMeta(
        label: 'Mua giao dịch',
        color: AppColors.buy,
        icon: Icons.currency_exchange_rounded,
        isDebit: false,
      ),
      WalletTransactionType.tradeSell => const _DetailTabletMeta(
        label: 'Bán giao dịch',
        color: AppColors.sell,
        icon: Icons.currency_exchange_rounded,
        isDebit: true,
      ),
      WalletTransactionType.p2pBuy => const _DetailTabletMeta(
        label: 'P2P Mua',
        color: AppColors.buy,
        icon: Icons.handshake_rounded,
        isDebit: false,
      ),
      WalletTransactionType.p2pSell => const _DetailTabletMeta(
        label: 'P2P Bán',
        color: AppColors.sell,
        icon: Icons.handshake_rounded,
        isDebit: true,
      ),
    };
  }
}

String _formatAmount(WalletTransaction tx) {
  if (tx.asset == 'BTC') return tx.amount.toStringAsFixed(6);
  if (tx.asset == 'ETH') return tx.amount.toStringAsFixed(4);
  return tx.amount.toStringAsFixed(2);
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
