import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/sub_account_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpRoute(WidgetTester tester, String route) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: route),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-166 mock repository exposes sub-account BE draft', () async {
    final snapshot = await const MockProfileRepository().getSubAccounts();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-sub-accounts');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.accounts, hasLength(5));
    expect(snapshot.totalBalance, 63850.70);
    expect(snapshot.totalPnl30d, 13253.20);
    expect(snapshot.activeCount, 4);
    expect(snapshot.apiKeyCount, 7);
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

  testWidgets('SC-166 renders sub-accounts with Profile bottom nav active', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.profileSubAccounts);

    expect(find.byType(SubAccountPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('T\u00E0i kho\u1EA3n ph\u1EE5'), findsOneWidget);
    expect(find.byKey(SubAccountPage.summaryKey), findsOneWidget);
    expect(find.text('\$63,850.70'), findsOneWidget);
    expect(find.text('T\u00C0I KHO\u1EA2N (5)'), findsOneWidget);
    expect(find.byKey(SubAccountPage.accountCardKey('sub001')), findsOneWidget);
    expect(find.byKey(SubAccountPage.accountCardKey('sub005')), findsOneWidget);
    expect(find.text('Team Member - Linh'), findsOneWidget);
  });

  testWidgets('SC-166 first viewport reaches first account card', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.profileSubAccounts);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SubAccountPage',
      semanticLabel: 'Quản lý tài khoản phụ',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(SubAccountPage.accountCardKey('sub001')),
      minVisibleHeight: 24,
      targetLabel: 'first sub-account card',
      reason:
          'Sub-account management must preview real account content above '
          'the bottom navigation instead of spending the whole viewport on '
          'summary and risk chrome.',
    );
  });

  testWidgets('SC-166 supports balance masking, create form, and expansion', (
    tester,
  ) async {
    await pumpRoute(tester, AppRoutePaths.profileSubAccounts);

    await tester.tap(find.byKey(SubAccountPage.balanceToggleKey));
    await tester.pumpAndSettle();

    expect(find.text('\$63,850.70'), findsNothing);
    expect(find.text('\u2022\u2022\u2022\u2022\u2022\u2022'), findsOneWidget);

    await tester.tap(find.byKey(SubAccountPage.createButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(SubAccountPage.createFormKey), findsOneWidget);
    expect(find.text('T\u1EA1o t\u00E0i kho\u1EA3n ph\u1EE5'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(SubAccountPage.accountCardKey('sub001')),
    );
    await tester.tap(find.byKey(SubAccountPage.expandKey('sub001')));
    await tester.pumpAndSettle();

    expect(find.text('Volume 30d'), findsOneWidget);
    expect(
      find.textContaining('b***@vittrade.vn', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Chuy\u1EC3n ti\u1EC1n'), findsOneWidget);
  });

  testWidgets('SC-166 navigation edge from Profile is wired', (tester) async {
    await pumpRoute(tester, AppRoutePaths.profile);

    expect(find.byType(ProfilePage), findsOneWidget);
    await tester.ensureVisible(find.byKey(ProfilePage.menuKey('sub-accounts')));
    await tester.tap(find.byKey(ProfilePage.menuKey('sub-accounts')));
    await tester.pumpAndSettle();

    expect(find.byType(SubAccountPage), findsOneWidget);
    expect(find.text('Bot Trading #1'), findsOneWidget);
  });
}
