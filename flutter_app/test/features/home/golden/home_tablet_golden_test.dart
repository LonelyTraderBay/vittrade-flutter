// Tablet visual reference for the Home route. Every frame pins
// AppSurface.tablet: at 600px the tablet page renders its single-column
// fallback (VitTwoColumnTabletDashboard dưới 900px), wider frames exercise
// the dedicated Home Tablet composition.
//
// Goldens are generated on Windows with the repository Flutter version:
// `flutter test --update-goldens test/features/home/golden/home_tablet_golden_test.dart`.
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';

final _notOnGoldenPlatform = !Platform.isWindows;

void main() {
  Future<void> pumpHomeAt(WidgetTester tester, double width) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 820);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(
            const MockHomeRepository(loadDelay: Duration.zero),
          ),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: AppRoutePaths.home,
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
    testWidgets('golden: Home tablet reference at $name'
        'px', (tester) async {
      await pumpHomeAt(tester, width);

      await expectLater(
        find.byType(VitTradeApp),
        matchesGoldenFile('goldens/home_tablet_$name.png'),
      );
    }, skip: _notOnGoldenPlatform);
  }
}
