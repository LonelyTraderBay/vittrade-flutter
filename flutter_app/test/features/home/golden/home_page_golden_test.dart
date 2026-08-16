// Pixel baseline for lib/features/home/presentation/phone/pages/home_page.dart —
// the canonical UI reference ("SC-007 HomePage", see
// docs/02_FLUTTER_MIGRATION/standards/Flutter-Module-Identity-Standard.md). Pinned at
// 360x800 (minimum supported phone size, matches the convention used by
// test/quality/page_rhythm_phone_visual_qa_test.dart) and Flutter 3.41.9
// stable (matches .github/workflows/flutter-ci.yml) — goldens are sensitive
// to Skia/renderer version, so regenerate with that Flutter version on
// Windows: `flutter test --update-goldens test/features/home/golden/`.
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/home/data/providers/home_repository_provider.dart';
import 'package:vit_trade_flutter/features/home/data/repositories/mock_home_repository.dart';
import 'package:vit_trade_flutter/features/home/domain/repositories/home_repository.dart';

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

  Widget appWith(HomeRepository repository) {
    return ProviderScope(
      overrides: [homeRepositoryProvider.overrideWithValue(repository)],
      child: VitTradeApp(
        routerConfig: createAppRouter(initialLocation: AppRoutePaths.home),
      ),
    );
  }

  testWidgets('golden: Home data state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      appWith(const MockHomeRepository(loadDelay: Duration.zero)),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/home_page_data.png'),
    );
  }, skip: _notOnGoldenPlatform);

  testWidgets('golden: Home loading state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      appWith(const MockHomeRepository(loadDelay: Duration(milliseconds: 500))),
    );
    // Hai pump thay vì một (GĐ4-F2): badge thông báo trên shell giờ là
    // FutureProvider (mock Duration.zero) — cần thêm đúng một frame để badge
    // render ổn định trước khi chụp, nếu không pixel compare race theo
    // microtask (lúc có lúc không 500px diff). Home vẫn giữ loading nhờ
    // loadDelay 500ms nên frame thứ hai không đổi trạng thái skeleton.
    await tester.pump();
    await tester.pump();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/home_page_loading.png'),
    );

    await tester.pumpAndSettle();
  }, skip: _notOnGoldenPlatform);

  testWidgets('golden: Home error state', (tester) async {
    await setViewport(tester);
    await tester.pumpWidget(
      appWith(
        const MockHomeRepository(simulateError: true, loadDelay: Duration.zero),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(VitTradeApp),
      matchesGoldenFile('goldens/home_page_error.png'),
    );
  }, skip: _notOnGoldenPlatform);
}
