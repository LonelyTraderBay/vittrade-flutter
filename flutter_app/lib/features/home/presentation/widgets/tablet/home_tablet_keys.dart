import 'package:flutter/foundation.dart';

/// Semantic keys owned by the tablet Home surface.
final class HomeTabletKeys {
  const HomeTabletKeys._();

  static const content = Key('sc007_home_scroll_content');
  static const header = Key('sc007_home_header');
  static const announcement = Key('sc007_home_announcement');
  static const portfolioCard = Key('sc007_home_portfolio_card');
  static const portfolioDeposit = Key('sc007_home_portfolio_deposit');
  static const nextAction = Key('sc007_home_next_action');
  static const marketTicker = Key('sc007_home_market_ticker');
  static const productsSection = Key('sc007_home_products_section');
  static const recentProducts = Key('sc007_home_recent_products');
  static const recentProductsSection = Key(
    'sc007_home_recent_products_section',
  );
  static const moreProductsSheet = Key('sc007_home_more_products_sheet');

  static Key recentProduct(String id) => Key('sc007_home_recent_$id');
}
