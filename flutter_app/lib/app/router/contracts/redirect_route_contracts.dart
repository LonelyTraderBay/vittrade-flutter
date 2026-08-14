import 'package:vit_trade_flutter/app/router/contracts/route_contract.dart';
import 'package:vit_trade_flutter/app/router/route_groups/arena_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/auth_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/home_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/p2p_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/predictions_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/profile_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_compliance_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/trade_route_ids.dart';
import 'package:vit_trade_flutter/app/router/route_groups/utility_route_ids.dart';

/// Sáu redirect alias được audit riêng, không tính là page mới.
final class RedirectRouteContracts {
  const RedirectRouteContracts._();

  static const List<RouteContract> aliases = [
    RouteContract(
      path: ArenaRoutePaths.arenaPoints,
      feature: 'arena',
      kind: RouteContractKind.redirectAlias,
      redirectTarget: '${UtilityRoutePaths.rewards}?tab=arena',
    ),
    RouteContract(
      path: AuthRoutePaths.root,
      feature: 'auth',
      kind: RouteContractKind.redirectAlias,
      redirectTarget: HomeRoutePaths.home,
    ),
    RouteContract(
      path: P2PRoutePaths.p2pInsuranceFundAlias,
      name: P2PRouteNames.sc244P2PInsuranceFundAlias,
      screenId: P2PRouteNames.sc244P2PInsuranceFundAlias,
      feature: 'p2p',
      kind: RouteContractKind.redirectAlias,
      redirectTarget: P2PRoutePaths.p2pInsurance,
    ),
    RouteContract(
      path: ProfileRoutePaths.profilePredictions,
      name: ProfileRouteNames.sc167ProfilePredictions,
      screenId: ProfileRouteNames.sc167ProfilePredictions,
      feature: 'profile',
      kind: RouteContractKind.redirectAlias,
      redirectTarget: PredictionsRoutePaths.marketsPredictionsPortfolio,
    ),
    RouteContract(
      path: ProfileRoutePaths.profileArena,
      name: ProfileRouteNames.sc168MyArena,
      screenId: ProfileRouteNames.sc168MyArena,
      feature: 'profile',
      kind: RouteContractKind.redirectAlias,
      redirectTarget: ArenaRoutePaths.arenaMy,
    ),
    RouteContract(
      path: TradeRoutePaths.tradeCopyRegulatoryDisclosuresAlias,
      name: TradeRouteNames.sc412TradeCopyRegulatoryDisclosuresAlias,
      screenId: TradeRouteNames.sc412TradeCopyRegulatoryDisclosuresAlias,
      feature: 'trade',
      kind: RouteContractKind.redirectAlias,
      redirectTarget: TradeComplianceRoutePaths.tradeCopyRegulatoryDisclosures,
    ),
  ];
}
