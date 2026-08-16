import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_contract_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpContract(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadContractSample,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-300 mock repository exposes launchpad contract BE draft', () async {
    final snapshot = await const MockLaunchpadRepository(
      loadDelay: Duration.zero,
    ).getContract('sample');

    expect(
      snapshot.endpoint,
      '/api/mobile/launchpad/launchpad-contract-sample',
    );
    expect(
      snapshot.actionDraft,
      'POST /launchpad/subscribe|claim|bridge where applicable',
    );
    expect(snapshot.title, 'Contract');
    expect(snapshot.backRoute, AppRoutePaths.launchpad);
    expect(snapshot.projectId, 'sample');
    expect(snapshot.project, isNull);
    expect(snapshot.networks, hasLength(3));
    expect(snapshot.functions, hasLength(5));
    expect(snapshot.simulations, hasLength(2));
    expect(snapshot.abiDiffRoute, AppRoutePaths.launchpadAbiDiff);
    expect(snapshot.contractNotes, contains('contractFunctions'));
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

  testWidgets('SC-300 renders Flutter not-found state for sample id', (
    tester,
  ) async {
    await pumpContract(tester);

    expect(find.byType(LaunchpadContractPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Contract'), findsOneWidget);
    expect(find.byKey(LaunchpadContractPage.contentKey), findsOneWidget);
    expect(find.byKey(LaunchpadContractPage.notFoundKey), findsOneWidget);
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    expect(find.text('Dự án không tồn tại'), findsOneWidget);
  });

  testWidgets('SC-300 header back returns to launchpad', (tester) async {
    await pumpContract(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
    expect(find.text('Launchpad'), findsWidgets);
  });
}
