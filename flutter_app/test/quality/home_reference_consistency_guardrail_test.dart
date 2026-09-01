// Origin: 3b6ecd0c (2026-07-07) - feat(flutter): bổ sung Home Reference Consistency Audit và tách spacing token theo từng module
// Guardrail này có lý do tồn tại riêng - đọc commit gốc ở trên trước khi nới lỏng hoặc xóa.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'home_reference_consistency_guardrail_test_utils.dart';

void main() {
  test('home reference consistency artifacts are current for all modules', () {
    final result = Process.runSync(dartExecutable(), [
      'run',
      'tool/home_reference_consistency_audit.dart',
      '--check',
    ]);

    expect(
      result.exitCode,
      0,
      reason:
          'stdout:\n${result.stdout}\n\nstderr:\n${result.stderr}\n'
          'Run `dart run tool/home_reference_consistency_audit.dart` from flutter_app/.',
    );
  });

  test('Home still consumes the shared widgets extracted from it', () {
    const expectations = <String, String>{
      // The home grid and the "more products" sheet both render a
      // HomeQuickAction as a VitServiceTile via the single shared
      // `buildHomeQuickActionTile` builder in home_formatters.dart (see the
      // needle below), rather than each duplicating an identical
      // `VitServiceTile.fromAction(...)` call inline. That builder is the
      // one and only place that still has to call the real factory, which
      // is asserted directly.
      'lib/features/home/presentation/widgets/phone/home_products_section.dart':
          'buildHomeQuickActionTile(',
      'lib/features/home/presentation/widgets/home_more_products_sheet.dart':
          'buildHomeQuickActionTile(',
      'lib/features/home/presentation/widgets/home_formatters.dart':
          'VitServiceTile.fromAction(',
      'lib/features/home/presentation/widgets/phone/home_portfolio_card.dart':
          'VitBalanceBreakdownRow(',
      'lib/features/home/presentation/phone/pages/home_page_sections.dart':
          'VitRiskDisclaimerNote(',
    };

    final violations = <String>[];
    expectations.forEach((path, needle) {
      final file = File(path);
      if (!file.existsSync()) {
        violations.add('$path: file missing');
        return;
      }
      final content = file.readAsStringSync();
      if (!content.contains(needle)) {
        violations.add(
          '$path: no longer references $needle — home silently re-forked '
          'a local copy instead of using the shared widget.',
        );
      }
    });

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test(
    'the three home-extracted shared widgets still exist and are exported',
    () {
      const widgetFiles = <String>[
        'lib/shared/widgets/vit_balance_breakdown_row.dart',
        'lib/shared/widgets/vit_risk_disclaimer_note.dart',
      ];
      for (final path in widgetFiles) {
        expect(File(path).existsSync(), isTrue, reason: 'Missing $path');
      }

      final serviceTileContent = File(
        'lib/shared/widgets/vit_module_components.dart',
      ).readAsStringSync();
      expect(
        serviceTileContent,
        contains('factory VitServiceTile.fromAction('),
        reason: 'VitServiceTile.fromAction factory was removed or renamed',
      );

      final barrelContent = File(
        'lib/shared/widgets/widgets.dart',
      ).readAsStringSync();
      expect(barrelContent, contains('vit_balance_breakdown_row.dart'));
      expect(barrelContent, contains('vit_risk_disclaimer_note.dart'));
    },
  );

  test('archetype reference pages (tabbed detail, form wizard) stay '
      'divergence-free and keep their defining structure', () {
    // Lightweight tripwire — NOT a full archetype-classification audit
    // (see docs/02_FLUTTER_MIGRATION/standards/Flutter-Page-Archetype-Standard.md
    // for why automatic classification was rejected). Reuses the exact
    // same 4 regexes as the home-reference divergence scan above, scoped
    // to just the two evidence-vetted canonical pages and their bundles.
    const tabbedDetailBundle = <String>[
      'lib/features/wallet/presentation/phone/pages/tools/wallet_token_approval_page.dart',
      'lib/features/wallet/presentation/widgets/tools/wallet_token_approval_badges.dart',
      'lib/features/wallet/presentation/widgets/tools/wallet_token_approval_tabs.dart',
      'lib/features/wallet/presentation/widgets/tools/wallet_token_revoke_sheet.dart',
      'lib/features/wallet/presentation/widgets/tools/wallet_token_approval_cards.dart',
      'lib/features/wallet/presentation/widgets/tools/wallet_token_approval_history_tab.dart',
      'lib/features/wallet/presentation/widgets/tools/wallet_token_active_approvals_tab.dart',
      'lib/features/wallet/presentation/widgets/tools/wallet_token_approval_settings_tab.dart',
      'lib/features/wallet/presentation/widgets/tools/wallet_token_approval_common.dart',
    ];
    const formWizardBundle = <String>[
      'lib/features/wallet/presentation/phone/pages/address_add_page.dart',
      'lib/features/wallet/presentation/widgets/address/wallet_address_add_form.dart',
      'lib/features/wallet/presentation/widgets/address/wallet_address_add_sections.dart',
      'lib/features/wallet/presentation/widgets/address/wallet_address_add_common.dart',
      'lib/features/wallet/presentation/widgets/address/wallet_address_add_preview.dart',
      'lib/features/wallet/presentation/widgets/address/wallet_address_add_agreement.dart',
      'lib/features/wallet/presentation/widgets/address/wallet_address_add_selectors.dart',
    ];

    final violations = <String>[];
    for (final path in [...tabbedDetailBundle, ...formWizardBundle]) {
      final file = File(path);
      if (!file.existsSync()) {
        violations.add('$path: file missing');
        continue;
      }
      final content = file.readAsStringSync();
      for (final line in content.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('//')) continue;
        if (containerPattern.hasMatch(trimmed) ||
            boxDecorationPattern.hasMatch(trimmed) ||
            borderRadiusPattern.hasMatch(trimmed) ||
            radiusPattern.hasMatch(trimmed)) {
          violations.add('$path: new raw markup -> $trimmed');
        }
      }
    }

    const structuralMarkers = <String, String>{
      'lib/features/wallet/presentation/phone/pages/tools/wallet_token_approval_page.dart':
          'WalletTokenApprovalTabs(',
      'lib/features/wallet/presentation/phone/pages/address_add_page.dart':
          'AddressAddForm.sections(',
    };
    structuralMarkers.forEach((path, needle) {
      final content = File(path).readAsStringSync();
      if (!content.contains(needle)) {
        violations.add(
          '$path: no longer references $needle — archetype reference '
          'page lost its defining structure.',
        );
      }
    });

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('sibling-card gap fixes for the 14-site card-gap audit stay applied', () {
    // Pinned tripwire (not a full audit) for the card-to-card gap sweep that
    // aligned all sibling-card lists/grids on AppSpacing.rowGap (8px) to
    // match lib/features/home/presentation's canonical pattern. See
    // needles as symbol-level substrings (not whole-line snippets) so a
    // `dart format` reflow doesn't spuriously break this test.
    const requiredNeedles = <String, List<String>>{
      'lib/features/trade_copy/presentation/phone/pages/provider/provider_leaderboard_page.dart':
          ['entry.\$1 != providers.length - 1', 'AppSpacing.rowGap'],
      'lib/app/theme/spacing/wallet_spacing_tokens.dart': [
        'walletManagerAllWalletGap = AppSpacing.rowGap',
        'walletTokenCardGap = AppSpacing.rowGap',
        'walletManagerGroupCardGap = AppSpacing.rowGap',
        'walletManagerActivityRowGap = AppSpacing.rowGap',
        'walletBuyPaymentCardGap = AppSpacing.rowGap',
      ],
      'lib/app/theme/spacing/trade_spacing_tokens.dart': [
        'preCopyAssessmentCtaGap = 12',
      ],
      'lib/features/trade_copy/presentation/phone/pages/flow/pre_copy_assessment_page.dart':
          [
            'question != snapshot.questions.last',
            'TradeSpacingTokens.preCopyAssessmentCtaGap',
          ],
      'lib/app/theme/spacing/p2p_spacing_tokens.dart': [
        'p2pPaymentMethodsListSectionGap = AppSpacing.rowGap',
      ],
      'lib/features/markets/presentation/phone/pages/research/token_unlocks_page.dart':
          ['_unlockListGap = AppSpacing.rowGap'],
      'lib/features/p2p_marketplace/presentation/phone/pages/ads/p2p_my_ads_page.dart':
          ['if (index > 0) const SizedBox(height: AppSpacing.rowGap)'],
      'lib/features/markets/presentation/widgets/research/market_news_page_sections.dart':
          ['item != news.last', 'SizedBox(height: AppSpacing.rowGap)'],
      'lib/features/profile/presentation/widgets/vip_history_widgets.dart': [
        'row != snapshot.history.last',
        'SizedBox(height: AppSurfaceSpacing.rowGap)',
      ],
      'lib/features/rewards/presentation/widgets/rewards_hub_hero_section.dart':
          ['width: AppSpacing.rowGap'],
    };
    const forbiddenNeedles = <String, List<String>>{
      'lib/features/rewards/presentation/widgets/rewards_hub_hero_section.dart':
          ['AppSpacing.cardTileInnerGap'],
    };

    final violations = <String>[];
    requiredNeedles.forEach((path, needles) {
      final file = File(path);
      if (!file.existsSync()) {
        violations.add('$path: file missing');
        return;
      }
      final content = file.readAsStringSync();
      for (final needle in needles) {
        if (!content.contains(needle)) {
          violations.add('$path: missing "$needle" — card-gap fix regressed');
        }
      }
    });
    forbiddenNeedles.forEach((path, needles) {
      final content = File(path).readAsStringSync();
      for (final needle in needles) {
        if (content.contains(needle)) {
          violations.add(
            '$path: still contains "$needle" — off-label token reintroduced',
          );
        }
      }
    });

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test(
    'AppSpacing.cardTileInnerGap is never used as a horizontal (width) gap '
    'between sibling tiles — reserved for the vertical gap inside one tile',
    () {
      // Generalizes the rewards/arena fix above: catches this exact
      // off-label-token bug pattern anywhere in lib/features, not just the
      // two known sites. cardTileInnerGap's doc comment reserves it for the
      // vertical icon→title→subtitle gap inside one tile.
      final violations = <String>[];
      for (final entity in Directory(
        'lib/features',
      ).listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = entity.path.replaceAll('\\', '/');
        for (final line in entity.readAsStringSync().split('\n')) {
          final trimmed = line.trim();
          if (trimmed.isEmpty || trimmed.startsWith('//')) continue;
          if (cardTileInnerGapWidthPattern.hasMatch(trimmed)) {
            violations.add('$path: $trimmed');
          }
        }
      }
      expect(violations, isEmpty, reason: violations.join('\n'));
    },
  );

  test('changed app files do not introduce new home-reference divergence', () {
    final changedFiles = collectChangedLibFiles();
    final violations = <String>[];

    for (final path in changedFiles) {
      final lower = path.toLowerCase();
      if (isPathException(lower)) continue;

      final isUntracked = !isTracked(path);
      final lines = collectAddedLines(path, isUntracked);
      for (final line in lines) {
        final reason = lineDivergenceReason(line);
        if (reason != null) {
          violations.add('$path: $reason -> $line');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
