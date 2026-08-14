import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/router/contracts/redirect_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/contracts/root_route_contracts.dart';
import 'package:vit_trade_flutter/app/router/contracts/route_contract.dart';
import 'package:vit_trade_flutter/app/router/route_groups/arena_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/auth_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/home_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/markets_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/p2p_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/predictions_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/profile_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_compliance_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/utility_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/wallet_route_ids.dart';

void main() {
  test('route contract có đủ năm navigation roots theo thứ tự sản phẩm', () {
    expect(RootRouteContracts.navigationRoots.map((route) => route.path), [
      HomeRoutePaths.home,
      MarketsRoutePaths.markets,
      TradeRoutePaths.trade,
      WalletRoutePaths.wallet,
      ProfileRoutePaths.profile,
    ]);
    expect(
      RootRouteContracts.navigationRoots.every(
        (route) =>
            route.kind == RouteContractKind.page &&
            route.name != null &&
            route.screenId != null,
      ),
      isTrue,
    );
  });

  test('route contract không trùng path hoặc route name', () {
    final routes = RootRouteContracts.all;
    expect(routes.map((route) => route.path).toSet().length, routes.length);
    expect(routes.map((route) => route.name).toSet().length, routes.length);
  });

  test('receipt giữ contract trade độc lập với navigation root', () {
    expect(
      RootRouteContracts.tradeOrderReceipt.path,
      TradeRoutePaths.tradeOrderReceipt,
    );
    expect(RootRouteContracts.tradeOrderReceipt.feature, 'trade');
    expect(RootRouteContracts.tradeOrderReceipt.isRedirectAlias, isFalse);
  });

  test('route contract giữ đủ sáu redirect alias và target canonical', () {
    final aliases = RedirectRouteContracts.aliases;
    expect(aliases, hasLength(6));
    expect(aliases.every((route) => route.isRedirectAlias), isTrue);
    expect(aliases.every((route) => route.redirectTarget != null), isTrue);
    expect(aliases.map((route) => route.path).toSet().length, aliases.length);
    expect(
      aliases.map((route) => route.path),
      containsAll(<String>[
        ArenaRoutePaths.arenaPoints,
        AuthRoutePaths.root,
        P2PRoutePaths.p2pInsuranceFundAlias,
        ProfileRoutePaths.profilePredictions,
        ProfileRoutePaths.profileArena,
        TradeRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
      ]),
    );
    expect(
      aliases.map((route) => route.redirectTarget),
      containsAll(<String>[
        '${UtilityRoutePaths.rewards}?tab=arena',
        HomeRoutePaths.home,
        P2PRoutePaths.p2pInsurance,
        PredictionsRoutePaths.marketsPredictionsPortfolio,
        ArenaRoutePaths.arenaMy,
        TradeComplianceRoutePaths.tradeCopyRegulatoryDisclosures,
      ]),
    );
  });

  test('tên route trong contract đã được router runtime đăng ký', () {
    final router = createAppRouter();
    addTearDown(router.dispose);

    for (final route in [
      ...RootRouteContracts.all,
      ...RedirectRouteContracts.aliases,
    ]) {
      final name = route.name;
      if (name == null) continue;
      expect(router.namedLocation(name), route.path);
    }
  });
}
