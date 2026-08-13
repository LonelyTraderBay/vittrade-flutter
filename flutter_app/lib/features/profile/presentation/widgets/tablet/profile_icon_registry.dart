import 'package:flutter/material.dart';

/// Shared icon-key -> [IconData] registry for the profile module.
///
/// Profile domain models (menu shortcuts, security items, settings rows)
/// reference icons by a short string key (e.g. `'shield'`, `'phone'`) so
/// fixtures/API payloads stay presentation-agnostic. This is the single
/// place that maps those keys to concrete Material icons across every
/// profile page — home menu, security, and settings all resolve through
/// this one switch instead of keeping their own partial copies.
IconData profileIconFor(String key) {
  return switch (key) {
    'shield-check' => Icons.verified_user_outlined,
    'wallet' => Icons.account_balance_wallet_outlined,
    'shield' => Icons.shield_outlined,
    'crown' => Icons.workspace_premium_outlined,
    'bell' => Icons.notifications_none_rounded,
    'key' => Icons.key_rounded,
    'phone' => Icons.phone_android_rounded,
    'users' => Icons.groups_outlined,
    'clipboard' => Icons.assignment_outlined,
    'globe' => Icons.language_rounded,
    'settings' => Icons.settings_outlined,
    'rotate' => Icons.history_rounded,
    'message' => Icons.chat_bubble_outline_rounded,
    'compass' => Icons.explore_outlined,
    'trophy' => Icons.emoji_events_outlined,
    'refresh' => Icons.sync_rounded,
    'rocket' => Icons.rocket_launch_outlined,
    'copy' => Icons.content_copy_rounded,
    'zap' => Icons.bolt_rounded,
    'bot' => Icons.smart_toy_outlined,
    'help' => Icons.help_outline_rounded,
    'file' => Icons.article_outlined,
    'star' => Icons.star_border_rounded,
    'laptop' => Icons.laptop_mac_rounded,
    'activity' => Icons.monitor_heart_outlined,
    _ => Icons.circle_outlined,
  };
}
