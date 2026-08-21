import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('device-specific root UI stays in canonical presentation boundaries', () {
    const requiredFiles = <String>[
      'lib/features/home/presentation/phone/pages/home_page.dart',
      'lib/features/home/presentation/tablet/pages/home_tablet_page.dart',
      'lib/features/home/presentation/web/pages/home_web_page.dart',
      'lib/features/home/presentation/widgets/tablet/home_tablet_reference_home.dart',
      'lib/features/home/presentation/widgets/tablet/home_tablet_keys.dart',
      'lib/features/markets/presentation/phone/pages/market_list_page.dart',
      'lib/features/markets/presentation/tablet/pages/markets_tablet_page.dart',
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
      'lib/features/wallet/presentation/widgets/tablet/wallet_tablet_keys.dart',
      'lib/features/trade/presentation/phone/pages/trade_page.dart',
      'lib/features/trade/presentation/tablet/pages/trade_tablet_page.dart',
      'lib/features/trade/presentation/tablet/pages/trade_tablet_order_receipt_page.dart',
      'lib/features/trade/presentation/tablet/pages/trade_tablet_utility_page.dart',
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
      'lib/features/profile/presentation/phone/pages/profile_home_hero.dart',
      'lib/features/home/presentation/widgets/phone/home_header.dart',
      'lib/features/markets/presentation/widgets/phone/market_list_header.dart',
      'lib/features/wallet/presentation/widgets/phone/wallet_page_sections.dart',
      'lib/features/trade/presentation/phone/pages/order_receipt_page.dart',
      'lib/features/trade/presentation/widgets/phone/vit_trade_simple_order_form.dart',
      'lib/features/profile/presentation/widgets/common/profile_icon_registry.dart',
      'lib/features/profile/presentation/widgets/tablet/profile_account_hero.dart',
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
      'lib/features/auth/presentation/web/pages/auth_web_page.dart',
      'lib/shared/layout/vit_web_utility_page.dart',
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

  test(
    'legacy shared pages/widgets tree stays empty (phone migration ratchet)',
    () {
      // Phone-surface migration (2026-08-16) moved every legacy
      // `presentation/pages/**` file into `presentation/phone/pages/**`
      // (plus `presentation/tablet|web/pages/**` for the surface facades) and
      // `presentation/widgets/hub/**` into `presentation/widgets/phone/**`.
      // Both legacy locations must stay at zero — new screens belong in the
      // per-surface trees.
      final violations = <String>[];
      for (final feature in Directory(
        'lib/features',
      ).listSync().whereType<Directory>()) {
        final legacyPages = Directory('${feature.path}/presentation/pages');
        if (legacyPages.existsSync()) {
          violations.add('${feature.path}\\presentation\\pages');
        }
        final legacyHubWidgets = Directory(
          '${feature.path}/presentation/widgets/hub',
        );
        if (legacyHubWidgets.existsSync()) {
          violations.add('${feature.path}\\presentation\\widgets\\hub');
        }
      }

      expect(
        violations,
        isEmpty,
        reason:
            'Legacy presentation/pages|widgets/hub đã bị xóa sau Phone-surface '
            'migration — thêm screen mới vào presentation/phone/pages: $violations',
      );
    },
  );

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

  test('web UI never imports phone or tablet feature UI', () {
    const features = <String>['home', 'auth'];
    final violations = <String>[];

    for (final feature in features) {
      final root = Directory('lib/features/$feature/presentation/web');
      if (!root.existsSync()) continue;
      final files = root
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));
      for (final file in files) {
        final content = file.readAsStringSync();
        const forbidden = <String>[
          'presentation/phone/',
          'presentation/tablet/',
          'presentation/pages/phone/',
          'presentation/pages/tablet/',
          'presentation/pages/hub/',
          'presentation/widgets/hub/',
        ];
        for (final token in forbidden) {
          if (content.contains(token)) {
            violations.add('${file.path}: import UI ngoài Web "$token"');
          }
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
