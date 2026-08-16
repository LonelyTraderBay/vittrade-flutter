part of '../../phone/pages/savings/savings_comparison_page.dart';

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.products, required this.details});

  final List<SavingsProductDraft> products;
  final Map<String, SavingsComparisonDetailDraft> details;

  @override
  Widget build(BuildContext context) {
    final bestApy = products
        .map((product) => _apyNumber(product.apy))
        .fold<double>(0, (current, value) => value > current ? value : current);
    final lowestMin = products
        .map((product) => details[product.id]?.minAmountValue ?? 0)
        .fold<double>(
          double.infinity,
          (current, value) => value < current ? value : current,
        );

    return VitCard(
      key: SavingsComparisonPage.comparisonTableKey,
      radius: VitCardRadius.large,
      clip: true,
      child: Column(
        children: [
          _ComparisonHeader(products: products),
          _ComparisonRow(
            label: 'APY',
            highlighted: true,
            values: [
              for (final product in products)
                _ApyValue(product: product, bestApy: bestApy),
            ],
          ),
          _ComparisonRow(
            label: 'Loại',
            values: [
              for (final product in products) _TypeValue(type: product.type),
            ],
          ),
          _ComparisonRow(
            label: 'Kỳ hạn',
            values: [
              for (final product in products)
                Text(
                  product.lockDays == null
                      ? 'Không kỳ hạn'
                      : '${product.lockDays} ngày',
                  textAlign: TextAlign.center,
                  style: _cellStyle(),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Tối thiểu',
            highlighted: true,
            values: [
              for (final product in products)
                _MinAmountValue(
                  detail: details[product.id],
                  lowestMin: lowestMin,
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Rủi ro',
            values: [
              for (final product in products)
                _RiskValue(
                  risk: details[product.id]?.risk ?? product.riskLevel,
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Dung lượng',
            highlighted: true,
            values: [
              for (final product in products)
                _CapacityValue(
                  capacity:
                      details[product.id]?.capacityPercent ??
                      (product.progress * 100).round(),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Người tham gia',
            values: [
              for (final product in products)
                _IconTextValue(
                  icon: Icons.group_outlined,
                  label: _formatCount(
                    details[product.id]?.participants,
                    fallback: product.participants,
                  ),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Rút sớm',
            highlighted: true,
            values: [
              for (final product in products)
                _TextMetricValue(
                  label: details[product.id]?.earlyWithdrawal ?? '—',
                  color:
                      details[product.id]?.earlyWithdrawal == 'Bất kỳ lúc nào'
                      ? AppColors.buy
                      : AppColors.warn,
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Trả lãi',
            values: [
              for (final product in products)
                Text(
                  details[product.id]?.interestPayout ?? '—',
                  textAlign: TextAlign.center,
                  style: _cellStyle(),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Lãi kép',
            values: [
              for (final product in products)
                _BooleanValue(
                  value: details[product.id]?.compounding == 'Tự động',
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Bảo hiểm',
            highlighted: true,
            values: [
              for (final product in products)
                _BooleanValue(
                  value: details[product.id]?.insurance ?? false,
                  icon: Icons.shield_outlined,
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Quota còn lại',
            values: [
              for (final product in products)
                Text(
                  product.remainingQuota,
                  textAlign: TextAlign.center,
                  style: _cellStyle(),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Tổng đã ký',
            highlighted: true,
            isLast: true,
            values: [
              for (final product in products)
                Text(
                  product.totalSubscribed,
                  textAlign: TextAlign.center,
                  style: _cellStyle(fontWeight: AppTextStyles.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparisonHeader extends StatelessWidget {
  const _ComparisonHeader({required this.products});

  final List<SavingsProductDraft> products;

  @override
  Widget build(BuildContext context) {
    return _ComparisonRowShell(
      highlighted: true,
      label: const Icon(
        Icons.compare_arrows_rounded,
        color: AppColors.text3,
        size: AppSpacing.iconSm,
      ),
      values: [
        for (final product in products)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _EarnAssetBadge(
                asset: product.asset,
                color: _assetColor(product.asset),
              ),
              const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.values,
    this.highlighted = false,
    this.isLast = false,
  });

  final String label;
  final List<Widget> values;
  final bool highlighted;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return _ComparisonRowShell(
      highlighted: highlighted,
      isLast: isLast,
      label: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
      values: values,
    );
  }
}

class _ComparisonRowShell extends StatelessWidget {
  const _ComparisonRowShell({
    required this.label,
    required this.values,
    this.highlighted = false,
    this.isLast = false,
  });

  final Widget label;
  final List<Widget> values;
  final bool highlighted;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: highlighted ? AppColors.surface2 : AppColors.transparent,
        shape: isLast
            ? const Border()
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: AppSpacing.buttonHero + AppSpacing.x4,
              child: Padding(
                padding: EarnSpacingTokens.earnCardPaddingX4,
                child: Align(alignment: Alignment.centerLeft, child: label),
              ),
            ),
            for (final value in values)
              Expanded(
                child: DecoratedBox(
                  decoration: const ShapeDecoration(
                    shape: Border(left: BorderSide(color: AppColors.divider)),
                  ),
                  child: Padding(
                    padding: EarnSpacingTokens.earnCardPaddingX3,
                    child: Center(child: value),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
