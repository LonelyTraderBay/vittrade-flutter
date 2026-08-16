import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/earn_core/data/earn_repository.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_earn_page.dart';
import 'package:vit_trade_flutter/features/earn_staking/presentation/phone/pages/staking/staking_terms_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpTerms(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.earnStakingTerms,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-353 mock repository exposes staking terms BE draft', () async {
    final snapshot = await const MockStakingTermsRepository().getTerms();

    expect(snapshot.endpoint, '/api/mobile/earn/earn-staking-terms');
    expect(snapshot.actionDraft, contains('terms/accept'));
    expect(snapshot.title, 'Điều khoản Staking');
    expect(snapshot.backRoute, AppRoutePaths.earnStaking);
    expect(snapshot.version, '2.1');
    expect(snapshot.sections, hasLength(15));
    expect(snapshot.sections.first.id, 'definitions');
    expect(snapshot.contractNotes, contains('legal terms version'));
    expect(snapshot.supportedStates, contains(EarnScreenState.offline));
  });

  testWidgets('SC-353 renders staking terms baseline', (tester) async {
    await pumpTerms(tester);

    expect(find.byType(StakingTermsPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text('Điều khoản Staking'), findsOneWidget);
    expect(find.byKey(StakingTermsPage.heroKey), findsOneWidget);
    expect(find.text('Điều khoản Dịch vụ Staking'), findsOneWidget);
    expect(find.text('Cập nhật: 01/03/2026'), findsOneWidget);
    expect(find.text('Phiên bản 2.1'), findsOneWidget);
    expect(find.text('In trang'), findsOneWidget);
    expect(find.text('Tải PDF'), findsOneWidget);
    expect(
      find.byKey(StakingTermsPage.sectionKey('definitions')),
      findsOneWidget,
    );
    expect(find.text('1. Định nghĩa'), findsOneWidget);
    expect(find.textContaining('"Nền tảng"'), findsOneWidget);
    expect(find.text('15. Liên hệ'), findsOneWidget);
  });

  testWidgets('SC-353 expands sections and toggles acceptance', (tester) async {
    await pumpTerms(tester);

    final serviceSection = find.byKey(
      StakingTermsPage.sectionKey('service-description'),
    );
    await Scrollable.ensureVisible(
      tester.element(serviceSection),
      alignment: .4,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('2. Mô tả dịch vụ'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Staking Cố định'), findsOneWidget);

    final acceptance = find.byKey(StakingTermsPage.acceptanceKey);
    await Scrollable.ensureVisible(tester.element(acceptance), alignment: .65);
    await tester.pumpAndSettle();
    await tester.tap(acceptance);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('SC-353 action buttons show safe draft status', (tester) async {
    await pumpTerms(tester);

    await tester.tap(find.byKey(StakingTermsPage.downloadKey));
    await tester.pumpAndSettle();

    expect(find.textContaining('Tải PDF sẽ sớm ra mắt'), findsOneWidget);
  });

  testWidgets('SC-353 header back returns to staking route', (tester) async {
    await pumpTerms(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(StakingEarnPage), findsOneWidget);
  });
}
