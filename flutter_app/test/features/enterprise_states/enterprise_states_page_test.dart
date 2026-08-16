import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/auth/presentation/phone/pages/login_page.dart';
import 'package:vit_trade_flutter/features/enterprise_states/data/enterprise_states_repository.dart';
import 'package:vit_trade_flutter/features/enterprise_states/presentation/phone/pages/enterprise_states_page.dart';
import 'package:vit_trade_flutter/features/home/presentation/phone/pages/home_page.dart';
import 'package:vit_trade_flutter/features/markets/presentation/phone/pages/market_list_page.dart';
import 'package:vit_trade_flutter/features/profile/presentation/phone/pages/kyc_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

void main() {
  Future<void> pumpEnterpriseStates(
    WidgetTester tester, {
    Size viewport = const Size(440, 956),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = viewport;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.enterpriseStates,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  test('SC-320 mock repository exposes enterprise states BE draft', () async {
    final snapshot = await const MockEnterpriseStatesRepository()
        .getReference();

    expect(
      snapshot.endpoint,
      '/api/mobile/enterprise-states/enterprise-states',
    );
    expect(snapshot.actionDraft, 'read-only or local navigation action');
    expect(snapshot.title, '02 – Enterprise UI States');
    expect(snapshot.backRoute, AppRoutePaths.home);
    expect(snapshot.marketRoute, AppRoutePaths.markets);
    expect(snapshot.kycRoute, AppRoutePaths.profileKyc);
    expect(snapshot.securityRoute, AppRoutePaths.profileSecurity);
    expect(snapshot.loginRoute, AppRoutePaths.authLogin);
    expect(snapshot.tabs.length, 3);
    expect(snapshot.previewStates.length, 5);
    expect(snapshot.banners.length, 3);
    expect(snapshot.contractNotes, contains('UI reference screen'));
    expect(
      snapshot.supportedStates,
      containsAll([
        EnterpriseStatesScreenState.loading,
        EnterpriseStatesScreenState.empty,
        EnterpriseStatesScreenState.error,
        EnterpriseStatesScreenState.offline,
      ]),
    );
  });

  testWidgets('SC-320 renders enterprise state kit baseline structure', (
    tester,
  ) async {
    // loadDelay: Duration.zero — gọi trực tiếp Mock*.get() bên trong
    // testWidgets() (khác với test() thường) chạy trong FakeAsync zone;
    // delay mặc định 300ms cần tester.pump(duration) để đẩy fake clock,
    // và lệnh gọi NÀY đứng TRƯỚC pumpEnterpriseStates nên không có pump
    // nào đẩy nó cả — treo vô thời hạn nếu không ép loadDelay: 0.
    final snapshot = await const MockEnterpriseStatesRepository(
      loadDelay: Duration.zero,
    ).getReference();
    await pumpEnterpriseStates(tester);

    expect(find.byType(EnterpriseStatesPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.text(snapshot.title), findsOneWidget);
    expect(find.text(snapshot.subtitle), findsOneWidget);
    expect(find.text(snapshot.tabs[0].label), findsOneWidget);
    expect(find.text(snapshot.tabs[1].label), findsOneWidget);
    expect(find.text(snapshot.tabs[2].label), findsOneWidget);
    expect(find.text('Preview — loading'), findsOneWidget);
    expect(find.text('Banner Variants'), findsOneWidget);
    expect(find.text(snapshot.banners.first.title), findsOneWidget);
  });

  testWidgets('SC-320 uses full-width workspace at 360x800', (tester) async {
    await pumpEnterpriseStates(tester, viewport: const Size(360, 800));

    expect(find.byType(EnterpriseStatesPage), findsOneWidget);
    expect(find.byKey(EnterpriseStatesPage.contentKey), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);

    final contentRect = tester.getRect(
      find.byKey(EnterpriseStatesPage.contentKey),
    );
    expect(contentRect.left, closeTo(0, 0.5));
    expect(contentRect.right, closeTo(360, 0.5));
    expect(contentRect.top, greaterThanOrEqualTo(0));
    expect(contentRect.bottom, lessThanOrEqualTo(800));
    expect(tester.takeException(), isNull);
  });

  testWidgets('SC-320 switches preview states locally', (tester) async {
    await pumpEnterpriseStates(tester);

    await tester.ensureVisible(
      find.byKey(EnterpriseStatesPage.stateKey(EnterprisePreviewState.empty)),
    );
    await tester.tap(
      find.byKey(EnterpriseStatesPage.stateKey(EnterprisePreviewState.empty)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));

    expect(find.byIcon(Icons.star_border_rounded), findsOneWidget);
    expect(find.byKey(EnterpriseStatesPage.marketCtaKey), findsOneWidget);

    await tester.ensureVisible(
      find.byKey(EnterpriseStatesPage.stateKey(EnterprisePreviewState.gate)),
    );
    await tester.tap(
      find.byKey(EnterpriseStatesPage.stateKey(EnterprisePreviewState.gate)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));

    expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);
    expect(find.byKey(EnterpriseStatesPage.kycCtaKey), findsOneWidget);
  });

  testWidgets('SC-320 back control returns to Home', (tester) async {
    await pumpEnterpriseStates(tester);

    await tester.tap(find.byKey(EnterpriseStatesPage.backKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets(
    'SC-320 resolved CTA routes navigate to markets, KYC, and login',
    (tester) async {
      await pumpEnterpriseStates(tester);

      await tester.tap(
        find.byKey(EnterpriseStatesPage.stateKey(EnterprisePreviewState.empty)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 220));
      await tester.tap(find.byKey(EnterpriseStatesPage.marketCtaKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(MarketListPage), findsOneWidget);

      await pumpEnterpriseStates(tester);
      await tester.ensureVisible(
        find.byKey(EnterpriseStatesPage.stateKey(EnterprisePreviewState.gate)),
      );
      await tester.tap(
        find.byKey(EnterpriseStatesPage.stateKey(EnterprisePreviewState.gate)),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 220));
      await tester.tap(find.byKey(EnterpriseStatesPage.kycCtaKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(KYCPage), findsOneWidget);

      await pumpEnterpriseStates(tester);
      await tester.tap(
        find.byKey(
          EnterpriseStatesPage.sectionKey(EnterpriseStateSection.security),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 220));
      await tester.tap(find.byKey(EnterpriseStatesPage.loginCtaKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(LoginPage), findsOneWidget);
    },
  );
}
