import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/onboarding/data/onboarding_repository.dart';
import 'package:vit_trade_flutter/features/onboarding/presentation/phone/pages/onboarding_flow_page.dart';
import 'package:vit_trade_flutter/features/trade/presentation/phone/pages/trade_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpOnboarding(
    WidgetTester tester, {
    KeyValueStore? store,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (store != null) keyValueStoreProvider.overrideWithValue(store),
        ],
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.onboarding,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-397 mock repository exposes onboarding BE draft', () async {
    final snapshot = await const MockOnboardingRepository().getFlow();

    expect(snapshot.endpoint, '/api/mobile/onboarding/onboarding');
    expect(snapshot.actionDraft, contains('local navigation actions'));
    expect(snapshot.contractNotes, contains('Match screenshot first'));
    expect(snapshot.steps, hasLength(6));
    expect(snapshot.welcome.title, 'Chào mừng đến với\nTrading App');
    expect(snapshot.welcome.features, hasLength(3));
    expect(snapshot.modules, hasLength(5));
    expect(snapshot.boundaries.last.title, 'Open Arena');
    expect(snapshot.goals, hasLength(6));
    expect(
      snapshot.supportedStates,
      containsAll([
        OnboardingScreenState.loading,
        OnboardingScreenState.empty,
        OnboardingScreenState.error,
        OnboardingScreenState.offline,
        OnboardingScreenState.ready,
      ]),
    );
    expect(snapshot.screenState, OnboardingScreenState.ready);
  });

  testWidgets('SC-397 renders welcome baseline as standalone onboarding', (
    tester,
  ) async {
    await pumpOnboarding(tester);

    expect(find.byType(OnboardingFlowPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsNothing);
    expect(find.byKey(OnboardingFlowPage.welcomeKey), findsOneWidget);
    expect(find.text('Bỏ qua'), findsOneWidget);
    expect(find.text('Chào mừng đến với\nTrading App'), findsOneWidget);
    expect(find.text('Giao dịch đa dạng'), findsOneWidget);
    expect(find.text('An toàn & Minh bạch'), findsOneWidget);
    expect(find.text('Tính năng thông minh'), findsOneWidget);
    expect(find.byKey(OnboardingFlowPage.startButtonKey), findsOneWidget);
  });

  testWidgets('SC-397 advances module carousel state', (tester) async {
    await pumpOnboarding(tester);

    await tester.tap(find.byKey(OnboardingFlowPage.startButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(OnboardingFlowPage.modulesKey), findsOneWidget);
    expect(find.text('Khám phá 5 modules'), findsOneWidget);
    expect(find.text('Trading'), findsOneWidget);

    await tester.tap(find.byKey(OnboardingFlowPage.nextButtonKey));
    await tester.pumpAndSettle();

    expect(find.text('Wallet'), findsOneWidget);
    expect(find.text('Quản lý tài sản'), findsOneWidget);
  });

  testWidgets('SC-397 skip navigates to Home', (tester) async {
    await pumpOnboarding(tester);

    await tester.tap(find.byKey(OnboardingFlowPage.skipButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
  });

  testWidgets('SC-397 GĐ4-F1 skip persists onboarding-seen flag', (
    tester,
  ) async {
    final store = InMemoryKeyValueStore();
    await pumpOnboarding(tester, store: store);

    expect(store.getBool(KeyValueStoreKeys.onboardingSeen), isNull);
    await tester.tap(find.byKey(OnboardingFlowPage.skipButtonKey));
    await tester.pumpAndSettle();

    expect(store.getBool(KeyValueStoreKeys.onboardingSeen), isTrue);
  });

  testWidgets('SC-397 selected trade goal navigates to trade pair route', (
    tester,
  ) async {
    await pumpOnboarding(tester);

    await tester.tap(find.byKey(OnboardingFlowPage.startButtonKey));
    await tester.pumpAndSettle();

    for (var i = 0; i < 5; i++) {
      await tester.tap(find.byKey(OnboardingFlowPage.nextButtonKey));
      await tester.pumpAndSettle();
    }

    expect(find.byKey(OnboardingFlowPage.boundariesKey), findsOneWidget);
    await tester.tap(find.byKey(OnboardingFlowPage.nextButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(OnboardingFlowPage.trustKey), findsOneWidget);
    await tester.tap(find.byKey(OnboardingFlowPage.nextButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(OnboardingFlowPage.goalsKey), findsOneWidget);
    await tester.tap(
      find.byKey(
        OnboardingFlowPage.goalKey(OnboardingUserGoalDraft.tradeCrypto),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(OnboardingFlowPage.nextButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(OnboardingFlowPage.completeKey), findsOneWidget);
    await tester.tap(find.byKey(OnboardingFlowPage.nextButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(TradePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
  });
}
