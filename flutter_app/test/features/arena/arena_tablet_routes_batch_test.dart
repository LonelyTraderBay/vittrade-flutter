// Batch test tablet sinh từ route group arena (coverage 2026-09-10:
// group + các trang tablet liên quan chưa phủ). Bất biến: mọi route tablet
// render trang thật — không rơi vào VitTabletUtilityPage, không exception.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/shared/layout/vit_tablet_utility_page.dart';

void main() {
  Future<void> pumpTablet(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            surface: AppSurface.tablet,
            initialLocation: location,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('arena tablet routes render trang thật (lô 1)', (tester) async {
    final locations = <String>[
      AppRoutePaths.arena,
      AppRoutePaths.arenaGuide,
      AppRoutePaths.arenaStudio,
      AppRoutePaths.arenaStudioSmartRules,
      AppRoutePaths.arenaStudioPresets,
      AppRoutePaths.arenaStudioGovernance,
      AppRoutePaths.arenaResolution,
      AppRoutePaths.arenaLeaderboard,
      AppRoutePaths.arenaVerified,
      AppRoutePaths.arenaPoints,
      AppRoutePaths.arenaFlowMap,
      AppRoutePaths.arenaSafety,
      AppRoutePaths.arenaBlocked,
      AppRoutePaths.arenaMyReports,
      AppRoutePaths.arenaMy,
      AppRoutePaths.arenaProduction,
      AppRoutePaths.arenaBridge,
      AppRoutePaths.arenaEcosystem,
      AppRoutePaths.arenaLedger,
    ];
    for (final location in locations) {
      await pumpTablet(tester, location);

      expect(find.byType(VitTabletUtilityPage), findsNothing, reason: location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });
}
