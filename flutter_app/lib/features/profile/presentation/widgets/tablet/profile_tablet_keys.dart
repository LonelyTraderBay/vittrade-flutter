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

  // VIP detail pane (SC-164 tablet port).
  static const vipPane = Key('sc164_vip_pane');
  static const vipPaneError = Key('sc164_vip_pane_error');
  static const vipTradeCta = Key('sc164_vip_pane_trade_cta');

  static Key vipTab(String id) => Key('sc164_vip_pane_tab_$id');

  static Key vipTier(int level) => Key('sc164_vip_pane_tier_$level');

  static Key productShortcut(String id) => Key('sc156_profile_product_$id');
  static Key menu(String id) => Key('sc156_profile_menu_$id');
  static Key legalGroup(String id) => Key('sc156_profile_legal_group_$id');
  static Key legalItem(String id) => Key('sc156_profile_legal_item_$id');

  // Settings detail pane (SC-160 tablet port).
  static const settingsPane = Key('sc160_settings_pane');
  static const settingsPaneError = Key('sc160_settings_pane_error');
  static const settingsAppInfo = Key('sc160_settings_pane_app_info');

  static Key settingsCurrency(String currency) =>
      Key('sc160_settings_pane_currency_$currency');

  static Key settingsLanguage(String id) =>
      Key('sc160_settings_pane_language_$id');

  static Key settingsToggle(String id) => Key('sc160_settings_pane_toggle_$id');

  // Activity log detail pane (SC-161 tablet port).
  static const activityPane = Key('sc161_activity_pane');
  static const activityPaneError = Key('sc161_activity_pane_error');
  static const activityWarning = Key('sc161_activity_pane_warning');

  static Key activityFilter(String id) => Key('sc161_activity_pane_filter_$id');

  static Key activityLog(String id) => Key('sc161_activity_pane_log_$id');

  // Devices detail pane (SC-165 tablet port).
  static const devicesPane = Key('sc165_devices_pane');
  static const devicesPaneError = Key('sc165_devices_pane_error');
  static const devicesSummary = Key('sc165_devices_pane_summary');
  static const devicesLogoutAll = Key('sc165_devices_pane_logout_all');
  static const devicesLogoutConfirm = Key('sc165_devices_pane_logout_confirm');
  static const devicesLogoutCancel = Key('sc165_devices_pane_logout_cancel');

  static Key deviceCard(String id) => Key('sc165_devices_pane_card_$id');

  static Key deviceTrust(String id) => Key('sc165_devices_pane_trust_$id');

  static Key deviceLogout(String id) => Key('sc165_devices_pane_logout_$id');
}
