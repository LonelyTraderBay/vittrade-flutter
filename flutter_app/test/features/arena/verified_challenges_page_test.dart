import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/challenge/verified_challenges_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpVerified(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaVerified,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-195 mock repository exposes Verified Challenges BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getVerifiedChallenges();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-verified');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.title, 'Verified Challenges');
    expect(snapshot.statusLabel, 'Release-gated Preview');
    expect(
      snapshot.features.map((feature) => feature.kind),
      containsAll([
        VerifiedChallengeFeatureKind.oracle,
        VerifiedChallengeFeatureKind.escrow,
        VerifiedChallengeFeatureKind.leaderboard,
        VerifiedChallengeFeatureKind.trust,
      ]),
    );
    expect(
      snapshot.supportedStates,
      containsAll([
        ArenaScreenState.loading,
        ArenaScreenState.empty,
        ArenaScreenState.error,
        ArenaScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-195 renders Verified Challenges release-gated preview', (
    tester,
  ) async {
    await pumpVerified(tester);

    expect(find.byType(VerifiedChallengesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Verified Challenges'), findsWidgets);
    expect(find.text('Release-gated preview - Open Arena'), findsOneWidget);
    expect(find.text('Release-gated Preview'), findsOneWidget);
    expect(find.text('Preview scope'), findsOneWidget);
    expect(
      find.text('Challenge được verify bởi hệ thống Oracle'),
      findsOneWidget,
    );
    expect(
      find.text('Points pool policy with release review gate'),
      findsOneWidget,
    );
    expect(find.text('Leaderboard riêng cho verified players'), findsOneWidget);
    expect(find.text('Creator badges và trust score nâng cao'), findsOneWidget);
  });

  testWidgets('SC-195 first viewport exposes preview info card', (
    tester,
  ) async {
    await pumpVerified(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-195 VerifiedChallengesPage',
      semanticLabel:
          'Xem trước tính năng Thử thách đã xác minh - đang chờ duyệt tuân thủ và KYC',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(VerifiedChallengesPage.infoCardKey),
      routeName: 'SC-195 VerifiedChallengesPage',
      actionLabel: 'the verified preview info card',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-195 uses a compact static preview state', (tester) async {
    await pumpVerified(tester);

    expect(find.byKey(VerifiedChallengesPage.contentKey), findsOneWidget);
    expect(find.byKey(VerifiedChallengesPage.infoCardKey), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);
  });
}
