// Walker-test kiểm soát toàn bộ hành vi back của module predictions trên tablet:
// vào đúng đường user thật (tab Markets → push trang chủ dự đoán → push TỪNG
// trang con → bấm nút back) và yêu cầu mỗi lần back quay về đúng trang trước
// đó (trang chủ), KHÔNG nhảy thẳng ra Markets. Nếu một trang con fail, tên
// route hiện trong reason để khoanh vùng ngay.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_home_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';

Finder get _backButton => find.byWidgetPredicate(
  (widget) =>
      widget is VitHeaderActionButton &&
      widget.type == VitHeaderActionType.back,
);

void main() {
  late GoRouter appRouter;

  /// Markets tab có ticker/animation lặp vô hạn — pumpAndSettle không bao giờ
  /// kết thúc. Pump có giới hạn là đủ cho push route + animation chuyển trang.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> pumpFromMarkets(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    appRouter = createAppRouter(
      initialLocation: AppRoutePaths.markets,
      surface: AppSurface.tablet,
    );
    await tester.pumpWidget(
      ProviderScope(child: VitTradeApp(routerConfig: appRouter)),
    );
    await settle(tester);

    // Đường vào thật của user: thẻ "Dự đoán" trên Markets push trang chủ.
    unawaited(appRouter.push(AppRoutePaths.marketsPredictions));
    await settle(tester);
    expect(find.byType(PredictionsHomeTabletPage), findsOneWidget);
  }

  // Mỗi mục: (tên route dùng trong reason, path).
  final subPages = <(String, String)>[
    ('search', AppRoutePaths.marketsPredictionsSearch),
    ('breaking', AppRoutePaths.marketsPredictionsBreaking),
    ('event-detail', AppRoutePaths.marketsPredictionEvent('pred-1')),
    ('portfolio', AppRoutePaths.marketsPredictionsPortfolio),
    ('rewards', AppRoutePaths.marketsPredictionsRewards),
    ('leaderboard', AppRoutePaths.marketsPredictionsLeaderboard),
    ('activity', AppRoutePaths.marketsPredictionsActivity),
    ('receipt', AppRoutePaths.marketsPredictionReceipt('po-1')),
    ('risk-calculator', AppRoutePaths.marketsPredictionsRiskCalculator),
    ('market-maker', AppRoutePaths.marketsPredictionsMarketMaker),
    ('portfolio-analyzer', AppRoutePaths.marketsPredictionsPortfolioAnalyzer),
    ('event-calendar', AppRoutePaths.marketsPredictionsEventCalendar),
    ('social', AppRoutePaths.marketsPredictionsSocial),
    ('advanced-chart', AppRoutePaths.marketsPredictionsAdvancedChart('pred-1')),
    ('tournaments', AppRoutePaths.marketsPredictionsTournaments),
    ('tournament-detail', AppRoutePaths.marketsPredictionTournament('t-1')),
    ('data-integration', AppRoutePaths.marketsPredictionsDataIntegration),
  ];

  for (final (name, path) in subPages) {
    testWidgets('back từ $name quay về trang chủ dự đoán (không về Markets)', (
      tester,
    ) async {
      await pumpFromMarkets(tester);

      unawaited(appRouter.push(path));
      await settle(tester);
      expect(
        find.byType(PredictionsHomeTabletPage),
        findsNothing,
        reason: 'Trang $name phải hiển thị trên trang chủ.',
      );
      expect(
        _backButton,
        findsOneWidget,
        reason: 'Trang $name thiếu nút back.',
      );

      await tester.tap(_backButton);
      await settle(tester);
      expect(
        find.byType(PredictionsHomeTabletPage),
        findsOneWidget,
        reason:
            'Back từ $name phải pop đúng 1 tầng về trang chủ dự đoán, '
            'không nhảy thẳng ra Markets.',
      );
    });
  }

  testWidgets('chuỗi sâu: home → event → chart, back từng tầng đúng', (
    tester,
  ) async {
    await pumpFromMarkets(tester);

    unawaited(appRouter.push(AppRoutePaths.marketsPredictionEvent('pred-1')));
    await settle(tester);
    unawaited(
      appRouter.push(AppRoutePaths.marketsPredictionsAdvancedChart('pred-1')),
    );
    await settle(tester);

    await tester.tap(_backButton);
    await settle(tester);
    expect(
      find.byType(PredictionsHomeTabletPage),
      findsNothing,
      reason: 'Back từ chart phải về event detail (tầng trước).',
    );

    await tester.tap(_backButton);
    await settle(tester);
    expect(
      find.byType(PredictionsHomeTabletPage),
      findsOneWidget,
      reason: 'Back từ event detail phải về trang chủ dự đoán.',
    );
  });

  testWidgets('chuỗi sâu: home → tournaments → tournament detail', (
    tester,
  ) async {
    await pumpFromMarkets(tester);

    unawaited(appRouter.push(AppRoutePaths.marketsPredictionsTournaments));
    await settle(tester);
    unawaited(appRouter.push(AppRoutePaths.marketsPredictionTournament('t-1')));
    await settle(tester);

    await tester.tap(_backButton);
    await settle(tester);
    expect(
      find.byType(PredictionTournamentsTabletPage),
      findsOneWidget,
      reason: 'Back từ tournament detail phải về danh sách tournaments.',
    );
  });

  testWidgets('back từ chính trang chủ dự đoán → Markets (điểm vào)', (
    tester,
  ) async {
    await pumpFromMarkets(tester);
    expect(_backButton, findsOneWidget);

    await tester.tap(_backButton);
    await settle(tester);
    expect(
      find.byType(PredictionsHomeTabletPage),
      findsNothing,
      reason: 'Back từ trang chủ dự đoán phải về Markets (trang trước nó).',
    );
  });
}
