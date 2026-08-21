import 'package:flutter/foundation.dart';

/// Semantic keys owned by the tablet Profile surface.
///
/// This contract intentionally lives in the tablet boundary so tablet widgets
/// never need to import the phone Profile page just to expose test hooks.
final class ProfileTabletKeys {
  const ProfileTabletKeys._();

  static const loading = Key('sc156_profile_loading');
  static const error = Key('sc156_profile_error');
  static const offline = Key('sc156_profile_offline');
  static const empty = Key('sc156_profile_empty');
  static const accountHero = Key('sc156_profile_account_hero');
  static const masterMenu = Key('sc156_profile_master_menu');
  static const heroPills = Key('sc156_profile_hero_pills');
  static const vipRunway = Key('sc156_profile_vip_runway');
  static const securityScore = Key('sc156_profile_security_score');
  static const copyReferral = Key('sc156_profile_copy_referral');
  static const editProfile = Key('sc156_profile_edit');
  static const logout = Key('sc156_profile_logout');
  static const predictionCard = Key('sc156_profile_prediction_card');
  static const arenaCard = Key('sc156_profile_arena_card');
  static const productHub = Key('sc156_profile_product_hub');
  static const kycBanner = Key('sc156_profile_kyc_banner');
  static const legalScaffold = Key('sc156_profile_legal_scaffold');
  static const legalSearch = Key('sc156_profile_legal_search');

  static Key productShortcut(String id) => Key('sc156_profile_product_$id');
  static Key menu(String id) => Key('sc156_profile_menu_$id');
  static Key legalGroup(String id) => Key('sc156_profile_legal_group_$id');
  static Key legalItem(String id) => Key('sc156_profile_legal_item_$id');
}
