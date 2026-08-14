import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('device-specific root UI stays in canonical presentation boundaries', () {
    const requiredFiles = <String>[
      'lib/features/home/presentation/phone/pages/home_page.dart',
      'lib/features/home/presentation/tablet/pages/home_tablet_page.dart',
      'lib/features/home/presentation/pages/responsive/home_responsive_entry.dart',
      'lib/features/home/presentation/widgets/tablet/home_tablet_reference_home.dart',
      'lib/features/home/presentation/widgets/tablet/home_tablet_keys.dart',
      'lib/features/markets/presentation/phone/pages/market_list_page.dart',
      'lib/features/markets/presentation/tablet/pages/markets_tablet_page.dart',
      'lib/features/markets/presentation/pages/responsive/markets_responsive_entry.dart',
      'lib/features/markets/presentation/widgets/tablet/markets_tablet_keys.dart',
      'lib/features/wallet/presentation/phone/pages/wallet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/wallet_tablet_page.dart',
      'lib/features/wallet/presentation/phone/pages/deposit_page.dart',
      'lib/features/wallet/presentation/phone/pages/withdraw_page.dart',
      'lib/features/wallet/presentation/phone/pages/transfer_page.dart',
      'lib/features/wallet/presentation/phone/pages/address_add_page.dart',
      'lib/features/wallet/presentation/phone/pages/address_book_page.dart',
      'lib/features/wallet/presentation/phone/pages/transaction_history_page.dart',
      'lib/features/wallet/presentation/phone/pages/transaction_detail_page.dart',
      'lib/features/wallet/presentation/phone/pages/pending_deposits_page.dart',
      'lib/features/wallet/presentation/tablet/pages/deposit_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/withdraw_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/transfer_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/address_add_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/address_book_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/asset_detail_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/buy_crypto_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/transaction_history_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/transaction_detail_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/pending_deposits_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/portfolio_analytics_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/wallet_multi_manager_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/wallet_gas_optimizer_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/wallet_health_score_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/wallet_token_approval_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/withdraw_limits_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/dust_converter_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/pages/network_status_tablet_page.dart',
      'lib/features/wallet/presentation/tablet/widgets/wallet_tablet_detail_surface.dart',
      'lib/features/wallet/presentation/pages/responsive/wallet_responsive_entry.dart',
      'lib/features/wallet/presentation/widgets/tablet/wallet_tablet_keys.dart',
      'lib/features/trade/presentation/phone/pages/trade_page.dart',
      'lib/features/trade/presentation/tablet/pages/trade_tablet_page.dart',
      'lib/features/trade/presentation/tablet/pages/trade_tablet_order_receipt_page.dart',
      'lib/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
      'lib/features/trade/presentation/pages/responsive/trade_responsive_entry.dart',
      'lib/features/trade/presentation/phone/pages/trade_page_state.dart',
      'lib/features/trade/presentation/widgets/tablet/trade_positions_panel.dart',
      'lib/features/trade/presentation/widgets/tablet/trade_tablet_keys.dart',
      'lib/features/profile/presentation/phone/pages/profile_page.dart',
      'lib/features/profile/presentation/tablet/pages/profile_tablet_page.dart',
      'lib/features/profile/presentation/tablet/pages/profile_tablet_utility_page.dart',
      'lib/features/profile/presentation/tablet/widgets/profile_tablet_utility_surface.dart',
      'lib/features/p2p_core/presentation/tablet/pages/p2p_tablet_utility_page.dart',
      'lib/features/p2p_core/presentation/tablet/widgets/p2p_tablet_utility_surface.dart',
      'lib/shared/layout/vit_tablet_utility_page.dart',
      'lib/features/profile/presentation/pages/responsive/profile_responsive_entry.dart',
      'lib/features/profile/presentation/phone/pages/profile_home_hero.dart',
      'lib/features/home/presentation/widgets/phone/home_header.dart',
      'lib/features/markets/presentation/widgets/phone/market_list_header.dart',
      'lib/features/wallet/presentation/widgets/phone/wallet_page_sections.dart',
      'lib/features/trade/presentation/phone/pages/order_receipt_page.dart',
      'lib/features/trade/presentation/widgets/phone/vit_trade_simple_order_form.dart',
      'lib/features/profile/presentation/widgets/common/profile_icon_registry.dart',
      'lib/features/profile/presentation/widgets/tablet/profile_hero_panel.dart',
      'lib/features/profile/presentation/widgets/tablet/profile_tablet_keys.dart',
      'lib/features/auth/presentation/phone/pages/login_page.dart',
      'lib/features/auth/presentation/phone/pages/register_page.dart',
      'lib/features/auth/presentation/phone/pages/otp_page.dart',
      'lib/features/auth/presentation/phone/pages/two_fa_setup_page.dart',
      'lib/features/auth/presentation/phone/pages/forgot_password_page.dart',
      'lib/features/auth/presentation/phone/pages/reset_password_page.dart',
      'lib/features/auth/presentation/tablet/pages/login_tablet_page.dart',
      'lib/features/auth/presentation/tablet/pages/register_tablet_page.dart',
      'lib/features/auth/presentation/tablet/pages/otp_tablet_page.dart',
      'lib/features/auth/presentation/tablet/pages/two_fa_setup_tablet_page.dart',
      'lib/features/auth/presentation/tablet/pages/forgot_password_tablet_page.dart',
      'lib/features/auth/presentation/tablet/pages/reset_password_tablet_page.dart',
    ];

    final missing = requiredFiles
        .where((path) => !File(path).existsSync())
        .toList(growable: false);

    expect(
      missing,
      isEmpty,
      reason: 'Thiếu file trong boundary UI phone/tablet chuẩn: $missing',
    );
  });

  test('legacy page paths remain export-only compatibility facades', () {
    const legacyFiles = <String>[
      'lib/features/home/presentation/pages/home_page.dart',
      'lib/features/home/presentation/pages/home_tablet_page.dart',
      'lib/features/home/presentation/pages/home_responsive_entry.dart',
      'lib/features/markets/presentation/pages/hub/market_list_page.dart',
      'lib/features/markets/presentation/pages/hub/markets_tablet_page.dart',
      'lib/features/markets/presentation/pages/hub/markets_responsive_entry.dart',
      'lib/features/wallet/presentation/pages/hub/wallet_page.dart',
      'lib/features/wallet/presentation/pages/hub/wallet_tablet_page.dart',
      'lib/features/wallet/presentation/pages/hub/wallet_responsive_entry.dart',
      'lib/features/trade/presentation/pages/hub/trade_page.dart',
      'lib/features/trade/presentation/pages/hub/trade_tablet_page.dart',
      'lib/features/trade/presentation/pages/hub/trade_responsive_entry.dart',
      'lib/features/profile/presentation/pages/profile_page.dart',
      'lib/features/profile/presentation/pages/profile_tablet_page.dart',
      'lib/features/profile/presentation/pages/profile_responsive_entry.dart',
      'lib/features/home/presentation/pages/phone/home_page.dart',
      'lib/features/home/presentation/pages/tablet/home_tablet_page.dart',
      'lib/features/markets/presentation/pages/phone/market_list_page.dart',
      'lib/features/markets/presentation/pages/tablet/markets_tablet_page.dart',
      'lib/features/wallet/presentation/pages/phone/wallet_page.dart',
      'lib/features/wallet/presentation/pages/tablet/wallet_tablet_page.dart',
      'lib/features/wallet/presentation/pages/transfer/deposit_page.dart',
      'lib/features/wallet/presentation/pages/transfer/withdraw_page.dart',
      'lib/features/wallet/presentation/pages/transfer/transfer_page.dart',
      'lib/features/wallet/presentation/pages/address/address_add_page.dart',
      'lib/features/wallet/presentation/pages/address/address_book_page.dart',
      'lib/features/wallet/presentation/pages/history/transaction_history_page.dart',
      'lib/features/wallet/presentation/pages/history/transaction_detail_page.dart',
      'lib/features/wallet/presentation/pages/transfer/pending_deposits_page.dart',
      'lib/features/trade/presentation/pages/phone/trade_page.dart',
      'lib/features/trade/presentation/pages/phone/order_receipt_page.dart',
      'lib/features/trade/presentation/pages/tablet/trade_tablet_page.dart',
      'lib/features/trade/presentation/pages/tablet/trade_tablet_order_receipt_page.dart',
      'lib/features/profile/presentation/pages/phone/profile_page.dart',
      'lib/features/profile/presentation/pages/tablet/profile_tablet_page.dart',
      'lib/features/auth/presentation/pages/login_page.dart',
      'lib/features/auth/presentation/pages/register_page.dart',
      'lib/features/auth/presentation/pages/otp_page.dart',
      'lib/features/auth/presentation/pages/two_fa_setup_page.dart',
      'lib/features/auth/presentation/pages/forgot_password_page.dart',
      'lib/features/auth/presentation/pages/reset_password_page.dart',
    ];

    final violations = <String>[];
    for (final path in legacyFiles) {
      final file = File(path);
      if (!file.existsSync()) {
        violations.add('$path: thiếu compatibility facade');
        continue;
      }
      final content = file.readAsStringSync();
      if (!content.contains('export ') || content.contains('class ')) {
        violations.add('$path: facade chứa logic UI thay vì chỉ export');
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('tablet UI never imports phone or legacy feature UI', () {
    const features = <String>[
      'home',
      'markets',
      'wallet',
      'trade',
      'profile',
      'auth',
    ];
    final violations = <String>[];

    for (final feature in features) {
      final roots = <String>[
        'lib/features/$feature/presentation/tablet/pages',
        'lib/features/$feature/presentation/widgets/tablet',
      ];
      final forbidden = <String>[
        'features/$feature/presentation/phone/',
        'features/$feature/presentation/pages/hub/',
        'features/$feature/presentation/widgets/hub/',
        'features/$feature/presentation/widgets/profile_icon_registry.dart',
      ];
      final phoneClasses = <String>[
        'HomePage.',
        'MarketListPage.',
        'WalletPage.',
        'TradePage.',
        'ProfilePage.',
      ];

      for (final root in roots) {
        final directory = Directory(root);
        if (!directory.existsSync()) continue;
        final files = directory
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'));
        for (final file in files) {
          final content = file.readAsStringSync();
          final forbiddenImport = forbidden.firstWhere(
            content.contains,
            orElse: () => '',
          );
          final forbiddenClass = phoneClasses.firstWhere(
            content.contains,
            orElse: () => '',
          );
          if (forbiddenImport.isNotEmpty) {
            violations.add('${file.path}: import UI legacy "$forbiddenImport"');
          }
          if (forbiddenClass.isNotEmpty) {
            violations.add(
              '${file.path}: tham chiếu class Phone "$forbiddenClass"',
            );
          }
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('phone UI never imports tablet or legacy feature UI', () {
    const features = <String>[
      'home',
      'markets',
      'wallet',
      'trade',
      'profile',
      'auth',
    ];
    final violations = <String>[];

    for (final feature in features) {
      final roots = <String>[
        'lib/features/$feature/presentation/phone/pages',
        'lib/features/$feature/presentation/widgets/phone',
      ];
      final forbidden = <String>[
        'features/$feature/presentation/tablet/',
        'features/$feature/presentation/widgets/tablet/',
        'features/$feature/presentation/pages/hub/',
        'features/$feature/presentation/widgets/hub/',
      ];

      for (final root in roots) {
        final directory = Directory(root);
        if (!directory.existsSync()) continue;
        final files = directory
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'));
        for (final file in files) {
          final content = file.readAsStringSync();
          final forbiddenImport = forbidden.firstWhere(
            content.contains,
            orElse: () => '',
          );
          if (forbiddenImport.isNotEmpty) {
            violations.add(
              '${file.path}: import UI ngoài Phone "$forbiddenImport"',
            );
          }
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
