part of '../../phone/pages/savings/savings_page.dart';

List<SavingsProductDraft> _filteredProducts(
  SavingsController controller,
  _SavingsFilter filter,
) {
  return switch (filter) {
    _SavingsFilter.all => controller.productsByType(null),
    _SavingsFilter.flexible => controller.productsByType(
      SavingsProductType.flexible,
    ),
    _SavingsFilter.locked => controller.productsByType(
      SavingsProductType.locked,
    ),
  };
}

String _filterLabel(_SavingsFilter filter) {
  return switch (filter) {
    _SavingsFilter.all => 'Tất cả',
    _SavingsFilter.flexible => 'Linh hoạt',
    _SavingsFilter.locked => 'Cố định',
  };
}

String _productSubtitle(SavingsProductDraft product) {
  final duration = product.type == SavingsProductType.flexible
      ? 'Linh hoạt'
      : '${product.lockDays} ngày';
  return '$duration - ${product.participants}';
}

Color _productAccent(SavingsProductDraft product) {
  if (product.asset == 'BTC') return AppColors.warn;
  if (product.asset == 'ETH') return AppColors.primary;
  if (product.asset == 'SOL') return AppColors.primarySoft;
  return product.type == SavingsProductType.flexible
      ? AppColors.buy
      : AppColors.sell;
}

Color _riskColor(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}

String _riskLabel(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => 'Thấp',
    EarnRiskLevel.medium => 'Trung bình',
    EarnRiskLevel.high => 'Cao',
  };
}

VitStatusPillStatus _riskPillStatus(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => VitStatusPillStatus.success,
    EarnRiskLevel.medium => VitStatusPillStatus.warning,
    EarnRiskLevel.high => VitStatusPillStatus.error,
  };
}

String _savingsApyEstimateRange(List<SavingsProductDraft> products) {
  if (products.isEmpty) {
    return '--';
  }

  final values = products
      .map((product) => _parseSavingsApyPercent(product.apy))
      .whereType<double>()
      .toList();
  if (values.isEmpty) {
    return '--';
  }

  final minApy = values.reduce((a, b) => a < b ? a : b);
  final maxApy = values.reduce((a, b) => a > b ? a : b);
  if ((maxApy - minApy).abs() < 0.05) {
    return '${minApy.toStringAsFixed(1)}%';
  }
  return '${minApy.toStringAsFixed(1)}–${maxApy.toStringAsFixed(1)}%';
}

double? _parseSavingsApyPercent(String apy) {
  final normalized = apy.replaceAll('%', '').trim();
  return double.tryParse(normalized);
}
