import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/provider/copy_provider_detail_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/flow/pre_copy_assessment_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopyProviderDetail(
    WidgetTester tester, {
    String providerId = 'provider001',
    String? initialLocation,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation:
                initialLocation ?? AppRoutePaths.tradeCopyProvider(providerId),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-070 mock repository exposes provider detail BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final notFound = await repo.getCopyProviderDetail(
      providerId: 'provider001',
    );
    final found = await repo.getCopyProviderDetail(providerId: 'ct001');

    expect(notFound.providerId, 'provider001');
    expect(notFound.isNotFound, isTrue);
    expect(found.provider?.name, 'AlphaHunter_VN');
    expect(
      notFound.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-070 renders the Provider Not Found state in Trade shell', (
    tester,
  ) async {
    await pumpCopyProviderDetail(tester);

    expect(find.byType(CopyProviderDetailPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Không tìm thấy provider'), findsOneWidget);
    expect(find.byKey(CopyProviderDetailPage.notFoundKey), findsOneWidget);
  });

  testWidgets('SC-070 first viewport reaches risk assessment CTA', (
    tester,
  ) async {
    await pumpCopyProviderDetail(tester, providerId: 'ct001');

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-070 CopyProviderDetailPage',
      semanticLabel: 'Chi tiết provider',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(CopyProviderDetailPage.assessmentKey),
      routeName: 'SC-070 CopyProviderDetailPage',
      actionLabel: 'the risk assessment CTA',
    );
  });

  testWidgets('SC-070 back returns to SC-063 CopyTradingPage', (tester) async {
    await pumpCopyProviderDetail(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(CopyProviderDetailPage), findsNothing);
  });

  testWidgets('SC-070 valid back query returns to the encoded source route', (
    tester,
  ) async {
    await pumpCopyProviderDetail(
      tester,
      providerId: 'ct001',
      initialLocation: AppRoutePaths.tradeCopyProvider(
        'ct001',
        backPath: AppRoutePaths.tradeCopyTrading,
      ),
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(CopyProviderDetailPage), findsNothing);
  });

  testWidgets('SC-070 invalid back query falls back to copy trading parent', (
    tester,
  ) async {
    await pumpCopyProviderDetail(
      tester,
      providerId: 'ct001',
      initialLocation: AppRoutePaths.tradeCopyProvider(
        'ct001',
        backPath: 'https://evil.example/phish',
      ),
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(CopyProviderDetailPage), findsNothing);
  });

  testWidgets('SC-070 assessment CTA uses the SC-071 route edge', (
    tester,
  ) async {
    await pumpCopyProviderDetail(tester, providerId: 'ct001');

    await tester.tap(find.byKey(CopyProviderDetailPage.assessmentKey));
    await tester.pumpAndSettle();

    expect(find.byType(PreCopyAssessmentPage), findsOneWidget);
    expect(find.text('Đánh giá rủi ro'), findsOneWidget);
  });
}
