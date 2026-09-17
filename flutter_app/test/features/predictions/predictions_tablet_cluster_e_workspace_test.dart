import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';

/// Gate test Cụm E (redesign 2026-09-17 — batch đóng 18/18 màn): 4 màn
/// cộng đồng/sự kiện lên workspace 2 cột; SC-225 biên lai giữ một cột đúng
/// quyết định 2026-09-13 (skip dedicated layout).
void main() {
  Future<void> pumpAt(
    WidgetTester tester,
    String location, {
    Size size = const Size(1280, 900),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
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

  testWidgets('SC-213 phần thưởng: hero + bảng cột chính, chip panel phải', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutePaths.marketsPredictionsRewards);

    expect(
      find.byKey(PredictionsRewardsTabletPage.controlPaneKey),
      findsOneWidget,
    );
    expect(find.text('Quỹ thưởng hàng ngày'), findsOneWidget);
    expect(find.text('Cơ hội kiếm thưởng'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-220 cộng đồng: bình luận cột chính, insight panel phải', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutePaths.marketsPredictionsSocial);

    expect(
      find.byKey(PredictionSocialTabletPage.insightPaneKey),
      findsOneWidget,
    );
    expect(find.text('Sentiment cộng đồng'), findsOneWidget);
    expect(find.text('Bình luận'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-222 giải đấu: tabs + thẻ grid cột chính, stats panel phải', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutePaths.marketsPredictionsTournaments);

    expect(
      find.byKey(PredictionTournamentsTabletPage.controlPaneKey),
      findsOneWidget,
    );
    expect(find.text('Đang diễn ra'), findsWidgets);
    expect(find.text('Thống kê nhanh'), findsOneWidget);

    await tester.tap(find.text('Crypto Masters Q1 2026').first);
    await tester.pumpAndSettle();
    expect(
      find.byKey(PredictionTournamentDetailTabletPage.controlPaneKey),
      findsOneWidget,
    );
    expect(find.text('Bảng xếp hạng giải đấu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-225 biên lai: giữ một cột (quyết định skip layout)', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutePaths.marketsPredictionReceipt('po-1'));

    expect(find.text('Chi tiết lệnh'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
