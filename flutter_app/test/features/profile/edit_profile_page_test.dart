import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/edit_profile_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/profile_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpEditProfile(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.profileEdit,
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(initialLocation: initialLocation),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-157 mock repository exposes edit profile BE draft', () async {
    final snapshot = await const MockProfileRepository().getEditProfile();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-edit');
    expect(snapshot.actionDraft, 'PATCH /user/settings');
    expect(snapshot.user.fullName, 'Nguy\u1EC5n V\u0103n A');
    expect(snapshot.user.email, 'nguyenvana@email.com');
    expect(snapshot.user.phone, '+84 912 345 678');
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

  testWidgets('SC-157 renders edit profile baseline shell', (tester) async {
    await pumpEditProfile(tester);

    expect(find.byType(EditProfilePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_profile')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('Ch\u1EC9nh s\u1EEDa h\u1ED3 s\u01A1'), findsOneWidget);
    expect(
      find.text('Ch\u1EC9nh s\u1EEDa \u00B7 T\u00E0i kho\u1EA3n'),
      findsOneWidget,
    );
    expect(find.text('H\u1ECC V\u00C0 T\u00CAN'), findsOneWidget);
    expect(find.text('EMAIL'), findsOneWidget);
    expect(find.text('S\u1ED0 \u0110I\u1EC6N THO\u1EA0I'), findsOneWidget);
    expect(find.text('Nguy\u1EC5n V\u0103n A'), findsOneWidget);
    expect(find.text('nguyenvana@email.com'), findsOneWidget);
    expect(find.text('+84 912 345 678'), findsOneWidget);
    expect(
      find.text('Email kh\u00F4ng th\u1EC3 thay \u0111\u1ED5i'),
      findsOneWidget,
    );
    expect(find.text('L\u01B0u thay \u0111\u1ED5i'), findsOneWidget);
  });

  testWidgets(
    'SC-157 Phone keeps edit identity, form, and action on VitCard surfaces',
    (tester) async {
      await pumpEditProfile(tester, viewport: const Size(360, 800));

      expect(find.byType(VitCard), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('SC-157 first viewport reaches save action', (tester) async {
    await pumpEditProfile(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'EditProfilePage',
      semanticLabel: 'Chỉnh sửa hồ sơ cá nhân',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(EditProfilePage.saveKey),
      minVisibleHeight: 24,
      targetLabel: 'save profile action',
      reason:
          'Edit profile must keep the primary save action visible above '
          'bottom navigation after the avatar and required profile fields.',
    );
  });

  testWidgets('SC-157 local edit, camera, save and back edges are safe', (
    tester,
  ) async {
    await pumpEditProfile(tester);

    await tester.tap(find.byKey(EditProfilePage.cameraKey));
    await tester.pump();
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    await tester.enterText(
      find.byKey(EditProfilePage.fullNameFieldKey),
      'Nguyen Van A',
    );
    await tester.enterText(
      find.byKey(EditProfilePage.phoneFieldKey),
      '+84 900 000 000',
    );
    await tester.tap(find.byKey(EditProfilePage.saveKey));
    await tester.pump();
    expect(find.text('\u0110ang l\u01B0u...'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(milliseconds: 420));
    expect(find.byType(ProfilePage), findsOneWidget);
  });
}
