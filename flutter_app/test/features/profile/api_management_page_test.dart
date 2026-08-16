import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/api_key_create_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/api_management_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/profile_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpApiManagement(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.profileApi,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-163 mock repository exposes API management BE draft', () async {
    final snapshot = await const MockProfileRepository().getApiManagement();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-api');
    expect(
      snapshot.actionDraft,
      'read-only + local toggle, copy, secret reveal, delete, and create navigation actions',
    );
    expect(snapshot.keys.map((apiKey) => apiKey.id), ['key1', 'key2', 'key3']);
    expect(snapshot.keys.first.permissions, ['read', 'trade']);
    expect(snapshot.keys.first.ipWhitelist, ['192.168.1.100', '10.0.0.5']);
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

  testWidgets('SC-163 renders API management baseline shell', (tester) async {
    await pumpApiManagement(tester);

    expect(find.byType(ApiManagementPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_profile')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('Qu\u1EA3n l\u00FD API'), findsOneWidget);
    expect(find.text('API \u00B7 Profile'), findsOneWidget);
    expect(find.byKey(ApiManagementPage.createKey), findsOneWidget);
    expect(find.text('Trading Bot Alpha'), findsOneWidget);
    expect(find.text('Portfolio Tracker'), findsOneWidget);
    expect(find.text('Test Key (C\u0169)'), findsOneWidget);
    expect(find.text('T\u1EA1o l\u1EA1i Secret'), findsNWidgets(3));
    expect(find.text('T\u00E0i li\u1EC7u API'), findsOneWidget);
  });

  testWidgets('SC-163 first viewport reaches API key inventory', (
    tester,
  ) async {
    await pumpApiManagement(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ApiManagementPage',
      semanticLabel: 'Quản lý API',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ApiManagementPage.cardKey('key1')),
      minVisibleHeight: 24,
      targetLabel: 'first API key card',
      reason:
          'API management must preview active API credentials above bottom '
          'navigation after the high-risk access review.',
    );
  });

  testWidgets('SC-163 local actions and create edge work', (tester) async {
    await pumpApiManagement(tester);

    await tester.tap(find.byKey(ApiManagementPage.revealKey('key1')));
    await tester.pumpAndSettle();
    expect(find.text('sk_live_VI_DU_KHONG_THAT_bot_alpha_02'), findsOneWidget);

    await tester.tap(find.byKey(ApiManagementPage.toggleKey('key1')));
    await tester.pumpAndSettle();
    expect(find.byKey(ApiManagementPage.cardKey('key1')), findsOneWidget);

    await tester.tap(find.byKey(ApiManagementPage.createKey));
    await tester.pumpAndSettle();
    expect(find.byType(ApiKeyCreatePage), findsOneWidget);
    expect(find.text('T\u1EA1o API Key m\u1EDBi'), findsOneWidget);
  });

  testWidgets('SC-163 regenerate secret shows coming-soon snackbar', (
    tester,
  ) async {
    await pumpApiManagement(tester);

    await tester.tap(find.text('Tạo lại Secret').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Tạo lại Secret sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-163 API docs card shows coming-soon snackbar', (
    tester,
  ) async {
    await pumpApiManagement(tester);

    await tester.ensureVisible(find.text('Tài liệu API'));
    await tester.tap(find.text('Tài liệu API'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Tài liệu API sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-163 confirms before deleting an API key', (tester) async {
    await pumpApiManagement(tester);

    await tester.tap(find.byKey(ApiManagementPage.deleteKey('key1')));
    await tester.pumpAndSettle();

    expect(find.text('Xoá API Key?'), findsOneWidget);

    await tester.tap(find.text('Xoá'));
    await tester.pumpAndSettle();

    expect(find.text('Đã xoá API key'), findsOneWidget);
    expect(
      find.text('Key "Trading Bot Alpha" đã bị xoá và ngừng hoạt động.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();

    expect(find.text('Trading Bot Alpha'), findsNothing);
  });

  testWidgets('SC-163 direct header back returns to profile parent', (
    tester,
  ) async {
    await pumpApiManagement(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.byType(ApiManagementPage), findsNothing);
  });
}
