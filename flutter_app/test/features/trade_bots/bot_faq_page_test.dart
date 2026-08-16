import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/settings/bot_faq_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpBotFaq(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotFaq,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-132 mock repository exposes bot FAQ BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotFaq();

    expect(snapshot.categories, hasLength(5));
    expect(snapshot.totalFaqs, 25);
    expect(snapshot.categories.first.id, 'general');
    expect(snapshot.categories.first.items, hasLength(5));
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-faq');
    expect(snapshot.actionDraft, contains('POST /trade/order-preview'));
    expect(snapshot.actionDraft, contains('POST /bots/create'));
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
  });

  testWidgets('SC-132 renders FAQ baseline in Trade shell', (tester) async {
    await pumpBotFaq(tester);

    expect(find.byType(BotFaqPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Hỏi đáp Bot giao dịch'), findsOneWidget);
    expect(find.text('Tìm câu hỏi...'), findsOneWidget);
    expect(find.text('General (5)'), findsOneWidget);
    expect(find.text('What is a trading bot?'), findsOneWidget);
    expect(find.text('Can I lose more than I invest?'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
    expect(find.text('Vẫn cần trợ giúp?'), findsOneWidget);
  });

  testWidgets('SC-132 first viewport reaches FAQ tabs and first item', (
    tester,
  ) async {
    await pumpBotFaq(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-132 BotFAQPage',
      semanticLabel: 'Giải đáp câu hỏi thường gặp về bot giao dịch',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(BotFaqPage.tabKey('general')),
      routeName: 'SC-132 BotFAQPage',
      actionLabel: 'FAQ category tabs',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(BotFaqPage.questionKey('general', 0)),
      routeName: 'SC-132 BotFAQPage',
      actionLabel: 'the first FAQ item',
    );
  });

  testWidgets('SC-132 category tabs and search filter FAQ data', (
    tester,
  ) async {
    await pumpBotFaq(tester);

    await tester.tap(find.byKey(BotFaqPage.tabKey('technical')));
    await tester.pumpAndSettle();
    expect(find.text('Technical (5)'), findsOneWidget);
    expect(find.text('How accurate is backtesting?'), findsOneWidget);

    await tester.enterText(find.byKey(BotFaqPage.searchKey), 'slippage');
    await tester.pumpAndSettle();
    expect(find.text('Technical (2)'), findsOneWidget);
    expect(
      find.text('What is slippage and how do I reduce it?'),
      findsOneWidget,
    );
  });

  testWidgets('SC-132 FAQ cards expand answer content', (tester) async {
    await pumpBotFaq(tester);

    await tester.tap(find.byKey(BotFaqPage.questionKey('general', 0)));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        'automated program that executes buy and sell orders',
      ),
      findsOneWidget,
    );
  });
}
