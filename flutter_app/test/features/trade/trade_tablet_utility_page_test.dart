import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/convert_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart';

void main() {
  Future<void> pumpTabletRoute(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeRepositoryProvider.overrideWithValue(
            const MockTradeRepository(loadDelay: Duration.zero),
          ),
        ],
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

  testWidgets('SC-056 Tablet uses the real convert composition '
      '(2026-08-31 — utility placeholder đã nghỉ hưu)', (tester) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradeConvert);

    expect(find.byType(ConvertTabletPage), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
    expect(find.byType(TradeTabletPage), findsNothing);
    expect(find.text('Chuyển đổi tài sản'), findsOneWidget);
  });

  testWidgets('SC-049 Tablet pair route uses the Trade Tablet page', (
    tester,
  ) async {
    await pumpTabletRoute(tester, AppRoutePaths.tradePair('ethusdt'));

    expect(find.byType(TradeTabletPage), findsOneWidget);
    expect(find.text('Giao dịch Spot'), findsOneWidget);
    expect(find.byType(TradeTabletUtilityPage), findsNothing);
  });

  // Phủ trực tiếp khung utility (coverage 2026-09-10: 64 dòng chưa phủ —
  // nhóm trên chỉ assert trang này KHÔNG xuất hiện ở route thật).
  group('pump trực tiếp khung TradeTabletUtilityPage', () {
    Future<void> pumpUtility(
      WidgetTester tester, {
      bool requiresConfirmation = false,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: TradeTabletUtilityPage(
            semanticIdentifier: 'TRADE-UT-TEST',
            title: 'Tiện ích Trade thử nghiệm',
            subtitle: 'Kiểm tra khung utility Trade',
            description: 'Mô tả ngắn về tiện ích đang chờ composition thật.',
            facts: const [
              TradeTabletFact(label: 'Trạng thái', value: 'Đang chờ backend'),
              TradeTabletFact(label: 'Bề mặt', value: 'Tablet'),
            ],
            actionLabel: 'Kích hoạt',
            requiresConfirmation: requiresConfirmation,
            confirmationTitle: 'Xác nhận Trade',
            confirmationMessage: 'Bạn có muốn tiếp tục thao tác này không?',
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('render đủ nội dung và key', (tester) async {
      await pumpUtility(tester);

      expect(
        find.byKey(const Key('TRADE-UT-TEST-tablet-content')),
        findsOneWidget,
      );
      expect(find.text('Tiện ích Trade thử nghiệm'), findsOneWidget);
      expect(find.text('Đang chờ backend'), findsOneWidget);
    });

    testWidgets('flow xác nhận mở sheet và đóng bằng confirm', (tester) async {
      await pumpUtility(tester, requiresConfirmation: true);

      await tester.tap(find.byKey(const Key('TRADE-UT-TEST-tablet-action')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('TRADE-UT-TEST-tablet-confirm-sheet')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('TRADE-UT-TEST-tablet-confirm')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('TRADE-UT-TEST-tablet-confirm-sheet')),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    });
  });
}
