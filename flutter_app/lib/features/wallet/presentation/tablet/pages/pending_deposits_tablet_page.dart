import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/wallet_controller_providers.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/core/utils/data_masking.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Independent Tablet composition for the wallet pending deposits flow SC-152.
class PendingDepositsTabletPage extends ConsumerStatefulWidget {
  const PendingDepositsTabletPage({super.key});

  static const contentKey = Key('sc152_pending_deposits_tablet_content');
  static const refreshKey = Key('sc152_pending_deposits_tablet_refresh');
  static Key filterKey(String filter) =>
      Key('sc152_pending_deposits_tablet_filter_$filter');
  static Key depositKey(String id) => Key('sc152_pending_deposit_tablet_$id');
  static Key copyKey(String id) => Key('sc152_pending_deposit_tablet_copy_$id');

  @override
  ConsumerState<PendingDepositsTabletPage> createState() =>
      _PendingDepositsTabletPageState();
}

enum _PendingDepositFilter { all, pending, done }

class _PendingDepositsTabletPageState
    extends ConsumerState<PendingDepositsTabletPage> {
  _PendingDepositFilter _filter = _PendingDepositFilter.all;
  String? _copiedId;

  @override
  Widget build(BuildContext context) {
    final snapshotAsync = ref.watch(walletPendingDepositsProvider);
    return snapshotAsync.when(
      loading: () => _frame(
        primary: const VitSkeletonList(),
        secondary: const SizedBox.shrink(),
      ),
      error: (error, stackTrace) => _frame(
        primary: VitErrorState(
          title: 'Không tải được nạp tiền đang chờ',
          message: 'Vui lòng kiểm tra kết nối và thử lại.',
          actionLabel: 'Thử lại',
          onAction: () => ref.invalidate(walletPendingDepositsProvider),
        ),
        secondary: const SizedBox.shrink(),
      ),
      data: (snapshot) {
        final deposits = _filteredDeposits(snapshot.deposits);
        return _frame(
          primary: _buildPrimary(snapshot, deposits),
          secondary: _buildSecondary(snapshot, deposits.length),
        );
      },
    );
  }

  Widget _frame({required Widget primary, required Widget secondary}) {
    return WalletTabletDetailSurface(
      semanticLabel: 'Nạp tiền đang chờ trên tablet',
      semanticIdentifier: 'SC-152-TABLET',
      title: 'Nạp tiền đang chờ',
      subtitle: 'Theo dõi xác nhận · Ví',
      onBack: () => context.go(AppRoutePaths.wallet),
      primary: primary,
      secondary: secondary,
    );
  }

  Widget _buildPrimary(
    WalletPendingDepositsSnapshot snapshot,
    List<WalletPendingDeposit> deposits,
  ) {
    return Column(
      key: PendingDepositsTabletPage.contentKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryCard(
          pendingCount: snapshot.pendingCount,
          onRefresh: _refreshDeposits,
        ),
        VitPageSection(
          label: 'Bộ lọc nạp tiền',
          headerIcon: Icons.filter_alt_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            _FilterBar(
              active: _filter,
              pendingCount: snapshot.pendingCount,
              onChanged: (filter) => setState(() {
                _filter = filter;
                _copiedId = null;
              }),
            ),
          ],
        ),
        VitPageSection(
          label: 'Danh sách nạp',
          headerIcon: Icons.pending_actions_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: deposits.isEmpty
              ? [
                  VitEmptyState(
                    title: snapshot.deposits.isEmpty
                        ? 'Chưa có nạp đang chờ'
                        : 'Không có giao dịch phù hợp',
                    message: snapshot.deposits.isEmpty
                        ? 'Khi bạn gửi tiền vào ví, giao dịch sẽ xuất hiện tại đây.'
                        : 'Bộ lọc hiện tại không có giao dịch cần theo dõi.',
                    icon: Icons.inbox_outlined,
                    actionLabel: snapshot.deposits.isEmpty
                        ? 'Nạp tiền'
                        : 'Xem tất cả',
                    onAction: snapshot.deposits.isEmpty
                        ? () => context.go(AppRoutePaths.walletDeposit)
                        : () => setState(
                            () => _filter = _PendingDepositFilter.all,
                          ),
                  ),
                ]
              : [
                  for (final deposit in deposits)
                    _PendingDepositTabletCard(
                      key: PendingDepositsTabletPage.depositKey(deposit.id),
                      deposit: deposit,
                      copied: _copiedId == deposit.id,
                      onCopy: () => _copyHash(deposit),
                      onSupport: _openSupportForDeposit,
                    ),
                ],
        ),
      ],
    );
  }

  Widget _buildSecondary(
    WalletPendingDepositsSnapshot snapshot,
    int visibleCount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'Đối soát an toàn',
          message:
              'Kiểm tra mạng, số xác nhận, số tiền và phí trước khi thao tác ví.',
          contractId: 'Wallet pending deposits',
        ),
        VitPageSection(
          label: 'Tóm tắt trạng thái',
          headerIcon: Icons.analytics_outlined,
          headerIconColor: AppColors.primary,
          headerVariant: VitSectionHeaderVariant.plain,
          accentColor: AppColors.primary,
          rhythm: VitPageRhythm.form,
          children: [
            VitCard(
              variant: VitCardVariant.inner,
              child: Column(
                children: [
                  VitInfoRow(
                    label: 'Đang chờ xác nhận',
                    value: '${snapshot.pendingCount} giao dịch',
                    leading: const Icon(Icons.hourglass_top_rounded),
                    valueColor: snapshot.pendingCount > 0
                        ? AppColors.caution
                        : AppColors.buy,
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  VitInfoRow(
                    label: 'Đang hiển thị',
                    value: '$visibleCount giao dịch',
                    leading: const Icon(Icons.visibility_outlined),
                    density: VitDensity.compact,
                    showDivider: true,
                  ),
                  const VitInfoRow(
                    label: 'Nguyên tắc',
                    value: 'Không tự xác nhận hoàn tất',
                    leading: Icon(Icons.verified_user_outlined),
                    density: VitDensity.compact,
                    showDivider: false,
                  ),
                ],
              ),
            ),
            const VitBanner(
              variant: VitBannerVariant.info,
              message:
                  'Số xác nhận cần thiết phụ thuộc vào mạng blockchain. Nạp dưới mức tối thiểu có thể không được ghi nhận.',
              icon: Icons.info_outline_rounded,
            ),
          ],
        ),
      ],
    );
  }

  List<WalletPendingDeposit> _filteredDeposits(
    List<WalletPendingDeposit> deposits,
  ) {
    return switch (_filter) {
      _PendingDepositFilter.pending =>
        deposits
            .where(
              (deposit) =>
                  deposit.status == 'confirming' ||
                  deposit.status == 'processing',
            )
            .toList(growable: false),
      _PendingDepositFilter.done =>
        deposits
            .where(
              (deposit) =>
                  deposit.status == 'credited' || deposit.status == 'failed',
            )
            .toList(growable: false),
      _PendingDepositFilter.all => deposits,
    };
  }

  Future<void> _copyHash(WalletPendingDeposit deposit) async {
    await Clipboard.setData(ClipboardData(text: deposit.txHash));
    if (!mounted) return;
    setState(() => _copiedId = deposit.id);
    await showVitNoticeSheet(
      context: context,
      title: 'Đã sao chép',
      message: 'Mã giao dịch đã được sao chép an toàn.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }

  void _openSupportForDeposit(WalletPendingDeposit deposit) {
    final supportContext = ProductSupportContext.fromContract(
      ContextualSupportContracts.contracts.firstWhere(
        (contract) => contract.flow == ContextualSupportFlow.withdrawal,
      ),
      referenceId: deposit.id,
      sourceRoute: AppRoutePaths.walletPendingDeposits,
      issueLabel: 'Nạp ${deposit.asset} thất bại',
    );
    context.go(
      supportContext.toSupportRoute(supportPath: AppRoutePaths.support),
    );
  }

  Future<void> _refreshDeposits() async {
    try {
      ref.invalidate(walletPendingDepositsProvider);
      await ref.read(walletPendingDepositsProvider.future);
    } catch (_) {
      if (!mounted) return;
      await showVitNoticeSheet(
        context: context,
        title: 'Không làm mới được',
        message: 'Kiểm tra kết nối và thử lại.',
      );
      return;
    }
    if (!mounted) return;
    await showVitNoticeSheet(
      context: context,
      title: 'Đã làm mới',
      message: 'Trạng thái nạp tiền đang chờ đã được cập nhật.',
      variant: VitBannerVariant.success,
      ctaVariant: VitCtaButtonVariant.success,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.pendingCount, required this.onRefresh});

  final int pendingCount;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final hasPending = pendingCount > 0;
    final color = hasPending ? AppColors.caution : AppColors.buy;
    return VitCard(
      variant: VitCardVariant.hero,
      borderColor: color.withValues(alpha: .22),
      child: Row(
        children: [
          VitAccentIconBox(
            icon: hasPending
                ? Icons.access_time_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPending
                      ? '$pendingCount giao dịch đang chờ xác nhận'
                      : 'Tất cả nạp tiền đã hoàn tất',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                Text(
                  hasPending
                      ? 'Làm mới để cập nhật trạng thái xác nhận.'
                      : 'Không có giao dịch nào đang chờ.',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          VitIconButton(
            key: PendingDepositsTabletPage.refreshKey,
            icon: Icons.refresh_rounded,
            tooltip: 'Làm mới nạp tiền đang chờ',
            size: VitIconButtonSize.md,
            onPressed: () => unawaited(onRefresh()),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.active,
    required this.pendingCount,
    required this.onChanged,
  });

  final _PendingDepositFilter active;
  final int pendingCount;
  final ValueChanged<_PendingDepositFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x1,
      children: [
        _filter(
          filter: _PendingDepositFilter.all,
          label: 'Tất cả',
          color: AppColors.primary,
        ),
        _filter(
          filter: _PendingDepositFilter.pending,
          label: 'Đang chờ ($pendingCount)',
          color: AppColors.caution,
        ),
        _filter(
          filter: _PendingDepositFilter.done,
          label: 'Hoàn tất',
          color: AppColors.buy,
        ),
      ],
    );
  }

  Widget _filter({
    required _PendingDepositFilter filter,
    required String label,
    required Color color,
  }) {
    return VitChoicePill(
      key: PendingDepositsTabletPage.filterKey(filter.name),
      label: label,
      selected: active == filter,
      onTap: () => onChanged(filter),
      accentColor: color,
    );
  }
}

class _PendingDepositTabletCard extends StatelessWidget {
  const _PendingDepositTabletCard({
    super.key,
    required this.deposit,
    required this.copied,
    required this.onCopy,
    required this.onSupport,
  });

  final WalletPendingDeposit deposit;
  final bool copied;
  final VoidCallback onCopy;
  final ValueChanged<WalletPendingDeposit> onSupport;

  @override
  Widget build(BuildContext context) {
    final config = _PendingStatusConfig.from(deposit.status);
    final isPending =
        deposit.status == 'confirming' || deposit.status == 'processing';
    return VitCard(
      density: VitDensity.compact,
      borderColor: config.color.withValues(alpha: .22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitAccentIconBox(
                icon: Icons.south_west_rounded,
                color: config.color,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nạp ${deposit.asset}',
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Text(
                      '${deposit.network} · ${deposit.createdAt}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+${deposit.amountLabel}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  VitStatusPill(
                    label: config.label,
                    icon: config.icon,
                    status: config.status,
                    size: VitStatusPillSize.sm,
                  ),
                ],
              ),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: AppSpacing.x4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Xác nhận blockchain',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
                Text(
                  '${deposit.confirmations}/${deposit.requiredConfirmations}',
                  style: AppTextStyles.micro.copyWith(
                    color: config.color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            ClipRRect(
              borderRadius: AppRadii.pillRadius,
              child: LinearProgressIndicator(
                value: deposit.progress.clamp(.05, 1),
                minHeight: AppSpacing.x1,
                backgroundColor: AppColors.surface3,
                valueColor: AlwaysStoppedAnimation<Color>(config.color),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.x4),
          VitInfoRow(
            label: 'Dự kiến nhận',
            value: deposit.estimatedArrival,
            leading: const Icon(Icons.timelapse_rounded),
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Mã giao dịch',
            value: maskAddress(deposit.txHash),
            leading: const Icon(Icons.receipt_long_outlined),
            valueColor: AppColors.primary,
            density: VitDensity.compact,
            showDivider: false,
            trailing: VitStatusPill(
              key: PendingDepositsTabletPage.copyKey(deposit.id),
              label: copied ? 'Đã chép' : 'Sao chép',
              icon: copied ? Icons.check_rounded : Icons.copy_rounded,
              status: copied
                  ? VitStatusPillStatus.success
                  : VitStatusPillStatus.neutral,
              size: VitStatusPillSize.sm,
              onTap: onCopy,
            ),
          ),
          if (deposit.status == 'failed') ...[
            const SizedBox(height: AppSpacing.x4),
            VitCtaButton(
              variant: VitCtaButtonVariant.secondary,
              density: VitDensity.compact,
              fullWidth: false,
              leading: const Icon(Icons.support_agent_rounded),
              onPressed: () => onSupport(deposit),
              child: const Text('Liên hệ hỗ trợ'),
            ),
          ],
        ],
      ),
    );
  }
}

final class _PendingStatusConfig {
  const _PendingStatusConfig({
    required this.label,
    required this.color,
    required this.icon,
    required this.status,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VitStatusPillStatus status;

  factory _PendingStatusConfig.from(String value) {
    return switch (value) {
      'credited' => const _PendingStatusConfig(
        label: 'Đã ghi nhận',
        color: AppColors.buy,
        icon: Icons.check_circle_outline_rounded,
        status: VitStatusPillStatus.success,
      ),
      'failed' => const _PendingStatusConfig(
        label: 'Thất bại',
        color: AppColors.sell,
        icon: Icons.warning_amber_rounded,
        status: VitStatusPillStatus.error,
      ),
      'processing' => const _PendingStatusConfig(
        label: 'Đang xử lý',
        color: AppColors.primary,
        icon: Icons.sync_rounded,
        status: VitStatusPillStatus.info,
      ),
      _ => const _PendingStatusConfig(
        label: 'Đang xác nhận',
        color: AppColors.caution,
        icon: Icons.access_time_rounded,
        status: VitStatusPillStatus.warning,
      ),
    };
  }
}
