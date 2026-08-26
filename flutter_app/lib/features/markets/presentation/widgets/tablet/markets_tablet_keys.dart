import 'package:flutter/foundation.dart';

/// Semantic keys owned by the tablet Markets surface.
final class MarketsTabletKeys {
  const MarketsTabletKeys._();

  static const content = Key('sc008_markets_scroll_content');
  static const search = Key('sc008_markets_search');
  static const sortToggle = Key('sc008_markets_sort_toggle');
  static const pulseStrip = Key('sc008_markets_pulse_strip');
  static const masterList = Key('sc008_markets_master_list');
  static const watchlistEmpty = Key('sc008_markets_watchlist_empty');
  static const pairPaneContent = Key('sc044_pair_pane_content');
  static const pairPaneChart = Key('sc044_pair_pane_chart');
  static const pairPaneBuyCta = Key('sc044_pair_pane_buy_cta');
  static const pairPaneSellCta = Key('sc044_pair_pane_sell_cta');
  static const pairPaneFavorite = Key('sc044_pair_pane_favorite');
  static const tokenPaneContent = Key('sc045_token_pane_content');
  static const tokenStatsCard = Key('sc045_token_pane_stats_card');
  static const tokenChartLink = Key('sc045_token_pane_chart_link');
  static const depthPaneContent = Key('sc046_depth_pane_content');

  static Key category(String category) => Key('sc008_category_$category');
  static Key pair(String id) => Key('sc008_pair_$id');
  static Key sortColumn(String columnId) => Key('sc008_sort_$columnId');
  static Key pairViewTab(String viewKey) => Key('sc044_pair_view_$viewKey');
  static Key tokenTab(String tabKey) => Key('sc045_token_tab_$tabKey');
}
