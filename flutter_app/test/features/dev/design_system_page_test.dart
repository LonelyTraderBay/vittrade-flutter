import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/dev/data/dev_tools_repository.dart';
import 'package:vit_trade_flutter/features/dev/presentation/phone/pages/design_system_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpDesignSystem(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.devDesignSystem,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-399 mock repository exposes design system BE draft', () async {
    final snapshot = await const MockDesignSystemRepository().getDesignSystem();

    expect(snapshot.endpoint, '/api/mobile/dev/dev-design-system');
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, 'Design System');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.tokens, hasLength(9));
    expect(snapshot.swatches, hasLength(15));
    expect(snapshot.ctaDemos, hasLength(6));
    expect(snapshot.inputDemos, hasLength(4));
    expect(snapshot.sectionDemos, hasLength(4));
    expect(snapshot.contractNotes, contains('internal role or dev flag'));
    expect(snapshot.contractNotes, contains('AppColors'));
    expect(
      snapshot.supportedStates,
      containsAll([
        DevScreenState.loading,
        DevScreenState.empty,
        DevScreenState.error,
        DevScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-399 renders design tokens and palette baseline', (
    tester,
  ) async {
    await pumpDesignSystem(tester);

    expect(find.byType(DesignSystemPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Design System'), findsOneWidget);
    expect(find.byKey(DesignSystemPage.heroKey), findsOneWidget);
    expect(find.text('VitTrade UI Kit'), findsOneWidget);
    expect(find.byKey(DesignSystemPage.tokensKey), findsOneWidget);
    expect(find.text('--input-height'), findsOneWidget);
    expect(find.text('52px'), findsWidgets);
    expect(find.byKey(DesignSystemPage.colorsKey), findsOneWidget);
    expect(find.byKey(DesignSystemPage.swatchKey('primary')), findsOneWidget);
    expect(find.text('Primary'), findsOneWidget);
  });

  testWidgets('SC-399 lower component sections render and playground updates', (
    tester,
  ) async {
    await pumpDesignSystem(tester);

    await tester.ensureVisible(find.byKey(DesignSystemPage.playgroundKey));
    await tester.pump();

    expect(find.byKey(DesignSystemPage.ctaKey), findsOneWidget);
    expect(find.byKey(DesignSystemPage.inputKey), findsOneWidget);
    expect(find.byKey(DesignSystemPage.sectionsKey), findsOneWidget);
    expect(find.text('Interactive Playground'), findsOneWidget);
    expect(find.text('CTAButton Playground'), findsOneWidget);

    await tester.tap(find.text('danger').last);
    await tester.pump();
    await tester.enterText(
      find.widgetWithText(TextField, 'Mua BTC').last,
      'Bán ETH',
    );
    await tester.pump();

    expect(find.text('Bán ETH'), findsWidgets);
  });

  testWidgets('SC-399 header back returns home', (tester) async {
    await pumpDesignSystem(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomePage), findsOneWidget);
  });
}
