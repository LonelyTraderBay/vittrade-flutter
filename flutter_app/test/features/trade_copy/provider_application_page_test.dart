import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/copy_trading_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/provider/provider_application_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpProviderApplication(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyProviderApply,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-069 mock repository exposes provider application BE draft',
    () async {
      final repo = const MockTradeCopyTradingRepository(
        loadDelay: Duration.zero,
      );
      final snapshot = await repo.getProviderApplication();
      final result = await repo.submitProviderApplication(
        snapshot.defaultDraft,
      );

      expect(snapshot.steps, hasLength(5));
      expect(snapshot.defaultStep, TradeProviderApplicationStep.intro);
      expect(snapshot.benefits, hasLength(3));
      expect(snapshot.requirements.first.label, 'KYC Level 2');
      expect(snapshot.defaultDraft.minCapital, 10000);
      expect(result.status, 'submitted');
      expect(
        snapshot.supportedStates,
        containsAll([
          TradeScreenState.loading,
          TradeScreenState.empty,
          TradeScreenState.error,
          TradeScreenState.offline,
          TradeScreenState.submitting,
          TradeScreenState.success,
          TradeScreenState.realtimeRefresh,
        ]),
      );
    },
  );

  testWidgets('SC-069 renders ProviderApplicationPage inside the Trade shell', (
    tester,
  ) async {
    await pumpProviderApplication(tester);

    expect(find.byType(ProviderApplicationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.text('Đăng ký Provider'), findsOneWidget);
    expect(find.text('Trở thành Copy Trading Provider'), findsOneWidget);
    expect(find.text('Performance Fee'), findsOneWidget);
    expect(find.text('Trách nhiệm quan trọng'), findsOneWidget);
    expect(find.byKey(ProviderApplicationPage.nextKey), findsOneWidget);
  });

  testWidgets('SC-069 first viewport reaches wizard action', (tester) async {
    await pumpProviderApplication(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-069 ProviderApplicationPage',
      semanticLabel: 'Đăng ký Provider',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ProviderApplicationPage.nextKey),
      routeName: 'SC-069 ProviderApplicationPage',
      actionLabel: 'the provider application next action',
    );
  });

  testWidgets('SC-069 wizard gates requirements before disclosure', (
    tester,
  ) async {
    await pumpProviderApplication(tester);

    await tester.tap(find.byKey(ProviderApplicationPage.nextKey));
    await tester.pumpAndSettle();

    expect(find.text('Kiểm tra điều kiện'), findsOneWidget);

    await tester.tap(find.byKey(ProviderApplicationPage.kycKey));
    await tester.enterText(
      find.byKey(ProviderApplicationPage.monthsFieldKey),
      '6',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ProviderApplicationPage.nextKey));
    await tester.pumpAndSettle();

    expect(find.text('Nghĩa vụ công khai'), findsOneWidget);
  });

  testWidgets(
    'SC-069 completing the wizard submits and shows acknowledgement',
    (tester) async {
      await pumpProviderApplication(tester);

      await tester.tap(find.byKey(ProviderApplicationPage.nextKey));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ProviderApplicationPage.kycKey));
      await tester.enterText(
        find.byKey(ProviderApplicationPage.monthsFieldKey),
        '6',
      );
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ProviderApplicationPage.nextKey));
      await tester.pumpAndSettle();

      expect(find.text('Nghĩa vụ công khai'), findsOneWidget);
      await tester.ensureVisible(
        find.byKey(ProviderApplicationPage.disclosureKey),
      );
      await tester.tap(find.byKey(ProviderApplicationPage.disclosureKey));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(ProviderApplicationPage.fiduciaryKey),
      );
      await tester.tap(find.byKey(ProviderApplicationPage.fiduciaryKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ProviderApplicationPage.nextKey));
      await tester.pumpAndSettle();

      expect(find.text('Cấu trúc phí'), findsOneWidget);
      await tester.ensureVisible(
        find.byKey(ProviderApplicationPage.strategyFieldKey),
      );
      await tester.enterText(
        find.byKey(ProviderApplicationPage.strategyFieldKey),
        List.filled(100, 'x').join(),
      );
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ProviderApplicationPage.nextKey));
      await tester.pumpAndSettle();

      expect(find.text('Xem lại đơn đăng ký'), findsOneWidget);
      await tester.ensureVisible(find.byKey(ProviderApplicationPage.termsKey));
      await tester.tap(find.byKey(ProviderApplicationPage.termsKey));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(ProviderApplicationPage.submitKey));
      await tester.pumpAndSettle();

      expect(find.text('Đã gửi đơn đăng ký'), findsOneWidget);
      expect(
        find.text(
          'Mã đơn CPA-069-DEMO. Thời gian xét duyệt: 2-3 ngày làm việc.',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();

      expect(find.byType(CopyTradingPage), findsOneWidget);
      expect(find.byType(ProviderApplicationPage), findsNothing);
    },
  );

  testWidgets('SC-069 back returns to SC-063 CopyTradingPage', (tester) async {
    await pumpProviderApplication(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyTradingPage), findsOneWidget);
    expect(find.byType(ProviderApplicationPage), findsNothing);
  });
}
