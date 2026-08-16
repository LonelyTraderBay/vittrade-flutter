import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('P2P security and compliance mutations require preview confirmation', () {
    const paths = <String>[
      'lib/features/p2p_security/presentation/phone/pages/security/'
          'p2p_anti_phishing_code_page.dart',
      'lib/features/p2p_security/presentation/phone/pages/security/'
          'p2p_blacklist_add_page.dart',
      'lib/features/p2p_security/presentation/phone/pages/security/'
          'p2p_source_of_funds_page.dart',
      'lib/features/p2p_security/presentation/phone/pages/security/'
          'p2p_large_transaction_justification_page.dart',
      'lib/features/p2p_security/presentation/phone/pages/security/'
          'p2p_report_merchant_page.dart',
    ];

    final violations = <String>[];
    for (final path in paths) {
      final file = File(path);
      if (!file.existsSync()) {
        violations.add('$path: thiếu security flow file');
        continue;
      }

      final content = file.readAsStringSync();
      for (final requirement in const [
        'showVitConfirmDialog(',
        'confirmKey',
        'cancelKey',
        'if (!mounted || !confirmed) return;',
      ]) {
        if (!content.contains(requirement)) {
          violations.add('$path: thiếu $requirement');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'P2P security/compliance mutation phải preview + confirm trước khi áp dụng: '
          '$violations',
    );
  });
}
