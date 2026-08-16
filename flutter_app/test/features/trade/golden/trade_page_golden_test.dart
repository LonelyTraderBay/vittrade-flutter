// Pixel baseline for lib/features/trade/presentation/phone/pages/trade_page.dart
// ("SC-048 Trade", see
// docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md).
// Pinned at 360x800 (minimum supported phone size, matches the convention
// used by test/quality/page_rhythm_phone_visual_qa_test.dart and
// test/features/home/golden/home_page_golden_test.dart) and Flutter 3.41.9
// stable (matches .github/workflows/flutter-ci.yml) — goldens are sensitive
// to Skia/renderer version, so regenerate with that Flutter version on
// Windows: `flutter test --update-goldens test/features/trade/golden/`.
//
// Only a "data" state is captured here: TradeRepository.getTrade() (the
// read path TradePage's build() calls) is fully synchronous and ignores
// both `loadDelay` and `simulateError` on MockTradeRepository — those two
// flags only gate the async write path (submitOrder / submitFuturesOrder,
// used by the confirm-sheet flow, not the initial page render). Pumping
// TradePage with a delayed or error-simulating mock therefore renders a
// pixel-identical frame to the default data state — capturing it as a
// second/third golden would be a redundant PNG, not a real state diff.
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

// The PNGs are generated on Windows (the team's reference platform). Linux
// and macOS rasterize text with different anti-aliasing, so the pixel
// comparison only holds on Windows — elsewhere (incl. ubuntu CI) skip.
final _notOnGoldenPlatform = !Platform.isWindows;

void main() {
  Future<void> setViewport(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget appWith(TradeRepository repository) {
    return ProviderScope(
      overrides: [tradeRepositoryProvider.overrideWithValue(repository)],
      child: VitTradeApp(
        routerConfig: createAppRouter(initialLocation: AppRoutePaths.trade),
      ),
    );
  }

  testWidgets('golden: Trade data state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      appWith(const MockTradeRepository(loadDelay: Duration.zero)),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/trade_page_data.png'),
    );
  }, skip: _notOnGoldenPlatform);
}
