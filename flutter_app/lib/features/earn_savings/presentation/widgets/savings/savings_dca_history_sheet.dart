part of '../../phone/pages/savings/savings_dca_page.dart';

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.executions});

  final List<SavingsDcaExecutionDraft> executions;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsDCAPage.historyListKey,
      children: [
        for (final execution in executions) ...[
          _ExecutionCard(execution: execution),
          if (execution != executions.last)
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
        ],
      ],
    );
  }
}

class _ExecutionCard extends StatelessWidget {
  const _ExecutionCard({required this.execution});

  final SavingsDcaExecutionDraft execution;

  @override
  Widget build(BuildContext context) {
    final color = _executionColor(execution.status);

    return VitCard(
      key: SavingsDCAPage.executionKey(execution.id),
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX4,
      child: Row(
        children: [
          DecoratedBox(
            decoration: ShapeDecoration(
              color: color.withValues(alpha: .12),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.mdRadius,
              ),
            ),
            child: SizedBox(
              width: AppSpacing.x7,
              height: AppSpacing.x7,
              child: Icon(_executionIcon(execution.status), color: color),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x1,
                  children: [
                    Text(execution.planName, style: _captionBold),
                    VitAccentPill(
                      label: _executionLabel(execution.status),
                      accentColor: color,
                    ),
                  ],
                ),
                Text(
                  '${execution.date} · APY ${execution.apyLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            execution.amountLabel,
            textAlign: TextAlign.end,
            style: _captionBold.copyWith(
              color: execution.status == SavingsDcaExecutionStatus.failed
                  ? AppColors.sell
                  : AppColors.text1,
              decoration: execution.status == SavingsDcaExecutionStatus.failed
                  ? TextDecoration.lineThrough
                  : null,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _CreatePlanSheet extends StatelessWidget {
  const _CreatePlanSheet({required this.snapshot});

  final SavingsDcaSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: VitCard(
        key: SavingsDCAPage.createSheetKey,
        radius: VitCardRadius.large,
        padding: EarnSpacingTokens.earnCardPaddingX3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text('Tạo kế hoạch DCA', style: AppTextStyles.baseMedium),
                const SizedBox(width: AppSpacing.x2),
                VitIconButton(
                  icon: Icons.close_rounded,
                  tooltip: 'Đóng',
                  onPressed: () => Navigator.of(context).pop(),
                  variant: VitIconButtonVariant.transparent,
                  size: VitIconButtonSize.md,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            Text(
              'Chọn sản phẩm linh hoạt để tự động gửi tiết kiệm theo lịch.',
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            for (final product in snapshot.products) ...[
              _ProductRow(product: product),
              if (product != snapshot.products.last)
                const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
            ],
            const SizedBox(height: AppSpacing.pageRhythmFormSectionGap),
            VitCtaButton(
              variant: VitCtaButtonVariant.success,
              onPressed: () => Navigator.of(context).pop(),
              leading: const Icon(Icons.check_rounded),
              child: const Text('Xem trước lịch DCA'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});

  final SavingsDcaProductDraft product;

  @override
  Widget build(BuildContext context) {
    final color = _assetColor(product.asset);

    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.standard,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          _AssetBadge(asset: product.asset, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: _captionBold),
                Text(
                  'Khả dụng: ${product.balanceLabel}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            product.apyLabel,
            style: _captionBold.copyWith(color: AppColors.buy),
          ),
        ],
      ),
    );
  }
}
