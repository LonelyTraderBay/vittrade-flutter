part of '../../phone/pages/transaction_detail_page.dart';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.tx,
    required this.type,
    required this.status,
  });

  final WalletTransaction tx;
  final _DetailTypeMeta type;
  final _DetailStatusMeta status;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      density: VitDensity.compact,
      borderColor: type.color.withValues(alpha: .22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: WalletSpacingTokens.walletTransactionSummaryIconSize,
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    color: type.color.withValues(alpha: .12),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.smRadius,
                      side: BorderSide(
                        color: type.color.withValues(alpha: .22),
                      ),
                    ),
                  ),
                  child: Icon(
                    type.icon,
                    color: type.color,
                    size:
                        WalletSpacingTokens.walletTransactionSummaryStatusIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: status.label,
                icon: status.icon,
                status: _detailPillStatus(tx.status),
                size: VitStatusPillSize.md,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
          Text(
            type.label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '${type.isDebit ? '-' : '+'}${_formatAmount(tx)} ${tx.asset}',
            textAlign: TextAlign.center,
            style: AppTextStyles.heroNumber.copyWith(
              color: type.color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.tx});

  final WalletTransaction tx;

  @override
  Widget build(BuildContext context) {
    final steps = [
      _ProgressStep('Tạo yêu cầu', tx.createdAt, done: true),
      _ProgressStep(
        'Đang xử lý',
        tx.status == WalletTransactionStatus.failed ? null : tx.createdAt,
        done: tx.status != WalletTransactionStatus.failed,
      ),
      _ProgressStep(
        tx.status == WalletTransactionStatus.completed
            ? 'Hoàn tất'
            : tx.status == WalletTransactionStatus.failed
            ? 'Thất bại'
            : 'Đang chờ...',
        tx.status == WalletTransactionStatus.completed ? tx.createdAt : null,
        done: tx.status == WalletTransactionStatus.completed,
        failed: tx.status == WalletTransactionStatus.failed,
      ),
    ];

    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < steps.length; i++)
            _ProgressRow(step: steps[i], isLast: i == steps.length - 1),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.step, required this.isLast});

  final _ProgressStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = step.failed
        ? _detailRed
        : step.done
        ? _detailGreen
        : AppColors.borderSolid;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SizedBox.square(
              dimension: WalletSpacingTokens.walletTransactionProgressDotSize,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: color,
                  shape: const CircleBorder(),
                ),
              ),
            ),
            if (!isLast)
              Column(
                children: [
                  const SizedBox(
                    height: WalletSpacingTokens
                        .walletTransactionProgressLineSpacing,
                  ),
                  SizedBox(
                    width:
                        WalletSpacingTokens.walletTransactionProgressLineWidth,
                    height: WalletSpacingTokens.walletTransactionStepLineHeight,
                    child: ColoredBox(
                      color: step.done ? _detailGreen : AppColors.borderSolid,
                    ),
                  ),
                  const SizedBox(
                    height: WalletSpacingTokens
                        .walletTransactionProgressLineSpacing,
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(
          width: WalletSpacingTokens.walletTransactionExplorerLabelGap,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.label,
                style: AppTextStyles.caption.copyWith(
                  color: step.done || step.failed
                      ? AppColors.text1
                      : AppColors.text3,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (step.time != null) ...[
                const SizedBox(height: AppSpacing.x1),
                Text(
                  step.time!,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
              if (!isLast)
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({
    required this.rows,
    required this.copiedValue,
    required this.onCopy,
  });

  final List<_DetailRowData> rows;
  final String? copiedValue;
  final ValueChanged<String> onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      density: VitDensity.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final row in rows)
            _DetailInfoRow(
              row: row,
              copied: copiedValue == (row.copyValue ?? row.value),
              onCopy: () => onCopy(row.copyValue ?? row.value),
            ),
        ],
      ),
    );
  }
}

class _DetailInfoRow extends StatelessWidget {
  const _DetailInfoRow({
    required this.row,
    required this.copied,
    required this.onCopy,
  });

  final _DetailRowData row;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return VitInfoRow(
      label: row.label,
      value: row.value,
      density: VitDensity.compact,
      showDivider: true,
      trailing: row.copyable
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (copied) ...[
                  const VitStatusPill(
                    label: 'Đã sao chép',
                    icon: Icons.check_rounded,
                    status: VitStatusPillStatus.success,
                    size: VitStatusPillSize.sm,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                ],
                VitIconButton(
                  key: TransactionDetailPage.copyTxIdKey,
                  icon: Icons.copy_rounded,
                  tooltip: 'Copy transaction field',
                  size: VitIconButtonSize.sm,
                  onPressed: onCopy,
                ),
              ],
            )
          : null,
    );
  }
}

class _ExplorerButton extends StatelessWidget {
  const _ExplorerButton();

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: TransactionDetailPage.explorerKey,
      height: WalletSpacingTokens.walletTransactionExplorerHeight,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      borderColor: _detailPrimary.withValues(alpha: .28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.open_in_new_rounded,
            color: _detailPrimary,
            size: WalletSpacingTokens.walletTransactionActionIcon,
          ),
          const SizedBox(
            width: WalletSpacingTokens.walletTransactionExplorerLabelGap,
          ),
          Text(
            'Xem trên Explorer',
            style: AppTextStyles.caption.copyWith(
              color: _detailPrimary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}
