import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_two_column_tablet_dashboard.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

void main() {
  Future<void> pumpDashboard(WidgetTester tester, double width) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VitTwoColumnTabletDashboard(
            primaryChildren: [Text('Primary content')],
            secondaryChildren: [Text('Secondary content')],
          ),
        ),
      ),
    );
  }

  testWidgets(
    'below twoColumnMinWidth renders the single-column fallback with both '
    'primary and secondary children present',
    (tester) async {
      await pumpDashboard(tester, 700);

      expect(find.byType(Row), findsNothing);
      expect(find.text('Primary content'), findsOneWidget);
      expect(find.text('Secondary content'), findsOneWidget);
    },
  );

  testWidgets('at/above twoColumnMinWidth renders a two-column Row with the '
      'secondary column framed in a VitCard and the primary column not', (
    tester,
  ) async {
    await pumpDashboard(tester, 1000);

    expect(find.byType(Row), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('Secondary content'),
        matching: find.byType(VitCard),
      ),
      findsOneWidget,
    );
    expect(
      find.ancestor(
        of: find.text('Primary content'),
        matching: find.byType(VitCard),
      ),
      findsNothing,
    );
  });

  testWidgets(
    'at the two-column width, the dashboard lays out without overflow',
    (tester) async {
      await pumpDashboard(tester, 1000);

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('the two-column block width-caps at primaryColumnMaxWidth + '
      'secondaryColumnMaxWidth (R5) instead of stretching to fill a much '
      'wider shell', (tester) async {
    await pumpDashboard(tester, 1600);

    expect(
      tester.getSize(find.byType(Row)).width,
      TabletDashboardWidths.primaryColumnMaxWidth +
          TabletDashboardWidths.secondaryColumnMaxWidth,
    );
  });

  testWidgets('both tablet columns reserve the standard bottom content inset', (
    tester,
  ) async {
    await pumpDashboard(tester, 1000);

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is SingleChildScrollView &&
            widget.padding ==
                const EdgeInsets.only(bottom: AppSpacing.contentPad),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Padding &&
            widget.padding ==
                const EdgeInsets.only(bottom: AppSpacing.contentPad),
      ),
      findsNWidgets(2),
    );
  });

  testWidgets(
    'the two-column path accepts independent primary and secondary section '
    'rhythm overrides',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1000, 900);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VitTwoColumnTabletDashboard(
              primaryContentGap: 8,
              secondaryContentGap: 13,
              primaryChildren: [Text('Primary content')],
              secondaryChildren: [Text('Secondary content')],
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is VitPageContent && widget.customGap == 8,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is VitPageContent && widget.customGap == 13,
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('a null onRefresh keeps the dashboard non-refreshable', (
    tester,
  ) async {
    await pumpDashboard(tester, 1000);

    expect(find.byType(RefreshIndicator), findsNothing);
  });

  testWidgets('onRefresh wraps both two-column scrollables and fires on an '
      'overscroll in either column', (tester) async {
    final refreshGate = Completer<void>();
    var refreshCalls = 0;

    Future<void> pumpWithRefresh(double width) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 900);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VitTwoColumnTabletDashboard(
              onRefresh: () async {
                refreshCalls++;
                await refreshGate.future;
              },
              primaryChildren: const [Text('Primary content')],
              secondaryChildren: const [Text('Secondary content')],
            ),
          ),
        ),
      );
    }

    await pumpWithRefresh(1000);

    expect(find.byType(RefreshIndicator), findsNWidgets(2));

    // Both columns hold less content than the viewport, so the pull only
    // works because the refreshable path scrolls always-scrollable.
    await tester.fling(
      find.text('Primary content'),
      const Offset(0, 400),
      1000,
    );
    await tester.pump();
    expect(find.byType(RefreshProgressIndicator), findsOneWidget);

    refreshGate.complete();
    await tester.pumpAndSettle();
    expect(refreshCalls, 1);

    await tester.fling(
      find.text('Secondary content'),
      const Offset(0, 400),
      1000,
    );
    await tester.pump();
    await tester.pumpAndSettle();
    expect(refreshCalls, 2);
  });

  testWidgets('onRefresh also covers the single-column fallback', (
    tester,
  ) async {
    var refreshCalls = 0;

    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 900);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VitTwoColumnTabletDashboard(
            onRefresh: () async => refreshCalls++,
            primaryChildren: const [Text('Primary content')],
            secondaryChildren: const [Text('Secondary content')],
          ),
        ),
      ),
    );

    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.fling(
      find.text('Primary content'),
      const Offset(0, 400),
      1000,
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(refreshCalls, 1);
  });
}
