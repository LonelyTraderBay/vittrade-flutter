part of '../../phone/pages/hub/p2p_dashboard_page.dart';

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.rows);

  final List<P2PDashboardAssetDraft> rows;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -math.pi / 2;
    for (final row in rows) {
      final sweep = math.pi * 2 * (row.percentage / 100);
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = _assetColor(row.asset)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.rows != rows;
  }
}

void _paintTinyText(Canvas canvas, String text, Offset offset) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, offset);
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'ETH' => AppColors.primary,
    'BNB' => AppModuleAccents.p2p,
    'SOL' => AppColors.accent,
    _ => AppColors.text2,
  };
}

Color _quickColor(String id) {
  return switch (id) {
    'orders' => AppColors.primary,
    'reviews' => AppColors.warn,
    'ads' => AppColors.accent,
    'express' => AppColors.buy,
    _ => AppColors.text2,
  };
}

IconData _quickIcon(String iconKey) {
  return switch (iconKey) {
    'orders' => Icons.shopping_cart_outlined,
    'reviews' => Icons.star_border_rounded,
    'ads' => Icons.bar_chart_rounded,
    'express' => Icons.bolt_outlined,
    _ => Icons.chevron_right_rounded,
  };
}

({String label, Color color}) _statusInfo(String status) {
  return switch (status) {
    'pending_payment' => (label: 'Chờ TT', color: AppColors.warn),
    'paid' => (label: 'Đã TT', color: AppColors.primary),
    'released' => (label: 'Hoàn tất', color: AppColors.buy),
    'cancelled' => (label: 'Đã hủy', color: AppColors.sell),
    'disputed' => (label: 'Tranh chấp', color: AppColors.sell),
    _ => (label: status, color: AppColors.text2),
  };
}

String _formatMoneyCompact(double value) {
  if (value >= 1000000000) {
    return '₫${(value / 1000000000).toStringAsFixed(value % 1000000000 == 0 ? 0 : 2)}B';
  }
  if (value >= 1000000) {
    final scaled = value / 1000000;
    final text = scaled >= 100
        ? scaled.toStringAsFixed(0)
        : scaled >= 10
        ? scaled.toStringAsFixed(1)
        : scaled.toStringAsFixed(2);
    return '₫${text.replaceAll(RegExp(r'\.00$'), '')}M';
  }
  return '₫${_formatWhole(value.round())}';
}

String _formatWhole(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write('.');
    buffer.write(raw[i]);
  }
  return buffer.toString();
}

String _formatDecimal(double value) {
  if (value % 1 == 0) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}

String _formatAmount(double value) {
  if (value >= 1) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(4);
  }
  return value.toStringAsFixed(6);
}
