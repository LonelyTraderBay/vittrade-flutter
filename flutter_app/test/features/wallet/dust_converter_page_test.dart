import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/wallet/data/wallet_repository.dart';
import 'package:vit_trade_flutter/features/wallet/presentation/phone/pages/assets/dust_converter_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';
import 'package:vit_trade_flutter/shared/layout/vit_phone_frame.dart';
import 'package:vit_trade_flutter/shared/layout/vit_status_bar.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpDustConverter(
    WidgetTester tester, {
    VitFirstViewport viewport = VitFirstViewport.qaPhone,
  }) async {
    configureFirstViewport(tester, viewport);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.walletDustConverter,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test('SC-154 mock repository exposes dust converter BE draft', () async {
    final snapshot = await const MockWalletRepository(
      loadDelay: Duration.zero,
    ).getDustConverter();

    expect(snapshot.endpoint, '/api/mobile/wallet/wallet-dust-converter');
    expect(
      snapshot.actionDraft,
      'POST /wallet/dust-converter/preview + POST /wallet/dust-converter/confirm',
    );
    expect(snapshot.dustThresholdUsd, 10);
    expect(snapshot.conversionFeePct, .5);
    expect(snapshot.targets.map((target) => target.symbol), ['USDT', 'BNB']);
    expect(snapshot.eligibleAssets('USDT').length, 6);
    expect(snapshot.assets.first.symbol, 'DOT');
    expect(snapshot.assets.last.symbol, 'DOGE');
    expect(
      snapshot.supportedStates,
      containsAll([
        WalletScreenState.loading,
        WalletScreenState.empty,
        WalletScreenState.error,
        WalletScreenState.offline,
        WalletScreenState.submitting,
        WalletScreenState.success,
      ]),
    );
  });

  testWidgets('SC-154 renders dust converter baseline shell', (tester) async {
    await pumpDustConverter(tester);

    expect(find.byType(DustConverterPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byType(VitPhoneFrame), findsNothing);
    expect(find.byType(VitStatusBar), findsNothing);
    expect(find.byKey(const Key('vit_bottom_nav_wallet')), findsOneWidget);
    expect(
      find.byKey(const Key('vit_bottom_nav_active_wallet')),
      findsOneWidget,
    );
    expect(
      find.text('Chuy\u1EC3n \u0111\u1ED5i s\u1ED1 d\u01B0 nh\u1ECF'),
      findsWidgets,
    );
    expect(find.text('D\u1ECDn d\u1EB9p v\u00ED'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('\$0.00'), findsOneWidget);
    expect(find.text('USDT'), findsWidgets);
    expect(find.text('BNB'), findsWidgets);
    expect(find.text('S\u1ED1 d\u01B0 nh\u1ECF (6)'), findsOneWidget);
    expect(find.text('Ch\u1ECDn t\u1EA5t c\u1EA3'), findsOneWidget);
    expect(find.byKey(DustConverterPage.assetKey('dot')), findsOneWidget);
    expect(find.byKey(DustConverterPage.assetKey('avax')), findsOneWidget);
    expect(find.byKey(DustConverterPage.assetKey('link')), findsOneWidget);
    expect(find.byKey(DustConverterPage.assetKey('matic')), findsOneWidget);
    expect(find.byKey(DustConverterPage.assetKey('atom')), findsOneWidget);
  });

  testWidgets('SC-154 first viewport reaches first dust asset row', (
    tester,
  ) async {
    await pumpDustConverter(tester, viewport: VitFirstViewport.minimumPhone);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'DustConverterPage',
      semanticLabel: 'Chuyển đổi số dư nhỏ',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(DustConverterPage.assetKey('dot')),
      routeName: 'DustConverterPage',
      actionLabel: 'the first dust asset row',
    );
  });

  testWidgets('SC-154 select all opens local confirm preview', (tester) async {
    await pumpDustConverter(tester);

    await tester.tap(find.byKey(DustConverterPage.selectAllKey));
    await tester.pumpAndSettle();
    expect(find.text('\$12.21'), findsOneWidget);
    expect(
      find.text('Chuy\u1EC3n \u0111\u1ED5i 6 t\u00E0i s\u1EA3n \u2192 USDT'),
      findsOneWidget,
    );

    await tester.ensureVisible(find.byKey(DustConverterPage.ctaKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(DustConverterPage.ctaKey));
    await tester.pumpAndSettle();
    expect(find.byKey(DustConverterPage.confirmSheetKey), findsOneWidget);
    expect(
      find.text('X\u00E1c nh\u1EADn chuy\u1EC3n \u0111\u1ED5i'),
      findsOneWidget,
    );
    expect(find.text('6 lo\u1EA1i'), findsOneWidget);
    expect(find.text('\$0.06 (0.5%)'), findsOneWidget);
    expect(find.byKey(DustConverterPage.confirmCancelKey), findsOneWidget);
    expect(find.byKey(DustConverterPage.confirmButtonKey), findsOneWidget);

    await tester.tap(find.byKey(DustConverterPage.confirmButtonKey));
    await tester.pumpAndSettle();
    expect(
      find.text('\u0110\u00E3 chuy\u1EC3n \u0111\u1ED5i th\u00E0nh c\u00F4ng'),
      findsOneWidget,
    );
    expect(
      find.text(
        '\u0110\u00E3 nh\u1EADn 12.1489 USDT t\u1EEB chuy\u1EC3n \u0111\u1ED5i s\u1ED1 d\u01B0 nh\u1ECF.',
      ),
      findsOneWidget,
    );
  });
}
