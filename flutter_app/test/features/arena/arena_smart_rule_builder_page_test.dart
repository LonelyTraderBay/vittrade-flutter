import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';
import 'package:vit_trade_flutter/features/arena/presentation/phone/pages/studio/arena_smart_rule_builder_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpSmartRules(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.arenaStudioSmartRules,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pickOption(
    WidgetTester tester,
    Finder trigger,
    String option,
  ) async {
    await tester.ensureVisible(trigger);
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  Future<void> completeCoreRule(WidgetTester tester) async {
    await tester.enterText(
      find.byKey(ArenaSmartRuleBuilderPage.titleKey),
      'BTC Weekly Predict - Investor Demo',
    );
    await pickOption(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.domainKey),
      'Crypto / Markets',
    );
    await tester.tap(
      find.byKey(ArenaSmartRuleBuilderPage.challengeTypeKey('yes_no')),
    );
    await tester.pumpAndSettle();
    await pickOption(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.subjectKey),
      'Người chơi',
    );
    await pickOption(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.actionKey),
      'đoán gần đúng nhất',
    );
  }

  Future<void> completeEdgeRules(WidgetTester tester) async {
    await pickOption(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.metricKey),
      'giá',
    );
    await pickOption(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.winTypeKey),
      'sẽ thắng',
    );
    await pickOption(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.deadlineContextKey),
      'vào ngày kết thúc',
    );
    await pickOption(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.tieRuleKey),
      'Chia đều pool',
    );
    await pickOption(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.voidRuleKey),
      'Sự kiện gốc bị hủy -> hủy',
    );
    await pickOption(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.resultDeadlineKey),
      '24 giờ sau kết thúc',
    );
  }

  test('SC-186 mock repository exposes Smart Rule BE draft', () async {
    final snapshot = await const MockArenaRepository(
      loadDelay: Duration.zero,
    ).getArenaSmartRules();

    expect(snapshot.endpoint, '/api/mobile/arena/arena-studio-smart-rules');
    expect(
      snapshot.actionDraft,
      'POST /arena/challenges|join|resolve|report where applicable',
    );
    expect(snapshot.steps.length, 6);
    expect(snapshot.domains.map((domain) => domain.id), contains('crypto'));
    expect(
      snapshot.challengeTypes.map((type) => type.id),
      containsAll(['yes_no', 'proof_challenge']),
    );
    expect(snapshot.defaultEndDate, '2026-03-15');
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

  testWidgets('SC-186 renders Smart Rule Builder baseline', (tester) async {
    await pumpSmartRules(tester);

    expect(find.byType(ArenaSmartRuleBuilderPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Arena Studio'), findsOneWidget);
    expect(find.text('Luật chơi — Smart Builder'), findsOneWidget);
    expect(find.text('Luật chơi — Smart Builder'), findsOneWidget);
    expect(find.text('Rule Clarity Score'), findsOneWidget);
    expect(find.text('Thấp'), findsWidgets);
    expect(find.text('Public vs Private — Room cần rule gì?'), findsOneWidget);
    expect(find.text('Tên challenge'), findsOneWidget);
    expect(find.text('Loại challenge'), findsWidgets);
    expect(find.text('Yes / No'), findsOneWidget);
  });

  testWidgets('SC-186 first viewport exposes rule setup controls', (
    tester,
  ) async {
    await pumpSmartRules(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-186 ArenaSmartRuleBuilderPage',
      semanticLabel:
          'Đặt luật thử thách - bước xây dựng luật trong Arena Studio',
    );
    expectFirstViewportVisible(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.titleKey),
      targetLabel: 'the smart rule title field',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(ArenaSmartRuleBuilderPage.challengeTypeKey('yes_no')),
      routeName: 'SC-186 ArenaSmartRuleBuilderPage',
      actionLabel: 'the yes/no challenge type',
    );
    expectNoArenaFinancialBoundaryCopyRegression();
  });

  testWidgets('SC-186 structured rule controls enable continue', (
    tester,
  ) async {
    await pumpSmartRules(tester);

    final blockedCta = tester.widget<VitCtaButton>(
      find.byKey(ArenaSmartRuleBuilderPage.continueKey),
    );
    expect(blockedCta.onPressed, isNotNull);

    await completeCoreRule(tester);

    expect(find.text('Crypto / Markets'), findsWidgets);
    expect(find.text('Người chơi'), findsWidgets);
    expect(find.text('đoán gần đúng nhất'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(ArenaSmartRuleBuilderPage.continueKey),
    );
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.continueKey));
    await tester.pumpAndSettle();
    expect(find.text('Rule đã hoàn chỉnh'), findsOneWidget);
  });

  testWidgets('SC-186 incomplete actions explain what is missing', (
    tester,
  ) async {
    await pumpSmartRules(tester);

    await tester.ensureVisible(
      find.byKey(ArenaSmartRuleBuilderPage.previewKey),
    );
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.previewKey));
    await tester.pumpAndSettle();

    expect(find.text('Nhập tên challenge tối thiểu 3 ký tự.'), findsWidgets);
  });

  testWidgets('SC-186 selectors expose real option choices', (tester) async {
    await pumpSmartRules(tester);

    await tester.ensureVisible(find.byKey(ArenaSmartRuleBuilderPage.domainKey));
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.domainKey));
    await tester.pumpAndSettle();
    expect(find.text('Thể thao'), findsWidgets);
    await tester.tap(find.text('Thể thao').last);
    await tester.pumpAndSettle();
    expect(find.text('Thể thao'), findsWidgets);

    await tester.ensureVisible(
      find.byKey(ArenaSmartRuleBuilderPage.subjectKey),
    );
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.subjectKey));
    await tester.pumpAndSettle();
    expect(find.text('Đội'), findsWidgets);
    await tester.tap(find.text('Đội').last);
    await tester.pumpAndSettle();
    expect(find.text('Đội'), findsWidgets);
  });

  testWidgets('SC-186 previews backend payload and submits local challenge', (
    tester,
  ) async {
    await pumpSmartRules(tester);

    await completeCoreRule(tester);
    await completeEdgeRules(tester);

    await tester.ensureVisible(
      find.byKey(ArenaSmartRuleBuilderPage.previewKey),
    );
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.previewKey));
    await tester.pumpAndSettle();
    expect(find.text('Payload sẵn sàng cho BE'), findsWidgets);
    expect(find.text('POST /arena/challenges'), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(ArenaSmartRuleBuilderPage.rulesAckKey),
    );
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.rulesAckKey));
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.pointsAckKey));
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.moderationAckKey));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(ArenaSmartRuleBuilderPage.submitKey));
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.submitKey));
    await tester.pumpAndSettle();
    expect(find.text('Xác nhận gửi challenge'), findsOneWidget);
    expect(find.byType(VitBottomNav).hitTestable(), findsNothing);

    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.confirmSubmitKey));
    await tester.pumpAndSettle();

    expect(find.text('Sân chơi của tôi'), findsOneWidget);
    expect(find.text('BTC Weekly Predict - Investor Demo'), findsOneWidget);
  });

  testWidgets('SC-186 guidance and draft actions expose local state', (
    tester,
  ) async {
    await pumpSmartRules(tester);

    await tester.ensureVisible(
      find.byKey(ArenaSmartRuleBuilderPage.guidanceKey),
    );
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.guidanceKey));
    await tester.pumpAndSettle();
    expect(find.text('Public room cần rule rõ ràng hơn'), findsOneWidget);

    await tester.enterText(
      find.byKey(ArenaSmartRuleBuilderPage.titleKey),
      'Investor draft challenge',
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(ArenaSmartRuleBuilderPage.saveKey));
    await tester.tap(find.byKey(ArenaSmartRuleBuilderPage.saveKey));
    await tester.pumpAndSettle();
    expect(find.text('Đã lưu nháp'), findsWidgets);
  });
}
