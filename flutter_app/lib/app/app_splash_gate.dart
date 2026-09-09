import 'dart:async';

import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/brand/vit_logo_mark.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_motion.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';

/// Cổng splash khởi động: phủ logo VitTrade lên toàn app một nhịp rồi tự ẩn.
///
/// Chỉ được bật opt-in từ entrypoint thật (`VitTradeApp(showSplash: true)`
/// trong `main.dart`). Toàn bộ 453 file test dựng `VitTradeApp` mặc định
/// không có overlay này nên cây widget và hành vi tap/pump giữ nguyên.
///
/// Timeline (1.6s, chỉnh bằng [duration]): logo fade+scale-in 0–25%,
/// giữ nguyên, overlay fade-out 80–100%. Chạy bằng AnimationController
/// (frame-driven, không Timer) để `pumpAndSettle` trong test chạy tới hồi
/// kết thúc thay vì treo timer thật.
class AppSplashGate extends StatefulWidget {
  const AppSplashGate({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1600),
  });

  final Widget child;
  final Duration duration;

  @override
  State<AppSplashGate> createState() => _AppSplashGateState();
}

class _AppSplashGateState extends State<AppSplashGate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  bool _finished = false;

  @override
  void initState() {
    super.initState();
    unawaited(
      _controller.forward().whenComplete(() {
        if (mounted) setState(() => _finished = true);
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return widget.child;
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            final logoIn = const Interval(
              0,
              0.25,
              curve: AppMotion.enter,
            ).transform(t);
            final fadeOut = const Interval(
              0.8,
              1,
              curve: AppMotion.exit,
            ).transform(t);
            // ColoredBox (opacity đặc lúc t=0) chặn tương tác với app bên
            // dưới trong lúc splash còn hiển thị.
            return ColoredBox(
              color: AppColors.bg,
              child: Opacity(
                opacity: 1 - fadeOut,
                child: Center(
                  child: Opacity(
                    opacity: logoIn,
                    child: Transform.scale(
                      scale: 0.96 + 0.04 * logoIn,
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          VitLogoMark(
                            size: 128,
                            semanticLabel: 'Logo VitTrade',
                          ),
                          SizedBox(height: 20),
                          Text('VitTrade', style: AppTextStyles.heroNumber),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
