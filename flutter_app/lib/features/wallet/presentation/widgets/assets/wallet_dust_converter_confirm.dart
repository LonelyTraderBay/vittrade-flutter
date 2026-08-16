part of '../../phone/pages/assets/dust_converter_page.dart';

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: enabled ? onTap : null,
      height: AppSpacing.inputHeight,
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }
}

double _sumUsd(List<WalletDustAsset> assets) {
  return assets.fold<double>(0, (sum, asset) => sum + asset.usdValue);
}

String _formatAmount(double value) => value.toStringAsFixed(4);

String _formatUsd(double value, {bool preciseSmall = false}) {
  final fixed = value.toStringAsFixed(
    preciseSmall && value < 1 && value > 0 ? 4 : 2,
  );
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    if (i > 0 && (integer.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(integer[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
