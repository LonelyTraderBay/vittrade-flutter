part of 'wallet_page_sections.dart';

double walletPortfolioChange24h(List<WalletAsset> assets) {
  final total = assets.fold<double>(0, (sum, asset) => sum + asset.usdValue);
  if (total <= 0) return 0;
  return assets.fold<double>(
    0,
    (sum, asset) => sum + asset.change24h * (asset.usdValue / total),
  );
}

class WalletAllocationCard extends StatelessWidget {
  const WalletAllocationCard({super.key, required this.assets});

  final List<WalletAsset> assets;

  @override
  Widget build(BuildContext context) {
    final total = assets.fold<double>(0, (sum, asset) => sum + asset.usdValue);
    return VitCard(
      padding: AppSpacing.cardPaddingCompact,
      variant: VitCardVariant.standard,
      child: Row(
        children: [
          CustomPaint(
            size: const Size.square(
              WalletSpacingTokens.walletAllocationChartSize,
            ),
            painter: _AllocationPainter(assets: assets, total: total),
          ),
          const SizedBox(width: AppSpacing.contentPad),
          Expanded(
            child: Column(
              children: [
                for (final asset in assets.take(6)) ...[
                  Row(
                    children: [
                      SizedBox(
                        width: WalletSpacingTokens.walletAllocationLegendMarker,
                        height:
                            WalletSpacingTokens.walletAllocationLegendMarker,
                        child: ClipOval(
                          child: ColoredBox(color: Color(asset.colorHex)),
                        ),
                      ),
                      const SizedBox(
                        width: WalletSpacingTokens.walletAllocationLegendGap,
                      ),
                      Expanded(
                        child: Text(
                          asset.symbol,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                          ),
                        ),
                      ),
                      Text(
                        total <= 0
                            ? '0.0%'
                            : '${(asset.usdValue / total * 100).toStringAsFixed(1)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  if (asset != assets.take(6).last)
                    const SizedBox(
                      height: WalletSpacingTokens.walletAllocationLegendItemGap,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllocationPainter extends CustomPainter {
  const _AllocationPainter({required this.assets, required this.total});

  final List<WalletAsset> assets;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0) {
      final trackPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = WalletSpacingTokens.walletAllocationChartStroke
        ..color = AppColors.surface3;
      final rect = Offset.zero & size;
      canvas.drawArc(
        rect.deflate(WalletSpacingTokens.walletAllocationChartInset),
        -math.pi / 2,
        math.pi * 2,
        false,
        trackPaint,
      );
      final centerPaint = Paint()..color = _walletPanel;
      canvas.drawCircle(
        rect.center,
        WalletSpacingTokens.walletAllocationCenterRadius,
        centerPaint,
      );
      return;
    }

    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = WalletSpacingTokens.walletAllocationChartStroke;
    for (final asset in assets.take(6)) {
      final sweep = (asset.usdValue / total) * math.pi * 2;
      paint.color = Color(asset.colorHex).withValues(alpha: .88);
      canvas.drawArc(
        rect.deflate(WalletSpacingTokens.walletAllocationChartInset),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
    final centerPaint = Paint()..color = _walletPanel;
    canvas.drawCircle(
      rect.center,
      WalletSpacingTokens.walletAllocationCenterRadius,
      centerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AllocationPainter oldDelegate) => false;
}

IconData _actionIcon(String key) => switch (key) {
  'deposit' => Icons.file_download_outlined,
  'withdraw' => Icons.file_upload_outlined,
  'buy' => Icons.shopping_cart_outlined,
  'transfer' => Icons.swap_vert_rounded,
  'history' => Icons.schedule_rounded,
  _ => Icons.account_balance_wallet_outlined,
};

IconData _toolIcon(String key) => switch (key) {
  'history' => Icons.schedule_rounded,
  'address' => Icons.menu_book_outlined,
  'health' => Icons.health_and_safety_outlined,
  'pending' => Icons.south_west_rounded,
  'limits' => Icons.speed_rounded,
  'dust' => Icons.auto_awesome_rounded,
  'network' => Icons.wifi_rounded,
  'gas' => Icons.local_gas_station_outlined,
  'multi' => Icons.account_tree_outlined,
  'approval' => Icons.verified_user_outlined,
  _ => Icons.account_balance_wallet_outlined,
};

String _formatUsd(double value) {
  final whole = value.truncate();
  final cents = ((value - whole) * 100).round().abs();
  return '\$${_withCommas(whole)}.${cents.toString().padLeft(2, '0')}';
}

String _formatVnd(double value) => _withDots(value.round());

String _formatPct(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(2)}%';
}

String _formatAssetAmount(double value) {
  if (value >= 1000) return _withCommas(value.round());
  if (value >= 10) return value.toStringAsFixed(4);
  if (value >= 1) return value.toStringAsFixed(4);
  return value.toStringAsFixed(6);
}

String _withCommas(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

String _withDots(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final remaining = raw.length - i;
    buffer.write(raw[i]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write('.');
  }
  return buffer.toString();
}
