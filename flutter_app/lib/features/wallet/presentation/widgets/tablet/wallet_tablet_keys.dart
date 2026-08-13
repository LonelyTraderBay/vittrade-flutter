import 'package:flutter/foundation.dart';

/// Semantic keys owned by the tablet Wallet surface.
final class WalletTabletKeys {
  const WalletTabletKeys._();

  static const content = Key('sc135_wallet_content');
  static const balanceToggle = Key('sc135_wallet_balance_toggle');
  static const moreActions = Key('sc135_wallet_more_actions');
  static const moreActionsSheet = Key('sc135_wallet_more_actions_sheet');
  static const search = Key('sc135_wallet_search');
  static const filter = Key('sc135_wallet_filter');

  static Key action(String id) => Key('sc135_wallet_action_$id');
  static Key tab(String id) => Key('sc135_wallet_tab_$id');
  static Key asset(String id) => Key('sc135_wallet_asset_$id');
}
