import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_event_log_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpEventLog(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadEventLog,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-307 mock repository exposes event log BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getEventLog();

    expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-event-log');
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Event Log');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.events, hasLength(12));
    expect(snapshot.events.first.message, 'Bridge transaction initiated');
    expect(snapshot.events.first.tags, ['bridge', 'initiate']);
    expect(snapshot.exportFormats.map((format) => format.value), [
      'text',
      'json',
      'csv',
    ]);
    expect(snapshot.contractNotes, contains('event log rows'));
    expect(snapshot.contractNotes, contains('clipboard payload'));
    expect(
      snapshot.supportedStates,
      containsAll([
        LaunchpadScreenState.loading,
        LaunchpadScreenState.empty,
        LaunchpadScreenState.error,
        LaunchpadScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-307 renders event log baseline', (tester) async {
    await pumpEventLog(tester);

    expect(find.byType(LaunchpadEventLogPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadEventLogPage.contentKey), findsOneWidget);
    expect(find.byKey(LaunchpadEventLogPage.searchKey), findsOneWidget);
    expect(find.byKey(LaunchpadEventLogPage.levelsKey), findsOneWidget);
    expect(find.byKey(LaunchpadEventLogPage.actionsKey), findsOneWidget);
    expect(find.byKey(LaunchpadEventLogPage.eventListKey), findsOneWidget);
    expect(find.byKey(LaunchpadEventLogPage.eventKey('ev01')), findsOneWidget);
    expect(find.text('Bridge transaction initiated'), findsOneWidget);
    expect(find.text('Token approval confirmed'), findsOneWidget);
    expect(find.byKey(LaunchpadEventLogPage.exportButtonKey), findsOneWidget);
  });

  testWidgets('SC-307 first viewport reaches event search', (tester) async {
    await pumpEventLog(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-307 LaunchpadEventLogPage',
      semanticLabel: 'Nhật ký sự kiện trên chuỗi của Launchpad',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadEventLogPage.searchKey),
      routeName: 'SC-307 LaunchpadEventLogPage',
      actionLabel: 'the event search field',
    );
  });

  testWidgets('SC-307 filters search and source states', (tester) async {
    await pumpEventLog(tester);

    await tester.tap(find.byKey(LaunchpadEventLogPage.levelKey('info')));
    await tester.pumpAndSettle();
    expect(find.text('Bridge transaction initiated'), findsOneWidget);
    expect(find.text('Token approval confirmed'), findsNothing);

    await tester.tap(find.byKey(LaunchpadEventLogPage.levelKey('all')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byKey(LaunchpadEventLogPage.searchKey),
        matching: find.byType(TextField),
      ),
      'liquidity',
    );
    await tester.pumpAndSettle();
    expect(find.text('Bridge transaction failed'), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byKey(LaunchpadEventLogPage.searchKey),
        matching: find.byType(TextField),
      ),
      'does-not-exist',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadEventLogPage.emptyKey), findsOneWidget);
  });

  testWidgets('SC-307 expands event details and exports selected rows', (
    tester,
  ) async {
    await pumpEventLog(tester);

    await tester.tap(find.byKey(LaunchpadEventLogPage.eventExpandKey('ev01')));
    await tester.pumpAndSettle();
    expect(find.text('TxHash'), findsOneWidget);
    expect(find.text('0x7a3f...8d2c'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadEventLogPage.eventSelectKey('ev01')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(LaunchpadEventLogPage.exportButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadEventLogPage.exportSheetKey), findsOneWidget);
    expect(find.text('Export Event Log'), findsOneWidget);
    expect(find.text('1'), findsWidgets);

    await tester.tap(find.byKey(LaunchpadEventLogPage.formatKey('json')));
    await tester.pumpAndSettle();
    final copyButtonTopLeft = tester.getTopLeft(
      find.byKey(LaunchpadEventLogPage.copyButtonKey),
    );
    await tester.tapAt(copyButtonTopLeft + const Offset(24, 12));
    await tester.pumpAndSettle();
    expect(find.text('Da copy vao clipboard'), findsOneWidget);
  });

  testWidgets('SC-307 source filter and header back work', (tester) async {
    await pumpEventLog(tester);

    await tester.tap(find.text('Nguon'));
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadEventLogPage.sourcesKey), findsOneWidget);
    await tester.tap(find.byKey(LaunchpadEventLogPage.sourceKey('Security')));
    await tester.pumpAndSettle();
    expect(
      find.text('New login detected from unfamiliar device'),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
