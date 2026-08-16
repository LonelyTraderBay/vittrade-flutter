import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/api_key_create_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/api_management_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpApiCreate(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.profileApiCreate,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-162 mock repository exposes API key create BE draft', () async {
    final snapshot = await const MockProfileRepository().getApiKeyCreate();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-api-create');
    expect(
      snapshot.actionDraft,
      'POST /user/api-keys + local confirm/result steps',
    );
    expect(snapshot.permissions.map((permission) => permission.id), [
      'read',
      'trade',
      'withdraw',
    ]);
    expect(snapshot.expiryOptions.map((option) => option.id), [
      'none',
      '30d',
      '90d',
      '1y',
    ]);
    expect(snapshot.securityTips, hasLength(4));
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

  testWidgets('SC-162 renders API key create baseline shell', (tester) async {
    await pumpApiCreate(tester);

    expect(find.byType(ApiKeyCreatePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_profile')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('T\u1EA1o API Key m\u1EDBi'), findsOneWidget);
    expect(find.text('API \u00B7 Profile'), findsOneWidget);
    expect(
      find.text('VD: Trading Bot Alpha, Portfolio Tracker...'),
      findsOneWidget,
    );
    expect(find.text('\u0110\u1ECDc d\u1EEF li\u1EC7u'), findsOneWidget);
    expect(find.byKey(ApiKeyCreatePage.permissionKey('trade')), findsOneWidget);
    expect(find.text('R\u00FAt ti\u1EC1n'), findsOneWidget);
    expect(
      find.textContaining('IP Whitelist', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Kh\u00F4ng h\u1EBFt h\u1EA1n'), findsOneWidget);
    expect(find.text('M\u1EB9o b\u1EA3o m\u1EADt'), findsOneWidget);
    expect(find.text('Ti\u1EBFp t\u1EE5c'), findsOneWidget);
  });

  testWidgets('SC-162 first viewport keeps permission review visible', (
    tester,
  ) async {
    await pumpApiCreate(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ApiKeyCreatePage',
      semanticLabel: 'Tạo API Key mới',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ApiKeyCreatePage.permissionKey('withdraw')),
      minVisibleHeight: 24,
      targetLabel: 'withdraw permission review',
      reason:
          'API key creation must show high-risk permission scope inside the '
          'first viewport above the bottom navigation.',
    );
  });

  testWidgets('SC-162 local create flow returns to API management', (
    tester,
  ) async {
    await pumpApiCreate(tester);

    GestureDetector continueGesture() {
      return tester.widget<GestureDetector>(
        find.descendant(
          of: find.byKey(ApiKeyCreatePage.continueKey),
          matching: find.byType(GestureDetector),
        ),
      );
    }

    await tester.ensureVisible(find.byKey(ApiKeyCreatePage.continueKey));
    expect(continueGesture().onTap, isNull);
    await tester.pumpAndSettle();
    expect(find.text('T\u1EA1o API Key m\u1EDBi'), findsOneWidget);

    await tester.enterText(
      find.byKey(ApiKeyCreatePage.nameFieldKey),
      'Trading Bot Alpha',
    );
    await tester.pump();
    await tester.ensureVisible(find.byKey(ApiKeyCreatePage.continueKey));
    continueGesture().onTap!();
    await tester.pumpAndSettle();

    expect(find.text('X\u00E1c nh\u1EADn t\u1EA1o API Key'), findsWidgets);
    expect(find.text('Trading Bot Alpha'), findsOneWidget);
    expect(find.text('Kh\u00F4ng h\u1EBFt h\u1EA1n'), findsOneWidget);

    await tester.tap(find.text('T\u1EA1o API Key'));
    await tester.pumpAndSettle();
    expect(find.text('API Key \u0111\u00E3 t\u1EA1o'), findsOneWidget);
    expect(find.text('T\u1EA1o th\u00E0nh c\u00F4ng!'), findsOneWidget);

    await tester.tap(find.text('\u0110\u00E3 l\u01B0u, quay l\u1EA1i'));
    await tester.pumpAndSettle();
    expect(find.text('Qu\u1EA3n l\u00FD API'), findsOneWidget);
  });

  testWidgets('SC-162 direct header back returns to API management parent', (
    tester,
  ) async {
    await pumpApiCreate(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ApiManagementPage), findsOneWidget);
    expect(find.byType(ApiKeyCreatePage), findsNothing);
  });
}
