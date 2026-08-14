import 'package:vit_trade_flutter/app/router/contracts/route_contract.dart';
import 'package:vit_trade_flutter/app/router/route_groups/home_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/markets_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/profile_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/wallet_route_ids.dart';

/// Route contract của năm navigation roots và receipt dùng chung giữa surface.
///
/// Đây là bước đầu của manifest migration. Các bounded context còn lại sẽ
/// được bổ sung theo route truth table ở các batch P2 tiếp theo.
final class RootRouteContracts {
  const RootRouteContracts._();

  static const List<RouteContract> navigationRoots = [
    RouteContract(
      path: HomeRoutePaths.home,
      name: HomeRouteNames.sc007Home,
      screenId: HomeRouteNames.sc007Home,
      feature: 'home',
      kind: RouteContractKind.page,
    ),
    RouteContract(
      path: MarketsRoutePaths.markets,
      name: MarketsRouteNames.sc008MarketList,
      screenId: MarketsRouteNames.sc008MarketList,
      feature: 'markets',
      kind: RouteContractKind.page,
    ),
    RouteContract(
      path: TradeRoutePaths.trade,
      name: TradeRouteNames.sc048Trade,
      screenId: TradeRouteNames.sc048Trade,
      feature: 'trade',
      kind: RouteContractKind.page,
    ),
    RouteContract(
      path: WalletRoutePaths.wallet,
      name: WalletRouteNames.sc135Wallet,
      screenId: WalletRouteNames.sc135Wallet,
      feature: 'wallet',
      kind: RouteContractKind.page,
    ),
    RouteContract(
      path: ProfileRoutePaths.profile,
      name: ProfileRouteNames.sc156Profile,
      screenId: ProfileRouteNames.sc156Profile,
      feature: 'profile',
      kind: RouteContractKind.page,
    ),
  ];

  static const RouteContract tradeOrderReceipt = RouteContract(
    path: TradeRoutePaths.tradeOrderReceipt,
    name: TradeRouteNames.sc051OrderReceipt,
    screenId: TradeRouteNames.sc051OrderReceipt,
    feature: 'trade',
    kind: RouteContractKind.page,
  );

  static const List<RouteContract> all = [
    ...navigationRoots,
    tradeOrderReceipt,
  ];
}
