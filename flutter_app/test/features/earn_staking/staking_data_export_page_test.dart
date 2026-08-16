import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_data_export_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDataExport(
    WidgetTester tester, {
    String initialLocation = AppRoutePaths.earnDataExport,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
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

  test('SC-394 mock repository exposes data export BE draft', () async {
    final snapshot = await const MockStakingDataExportRepository()
        .getDataExport();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-data-export');
    expect(snapshot.actionDraft, contains('POST /exports'));
    expect(snapshot.title, 'Data Export');
    expect(snapshot.backRoute, AppRoutePaths.earn);
    expect(snapshot.heroTitle, 'Export Your Data');
    expect(snapshot.quickExports, hasLength(4));
    expect(snapshot.quickExports.first.name, 'All Transactions');
    expect(
      snapshot.quickExports[1].description,
      'Daily rewards breakdown (CSV)',
    );
    expect(snapshot.formatOptions, ['CSV', 'JSON', 'PDF']);
    expect(snapshot.defaultFormat, 'CSV');
    expect(snapshot.footerNote, contains('available for download for 7 days'));
    expect(snapshot.contractNotes, contains('riskData'));
    expect(snapshot.contractNotes, contains('POST /exports'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EarnScreenState.loading,
        EarnScreenState.empty,
        EarnScreenState.error,
        EarnScreenState.offline,
        EarnScreenState.submitting,
        EarnScreenState.success,
      ]),
    );
  });

  testWidgets('SC-394 renders quick exports and custom export form', (
    tester,
  ) async {
    await pumpDataExport(tester);

    expect(find.byType(StakingDataExportPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Data Export'), findsOneWidget);
    expect(find.byKey(StakingDataExportPage.heroKey), findsOneWidget);
    expect(find.text('Export Your Data'), findsOneWidget);
    expect(find.textContaining('Download complete records'), findsOneWidget);
    expect(find.byKey(StakingDataExportPage.quickKey), findsOneWidget);
    expect(find.text('Quick Exports'), findsOneWidget);
    expect(
      find.byKey(StakingDataExportPage.quickExportKey('transactions')),
      findsOneWidget,
    );
    expect(find.text('All Transactions'), findsOneWidget);
    expect(find.text('Rewards Report'), findsOneWidget);
    expect(find.text('Tax Report'), findsOneWidget);
    expect(find.text('Portfolio Snapshot'), findsOneWidget);
    expect(find.byKey(StakingDataExportPage.customKey), findsOneWidget);
    expect(find.text('Custom Export'), findsOneWidget);
    expect(find.byKey(StakingDataExportPage.startDateKey), findsOneWidget);
    expect(find.byKey(StakingDataExportPage.endDateKey), findsOneWidget);
    expect(find.byKey(StakingDataExportPage.formatKey), findsOneWidget);
    expect(find.byKey(StakingDataExportPage.exportKey), findsOneWidget);
    expect(find.text('Export Custom Range'), findsOneWidget);
    expect(find.byKey(StakingDataExportPage.footerKey), findsOneWidget);
  });

  testWidgets('SC-394 first viewport reaches quick export action', (
    tester,
  ) async {
    await pumpDataExport(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-394 StakingDataExportPage',
      semanticLabel: 'Xuất dữ liệu stake và yield',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(StakingDataExportPage.quickExportKey('transactions')),
      routeName: 'SC-394 StakingDataExportPage',
      actionLabel: 'the first quick export card',
    );
  });

  testWidgets('SC-394 quick export selection and format state update', (
    tester,
  ) async {
    await pumpDataExport(tester);

    await tester.tap(find.byKey(StakingDataExportPage.quickExportKey('tax')));
    await tester.pumpAndSettle();

    final selectedCard = tester.widget<VitCard>(
      find.byKey(StakingDataExportPage.quickExportKey('tax')),
    );
    expect(selectedCard.borderColor, isNotNull);

    await tester.tap(find.byKey(StakingDataExportPage.formatKey));
    await tester.pumpAndSettle();

    expect(find.text('JSON'), findsOneWidget);
  });

  testWidgets('SC-394 header back returns to Earn', (tester) async {
    await pumpDataExport(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
  });

  testWidgets('SC-394 export custom range shows coming-soon snack bar', (
    tester,
  ) async {
    await pumpDataExport(tester);

    await tester.ensureVisible(find.byKey(StakingDataExportPage.exportKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(StakingDataExportPage.exportKey));
    await tester.pumpAndSettle();

    expect(find.text('Xuất dữ liệu sẽ sớm ra mắt'), findsOneWidget);
  });
}
