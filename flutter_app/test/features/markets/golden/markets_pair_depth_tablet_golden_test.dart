// Tablet visual reference for the Markets pair depth pane. Frames pin
// AppSurface.tablet and deep-link straight into /pair/btcusdt/depth so the
// golden captures the terminal master-detail composition with the real
// depth pane in the detail column.
//
// Goldens are generated on Windows with the repository Flutter version:
// `flutter test --update-goldens test/features/markets/golden/markets_pair_depth_tablet_golden_test.dart`.
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/markets/data/providers/market_repository_provider.dart';
import 'package:vit_trade_flutter/features/markets/data/repositories/mock_market_repository.dart';

final _notOnGoldenPlatform = !Platform.isWindows;

void main() {
  Future<void> pumpDepthAt(WidgetTester tester, double width) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 820);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          marketRepositoryProvider.overrideWithValue(
            const MockMarketRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: '/pair/btcusdt/depth',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final (width, name) in [
    (600.0, '600'),
    (768.0, '768'),
    (1024.0, '1024'),
    (1280.0, '1280'),
  ]) {
    testWidgets('golden: Markets depth pane reference at $name'
        'px', (tester) async {
      await pumpDepthAt(tester, width);

      await expectLater(
        find.byType(VitTradeApp),
        matchesGoldenFile('goldens/markets_pair_depth_tablet_$name.png'),
      );
    }, skip: _notOnGoldenPlatform);
  }
}
