import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/p2p_core/data/p2p_repository.dart';
import 'package:vit_trade_flutter/features/p2p_account/presentation/phone/pages/payment/p2p_payment_method_cooling_period_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpP2PPaymentMethodCoolingPeriod(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.p2pPaymentMethodCoolingPeriod,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-235 mock repository exposes cooling period BE draft', () async {
    final snapshot = await const MockP2PRepository(
      loadDelay: Duration.zero,
    ).getPaymentMethodCoolingPeriod();

    expect(
      snapshot.endpoint,
      '/api/mobile/p2p/p2p-payment-method-cooling-period',
    );
    expect(
      snapshot.actionDraft,
      'POST /p2p/* workflow action where applicable; POST /p2p/payment-methods',
    );
    expect(snapshot.addedAt, '2026-03-05 10:00');
    expect(snapshot.availableAt, '2026-03-12 10:00');
    expect(snapshot.hoursRemaining, 168);
    expect(snapshot.reasons, hasLength(4));
    expect(snapshot.contractNotes, contains('Hành động rủi ro cao'));
    expect(
      snapshot.supportedStates,
      containsAll([
        P2PScreenState.loading,
        P2PScreenState.empty,
        P2PScreenState.error,
        P2PScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-235 renders cooling period baseline', (tester) async {
    await pumpP2PPaymentMethodCoolingPeriod(tester);

    expect(find.byType(P2PPaymentMethodCoolingPeriodPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Thời gian chờ'), findsOneWidget);
    expect(find.text('Thanh toán · P2P'), findsOneWidget);
    expect(find.text('Đang trong thời gian chờ'), findsOneWidget);
    expect(
      find.text('Phương thức thanh toán mới cần chờ 7 ngày'),
      findsOneWidget,
    );
    expect(find.text('7d 0h'), findsOneWidget);
    expect(find.text('Còn lại'), findsOneWidget);
    expect(find.text('Thêm lúc'), findsOneWidget);
    expect(find.text('2026-03-05 10:00'), findsOneWidget);
    expect(find.text('Sẵn sàng lúc'), findsOneWidget);
    expect(find.text('2026-03-12 10:00'), findsOneWidget);
    expect(find.text('Tại sao có thời gian chờ?'), findsOneWidget);
    expect(find.text('Bảo vệ khỏi gian lận và lừa đảo'), findsOneWidget);
    expect(find.text('Trong thời gian chờ'), findsOneWidget);
  });

  testWidgets('SC-235 header back returns to payment methods list', (
    tester,
  ) async {
    await pumpP2PPaymentMethodCoolingPeriod(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Phương thức thanh toán'), findsOneWidget);
  });
}
