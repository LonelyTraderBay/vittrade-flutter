import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/profile/data/profile_repository.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/kyc_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/profile_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpKyc(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.profileKyc,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-159 mock repository exposes KYC BE draft', () async {
    final snapshot = await const MockProfileRepository().getKyc();

    expect(snapshot.endpoint, '/api/mobile/profile/profile-kyc');
    expect(snapshot.actionDraft, 'POST /kyc/submission-step');
    expect(snapshot.currentLevel, 2);
    expect(snapshot.statusTitle, 'KYC Cấp 2 — Đã xác minh');
    expect(snapshot.levels.map((level) => level.title), [
      'Cơ bản',
      'KYC Cấp 1',
      'KYC Cấp 2',
    ]);
    expect(snapshot.levels.last.limits.last, 'Rút: \$100,000/ngày');
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

  testWidgets('SC-159 renders KYC baseline shell', (tester) async {
    await pumpKyc(tester);

    expect(find.byType(KYCPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_profile')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_profile')),
      findsOneWidget,
    );
    expect(find.text('Xác minh danh tính'), findsOneWidget);
    expect(find.text('KYC · Profile'), findsOneWidget);
    expect(find.text('KYC Cấp 2 — Đã xác minh'), findsOneWidget);
    expect(
      find.text('Tài khoản của bạn đã được xác minh đầy đủ'),
      findsOneWidget,
    );
    expect(find.text('Cơ bản'), findsOneWidget);
    expect(find.text('KYC Cấp 1'), findsOneWidget);
    expect(find.text('KYC Cấp 2'), findsWidgets);
    expect(find.text('Đã hoàn thành'), findsNWidgets(3));
    expect(find.text('Bảo mật thông tin cá nhân'), findsOneWidget);
  });

  testWidgets('SC-159 first viewport reaches first KYC level', (tester) async {
    await pumpKyc(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'KYCPage',
      semanticLabel: 'Xác minh danh tính',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(KYCPage.levelKey(1)),
      minVisibleHeight: 24,
      targetLabel: 'first KYC level card',
      reason:
          'KYC must expose the actual verification level list above the bottom '
          'navigation after the status and risk review.',
    );
  });

  testWidgets('SC-159 expands KYC level details locally', (tester) async {
    await pumpKyc(tester);

    await tester.tap(find.byKey(KYCPage.levelKey(2)));
    await tester.pumpAndSettle();

    expect(find.text('Giới hạn giao dịch:'), findsOneWidget);
    expect(find.text('Rút: \$100,000/ngày'), findsOneWidget);
    expect(find.text('Tính năng mở khóa:'), findsOneWidget);
    expect(find.text('OTC Trading'), findsOneWidget);
    expect(find.text('API Access'), findsOneWidget);
  });
  testWidgets('SC-159 direct header back returns to profile parent', (
    tester,
  ) async {
    await pumpKyc(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.byType(KYCPage), findsNothing);
  });
}
