part of '../../phone/pages/pending_deposits_page.dart';

class _TrustReviewNotice extends StatelessWidget {
  const _TrustReviewNotice();

  @override
  Widget build(BuildContext context) {
    return const VitInfoCallout(
      message:
          'Kiểm tra mạng, số xác nhận, số tiền và phí trước khi thao tác ví.',
      icon: Icons.fact_check_outlined,
      accentColor: AppColors.caution,
      iconSize: AppSpacing.iconMd,
      padding: AppSpacing.cardTilePadding,
      messageStyle: AppTextStyles.micro,
    );
  }
}

class _SummaryBanner extends StatelessWidget {
  const _SummaryBanner({required this.pendingCount, required this.onRefresh});

  final int pendingCount;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final hasPending = pendingCount > 0;
    final color = hasPending ? AppColors.caution : AppColors.buy;
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      padding: AppSpacing.cardTilePadding,
      borderColor: AppColors.overlayStroke,
      child: Row(
        children: [
          VitAccentIconBox(
            icon: hasPending
                ? Icons.access_time_rounded
                : Icons.check_circle_outline_rounded,
            color: color,
          ),
          const SizedBox(width: _pendingInlineGap),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasPending
                      ? '$pendingCount giao dịch đang chờ xác nhận'
                      : 'Tất cả nạp tiền đã hoàn tất',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: _pendingTinyGap),
                Text(
                  hasPending
                      ? 'Nhấn làm mới để cập nhật trạng thái xác nhận'
                      : 'Không có giao dịch nào đang chờ',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: _pendingInlineGap),
          Semantics(
            button: true,
            label: 'Làm mới trạng thái nạp tiền đang chờ',
            child: VitIconButton(
              key: PendingDepositsPage.refreshKey,
              icon: Icons.refresh_rounded,
              tooltip: 'Làm mới nạp tiền đang chờ',
              size: VitIconButtonSize.sm,
              onPressed: () => unawaited(onRefresh()),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingDepositFilters extends StatelessWidget {
  const _PendingDepositFilters({
    required this.active,
    required this.pendingCount,
    required this.onChanged,
  });

  final _DepositFilter active;
  final int pendingCount;
  final ValueChanged<_DepositFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _pendingFilterHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          VitFilterChip(
            key: PendingDepositsPage.filterKey(_DepositFilter.all.name),
            label: 'Tất cả',
            active: active == _DepositFilter.all,
            color: AppColors.primary,
            height: _pendingFilterHeight,
            padding: AppSpacing.vitFilterChipPadding,
            semanticLabel: 'Bộ lọc nạp tiền đang chờ Tất cả',
            onTap: () => onChanged(_DepositFilter.all),
          ),
          const SizedBox(width: _pendingInlineGap),
          VitFilterChip(
            key: PendingDepositsPage.filterKey(_DepositFilter.pending.name),
            label: 'Đang chờ',
            count: pendingCount,
            active: active == _DepositFilter.pending,
            color: AppColors.caution,
            height: _pendingFilterHeight,
            padding: AppSpacing.vitFilterChipPadding,
            semanticLabel: 'Bộ lọc nạp tiền đang chờ Đang chờ',
            semanticCountSuffix: 'giao dịch',
            onTap: () => onChanged(_DepositFilter.pending),
          ),
          const SizedBox(width: _pendingInlineGap),
          VitFilterChip(
            key: PendingDepositsPage.filterKey(_DepositFilter.done.name),
            label: 'Hoàn tất',
            active: active == _DepositFilter.done,
            color: AppColors.buy,
            height: _pendingFilterHeight,
            padding: AppSpacing.vitFilterChipPadding,
            semanticLabel: 'Bộ lọc nạp tiền đang chờ Hoàn tất',
            onTap: () => onChanged(_DepositFilter.done),
          ),
        ],
      ),
    );
  }
}

class _DepositCard extends StatefulWidget {
  const _DepositCard({
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
  State<_DepositCard> createState() => _DepositCardState();
}

class _DepositCardState extends State<_DepositCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final deposit = widget.deposit;
    final copied = widget.copied;
    final onCopy = widget.onCopy;
    final onSupport = widget.onSupport;
    final config = _statusConfig(deposit.status);
    return VitCard(
      padding: AppSpacing.cardTilePadding,
      borderColor: AppColors.overlayStroke,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VitAccentIconBox(
                icon: Icons.south_west_rounded,
                color: config.color,
              ),
              const SizedBox(width: _pendingInlineGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Nạp ${deposit.asset}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: _pendingInlineGap),
                        Flexible(
                          child: Text(
                            '+${deposit.amountLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: _pendingTinyGap),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            deposit.createdAt,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                        const SizedBox(width: _pendingInlineGap),
                        _DepositStatusBadge(config: config),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (deposit.status == 'confirming' ||
              deposit.status == 'processing') ...[
            const SizedBox(height: _pendingGap),
            _ConfirmationProgress(deposit: deposit, color: config.color),
          ],
          if (deposit.status == 'credited') ...[
            const SizedBox(height: _pendingGap),
            _StatusNotice(
              color: AppColors.buy,
              icon: Icons.check_circle_outline_rounded,
              text:
                  'Đã ghi nhận vào ví — ${deposit.confirmations}/${deposit.requiredConfirmations} xác nhận',
            ),
          ],
          if (deposit.status == 'failed') ...[
            const SizedBox(height: _pendingGap),
            const _StatusNotice(
              color: AppColors.sell,
              icon: Icons.warning_amber_rounded,
              text: 'Giao dịch thất bại — liên hệ hỗ trợ nếu đã gửi tiền',
            ),
            const SizedBox(height: _pendingTinyGap),
            Align(
              alignment: Alignment.centerLeft,
              child: VitCtaButton(
                onPressed: () => onSupport(deposit),
                variant: VitCtaButtonVariant.secondary,
                density: VitDensity.compact,
                fullWidth: false,
                leading: const Icon(Icons.support_agent_rounded),
                child: const Text('Liên hệ hỗ trợ'),
              ),
            ),
          ],
          const SizedBox(height: _pendingGap),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? 'Ẩn chi tiết' : 'Chi tiết giao dịch'),
            ),
          ),
          if (_expanded) ...[
            const SizedBox(height: _pendingTinyGap),
            _DepositDetails(deposit: deposit, copied: copied, onCopy: onCopy),
          ],
        ],
      ),
    );
  }
}

class _DepositStatusBadge extends StatelessWidget {
  const _DepositStatusBadge({required this.config});

  final _DepositStatusConfig config;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: config.label,
      icon: config.icon,
      status: config.status,
      size: VitStatusPillSize.sm,
    );
  }
}

class _ConfirmationProgress extends StatelessWidget {
  const _ConfirmationProgress({required this.deposit, required this.color});

  final WalletPendingDeposit deposit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label:
          'Xác nhận blockchain ${deposit.confirmations} trên ${deposit.requiredConfirmations}',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Xác nhận blockchain',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
              VitStatusPill(
                label:
                    '${deposit.confirmations}/${deposit.requiredConfirmations} yêu cầu',
                icon: Icons.fact_check_outlined,
                status: deposit.confirmations >= deposit.requiredConfirmations
                    ? VitStatusPillStatus.success
                    : VitStatusPillStatus.warning,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: _pendingTinyGap),
          ClipRRect(
            borderRadius: AppRadii.pillRadius,
            child: SizedBox(
              height: WalletSpacingTokens.walletPendingProgressHeight,
              child: LinearProgressIndicator(
                value: deposit.progress.clamp(.05, 1),
                backgroundColor: AppColors.surface3,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
