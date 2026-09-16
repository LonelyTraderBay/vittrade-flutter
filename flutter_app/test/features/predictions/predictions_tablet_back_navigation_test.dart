// Back-navigation hợp đồng (Production-Ready): nút back phải POP ĐÚNG MỘT
// TẦNG về trang trước đó (BackNavigationMode.historyThenFallback qua
// goBackOrFallback), system back tương đương; fallback chỉ dùng khi hết
// stack. Khóa bằng widget test tap THẬT vào nút back của cả 2 loại header
// (VitTabletSectionFrame và custom scaffold Event Detail).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/bootstrap/app_surface.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart' as router;
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/prediction_event_detail_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_home_tablet_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/tablet/pages/predictions_tablet_pages.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/widgets/tablet/prediction_event_card_tablet.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header_action_button.dart';

Finder get _backButton => find.byWidgetPredicate(
  (widget) =>
      widget is VitHeaderActionButton &&
      widget.type == VitHeaderActionType.back,
);

void main() {
  Future<void> pumpTabletRoute(WidgetTester tester, String location) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
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

  testWidgets('Frame back (BXH) pop đúng 1 tầng về trang chủ', (tester) async {
    await pumpTabletRoute(tester, router.AppRoutePaths.marketsPredictions);
    expect(find.byType(PredictionsHomeTabletPage), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('BXH'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('BXH').first);
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsLeaderboardTabletPage), findsOneWidget);
    expect(_backButton, findsOneWidget);

    await tester.tap(_backButton);
    await tester.pumpAndSettle();
    expect(
      find.byType(PredictionsHomeTabletPage),
      findsOneWidget,
      reason: 'Back phải pop đúng 1 tầng về trang trước (trang chủ).',
    );
    expect(find.byType(PredictionsLeaderboardTabletPage), findsNothing);
  });

  testWidgets('Custom header back (Event Detail) pop đúng 1 tầng', (
    tester,
  ) async {
    await pumpTabletRoute(tester, router.AppRoutePaths.marketsPredictions);

    final firstCard = find.byType(PredictionEventCardTablet).first;
    await tester.scrollUntilVisible(
      firstCard,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(firstCard);
    await tester.pumpAndSettle();
    expect(find.byType(PredictionEventDetailTabletPage), findsOneWidget);
    expect(_backButton, findsOneWidget);

    await tester.tap(_backButton);
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomeTabletPage), findsOneWidget);
    expect(find.byType(PredictionEventDetailTabletPage), findsNothing);
  });

  testWidgets('Chuỗi 3 tầng pop từng tầng một (Home→Event→Rewards)', (
    tester,
  ) async {
    await pumpTabletRoute(tester, router.AppRoutePaths.marketsPredictions);

    final firstCard = find.byType(PredictionEventCardTablet).first;
    await tester.scrollUntilVisible(
      firstCard,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(firstCard);
    await tester.pumpAndSettle();
    expect(find.byType(PredictionEventDetailTabletPage), findsOneWidget);

    final rewardsLink = find.byKey(
      PredictionEventDetailTabletPage.dailyRewardsKey,
    );
    await tester.scrollUntilVisible(
      rewardsLink,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(rewardsLink);
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsRewardsTabletPage), findsOneWidget);

    // Tầng 3 -> tầng 2
    await tester.tap(_backButton);
    await tester.pumpAndSettle();
    expect(
      find.byType(PredictionEventDetailTabletPage),
      findsOneWidget,
      reason:
          'Back từ Rewards phải về Event Detail (tầng trước), '
          'không nhảy về trang chủ.',
    );

    // Tầng 2 -> tầng 1
    await tester.tap(_backButton);
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomeTabletPage), findsOneWidget);
  });

  testWidgets('System back tương đương nút back (pop 1 tầng)', (tester) async {
    await pumpTabletRoute(tester, router.AppRoutePaths.marketsPredictions);

    final firstCard = find.byType(PredictionEventCardTablet).first;
    await tester.scrollUntilVisible(
      firstCard,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(firstCard);
    await tester.pumpAndSettle();
    expect(find.byType(PredictionEventDetailTabletPage), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(
      find.byType(PredictionsHomeTabletPage),
      findsOneWidget,
      reason: 'System back phải pop đúng 1 tầng, không thoát app.',
    );
  });
}
