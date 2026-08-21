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

  // KYC detail pane (SC-159 tablet port).
  static const kycPane = Key('sc159_kyc_pane');
  static const kycPaneError = Key('sc159_kyc_pane_error');
  static const kycStatusCard = Key('sc159_kyc_pane_status_card');
  static const kycPrivacyCard = Key('sc159_kyc_pane_privacy_card');

  static Key kycLevel(int level) => Key('sc159_kyc_pane_level_$level');

  static Key kycStart(int level) => Key('sc159_kyc_pane_start_$level');

  // Security detail pane (SC-158 tablet port).
  static const securityPane = Key('sc158_security_pane');
  static const securityPaneError = Key('sc158_security_pane_error');
  static const securityPaneScore = Key('sc158_security_pane_score');
  static const securityAntiPhishingField = Key(
    'sc158_security_pane_anti_phishing_field',
  );
  static const securityAntiPhishingSave = Key(
    'sc158_security_pane_anti_phishing_save',
  );
  static const securityAntiPhishingConfirm = Key(
    'sc158_security_pane_anti_phishing_confirm',
  );
  static const securityAntiPhishingCancel = Key(
    'sc158_security_pane_anti_phishing_cancel',
  );
  static const securitySupport = Key('sc158_security_pane_support');

  static Key securityItem(String id) => Key('sc158_security_pane_item_$id');

  static Key productShortcut(String id) => Key('sc156_profile_product_$id');
  static Key menu(String id) => Key('sc156_profile_menu_$id');
  static Key legalGroup(String id) => Key('sc156_profile_legal_group_$id');
  static Key legalItem(String id) => Key('sc156_profile_legal_item_$id');
}
