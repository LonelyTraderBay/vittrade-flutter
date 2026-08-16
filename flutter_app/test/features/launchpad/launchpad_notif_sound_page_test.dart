import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_notif_sound_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpNotifSound(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadNotifSound,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-306 mock repository exposes notification sound BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getNotifSound();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-notif-sound');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Âm thanh thông báo');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.masterEnabled, isTrue);
    expect(snapshot.masterVolume, 80);
    expect(snapshot.vibrate, isTrue);
    expect(snapshot.doNotDisturb, isFalse);
    expect(snapshot.categories, hasLength(8));
    expect(snapshot.categories.first.id, 'price_alert');
    expect(snapshot.categories.first.soundType, 'chime');
    expect(snapshot.soundTypes.map((item) => item.value), [
      'default',
      'chime',
      'bell',
      'ping',
      'none',
    ]);
    expect(snapshot.contractNotes, contains('category sound settings'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-306 renders notification sound baseline', (tester) async {
    await pumpNotifSound(tester);

    expect(find.byType(LaunchpadNotifSoundPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Âm thanh thông báo'), findsOneWidget);
    expect(find.byKey(LaunchpadNotifSoundPage.heroKey), findsOneWidget);
    expect(find.byKey(LaunchpadNotifSoundPage.quickTogglesKey), findsOneWidget);
    expect(find.byKey(LaunchpadNotifSoundPage.categoriesKey), findsOneWidget);
    expect(
      find.byKey(LaunchpadNotifSoundPage.categoryKey('price_alert')),
      findsOneWidget,
    );
    expect(
      find.byKey(LaunchpadNotifSoundPage.categoryKey('system')),
      findsOneWidget,
    );
    expect(find.byKey(LaunchpadNotifSoundPage.footerKey), findsOneWidget);
    expect(find.byKey(LaunchpadNotifSoundPage.saveKey), findsOneWidget);
  });

  testWidgets('SC-306 first viewport reaches sound controls', (tester) async {
    await pumpNotifSound(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-306 LaunchpadNotifSoundPage',
      semanticLabel: 'Cài đặt âm thanh và thông báo Launchpad',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadNotifSoundPage.quickTogglesKey),
      routeName: 'SC-306 LaunchpadNotifSoundPage',
      actionLabel: 'the notification quick toggles',
    );
  });

  testWidgets('SC-306 expands category and previews sound state', (
    tester,
  ) async {
    await pumpNotifSound(tester);

    await tester.tap(
      find.byKey(LaunchpadNotifSoundPage.expandKey('price_alert')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(LaunchpadNotifSoundPage.soundTypeKey('price_alert', 'none')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(LaunchpadNotifSoundPage.soundTypeKey('price_alert', 'none')),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(LaunchpadNotifSoundPage.previewKey('price_alert')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Đang phát...'), findsOneWidget);
  });

  testWidgets('SC-306 saves after master toggle change', (tester) async {
    await pumpNotifSound(tester);

    await tester.tap(find.byKey(LaunchpadNotifSoundPage.toggleKey('master')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(LaunchpadNotifSoundPage.saveKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LaunchpadNotifSoundPage.saveKey));
    await tester.pumpAndSettle();

    expect(find.text('Đã lưu cài đặt'), findsOneWidget);
  });

  testWidgets('SC-306 header back returns to launchpad', (tester) async {
    await pumpNotifSound(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadNotifSoundPage), findsNothing);
    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
