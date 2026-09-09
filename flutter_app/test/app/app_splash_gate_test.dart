import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/app_splash_gate.dart';
import 'package:vit_trade_flutter/app/brand/vit_logo_mark.dart';

Widget _host({
  required Widget child,
  Duration duration = const Duration(milliseconds: 1600),
}) {
  return MaterialApp(
    home: AppSplashGate(duration: duration, child: child),
  );
}

void main() {
  group('AppSplashGate', () {
    testWidgets('hiện logo + wordmark ở frame đầu, chặn tương tác', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          child: Center(
            child: ElevatedButton(
              onPressed: () => taps++,
              child: const Text('Vào app'),
            ),
          ),
        ),
      );

      expect(find.byType(VitLogoMark), findsOneWidget);
      expect(find.text('VitTrade'), findsOneWidget);

      await tester.tap(find.text('Vào app'));
      await tester.pump();
      expect(taps, 0, reason: 'overlay splash phải chặn tap lúc đang hiện');
    });

    testWidgets('tự ẩn sau animation và trả tương tác về cho app', (
      tester,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        _host(
          child: Center(
            child: ElevatedButton(
              onPressed: () => taps++,
              child: const Text('Vào app'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        find.byType(VitLogoMark),
        findsNothing,
        reason: 'overlay phải gỡ hẳn khỏi cây widget',
      );
      expect(find.text('Vào app'), findsOneWidget);

      await tester.tap(find.text('Vào app'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('child vẫn build bình thường ngay dưới overlay', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(child: const Center(child: Text('Nội dung chính'))),
      );
      // Overlay phủ lên nhưng không thay thế child — child vẫn trong cây.
      expect(find.text('Nội dung chính'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Nội dung chính'), findsOneWidget);
    });
  });
}
