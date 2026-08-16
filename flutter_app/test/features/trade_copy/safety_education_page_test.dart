import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/safety/safety_education_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSafetyEducation(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopySafety,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-080 mock repository exposes safety education BE draft', () async {
    final snapshot = await const MockTradeCopyTradingRepository(
      loadDelay: Duration.zero,
    ).getSafetyEducation();

    expect(snapshot.defaultTabId, 'scams');
    expect(snapshot.tabs.map((tab) => tab.id), [
      'scams',
      'redflags',
      'verification',
      'report',
    ]);
    expect(snapshot.scams, hasLength(5));
    expect(snapshot.redFlags, hasLength(8));
    expect(snapshot.verificationTiers.map((tier) => tier.tier), [
      'Pro',
      'Verified',
      'Basic',
    ]);
    expect(snapshot.reportReasons, hasLength(5));
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

  testWidgets('SC-080 renders scams guide inside the Trade shell', (
    tester,
  ) async {
    await pumpSafetyEducation(tester);

    expect(find.byType(SafetyEducationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('An toàn & Bảo mật'), findsOneWidget);
    expect(find.text('Bảo vệ bản thân khỏi scams'), findsOneWidget);
    expect(find.text('Scams phổ biến'), findsOneWidget);
    expect(
      find.text(
        '5 loại scam phổ biến trong copy trading. Tap để xem chi tiết.',
      ),
      findsOneWidget,
    );
    expect(find.text('Hứa hẹn lợi nhuận đảm bảo'), findsOneWidget);
    expect(find.text('Giả mạo hiệu suất'), findsOneWidget);
    expect(find.text('Exit Scam'), findsOneWidget);
  });

  testWidgets('SC-080 first viewport reaches first scam card', (tester) async {
    await pumpSafetyEducation(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SafetyEducationPage',
      semanticLabel: 'An toàn & Bảo mật',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(SafetyEducationPage.scamKey('guaranteed-returns')),
      minVisibleHeight: 24,
      targetLabel: 'first scam education card',
      reason:
          'Safety education must show the first scam card above bottom '
          'navigation after the safety review and tabs.',
    );
  });

  testWidgets('SC-080 scam cards expand locally', (tester) async {
    await pumpSafetyEducation(tester);

    await tester.tap(
      find.byKey(SafetyEducationPage.scamKey('guaranteed-returns')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ví dụ:'), findsOneWidget);
    expect(find.textContaining('"Copy tôi = lời chắc chắn"'), findsOneWidget);
    expect(
      find.textContaining('KHÔNG CÓ lợi nhuận đảm bảo trong trading'),
      findsOneWidget,
    );
  });

  testWidgets('SC-080 tabs switch to verification content', (tester) async {
    await pumpSafetyEducation(tester);

    await tester.tap(find.byKey(SafetyEducationPage.tabKey('verification')));
    await tester.pumpAndSettle();

    expect(find.text('Verification Tiers'), findsOneWidget);
    expect(find.text('Pro'), findsOneWidget);
    expect(find.text('Basic'), findsOneWidget);
  });

  testWidgets('SC-080 back returns to copy trading', (tester) async {
    await pumpSafetyEducation(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
  });
}
