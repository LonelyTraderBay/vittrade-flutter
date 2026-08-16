import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/prediction_data_integration_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDataIntegration(WidgetTester tester) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsDataIntegration,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-043 mock repository exposes the data integration BE draft',
    () async {
      final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
      final snapshot = await repo.getDataIntegration();

      expect(snapshot.sources, hasLength(4));
      expect(snapshot.apiKeys, hasLength(2));
      expect(snapshot.webhooks, hasLength(2));
      expect(snapshot.activeSources, 3);
      expect(snapshot.averageReliability.toStringAsFixed(1), '99.5');
      expect(snapshot.eventsResolved, 2807);
      expect(snapshot.predictionEvents, isNotEmpty);
      expect(snapshot.orders, hasLength(3));
      expect(snapshot.receipts, hasLength(6));
      expect(snapshot.rewards, isNotEmpty);
      expect(snapshot.lastUpdatedLabel, 'realtime-refresh');
      expect(
        snapshot.supportedStates,
        containsAll([
          PredictionScreenState.loading,
          PredictionScreenState.empty,
          PredictionScreenState.error,
          PredictionScreenState.offline,
          PredictionScreenState.realtimeRefresh,
        ]),
      );
    },
  );

  testWidgets('SC-043 first viewport reaches configured source content', (
    tester,
  ) async {
    await pumpDataIntegration(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-043 PredictionDataIntegrationPage',
      semanticLabel:
          'Tích hợp dữ liệu dự đoán: nguồn dữ liệu, khóa API và webhook',
    );
    expectFirstViewportVisible(
      tester,
      find.text('CoinGecko Price Oracle'),
      targetLabel: 'the first configured source card',
      minVisibleHeight: 12,
    );
  });

  testWidgets('SC-043 renders sources inside the Markets shell', (
    tester,
  ) async {
    await pumpDataIntegration(tester);

    expect(find.byType(PredictionDataIntegrationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Data Integration'), findsOneWidget);
    expect(find.text('Dữ liệu · Prediction'), findsOneWidget);
    expect(find.text('Nguon du lieu'), findsOneWidget);
    expect(find.text('API Keys'), findsOneWidget);
    expect(find.text('Webhooks'), findsOneWidget);
    expect(find.text('Oracle Data Sources'), findsOneWidget);
    expect(find.text('Configured Sources'), findsOneWidget);
    expect(find.text('CoinGecko Price Oracle'), findsOneWidget);
    expect(find.text('Chainlink Oracle Network'), findsOneWidget);
    expect(
      find.byKey(PredictionDataIntegrationPage.addSourceKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-043 switches API key tab and toggles masked keys', (
    tester,
  ) async {
    await pumpDataIntegration(tester);

    await tester.tap(find.byKey(PredictionDataIntegrationPage.apiKeysTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Your API Keys'), findsOneWidget);
    expect(find.text('Production API'), findsOneWidget);
    expect(find.text('pk_live_******************'), findsOneWidget);

    await tester.tap(
      find.byKey(PredictionDataIntegrationPage.revealApiKey('key1')),
    );
    await tester.pumpAndSettle();
    expect(find.text('pk_live_abc123xyz789def456'), findsOneWidget);

    await tester.tap(
      find.byKey(PredictionDataIntegrationPage.copyApiKey('key1')),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
  });

  testWidgets('SC-043 switches webhooks tab', (tester) async {
    await pumpDataIntegration(tester);

    await tester.tap(find.byKey(PredictionDataIntegrationPage.webhooksTabKey));
    await tester.pumpAndSettle();

    expect(find.text('Webhook Endpoints'), findsOneWidget);
    expect(
      find.text('https://example.com/webhooks/prediction-resolved'),
      findsOneWidget,
    );
    expect(find.text('event.resolved'), findsOneWidget);
    expect(
      find.byKey(PredictionDataIntegrationPage.addWebhookKey),
      findsOneWidget,
    );
  });

  testWidgets('SC-043 add-source CTA shows a placeholder snackbar', (
    tester,
  ) async {
    await pumpDataIntegration(tester);

    await tester.ensureVisible(
      find.byKey(PredictionDataIntegrationPage.addSourceKey),
    );
    await tester.tap(find.byKey(PredictionDataIntegrationPage.addSourceKey));
    await tester.pumpAndSettle();
    expect(find.text('Thêm nguồn dữ liệu sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-043 create-API-key CTA shows a placeholder snackbar', (
    tester,
  ) async {
    await pumpDataIntegration(tester);

    await tester.tap(find.byKey(PredictionDataIntegrationPage.apiKeysTabKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(PredictionDataIntegrationPage.createApiKeyKey),
    );
    await tester.tap(find.byKey(PredictionDataIntegrationPage.createApiKeyKey));
    await tester.pumpAndSettle();
    expect(find.text('Tạo API Key sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-043 add-webhook CTA shows a placeholder snackbar', (
    tester,
  ) async {
    await pumpDataIntegration(tester);

    await tester.tap(find.byKey(PredictionDataIntegrationPage.webhooksTabKey));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(PredictionDataIntegrationPage.addWebhookKey),
    );
    await tester.tap(find.byKey(PredictionDataIntegrationPage.addWebhookKey));
    await tester.pumpAndSettle();
    expect(find.text('Thêm Webhook sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-043 back button returns to Predictions home', (tester) async {
    await pumpDataIntegration(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
