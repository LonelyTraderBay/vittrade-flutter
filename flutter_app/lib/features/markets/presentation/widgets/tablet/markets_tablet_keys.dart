import 'package:flutter/foundation.dart';

/// Semantic keys owned by the tablet Markets surface.
final class MarketsTabletKeys {
  const MarketsTabletKeys._();

  static const content = Key('sc008_markets_scroll_content');
  static const search = Key('sc008_markets_search');
  static const sortToggle = Key('sc008_markets_sort_toggle');

  static Key category(String category) => Key('sc008_category_$category');
  static Key pair(String id) => Key('sc008_pair_$id');
}
