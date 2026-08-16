import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/trade_copy/data/trade_copy_repository.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/hub/active_copies_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/flow/copy_confirmation_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/flow/copy_configuration_page.dart';
import 'package:vit_trade_flutter/features/trade_copy/presentation/phone/pages/provider/copy_provider_detail_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpCopyConfiguration(
    WidgetTester tester, {
    String providerId = 'provider001',
    String? initialLocation,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation:
                initialLocation ??
                AppRoutePaths.tradeCopyProviderConfiguration(providerId),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-072 mock repository exposes copy configuration BE draft', () async {
    final repo = const MockTradeCopyTradingRepository(loadDelay: Duration.zero);
    final notFound = await repo.getCopyConfiguration(providerId: 'provider001');
    final found = await repo.getCopyConfiguration(providerId: 'ct001');
    final preview = await repo.previewCopyConfiguration(found.defaultDraft);

    expect(notFound.isNotFound, isTrue);
    expect(found.provider?.name, 'AlphaHunter_VN');
    expect(found.defaultDraft.copyCapital, 5000);
    expect(found.defaultDraft.copyMode, TradeCopyConfigurationMode.fixed);
    expect(found.feePreview.totalFixedFees, greaterThan(0));
    expect(preview.status, 'ready');
    expect(preview.hasBlockingErrors, isFalse);
    expect(
      found.supportedStates,
      containsAll([
        TradeScreenState.loading,
        TradeScreenState.empty,
        TradeScreenState.error,
        TradeScreenState.offline,
        TradeScreenState.realtimeRefresh,
      ]),
    );
  });

  testWidgets('SC-072 renders blank state for missing provider001 baseline', (
    tester,
  ) async {
    await pumpCopyConfiguration(tester);

    expect(find.byType(CopyConfigurationPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Cấu hình Copy'), findsNothing);
    expect(find.text('Copy Configuration'), findsNothing);
  });

  testWidgets('SC-072 valid provider renders configuration controls', (
    tester,
  ) async {
    await pumpCopyConfiguration(tester, providerId: 'ct001');

    expect(find.text('Cấu hình Copy'), findsOneWidget);
    expect(find.text('AlphaHunter_VN'), findsOneWidget);
    expect(find.text('Vốn copy'), findsOneWidget);
    expect(find.text('Fixed Ratio'), findsWidgets);
    expect(find.text('Dự kiến chi phí'), findsOneWidget);
    expect(find.text('Copy fee preview'), findsOneWidget);
    expect(find.text('Risk check'), findsOneWidget);

    await tester.tap(
      find.byKey(
        CopyConfigurationPage.modeKey(TradeCopyConfigurationMode.smart),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Smart Copy'), findsWidgets);
  });

  testWidgets('SC-072 first viewport reaches capital field', (tester) async {
    await pumpCopyConfiguration(tester, providerId: 'ct001');

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-072 CopyConfigurationPage',
      semanticLabel: 'Cấu hình Copy',
    );
    expectFirstViewportVisible(
      tester,
      find.text('Số tiền copy (USD)'),
      targetLabel: 'the copy capital control',
      minVisibleHeight: 16,
    );
  });

  testWidgets('SC-072 confirmation CTA uses the SC-073 route edge', (
    tester,
  ) async {
    await pumpCopyConfiguration(tester, providerId: 'ct001');

    await tester.ensureVisible(find.byKey(CopyConfigurationPage.confirmKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(CopyConfigurationPage.confirmKey));
    await tester.pumpAndSettle();

    expect(find.byType(CopyConfigurationPage), findsNothing);
    expect(find.byType(CopyConfirmationPage), findsOneWidget);
    expect(find.text('Xác nhận Copy'), findsOneWidget);
  });
  testWidgets('SC-072 valid back query returns to encoded source route', (
    tester,
  ) async {
    await pumpCopyConfiguration(
      tester,
      providerId: 'ct001',
      initialLocation: AppRoutePaths.tradeCopyProviderConfiguration(
        'ct001',
        backPath: AppRoutePaths.tradeCopyActive,
      ),
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(ActiveCopiesPage), findsOneWidget);
    expect(find.byType(CopyConfigurationPage), findsNothing);
  });

  testWidgets('SC-072 invalid back query falls back to provider detail', (
    tester,
  ) async {
    await pumpCopyConfiguration(
      tester,
      providerId: 'ct001',
      initialLocation: AppRoutePaths.tradeCopyProviderConfiguration(
        'ct001',
        backPath: '/wallet',
      ),
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(CopyProviderDetailPage), findsOneWidget);
    expect(find.byType(CopyConfigurationPage), findsNothing);
  });
}
