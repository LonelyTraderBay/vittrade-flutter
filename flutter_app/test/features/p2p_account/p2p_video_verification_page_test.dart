import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_kyc_status_page.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/merchant/p2p_video_verification_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpVideoVerification(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pKycVideo,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-252 mock repository exposes video verification BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getVideoVerification();

    expect(snapshot.endpoint, '/api/mobile/p2p/p2p-kyc-video');
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /kyc/submission-step',
    );
    expect(snapshot.preparationItems, hasLength(4));
    expect(snapshot.timeSlots, hasLength(4));
    expect(snapshot.timeSlots[2].available, isFalse);
    expect(snapshot.parentRoute, AppRoutePaths.p2pKycStatus);
    expect(snapshot.statusRoute, AppRoutePaths.p2pKycStatus);
    expect(snapshot.contractNotes, contains('P2P requires escrow'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
        P2PScreenState.submitting,
        P2PScreenState.success,
      ]),
    );
  });

  testWidgets('SC-252 renders video scheduling baseline', (tester) async {
    await pumpVideoVerification(tester);

    expect(find.byType(P2PVideoVerificationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Xác minh video'), findsOneWidget);
    expect(find.text('KYC · P2P'), findsOneWidget);
    expect(find.byKey(P2PVideoVerificationPage.heroKey), findsOneWidget);
    expect(find.text('Video KYC Call'), findsOneWidget);
    expect(find.byKey(P2PVideoVerificationPage.preparationKey), findsOneWidget);
    expect(find.text('Chuẩn bị'), findsOneWidget);
    expect(find.text('CMND/CCCD gốc'), findsOneWidget);
    expect(find.byKey(P2PVideoVerificationPage.slotsKey), findsOneWidget);
    expect(find.text('Chọn khung giờ'), findsOneWidget);
    expect(find.text('2026-03-06'), findsWidgets);
    expect(find.text('09:00 - 09:30'), findsOneWidget);
    expect(find.text('Hết chỗ'), findsOneWidget);
  });

  testWidgets('SC-252 selects an available slot and returns to status', (
    tester,
  ) async {
    await pumpVideoVerification(tester);

    await tester.tap(find.byKey(P2PVideoVerificationPage.slotKey('slot_0900')));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(P2PVideoVerificationPage.submitKey));
    await tester.tap(find.byKey(P2PVideoVerificationPage.submitKey));
    await tester.pumpAndSettle();

    expect(find.byType(P2PKycStatusPage), findsOneWidget);
  });

  testWidgets('SC-252 back returns to KYC status page', (tester) async {
    await pumpVideoVerification(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(P2PKycStatusPage), findsOneWidget);
  });
}
