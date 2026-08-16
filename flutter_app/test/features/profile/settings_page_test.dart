import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/core/storage/key_value_store.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/settings_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_choice_pill.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_toggle_pill.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSettings(WidgetTester tester, {KeyValueStore? store}) async {
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
            initialLocation: AppRoutePaths.profileSettings,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-160 mock repository exposes profile settings BE draft', () async {
    final snapshot = await const MockProfileRepository().getSettings();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-settings');
    expect(snapshot.actionDraft, 'PATCH /user/settings or module settings');
    expect(snapshot.currencyOptions, ['USD', 'VND', 'EUR', 'BTC']);
    expect(snapshot.selectedCurrency, 'USD');
    expect(snapshot.languages.map((language) => language.id), ['vi', 'en']);
    expect(snapshot.tradeSecurity.map((item) => item.id), [
      'biometric',
      'order-confirm',
      'withdraw-limit',
    ]);
    expect(snapshot.notifications.map((item) => item.id), [
      'trade',
      'price',
      'security',
      'p2p',
      'arena',
      'news',
    ]);
    expect(snapshot.appInfo.last.value, '21/02/2026');
    expect(
      snapshot.supportedStates,
      containsAll([
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
        ProfileScreenState.submitting,
        ProfileScreenState.success,
      ]),
    );
  });

  testWidgets('SC-160 renders settings baseline shell', (tester) async {
    await pumpSettings(tester);

    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_profile')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('C\u00E0i \u0111\u1EB7t'), findsOneWidget);
    expect(find.text('C\u00E0i \u0111\u1EB7t \u00B7 Profile'), findsOneWidget);
    expect(find.text('GIAO DI\u1EC6N'), findsOneWidget);
    expect(
      find.text('\u0110\u01A1n v\u1ECB ti\u1EC1n t\u1EC7 hi\u1EC3n th\u1ECB'),
      findsOneWidget,
    );
    expect(find.text('USD'), findsOneWidget);
    expect(find.text('Ti\u1EBFng Vi\u1EC7t'), findsOneWidget);
    expect(
      find.text('\u0110\u0103ng nh\u1EADp sinh tr\u1EAFc h\u1ECDc'),
      findsOneWidget,
    );
    expect(find.text('X\u00E1c nh\u1EADn l\u1EC7nh'), findsOneWidget);
    expect(find.text('L\u1EC7nh giao d\u1ECBch'), findsOneWidget);
    expect(find.text('Open Arena'), findsOneWidget);
    expect(find.text('Tin t\u1EE9c & Khuy\u1EBFn m\u1EA1i'), findsOneWidget);
    expect(find.text('TH\u00D4NG TIN \u1EE8NG D\u1EE4NG'), findsOneWidget);
    expect(find.text('2.4.1 (Build 241)'), findsOneWidget);
  });

  testWidgets('SC-160 first viewport reaches trade security toggle', (
    tester,
  ) async {
    await pumpSettings(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SettingsPage',
      semanticLabel: 'Cài đặt tài khoản',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(SettingsPage.toggleKey('biometric')),
      minVisibleHeight: 20,
      targetLabel: 'biometric trade security toggle',
      reason:
          'Settings must preview actionable security preferences above the '
          'bottom navigation, not only localization controls.',
    );
  });

  testWidgets('SC-160 settings interactions stay local', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.byKey(SettingsPage.currencyKey('VND')));
    await tester.tap(find.byKey(SettingsPage.languageKey('en')));
    await tester.tap(find.byKey(SettingsPage.toggleKey('biometric')));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);

    final vndChip = tester.widget<VitChoicePill>(
      find.byKey(SettingsPage.currencyKey('VND')),
    );
    expect(vndChip.selected, isTrue);

    final biometricTrack = tester.widget<VitTogglePill>(
      find.descendant(
        of: find.byKey(SettingsPage.toggleKey('biometric')),
        matching: find.byType(VitTogglePill),
      ),
    );
    expect(biometricTrack.enabled, isTrue);
    expect(biometricTrack.activeColor, AppColors.buy);
  });

  testWidgets('SC-160 GĐ4-F1 khôi phục lựa chọn đã lưu từ store', (
    tester,
  ) async {
    final store = InMemoryKeyValueStore(
      seed: {
        KeyValueStoreKeys.settingsCurrency: 'VND',
        KeyValueStoreKeys.settingsLanguage: 'en',
        '${KeyValueStoreKeys.settingsTogglePrefix}biometric': true,
      },
    );
    await pumpSettings(tester, store: store);

    final vndChip = tester.widget<VitChoicePill>(
      find.byKey(SettingsPage.currencyKey('VND')),
    );
    expect(vndChip.selected, isTrue);

    final biometricTrack = tester.widget<VitTogglePill>(
      find.descendant(
        of: find.byKey(SettingsPage.toggleKey('biometric')),
        matching: find.byType(VitTogglePill),
      ),
    );
    expect(biometricTrack.enabled, isTrue);
  });

  testWidgets('SC-160 GĐ4-F1 đổi toggle ghi lại vào store', (tester) async {
    final store = InMemoryKeyValueStore();
    await pumpSettings(tester, store: store);

    expect(
      store.getBool('${KeyValueStoreKeys.settingsTogglePrefix}biometric'),
      isNull,
    );

    await tester.tap(find.byKey(SettingsPage.toggleKey('biometric')));
    await tester.tap(find.byKey(SettingsPage.currencyKey('VND')));
    await tester.tap(find.byKey(SettingsPage.languageKey('en')));
    await tester.pumpAndSettle();

    expect(
      store.getBool('${KeyValueStoreKeys.settingsTogglePrefix}biometric'),
      isTrue,
    );
    expect(store.getString(KeyValueStoreKeys.settingsCurrency), 'VND');
    expect(store.getString(KeyValueStoreKeys.settingsLanguage), 'en');
  });
}
