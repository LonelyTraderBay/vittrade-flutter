import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/activity_log_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpActivity(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.profileActivity,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-161 mock repository exposes activity BE draft', () async {
    final snapshot = await const MockProfileRepository().getActivity();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-activity');
    expect(snapshot.actionDraft, 'read-only + local filter actions');
    expect(snapshot.filters.map((filter) => filter.id), [
      'all',
      'login',
      'security',
    ]);
    expect(snapshot.logs, hasLength(7));
    expect(snapshot.logs.first.id, 'act001');
    expect(
      snapshot.logs.first.location,
      'H\u1ED3 Ch\u00ED Minh, Vi\u1EC7t Nam',
    );
    expect(
      snapshot.logs.where((log) => log.status == 'suspicious'),
      hasLength(1),
    );
    expect(
      snapshot.supportedStates,
      containsAll([
        ProfileScreenState.loading,
        ProfileScreenState.empty,
        ProfileScreenState.error,
        ProfileScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-161 renders activity baseline shell', (tester) async {
    await pumpActivity(tester);

    expect(find.byType(ActivityLogPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_profile')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(
      find.text('Nh\u1EADt k\u00FD ho\u1EA1t \u0111\u1ED9ng'),
      findsOneWidget,
    );
    expect(
      find.text('Ho\u1EA1t \u0111\u1ED9ng \u00B7 Profile'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Ph\u00E1t hi\u1EC7n 1 ho\u1EA1t \u0111\u1ED9ng \u0111\u00E1ng ng\u1EDD',
      ),
      findsOneWidget,
    );
    expect(find.text('T\u1EA5t c\u1EA3'), findsOneWidget);
    expect(find.text('\u0110\u0103ng nh\u1EADp'), findsWidgets);
    expect(find.text('B\u1EA3o m\u1EADt'), findsOneWidget);
    expect(find.byKey(ActivityLogPage.logKey('act001')), findsOneWidget);
    expect(find.byKey(ActivityLogPage.logKey('act006')), findsOneWidget);
    expect(find.text('113.161.88.123'), findsWidgets);
  });

  testWidgets('SC-161 first viewport reaches first activity log', (
    tester,
  ) async {
    await pumpActivity(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'ActivityLogPage',
      semanticLabel: 'Nhật ký hoạt động tài khoản',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ActivityLogPage.logKey('act001')),
      minVisibleHeight: 24,
      targetLabel: 'first activity log',
      reason:
          'Activity history must preview actual security/account events above '
          'the bottom navigation after the filter and warning summary.',
    );
  });

  testWidgets('SC-161 filters activity locally', (tester) async {
    await pumpActivity(tester);

    await tester.tap(find.byKey(ActivityLogPage.filterKey('security')));
    await tester.pumpAndSettle();
    expect(find.byKey(ActivityLogPage.logKey('act003')), findsOneWidget);
    expect(find.byKey(ActivityLogPage.logKey('act005')), findsOneWidget);
    expect(find.byKey(ActivityLogPage.logKey('act007')), findsOneWidget);
    expect(find.byKey(ActivityLogPage.logKey('act001')), findsNothing);

    await tester.tap(find.byKey(ActivityLogPage.filterKey('login')));
    await tester.pumpAndSettle();
    expect(find.byKey(ActivityLogPage.logKey('act001')), findsOneWidget);
    expect(find.byKey(ActivityLogPage.logKey('act006')), findsOneWidget);
    expect(find.byKey(ActivityLogPage.logKey('act003')), findsNothing);
  });
}
