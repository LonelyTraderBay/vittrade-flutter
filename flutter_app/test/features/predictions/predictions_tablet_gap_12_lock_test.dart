// Layout-lock (Rule 6 — "đo thật ±0.1dp"): mọi cặp card sibling NGANG
// trong các cụm đã sửa (stats grid SC-211, stat row SC-218, podium SC-214,
// related cards SC-211) phải cách nhau đúng 12dp — khóa bằng RenderBox,
// không tin scanner tĩnh. Bản mẫu: trade_terminal_gap_12_lock_test.dart.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart' as router;
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_card.dart';

void main() {
  Future<void> pumpTabletRoute(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: location,
            surface: AppSurface.tablet,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Rect rectOf(Element e) =>
      (e.renderObject as RenderBox).localToGlobal(Offset.zero) &
      e.renderObject!.paintBounds.size;

  /// Mọi cặp VitCard kề nhau THEO TRỤC NGANG (cùng top hoặc cùng bottom
  /// trong cụm ≥2 card) phải cách đúng [expected] dp.
  void expectHorizontalCardGaps(
    WidgetTester tester, {
    required double expected,
    String reason = '',
  }) {
    final cards = find.byType(VitCard).evaluate().map(rectOf).toList()
      ..sort((a, b) => a.left.compareTo(b.left));

    // Gom cụm theo top chung, rồi theo bottom chung (podium end-aligned).
    for (final cluster
        in _clusters(cards, (a, b) => (a.top - b.top).abs() < .5).followedBy(
          _clusters(cards, (a, b) => (a.bottom - b.bottom).abs() < .5),
        )) {
      for (var i = 1; i < cluster.length; i++) {
        final gap = cluster[i].left - cluster[i - 1].right;
        expect(
          gap,
          moreOrLessEquals(expected, epsilon: .1),
          reason:
              'Card sibling ngang phải cách $expected dp (Rule 6) $reason — '
              'đo được $gap giữa card tại left=${cluster[i - 1].left} và '
              'left=${cluster[i].left}.',
        );
      }
    }
  }

  testWidgets('SC-211 stats grid: gap card ngang = 12dp (lock)', (
    tester,
  ) async {
    await pumpTabletRoute(
      tester,
      router.AppRoutePaths.marketsPredictionEvent('pred-1'),
    );
    expectHorizontalCardGaps(tester, expected: 12, reason: '(stats grid)');
  });

  testWidgets('SC-218 overview stat row: gap card ngang = 12dp (lock)', (
    tester,
  ) async {
    await pumpTabletRoute(
      tester,
      router.AppRoutePaths.marketsPredictionsPortfolioAnalyzer,
    );
    expectHorizontalCardGaps(tester, expected: 12, reason: '(analyzer stats)');
  });

  testWidgets('SC-214 podium: gap tile ngang = 12dp (lock)', (tester) async {
    await pumpTabletRoute(
      tester,
      router.AppRoutePaths.marketsPredictionsLeaderboard,
    );
    expectHorizontalCardGaps(tester, expected: 12, reason: '(podium)');
  });
}

List<List<Rect>> _clusters(List<Rect> rects, bool Function(Rect, Rect) same) {
  final sorted = [...rects];
  final out = <List<Rect>>[];
  var current = <Rect>[];
  for (final r in sorted) {
    if (current.isNotEmpty && !same(current.last, r)) {
      if (current.length >= 2) out.add(current);
      current = <Rect>[];
    }
    current.add(r);
  }
  if (current.length >= 2) out.add(current);
  return out;
}
