import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';

/// Dấu hiệu thương hiệu VitTrade "Chart V" (concept C, chốt 2026-09-09):
/// đường giá vẽ chữ V — xuống đáy (râu nến) rồi vượt lên trên điểm vào,
/// chấm xanh là điểm lời.
///
/// Vẽ bằng CustomPaint đúng hệ toạ độ của SVG master
/// `design/logo/vittrade_app_icon.svg` (viewBox 1024). Màu lấy từ
/// [AppColors] — dấu hiệu thương hiệu phải luôn đúng màu brand bất kể
/// bối cảnh theme; nằm ở tầng app/ vì shared/ không được import theme.
class VitLogoMark extends StatelessWidget {
  const VitLogoMark({
    super.key,
    this.size = 64,
    this.semanticLabel = 'Logo VitTrade',
  });

  /// Cạnh của khung vuông chứa logo (logical pixels).
  final double size;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: SizedBox(
        width: size,
        height: size,
        child: const CustomPaint(painter: _ChartVPainter()),
      ),
    );
  }
}

class _ChartVPainter extends CustomPainter {
  const _ChartVPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 1024;
    canvas.save();
    canvas.scale(scale);

    // Baseline mờ — mức giá vào.
    canvas.drawLine(
      const Offset(736, 350),
      const Offset(824, 350),
      Paint()
        ..color = AppColors.text3.withValues(alpha: 0.55)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
    // Râu nến đánh dấu đáy.
    canvas.drawLine(
      const Offset(512, 610),
      const Offset(512, 838),
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 34
        ..strokeCap = StrokeCap.round,
    );
    // Nhánh xuống của đường giá.
    canvas.drawLine(
      const Offset(268, 350),
      const Offset(512, 720),
      Paint()
        ..color = AppColors.primary
        ..strokeWidth = 98
        ..strokeCap = StrokeCap.round,
    );
    // Nhánh lên — sáng hơn, vượt trên điểm vào.
    canvas.drawLine(
      const Offset(512, 720),
      const Offset(756, 256),
      Paint()
        ..color = AppColors.primarySoft
        ..strokeWidth = 98
        ..strokeCap = StrokeCap.round,
    );
    // Chấm xanh lời + glow nhẹ.
    const dotCenter = Offset(811, 151);
    final glow = AppColors.buy.withValues(alpha: 0.32);
    canvas.drawCircle(
      dotCenter,
      96,
      Paint()
        ..shader = ui.Gradient.radial(dotCenter, 96, [
          glow,
          glow.withValues(alpha: 0),
        ]),
    );
    canvas.drawCircle(dotCenter, 46, Paint()..color = AppColors.buy);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ChartVPainter oldDelegate) => false;
}
