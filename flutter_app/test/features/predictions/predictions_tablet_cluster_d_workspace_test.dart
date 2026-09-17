import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_market_maker_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_risk_calculator_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';

/// Gate test Cụm D (redesign 2026-09-17): 3 màn công cụ theo khuôn
/// "form trái — kết quả phải": kết quả live ghim panel phải ở tầng rộng,
/// nhúng lại trong luồng một cột ở tầng hẹp (SC-217 form nhúng ước tính).
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

  testWidgets(
    'SC-216 máy tính rủi ro: form cột chính, kết quả live panel phải',
    (tester) async {
      await pumpAt(tester, AppRoutePaths.marketsPredictionsRiskCalculator);

      expect(
        find.byKey(PredictionRiskCalculatorTabletPage.resultPaneKey),
        findsOneWidget,
      );
      // Kết quả luôn đọc được khi đang ở tab Kịch bản.
      await tester.tap(
        find.byKey(PredictionRiskCalculatorTabletPage.scenariosTabKey),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(PredictionRiskCalculatorTabletPage.resultPaneKey),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('SC-216 hẹp: một cột, kết quả theo sau form', (tester) async {
    await pumpAt(
      tester,
      AppRoutePaths.marketsPredictionsRiskCalculator,
      size: const Size(800, 1280),
    );

    expect(
      find.byKey(PredictionRiskCalculatorTabletPage.resultPaneKey),
      findsNothing,
    );
    expect(find.text('Máy tính'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'SC-217 market maker: form trái, ước tính + tổng quan panel phải',
    (tester) async {
      await pumpAt(tester, AppRoutePaths.marketsPredictionsMarketMaker);

      expect(
        find.byKey(PredictionMarketMakerTabletPage.controlPaneKey),
        findsOneWidget,
      );
      // Tổng quan thanh khoản ghim panel khi sang tab Vị thế.
      await tester.tap(
        find.byKey(PredictionMarketMakerTabletPage.positionsTabKey),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(PredictionMarketMakerTabletPage.controlPaneKey),
        findsOneWidget,
      );
      expect(find.text('Các vị thế'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('SC-224 tích hợp dữ liệu: nguồn cột chính, quản lý panel phải', (
    tester,
  ) async {
    await pumpAt(tester, AppRoutePaths.marketsPredictionsDataIntegration);

    expect(
      find.byKey(PredictionDataIntegrationTabletPage.controlPaneKey),
      findsOneWidget,
    );
    expect(find.text('Nguồn dữ liệu'), findsOneWidget);
    expect(find.text('Khóa API'), findsOneWidget);
    expect(find.text('Webhook'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
