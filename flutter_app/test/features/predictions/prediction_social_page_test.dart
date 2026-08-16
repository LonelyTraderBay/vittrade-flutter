import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/social/prediction_social_page.dart';
import 'package:vit_trade_flutter/features/predictions/presentation/phone/pages/hub/predictions_home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSocial(WidgetTester tester) async {
    configureFirstViewport(tester, VitFirstViewport.qaPhone);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.marketsPredictionsSocial,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-040 mock repository exposes the social BE draft', () async {
    final repo = const MockPredictionsRepository(loadDelay: Duration.zero);
    final snapshot = await repo.getSocial();

    expect(snapshot.eventTitle, 'BTC > \$100K by Dec 2026?');
    expect(snapshot.comments, hasLength(3));
    expect(snapshot.totalComments, 4);
    expect(snapshot.bullishPercent, 58);
    expect(snapshot.sentiment.map((item) => item.value), [58, 22, 20]);
    expect(snapshot.contributors, hasLength(3));
    expect(
      snapshot.shareUrl,
      'https://app.example.com/predictions/event/pred-1',
    );
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
  });

  testWidgets('SC-040 renders comments tab inside the Markets shell', (
    tester,
  ) async {
    await pumpSocial(tester);

    expect(find.byType(PredictionSocialPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_markets')),
      findsOneWidget,
    );
    expect(find.text('Social & Discussion'), findsOneWidget);
    expect(find.text('Thảo luận · Prediction'), findsOneWidget);
    expect(find.text('Binh luan'), findsOneWidget);
    expect(find.text('Phan tich'), findsOneWidget);
    expect(find.text('Chia se'), findsOneWidget);
    expect(find.text('BTC > \$100K by Dec 2026?'), findsOneWidget);
    expect(find.text('4 comments'), findsOneWidget);
    expect(find.text('58% Bullish'), findsOneWidget);
    expect(find.text('Them binh luan'), findsOneWidget);
    expect(find.text('4 binh luan'), findsOneWidget);
    expect(find.text('CryptoAnalyst'), findsOneWidget);
    expect(find.text('ChartMaster'), findsOneWidget);
    expect(find.text('BearMarketSurvivor'), findsOneWidget);
  });

  testWidgets('SC-040 first viewport reaches comment composer', (tester) async {
    await pumpSocial(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-040 PredictionSocialPage',
      semanticLabel: 'Thảo luận xã hội về sự kiện dự đoán',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Them binh luan'),
      targetLabel: 'the comment composer',
      minVisibleHeight: 12,
    );
  });

  testWidgets('SC-040 stance, comment input, tabs, and copy action are local', (
    tester,
  ) async {
    await pumpSocial(tester);

    await tester.tap(find.text('BULLISH').first);
    await tester.enterText(
      find.byKey(PredictionSocialPage.commentFieldKey),
      'Toi nghieng ve kich ban tang.',
    );
    await tester.pumpAndSettle();
    expect(find.text('Toi nghieng ve kich ban tang.'), findsOneWidget);

    await tester.tap(find.byKey(PredictionSocialPage.analysisTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Community Sentiment'), findsOneWidget);
    expect(find.text('Nguoi dong gop hang dau'), findsOneWidget);
    expect(find.text('Sentiment Trend'), findsOneWidget);

    await tester.tap(find.byKey(PredictionSocialPage.shareTabKey));
    await tester.pumpAndSettle();
    expect(find.text('Chia se qua mang xa hoi'), findsOneWidget);
    expect(find.text('Twitter'), findsOneWidget);
    expect(find.text('Facebook'), findsOneWidget);

    await tester.tap(find.byKey(PredictionSocialPage.copyLinkKey));
    await tester.pumpAndSettle();
    expect(find.text('Copied'), findsOneWidget);
  });

  testWidgets('SC-040 back button returns to Predictions home', (tester) async {
    await pumpSocial(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(PredictionsHomePage), findsOneWidget);
  });
}
