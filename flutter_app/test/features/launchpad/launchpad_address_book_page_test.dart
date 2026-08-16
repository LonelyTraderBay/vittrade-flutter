import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/vit_trade_app.dart';
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/tools/launchpad_address_book_page.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/phone/pages/hub/launchpad_page.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import '../../helpers/first_viewport_test_utils.dart';

void main() {
  Future<void> pumpAddressBook(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(440, 956);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: VitTradeApp(
          routerConfig: createAppRouter(
            initialLocation: AppRoutePaths.launchpadAddressBook,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  test(
    'SC-309 mock repository exposes launchpad address book BE draft',
    () async {
      final snapshot = await const MockLaunchpadRepository(
        loadDelay: Duration.zero,
      ).getAddressBook();

      expect(snapshot.endpoint, '/api/mobile/launchpad/launchpad-address-book');
      expect(
        snapshot.actionDraft,
        'POST /kyc/submission-step; POST /launchpad/subscribe|claim|bridge where applicable',
      );
      expect(snapshot.title, 'So dia chi');
      expect(snapshot.backRoute, AppRoutePaths.launchpad);
      expect(snapshot.addresses, hasLength(6));
      expect(snapshot.addresses.first.label, 'Vi chinh');
      expect(snapshot.chainFilters, [
        'all',
        'Ethereum',
        'BSC',
        'Polygon',
        'Arbitrum',
      ]);
      expect(snapshot.contractNotes, contains('multi-chain saved addresses'));
      expect(snapshot.contractNotes, contains('KYC submission-step'));
      expect(
        snapshot.supportedStates,
        containsAll([
          LaunchpadScreenState.loading,
          LaunchpadScreenState.empty,
          LaunchpadScreenState.error,
          LaunchpadScreenState.offline,
        ]),
      );
    },
  );

  testWidgets('SC-309 renders address book baseline', (tester) async {
    await pumpAddressBook(tester);

    expect(find.byType(LaunchpadAddressBookPage), findsOneWidget);
    expect(find.byType(VitBottomNav), findsOneWidget);
    expect(find.byKey(const Key('vit_bottom_nav_trade')), findsOneWidget);
    expect(find.byKey(LaunchpadAddressBookPage.contentKey), findsOneWidget);
    expect(find.byKey(LaunchpadAddressBookPage.searchKey), findsOneWidget);
    expect(find.byKey(LaunchpadAddressBookPage.statsKey), findsOneWidget);
    expect(find.byKey(LaunchpadAddressBookPage.favoritesKey), findsOneWidget);
    expect(find.byKey(LaunchpadAddressBookPage.allKey), findsOneWidget);
    expect(find.text('So dia chi'), findsOneWidget);
    expect(find.text('Vi chinh'), findsOneWidget);
    expect(find.text('Vi BSC'), findsOneWidget);
    expect(find.text('Vi Arbitrum'), findsOneWidget);
  });

  testWidgets('SC-309 first viewport reaches address search', (tester) async {
    await pumpAddressBook(tester);

    expectRouteSemanticInFirstViewport(
      tester,
      routeName: 'SC-309 LaunchpadAddressBookPage',
      semanticLabel: 'Sổ địa chỉ ví đáng tin cậy trong Launchpad',
    );
    expectActionableInFirstViewport(
      tester,
      find.byKey(LaunchpadAddressBookPage.searchKey),
      routeName: 'SC-309 LaunchpadAddressBookPage',
      actionLabel: 'the address search field',
    );
  });

  testWidgets('SC-309 filters search and chain state', (tester) async {
    await pumpAddressBook(tester);

    await tester.tap(find.byKey(LaunchpadAddressBookPage.filterKey('BSC')));
    await tester.pumpAndSettle();
    expect(find.text('Vi BSC'), findsOneWidget);
    expect(find.text('Vi Polygon'), findsNothing);

    await tester.enterText(
      find.descendant(
        of: find.byKey(LaunchpadAddressBookPage.searchKey),
        matching: find.byType(TextField),
      ),
      'defi',
    );
    await tester.pumpAndSettle();
    expect(find.text('Vi test DeFi'), findsOneWidget);
    expect(find.text('Vi BSC'), findsNothing);
  });

  testWidgets('SC-309 shows empty state for unmatched address search', (
    tester,
  ) async {
    await pumpAddressBook(tester);

    await tester.enterText(
      find.descendant(
        of: find.byKey(LaunchpadAddressBookPage.searchKey),
        matching: find.byType(TextField),
      ),
      'khong-co-dia-chi',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(LaunchpadAddressBookPage.emptyKey), findsOneWidget);
    expect(find.text('Khong tim thay dia chi'), findsOneWidget);
    expect(find.byKey(LaunchpadAddressBookPage.favoritesKey), findsNothing);
    expect(find.byKey(LaunchpadAddressBookPage.allKey), findsNothing);
    expect(find.byKey(LaunchpadAddressBookPage.infoKey), findsOneWidget);
  });

  testWidgets('SC-309 copy favorite expand and default states work', (
    tester,
  ) async {
    await pumpAddressBook(tester);

    await tester.tap(find.byKey(LaunchpadAddressBookPage.copyKey('w1')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_rounded), findsWidgets);

    await tester.tap(find.byKey(LaunchpadAddressBookPage.favoriteKey('w6')));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadAddressBookPage.cardKey('w6')), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadAddressBookPage.expandKey('w6')));
    await tester.pumpAndSettle();
    expect(find.text('So lan su dung'), findsOneWidget);

    await tester.tap(find.byKey(LaunchpadAddressBookPage.defaultKey('w6')));
    await tester.pumpAndSettle();
    expect(find.text('MAC DINH'), findsOneWidget);
  });

  testWidgets('SC-309 add sheet opens from header action', (tester) async {
    await pumpAddressBook(tester);

    await tester.tap(find.byKey(LaunchpadAddressBookPage.addKey));
    await tester.pumpAndSettle();
    expect(find.byKey(LaunchpadAddressBookPage.addSheetKey), findsOneWidget);
    expect(find.text('Them dia chi moi'), findsOneWidget);
  });

  testWidgets('SC-309 header back returns to launchpad', (tester) async {
    await pumpAddressBook(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
    await tester.pumpAndSettle();

    expect(find.byType(LaunchpadPage), findsOneWidget);
  });
}
