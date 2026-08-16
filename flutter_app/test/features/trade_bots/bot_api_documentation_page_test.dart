import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/settings/bot_api_documentation_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotApiDocumentation(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotApiDocumentation,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-134 mock repository exposes bot API documentation BE draft',
    () async {
      final snapshot = await const MockTradeBotsRepository(
        loadDelay: Duration.zero,
      ).getBotApiDocumentation();

      expect(snapshot.tabs.map((item) => item.id), [
        'endpoints',
        'websocket',
        'examples',
      ]);
      expect(snapshot.defaultView, 'endpoints');
      expect(snapshot.defaultLanguage, 'javascript');
      expect(snapshot.endpoints, hasLength(4));
      expect(snapshot.endpoints.first.method, 'GET');
      expect(snapshot.endpoints.first.path, '/api/v1/bots');
      expect(snapshot.websocketEvents, hasLength(3));
      expect(snapshot.codeExamples, hasLength(3));
      expect(snapshot.rateLimits, hasLength(3));
      expect(
        snapshot.endpoint,
        '/api/mobile/trade/trade-bots-api-documentation',
      );
      expect(snapshot.actionDraft, contains('POST /bots/create'));
      expect(
        snapshot.authenticationHeader,
        'Authorization: Bearer YOUR_API_KEY',
      );
      expect(
        snapshot.supportedStates,
        containsAll([
          TradeScreenState.loading,
          TradeScreenState.empty,
          TradeScreenState.error,
          TradeScreenState.offline,
          TradeScreenState.realtimeRefresh,
        ]),
      );
    },
  );

  testWidgets('SC-134 renders API documentation baseline in Trade shell', (
    tester,
  ) async {
    await pumpBotApiDocumentation(tester);

    expect(find.byType(BotApiDocumentationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Tài liệu API'), findsOneWidget);
    expect(find.text('Tài liệu API bot'), findsOneWidget);
    expect(find.text('endpoints'), findsOneWidget);
    expect(find.text('websocket'), findsOneWidget);
    expect(find.text('examples'), findsOneWidget);
    expect(find.text('Các điểm cuối REST API'), findsOneWidget);
    expect(find.text('/api/v1/bots'), findsWidgets);
    expect(find.text('List all user bots'), findsOneWidget);
    expect(find.text('THAM SỐ:'), findsWidgets);
    expect(find.text('PHẢN HỒI:'), findsWidgets);
  });

  testWidgets('SC-134 tabs switch websocket and examples content', (
    tester,
  ) async {
    await pumpBotApiDocumentation(tester);

    await tester.tap(BotApiDocumentationPage.tabKey('websocket').finder);
    await tester.pumpAndSettle();
    expect(find.text('Kết nối WebSocket'), findsOneWidget);
    expect(find.text('Loại sự kiện'), findsOneWidget);
    expect(find.text('bot.status'), findsOneWidget);

    await tester.tap(BotApiDocumentationPage.tabKey('examples').finder);
    await tester.pumpAndSettle();
    expect(find.text('Bắt đầu nhanh'), findsOneWidget);
    expect(find.text('JavaScript SDK'), findsOneWidget);

    await tester.tap(BotApiDocumentationPage.languageKey('python').finder);
    await tester.pumpAndSettle();
    expect(find.text('Python SDK'), findsOneWidget);

    await tester.tap(find.text('Sao chép'));
    await tester.pumpAndSettle();
    expect(find.text('Đã sao chép!'), findsOneWidget);
  });

  testWidgets('SC-134 first viewport reaches first endpoint card', (
    tester,
  ) async {
    await pumpBotApiDocumentation(tester);

    expectActionableInFirstViewport(
      tester,
      BotApiDocumentationPage.endpointKey('GET', '/api/v1/bots').finder,
      routeName: 'BotApiDocumentationPage',
      actionLabel: 'first REST endpoint card',
    );
  });
}

extension on Key {
  Finder get finder => find.byKey(this);
}
