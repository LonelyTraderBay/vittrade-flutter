import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/active_copies_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/flow/copy_confirmation_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopyConfirmation(
    WidgetTester tester, {
    String providerId = 'provider001',
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.tradeCopyProviderConfirmation(
              providerId,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-073 mock repository exposes copy confirmation BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final notFound = await repo.getCopyConfirmation(providerId: 'provider001');
    final found = await repo.getCopyConfirmation(providerId: 'ct001');
    final blocked = await repo.submitCopyConfirmation(
      TradeCopyConfirmationRequest(
        providerId: 'ct001',
        configuration: found.configuration,
        acceptedConsentIds: const ['risk'],
      ),
    );
    final accepted = await repo.submitCopyConfirmation(
      TradeCopyConfirmationRequest(
        providerId: 'ct001',
        configuration: found.configuration,
        acceptedConsentIds: found.consentItems.map((item) => item.id).toList(),
      ),
    );

    expect(notFound.isNotFound, isTrue);
    expect(found.provider?.name, 'AlphaHunter_VN');
    expect(found.consentItems, hasLength(4));
    expect(found.scenarios, hasLength(3));
    expect(found.coolingOffHours, 24);
    expect(blocked.status, 'blocked');
    expect(accepted.status, 'pending_cooling_off');
    expect(accepted.activeCopiesPath, AppRoutePaths.tradeCopyActive);
    expect(
      found.supportedStates,
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
  });

  testWidgets('SC-073 renders blank state for missing provider001 baseline', (
    tester,
  ) async {
    await pumpCopyConfirmation(tester);

    expect(find.byType(CopyConfirmationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xác nhận Copy'), findsNothing);
    expect(find.text('Copy Confirmation'), findsNothing);
  });

  testWidgets('SC-073 valid provider requires all consent checks', (
    tester,
  ) async {
    await pumpCopyConfirmation(tester, providerId: 'ct001');

    expect(find.text('Xác nhận Copy'), findsOneWidget);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);
    expect(find.byKey(CopyConfirmationPage.suitabilityKey), findsOneWidget);
    expect(find.text('Suitability & limits review'), findsOneWidget);
    expect(find.text('Max 20% portfolio per provider'), findsOneWidget);
    expect(find.text('Xác nhận & Đồng ý'), findsOneWidget);

    final submit = tester.widget<VitCtaButton>(
      find.byKey(CopyConfirmationPage.submitKey),
    );
    expect(submit.onPressed, isNull);

    for (final id in const ['risk', 'fees', 'loss', 'terms']) {
      await tester.ensureVisible(
        find.byKey(CopyConfirmationPage.consentKey(id)),
      );
      await tester.tap(find.byKey(CopyConfirmationPage.consentKey(id)));
      await tester.pumpAndSettle();
    }

    final enabledSubmit = tester.widget<VitCtaButton>(
      find.byKey(CopyConfirmationPage.submitKey),
    );
    expect(enabledSubmit.onPressed, isNotNull);
  });

  testWidgets('SC-073 first viewport reaches suitability review', (
    tester,
  ) async {
    await pumpCopyConfirmation(tester, providerId: 'ct001');

    expectFirstViewportVisible(
      tester,
      find.byKey(CopyConfirmationPage.suitabilityKey),
      targetLabel: 'the suitability review section',
    );
  });

  testWidgets('SC-073 submit navigates to active copies', (tester) async {
    await pumpCopyConfirmation(tester, providerId: 'ct001');

    for (final id in const ['risk', 'fees', 'loss', 'terms']) {
      await tester.ensureVisible(
        find.byKey(CopyConfirmationPage.consentKey(id)),
      );
      await tester.tap(find.byKey(CopyConfirmationPage.consentKey(id)));
      await tester.pumpAndSettle();
    }
    await tester.ensureVisible(find.byKey(CopyConfirmationPage.submitKey));
    await tester.tap(find.byKey(CopyConfirmationPage.submitKey));
    await tester.pump(const Duration(milliseconds: 220));
    await tester.pumpAndSettle();

    expect(find.byType(ActiveCopiesPage), findsOneWidget);
    expect(find.byType(CopyConfirmationPage), findsNothing);
  });
}
