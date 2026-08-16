import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/governance/arena_governance_gate_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpGovernance(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaStudioGovernance,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-188 mock repository exposes Governance Gate BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaGovernance();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-studio-governance');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.steps.length, 6);
    expect(snapshot.privacyOptions.map((option) => option.id), [
      'public',
      'private',
      'unlisted',
    ]);
    expect(snapshot.domains.map((domain) => domain.id), contains('crypto'));
    expect(
      snapshot.challengeTypes.map((type) => type.id),
      containsAll(['yes_no', 'proof_challenge']),
    );
    expect(
      snapshot.suggestionActions.map((item) => item.id),
      contains('add_rules'),
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

  testWidgets('SC-188 renders Governance Gate baseline', (tester) async {
    await pumpGovernance(tester);

    expect(find.byType(ArenaGovernanceGatePage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Arena Studio'), findsOneWidget);
    expect(find.text('Xác nhận trước publish · Points only'), findsOneWidget);
    expect(find.text('Governance state'), findsOneWidget);
    expect(find.text('Luật chơi — Governed Mode'), findsOneWidget);
    expect(find.text('Quyền riêng tư'), findsOneWidget);
    expect(find.text('Công khai'), findsWidgets);
    expect(find.text('Rule Clarity Score'), findsOneWidget);
    expect(find.text('Tên challenge'), findsOneWidget);
    expect(find.text('Lĩnh vực'), findsOneWidget);
    expect(find.text('Loại challenge'), findsOneWidget);
  });

  testWidgets('SC-188 first viewport exposes governance setup controls', (
    tester,
  ) async {
    await pumpGovernance(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-188 ArenaGovernanceGatePage',
      semanticLabel:
          'Xác nhận và publish thử thách - bước cuối trong Arena Studio',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaGovernanceGatePage.titleKey),
      routeName: 'SC-188 ArenaGovernanceGatePage',
      actionLabel: 'the governance title field',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-188 governance form can reach publish-ready state', (
    tester,
  ) async {
    await pumpGovernance(tester);

    final blockedCta = tester.widget<VitCtaButton>(
      find.byKey(ArenaGovernanceGatePage.continueKey),
    );
    expect(blockedCta.onPressed, isNull);

    await tester.enterText(
      find.byKey(ArenaGovernanceGatePage.titleKey),
      'BTC Weekly Predict — Tuần 10',
    );
    await tester.ensureVisible(
      find.byKey(ArenaGovernanceGatePage.domainKey('crypto')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ArenaGovernanceGatePage.domainKey('crypto')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(ArenaGovernanceGatePage.challengeTypeKey('closest_guess')),
    );
    await tester.tap(
      find.byKey(ArenaGovernanceGatePage.challengeTypeKey('closest_guess')),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Điều kiện thắng'));
    await tester.tap(find.text('Chọn...').first);
    await tester.tap(find.text('Chọn...').at(1));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Cách chốt kết quả'));
    await tester.tap(find.text('Chọn resolution source...'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Luật hòa'));
    await tester.tap(find.text('Chọn tie rule...'));
    await tester.tap(find.text('Chọn void rule...'));
    await tester.tap(find.text('Chọn result deadline...'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(ArenaGovernanceGatePage.continueKey));
    final readyCta = tester.widget<VitCtaButton>(
      find.byKey(ArenaGovernanceGatePage.continueKey),
    );
    expect(readyCta.onPressed, isNotNull);
  });

  testWidgets('SC-188 guidance and save expose local state', (tester) async {
    await pumpGovernance(tester);

    await tester.tap(find.byKey(ArenaGovernanceGatePage.compareKey));
    await tester.pumpAndSettle();
    expect(find.text('Public room cần checklist đầy đủ'), findsOneWidget);

    await tester.ensureVisible(find.byKey(ArenaGovernanceGatePage.saveKey));
    await tester.tap(find.byKey(ArenaGovernanceGatePage.saveKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã lưu nháp'), findsOneWidget);
  });
}
