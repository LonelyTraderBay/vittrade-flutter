// Pixel baseline for
// lib/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart
// ("SC-327 Staking & Earn", see
// docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md).
// Pinned at 360x800 (minimum supported phone size, matches the convention
// used by test/quality/page_rhythm_phone_visual_qa_test.dart and
// test/features/home/golden/home_page_golden_test.dart) and Flutter 3.41.9
// stable (matches .github/workflows/flutter-ci.yml) — goldens are sensitive
// to Skia/renderer version, so regenerate with that Flutter version on
// Windows: `flutter test --update-goldens test/features/earn_core/golden/`.
//
// Only a "data" state is captured here: MockStakingEarnRepository (unlike
// MockTradeRepository/MockHomeRepository) is fully synchronous with no
// `loadDelay`/`simulateError` constructor knobs — see
// test/features/earn_core/staking_earn_page_test.dart, which pumps the default
// ProviderScope() the same way. There is no distinguishable loading/error
// state to override for this repository.
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

  testWidgets('golden: Earn data state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.earn),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/earn_page_data.png'),
    );
  }, skip: _notOnGoldenPlatform);
}
