import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_bots/data/trade_bots_repository.dart';
import 'package:vit_trade_flutter/features/trade_bots/presentation/phone/pages/settings/bot_terms_of_service_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpTerms(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeBotTermsOfService,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-117 mock repository exposes bot terms BE draft', () async {
    final snapshot = await const MockTradeBotsRepository(
      loadDelay: Duration.zero,
    ).getBotTermsOfService();

    expect(snapshot.infoTitle, 'Yêu cầu đồng ý điều khoản');
    expect(snapshot.title, 'Điều khoản dịch vụ Bot giao dịch');
    expect(snapshot.sections.first.title, '1. Chấp nhận điều khoản');
    expect(snapshot.sections[1].warningTitle, 'CẢNH BÁO QUAN TRỌNG:');
    expect(snapshot.disabledCta, 'Đọc điều khoản để tiếp tục');
    expect(snapshot.enabledCta, 'Chấp nhận & Tiếp tục');
    expect(snapshot.endpoint, '/api/mobile/trade/trade-bots-terms-of-service');
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

  testWidgets('SC-117 renders bot terms baseline in Trade shell', (
    tester,
  ) async {
    await pumpTerms(tester);

    expect(find.byType(BotTermsOfServicePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Điều khoản Bot giao dịch'), findsOneWidget);
    expect(find.text('Yêu cầu đồng ý điều khoản'), findsOneWidget);
    expect(find.text('Điều khoản dịch vụ Bot giao dịch'), findsOneWidget);
    expect(find.text('1. Chấp nhận điều khoản'), findsOneWidget);
    expect(find.text('2. Không đảm bảo lợi nhuận'), findsOneWidget);
    expect(find.text('Chấp nhận điều khoản'), findsOneWidget);
    expect(find.text('Đọc điều khoản để tiếp tục'), findsOneWidget);
  });

  testWidgets('SC-117 first viewport previews agreement card', (tester) async {
    await pumpTerms(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'BotTermsOfServicePage',
      semanticLabel: 'Điều khoản dịch vụ bot giao dịch',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(BotTermsOfServicePage.agreementKey),
      minVisibleHeight: 24,
      targetLabel: 'terms agreement card',
      reason:
          'Bot terms must preview the agreement step above bottom navigation '
          'while still requiring the inner terms scroll to be read before '
          'enabling the CTA.',
    );
  });

  testWidgets('SC-117 agreement stays disabled until terms are read', (
    tester,
  ) async {
    await pumpTerms(tester);

    await tester.ensureVisible(find.byKey(BotTermsOfServicePage.agreementKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(BotTermsOfServicePage.agreementKey));
    await tester.pumpAndSettle();

    expect(find.text('Đọc điều khoản để tiếp tục'), findsOneWidget);
    expect(find.text('Chấp nhận & Tiếp tục'), findsNothing);
  });
}
