// Pixel baseline for lib/features/wallet/presentation/phone/pages/wallet_page.dart
// ("SC-135 Wallet", see
// docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md).
// Pinned at 360x800 (minimum supported phone size, matches the convention
// used by test/quality/page_rhythm_phone_visual_qa_test.dart and
// test/features/home/golden/home_page_golden_test.dart) and Flutter 3.41.9
// stable (matches .github/workflows/flutter-ci.yml) — goldens are sensitive
// to Skia/renderer version, so regenerate with that Flutter version on
// Windows: `flutter test --update-goldens test/features/wallet/golden/`.
//
// MockWalletRepository (unlike MockTradeRepository/MockHomeRepository) has
// no `loadDelay`/`simulateError` constructor knobs, so there is no
// distinguishable "loading" state to capture here. For "error" this file
// reuses the fail-closed override already established by
// test/features/wallet/wallet_page_test.dart ("SC-135 production wallet
// without backend fails closed in UI"): forcing AppEnvironment.production
// with enableMockData: false routes WalletPage to
// FailClosedWalletRepository, which renders a real, distinct "service
// unavailable" UI state.
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/config/app_environment.dart';
import 'package:vit_trade_flutter/core/network/api_client.dart';

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

  testWidgets('golden: Wallet data state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.wallet),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/wallet_page_data.png'),
    );
  }, skip: _notOnGoldenPlatform);

  testWidgets('golden: Wallet error (fail-closed) state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(
            AppConfig(
              environment: AppEnvironment.production,
              apiBaseUrl: Uri.parse('https://api.vittrade.example'),
              enableMockData: false,
            ),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: AppRoutePaths.wallet),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/wallet_page_error.png'),
    );
  }, skip: _notOnGoldenPlatform);
}
