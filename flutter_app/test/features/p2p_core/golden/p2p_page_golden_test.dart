// Pixel baseline for lib/features/p2p_marketplace/presentation/phone/pages/hub/p2p_home_page.dart
// ("SC-282 P2P Home", see
// docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md).
// Pinned at 360x800 (minimum supported phone size, matches the convention
// used by test/quality/page_rhythm_phone_visual_qa_test.dart and
// test/features/home/golden/home_page_golden_test.dart) and Flutter 3.41.9
// stable (matches .github/workflows/flutter-ci.yml) — goldens are sensitive
// to Skia/renderer version, so regenerate with that Flutter version on
// Windows: `flutter test --update-goldens test/features/p2p_core/golden/`.
//
// Only a "data" state is captured here: MockP2PRepository (unlike
// MockTradeRepository/MockHomeRepository) has no `loadDelay`/`simulateError`
// constructor knobs — see test/features/p2p_core/p2p_home_page_test.dart, which
// pumps the default ProviderScope() the same way. There is no
// distinguishable loading/error state to override for this repository.
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';

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

  testWidgets('golden: P2P data state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.p2p),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/p2p_page_data.png'),
    );
  }, skip: _notOnGoldenPlatform);
}
